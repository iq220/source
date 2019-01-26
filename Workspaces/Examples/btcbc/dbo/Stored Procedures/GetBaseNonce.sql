-- Gets the base nonce for a given user
CREATE PROCEDURE [dbo].[GetBaseNonce]
    @UserID INT,
    @ConnectionID INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT [BaseNonce] FROM [dbo].[UserChainMapping] as m WHERE m.[UserId] = @UserId AND m.[ConnectionId] = @ConnectionId
END
