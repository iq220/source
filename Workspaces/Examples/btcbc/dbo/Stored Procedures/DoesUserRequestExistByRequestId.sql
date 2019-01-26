CREATE PROCEDURE [dbo].[DoesUserRequestExistByRequestId]
(
    @RequestId NVARCHAR (50)
)
AS
BEGIN
	DECLARE @LookupId int, @ReturnVal BIT

	SELECT @LookupId = Id
	FROM [UserChainMapping]
	WHERE [RequestId] = @RequestId

	SET @ReturnVal = 1
	IF @LookupId IS NULL
	BEGIN
		SET @ReturnVal = 0
	END
	SELECT @ReturnVal AS Status
END