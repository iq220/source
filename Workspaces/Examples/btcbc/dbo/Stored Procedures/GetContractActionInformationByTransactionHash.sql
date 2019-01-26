CREATE PROCEDURE [dbo].[GetContractActionInformationByTransactionHash]
(
    @TransactionHash NVARCHAR(255)
)
AS
BEGIN
    DECLARE @ContractActionId INT
    DECLARE @ContractAddress NVARCHAR(255)
    DECLARE @WorkflowFunctionName NVARCHAR(50)

    SELECT @ContractActionId = ca.[Id], @ContractAddress = c.[LedgerIdentifier], @WorkflowFunctionName = wf.[Name]
    FROM [dbo].[ContractAction] AS ca 
    INNER JOIN [dbo].[Transaction] AS tx ON tx.[TransactionHash] = @TransactionHash
    INNER JOIN [dbo].[Contract] AS c ON c.[Id] = ca.[ContractId]
    INNER JOIN [dbo].[WorkflowFunction] AS wf ON wf.[Id] = ca.[WorkflowFunctionId]
    WHERE tx.[Id] = ca.[TransactionId]

    SELECT @ContractActionId AS ContractActionId
    SELECT @ContractAddress AS ContractAddress
    SELECT @WorkflowFunctionName AS WorkflowFunctionName
END