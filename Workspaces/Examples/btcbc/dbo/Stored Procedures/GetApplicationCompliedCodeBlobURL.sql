CREATE PROCEDURE [dbo].[GetApplicationCompliedCodeBlobURL]
    @ApplicationId INT,
    @ConnectionId INT
AS
BEGIN

    DECLARE @CompiledCodeBlobStorageURL NVARCHAR(255)
    SELECT @CompiledCodeBlobStorageURL = [ArtifactBlobStorageURL]
        FROM [ContractCode]
        WHERE [ApplicationId] = @ApplicationId AND [LedgerId] = @ConnectionId

    SELECT @CompiledCodeBlobStorageURL AS CompiledCodeBlobStorageURL

END