-----------------------------------------------------------------------------
-- Copyright (c) Microsoft Corporation
-----------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[UpdateWorkflowConstructorsAndStartStates]
    @WorkflowConstructorsAndStartStates [dbo].[udtt_WorkflowConstructorsAndStartStates] READONLY
AS
BEGIN
    UPDATE [dbo].[Workflow]
	SET ConstructorId = t.ConstructorId, StartStateId = t.StartStateId
    FROM @WorkflowConstructorsAndStartStates AS t
	WHERE [dbo].[Workflow].Id = t.WorkflowId 
END