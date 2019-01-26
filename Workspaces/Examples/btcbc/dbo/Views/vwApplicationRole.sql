Create View [dbo].[vwApplicationRole] as (
    SELECT  
        a.[Id] as ApplicationId,
        a.[Name] as ApplicationName,
        a.[Description] as ApplicationDescription,
        a.[DisplayName] as ApplicationDisplayName,
        r.[Id] as ApplicationRoleId,
        r.[Name] as ApplicationRoleName,
        r.[Description] as ApplicationRoleDescription
    FROM [dbo].[ApplicationRole] r 
    inner join [dbo].Application a on r.ApplicationId = a.Id
)
