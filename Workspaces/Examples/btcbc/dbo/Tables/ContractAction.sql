CREATE TABLE [dbo].[ContractAction] (
    [Id]                 INT           IDENTITY (1, 1) NOT NULL,
    [ContractId]         INT           NOT NULL,
    [UserId]             INT           NOT NULL,
    [ProvisioningStatus] INT           NOT NULL,
    [Timestamp]          DATETIME2 (7) CONSTRAINT [DF_ContractAction_Timestamp] DEFAULT (sysutcdatetime()) NOT NULL,
    [WorkflowFunctionId] INT           NOT NULL,
    [TransactionId]      INT           NULL,
    [WorkflowStateId]    INT           NULL,
    [SequenceNumber]     INT           NULL,
    [LastSweepTimestamp] DATETIME2 (7) NULL,
    [RequestId]          NVARCHAR (50) NULL,
    CONSTRAINT [PK_ContractAction] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_ContractAction_Contract] FOREIGN KEY ([ContractId]) REFERENCES [dbo].[Contract] ([Id]),
    CONSTRAINT [FK_ContractAction_Transaction] FOREIGN KEY ([TransactionId]) REFERENCES [dbo].[Transaction] ([Id]),
    CONSTRAINT [FK_ContractAction_User] FOREIGN KEY ([UserId]) REFERENCES [dbo].[User] ([Id]),
    CONSTRAINT [FK_ContractAction_WorkflowFunction] FOREIGN KEY ([WorkflowFunctionId]) REFERENCES [dbo].[WorkflowFunction] ([Id]),
    CONSTRAINT [FK_ContractAction_WorkflowState] FOREIGN KEY ([WorkflowStateId]) REFERENCES [dbo].[WorkflowState] ([Id])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [ContractAction_RequestId]
    ON [dbo].[ContractAction]([RequestId] ASC) WHERE ([RequestId] IS NOT NULL);

