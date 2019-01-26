

CREATE View [dbo].[vwWorkflowFunction]
as (
    Select 
        a.Id as ApplicationId,
        a.[Name] as ApplicationName,
        a.DisplayName as ApplicationDisplayName,
        a.Enabled as ApplicationEnabled,
        a.CreatedDtTm as ApplicationUploadedDtTm,
        w.Id as WorkflowId,
        w.Name as WorkflowName,
        w.DisplayName as WorkflowDisplayName,
        w.Description as WorkflowDescription,
        wf.Id as WorkflowFunctionId, 
        wf.Name WorkflowFunctionName, 
        wf.DisplayName as WorkflowFunctionDisplayName, 
        wf.Description as WorkflowFunctionDescription ,
        IIF ( w.ConstructorId = wf.Id, 'TRUE', 'FALSE' ) AS WorkflowFunctionIsConstructor,
        wfp.Id as WorkflowFunctionParameterId,
        wfp.Name as WorkflowFunctionParameterName,
        wfp.DisplayName as WorkflowFunctionParameterDisplayName,
        wfp.Description as WorkflowFunctionParameterDescription,
        wfp.DataTypeId as WorkflowFunctionParameterDataTypeId, 
        d.Name as WorkflowFunctionParameterDataTypeName
    from [dbo].WorkflowFunction wf 
    inner join [dbo].WorkflowFunctionParameter wfp on wf.Id = wfp.Id
    inner join [dbo].DataType d on wfp.DataTypeId = d.Id
    inner join [dbo].Workflow w on wf.WorkflowId = w.Id
    inner join [dbo].Application a on w.ApplicationId = a.Id
)
