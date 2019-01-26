-----------------------------------------------------------------------------
-- Copyright (c) Microsoft Corporation
-----------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[CreateDataTypes]
(
    @DataTypes                   [dbo].[udtt_DataTypes] READONLY
)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        --  -----------------------------------------------------
        BEGIN TRANSACTION
        --  -----------------------------------------------------
            INSERT INTO [dbo].[DataType] 
                ([Name],
                [ApplicationId],
                [ElementTypeId])
            OUTPUT
                INSERTED.Id,
                INSERTED.Name,
                INSERTED.ApplicationId,
                INSERTED.ElementTypeId            
            SELECT [Name], [ApplicationId], [ElementTypeId]
                FROM @DataTypes
            EXCEPT
            SELECT [Name], [ApplicationId], [ElementTypeId]
                FROM [dbo].[DataType]
        --  -----------------------------------------------------
        COMMIT TRANSACTION
        --  -----------------------------------------------------

    END TRY

    BEGIN CATCH

        ROLLBACK TRANSACTION;
        THROW;

    END CATCH
END