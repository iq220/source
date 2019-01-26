CREATE TABLE [dbo].[DataType] (
    [Id]            INT           IDENTITY (1, 1) NOT NULL,
    [Name]          NVARCHAR (50) NOT NULL,
    [ElementTypeId] INT           NULL,
    [ApplicationId] INT           NULL,
    CONSTRAINT [PK_DataType] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_DataType_Application] FOREIGN KEY ([ApplicationId]) REFERENCES [dbo].[Application] ([Id]),
    CONSTRAINT [FK_DataType_DataType] FOREIGN KEY ([ElementTypeId]) REFERENCES [dbo].[DataType] ([Id])
);

