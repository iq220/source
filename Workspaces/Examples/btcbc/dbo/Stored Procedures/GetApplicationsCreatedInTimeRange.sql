-----------------------------------------------------------------------------
-- Copyright (c) Microsoft Corporation
-----------------------------------------------------------------------------

-----------------------------------------------------------------------------
-- Purpose: For Telemetry 
-----------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[GetApplicationsCreatedInTimeRange]
    @StartTime DateTime,
    @EndTime DateTime
AS
BEGIN
    SET NOCOUNT ON;

    SELECT  [CreatedByUserId] as UserId,
            [CreatedDtTm] as ActionTimestamp, 
            [Enabled] 
    FROM [dbo].[Application] 
    WHERE [CreatedDtTm] > @StartTime AND [CreatedDtTm] <= @EndTime

END