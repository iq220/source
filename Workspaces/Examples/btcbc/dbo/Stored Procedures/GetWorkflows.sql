CREATE PROCEDURE [dbo].[GetWorkflows]
    @ApplicationId INT,
	@Top INT = null,
	@Skip INT = null,
	@UserId INT,
	@IsAdmin BIT
AS
    SET NOCOUNT ON;

    SELECT @Top = ISNULL(@Top, 20)
    IF @Top < 1 
        SET @Top = 20
    IF @Top > 100 
        SET @Top = 100
    SELECT @Skip = ISNULL(@Skip, 0)

	DECLARE @ErrorMessage NVARCHAR(255)
   	SET @ErrorMessage = 'Incorrect input. Check that ids are correct and user is authorized.'

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

	SELECT [Id]
      ,[Name]
      ,[Description]
      ,[DisplayName]
      ,[ApplicationId]
      ,[ConstructorId]
      ,[StartStateId]
    FROM [dbo].[Workflow]
    WHERE [ApplicationId] = @ApplicationId
    ORDER BY [ID] OFFSET @Skip ROWS FETCH NEXT @Top ROWS ONLY
	
RETURN 