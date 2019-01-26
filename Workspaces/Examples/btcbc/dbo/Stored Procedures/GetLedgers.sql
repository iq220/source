CREATE PROCEDURE [dbo].[GetLedgers]
	@top INT = null,
	@skip INT = null
AS
  SELECT @Top = ISNULL(@Top, 20)
  IF @Top < 1 
    SET @Top = 20
  IF @Top > 100 
      SET @Top = 100
  SELECT @Skip = ISNULL(@Skip, 0)

	SELECT [ID],[Name],[DisplayName] FROM [dbo].[Ledger] ORDER BY [ID] OFFSET @skip ROWS FETCH NEXT @top ROWS ONLY
RETURN 0