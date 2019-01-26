CREATE PROCEDURE [dbo].[GetTransactions] 
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

  SELECT T.[ID],
      T.[ConnectionID],
      T.[BlockID],
      T.[TransactionHash],
      T.[From],
      T.[To],
      T.[Value],
      T.[IsAppBuilderTx]
      FROM dbo.[Transaction] AS T
      WHERE T.[ConnectionID] = @connectionId
      ORDER BY T.[ID] OFFSET @skip ROWS FETCH NEXT @top ROWS ONLY
END
RETURN 0