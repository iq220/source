-----------------------------------------------------------------------------
-- Copyright (c) Microsoft Corporation
-----------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[CreateWorkflowStateTransitions]
(
    @Transitions                [dbo].[udtt_WorkflowStateTransitions] READONLY
)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        --  -----------------------------------------------------
        BEGIN TRANSACTION
        --  -----------------------------------------------------            
            -- INSERT Transitions
            INSERT INTO [dbo].[WorkflowStateTransition] 
                ([Description],
                [DisplayName],
                [CurrStateId],
                [WorkflowFunctionId],
                [WorkflowId])
            OUTPUT
                INSERTED.Id,
                INSERTED.Description,
                INSERTED.DisplayName,
                INSERTED.CurrStateId,
                INSERTED.WorkflowFunctionId,
                INSERTED.WorkflowId
            SELECT  
                t.Description,
                t.DisplayName,
                t.CurrStateId,
                t.WorkflowFunctionId,
                t.WorkflowId
            FROM @Transitions AS t
        --  -----------------------------------------------------
        COMMIT TRANSACTION
        --  -----------------------------------------------------

    END TRY

    BEGIN CATCH

        ROLLBACK TRANSACTION;
        THROW;

    END CATCH
END