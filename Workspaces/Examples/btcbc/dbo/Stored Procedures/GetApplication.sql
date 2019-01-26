CREATE PROCEDURE [dbo].[GetApplication]
    @ApplicationId INT,
	@UserId INT,
	@IsAdmin BIT
AS
BEGIN
    SET NOCOUNT ON;
	DECLARE @ErrorMessage NVARCHAR(255)

	IF NOT EXISTS (SELECT [Id] FROM [dbo].[Application] WHERE [Id] = @ApplicationId)
    BEGIN
		-- @ApplicationId not found
    SET @Errormessage = 'Application ID ' + CAST(@ApplicationId AS NVARCHAR) + ' not found.';
    THROW 55100, @Errormessage, 0;
    END

	IF @IsAdmin = 0
	BEGIN
		DECLARE @Status [dbo].[udtt_Ids]
		INSERT INTO @Status 
		EXEC [dbo].[IsApplicationAccessibleByUser] @ApplicationId, @UserId
	    
        IF (SELECT [Id] FROM @Status) = 0
        BEGIN
			-- @UserId is not authorized to access @ApplicationId
          SET @ErrorMessage = 'User ' + CAST(@UserId AS nvarchar) +' is not authorized to take this action.';
          THROW 55100, @Errormessage, 0;
        END
    END
	
	-- Return the specified Application
	SELECT [Id],[Name],[Description],[DisplayName],[CreatedByUserId],[CreatedDtTm],[Enabled],[BlobStorageURL] FROM [dbo].[Application] AS a
		WHERE a.[Id] = @ApplicationId

	-- Return the specified Application's ApplicationRole
	SELECT [Id], [Name], [Description] FROM
		[dbo].[ApplicationRole] AS ar
		WHERE ar.[ApplicationId] = @ApplicationId
END