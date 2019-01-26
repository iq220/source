CREATE TABLE [dbo].[ContractActionParameter] (
    [Id]                          INT             IDENTITY (1, 1) NOT NULL,
    [ContractActionId]            INT             NOT NULL,
    [WorkflowFunctionParameterId] INT             NOT NULL,
    [Value]                       NVARCHAR (4000) NULL,
    CONSTRAINT [PK_ContractActionParameter] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_ContractActionParameter_ContractAction] FOREIGN KEY ([ContractActionId]) REFERENCES [dbo].[ContractAction] ([Id]),
    CONSTRAINT [FK_ContractActionParameter_WorkflowFunctionParameter] FOREIGN KEY ([WorkflowFunctionParameterId]) REFERENCES [dbo].[WorkflowFunctionParameter] ([Id])
);

