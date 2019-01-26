CREATE PROCEDURE [dbo].[GetRoleAssignments]
    @ApplicationId INT,
    @ApplicationRoleId INT = null,
    @Top INT = null,
    @Skip INT = null,
	@UserId INT,
	@IsAdmin BIT,
    @SortBy NVARCHAR(255)
AS
BEGIN
	DECLARE @ErrorMessage NVARCHAR(255)

    SELECT @Top = ISNULL(@Top, 20)
    IF @Top < 1 
        SET @Top = 20
    IF @Top > 100 
        SET @Top = 100
    SELECT @Skip = ISNULL(@Skip, 0)

    IF NOT EXISTS (SELECT [Id] FROM [dbo].[Application] WHERE [Id] = @ApplicationId)
    BEGIN
       	SET @Errormessage = 'Application Id ' + CAST(@ApplicationId AS NVARCHAR) + ' not found.';
        THROW 55100, @Errormessage, 0;
    END

	IF @IsAdmin = 0
	BEGIN
        DECLARE @Status [dbo].[udtt_Ids]
		INSERT INTO @Status
        EXEC [dbo].[IsApplicationAccessibleByUser] @ApplicationId, @UserId

		IF (SELECT [Id] FROM @Status) = 0
		BEGIN
            -- @UserId not authorized to access @ApplicationId
        SET @ErrorMessage = 'User ' + CAST(@UserId AS nvarchar) +' is not authorized to take this action.';
        THROW 55100, @Errormessage, 0;
		END
	END

	DECLARE @authorizedRoleAssignment [dbo].[udtt_Ids]

    IF (@ApplicationRoleId IS NULL)
    BEGIN
	    INSERT INTO @authorizedRoleAssignment
	    SELECT urm.[Id] FROM [dbo].[RoleAssignment] urm
	    INNER JOIN [dbo].[ApplicationRole] ar ON urm.[ApplicationRoleId] = ar.[Id]
	    WHERE ar.[ApplicationId] = @ApplicationId
    END
    ELSE
    BEGIN
        IF NOT EXISTS (SELECT [Id] FROM [dbo].[ApplicationRole] WHERE @ApplicationRoleId = [Id] AND @ApplicationId = [ApplicationId])
        BEGIN
            -- @ApplicationRoleId not found
            SET @Errormessage = 'Application role Id ' + CAST(@ApplicationRoleId AS NVARCHAR) + ' not found.';
            THROW 55100, @Errormessage, 0;
        END
        INSERT INTO @authorizedRoleAssignment
	    SELECT urm.[Id] FROM [dbo].[RoleAssignment] urm
	    WHERE @ApplicationRoleId = urm.[ApplicationRoleId]
    END

    SELECT rm.[Id], rm.[UserId], rm.[ApplicationRoleId]
    FROM [dbo].[RoleAssignment] rm
    INNER JOIN @authorizedRoleAssignment authorized ON rm.[Id] = authorized.[Id]
    INNER JOIN [dbo].[User] u ON rm.[UserId] = u.[Id]
    ORDER BY 
        CASE @SortBy WHEN 'FirstName' COLLATE SQL_Latin1_General_CP1_CI_AS THEN u.[FirstName] END
        ,u.[Id]
    OFFSET @Skip ROWS FETCH NEXT @Top ROWS ONLY
END