CREATE PROCEDURE [dbo].[GetPendingUserCreations]
    @IntervalInMilliseconds INT
AS
BEGIN
    DECLARE @SweepTime DATETIME2
    DECLARE @SweepTimeWithInterval DATETIME2

    SET @SweepTime = GETUTCDATE()
    SET @SweepTimeWithInterval = DATEADD(MILLISECOND, -@IntervalInMilliseconds, @SweepTime)

    DECLARE @PendingUserChainMappingIds [dbo].[udtt_Ids]
    -- return UserId and ConnectionId where
    -- Chain Identifier is NULL
    -- AND 
    -- -- LastSweepTime < (Current time - IntervalInMilliseconds)
    INSERT INTO @PendingUserChainMappingIds
    SELECT [Id]
    FROM [dbo].[UserChainMapping]
    WHERE 
      [ChainIdentifier] IS NULL
      AND
      [LastSweepTimestamp] < @SweepTimeWithInterval

    -- return a list of UserId and ConnectionId pair
    SELECT 
        ucm.[UserID] AS UserId,
        ucm.[ConnectionID] AS ConnectionId,
        ucm.[RequestId] AS RequestId
    FROM [dbo].[UserChainMapping] AS ucm
    INNER JOIN 
    (
      SELECT [Id] FROM @PendingUserChainMappingIds
    ) as pucmi on ucm.[ID] = pucmi.[Id];

    -- update the last sweep time of all user chain mapping ids picked
    UPDATE [dbo].[UserChainMapping]
    SET [LastSweepTimestamp] = @SweepTime
    FROM [dbo].[UserChainMapping] as ucm
    INNER JOIN 
    (
      SELECT [Id] FROM @PendingUserChainMappingIds
    ) as pucmi on ucm.[Id] = pucmi.[Id];

END