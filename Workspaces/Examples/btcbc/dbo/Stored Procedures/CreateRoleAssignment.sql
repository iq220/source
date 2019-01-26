CREATE PROCEDURE [dbo].[CreateRoleAssignment]
    @UserId INT,
    @ApplicationRoleId INT
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @ErrorMessage NVARCHAR(255)
    
    IF NOT EXISTS(SELECT [ID] FROM [dbo].[User] WHERE [Id] = @UserId)
    BEGIN
        SET @Errormessage = '@UserId ' + CAST(@UserId AS NVARCHAR) + ' not found.';
        THROW 55200, @Errormessage, 0;
    END

    IF NOT EXISTS(SELECT [ID] FROM [dbo].[ApplicationRole] WHERE [Id] = @ApplicationRoleId)
    BEGIN
        SET @Errormessage = '@ApplicationRoleId ' + CAST(@ApplicationRoleId AS NVARCHAR) + ' not found.';
        THROW 55200, @Errormessage, 0;
    END

    IF EXISTS(SELECT [ID] FROM [dbo].[RoleAssignment] WHERE [UserId] = @UserId AND [ApplicationRoleId] = @ApplicationRoleId)
    BEGIN
        SET @Errormessage = 'Role assignment with @ApplicationRole ' + CAST(@ApplicationRoleId AS NVARCHAR) + ' and @UserId ' + CAST(@UserId AS NVARCHAR) + ' already exists';
        THROW 55200, @Errormessage, 0;
    END

    INSERT INTO [dbo].[RoleAssignment]([UserId], [ApplicationRoleId])
        VALUES(@UserId, @ApplicationRoleId)

    SELECT SCOPE_IDENTITY() AS NewId
END
