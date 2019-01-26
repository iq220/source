CREATE PROCEDURE [dbo].[GetContractActionsNext]
(
	@ContractId INT,
	@UserId INT,
	@Top INT,
	@Skip INT
)
AS
BEGIN
	DECLARE @ErrorMessage NVARCHAR(255)

    SET NOCOUNT ON

	SELECT @Top = ISNULL(@Top, 20)
    IF @Top < 1
        SET @Top = 20
    IF @Top > 100 
        SET @Top = 100

    SELECT @Skip = ISNULL(@Skip, 0)

	DECLARE @WorkflowId INT
	SELECT @WorkflowId = [WorkflowId] FROM [dbo].[Contract]	WHERE [Id] = @ContractId

	IF @WorkflowId IS NULL
    BEGIN
		-- @ContractId not found
    SET @Errormessage = 'Contract Id ' + CAST(@ContractId AS NVARCHAR) + ' not found.';
    THROW 55100, @Errormessage, 0;
    END

	DECLARE @ApplicationId INT
	SELECT @ApplicationId = [ApplicationId] FROM [dbo].[Workflow] WHERE [Id] = @WorkflowId

	DECLARE @Status [dbo].[udtt_Ids]
	INSERT INTO @Status 
	EXEC [dbo].[IsApplicationAccessibleByUser] @ApplicationId, @UserId

	IF (SELECT [Id] FROM @Status) = 0
	BEGIN
		-- @UserId not authorized to access contracts in @ApplicationId
    SET @ErrorMessage = 'User ' + CAST(@UserId AS nvarchar) +' is not authorized to take this action.';
		THROW 55100, @Errormessage, 0;
	END

	---- Find authorized actions ----
	DECLARE @authorizedActions [dbo].[udtt_Ids]
	INSERT INTO @authorizedActions
	EXEC [dbo].[GetAuthorizedContractActions] @ContractId, @UserId

	---- Select functions ----
	SELECT wff.[Id]
		  ,wff.[Name]
		  ,wff.[Description]
		  ,wff.[DisplayName]
		  ,wff.[WorkflowId]
	FROM [dbo].[WorkflowFunction] wff
	INNER JOIN @authorizedActions AS aa ON aa.[Id] = wff.[Id]
	ORDER BY [DisplayName] OFFSET @skip ROWS FETCH NEXT @top ROWS ONLY

	---- Select function parameters ----
	SELECT wffp.[Id]
		  ,wffp.[Name]
		  ,wffp.[Description]
		  ,wffp.[DisplayName]
		  ,wffp.[DataTypeId]
		  ,wffp.[WorkflowFunctionId]
	FROM [dbo].[WorkflowFunctionParameter] AS wffp
	INNER JOIN @authorizedActions AS wff ON wff.[Id] = wffp.[WorkflowFunctionId]

	---- Select function parameter datatypes ----
	SELECT dt.[Id]
		  ,dt.[Name]
		  ,dt.[ElementTypeId]
	FROM [dbo].[WorkflowFunctionParameter] wffp 
	INNER JOIN [dbo].[DataType] AS dt ON wffp.[DataTypeId] = dt.[Id]
	INNER JOIN @authorizedActions AS wff ON wff.[Id] = wffp.[WorkflowFunctionId]
END