-----------------------------------------------------------------------------
-- Copyright (c) Microsoft Corporation
-----------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[CreateWorkflowStateTransitionApplicationRolesAndInstanceRoles]
(
    @ApplicationRoles             [dbo].[udtt_WorkflowStateTransitionApplicationRoles] READONLY,
    @InstanceRoles     [dbo].[udtt_WorkflowStateTransitionInstanceRoles] READONLY
)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        --  -----------------------------------------------------
        BEGIN TRANSACTION
        --  -----------------------------------------------------
            
            -- INSERT ApplicationRoles
            INSERT INTO [dbo].[WorkflowStateTransitionApplicationRole] 
                ([ApplicationRoleId],
                [WorkflowStateTransitionId])
            OUTPUT
                INSERTED.Id,
                INSERTED.ApplicationRoleId,
                INSERTED.WorkflowStateTransitionId
            SELECT  
                ar.ApplicationRoleId,
                ar.WorkflowStateTransitionId
            FROM @ApplicationRoles AS ar

            -- INSERT InstanceRoles
            INSERT INTO [dbo].[WorkflowStateTransitionInstanceRole] 
                ([WorkflowPropertyId],
                 [WorkflowStateTransitionId])
            OUTPUT
                INSERTED.Id,
                INSERTED.WorkflowPropertyId,
                INSERTED.WorkflowStateTransitionId
            SELECT  
                ir.WorkflowPropertyId,
                ir.WorkflowStateTransitionId
            FROM @InstanceRoles AS ir
        --  -----------------------------------------------------
        COMMIT TRANSACTION
        --  -----------------------------------------------------

    END TRY

    BEGIN CATCH

        ROLLBACK TRANSACTION;
        THROW;

    END CATCH
END