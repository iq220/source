CREATE PROCEDURE [dbo].[GetPendingContractActions]
    @IntervalInMilliseconds INT
AS
BEGIN
    DECLARE @SweepTime DATETIME2
    DECLARE @SweepTimeWithInterval DATETIME2

    SET @SweepTime = GETUTCDATE()
    SET @SweepTimeWithInterval = DATEADD(MILLISECOND, -@IntervalInMilliseconds, @SweepTime)

    DECLARE @PendingContractActionIds [dbo].[udtt_Ids]

    -- get contract actions where provisioning status is 
    -- -- 0 for created
    -- -- 1 for submitted
    -- -- 3 for failed to submit
    -- AND 
    -- -- LastSweepTime < (Current time - IntervalInMilliseconds)
    INSERT INTO @PendingContractActionIds
    SELECT [Id]
    FROM [dbo].[ContractAction]
    WHERE 
      (
        [ProvisioningStatus] = 0 OR 
        [ProvisioningStatus] = 1 OR
        [ProvisioningStatus] = 3
      )
      AND
      [LastSweepTimestamp] < @SweepTimeWithInterval

    -- return contract action id, user id, and connection id
    -- here the ids obtained from above cannot be used since
    -- the contract id required is not directly obtained from the contract
    -- action ids in the PendingContractActionIds
    SELECT
          ca.[Id] AS ContractActionId,
          ca.[UserId] AS UserId,
          c.[ConnectionId] AS ConnectionId,
          ca.[RequestId] AS RequestId
    FROM @PendingContractActionIds pcai
    LEFT JOIN [dbo].[ContractAction] ca ON pcai.[Id] = ca.[Id]
    INNER JOIN [dbo].[Contract] c ON ca.ContractId = c.Id
    LEFT JOIN [dbo].[Transaction] t ON t.[Id] = ca.[TransactionId]
    WHERE t.[TransactionHash] IS NULL OR t.[EstimatedGas] IS NOT NULL

    -- finally, update the last sweep time of all the contract action ids selected
    UPDATE ca
    SET [LastSweepTimestamp] = @SweepTime
    FROM @PendingContractActionIds pcai
    LEFT JOIN [dbo].[ContractAction] ca ON pcai.[Id] = ca.[Id]
END