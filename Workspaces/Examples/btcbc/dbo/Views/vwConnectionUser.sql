
Create View [dbo].[vwConnectionUser] as (
    SELECT  
        c.Id as ConnectionID,
        c.EndPointURL as ConnectionEndpointURL,
        c.FundingAccount as ConnectionFundingAccount,
        l.Id as LedgerID,
        l.Name as LedgerName,
        l.DisplayName as LedgerDisplayName,
        u.[Id] as UserID,
        u.[ExternalId] as UserExternalID,
        u.[ProvisioningStatus] as UserProvisioningStatus,
        u.[FirstName] as UserFirstName,
        u.[LastName] as UserLastName,
        u.[EmailAddress] as UserEmailAddress,
        ucm.ChainIdentifier as UserChainIdentifier
    FROM [dbo].[vwUser] u
    inner join [dbo].UserChainMapping ucm on u.ID = ucm.UserID
    inner join [dbo].Connection c on c.ID = ucm.ConnectionID
    inner join [dbo].Ledger l on l.Id = c.LedgerId
)
