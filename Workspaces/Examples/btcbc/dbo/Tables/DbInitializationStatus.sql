CREATE TABLE [dbo].[DbInitializationStatus] (
    [Id]              INT          IDENTITY (1, 1) NOT NULL,
    [Initialized]     BIT          DEFAULT ((0)) NOT NULL,
    [DbSchemaVersion] VARCHAR (16) NOT NULL,
    CONSTRAINT [PK_ID] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [CK_ID] CHECK ([Id]=(1))
);

