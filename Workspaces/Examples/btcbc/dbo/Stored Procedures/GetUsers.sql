CREATE PROCEDURE [dbo].[GetUsers]
	@top INT = null,
	@skip INT = null,
  @sortBy NVARCHAR(255)
AS
BEGIN
	SELECT @top = ISNULL(@top, 20)
  IF @Top < 1 
    SET @Top = 20
  IF @Top > 100
      SET @Top = 100
	SELECT @skip = ISNULL(@skip, 0)

  SELECT [ID],[ExternalID],[FirstName],[LastName],[EmailAddress] FROM [dbo].[User]
  ORDER BY
    CASE @SortBy WHEN 'FirstName' COLLATE SQL_Latin1_General_CP1_CI_AS THEN [FirstName] END
    ,[Id]
  OFFSET @skip ROWS FETCH NEXT @top ROWS ONLY
END