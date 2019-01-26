CREATE TABLE [dbo].[Connection] (
    [Id]             INT            IDENTITY (1, 1) NOT NULL,
    [LedgerId]       INT            NOT NULL,
    [EndPointURL]    NVARCHAR (255) NOT NULL,
    [FundingAccount] NVARCHAR (255) NULL,
    CONSTRAINT [PK_Connection] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Connection_Ledger] FOREIGN KEY ([LedgerId]) REFERENCES [dbo].[Ledger] ([Id])
);

