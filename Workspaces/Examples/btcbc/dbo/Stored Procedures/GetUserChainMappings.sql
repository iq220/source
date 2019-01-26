CREATE PROCEDURE [dbo].[GetUserChainMappings]
	@UserID INT
AS
BEGIN
	SET NOCOUNT ON;
		
	SELECT [ID],[UserID],[ConnectionID],[ChainIdentifier],[ChainBalance] FROM [dbo].[UserChainMapping] as u WHERE u.[UserID] = @UserID
END