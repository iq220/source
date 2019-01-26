CREATE PROCEDURE [dbo].[CreateContractProperties]
(
    @BlockId              INT,
    @ContractProperties   [dbo].[udtt_ContractProperties] READONLY
)
AS
BEGIN
    DECLARE @ContractId INT

    SELECT TOP 1 @ContractId = [Id]
    FROM [dbo].[Contract]
    WHERE [LedgerIdentifier] IN (SELECT [ContractAddress] FROM @ContractProperties)

    IF @ContractId IS NOT NULL
    BEGIN
        INSERT INTO [dbo].[ContractProperty] ([BlockId], [ContractId], [WorkflowPropertyId], [Value])
        SELECT @BlockId, c.[Id], cp.[WorkflowPropertyId], cp.[ContractPropertyValue]
        FROM @ContractProperties AS cp
        INNER JOIN [dbo].[Contract] AS c ON c.[LedgerIdentifier] = cp.[ContractAddress]

        SELECT @@ROWCOUNT;
    END
END