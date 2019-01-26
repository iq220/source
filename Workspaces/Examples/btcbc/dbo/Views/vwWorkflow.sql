Create View [dbo].[vwWorkflow] as (
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
    wf.Id as WorkflowContructorFunctionId,
    ws.Id as WorkflowStartStateId,
    ws.Name as WorkflowStartStateName,
    ws.DisplayName as WorkflowStartStateDisplayName,
    ws.[Description] as WorkflowStartStateDescription,
    ws.[Style] as WorkflowStartStateStyle,
    ws.[Value] as WorkflowStartStateValue,
    ws.PercentComplete as WorkflowStartStatePercentComplete
    from 
    [dbo].[Application] a 
    inner join [dbo].Workflow w on a.id = w.ApplicationId 
    Inner join [dbo].WorkflowFunction wf on wf.Id = w.ConstructorId
    Inner Join [dbo].WorkflowState ws on w.StartStateId = ws.Id
)
