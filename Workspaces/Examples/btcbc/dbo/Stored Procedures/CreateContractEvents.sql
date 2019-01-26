CREATE PROCEDURE [dbo].[CreateContractEvents]
(
    @ConnectionId   INT,
    @ContractEvents   [dbo].[udtt_ContractEvents] READONLY
)
AS
BEGIN
    DECLARE @Timestamp DATETIME2 (7)
    SET @Timestamp = sysutcdatetime()

    INSERT INTO [dbo].[Contract] ([ProvisioningStatus], [Timestamp], [ConnectionId], [LedgerIdentifier], [DeployedByUserId], [WorkflowId], [ContractCodeId])
    SELECT NULL, @Timestamp, @ConnectionId, ce.[ContractAddress], ucm.[UserId], ce.[WorkflowId], cc.[Id]
    FROM @ContractEvents AS ce
    INNER JOIN [dbo].[Connection] AS c ON c.[Id] = @ConnectionId
    INNER JOIN [dbo].[ContractCode] AS cc ON cc.[LedgerId] = c.[LedgerId] AND cc.[ApplicationId] = ce.[ApplicationId]
    INNER JOIN [dbo].[Transaction] AS tx ON tx.[TransactionHash] = ce.[TransactionHash]
    INNER JOIN [dbo].[UserChainMapping] AS ucm ON ucm.[ConnectionID] = @ConnectionId AND ucm.[ChainIdentifier] = tx.[From]
    WHERE ce.[ContractAddress] NOT IN (SELECT [LedgerIdentifier] FROM [dbo].[Contract] WHERE [LedgerIdentifier] IS NOT NULL)

    INSERT INTO [dbo].[ContractAction] ([ContractId], [UserId], [WorkflowFunctionId], [TransactionId], [WorkflowStateId], [ProvisioningStatus])
    SELECT c.[Id], ucm.[UserId], wf.[Id], tx.[Id], wfs.[Id], 2
    FROM @ContractEvents AS ce
    INNER JOIN [dbo].[Contract] as c ON c.[LedgerIdentifier] = ce.[ContractAddress]
    INNER JOIN [dbo].[Transaction] AS tx ON tx.[TransactionHash] = ce.[TransactionHash]
    INNER JOIN [dbo].[UserChainMapping] AS ucm ON tx.[From] = ucm.[ChainIdentifier] AND tx.[ConnectionID] = ucm.[ConnectionID]
    INNER JOIN [dbo].[WorkflowFunction] AS wf ON wf.[WorkflowId] = ce.[WorkflowId] AND [wf].[Name] = ce.[ActionName]
    INNER JOIN [dbo].[WorkflowState] as wfs ON wfs.[WorkflowId] = ce.[WorkflowId]
    WHERE wfs.[Value] = ce.[WorkflowStateValue]

	SELECT @@ROWCOUNT
END