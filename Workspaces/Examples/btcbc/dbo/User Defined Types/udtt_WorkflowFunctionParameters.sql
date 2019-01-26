CREATE TYPE [dbo].[udtt_WorkflowFunctionParameters] AS TABLE (
    [Name]               NVARCHAR (50)  NOT NULL,
    [Description]        NVARCHAR (255) NULL,
    [DisplayName]        NVARCHAR (255) NULL,
    [DataTypeId]         INT            NOT NULL,
    [WorkflowFunctionId] INT            NOT NULL);

