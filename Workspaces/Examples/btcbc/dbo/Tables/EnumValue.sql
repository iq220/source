CREATE TABLE [dbo].[EnumValue] (
    [Id]         INT            IDENTITY (1, 1) NOT NULL,
    [Name]       NVARCHAR (255) NOT NULL,
    [Value]      INT            NOT NULL,
    [DataTypeId] INT            NOT NULL,
    CONSTRAINT [PK_EnumValue] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_EnumValue_DataTypeId] FOREIGN KEY ([DataTypeId]) REFERENCES [dbo].[DataType] ([Id])
);

