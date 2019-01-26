CREATE PROCEDURE [dbo].[DoesApplicationExistByName]
(
    @Name NVARCHAR (50)
)
AS
BEGIN
    DECLARE @ApplicationId int, @ReturnVal BIT

    SELECT @ApplicationId = Id
    FROM [Application]
    WHERE [Name] = @Name

    SET @ReturnVal = 1
    if @ApplicationId IS NULL
    BEGIN
        SET @ReturnVal = 0
    END
    SELECT @ReturnVal AS Status
END