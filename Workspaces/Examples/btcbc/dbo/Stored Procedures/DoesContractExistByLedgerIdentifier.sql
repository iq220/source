CREATE PROCEDURE [dbo].[DoesContractExistByLedgerIdentifier]
(
    @ConnectionId INT,
    @LedgerIdentifier NVARCHAR (255)
)
AS
BEGIN
	DECLARE @LookupId int, @ReturnVal BIT

	SELECT @LookupId = Id
	FROM [Contract]
	WHERE [ConnectionId] = @ConnectionId
    AND [LedgerIdentifier] = @LedgerIdentifier

	SET @ReturnVal = 1
	IF @LookupId IS NULL
	BEGIN
		SET @ReturnVal = 0
	END
	SELECT @ReturnVal AS Status
END