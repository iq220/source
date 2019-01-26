CREATE PROCEDURE [dbo].[DoesWorkflowFunctionExistByNameAndLedgerIdentifier]
(
    @Name NVARCHAR (50),
    @ConnectionId INT,
    @LedgerIdentifier NVARCHAR (255)
)
AS
BEGIN
	DECLARE @WorkflowId int, @LookupId int, @ReturnVal BIT

	SELECT @WorkflowId = [WorkflowId]
	FROM [Contract]
	WHERE [ConnectionId] = @ConnectionId
    AND [LedgerIdentifier] = @LedgerIdentifier

    SELECT @LookupId = [Id]
    FROM [WorkflowFunction]
    WHERE [Name] = @Name
    AND [WorkflowId] = @WorkflowId

	SET @ReturnVal = 1
	IF @LookupId IS NULL
	BEGIN
		SET @ReturnVal = 0
	END
	SELECT @ReturnVal AS Status
END