CREATE PROCEDURE [dbo].[GetLedger]
	@LedgerID INT
AS
BEGIN
	SET NOCOUNT ON;
		
	SELECT [ID],[Name],[DisplayName] FROM [dbo].[Ledger] as c WHERE c.[ID] = @LedgerID
END