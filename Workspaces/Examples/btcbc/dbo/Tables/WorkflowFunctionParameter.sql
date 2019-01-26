CREATE TABLE [dbo].[WorkflowFunctionParameter] (
    [Id]                 INT            IDENTITY (1, 1) NOT NULL,
    [Name]               NVARCHAR (50)  NOT NULL,
    [Description]        NVARCHAR (255) NULL,
    [DisplayName]        NVARCHAR (255) NOT NULL,
    [DataTypeId]         INT            NOT NULL,
    [WorkflowFunctionId] INT            NOT NULL,
    CONSTRAINT [PK_WorkflowFunctionParameter] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_WorkflowFunctionParameter_DataType] FOREIGN KEY ([DataTypeId]) REFERENCES [dbo].[DataType] ([Id]),
    CONSTRAINT [FK_WorkflowFunctionParameter_WorkflowFunction] FOREIGN KEY ([WorkflowFunctionId]) REFERENCES [dbo].[WorkflowFunction] ([Id])
);

