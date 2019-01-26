-----------------------------------------------------------------------------
-- Copyright (c) Microsoft Corporation
-----------------------------------------------------------------------------
-- This procedure exists to support contract action creation for message integration samples hosted on github.
-- https://github.com/Azure-Samples/blockchain/tree/master/blockchain-workbench/messaging-integration-samples/CreateContractAction.md

-- The input values are used to derive the values needed for the CreateContractAction procedure, and -- then calls the CreateContractAction procedure.
CREATE PROCEDURE [dbo].[CreateContractActionFromIngressQueue]
    @UserId INT,
    @ConnectionId INT,
    @UserChainIdentifier NVARCHAR(255),
    @ContractLedgerIdentifier NVARCHAR(255),
    @WorkflowFunctionName NVARCHAR(50),
    @RequestId NVARCHAR(50),
    @ContractActionParameters [dbo].[udtt_ContractActionParameter] READONLY
AS
BEGIN
  -- CreateContractAction requires ContractId, UserId, WorkflowFunctionId, and
  -- ContractActionParameters
    SET NOCOUNT ON;

    -- get Contract id using the contract ledger identifier
    DECLARE @ContractId INT
    DECLARE @WorkflowId INT
    SELECT 
        @ContractId = [Id],
        @WorkflowId = [WorkflowId]
    FROM [dbo].[Contract] as c
    WHERE c.[LedgerIdentifier] = @ContractLedgerIdentifier

    -- get Workflow function id using workflow id obtained from contract id and workflow function name
    DECLARE @WorkflowFunctionId INT
    SELECT @WorkflowFunctionId = [Id]
    FROM [dbo].[WorkflowFunction] as wf
    WHERE wf.[WorkflowId] = @WorkflowId AND wf.[Name] = @WorkflowFunctionName

    EXEC [dbo].[CreateContractAction] @ContractId, @UserId, @WorkflowFunctionId, @RequestId, @ContractActionParameters
END