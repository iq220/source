CREATE PROCEDURE [dbo].[GetContractIdByAddress] 
	@ContractAddress NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON
    SELECT TOP 1 [Id]
    FROM [dbo].[Contract]
    WHERE [LedgerIdentifier] = @ContractAddress
END
RETURN 0