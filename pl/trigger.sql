USE dbTipee
GO
CREATE TRIGGER trgInsertAccountShop ON dbo.tblAccount
FOR INSERT
AS
BEGIN
	DECLARE	@count VARCHAR(32)
	SET @count = (SELECT COUNT(username) FROM dbo.tblAccount WHERE username = (SELECT username FROM  inserted))
	IF @count > 0
		BEGIN
			PRINT 'The account was used'
		END
END