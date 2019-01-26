CREATE TABLE [dbo].[Block] (
    [ID]             INT            IDENTITY (1, 1) NOT NULL,
    [ConnectionID]   INT            NOT NULL,
    [BlockHash]      NVARCHAR (255) NOT NULL,
    [BlockNumber]    INT            NOT NULL,
    [BlockTimestamp] DATETIME2 (7)  NOT NULL,
    CONSTRAINT [PK_Block] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_Block_Connection] FOREIGN KEY ([ConnectionID]) REFERENCES [dbo].[Connection] ([Id])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [Block_BlockHash]
    ON [dbo].[Block]([BlockHash] ASC);


GO
CREATE NONCLUSTERED INDEX [Block_BlockNumber]
    ON [dbo].[Block]([BlockNumber] ASC);

