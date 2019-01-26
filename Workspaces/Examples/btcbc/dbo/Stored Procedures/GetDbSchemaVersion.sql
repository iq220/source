-----------------------------------------------------------------------------
-- Copyright (c) Microsoft Corporation
-----------------------------------------------------------------------------

-----------------------------------------------------------------------------
-- Purpose: For Telemetry 
-----------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[GetDbSchemaVersion]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT [DbSchemaVersion]
    FROM [dbo].[DbInitializationStatus]
END