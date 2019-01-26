CREATE PROCEDURE [dbo].[CreateUser]
	  @ExternalId NVARCHAR (255),
    @FirstName NVARCHAR(50),
    @LastName NVARCHAR(50),
    @EmailAddress NVARCHAR(255)
AS
BEGIN
  SET NOCOUNT ON;

  -- The common case for this is where multiple machines want to create a user who already exists.
  -- It is much faster to return the Id than to try and create each time while failing with an exception.
  DECLARE @NewId INT
  SELECT @NewId = [Id]
  FROM [dbo].[User] 
  WHERE [ExternalId] = @ExternalId

  -- If the id is null, in that the row does not exist, then create one
  IF @NewId IS NULL
  BEGIN
    -- If two processes get into here where both has NewId as NULL, then handle the case of duplicate insertion
    BEGIN TRY
      INSERT INTO [dbo].[User] ([ProvisioningStatus],[ExternalId],[FirstName],[LastName],[EmailAddress])
      VALUES (0, @ExternalId, @FirstName, @LastName, @EmailAddress)
      SELECT SCOPE_IDENTITY() AS NewID
    END TRY
    BEGIN CATCH
      -- handle duplicate insertion
      DECLARE @ErrorNumber INT
      SELECT @ErrorNumber = ERROR_NUMBER()
      IF @ErrorNumber = 2601 -- code for duplicate insertion exception
        BEGIN
          -- return what exists
          SELECT [Id] AS NewID 
          FROM [dbo].[User] 
          WHERE [ExternalId] = @ExternalId
        END
      ELSE
        BEGIN
        -- bubble up all other exceptions via throw
        ; THROW
        END
    END CATCH
  END
  -- else Id exists, return the id
  ELSE
  BEGIN
    SELECT @NewId AS NewID
  END
END