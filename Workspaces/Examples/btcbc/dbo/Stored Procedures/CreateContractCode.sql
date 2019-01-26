CREATE PROCEDURE [dbo].[CreateContractCode]
(
    @ApplicationId INT,
    @LedgerId INT,
    @CreatedByUserId INT,
    @FileName NVARCHAR(50),
    @SourceBlobStorageURL NVARCHAR(255),
    @ArtifactBlobStorageURL NVARCHAR(255)
)
AS
BEGIN
	SET NOCOUNT ON
    INSERT INTO [dbo].[ContractCode]([ApplicationId], [LedgerId], [CreatedByUserId], [CreatedDtTm],
        [FileName], [SourceBlobStorageURL], [ArtifactBlobStorageURL])
    VALUES(@ApplicationId, @LedgerId, @CreatedByUserId, GETUTCDATE(), @FileName, @SourceBlobStorageURL, @ArtifactBlobStorageURL)
    SELECT SCOPE_IDENTITY() AS NewId
END