-----------------------------------------------------------------------------
-- Copyright (c) Microsoft Corporation
-----------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[CreatePropertiesFunctionsAndStates]
(
    @Properties            [dbo].[udtt_WorkflowProperties] READONLY,
    @Functions             [dbo].[udtt_WorkflowFunctions] READONLY,
    @States                [dbo].[udtt_WorkflowStates] READONLY
)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        --  -----------------------------------------------------
        BEGIN TRANSACTION
        --  -----------------------------------------------------
            
            -- INSERT Properties
            INSERT INTO [dbo].[WorkflowProperty] 
                ([Name],
                [Description],
                [DisplayName],
                [WorkflowId],
                [DataTypeId])
            OUTPUT
                INSERTED.Id,
                INSERTED.Name,
                INSERTED.Description,
                INSERTED.DisplayName,
                INSERTED.WorkflowId,
                INSERTED.DataTypeId
            SELECT  
                p.Name,
                p.Description,
                p.DisplayName,
                p.WorkflowId,
                p.DataTypeId
            FROM @Properties AS p

            -- INSERT Functions
            INSERT INTO [dbo].[WorkflowFunction] 
                ([Name],
                [Description],
                [DisplayName],
                [WorkflowId])
            OUTPUT
                INSERTED.Id,
                INSERTED.Name,
                INSERTED.Description,
                INSERTED.DisplayName,
                INSERTED.WorkflowId
            SELECT  
                f.Name,
                f.Description,
                f.DisplayName,
                f.WorkflowId
            FROM @Functions AS f

            -- INSERT States
            INSERT INTO [dbo].[WorkflowState] 
                ([Name],
                [Description],
                [DisplayName],
                [PercentComplete],
                [Value],
                [Style], 
                [WorkflowId])
            OUTPUT
                INSERTED.Id,
                INSERTED.Name,
                INSERTED.Description,
                INSERTED.DisplayName,
                INSERTED.PercentComplete,
                INSERTED.Value,
                INSERTED.Style,
                INSERTED.WorkflowId
            SELECT  
                w.Name,
                w.Description,
                w.DisplayName,
                w.PercentComplete,
                w.Value,
                w.Style,
                w.WorkflowId
            FROM @States AS w
        --  -----------------------------------------------------
        COMMIT TRANSACTION
        --  -----------------------------------------------------

    END TRY

    BEGIN CATCH

        ROLLBACK TRANSACTION;
        THROW;

    END CATCH
END