CREATE PROCEDURE [dbo].[GetContracts]
	@Top INT = null,
	@Skip INT = null,
	@WorkflowId INT,
	@UserId INT,
	@IsAdmin BIT,
	@SortBy NVARCHAR(255)
AS
BEGIN
	SET NOCOUNT ON;
  	SELECT @Top = ISNULL(@Top, 20)
  	IF @Top < 1 
      SET @Top = 20
  	IF @Top > 100 
      SET @Top = 100
  	SELECT @Skip = ISNULL(@Skip, 0)

	DECLARE @ErrorMessage NVARCHAR(255)

	DECLARE @ApplicationId INT
	SELECT @ApplicationId = [ApplicationId] FROM [dbo].[Workflow] WHERE [Id] = @WorkflowId
    IF @ApplicationId IS NULL
    BEGIN
		-- @WorkflowId not found
       	SET @Errormessage = 'Workflow Id ' + CAST(@WorkflowId AS NVARCHAR) + ' not found.';
        THROW 55100, @Errormessage, 0;
    END

	IF @IsAdmin = 0
	BEGIN
		DECLARE @Status [dbo].[udtt_Ids]
		INSERT INTO @Status
		EXEC [dbo].[IsApplicationAccessibleByUser] @ApplicationId, @UserId

		IF (SELECT [Id] FROM @Status) = 0
		BEGIN
			-- @UserId not authorized to access @ApplicationId
        SET @ErrorMessage = 'User ' + CAST(@UserId AS nvarchar) +' is not authorized to take this action.';
        THROW 55100, @Errormessage, 0;
		END
	END

	DECLARE @returnScope [dbo].[udtt_Ids]

	INSERT INTO @returnScope
	SELECT wfi.[Id]
	FROM [dbo].[Contract] AS wfi
	WHERE wfi.[WorkflowId] = @WorkflowId
	ORDER BY 
		CASE @SortBy WHEN 'Timestamp' COLLATE SQL_Latin1_General_CP1_CI_AS THEN [Timestamp] END DESC
		,wfi.[Id]
	OFFSET @skip ROWS FETCH NEXT @top ROWS ONLY
	
	SELECT wfi.[Id],
	CASE
		WHEN wfi.[ProvisioningStatus] IS NOT NULL THEN wfi.[ProvisioningStatus]
		WHEN cca.ProvisioningStatus IS NULL THEN 2
		ELSE cca.ProvisioningStatus
    End as ProvisioningStatus,
	[Timestamp],
	[ConnectionId],
	[LedgerIdentifier],
	[DeployedByUserId],
	[WorkflowId],
	cca.[RequestId],
	[ContractCodeId]
	FROM [dbo].[Contract] AS wfi
	INNER JOIN @returnScope AS ret ON ret.[Id] = wfi.[Id]
	Left Outer Join 
    (select
        ca.[ProvisioningStatus] as ProvisioningStatus,
        ca.[ContractId] as ContractId,
        ca.[RequestId] as RequestId
     from [dbo].[ContractAction] as ca 
     inner join [dbo].[WorkflowFunction] as wff on wff.[Id] = ca.WorkflowFunctionId AND wff.[Name] = '') cca
     on cca.ContractId = wfi.[Id]
	ORDER BY 
		CASE @SortBy WHEN 'Timestamp' COLLATE SQL_Latin1_General_CP1_CI_AS THEN [Timestamp] END DESC
		,wfi.[Id]

	-- Select contract properties
	SELECT wfip.[WorkflowPropertyId], wfip.[Value], wfip.[ContractId]
	FROM [ContractProperty] AS wfip
	INNER JOIN @returnScope ret ON ret.[Id] = wfip.[ContractId]
	INNER JOIN (SELECT [ContractId], MAX([BlockId]) AS 'BlockId'
		FROM [ContractProperty]
		GROUP BY [ContractId]) mblock ON mblock.[BlockId] = wfip.[BlockId] AND mblock.[ContractId] = wfip.[ContractId]

	-- Select contract transactions
	SELECT t.[Id], t.[ConnectionId], t.[BlockId], t.[TransactionHash], t.[From], t.[To], t.[Value], t.[IsAppBuilderTx], wfa.[ContractId]
	FROM [ContractAction] AS wfa
	INNER JOIN [Transaction] AS t ON wfa.[TransactionId] = t.[Id]
	INNER JOIN @returnScope ret ON ret.[Id] = wfa.[ContractId]

	-- Select workflow instance actions
	SELECT wfia.[Id], wfia.[UserId], wfia.[ProvisioningStatus], wfia.[Timestamp], wfia.[ContractId], wfia.[WorkflowFunctionId], wfia.[TransactionId], wfia.[WorkflowStateId]
	FROM [ContractAction] AS wfia
	INNER JOIN @returnScope ret ON ret.[Id] = wfia.[ContractId]

	-- Select workflow function parameters
	SELECT wfa.[Id] AS ContractActionId, wfp.[DisplayName] AS Name, wfiap.[Value] AS Value, wfiap.[WorkflowFunctionParameterId] As WorkflowFunctionParameterId
	FROM [ContractAction] AS wfa
	INNER JOIN [WorkflowFunction] AS wf ON wf.[Id] = wfa.[WorkflowFunctionId]
	INNER JOIN [ContractActionParameter] AS wfiap ON wfiap.[ContractActionId] = wfa.[Id]
	INNER JOIN [WorkflowFunctionParameter] AS wfp ON wfiap.[WorkflowFunctionParameterId] = wfp.[Id]
	INNER JOIN @returnScope ret ON ret.[Id] = wfa.[ContractId] 
END