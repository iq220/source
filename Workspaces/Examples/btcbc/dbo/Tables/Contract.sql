CREATE TABLE [dbo].[Contract] (
    [Id]                 INT            IDENTITY (1, 1) NOT NULL,
    [ProvisioningStatus] INT            NULL,
    [Timestamp]          DATETIME2 (7)  CONSTRAINT [DF_Contract_Timestamp] DEFAULT (sysutcdatetime()) NOT NULL,
    [ConnectionId]       INT            NOT NULL,
    [LedgerIdentifier]   NVARCHAR (255) NULL,
    [DeployedByUserId]   INT            NOT NULL,
    [WorkflowId]         INT            NOT NULL,
    [ContractCodeId]     INT            NOT NULL,
    CONSTRAINT [PK_Contract] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Contract_Connection] FOREIGN KEY ([ConnectionId]) REFERENCES [dbo].[Connection] ([Id]),
    CONSTRAINT [FK_Contract_ContractCode] FOREIGN KEY ([ContractCodeId]) REFERENCES [dbo].[ContractCode] ([Id]),
    CONSTRAINT [FK_Contract_User] FOREIGN KEY ([DeployedByUserId]) REFERENCES [dbo].[User] ([Id]),
    CONSTRAINT [FK_Contract_Workflow] FOREIGN KEY ([WorkflowId]) REFERENCES [dbo].[Workflow] ([Id])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [Contract_LedgerIdentifier]
    ON [dbo].[Contract]([LedgerIdentifier] ASC) WHERE ([LedgerIdentifier] IS NOT NULL);

