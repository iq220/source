CREATE TABLE [dbo].[ContractCode] (
    [Id]                     INT            IDENTITY (1, 1) NOT NULL,
    [ApplicationId]          INT            NOT NULL,
    [LedgerId]               INT            NOT NULL,
    [CreatedByUserId]        INT            NOT NULL,
    [CreatedDtTm]            DATETIME2 (7)  CONSTRAINT [DF_ContractCode_CreatedDtTm] DEFAULT (sysutcdatetime()) NOT NULL,
    [FileName]               NVARCHAR (50)  NOT NULL,
    [SourceBlobStorageURL]   NVARCHAR (255) NOT NULL,
    [ArtifactBlobStorageURL] NVARCHAR (255) NOT NULL,
    CONSTRAINT [PK_ContractCode] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_ContractCode_Application] FOREIGN KEY ([ApplicationId]) REFERENCES [dbo].[Application] ([Id]),
    CONSTRAINT [FK_ContractCode_Ledger] FOREIGN KEY ([LedgerId]) REFERENCES [dbo].[Ledger] ([Id]),
    CONSTRAINT [FK_ContractCode_User] FOREIGN KEY ([CreatedByUserId]) REFERENCES [dbo].[User] ([Id])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [ContractCode_LedgerId_ApplicationId]
    ON [dbo].[ContractCode]([LedgerId] ASC, [ApplicationId] ASC);

