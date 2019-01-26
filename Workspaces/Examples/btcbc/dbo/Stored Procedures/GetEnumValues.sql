CREATE PROCEDURE [dbo].[GetEnumValues]
(
    @DataTypeId                   INT
)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        --  -----------------------------------------------------
        BEGIN TRANSACTION
        --  -----------------------------------------------------
         
            SELECT [Name]
                FROM [dbo].[EnumValue] AS ev
            WHERE 
                ev.[DataTypeId] = @DataTypeId
            ORDER BY ev.[Value] ASC
        --  -----------------------------------------------------
        COMMIT TRANSACTION
        --  -----------------------------------------------------

    END TRY

    BEGIN CATCH

        ROLLBACK TRANSACTION;
        THROW;

    END CATCH
END