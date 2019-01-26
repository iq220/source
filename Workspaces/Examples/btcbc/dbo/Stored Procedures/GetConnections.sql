CREATE PROCEDURE [dbo].[GetConnections] 
	@top INT = null,
	@skip INT = null
AS
BEGIN
	SET NOCOUNT ON
  SELECT @Top = ISNULL(@Top, 20)
  IF @Top < 1 
      SET @Top = 20
  IF @Top > 100 
      SET @Top = 100
  SELECT @Skip = ISNULL(@Skip, 0)

  BEGIN
    SELECT C.[ID],
        C.[LedgerID],
        C.[EndPointURL],
        C.[FundingAccount]
        FROM dbo.[Connection] AS C
        ORDER BY C.[ID] OFFSET @skip ROWS FETCH NEXT @top ROWS ONLY
  END
END
RETURN 0
