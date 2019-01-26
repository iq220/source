CREATE TABLE [dbo].[Workflow] (
    [Id]            INT            IDENTITY (1, 1) NOT NULL,
    [Name]          NVARCHAR (50)  NOT NULL,
    [Description]   NVARCHAR (255) NULL,
    [DisplayName]   NVARCHAR (255) NOT NULL,
    [ApplicationId] INT            NOT NULL,
    [ConstructorId] INT            NULL,
    [StartStateId]  INT            NULL,
    CONSTRAINT [PK_Workflow] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Workflow_Application] FOREIGN KEY ([ApplicationId]) REFERENCES [dbo].[Application] ([Id])
);


GO
CREATE NONCLUSTERED INDEX [Workflow_Name]
    ON [dbo].[Workflow]([Name] ASC);

