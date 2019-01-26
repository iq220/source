CREATE PROCEDURE [dbo].[CreateEnumDataType]
(
    @ApplicationId INT,
    @EnumValues    [dbo].[udtt_EnumValues] READONLY
)
AS
BEGIN
    DECLARE @NewDataTypeId INT

    SET NOCOUNT ON;
    
    BEGIN TRY
        --  -----------------------------------------------------
        BEGIN TRANSACTION
        --  -----------------------------------------------------

        INSERT INTO [dbo].[DataType] 
            ([Name],
            [ApplicationId])
        OUTPUT
            INSERTED.Id,
            INSERTED.Name,
            INSERTED.ApplicationId
        VALUES
        ('enum', @ApplicationId)

        SELECT @NewDataTypeId = SCOPE_IDENTITY()
        SELECT @NewDataTypeId;

        INSERT INTO [dbo].[EnumValue]
            ([Name],
            [Value],
            [DataTypeId])
        SELECT 
            ev.Name, 
            ev.Value,
            @NewDataTypeId
        FROM @EnumValues as ev
        --  -----------------------------------------------------
        COMMIT TRANSACTION
        --  -----------------------------------------------------

    END TRY

    BEGIN CATCH

        ROLLBACK TRANSACTION;
        THROW;

    END CATCH
END