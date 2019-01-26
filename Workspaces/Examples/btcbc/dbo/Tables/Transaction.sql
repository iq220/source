CREATE TABLE [dbo].[Transaction] (
    [Id]                 INT             IDENTITY (1, 1) NOT NULL,
    [ConnectionID]       INT             NOT NULL,
    [BlockID]            INT             NULL,
    [TransactionHash]    NVARCHAR (255)  NOT NULL,
    [From]               NVARCHAR (255)  NOT NULL,
    [To]                 NVARCHAR (255)  NULL,
    [Value]              DECIMAL (32, 2) NULL,
    [IsAppBuilderTx]     BIT             NOT NULL,
    [ProvisioningStatus] INT             NOT NULL,
    [EstimatedGas]       NVARCHAR (255)  NULL,
    CONSTRAINT [PK_Transaction] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Transaction_Block] FOREIGN KEY ([BlockID]) REFERENCES [dbo].[Block] ([ID]),
    CONSTRAINT [FK_Transaction_Connection] FOREIGN KEY ([ConnectionID]) REFERENCES [dbo].[Connection] ([Id])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [Transaction_TransactionHash]
    ON [dbo].[Transaction]([TransactionHash] ASC);

