CREATE PROCEDURE [dbo].[IsDbInitialized]
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @DBInitialized BIT
	SELECT @DBInitialized = Initialized FROM [dbo].[DbInitializationStatus]
	IF @@ROWCOUNT = 0
		PRINT 'FALSE'
	ELSE IF @DBInitialized = 0
		PRINT 'FALSE'
	ELSE
		PRINT 'TRUE'
END