CREATE PROCEDURE [dbo].[GetContract]
    @ContractId INT,
    @UserId INT,
    @IsAdmin BIT
AS
BEGIN
BEGIN TRY
    BEGIN TRANSACTION

    SET NOCOUNT ON;

    DECLARE @ErrorMessage NVARCHAR(255)

    DECLARE @WorkflowId INT
    SELECT @WorkflowId = [WorkflowId] FROM [dbo].[Contract] WHERE [Id] = @ContractId

    IF @WorkflowId IS NULL
    BEGIN
        -- @ContractId not found
    SET @Errormessage = 'Contract Id ' + CAST(@ContractId AS NVARCHAR) + ' not found.';
    THROW 55100, @Errormessage, 0;
    END

    DECLARE @ApplicationId INT
    SELECT @ApplicationId = [ApplicationId] FROM [dbo].[Workflow] WHERE [Id] = @WorkflowId

    IF @IsAdmin = 0
    BEGIN
        DECLARE @Status [dbo].[udtt_Ids]
        INSERT INTO @Status 
        EXEC [dbo].[IsApplicationAccessibleByUser] @ApplicationId, @UserId

        IF (SELECT [Id] FROM @Status) = 0
        BEGIN
            -- @UserId not authorized to access contracts in @ApplicationId
      SET @ErrorMessage = 'User ' + CAST(@UserId AS nvarchar) +' is not authorized to take this action.';
            THROW 55100, @Errormessage, 0;
        END
    END

    -- Select contract
    SELECT
        wfi.[Id],
        CASE
            WHEN wfi.[ProvisioningStatus] IS NOT NULL THEN wfi.[ProvisioningStatus]
            WHEN cca.ProvisioningStatus IS NULL THEN 2
            ELSE cca.ProvisioningStatus
        End as ProvisioningStatus,
        wfi.[Timestamp],
        wfi.[ConnectionId],
        wfi.[LedgerIdentifier],
        wfi.[DeployedByUserId],
        wfi.[WorkflowId],
        cca.[RequestId],
        wfi.[ContractCodeId]
    FROM [dbo].[Contract] AS wfi
    Left Outer Join 
    (select
        ca.[ProvisioningStatus] as ProvisioningStatus,
        ca.[ContractId] as ContractId,
        ca.[RequestId] as RequestId
     from [dbo].[ContractAction] as ca 
     inner join [dbo].[WorkflowFunction] as wff on wff.[Id] = ca.WorkflowFunctionId AND wff.[Name] = '') cca
     on cca.ContractId = wfi.[Id]
     WHERE @ContractId = wfi.[Id]

    -- Select contract properties
    DECLARE @MaxBlockNumber INT
    SELECT @MaxBlockNumber = max([BlockNumber]) 
    FROM
    (
        SELECT b.[BlockNumber]
        FROM [ContractProperty] as wfip
        INNER JOIN [Block] as b ON b.[Id] = wfip.[BlockId]
        WHERE @ContractId = wfip.[ContractId]
    ) AS _

    SELECT [WorkflowPropertyId], [Value]
    FROM [ContractProperty] as wfip
    INNER JOIN [Block] as b ON b.[Id] = wfip.[BlockId] AND b.[BlockNumber] = @MaxBlockNumber
    WHERE @ContractId = wfip.[ContractId] 

    -- Select contract transactions
    SELECT t.[Id], t.[ConnectionId], t.[BlockId], b.[BlockNumber], b.[BlockHash], t.[TransactionHash], t.[From], t.[To], t.[Value], t.[IsAppBuilderTx]
    FROM [ContractAction] AS wfa
    INNER JOIN [Transaction] AS t ON wfa.[TransactionId] = t.[Id]
    INNER JOIN [Block] AS b ON t.[BlockId] = b.[Id]
    WHERE @ContractId = wfa.[ContractId]

    -- Select workflow instance actions
    SELECT wfa.[Id], [UserId], [ProvisioningStatus], [Timestamp], [WorkflowFunctionId], [TransactionId], [WorkflowStateId], [RequestId]
    FROM [ContractAction] AS wfa
    WHERE @ContractId = wfa.[ContractId]

    -- Select workflow function parameters
    SELECT wfa.[Id] AS ContractActionId, wfp.[DisplayName] AS Name, wfiap.[Value] AS Value, wfiap.[WorkflowFunctionParameterId] As WorkflowFunctionParameterId 
    FROM [ContractAction] AS wfa
    INNER JOIN [WorkflowFunction] AS wf ON wf.[Id] = wfa.[WorkflowFunctionId]
    INNER JOIN [ContractActionParameter] AS wfiap ON wfiap.[ContractActionId] = wfa.[Id]
    INNER JOIN [WorkflowFunctionParameter] AS wfp ON wfiap.[WorkflowFunctionParameterId] = wfp.[Id]
    WHERE @ContractId = wfa.[ContractId]

    COMMIT TRANSACTION
END TRY

BEGIN CATCH
    ROLLBACK TRANSACTION;
    THROW;
END CATCH
END
