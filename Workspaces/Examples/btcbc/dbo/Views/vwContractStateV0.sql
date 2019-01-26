Create View [dbo].[vwContractStateV0] as (
    Select 
        a.Id as ApplicationId,
        a.[Name] as ApplicationName,
        a.DisplayName as ApplicationDisplayName,
        a.Enabled as ApplicationEnabled,
        w.Id as WorkflowId,
        w.Name as WorkflowName,
        w.DisplayName as WorkflowDisplayName,
        w.Description as WorkflowDescription,
        wfi.LedgerIdentifier as ContractLedgerIdentifier,
        wfi.Id as ContractId,
        CASE
            WHEN wfi.[ProvisioningStatus] IS NOT NULL THEN wfi.[ProvisioningStatus]
            WHEN cca.ProvisioningStatus IS NULL THEN 2
            WHEN cca.ProvisioningStatus = 3 THEN 0
            WHEN cca.ProvisioningStatus = 4 THEN 0
            WHEN cca.ProvisioningStatus = 5 THEN 1
            ELSE cca.ProvisioningStatus
        End as ContractProvisioningStatus,
        wfi.ConnectionId,
        wfi.ContractCodeId as ContractCodeId,
        wfi.DeployedByUserId as ContractDeployedByUserId,
        uwfi.FirstName as ContractDeployedByUserFirstName,
        uwfi.LastName as ContractDeployedByUserLastName,
        uwfi.ExternalId as ContractDeployedByUserExternalId,
        uwfi.EmailAddress as ContractDeployedByUserEmailAddress,
        wfp.Id as WorkflowPropertyId,
        dt.Id as WorkflowPropertyDataTypeId,
        dt.Name as WorkflowPropertyDataTypeName,
        wfp.Name as WorkflowPropertyName,
        wfp.DisplayName as WorkflowPropertyDisplayName,
        wfp.Description as WorkflowPropertyDescription,
        wfip.Value as ContractPropertyValue,
        ws.Name as StateName,
        ws.DisplayName as StateDisplayName,
        ws.StateValue as StateValue
    from 
    [dbo].Contract wfi 
    inner join [dbo].Workflow w  on wfi.WorkflowId = w.Id 
    inner join [dbo].ContractProperty wfip on wfip.ContractId = wfi.Id
    inner join [dbo].[Application] a on a.id = w.ApplicationId 
    inner join [dbo].WorkflowProperty wfp on wfp.Id = wfip.WorkflowPropertyId and wfp.Name='State'
    Inner Join [dbo].DataType dt on dt.Id = wfp.DataTypeId
    Left Outer Join [dbo].[User] uwfi on wfi.DeployedByUserId = uwfi.ID
    Left Outer Join ( select Id, WorkflowId, Name, Description, DisplayName, PercentComplete, Cast([Value] AS nvarchar(255)) as StateValue, Style from [dbo].WorkflowState) ws
    on ws.WorkflowId = w.Id and ws.StateValue  = wfip.[Value]
    Left Outer Join 
    (select
        ca.[ProvisioningStatus] as ProvisioningStatus,
        ca.[ContractId] as ContractId
     from [dbo].[ContractAction] as ca 
     inner join [dbo].[WorkflowFunction] as wff on wff.[Id] = ca.WorkflowFunctionId AND wff.[Name] = '') cca
     on cca.ContractId = wfi.[Id]
    where dt.Name = 'state'
)
