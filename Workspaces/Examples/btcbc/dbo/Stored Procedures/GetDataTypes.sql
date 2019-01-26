-----------------------------------------------------------------------------
-- Copyright (c) Microsoft Corporation
-----------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[GetDataTypes]
(
    @ApplicationId INT
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT [Id], [Name], [ElementTypeId], [ApplicationId]
    FROM [dbo].[DataType]
    WHERE [ApplicationId] = @ApplicationId OR [ApplicationId] IS NULL
END
