CREATE PROCEDURE [dbo].[GetTransaction] 
	@ConnectionID INT,
	@ID int
AS
BEGIN
	SET NOCOUNT ON
	SELECT T.[ID],   
			T.[ConnectionID],
			T.[BlockID],
			T.[TransactionHash],
			T.[From],
			T.[To],
			T.[Value],
			T.[IsAppBuilderTx]
			FROM dbo.[Transaction] AS T
			WHERE T.[ID] = @ID AND T.[ConnectionID] = @ConnectionID
END
RETURN 0
