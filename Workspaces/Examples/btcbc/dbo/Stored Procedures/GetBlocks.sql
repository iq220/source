CREATE PROCEDURE [dbo].[GetBlocks] 
	@connectionId INT = 0,
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

  SELECT B.[ID],
    B.[ConnectionID],
    B.[BlockHash],
    B.[BlockNumber],
    B.[BlockTimestamp]
    FROM [dbo].[Block] AS B
    WHERE B.[ConnectionID] = @connectionId
    ORDER BY B.[ID] OFFSET @skip ROWS FETCH NEXT @top ROWS ONLY
END
RETURN 0