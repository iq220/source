CREATE PROCEDURE [dbo].[DoesLedgerExistById]
(
    @LedgerId INT
)
AS
BEGIN
	DECLARE @LookupId int, @ReturnVal BIT

	SELECT @LookupId = Id
	FROM [Ledger]
	WHERE [Id] = @LedgerId

	SET @ReturnVal = 1
	if @LookupId IS NULL
	BEGIN
		SET @ReturnVal = 0
	END
	SELECT @ReturnVal AS Status
END