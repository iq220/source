-----------------------------------------------------------------------------
-- Copyright (c) Microsoft Corporation
-----------------------------------------------------------------------------

-----------------------------------------------------------------------------
-- Procedure: CreateApplicationRolesAndWorkflows
--
-- Purpose: Insert a new Application and the Application Roles and Workflows
-----------------------------------------------------------------------------
--    Given the application details (Name, Description, DisplayName, CreatedByUserId, Enabled, BlobStorageURL),
--        a table of ApplicationRoles (defined by udtt_ApplicationRoles)
--        AND a table of Workflows (defined by udtt_Workflows)
--    ---------------------------------------------------------------
--    Returns a. The ID of the newly inserted Application
--            b. ApplicationRoles rows inserted
--            c. Workflows rows inserted.
--    ---------------------------------------------------------------

CREATE PROCEDURE [dbo].[CreateApplicationRolesAndWorkflows]
(
    @ApplicationName NVARCHAR (50),
    @ApplicationDescription      NVARCHAR (255),
    @ApplicationDisplayName      NVARCHAR (255),
    @ApplicationCreatedByUserId  NVARCHAR (255),
    @ApplicationEnabled          BIT,
    @ApplicationBlobStorageURL   NVARCHAR (255),
    @ApplicationRoles            [dbo].[udtt_ApplicationRoles] READONLY,
    @Workflows                   [dbo].[udtt_Workflows] READONLY
)
AS
BEGIN
    DECLARE @NewApplicationId     INTEGER = -1;
    DECLARE @ErrorMessage NVARCHAR(255)

    SET NOCOUNT ON;

    IF EXISTS (SELECT [Name] FROM [dbo].[Application] AS a WHERE a.[Name] = @ApplicationName) 
    BEGIN
      SET @ErrorMessage = 'Application with name ' + @ApplicationName + ' already exists.';
		  THROW 55200, @Errormessage,0;
    END

    BEGIN TRY
        --  -----------------------------------------------------
        BEGIN TRANSACTION
        --  -----------------------------------------------------
            -- INSERT Application
            INSERT INTO [dbo].[Application]
                ([Name],
                [Description],
                [DisplayName],
                [CreatedByUserId],
                [CreatedDtTm],
                [Enabled],
                [BlobStorageURL])
            VALUES 
                (@ApplicationName,
                @ApplicationDescription, 
                @ApplicationDisplayName, 
                @ApplicationCreatedByUserId, 
                GETUTCDATE(), 
                @ApplicationEnabled,
                @ApplicationBlobStorageURL)

            SELECT @NewApplicationId = SCOPE_IDENTITY()
            SELECT @NewApplicationId;

            -- INSERT Application Roles
            INSERT INTO [dbo].[ApplicationRole] 
                ([Name],
                [Description],
                [ApplicationId])
            OUTPUT
                INSERTED.Id,
                INSERTED.Name,
                INSERTED.Description,
                INSERTED.ApplicationId
            SELECT  
                ar.Name,
                ar.Description,
                @NewApplicationId
            FROM @ApplicationRoles AS ar

            -- INSERT Workflows
            INSERT INTO [dbo].[Workflow] 
                ([Name],
                [Description],
                [DisplayName],
                [ApplicationId])
            OUTPUT
                INSERTED.Id,
                INSERTED.Name,
                INSERTED.Description,
                INSERTED.DisplayName,
                INSERTED.ApplicationId
            SELECT  
                w.Name,
                w.Description,
                w.DisplayName,
                @NewApplicationId
            FROM @Workflows AS w
        --  -----------------------------------------------------
        COMMIT TRANSACTION
        --  -----------------------------------------------------

    END TRY

    BEGIN CATCH

        ROLLBACK TRANSACTION;
        THROW;

    END CATCH
END