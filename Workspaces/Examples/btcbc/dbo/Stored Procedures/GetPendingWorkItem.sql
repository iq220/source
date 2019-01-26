CREATE PROCEDURE [dbo].[GetPendingWorkItem]
    @PendingWorkItemId INT
AS
BEGIN
    BEGIN
      -- return:
      -- -- application id,
      -- -- workflow name as ContractName,
      -- -- from as ActionFrom,
      -- -- to as ActionFrom,
      -- -- method name,
      -- -- arguments,
      -- -- sequence number as SequenceNumber

      -- get these from ContractAction table
      DECLARE @WorkflowFunctionId INT
      DECLARE @WorkflowFunctionParameterId INT
      SELECT
          @WorkflowFunctionId = [WorkflowFunctionId]
      FROM [dbo].[ContractAction]
      WHERE [Id] = @PendingWorkItemId

      -- get application id using WorkflowFunctionId -> WorkflowId -> ApplicationId
      DECLARE @WorkflowId INT
      SELECT @WorkflowId = [WorkflowId]
      FROM [dbo].[WorkflowFunction]
      WHERE [Id] = @WorkflowFunctionId

      SELECT
          [ApplicationId] AS ApplicationId
      FROM [dbo].[Workflow]
      WHERE [Id] = @WorkflowId

	  SELECT
		  [Name] AS ContractName
	  FROM [dbo].[Workflow]
	  WHERE [Id] = @WorkflowId

      -- get from and to using transaction id
      SELECT
          ucm.[ChainIdentifier] AS ActionFrom
      FROM [dbo].[ContractAction] AS ca
	  LEFT JOIN [dbo].[UserChainMapping] AS ucm
	  ON ca.[UserId] = ucm.[UserID]
	  WHERE ca.[Id] = @PendingWorkItemId

	  SELECT
	      IIF(c.[LedgerIdentifier] IS NULL, '', c.[LedgerIdentifier]) AS ActionTo
	  FROM [dbo].[ContractAction] AS ca
	  LEFT JOIN [dbo].[Contract] AS c
	  ON ca.[ContractId] = c.[Id]
	  WHERE ca.[Id] = @PendingWorkItemId

      -- get method name using workflow function id
      SELECT
          wf.[Name] AS MethodName
      FROM [dbo].[WorkflowFunction] AS wf
      WHERE [Id] = @WorkflowFunctionId

      SELECT 
          ca.[RequestId] AS RequestId
      FROM [dbo].[ContractAction] AS ca
      WHERE ca.[Id] = @PendingWorkItemId

	  SELECT
		wfp.[Name] as WorkflowFunctionParameterName,
		cap.[Value] as WorkflowFunctionParameterValue,
		wfp.[id] as WorkflowFunctionParameterId
	  FROM [dbo].[ContractActionParameter] cap
	  INNER JOIN [dbo].[WorkflowFunctionParameter] as wfp
	  ON cap.[WorkflowFunctionParameterId] = wfp.[Id]
	  WHERE cap.[ContractActionId] = @PendingWorkItemId

      -- get sequence number from contract action table
      SELECT
          ca.[SequenceNumber] AS SequenceNumber
      FROM [dbo].[ContractAction] AS ca
      WHERE [Id] = @PendingWorkItemId

      -- get provisioning status from contract action table
      SELECT
          ca.[ProvisioningStatus] AS ProvisioningStatus
      FROM [dbo].[ContractAction] AS ca
      WHERE [Id] = @PendingWorkItemId
    END

   RETURN
END
