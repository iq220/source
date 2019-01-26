CREATE PROCEDURE [dbo].[GetContractCodes]
    @ApplicationId INT,
    @LedgerId INT = null,
    @Top INT = null,
    @Skip INT = null,
	@UserId INT,
	@IsAdmin BIT
AS
BEGIN
    SET NOCOUNT ON;
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

    IF @LedgerId IS NULL
        SELECT li.[Id], [LedgerId], [CreatedByUserId], [CreatedDtTm] FROM [dbo].[ContractCode] li
		WHERE li.[ApplicationId] = @ApplicationId
        ORDER BY [Id] OFFSET @Skip ROWS FETCH NEXT @Top ROWS ONLY
    ELSE
	BEGIN
		IF NOT EXISTS (SELECT [Id] FROM [dbo].[Ledger] WHERE [Id] = @LedgerId)
    	BEGIN
       		-- @LedgerId not found
       	SET @Errormessage = 'Ledger Id ' + CAST(@LedgerId AS NVARCHAR) + ' not found.';
        THROW 55100, @Errormessage, 0;
    	END
        SELECT li.[Id], [LedgerId], [CreatedByUserId], [CreatedDtTm] FROM [dbo].[ContractCode] li
        WHERE li.[ApplicationId] = @ApplicationId AND li.[LedgerId] = @LedgerId
        ORDER BY [Id] OFFSET @Skip ROWS FETCH NEXT @Top ROWS ONLY
	END
END