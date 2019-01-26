CREATE PROCEDURE [dbo].[GetContractInformationByName]
    @ApplicationName NVARCHAR(255),
    @WorkflowName NVARCHAR(255),
    @LedgerId INT
AS
BEGIN
    DECLARE @ApplicationId INT
    SELECT @ApplicationId = [Id]
        FROM [Application]
        WHERE [Name] = @ApplicationName

    DECLARE @WorkflowId int
    SELECT @WorkflowId = [Id]
        FROM [Workflow]
        WHERE [Name] = @WorkflowName AND [ApplicationId] = @ApplicationId

    DECLARE @ContractFileName NVARCHAR(255)
    SELECT @ContractFileName = [ArtifactBlobStorageURL]
        FROM [ContractCode]
        WHERE [ApplicationId] = @ApplicationId AND [LedgerId] = @LedgerId

    SELECT @WorkflowName AS ContractName, @ContractFileName AS ContractFileName, @ApplicationId AS ApplicationId, @WorkflowId AS WorkflowId

    SELECT p.[Id] AS PropertyId, p.[Name] AS PropertyName, d.[Name] as PropertyDataTypeName
        FROM [WorkflowProperty] as p
        join DataType as d on p.DataTypeId = d.Id
        WHERE [WorkflowId] = @WorkflowId
END
