CREATE TYPE [dbo].[udtt_WorkflowStates] AS TABLE (
    [Name]            NVARCHAR (50)  NOT NULL,
    [Description]     NVARCHAR (255) NULL,
    [DisplayName]     NVARCHAR (255) NULL,
    [PercentComplete] INT            NOT NULL,
    [Value]           INT            NOT NULL,
    [Style]           NVARCHAR (50)  NOT NULL,
    [WorkflowId]      INT            NOT NULL);

