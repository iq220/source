CREATE PROCEDURE [dbo].[DoesWorkflowExistByName]
(
    @ApplicationName NVARCHAR (50),
    @WorkflowName NVARCHAR (50)
)
AS
BEGIN
    DECLARE @ApplicationId int, @WorkflowId int, @ReturnVal BIT

    SELECT @ApplicationId = Id
    FROM [Application]
    WHERE [Name] = @ApplicationName

    SET @ReturnVal = 1
    
    IF @ApplicationId IS NULL
    BEGIN
        SET @ReturnVal = 0
    END

    SELECT @WorkflowId = Id
    FROM [Workflow]
    WHERE [Name] = @WorkflowName
    AND [ApplicationId] = @ApplicationId

    IF @WorkflowId IS NULL
    BEGIN
        SET @ReturnVal = 0
    END

    SELECT @ReturnVal AS Status
END