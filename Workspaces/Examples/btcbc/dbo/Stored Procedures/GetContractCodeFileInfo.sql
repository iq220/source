CREATE PROCEDURE [dbo].[GetContractCodeFileInfo]
    @ContractCodeId INT,
    @UserId INT,
    @IsAdmin BIT
AS
BEGIN
    SET NOCOUNT ON

    DECLARE @ErrorMessage NVARCHAR(255)

    DECLARE @ApplicationId INT
    SELECT @ApplicationId = [ApplicationId] FROM [dbo].[ContractCode] WHERE [Id] = @ContractCodeId

    IF @ApplicationId IS NULL
    BEGIN
        -- @ContractCodeId not found
        SET @Errormessage = 'Contract Code Id ' + CAST(@ContractCodeId AS NVARCHAR) + ' not found.';
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

    SELECT [SourceBlobStorageURL], [FileName] 
    FROM [dbo].[ContractCode] AS li
    WHERE li.[Id] = @ContractCodeId
END