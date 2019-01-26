CREATE PROCEDURE [dbo].[UpdateContractActionProvisioningStatus]
    @ContractActionId INT,
    @ProvisioningStatus INT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE [dbo].[ContractAction] 
    SET [ProvisioningStatus] = @ProvisioningStatus
    WHERE [Id] = @ContractActionId
END