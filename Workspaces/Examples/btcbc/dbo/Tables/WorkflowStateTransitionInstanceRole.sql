CREATE TABLE [dbo].[WorkflowStateTransitionInstanceRole] (
    [Id]                        INT IDENTITY (1, 1) NOT NULL,
    [WorkflowStateTransitionId] INT NOT NULL,
    [WorkflowPropertyId]        INT NOT NULL,
    CONSTRAINT [PK_WorkflowStateTransitionInstanceRole] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_WorkflowStateTransitionInstanceRole_WorkflowProperty] FOREIGN KEY ([WorkflowPropertyId]) REFERENCES [dbo].[WorkflowProperty] ([Id]),
    CONSTRAINT [FK_WorkflowStateTransitionInstanceRole_WorkflowStateTransition] FOREIGN KEY ([WorkflowStateTransitionId]) REFERENCES [dbo].[WorkflowStateTransition] ([Id])
);

