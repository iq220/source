CREATE TABLE [dbo].[WorkflowFunction] (
    [Id]          INT            IDENTITY (1, 1) NOT NULL,
    [Name]        NVARCHAR (50)  NULL,
    [Description] NVARCHAR (255) NULL,
    [DisplayName] NVARCHAR (255) NOT NULL,
    [WorkflowId]  INT            NOT NULL,
    CONSTRAINT [PK_WorkflowFunction] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_WorkflowFunction_Workflow] FOREIGN KEY ([WorkflowId]) REFERENCES [dbo].[Workflow] ([Id])
);

