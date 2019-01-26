Create View [dbo].[vwApplicationRoleUser] as (
    SELECT  
        a.Id as ApplicationId,
        a.[Name] as ApplicationName,
        a.DisplayName as ApplicationDisplayName,
        a.Enabled as ApplicationEnabled,
        ar.Id as ApplicationRoleID,
        ar.Description as ApplicationRoleDescription,
        ar.Name as ApplicationRoleName,
        u.[Id] as UserID,
        u.[ExternalId] as UserExternalID,
        u.[ProvisioningStatus] as UserProvisioningStatus,
        u.[FirstName] as UserFirstName,
        u.[LastName] as UserLastName,
        u.[EmailAddress] as UserEmailAddress
    FROM [dbo].[Application] a
    inner join [dbo].ApplicationRole ar on a.Id = ar.ApplicationId
    inner join [dbo].RoleAssignment ra on ra.ApplicationRoleID = ar.Id
    inner join [dbo].vwUser u on u.Id = ra.UserId
)
