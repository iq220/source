CREATE PROCEDURE [dbo].[IsApplicationAccessibleByUser]
    @ApplicationId INT,
    @UserId INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ReturnVal INT
    SET @ReturnVal = 1

    IF NOT EXISTS (
	    SELECT app.[Id] FROM [dbo].[Application] AS app 
	    INNER JOIN [dbo].[ApplicationRole] AS ar ON ar.[ApplicationId] = app.[Id]
	    INNER JOIN [dbo].[RoleAssignment] AS urm ON urm.[ApplicationRoleId] = ar.[Id]
	    WHERE urm.[UserId] = @UserId AND @ApplicationId = app.[Id]
    )
    BEGIN
        SET @ReturnVal = 0
    END
    
    SELECT @ReturnVal AS Id
END