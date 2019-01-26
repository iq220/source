CREATE PROCEDURE [dbo].[UpdateTransactionAndContractInformation]
    @ConnectionId INT,
    @UserChainIdentifier NVARCHAR(255),
    @TransactionHash NVARCHAR(255),
    @EstimatedGas BIGINT,
    @LedgerIdentifier NVARCHAR(255),
    @ContractActionId INT
AS
BEGIN

BEGIN TRY
    BEGIN TRANSACTION

    DECLARE @TransactionId INT

	SELECT @TransactionId = [Id]
	FROM [dbo].[Transaction]
	WHERE [TransactionHash] = @TransactionHash

	IF (@TransactionId IS NULL)
	BEGIN
		INSERT INTO [dbo].[Transaction]
		(
			[ConnectionID],
			[BlockID],
			[TransactionHash],
			[EstimatedGas],
			[From],
			[To],
			[Value],
			[IsAppBuilderTx],
			[ProvisioningStatus]
		)
		VALUES
		(
			@ConnectionId,
			NULL,
			@TransactionHash,
			@EstimatedGas,
			@UserChainIdentifier,
			@LedgerIdentifier,
			NULL,
			1,
			0
		)

		UPDATE c
		SET [LedgerIdentifier] = @LedgerIdentifier
		FROM [dbo].[Contract] AS c
		INNER JOIN [dbo].[ContractAction] AS ca ON c.[Id] = ca.[ContractId]
		WHERE ca.[Id] = @ContractActionId

		SELECT @TransactionId = [Id]
    	FROM [dbo].[Transaction]
    	WHERE [TransactionHash] = @TransactionHash

    	UPDATE [dbo].[ContractAction]
    	SET [TransactionId] = @TransactionId,
        [Timestamp] = GETUTCDATE()
    	WHERE [Id] = @ContractActionId
	END

    COMMIT TRANSACTION
END TRY

BEGIN CATCH
    ROLLBACK TRANSACTION;
    THROW;
END CATCH

END
