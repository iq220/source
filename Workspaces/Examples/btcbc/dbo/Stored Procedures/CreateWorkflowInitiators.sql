-----------------------------------------------------------------------------
-- Copyright (c) Microsoft Corporation
-----------------------------------------------------------------------------

-----------------------------------------------------------------------------
-- Procedure: CreateWorkflowInitiators
--
-- Purpose: Insert a list of WorkflowInitiators
-----------------------------------------------------------------------------
--    Given a table of WorkflowInititors (defined by udtt_WorkflowInitiators)
--    ---------------------------------------------------------------
--    Returns number of WorkflowInitiators rows inserted
--    ---------------------------------------------------------------
CREATE PROCEDURE [dbo].[CreateWorkflowInitiators]
(
    @WorkflowInitiators         [dbo].[udtt_WorkflowInitiators] READONLY
)
AS
BEGIN
	SET NOCOUNT ON
    DECLARE @RowCount INT;
    BEGIN TRY
        --  -----------------------------------------------------
        BEGIN TRANSACTION
        --  -----------------------------------------------------
            INSERT INTO [dbo].[WorkflowInitiator] 
                ([WorkflowId],
                [ApplicationRoleId])
            SELECT  
                wi.WorkflowId,
                wi.ApplicationRoleId
            FROM @WorkflowInitiators AS wi

            SELECT @RowCount = @@ROWCOUNT;
        --  -----------------------------------------------------
        COMMIT TRANSACTION
        --  -----------------------------------------------------

        SELECT @RowCount as RowsInserted;
    END TRY

    BEGIN CATCH

        ROLLBACK TRANSACTION;
        THROW;

    END CATCH
END