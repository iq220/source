-----------------------------------------------------------------------------
-- Copyright (c) Microsoft Corporation
-----------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[CreateWorkflowFunctionParameters]
(
    @Parameters                [dbo].[udtt_WorkflowFunctionParameters] READONLY
)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        --  -----------------------------------------------------
        BEGIN TRANSACTION
        --  -----------------------------------------------------
            
            -- INSERT Parameters
            INSERT INTO [dbo].[WorkflowFunctionParameter] 
                ([Name],
                [Description],
                [DisplayName],
                [WorkflowFunctionId],
                [DataTypeId])
            OUTPUT
                INSERTED.Id,
                INSERTED.Name,
                INSERTED.Description,
                INSERTED.DisplayName,
                INSERTED.WorkflowFunctionId,
                INSERTED.DataTypeId
            SELECT  
                p.Name,
                p.Description,
                p.DisplayName,
                p.WorkflowFunctionId,
                p.DataTypeId
            FROM @Parameters AS p
        --  -----------------------------------------------------
        COMMIT TRANSACTION
        --  -----------------------------------------------------

    END TRY

    BEGIN CATCH

        ROLLBACK TRANSACTION;
        THROW;

    END CATCH
END