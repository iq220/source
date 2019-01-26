CREATE TABLE [dbo].[Application] (
    [Id]              INT            IDENTITY (1, 1) NOT NULL,
    [Name]            NVARCHAR (50)  NOT NULL,
    [Description]     NVARCHAR (255) NULL,
    [DisplayName]     NVARCHAR (255) NOT NULL,
    [CreatedByUserId] INT            NOT NULL,
    [CreatedDtTm]     DATETIME2 (7)  CONSTRAINT [DF_Application_CreatedDtTm] DEFAULT (sysutcdatetime()) NOT NULL,
    [Enabled]         BIT            DEFAULT ((1)) NOT NULL,
    [BlobStorageURL]  NVARCHAR (255) NOT NULL,
    CONSTRAINT [PK_Application] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Application_User] FOREIGN KEY ([CreatedByUserId]) REFERENCES [dbo].[User] ([Id])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [Application_Name]
    ON [dbo].[Application]([Name] ASC);

