CREATE TABLE [dbo].[WorkflowStateTransition] (
    [Id]                 INT            IDENTITY (1, 1) NOT NULL,
    [Description]        NVARCHAR (255) NULL,
    [DisplayName]        NVARCHAR (255) NOT NULL,
    [CurrStateId]        INT            NOT NULL,
    [WorkflowFunctionId] INT            NOT NULL,
    [WorkflowId]         INT            NOT NULL,
    CONSTRAINT [PK_WorkflowStateTransition] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_WorkflowStateTransition_Workflow] FOREIGN KEY ([WorkflowId]) REFERENCES [dbo].[Workflow] ([Id]),
    CONSTRAINT [FK_WorkflowStateTransition_WorkflowFunction] FOREIGN KEY ([WorkflowFunctionId]) REFERENCES [dbo].[WorkflowFunction] ([Id]),
    CONSTRAINT [FK_WorkflowStateTransition_WorkflowState_CurrState] FOREIGN KEY ([CurrStateId]) REFERENCES [dbo].[WorkflowState] ([Id])
);

