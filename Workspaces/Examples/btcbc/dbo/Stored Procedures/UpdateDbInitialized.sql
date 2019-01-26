CREATE PROCEDURE [dbo].[UpdateDbInitialized]
	@Initialized BIT,
	@SchemaVersion CHAR (16)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @ExistingValue BIT
	SELECT @ExistingValue = Initialized FROM [dbo].[DbInitializationStatus]
	IF @@ROWCOUNT = 0
		INSERT INTO [dbo].[DbInitializationStatus] ([Initialized],[DbSchemaVersion]) VALUES (@Initialized, @SchemaVersion)
	ELSE
		UPDATE [dbo].[DbInitializationStatus]
			SET [Initialized] = @Initialized, [DbSchemaVersion] = @SchemaVersion
END