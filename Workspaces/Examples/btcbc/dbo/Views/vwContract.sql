/****** Script for SelectTopNRows command from SSMS  ******/
Create View [dbo].[vwContract] as (
    Select 
        conn.Id as ConnectionID,
        conn.EndPointURL as ConnectionEndpointURL,
        conn.FundingAccount as ConnectionFundingAccount,
        l.Id as LedgerID,
        l.Name as LedgerName,
        l.DisplayName as LedgerDisplayName,
        a.Name as [ApplicationName],
        a.DisplayName as [ApplicationDisplayName],
        a.Enabled as [ApplicationEnabled],
        w.[WorkflowId],
        w.[WorkflowName],
        w.[WorkflowDisplayName],
        w.[WorkflowDescription],
        cc.Id as ContractCodeId,
        cc.FileName as ContractFileName,
        cc.CreatedDtTm as ContractUploadedDtTm,
        c.ID as ContractID,
        CASE
            WHEN c.[ProvisioningStatus] IS NOT NULL THEN c.[ProvisioningStatus]
            WHEN cca.ProvisioningStatus IS NULL THEN 2
            ELSE cca.ProvisioningStatus
        End as ContractProvisioningStatus,
        c.LedgerIdentifier as ContractLedgerIdentifier,
        u.[Id] as ContractDeployedByUserID,
        u.[ExternalId] as ContractDeployedByUserExternalID,
        u.[ProvisioningStatus] as ContractDeployedByUserProvisioningStatus,
        u.[FirstName] as ContractDeployedByUserFirstName,
        u.[LastName] as ContractDeployedByUserLastName,
        u.[EmailAddress] as ContractDeployedByUserEmailAddress
    from [dbo].Contract c
    inner join [dbo].Connection conn on c.ConnectionId = conn.Id
    inner join [dbo].Ledger l on conn.LedgerId = l.Id
    inner join [dbo].vwUser u on u.Id = c.DeployedByUserId
    inner join [dbo].ContractCode cc on c.ContractCodeId = cc.id
    inner join [dbo].Application a on a.ID = cc.ApplicationId
    inner join [dbo].vwWorkflow w on c.WorkflowId = w.WorkflowId
    Left Outer Join 
    (select
        ca.[ProvisioningStatus] as ProvisioningStatus,
        ca.[ContractId] as ContractId
     from [dbo].[ContractAction] as ca 
     inner join [dbo].[WorkflowFunction] as wff on wff.[Id] = ca.WorkflowFunctionId AND wff.[Name] = '') cca
     on cca.ContractId = c.[Id]
)
