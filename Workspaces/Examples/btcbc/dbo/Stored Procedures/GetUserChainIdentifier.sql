CREATE PROCEDURE [dbo].[GetUserChainIdentifier]
	@UserId INT,
    @ConnectionId INT
AS
BEGIN
	SET NOCOUNT ON;
    SELECT [ChainIdentifier]
    FROM [dbo].[UserChainMapping]
    WHERE [UserID] = @UserID AND [ConnectionID] = @ConnectionId
END