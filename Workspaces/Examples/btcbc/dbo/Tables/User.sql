CREATE TABLE [dbo].[User] (
    [Id]                 INT            IDENTITY (1, 1) NOT NULL,
    [ProvisioningStatus] INT            NOT NULL,
    [ExternalId]         NVARCHAR (255) NOT NULL,
    [FirstName]          NVARCHAR (256) NULL,
    [LastName]           NVARCHAR (64)  NULL,
    [EmailAddress]       NVARCHAR (255) NULL,
    CONSTRAINT [PK_User] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [CK_User_ProvisioningStatus] CHECK ([ProvisioningStatus]=(2) OR [ProvisioningStatus]=(1) OR [ProvisioningStatus]=(0)),
    CONSTRAINT [UC_User_ExternalId] UNIQUE NONCLUSTERED ([ExternalId] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [User_ExternalId]
    ON [dbo].[User]([ExternalId] ASC);


GO
CREATE NONCLUSTERED INDEX [User_FirstName]
    ON [dbo].[User]([FirstName] ASC);

