CREATE TABLE [dbo].[ApplicationRole] (
    [Id]            INT            IDENTITY (1, 1) NOT NULL,
    [Name]          NVARCHAR (50)  NOT NULL,
    [Description]   NVARCHAR (255) NULL,
    [ApplicationId] INT            NOT NULL,
    CONSTRAINT [PK_ApplicationRole] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_ApplicationRole_Application] FOREIGN KEY ([ApplicationId]) REFERENCES [dbo].[Application] ([Id])
);

