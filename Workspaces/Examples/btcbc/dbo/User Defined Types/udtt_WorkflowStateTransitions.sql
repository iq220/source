CREATE TYPE [dbo].[udtt_WorkflowStateTransitions] AS TABLE (
    [Description]        NVARCHAR (255) NULL,
    [DisplayName]        NVARCHAR (255) NULL,
    [CurrStateId]        INT            NOT NULL,
    [WorkflowFunctionId] INT            NOT NULL,
    [WorkflowId]         INT            NOT NULL);

