CREATE PROCEDURE [dbo].[GetEstimatedGasAndTransactionHash]
    @ContractActionId INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @TransactionId INT
    SELECT @TransactionId = [TransactionId]
    FROM [dbo].[ContractAction] 
    WHERE [Id] = @ContractActionId

    SELECT [EstimatedGas], [TransactionHash]
    FROM [dbo].[Transaction]
    WHERE [Id] = @TransactionId
END