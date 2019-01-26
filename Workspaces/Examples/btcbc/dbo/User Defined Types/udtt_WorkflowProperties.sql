CREATE TYPE [dbo].[udtt_WorkflowProperties] AS TABLE (
    [Name]        NVARCHAR (50)  NOT NULL,
    [Description] NVARCHAR (255) NULL,
    [DisplayName] NVARCHAR (255) NULL,
    [WorkflowId]  INT            NOT NULL,
    [DataTypeId]  INT            NOT NULL);

