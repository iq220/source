-- The CreateContractActionFromIngressQueue procedure calls this procedure.
-- We ensure that this procedure is written to the schema before CreateContractActionFromIngressQueue.sql
-- by prefixing a sequence number (here 04) to the name of this file (here CreateContractAction).
CREATE PROCEDURE [dbo].[CreateContractAction]
    @ContractId INT,
	@UserId INT,
	@WorkflowFunctionId INT,
    @RequestId NVARCHAR(50),
    @ContractActionParameters [dbo].[udtt_ContractActionParameter] READONLY
AS
BEGIN
	DECLARE @ErrorMessage NVARCHAR(255)

    -- Workflow provisioning status enum is as follows:
    -- 0: Provisioned in the database at the API level, but doesn't have an address associated with it
    -- 1: Successfully calculated the projected address and sent a transaction, but we are still waiting for the transaction to be mined
    -- 2: Transaction has been mined and the contract is fully provisioned on-chain
	SET NOCOUNT ON;
	
    -- Select valid contract action based on user and Next state
    DECLARE @instanceWorkflowId INT
    SELECT @instanceWorkflowId = [WorkflowId] FROM [dbo].[Contract] WHERE [Id] = @ContractId
    IF @instanceWorkflowId IS NULL
    BEGIN
       	-- @ContractId not found
         SET @ErrorMessage = 'Contract ID ' + CAST(@ContractId AS nvarchar) +' not found.'
       	; THROW 55200, @Errormessage, 0;
    END

	DECLARE @functionWorkflowId INT
	SELECT @functionWorkflowId = [WorkflowId] FROM [dbo].[WorkflowFunction] WHERE [Id] = @WorkflowFunctionId
    IF @functionWorkflowId IS NULL
    BEGIN
       	-- @WorkflowFunctionId not found
         SET @ErrorMessage = 'Workflow function ID ' + CAST(@WorkflowFunctionId AS nvarchar) +' not found.'
       	; THROW 55200, @Errormessage, 0;
    END

	IF @instanceWorkflowId <> @functionWorkflowId
	BEGIN
        -- Mismatch between workflow id corresponding to @ContractId and @WorkflowFunctionId
        SET @ErrorMessage = 'Workflow ID does not match.';
        THROW 55200, @Errormessage, 0;
	END
	
	---- Test authorized action ----
	DECLARE @authorizedActions [dbo].[udtt_Ids]
	INSERT INTO @authorizedActions
	EXEC [dbo].[GetAuthorizedContractActions] @ContractId, @UserId

	IF (SELECT [Id] FROM @authorizedActions WHERE [Id] = @WorkflowFunctionId) IS NULL
	BEGIN
        -- Each transition for which @UserId is authorized is labeled with a function different from @WorkflowFunctionId
        SET @ErrorMessage = 'User ' + CAST(@UserId AS nvarchar) +' is not authorized to take this action.'
        ; THROW 55200, @Errormessage, 0;
	END

  -- The next set of steps for adding an entry into the contract action table and the contract action parameters table happen in one transaction
   BEGIN TRY
        --  -----------------------------------------------------
        BEGIN TRANSACTION
        --  -----------------------------------------------------

        -- obtain the contract's connection id
        DECLARE @ConnectionId INT
        SELECT @ConnectionId = [ConnectionId]
        FROM [dbo].[Contract]
        WHERE [Id] = @ContractId

        -- Make sure [NextSequenceNumber] is initialized correctly.
        UPDATE [dbo].[UserChainMapping] 
            SET [NextSequenceNumber] = COALESCE([NextSequenceNumber], 0)
            WHERE [UserID] = @UserId AND [ConnectionID] = @ConnectionId

        -- obtain the next sequence number in the UserChainMapping table, and increment it atomically
        DECLARE @ContractActionNextSequenceNumber INT
        UPDATE [dbo].[UserChainMapping] 
            SET [NextSequenceNumber] = [NextSequenceNumber] + 1,
                @ContractActionNextSequenceNumber = [NextSequenceNumber]	
            WHERE [UserID] = @UserId AND [ConnectionID] = @ConnectionId

        -- add the sequence number to the action
        -- set the last sweep time to be the creation time
        INSERT INTO [dbo].[ContractAction] ([ContractId], [UserId], [ProvisioningStatus], [Timestamp], [WorkflowFunctionId], [SequenceNumber], [LastSweepTimestamp], [RequestId])
        VALUES (@ContractId, @UserId, 0, GETUTCDATE(), @WorkflowFunctionId, @ContractActionNextSequenceNumber, GETUTCDATE(), @RequestId)

        DECLARE @NewId INT
        SELECT @NewId = SCOPE_IDENTITY()

        INSERT INTO [dbo].[ContractActionParameter]
        (
            [ContractActionId],
            [WorkflowFunctionParameterId],
            [Value]
        )
        SELECT 
                @NewId
                ,wffp.[Id]
                ,wfiap.[Value]
        FROM @ContractActionParameters wfiap
            INNER JOIN [dbo].[WorkflowFunctionParameter] wffp
        ON wffp.[Name] = wfiap.[Name]
        WHERE Wffp.[WorkflowFunctionId] = @WorkflowFunctionId

        SELECT @ConnectionId = [ConnectionId]
        FROM [dbo].[Contract]
        WHERE [Id] = @ContractId
        
        DECLARE @ArtifactBlobStorageURL NVARCHAR(255)
        SELECT @ArtifactBlobStorageURL = [ArtifactBlobStorageURL]
        FROM [dbo].[ContractCode] AS li
        INNER JOIN [dbo].[Contract] AS wfi ON wfi.[ContractCodeId] = li.[Id]
        WHERE wfi.[Id] = @ContractId

        DECLARE @UserChainIdentifier NVARCHAR(255)
        SELECT @UserChainIdentifier = [ChainIdentifier]
        FROM [dbo].[UserChainMapping]
        WHERE [UserID] = @UserID AND [ConnectionID] = @ConnectionId

        DECLARE @WorkflowFunctionName NVARCHAR(50)
        SELECT @WorkflowFunctionName = [Name]
            FROM [dbo].[WorkflowFunction]
            WHERE [Id] = @WorkflowFunctionId

        DECLARE @LedgerIdentifier NVARCHAR(255)
        SELECT @LedgerIdentifier = [LedgerIdentifier]
        FROM [dbo].[Contract]
        WHERE [Id] = @ContractId

        DECLARE @WorkflowName NVARCHAR(50)
        SELECT @WorkflowName = [Name]
        FROM [dbo].[Workflow] AS wf
        INNER JOIN [dbo].[Contract] AS wfi ON wfi.[WorkflowId] = wf.[Id]
        WHERE wfi.[Id] = @ContractId

        SELECT 
            @NewId AS [NewID],
            @ConnectionId AS [ConnectionId],
            @ArtifactBlobStorageURL AS [WorkflowImplementationPath],
            @UserChainIdentifier AS [UserChainIdentifier],
            @WorkflowFunctionName AS [WorkflowFunctionName],
            @LedgerIdentifier AS [LedgerIdentifier],
            @WorkflowName AS [WorkflowName],
            @ContractActionNextSequenceNumber AS [SequenceNumber]

        --  -----------------------------------------------------
        COMMIT TRANSACTION
        --  -----------------------------------------------------

    END TRY

    BEGIN CATCH

        ROLLBACK TRANSACTION;
        THROW;

    END CATCH
END
