CREATE TABLE [dbo].[RoleAssignment] (
    [Id]                INT IDENTITY (1, 1) NOT NULL,
    [UserId]            INT NOT NULL,
    [ApplicationRoleId] INT NOT NULL,
    CONSTRAINT [PK_RoleAssignment] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_RoleAssignment_ApplicationRole] FOREIGN KEY ([ApplicationRoleId]) REFERENCES [dbo].[ApplicationRole] ([Id]),
    CONSTRAINT [FK_RoleAssignment_User] FOREIGN KEY ([UserId]) REFERENCES [dbo].[User] ([Id]),
    CONSTRAINT [UC_User_Id_ApplicationRole_Id] UNIQUE NONCLUSTERED ([UserId] ASC, [ApplicationRoleId] ASC)
);

