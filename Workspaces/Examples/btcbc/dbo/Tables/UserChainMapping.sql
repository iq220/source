CREATE TABLE [dbo].[UserChainMapping] (
    [ID]                 INT             IDENTITY (1, 1) NOT NULL,
    [UserID]             INT             NOT NULL,
    [ConnectionID]       INT             NOT NULL,
    [ChainIdentifier]    NVARCHAR (255)  NULL,
    [ChainBalance]       DECIMAL (32, 2) NULL,
    [NextSequenceNumber] INT             NULL,
    [LastSweepTimestamp] DATETIME2 (7)   NULL,
    [BaseNonce]          BIGINT          NULL,
    [RequestId]          NVARCHAR (50)   NULL,
    CONSTRAINT [PK_UserChainMapping] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_UserChainMapping_Connection] FOREIGN KEY ([ConnectionID]) REFERENCES [dbo].[Connection] ([Id]),
    CONSTRAINT [FK_UserChainMapping_User] FOREIGN KEY ([UserID]) REFERENCES [dbo].[User] ([Id])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UserChainMapping_UserID_ConnectionID]
    ON [dbo].[UserChainMapping]([UserID] ASC, [ConnectionID] ASC);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UserChainMapping_ChainIdentifier]
    ON [dbo].[UserChainMapping]([ChainIdentifier] ASC) WHERE ([ChainIdentifier] IS NOT NULL);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UserChainMapping_RequestId]
    ON [dbo].[UserChainMapping]([RequestId] ASC) WHERE ([RequestId] IS NOT NULL);

