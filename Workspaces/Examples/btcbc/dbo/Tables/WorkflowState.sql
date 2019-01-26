CREATE TABLE [dbo].[WorkflowState] (
    [Id]              INT            IDENTITY (1, 1) NOT NULL,
    [Name]            NVARCHAR (50)  NOT NULL,
    [Description]     NVARCHAR (255) NULL,
    [DisplayName]     NVARCHAR (255) NOT NULL,
    [PercentComplete] INT            NOT NULL,
    [Value]           INT            NOT NULL,
    [Style]           NVARCHAR (50)  NOT NULL,
    [WorkflowId]      INT            NOT NULL,
    CONSTRAINT [PK_WorkflowState] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_WorkflowState_Workflow] FOREIGN KEY ([WorkflowId]) REFERENCES [dbo].[Workflow] ([Id])
);

