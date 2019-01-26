-- Gets the information about transactions which have to be resubmitted
-- to the blockchain due to blockchain regression
CREATE PROCEDURE [dbo].[GetTransactionsForResubmission]
    @UserID INT,
    @ConnectionID INT,
    @BlockchainNextNonce INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @BaseNonce INT

    SELECT @BaseNonce = [BaseNonce]
    FROM [dbo].[UserChainMapping] AS m
    WHERE m.[UserId] = @UserId AND m.[ConnectionId] = @ConnectionId

    -- Note that we do not want to return rows that existed before 1.5.0 migration or 
    -- "synthetic" rows which are inserted by eth-watcher.
    --
    -- Pre-existing contract action rows created by older versions of
    -- Workbench as well as synthetic contract action rows will have
    -- their SequenceNumber set as NULL and the WHERE clause will not
    -- pick them up as (as (Number + NULL) >= Number) always evaluates
    -- to FALSE
    SELECT
      [Id] AS ContractActionId,
      [ProvisioningStatus] AS ProvisioningStatus,
      [SequenceNumber] AS SequenceNumber
    FROM [dbo].[ContractAction] AS ca
    WHERE
      ca.[UserId] = @UserID AND
      (@BaseNonce + ca.[SequenceNumber]) >= @BlockchainNextNonce AND
      (ca.[ProvisioningStatus] = 2 OR -- Committed
       ca.[ProvisioningStatus] = 4 OR -- FailedToSubmitAndNonceConsumed
       ca.[ProvisioningStatus] = 5)   -- CommittedWithoutEvents

END
