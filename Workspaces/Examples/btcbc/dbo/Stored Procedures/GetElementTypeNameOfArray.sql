-----------------------------------------------------------------------------
-- Copyright (c) Microsoft Corporation
-----------------------------------------------------------------------------

Create PROCEDURE [dbo].[GetElementTypeNameOfArray]
(
    @ArrayDataTypeId INT
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT d2.[Name] as ElementTypeName
    FROM [dbo].[DataType] as d1
    inner join [dbo].[DataType] as d2 on d1.[ElementTypeId] = d2.[Id]
    WHERE d1.Id = @ArrayDataTypeId

END
