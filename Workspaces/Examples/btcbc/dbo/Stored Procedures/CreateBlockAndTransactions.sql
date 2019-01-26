CREATE PROCEDURE [dbo].[CreateBlockAndTransactions]
(
    @ConnectionId   INT,
    @BlockNumber    INT,
    @BlockHash      NVARCHAR(255),
    @BlockTimestamp DATETIME2 (7),
    @Transactions   [dbo].[udtt_Transactions] READONLY
)
AS
BEGIN
    DECLARE @BlockId INT
	DECLARE @TransactionCount INT

    INSERT INTO [dbo].[Block] ([ConnectionID], [BlockNumber], [BlockHash], [BlockTimestamp])
    VALUES (@ConnectionId, @BlockNumber, @BlockHash, @BlockTimestamp)
    SET @BlockId = SCOPE_IDENTITY()

    UPDATE t
    SET [ProvisioningStatus] = tx.[ProvisioningStatus],
        [BlockId] = @BlockId,
        [Value] = tx.[Value],
        [To] = tx.[To]
    FROM [dbo].[Transaction] AS t, @Transactions AS tx 
    WHERE t.[TransactionHash] = tx.[TransactionHash]

	SET @TransactionCount = @@ROWCOUNT

    DECLARE @UnknownTransactions [dbo].[udtt_Transactions]
    INSERT INTO @UnknownTransactions ([TransactionHash], [From], [To], [Value], [ProvisioningStatus])
    SELECT tx.[TransactionHash], tx.[From], tx.[To], tx.[Value], tx.[ProvisioningStatus]
    FROM @Transactions AS tx 
    WHERE tx.[TransactionHash] NOT IN (SELECT [TransactionHash] FROM [dbo].[Transaction])
    
    INSERT INTO [dbo].[Transaction] ([BlockID], [TransactionHash], [From], [To], [Value], [ProvisioningStatus], [ConnectionId], [IsAppBuilderTx])
    SELECT  
        @BlockId,
        tx.[TransactionHash],
        tx.[From],
        tx.[To],
        tx.[Value],
        tx.[ProvisioningStatus],
        @ConnectionId,
		0
    FROM @UnknownTransactions AS tx

    SET @TransactionCount = @TransactionCount + @@ROWCOUNT

    SELECT @BlockId
	SELECT @TransactionCount
END
