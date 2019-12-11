-- Ngô Thanh Liêm - 1711929
USE dbTipee
Go
-------Nam------
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

select dbo.totalMoneyFromHas('MDH001')

go
----------Li�m-----------
CREATE FUNCTION totalMoneyByDepreciate
(
	@idOrder VARCHAR(50)
)
returns float
BEGIN
	declare @sum int
	set @sum = dbo.totalMoneyFromHas(@idOrder)
	if(@sum >= (select minTotal from tblOrder join tblPromotion on tblOrder.promotionCode = tblPromotion.id ))
	begin
		set @sum = ((dbo.totalMoneyFromHas(@idOrder)+(select costLevel From tblTransportation join tblOrder on tblTransportation.id = tblOrder.transportCode))-(select depreciate from tblOrder join tblPromotion on tblOrder.promotionCode = tblPromotion.id ))
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

--- phần của Nam ---
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


go
create function totalOrderFromShop
(
	@idShop VARCHAR(50)
)
returns int
as
begin
	declare @count int
	set @count = 0
	select @count = count(*) 
	from (select distinct idOrder, idShop from tblHas) as orderFromShop
	where idShop = @idShop
	return @count
end

go

go
create function totalShopSellProduct
(
	@idProduct VARCHAR(50)
)
returns int
as
begin
	if exists(select 1 from tblProduct where id = @idProduct)
	begin
	declare @count int
	set @count = 0
	select @count = count(*)
	from (select distinct idShop, idProduct from tblSell) as shopOrderProduct
	where idProduct = @idProduct
	return @count
	end
	else
	begin
		return -1
	end
	return 0
end

go
create function totalProductSellShop
(
	@idShop VARCHAR(50),
	@money int
)
returns int
as
begin
	if @money < 0
	begin
		return -1
	end
	declare @count int
	set @count = 0
	select @count = count(*)
	from tblSell
	where idShop = @idShop and unitPrice >= @money
	return @count
end

go
create function findProduct
(
	@stringFind NVARCHAR(100)
)
	returns @tempTable table
	(id VARCHAR(50),
	name NVARCHAR(100) COLLATE SQL_Latin1_General_CP1_CI_AI not null,
	size CHAR(50),
	img text,
	color NVARCHAR(100),
	detail text,
	idProduct VARCHAR(50) not null,
	idShop VARCHAR(50) not null,
	amount int not null,
	unitPrice int not null)
as
begin
	if len(@stringFind) >= 5
	begin
		declare @leftString NVARChar(5)
		declare @rightString NVARCHAR(5)
		declare @subString NVARCHAR(5)
		set @leftString = left(@stringFind, 5)
		set @rightString = RIGHT(@stringFind, 5)
		set @subString = SUBSTRING(@stringFind, len(@stringFind)/2 - 2, 5)
		insert into @tempTable
		select id, name, size, img, color, detail, idProduct, idShop, amount, unitPrice
		from tblProduct, tblSell
		where (id like '%' + @leftString + '%' 
		or id like '%' + @rightString + '%' 
		or id like '%' + @subString + '%'
		or name like '%' + @leftString + '%'
		or name like '%' + @rightString + '%' 
		or name like '%' + @subString + '%'
		or detail like '%' + @stringFind + '%')
		and id = idProduct
		order by name
	end
	else
	begin
		insert into @tempTable
		select id, name, size, img, color, detail, idProduct, idShop, amount, unitPrice
		from tblProduct, tblSell
		where (id like '%' + @stringFind + '%' 
		or id like '%' + @stringFind + '%' 
		or id like '%' + @stringFind + '%'
		or name like '%' + @stringFind + '%'
		or name like '%' + @stringFind + '%' 
		or name like '%' + @stringFind + '%'
		or detail like '%' + @stringFind + '%')
		and id = idProduct
		order by name
	end
	return
end

-- ham sort san pham theo ten hoac theo gia
go

--- PHẦN CỦA TÂM ---
CREATE FUNCTION ufnsum
(
	@first_name		NVARCHAR(20),
	@last_name		NVARCHAR(20)
)
RETURNS int
AS
BEGIN
	-- Declare the return variable here
	DECLARE @ResultVar	int
	declare @id_cus	varchar(50)
	select @id_cus = id_customer from tblCustomer 
	where first_name=@first_name and last_name=@last_name;

	Select @ResultVar = count(*)
	from 	(tblADD_CART INNER JOIN tblProduct
	ON	tblADD_CART.idproduct=tblProduct.id) INNER JOIN tblCART 
	on	tblADD_CART.idcart=tblCART.id
	where	tblCART.idclient=@id_cus;
	
	-- Return the result of the function
	RETURN @ResultVar
END
GO

select dbo.ufnsum('ly','tran') as TotalProductinCart;
go
