----------------------------------------------------------------------------
-- Copyright (c) Microsoft Corporation
----------------------------------------------------------------------------

-----------------------------------------------------------------------------
-- Purpose: For Telemetry 
-----------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[GetContractCodesCreatedInTimeRange]
    @StartTime DateTime,
    @EndTime DateTime
AS
BEGIN
    SET NOCOUNT ON;

    SELECT  [CreatedByUserId] as UserId, 
            [CreatedDtTm] as ActionTimestamp
    FROM [dbo].[ContractCode] 
    WHERE [CreatedDtTm] > @StartTime AND [CreatedDtTm] <= @EndTime

END