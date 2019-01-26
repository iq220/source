CREATE PROCEDURE [dbo].[UpdateUserChainIdentifier]
	@UserId INT,
	@ConnectionId INT,
	@ChainIdentifier NVARCHAR(255)
AS
BEGIN
	SET NOCOUNT ON;
		
	UPDATE [dbo].[UserChainMapping] 
    SET [ChainIdentifier] = @ChainIdentifier
    WHERE [UserId] = @UserId AND [ConnectionID] = @ConnectionId

END