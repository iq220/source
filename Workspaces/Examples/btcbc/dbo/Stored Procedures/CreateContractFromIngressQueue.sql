-----------------------------------------------------------------------------
-- Copyright (c) Microsoft Corporation
-----------------------------------------------------------------------------
-- This procedure exists to support contract creation for message integration samples hosted on github.
-- https://github.com/Azure-Samples/blockchain/tree/master/blockchain-workbench/messaging-integration-samples/CreateContract.md

-- The input values are used to derive the values needed for the CreateContract procedure, and then 
-- calls the CreateContract procedure.
CREATE PROCEDURE [dbo].[CreateContractFromIngressQueue]
    @UserId INT,
    @ApplicationName NVARCHAR (50),
    @WorkflowName NVARCHAR (50),
    @UserChainIdentifier NVARCHAR (255),
    @ConnectionId INT,
    @RequestId NVARCHAR(50),
    @ContractActionParameters [dbo].[udtt_ContractActionParameter] READONLY
AS
BEGIN
  -- values needed for create contract
  -- -- WorkflowId, ContractCodeId, ConnectionId, UserId, ContractActionParameters
    SET NOCOUNT ON

    DECLARE @ErrorMessage NVARCHAR(255)

    -- Get Application id and Contract code id using ApplicationName
    DECLARE @ApplicationId INT
    DECLARE @ContractCodeId INT
    SELECT 
        @ApplicationId = cc.[ApplicationId],
        @ContractCodeId = cc.[Id]
    FROM [dbo].[ContractCode] as cc
    INNER JOIN [dbo].[Application] as app ON cc.[ApplicationId] = app.[Id]
    WHERE app.[Name] = @ApplicationName

    -- Get Workflow id using Application Id and Workflow Name
    DECLARE @WorkflowId INT
    SELECT @WorkflowId = [Id]
    FROM [dbo].[Workflow] as w
    WHERE w.[ApplicationId] = @ApplicationId AND w.[Name] = @WorkflowName

    EXEC [dbo].[CreateContract] @WorkflowId, @ContractCodeId, @ConnectionId, @UserId, @RequestId, @ContractActionParameters
END
