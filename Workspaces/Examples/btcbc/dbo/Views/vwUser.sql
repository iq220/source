CREATE VIEW [dbo].[vwUser] as (
    SELECT u.[Id], u.[ExternalId], u.[FirstName], u.[LastName], u.[EmailAddress],
    (CASE
        WHEN EXISTS (SELECT ucm.[Id] FROM [dbo].[UserChainMapping] AS ucm WHERE ucm.[UserId] = u.[Id])
            THEN 2
        ELSE 0
    END) AS ProvisioningStatus
    FROM dbo.[User] AS u
)
