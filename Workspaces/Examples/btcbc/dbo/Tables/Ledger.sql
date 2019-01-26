CREATE TABLE [dbo].[Ledger] (
    [Id]          INT            IDENTITY (1, 1) NOT NULL,
    [Name]        NVARCHAR (50)  NOT NULL,
    [DisplayName] NVARCHAR (255) NOT NULL,
    CONSTRAINT [PK_Ledger] PRIMARY KEY CLUSTERED ([Id] ASC)
);

