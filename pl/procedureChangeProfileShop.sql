USE dbTipee
GO
CREATE PROCEDURE procedureChangeProfileShop
	@id	VARCHAR(6),
	@username VARCHAR(50),
	@curpassword VARCHAR(50),
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
	DECLARE @hashCurPass AS VARCHAR(500)
	SET @hashCurPass = CONVERT(VARCHAR(500), HASHBYTES('SHA2_512', @curpassword))
	DECLARE @password AS VARCHAR(500)
	SET @password = (SELECT password FROM dbo.tblAccount WHERE username = @username)
	IF @hashCurPass = @password
		BEGIN
			--UPDATE dbo.tblAccount SET password = CONVERT(VARCHAR(500), HASHBYTES('SHA2_512', @newpassword)) WHERE username = @username;
			UPDATE DBO.tblShop SET
				name = @name,
				number = @number,
				address = @address,
				email = @email,
				avatar = @avatar,
				classify = @classify,
				typesOfShop = @typesOfShop,
				distribution = @distribution
			WHERE
				id = @id;
			print 'Change profile shop success!'
		END
	ELSE
		BEGIN
			print 'Incorrect current password' 
		END
END



















