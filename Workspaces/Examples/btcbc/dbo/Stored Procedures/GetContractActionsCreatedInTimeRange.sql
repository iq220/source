-----------------------------------------------------------------------------
-- Copyright (c) Microsoft Corporation
-----------------------------------------------------------------------------

-----------------------------------------------------------------------------
-- Purpose: For Telemetry 
-----------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[GetContractActionsCreatedInTimeRange]
    @StartTime DateTime,
    @EndTime DateTime
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        ca.UserId as UserId,
        ca.Timestamp as ActionTimestamp, 
        b.BlockTimestamp as BlockTimestamp
    FROM [dbo].[ContractAction] ca
    INNER JOIN [dbo].[WorkflowFunction] wf
        ON ca.WorkflowFunctionId = wf.Id
    INNER JOIN [dbo].[Transaction] t
        ON ca.TransactionId = t.Id
    INNER JOIN [dbo].[Block] b
        ON t.BlockID = b.ID
    WHERE wf.Name is NOT NULL AND wf.Name <> ''                   --- Null/Empty WorkflowFunction name indicates constructor
      AND ca.[Timestamp] > @StartTime AND  ca.[Timestamp] <= @EndTime

END