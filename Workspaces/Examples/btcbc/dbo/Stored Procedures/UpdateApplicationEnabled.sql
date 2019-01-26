CREATE PROCEDURE [dbo].[UpdateApplicationEnabled]
    @ApplicationId INT,
    @Enabled BIT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT [Id] FROM [dbo].[Application] AS a WHERE a.[Id] = @ApplicationId)
    BEGIN
      DECLARE @ErrorMessage NVARCHAR(255)
      SET @ErrorMessage = 'Application with Id ' + CAST(@ApplicationId AS nvarchar) 
				+ 'does not exist';
			THROW 55200, @Errormessage, 0;
    END

    UPDATE [dbo].[Application] 
        SET [Enabled] = @Enabled
        WHERE [Id] = @ApplicationId
END