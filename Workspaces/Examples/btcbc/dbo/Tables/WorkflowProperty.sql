CREATE TABLE [dbo].[WorkflowProperty] (
    [Id]          INT            IDENTITY (1, 1) NOT NULL,
    [Name]        NVARCHAR (50)  NOT NULL,
    [Description] NVARCHAR (255) NULL,
    [DisplayName] NVARCHAR (255) NOT NULL,
    [WorkflowId]  INT            NOT NULL,
    [DataTypeId]  INT            NOT NULL,
    CONSTRAINT [PK_WorkflowProperty] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_WorkflowProperty_DataType] FOREIGN KEY ([DataTypeId]) REFERENCES [dbo].[DataType] ([Id]),
    CONSTRAINT [FK_WorkflowProperty_Workflow] FOREIGN KEY ([WorkflowId]) REFERENCES [dbo].[Workflow] ([Id])
);

