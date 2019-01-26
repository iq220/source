CREATE TABLE [dbo].[ContractProperty] (
    [Id]                 INT             IDENTITY (1, 1) NOT NULL,
    [ContractId]         INT             NOT NULL,
    [WorkflowPropertyId] INT             NOT NULL,
    [Value]              NVARCHAR (4000) NULL,
    [BlockId]            INT             DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_ContractProperty] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_ContractProperty_Block] FOREIGN KEY ([BlockId]) REFERENCES [dbo].[Block] ([ID]),
    CONSTRAINT [FK_ContractProperty_Contract] FOREIGN KEY ([ContractId]) REFERENCES [dbo].[Contract] ([Id]),
    CONSTRAINT [FK_ContractProperty_WorkflowProperty] FOREIGN KEY ([WorkflowPropertyId]) REFERENCES [dbo].[WorkflowProperty] ([Id]),
    CONSTRAINT [UNIQUE_ContractId_WorkflowPropertyId_BlockId] UNIQUE NONCLUSTERED ([ContractId] ASC, [WorkflowPropertyId] ASC, [BlockId] ASC)
);

