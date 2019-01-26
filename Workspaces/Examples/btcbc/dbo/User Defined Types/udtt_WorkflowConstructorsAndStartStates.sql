CREATE TYPE [dbo].[udtt_WorkflowConstructorsAndStartStates] AS TABLE (
    [WorkflowId]    INT NOT NULL,
    [ConstructorId] INT NOT NULL,
    [StartStateId]  INT NOT NULL);

