CREATE PROCEDURE [dbo].[GetConnection] 
	@ID INT
AS
BEGIN
	SET NOCOUNT ON
	SELECT C.[ID],
			C.[LedgerID],
			C.[EndPointURL],
			C.[FundingAccount]
			FROM dbo.[Connection] AS C 
			WHERE C.[ID] = @ID
END
RETURN 0
