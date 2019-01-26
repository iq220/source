-- The CreateContractFromIngressQueue procedure calls this procedure.
-- We ensure that this procedure is written to the schema before CreateContractFromIngressQueue.sql
-- by prefixing a sequence number (here 03) to the name of this file (here CreateContract).
CREATE PROCEDURE [dbo].[CreateContract]
    @WorkflowId INT,
    @ContractCodeId INT,
	@ConnectionId INT,
    @UserId INT,
	@RequestId NVARCHAR(50),
	@ContractActionParameters [dbo].[udtt_ContractActionParameter] READONLY
AS
BEGIN
BEGIN TRY
	BEGIN TRANSACTION

    SET NOCOUNT ON
	DECLARE @ErrorMessage NVARCHAR(255)

	DECLARE @initiators INT = 
	(
		SELECT COUNT(wfi.[Id])
		FROM [dbo].[WorkflowInitiator] wfi
		INNER JOIN [dbo].[RoleAssignment] urm ON urm.[ApplicationRoleId] = wfi.[ApplicationRoleId]
		INNER JOIN [dbo].[User] u ON u.[Id] = urm.[UserId]
		WHERE wfi.[WorkflowId] = @WorkflowId AND u.[Id] = @UserId
	)

	IF @initiators = 0
	BEGIN
		-- initiators not found
    SET @ErrorMessage = 'User unauthorized to create contract.'
		; THROW 55200, @Errormessage, 0;
	END

	DECLARE @ledgerIdCheck INT
	SELECT @ledgerIdCheck = li.[Id]
	FROM [dbo].[ContractCode] AS li
	INNER JOIN [dbo].[Workflow] AS w ON w.[ApplicationId] = li.[ApplicationId]
	INNER JOIN [dbo].[Connection] AS c ON c.[LedgerId] = li.[LedgerId]
	WHERE w.[Id] = @WorkflowId AND li.[Id] = @ContractCodeId AND c.[Id] = @ConnectionId

	IF (@ledgerIdCheck IS NULL)
	BEGIN
		-- inconsistent parameters
    SET @ErrorMessage = 'Inconsistent parameters provided during contract creation. Ledger ID corresponding to the input parameters does not exist.'
		; THROW 55200, @Errormessage, 0;
	END

	-- Workflow provisioning status enum is as follows:
    -- 0: Provisioned in the database at the API level, but doesn't have an address associated with it
    -- 1: Successfully calculated the projected address and sent a transaction, but we are still waiting for the transaction to be mined
    -- 2: Transaction has been mined and the contract is fully provisioned on-chain
	DECLARE @ArtifactBlobStorageURL NVARCHAR(255)
	SELECT @ArtifactBlobStorageURL = [ArtifactBlobStorageURL]
    FROM [dbo].[ContractCode]
    WHERE [Id] = @ContractCodeId

	DECLARE @WorkflowName NVARCHAR(50)
	SELECT @WorkflowName = [Name]
	FROM [dbo].[Workflow]
	WHERE [Id] = @WorkflowId

	DECLARE @UserChainIdentifier NVARCHAR(255)
	SELECT @UserChainIdentifier = [ChainIdentifier]
	FROM [dbo].[UserChainMapping]
	WHERE [UserId] = @UserId
	
	INSERT INTO [dbo].[Contract] ([ProvisioningStatus],[Timestamp],[ConnectionId],[WorkflowId],[ContractCodeId],[DeployedByUserId])
        VALUES (NULL,GETUTCDATE(), @ConnectionID, @WorkflowID, @ContractCodeId, @UserId)
	
	DECLARE @ContractId INT
	SELECT @ContractId = SCOPE_IDENTITY()

	DECLARE @WorkflowFunctionId INT
	SELECT @WorkflowFunctionId = [Id]
	FROM [dbo].[WorkflowFunction]
	WHERE [Name] = '' AND [WorkflowId] = @WorkflowId

    -- Make sure [NextSequenceNumber] is initialized correctly.
    UPDATE [dbo].[UserChainMapping] 
          SET [NextSequenceNumber] = COALESCE([NextSequenceNumber], 0)
          WHERE [UserID] = @UserId AND [ConnectionID] = @ConnectionId

    -- obtain the next sequence number in the user UserChainMapping, and increment it atomically
	DECLARE @ContractActionNextSequenceNumber INT
  	UPDATE [dbo].[UserChainMapping] 
          SET [NextSequenceNumber] = [NextSequenceNumber] + 1,
			@ContractActionNextSequenceNumber = [NextSequenceNumber]	
          WHERE [UserID] = @UserId AND [ConnectionID] = @ConnectionId

	INSERT INTO [dbo].[ContractAction] ([ContractId], [UserId], [ProvisioningStatus], [Timestamp], [WorkflowFunctionId], [SequenceNumber], [LastSweepTimestamp], [RequestId])
    VALUES (@ContractId, @UserId, 0, GETUTCDATE(), @WorkflowFunctionId, @ContractActionNextSequenceNumber, GETUTCDATE(), @RequestId)

    DECLARE @ContractActionId INT
    SELECT @ContractActionId = SCOPE_IDENTITY()

    INSERT INTO [dbo].[ContractActionParameter]
    (
        [ContractActionId],
        [WorkflowFunctionParameterId],
        [Value]
    )
    SELECT
            @ContractActionId
            ,wffp.[Id]
            ,wfiap.[Value]
    FROM @ContractActionParameters wfiap
        INNER JOIN [dbo].[WorkflowFunctionParameter] wffp
    ON wffp.[Name] = wfiap.[Name]
    WHERE Wffp.[WorkflowFunctionId] = @WorkflowFunctionId

	SELECT
		@ContractId AS [NewID],
		@ContractActionId AS [NewActionID],
        @ArtifactBlobStorageURL AS [WorkflowImplementationPath],
        @UserChainIdentifier AS [UserChainIdentifier],
        @WorkflowName AS [WorkflowName],
        @ContractActionNextSequenceNumber AS [SequenceNumber]
	COMMIT TRANSACTION
	
END TRY

BEGIN CATCH
    ROLLBACK TRANSACTION;
    THROW;
END CATCH
END
