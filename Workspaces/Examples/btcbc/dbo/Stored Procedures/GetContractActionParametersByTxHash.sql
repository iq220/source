CREATE PROCEDURE [dbo].[GetContractActionParametersByTxHash] 
    @TransactionHash NVARCHAR(255),
	@ContractAddress NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON
    SELECT wfp.Name AS 'Name', cap.Value AS 'Value', dt.Name AS 'Type'
    FROM [dbo].[ContractActionParameter] AS cap
    INNER JOIN [ContractAction] AS ca ON ca.Id = cap.ContractActionId
    INNER JOIN [Transaction] AS tx ON tx.Id = ca.TransactionId
    INNER JOIN [WorkflowFunctionParameter] AS wfp ON wfp.Id = cap.WorkflowFunctionParameterId
    INNER JOIN [DataType] AS dt ON dt.Id = wfp.DataTypeId
    INNER JOIN [Contract] AS c ON c.Id = ca.ContractId
    WHERE c.LedgerIdentifier = @ContractAddress AND tx.TransactionHash = @TransactionHash
END
RETURN 0