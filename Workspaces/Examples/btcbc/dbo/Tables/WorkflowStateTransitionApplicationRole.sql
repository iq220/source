CREATE TABLE [dbo].[WorkflowStateTransitionApplicationRole] (
    [Id]                        INT IDENTITY (1, 1) NOT NULL,
    [WorkflowStateTransitionId] INT NOT NULL,
    [ApplicationRoleId]         INT NOT NULL,
    CONSTRAINT [PK_WorkflowStateTransitionApplicationRole] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_WorkflowStateTransitionApplicationRole_ApplicationRole] FOREIGN KEY ([ApplicationRoleId]) REFERENCES [dbo].[ApplicationRole] ([Id]),
    CONSTRAINT [FK_WorkflowStateTransitionApplicationRole_WorkflowStateTransition] FOREIGN KEY ([WorkflowStateTransitionId]) REFERENCES [dbo].[WorkflowStateTransition] ([Id])
);

