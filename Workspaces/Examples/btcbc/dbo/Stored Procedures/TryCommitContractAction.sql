CREATE PROCEDURE [dbo].[TryCommitContractAction]
    @ContractActionId INT,
    @TransactionHash NVARCHAR(255)
AS
BEGIN
BEGIN TRY
  BEGIN TRANSACTION

    SET NOCOUNT ON;

    DECLARE @TransactionProvisioningStatus INT
    SELECT @TransactionProvisioningStatus = [ProvisioningStatus] 
    FROM [dbo].[Transaction] 
    WHERE [TransactionHash] = @TransactionHash

    IF @TransactionProvisioningStatus = 0
    BEGIN
        SELECT 0 AS Status
    END
    ELSE IF @TransactionProvisioningStatus = 1
    BEGIN 
        UPDATE [dbo].[ContractAction] 
        SET [ProvisioningStatus] = 2
        WHERE [Id] = @ContractActionId
        SELECT 1 AS Status
    END
    ELSE
    BEGIN
        UPDATE [dbo].[ContractAction] 
        SET [ProvisioningStatus] = 5
        WHERE [Id] = @ContractActionId
        SELECT 1 AS Status
    END
 
COMMIT TRANSACTION
END TRY

BEGIN CATCH
    ROLLBACK TRANSACTION;
    THROW;
END CATCH
END