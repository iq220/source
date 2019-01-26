CREATE PROCEDURE [dbo].[GetLastInsertedBlockNumber] 
AS
BEGIN
BEGIN TRY
  BEGIN TRANSACTION

  DECLARE @ReturnVal INT

  IF EXISTS (SELECT [BlockNumber] FROM [Block])
  BEGIN
    SELECT @ReturnVal = MAX([BlockNumber])
    FROM [dbo].[Block]
  END
  ELSE
  BEGIN
    SET @ReturnVal = 0
  END

  SELECT @ReturnVal AS [BlockNumber]

  COMMIT TRANSACTION
END TRY

BEGIN CATCH
    ROLLBACK TRANSACTION;
    THROW;
END CATCH
END