CREATE PROCEDURE [dbo].[GetWorkflow]
	@WorkflowId INT,
	@UserId INT,
	@IsAdmin BIT
AS
BEGIN
	DECLARE @ErrorMessage NVARCHAR(255)

	SET NOCOUNT ON;

    IF NOT EXISTS (SELECT [Id] FROM [dbo].[Workflow] WHERE [Id] = @WorkflowId)
    BEGIN
        -- @WorkflowId not found
       	SET @Errormessage = 'Workflow Id ' + CAST(@WorkflowId AS NVARCHAR) + ' not found.';
        THROW 55100, @Errormessage, 0;
    END

	IF @IsAdmin = 0
	BEGIN
        DECLARE @ApplicationId INT
        SELECT @ApplicationId = [ApplicationId] FROM [dbo].[Workflow] WHERE [Id] = @WorkflowId

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

    ---- Workflow ----
    SELECT
            w.[Id]
        ,w.[Name]
        ,w.[Description]
        ,w.[DisplayName]
        ,w.[ApplicationId]
        ,w.[ConstructorId]
        ,w.[StartStateId]

        FROM [dbo].[Workflow] w
    WHERE 
        w.[Id] = @WorkflowId

    ---- Workflow States ----
    SELECT 
            ws.[Id]
        ,ws.[Name]
        ,ws.[Description]
        ,ws.[DisplayName]
        ,ws.[PercentComplete]
        ,ws.[Value]
        ,ws.[Style]
        ,ws.[WorkflowId]
    FROM 
        [dbo].[Workflow] w
            INNER JOIN [dbo].[WorkflowState] ws ON ws.[WorkflowId] = w.[Id]
    WHERE
        w.[Id] = @WorkflowId

    ---- Workflow Properties ----
    SELECT
        wp.[Id]
        ,wp.[Name]
        ,wp.[Description]
        ,wp.[DisplayName]
        ,wp.[WorkflowId]
        ,wp.[DataTypeId]
    FROM 
        [dbo].[Workflow] w
            INNER JOIN [dbo].[WorkflowProperty] wp ON wp.[WorkflowId] = w.[Id]
    WHERE
        w.[Id] = @WorkflowId
        

    ---- Workflow Property DataTypes ----
    SELECT 
            d.[Id]
        ,d.[Name]
        ,d.[ElementTypeId]
    FROM 
        [dbo].[Workflow] w
            INNER JOIN [dbo].[WorkflowProperty] wp ON wp.[WorkflowId] = w.[Id]
            INNER JOIN [dbo].[DataType] d ON wp.[DataTypeId] = d.[Id]
    WHERE 
        w.[Id] = @WorkflowId

    ---- ApplicationRoles for Workflow Initiators ----
    SELECT
            ar.[Id]
        ,ar.[Name]
        ,ar.[Description]
        ,ar.[ApplicationId]
    FROM [dbo].[ApplicationRole] ar
        INNER JOIN [dbo].[WorkflowInitiator] wi 
            ON wi.[ApplicationRoleId] = ar.[Id]
    WHERE 
        wi.[WorkflowId] = @WorkflowId
            
    ---- Workflow Functions ----
    SELECT 
        wf.[Id]
        ,wf.[Name]
        ,wf.[Description]
        ,wf.[DisplayName]
        ,wf.[WorkflowId]
    FROM 
        [dbo].[WorkflowFunction] wf
    WHERE 
        wf.[WorkflowId] = @WorkflowId

    ---- Workflow Function Parameters
    SELECT 
            wfp.[Id]
        ,wfp.[Name]
        ,wfp.[Description]
        ,wfp.[DisplayName]
        ,wfp.[DataTypeId]
        ,wfp.[WorkflowFunctionId]
    FROM 
        [dbo].[WorkflowFunction] wf 
            INNER JOIN [dbo].[WorkflowFunctionParameter] wfp 
                ON wf.[Id] = wfp.[WorkflowFunctionId]
    WHERE wf.[WorkflowId] = @WorkflowId

    ---- Workflow Function Parameter DataTypes
    SELECT 
            d.[Id]
        ,d.[Name]
        ,d.[ElementTypeId]
    FROM 
        [dbo].[WorkflowFunction] wf
            INNER JOIN [dbo].[WorkflowFunctionParameter] wfp 
                ON wf.[Id] = wfp.[WorkflowFunctionId]
            INNER JOIN [dbo].[DataType] d 
                ON wfp.[DataTypeId] = d.[Id]
    WHERE 
        wf.[WorkflowId] = @WorkflowId

    ---- Workflow State Transitions
    SELECT 
            wst.[Id]
        ,wst.[Description]
        ,wst.[DisplayName]
        ,wst.[CurrStateId]
        ,wst.[WorkflowFunctionId]
        ,wst.[WorkflowId]
    FROM 
        [dbo].[WorkflowStateTransition] wst
    WHERE 
        wst.[WorkflowId] = @WorkflowId
        
    ---- Workflow State Transitions ApplicationRoles
    SELECT 
        wstar.[Id]
        ,wstar.[WorkflowStateTransitionId]
        ,wstar.[ApplicationRoleId]
        ,ar.[Name]  ApplicationRoleName
    FROM 
        [dbo].[WorkflowStateTransition] wst
        INNER JOIN [dbo].[WorkflowStateTransitionApplicationRole] wstar 
                ON wstar.[WorkflowStateTransitionId] =  wst.[Id]
        INNER JOIN [dbo].[ApplicationRole] ar 
            ON wstar.[ApplicationRoleId] =  ar.[Id]
    WHERE 
        wst.[WorkflowId] = @WorkflowId
        
    ---- Workflow State Transition Instance Roles
    SELECT 
        wstir.[Id]
        ,wstir.[WorkflowStateTransitionId]
        ,wstir.[WorkflowPropertyId]
        ,wp.[Name] WorkflowPropertyName
    FROM 
        [dbo].[WorkflowStateTransition] wst
        INNER JOIN [dbo].[WorkflowStateTransitionInstanceRole] wstir 
                ON wstir.[WorkflowStateTransitionId] =  wst.[Id]
        INNER JOIN [dbo].[WorkflowProperty] wp 
                ON wstir.[WorkflowPropertyId] =  wp.[Id]
    WHERE 
        wst.[WorkflowId] = @WorkflowId
END