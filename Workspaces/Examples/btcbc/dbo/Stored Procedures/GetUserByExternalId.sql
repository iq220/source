CREATE PROCEDURE [dbo].[GetUserByExternalId]
	@ExternalId NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT [ID],[ExternalID],[FirstName],[LastName],[EmailAddress]
    FROM [dbo].[User]
    WHERE [ExternalId] = @ExternalId
END