USE dbTipee
GO
CREATE PROCEDURE insertShopAccount
	@username VARCHAR(32),
	@password VARCHAR(50),
	@name VARCHAR(50),
	@number INT,
	@address VARCHAR(50),
	@email VARCHAR(50),
	@avatar VARCHAR(100),
	@classify INT,
	@typesOfShop VARCHAR(30),
	@distribution VARCHAR(10)
AS
BEGIN
	DECLARE @id AS CHAR(6)
	SET @id = ('CH' + CONVERT(VARCHAR(4),((SELECT COUNT(*) FROM dbo.tblShop) + 1)))
	DECLARE	@count INT
	SET @count = (SELECT COUNT(username) FROM dbo.tblAccount WHERE username = @username)
	IF @count > 0
		BEGIN
			PRINT 'The account was used'
		END
	ELSE
		BEGIN
			DECLARE @hashPass VARBINARY(500) = HASHBYTES('SHA2_512', @password)
			DECLARE @afterHashPassword VARCHAR(500) = CONVERT(VARCHAR(500), @hashPass)
			INSERT INTO dbo.tblAccount(id, username, password) VALUES (@id, @username, @afterHashPassword)
			INSERT INTO dbo.tblShop(id, name, number, address, email, avatar, classify, typesOfShop, distribution) VALUES (@id, @name, @number, @address, @email, @avatar, @classify, @typesOfShop, @distribution)
			PRINT 'SUCCESS'
		END
END