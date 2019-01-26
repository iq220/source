Create View [dbo].[vwApplication] as (
  SELECT a.[Id] as ApplicationId,
      [Name] as ApplicationName,
      [Description] as ApplicationDescription,
      [DisplayName] as DisplayName,
      [Enabled] as ApplicationEnabled,
      [CreatedDtTm] as UploadedDtTm,
      u.Id as UploadedByUserId,
      u.[ExternalId] as UploadedByUserExternalId,
      u.[ProvisioningStatus] as UploadedByUserProvisioningStatus,
      u.[FirstName] as UploadedByUserFirstName,
      u.[LastName] as UploadedByUserLastName,
      u.[EmailAddress] as UploadedByUserEmailAddress
  FROM [dbo].[Application] a
  inner Join [dbo].[vwUser] u on a.[CreatedByUserId] = u.Id
)
