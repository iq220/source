Create View [dbo].[vwContractAction] as (
    Select 
        a.Id as ApplicationId,
        a.[Name] as ApplicationName,
        a.DisplayName as ApplicationDisplayName,
        a.Enabled as ApplicationEnabled,
        w.Id as WorkflowId,
        w.Name as WorkflowName,
        w.DisplayName as WorkflowDisplayName,
        w.Description as WorkflowDescription,
        c.Id as ContractId,
        CASE
            WHEN c.[ProvisioningStatus] IS NOT NULL THEN c.[ProvisioningStatus]
            WHEN cca.ProvisioningStatus IS NULL THEN 2
            ELSE cca.ProvisioningStatus
        End as ContractProvisioningStatus,
        c.ConnectionId,
        c.ContractCodeId as ContractCodeId,
        c.LedgerIdentifier as ContractLedgerIdentifier,
        c.DeployedByUserId as ContractDeployedByUserId,
        uwfi.[ExternalId] as ContractDeployedByUserExternalId,
        uwfi.FirstName as ContractDeployedByUserFirstName,
        uwfi.LastName as ContractDeployedByUserLastName,
        uwfi.EmailAddress as ContractDeployedByUserEmailAddress,
        wf.Id as WorkflowFunctionId,
        wf.Name as WorkflowFunctionName,
        wf.DisplayName as WorkflowFunctionDisplayName,
        wf.Description as WorkflowFunctionDescription,
        ca.Id as ContractActionId,
        ca.ProvisioningStatus as ContractActionProvisioningStatus,
        ca.Timestamp as ContractActionTimestamp,
        uwfa.Id as ContractExecutedByUserId,
        uwfa.[ExternalId] as ContractActionExecutedByUserExternalId,
        uwfa.FirstName as ContractActionExecutedByUserFirstName,
        uwfa.LastName as ContractActionExecutedByUserLastName,
        uwfa.EmailAddress as ContractActionExecutedByUserEmailAddress,
        wfp.Id as WorkflowFunctionParameterId,
        wfp.Name as WorkflowFunctionParameterName,
        wfp.DisplayName as WorkflowFunctionParameterDisplayName,
        dt.Id as WorkflowFunctionParameterDataTypeId,
        dt.Name as WorkflowFunctionParameterDataTypeName,
        cap.Id as ContractActionParameterId,
        cap.Value as ContractActionParameterValue,
        b.BlockHash as BlockHash,
        b.BlockNumber as BlockNumber,
        b.BlockTimestamp as BlockTimestamp,
        t.Id as TransactionId,
        t.[From] as TransactionFrom,
        t.[To] as TransactionTo,
        t.TransactionHash as TransactionHash,
        t.IsAppBuilderTx as TransactionIsWorkbenchTransaction,
        t.ProvisioningStatus as TransactionProvisioningStatus,
        t.[Value] as TransactionValue
    from [dbo].ContractActionParameter cap
    Inner join [dbo].ContractAction ca on cap.ContractActionId = ca.Id
    Inner join [dbo].Contract c on ca.ContractId = c.Id
    Inner join [dbo].Workflow w on c.WorkflowId = w.Id
    Inner Join [dbo].WorkflowFunction wf on wf.Id = ca.WorkflowFunctionId
    Left Outer Join [dbo].WorkflowFunctionParameter wfp on wfp.id = cap.WorkflowFunctionParameterId
    Inner Join [dbo].DataType dt on dt.Id = wfp.DataTypeId
    Left Outer Join [dbo].[Transaction] t on t.Id = ca.TransactionId
    Left Outer Join [dbo].[Block] b on b.ID = t.BlockID
    Left Outer Join [dbo].[User] uwfi on c.DeployedByUserId = uwfi.ID
    Left Outer Join [dbo].[User] uwfa on ca.UserId = uwfa.Id
    Inner Join [dbo].Application a on a.Id = w.ApplicationId
    Left Outer Join 
    (select
        ca.[ProvisioningStatus] as ProvisioningStatus,
        ca.[ContractId] as ContractId
     from [dbo].[ContractAction] as ca 
     inner join [dbo].[WorkflowFunction] as wff on wff.[Id] = ca.WorkflowFunctionId AND wff.[Name] = '') cca
     on cca.ContractId = ca.ContractId
)
