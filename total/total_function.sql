-- Ngô Thanh Liêm - 1711929
USE dbTipee
Go

create function totalMoneyFromHas
(
	@idOrder Varchar(50)
)
returns int
as
begin
	declare @totalMoney int
	set @totalMoney = (select sum(money) as totalMoney
	from (select (unitPrice*amount) as money
		from tblHas
		where tblHas.idOrder = @idOrder) as totalMoneend)
	return @totalMoney
end
go
exec totalMoneyFromHas('MDH001')

CREATE FUNCTION totalMoneyByDepreciate
(
	@idOrder VARCHAR(50)
)
returns float
BEGIN
	declare @sum int
	set @sum = totalMoneyFromHas(@idOrder)
	if(@sum >= (select minTotal from tblOrder join tblPromotion on tblOrder.promotionCode = tblPromotion.id ))
	begin
		set @sum = ((totalMoneyFromHas(@idOrder)+(select costLevel From tblTransportation join tblOrder on tblTransportation.id = tblOrder.transportCode))-(select depreciate from tblOrder join tblPromotion on tblOrder.promotionCode = tblPromotion.id ))
	end
	return @sum
END

--- LINH --- 1710165 ---
GO
CREATE FUNCTION funcFindRate(@idShop VARCHAR(6), @star INT, @type INT) --type = 0 --> "=", type = 1 --> "<=", type = 2 --> ">="
RETURNS @tempTable TABLE (idShop VARCHAR(6), idCustomer VARCHAR(6), star INT, describe NVARCHAR(100))
AS
BEGIN
	IF @type = 0
	BEGIN
		INSERT INTO @tempTable (idShop, idCustomer, star, describe) SELECT idShop, idCustomer, star, describe 
		FROM dbo.tblRate WHERE idShop = @idShop AND star = @star
	END
	ELSE 
		BEGIN
			IF @type = 1
			BEGIN
				INSERT INTO @tempTable (idShop, idCustomer, star, describe) SELECT idShop, idCustomer, star, describe 
				FROM dbo.tblRate WHERE idShop = @idShop AND star <= @star
			END
			ELSE
			BEGIN
				INSERT INTO @tempTable (idShop, idCustomer, star, describe) SELECT idShop, idCustomer, star, describe 
				FROM dbo.tblRate WHERE idShop = @idShop AND star >= @star
			END
		END
	RETURN
END
GO
CREATE FUNCTION funcAvgRate (@idShop VARCHAR(6))
RETURNS FLOAT
AS
BEGIN
	DECLARE @avgRate AS FLOAT
	SET @avgRate = 0
	--SET @avgRate = (SELECT AVG(CAST(star AS FLOAT)) FROM tblRate WHERE idShop = @idShop)
	DECLARE @tempTable TABLE(idShop VARCHAR(6), idCustomer VARCHAR(6), star INT, describe NVARCHAR(100))
	INSERT INTO @tempTable (idShop, idCustomer, star, describe) SELECT idShop, idCustomer, star, describe FROM dbo.tblRate WHERE idShop = @idShop
	DECLARE @count FLOAT = (SELECT COUNT(idShop) FROM @tempTable WHERE idShop = @idShop)
	WHILE (SELECT COUNT(*) FROM @tempTable WHERE idShop = @idShop) > 0
		BEGIN
		SET @avgRate = @avgRate + (SELECT TOP 1 star FROM @tempTable WHERE idShop = @idShop)
		UPDATE TOP (1) @tempTable Set idShop = 'x' Where idShop = @idShop 
		END
	SET @avgRate = @avgRate/@count
	RETURN @avgRate
END
GO
SELECT dbo.[funcAvgRate]('CH0001')
SELECT * FROM dbo.[funcFindRate]('CH0001',5,1)
GO

