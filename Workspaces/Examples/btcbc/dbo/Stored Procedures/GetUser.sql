CREATE PROCEDURE [dbo].[GetUser]
	@UserID INT
AS
BEGIN
	SET NOCOUNT ON;
		
	SELECT [ID],[ExternalID],[FirstName],[LastName],[EmailAddress] FROM [dbo].[User] as u WHERE u.[ID] = @UserID
END