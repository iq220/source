CREATE PROCEDURE [dbo].[GetUserByChainIdentifier]
	@ChainIdentifier NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT u.[ID],u.[ExternalID],u.[FirstName],u.[LastName],u.[EmailAddress]
    FROM [dbo].[User] AS u
    INNER JOIN [dbo].[UserChainMapping] AS ucm ON ucm.[UserId] = u.[Id]
    WHERE ucm.[ChainIdentifier] = @ChainIdentifier
END