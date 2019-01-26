Create View [dbo].[vwWorkflowState] as (
    SELECT
        a.Id as ApplicationId,
        a.[Name] as ApplicationName,
        a.DisplayName as ApplicationDisplayName,
        a.Enabled as ApplicationEnabled,
        a.CreatedDtTm as ApplicationUploadedDtTm,
        w.Id as WorkflowId,
        w.Name as WorkflowName,
        w.DisplayName as WorkflowDisplayName,
        w.Description as WorkflowDescription,
        ws.[Id] as WorkflowStateId,
        ws.[Name] as WorkflowStateName,
        ws.[Description] as WorkflowStateDescription,
        ws.[DisplayName] as WorkflowStateDisplayName,
        ws.[PercentComplete] as WorkflowStatePercentComplete,
        ws.[Value] as WorkflowStateValue,
        ws.[Style] as WorkflowStateStyle

    From Application a inner join
    [dbo].Workflow w on a.Id = w.ApplicationId 
    inner join [dbo].WorkflowState ws on ws.WorkflowId = w.Id
)
