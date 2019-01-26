CREATE PROCEDURE [dbo].[GetAuthorizedContractActions]
    @ContractId INT,
    @UserId INT
AS
BEGIN
	DECLARE @StateDataTypeName NVARCHAR(50) = 'state'
    DECLARE @StateId INT
	DECLARE @MaxBlockId INT

	-- Get the max block ID for the contract properties
	SELECT @MaxBlockId = MAX([BlockId])
	FROM [dbo].[ContractProperty]
	WHERE [ContractId] = @ContractId

  	SELECT @StateId = wfs.[Id] FROM [dbo].[WorkflowState] AS wfs 
	INNER JOIN [dbo].[ContractProperty] AS wfip ON
		wfip.[ContractId] = @ContractId
		AND wfip.[BlockId] = @MaxBlockId
	INNER JOIN [dbo].[WorkflowProperty] AS wfp ON
		wfp.[Id] = wfip.[WorkflowPropertyId]
		AND wfs.[WorkflowId] = wfp.[WorkflowId]
        AND wfp.[DataTypeId] = (SELECT [Id] FROM [dbo].[DataType] WHERE [Name] = @StateDataTypeName COLLATE SQL_Latin1_General_CP1_CI_AS)
		AND TRY_PARSE(wfip.[Value] AS INT) IS NOT NULL
        AND CONVERT(INT, wfip.[Value]) = wfs.[Value]

	---- Contract and corresponding actions the given user can take now based on the user's instance role
	DECLARE @ContractActionsInstanceRole [dbo].[udtt_Ids]
	INSERT INTO @ContractActionsInstanceRole
	SELECT wfst.[WorkflowFunctionId] FROM [dbo].[WorkflowStateTransition] AS wfst
	INNER JOIN [dbo].[WorkflowStateTransitionInstanceRole] AS wfstir ON wfstir.[WorkflowStateTransitionId] = wfst.[Id]
	INNER JOIN [dbo].[ContractProperty] AS wip ON
		wip.[ContractId] = @ContractId
		AND wip.[WorkflowPropertyId] = wfstir.[WorkflowPropertyId]
		AND wip.[BlockId] = @MaxBlockId
	INNER JOIN [dbo].[UserChainMapping] AS ucm ON ucm.[ChainIdentifier] = wip.[Value]
	WHERE wfst.[CurrStateId] = @StateId AND ucm.[UserID] = @UserId

	---- Contract and corresponding actions the given user can take now based on the user's app role
	DECLARE @ContractActionsAppRole [dbo].[udtt_Ids]
	INSERT INTO @ContractActionsAppRole
	SELECT wfst.[WorkflowFunctionId] FROM [dbo].[WorkflowStateTransition] AS wfst 
	INNER JOIN [dbo].[WorkflowStateTransitionApplicationRole] AS wfstar ON wfstar.[WorkflowStateTransitionId] = wfst.[Id]
	INNER JOIN [dbo].[ApplicationRole] AS ar ON wfstar.[ApplicationRoleId] = ar.[Id]
	INNER JOIN [dbo].[RoleAssignment] AS urm ON ar.[Id] = urm.[ApplicationRoleId]
	WHERE wfst.[CurrStateId] = @StateId AND urm.[UserID] = @UserId

	SELECT [Id] FROM @ContractActionsInstanceRole
	UNION
	SELECT [Id] FROM @ContractActionsAppRole
END