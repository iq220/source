CREATE PROCEDURE [dbo].[GetBlock] 
	@ConnectionID INT,
	@ID INT
AS
BEGIN
	SET NOCOUNT ON
	SELECT B.[ID],
		B.[ConnectionID],
		B.[BlockHash],
		B.[BlockNumber],
		B.[BlockTimestamp]
		FROM [dbo].[Block] AS B
		WHERE B.[ID] = @ID AND B.[ConnectionID] = @ConnectionID
END
RETURN 0