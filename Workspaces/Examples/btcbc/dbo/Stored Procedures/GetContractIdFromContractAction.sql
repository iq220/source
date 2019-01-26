CREATE PROCEDURE [dbo].[GetContractIdFromContractAction]
    @ContractActionId INT
AS
BEGIN
    SET NOCOUNT ON;

    Select [ContractId] AS ContractId
    FROM [dbo].[ContractAction] 
    WHERE [Id] = @ContractActionId
END