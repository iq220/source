CREATE PROCEDURE [dbo].[CreateUserChainMapping]
    @UserID INT,
    @ConnectionID INT,
    @ChainIdentifier NVARCHAR(255),
    @ChainBalance INT,
    @RequestId NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    -- The common case for this is where multiple machines want to create a user chain mapping that already exists.
    -- It is much faster to return the Id than to try and create each time while failing with an exception.
    DECLARE @NewId INT
    SELECT @NewId = [Id]
    FROM [dbo].[UserChainMapping]
    WHERE [UserID] = @UserID AND [ConnectionID] = @ConnectionID

    -- If the id is null, in that the row does not exist, then create one
    IF @NewId IS NULL
    BEGIN
      -- If two processes get into here where both has NewId as NULL, then handle the case of duplicate insertion
      BEGIN TRY
        INSERT INTO [dbo].[UserChainMapping] ([UserID], [ConnectionID], [ChainIdentifier], [ChainBalance], [NextSequenceNumber], [LastSweepTimestamp], [RequestId])
        VALUES (@UserID, @ConnectionID, @ChainIdentifier, @ChainBalance, 0, GETUTCDATE(), @RequestId)
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
            FROM [dbo].[UserChainMapping]
            WHERE [UserID] = @UserID AND [ConnectionID] = @ConnectionID
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