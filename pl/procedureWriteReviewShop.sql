USE dbTipee
GO
CREATE PROCEDURE writeReviewShop
	@idShop VARCHAR(6),
	@idCustomer VARCHAR(6),
	@star INT,
	@describe VARCHAR(100)
AS
BEGIN
	IF @describe = ''
		PRINT 'Write comment'
	ELSE 
		BEGIN
			DECLARE @countRate AS INT
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