CREATE PROCEDURE [dbo].[UpdateContractActionWorkflowState]
(
    @ContractActionId INT,
    @WorkflowId INT,
    @WorkflowStateValue INT
)
AS
BEGIN
    UPDATE [dbo].[ContractAction] 
    SET [WorkflowStateId] = 
        (SELECT wfs.[Id]
        FROM [dbo].[WorkflowState] as wfs
        WHERE wfs.[Value] = @WorkflowStateValue AND wfs.[WorkflowId] = @WorkflowId)
    WHERE [Id] = @ContractActionId
END