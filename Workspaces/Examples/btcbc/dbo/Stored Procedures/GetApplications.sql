CREATE PROCEDURE [dbo].[GetApplications]
    @Top INT = null,
    @Skip INT = null,
    @Enabled BIT = null,
	@UserId INT,
	@IsAdmin BIT,
	@SortBy NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT @Top = ISNULL(@Top, 20)
    IF @Top < 1 
        SET @Top = 20
    IF @Top > 100 
        SET @Top = 100
    SELECT @Skip = ISNULL(@Skip, 0)

	IF @IsAdmin = 0
	BEGIN
		---- Find authorized applications ----
		DECLARE @authorizedApps [dbo].[udtt_Ids]
		INSERT INTO @authorizedApps
		SELECT app.[Id] FROM [dbo].[Application] AS app 
	    INNER JOIN [dbo].[ApplicationRole] AS ar ON ar.[ApplicationId] = app.[Id]
	    INNER JOIN [dbo].[RoleAssignment] AS urm ON urm.[ApplicationRoleId] = ar.[Id]
	    WHERE urm.[UserId] = @UserId

		SELECT a.[Id],[Name],[Description],[DisplayName],[CreatedByUserId],[CreatedDtTm],[Enabled] FROM [dbo].[Application] as a
		INNER JOIN @authorizedApps AS authorized ON authorized.[Id] = a.[Id]
		WHERE a.[Enabled] = ISNULL(@Enabled, a.[Enabled])
		ORDER BY 
			CASE @SortBy WHEN 'DisplayName' COLLATE SQL_Latin1_General_CP1_CI_AS THEN [DisplayName] END
			,[Id]
		OFFSET @Skip ROWS FETCH NEXT @Top ROWS ONLY
	END
	ELSE
	BEGIN
		SELECT a.[Id],[Name],[Description],[DisplayName],[CreatedByUserId],[CreatedDtTm],[Enabled] FROM [dbo].[Application] as a
		WHERE a.[Enabled] = ISNULL(@Enabled, a.[Enabled])
		ORDER BY 
			CASE @SortBy WHEN 'DisplayName' COLLATE SQL_Latin1_General_CP1_CI_AS THEN [DisplayName] END
			,[Id]
		OFFSET @Skip ROWS FETCH NEXT @Top ROWS ONLY
	END
END