CREATE PROCEDURE [dbo].[GetRoleAssignment]
    @RoleAssignmentId INT,
	@UserId INT,
	@IsAdmin BIT
AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @ErrorMessage NVARCHAR(255)

	DECLARE @ApplicationId INT
	SELECT @ApplicationId = a.[Id] FROM [dbo].[Application] AS a
	INNER JOIN [dbo].[ApplicationRole] AS ar ON a.[Id] = ar.[ApplicationId]
	INNER JOIN [dbo].[RoleAssignment] AS ra ON ar.[Id] = ra.[ApplicationRoleId]
	WHERE ra.[Id] = @RoleAssignmentId

	IF @ApplicationId IS NULL
	BEGIN
		-- @ApplicationId not found
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

    SELECT 
        urm.[Id],
        urm.[UserId],
        urm.[ApplicationRoleId]
    FROM [dbo].[RoleAssignment] AS urm
    WHERE @RoleAssignmentId = urm.[Id]

END