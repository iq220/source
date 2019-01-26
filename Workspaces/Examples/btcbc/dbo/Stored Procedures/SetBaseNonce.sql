-- Set the base nonce upon querying the rpc endpoint
CREATE PROCEDURE [dbo].[SetBaseNonce]
    @UserID INT,
    @ConnectionID INT,
    @NonceValue BIGINT
AS
BEGIN

    SET NOCOUNT ON;

    -- Update the user chain mapping table's base nonce to the @NonceValue value
    -- but only if base nonce is NULL.
    -- In case of a race where multiple calls to SetBaseNonce are in flight
    -- at the same time, the update statement below ensures only one will
    -- win and once BaseNonce is set to a non-null value, it won't change.
    UPDATE [dbo].[UserChainMapping]
    SET [BaseNonce] = COALESCE([BaseNonce], @NonceValue)
    WHERE [UserID] = @UserID AND [ConnectionID] = @ConnectionID

    SELECT [BaseNonce] AS BaseNonce
    FROM [dbo].[UserChainMapping] as m
    WHERE m.[UserId] = @UserId AND m.[ConnectionId] = @ConnectionId

END
