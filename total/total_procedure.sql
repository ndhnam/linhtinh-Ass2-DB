--- Phần của Linh ---
CREATE PROCEDURE insertShopAccount
	@id VARCHAR(6),
	@username VARCHAR(32),
	@password VARCHAR(50),
	@name NVARCHAR(50),
	@number INT,
	@address NVARCHAR(100),
	@email VARCHAR(50),
	@avatar VARCHAR(100),
	@classify INT,
	@typesOfShop NVARCHAR(30),
	@distribution NVARCHAR(10)
AS
BEGIN
	DECLARE @hashPass VARBINARY(500) = HASHBYTES('SHA2_512', @password)
	DECLARE @afterHashPassword VARCHAR(100) = CONVERT(VARCHAR(500), @hashPass)
	DECLARE @count_id INT = (SELECT COUNT(id) FROM dbo.tblAccount WHERE id = @id)
	DECLARE @count_user INT = (SELECT COUNT(username) FROM dbo.tblAccount WHERE username = @username)
	IF @count_id = 0 AND @count_user = 0
	BEGIN
		INSERT INTO dbo.tblAccount(id, username, password) VALUES (@id, @username, @afterHashPassword)
		IF @@ROWCOUNT > 0
		BEGIN
			INSERT INTO dbo.tblShop(id, name, number, address, email, avatar, classify, typesOfShop, distribution, total_rate) VALUES (@id, @name, @number, @address, @email, @avatar, @classify, @typesOfShop, @distribution, 0)
		END
	END
END
GO
CREATE PROCEDURE writeReviewShop
	@idShop VARCHAR(6),
	@username VARCHAR(32),
	@password VARCHAR(100),
	@star INT,
	@describe NVARCHAR(100)
AS
BEGIN
	DECLARE @hashPass VARBINARY(500) = HASHBYTES('SHA2_512', @password)
	DECLARE @afterHashPassword VARCHAR(100) = CONVERT(VARCHAR(500), @hashPass)
	IF (@afterHashPassword = (SELECT password FROM dbo.tblAccount WHERE username = @username))  AND (@username LIKE 'kh%')
		BEGIN
		IF  @describe = ''
			PRINT 'Write comment'
		ELSE
		BEGIN
			DECLARE @countRate AS INT
			DECLARE @idCustomer VARCHAR(6) = (SELECT id FROM dbo.tblAccount WHERE username = @username)
			SET @countRate = (SELECT COUNT(idShop) FROM dbo.tblRate WHERE idCustomer = @idCustomer AND idShop = @idShop)
			IF	@countRate = 0
				BEGIN
					INSERT INTO dbo.tblRate(idShop, idCustomer, star, describe) 
					VALUES (@idShop, @idCustomer, @star, @describe)
					PRINT 'Success'
				END
			ELSE
				BEGIN 
					UPDATE dbo.tblRate 
					SET star = @star, describe = @describe
					WHERE idShop = @idShop AND idCustomer = @idCustomer
					PRINT 'Success'
				END
		END
		END
	ELSE
		PRINT 'Password wrong!'
END
GO
CREATE PROCEDURE deleteReviewShop
	@idShop VARCHAR(6),
	@username VARCHAR(32),
	@password VARCHAR(100)
AS
BEGIN
	DECLARE @hashPass VARBINARY(500) = HASHBYTES('SHA2_512', @password)
	DECLARE @afterHashPassword VARCHAR(100) = CONVERT(VARCHAR(500), @hashPass)
	IF @afterHashPassword != (SELECT password FROM dbo.tblAccount WHERE username = @username) 
		PRINT 'Password wrong!'
	ELSE 
		BEGIN
			DECLARE @idCustomer VARCHAR(6) = (SELECT id FROM dbo.tblAccount WHERE username = @username)
			DELETE FROM dbo.tblRate WHERE idCustomer = @idCustomer
		END
END
GO
CREATE PROCEDURE insertCustomerAccount
	@id_customer VARCHAR(6),
	@username VARCHAR(32),
	@password VARCHAR(50),
	@last_name NVARCHAR(20), 
	@first_name NVARCHAR(20),
	@email VARCHAR(100),
	@sex BIT,
	@date_of_birth DATE,
	@id_intro VARCHAR(15),
	@id_reduce VARCHAR(15)
AS
BEGIN
	DECLARE @hashPass VARBINARY(500) = HASHBYTES('SHA2_512', @password)
	DECLARE @afterHashPassword VARCHAR(100) = CONVERT(VARCHAR(500), @hashPass)
	DECLARE @count_id INT = (SELECT COUNT(id) FROM dbo.tblAccount WHERE id = @id_customer)
	DECLARE @count_user INT = (SELECT COUNT(username) FROM dbo.tblAccount WHERE username = @username)
	IF @count_id = 0 AND @count_user = 0
	BEGIN
		INSERT INTO dbo.tblAccount(id, username, password) VALUES (@id_customer, @username, @afterHashPassword)
		IF @@ROWCOUNT > 0
		BEGIN
			INSERT INTO dbo.tblCustomer(id_customer, last_name, first_name, email, sex, date_of_birth, id_intro, id_reduce) VALUES (@id_customer, @last_name, @first_name, @email, @sex, @date_of_birth, @id_intro, @id_reduce)
		END
	END
END
GO
CREATE PROCEDURE procedureChangePassword
	@username VARCHAR(50),
	@curpassword VARCHAR(32),
	@newpassword VARCHAR(100)
AS
BEGIN
	DECLARE @hashCurPass AS VARCHAR(500)
	SET @hashCurPass = CONVERT(VARCHAR(500), HASHBYTES('SHA2_512', @curpassword))
	DECLARE @password AS VARCHAR(500)
	SET @password = (SELECT password FROM dbo.tblAccount WHERE username = @username)
	IF @hashCurPass = @password
		BEGIN
			UPDATE dbo.tblAccount SET password = CONVERT(VARCHAR(500), HASHBYTES('SHA2_512', @newpassword)) WHERE username = @username;
			print 'Change Password Success!'
		END
	ELSE
		BEGIN
			print 'Incorrect current password' 
		END
END
GO
CREATE PROCEDURE procedureChangeProfileShop
	@id	VARCHAR(6),
	@username VARCHAR(32),
	@curpassword VARCHAR(100),
	@name NVARCHAR(50),
	@number INT,
	@address NVARCHAR(50),
	@email VARCHAR(50),
	@avatar VARCHAR(100),
	@classify INT,
	@typesOfShop NVARCHAR(30),
	@distribution NVARCHAR(10)
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
GO