Create View [dbo].[vwWorkflowProperty] as (
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
        wp.[Id] as WorkflowPropertyId,
        wp.[Name] as WorkflowPropertyName,
        wp.[DisplayName] as WorkflowPropertyDisplayName,
        wp.[Description] as WorkflowPropertyDescription,
        dt.Id as DataTypeId,
        dt.Name as DataTypeName,
        IIF((dt.Name = 'state'), 1,0) as WorkflowPropertyIsState
    FROM 
    [dbo].Application a inner join
    [dbo].Workflow w on a.Id = w.ApplicationId
    inner join  [dbo].[WorkflowProperty] wp on wp.WorkflowId = w.Id
    Inner Join [dbo].DataType dt on wp.DataTypeId = dt.Id
)
