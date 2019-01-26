CREATE TABLE [dbo].[WorkflowInitiator] (
    [Id]                INT IDENTITY (1, 1) NOT NULL,
    [WorkflowId]        INT NOT NULL,
    [ApplicationRoleId] INT NOT NULL,
    CONSTRAINT [PK_WorkflowInitiator] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_WorkflowInitiator_ApplicationRole] FOREIGN KEY ([ApplicationRoleId]) REFERENCES [dbo].[ApplicationRole] ([Id]),
    CONSTRAINT [FK_WorkflowInitiator_Workflow] FOREIGN KEY ([WorkflowId]) REFERENCES [dbo].[Workflow] ([Id])
);

