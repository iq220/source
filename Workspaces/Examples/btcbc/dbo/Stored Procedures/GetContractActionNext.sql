CREATE PROCEDURE [dbo].[GetContractActionNext]
(
    @ContractId INT,
    @FunctionId INT,
    @UserId INT
)
AS
BEGIN
    DECLARE @ErrorMessage NVARCHAR(255)
       SET @ErrorMessage = 'Incorrect input. Check that ids are correct and user is authorized.'

    SET NOCOUNT ON

    -- Select valid contract action based on user and current state
    DECLARE @instanceWorkflowId INT
    SELECT @instanceWorkflowId = [WorkflowId] FROM [dbo].[Contract] WHERE [Id] = @ContractId
    IF @instanceWorkflowId IS NULL
    BEGIN
        -- @ContractId not found
    SET @Errormessage = 'Contract Id ' + CAST(@ContractId AS NVARCHAR) + ' not found.';
    THROW 55100, @Errormessage, 0;
    END

    DECLARE @functionWorkflowId INT
    SELECT @functionWorkflowId = [WorkflowId] FROM [dbo].[WorkflowFunction] WHERE [Id] = @FunctionId
    IF @functionWorkflowId IS NULL
    BEGIN
        -- @FunctionId not found
    SET @Errormessage = 'Function Id ' + CAST(@FunctionId AS NVARCHAR) + ' not found.';
    THROW 55100, @Errormessage, 0;
    END

    IF @instanceWorkflowId <> @functionWorkflowId
    BEGIN
        -- Workflow id corresponding to @ContractId and @FunctionId do not match
    SET @ErrorMessage = 'Workflow ID does not match.';
    THROW 55200, @Errormessage, 0;
    END
    
    ---- Find authorized actions ----
    DECLARE @authorizedActions [dbo].[udtt_Ids]
    INSERT INTO @authorizedActions
    EXEC [dbo].[GetAuthorizedContractActions] @ContractId, @UserId

    IF (SELECT [Id] FROM @authorizedActions WHERE [Id] = @FunctionId) IS NULL
    BEGIN
        -- Each transition for which @UserId is authorized is labeled with a function different from @FunctionId
    SET @ErrorMessage = 'User ' + CAST(@UserId AS nvarchar) +' is not authorized to take this action.';
        THROW 55100, @Errormessage, 0;
    END
    
    ---- Workflow Function ----
    SELECT wff.[Id]
            ,wff.[Name]
            ,wff.[Description]
            ,wff.[DisplayName]
            ,wff.[WorkflowId]
    FROM [dbo].[WorkflowFunction] wff
    WHERE wff.[Id] = @FunctionId

    ---- Workflow Function Parameters ----
    SELECT wffp.[Id]
            ,wffp.[Name]
            ,wffp.[Description]
            ,wffp.[DisplayName]
            ,wffp.[DataTypeId]
            ,wffp.[WorkflowFunctionId]
    FROM [dbo].[WorkflowFunctionParameter] AS wffp
    WHERE wffp.[WorkflowFunctionId] = @FunctionId

    ---- Workflow Function Parameter DataTypes
    SELECT dt.[Id]
            ,dt.[Name]
            ,dt.[ElementTypeId]
    FROM [dbo].[WorkflowFunctionParameter] wffp 
    INNER JOIN [dbo].[DataType] AS dt ON wffp.[DataTypeId] = dt.[Id]
    WHERE wffp.[WorkflowFunctionId] = @FunctionId
    
END