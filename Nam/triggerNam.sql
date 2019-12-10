create procedure insertProduct
	@id VARCHAR(50),
	@name NVARCHAR(100),
	@size CHAR(50),
	@img text,
	@color NVARCHAR(100),
	@detail text
AS
BEGIN
	begin try 
		insert into tblProduct(id, name, size, img, color, detail) values (@id, @name, @size, @img, @color, @detail)
		print 'Insert product successfully'
		return @@ROWCOUNT
	end try
	begin catch
		print 'Error insert product
Product was already exist+ACE-'
		return 0
	end catch
END


go
create procedure insertSell
	@idShop VARCHAR(50),
	@idProduct varchar(50),
	@amount int,
	@unitPrice int	
as
begin
	begin try 
		insert into tblSell(idShop, idProduct, amount, unitPrice) values (@idShop, @idProduct, @amount, @unitPrice)
		print 'Insert sell successfully'
		return @@ROWCOUNT
	end try
	begin catch
		print 'Error insert sell'
		return 0
	end catch
end

go
create procedure updateSell
	@idShop VARCHAR(50),
	@idProduct varchar(50),
	@amount int,
	@unitPrice int
as
begin
	begin try
		update tblSell
		set amount = @amount, unitPrice = @unitPrice
		where idShop = @idShop and idProduct = @idProduct
	end try
	begin catch
		print 'Error update product
Product does not exist'
	end catch
end


go
create procedure insertHas
	@idOrder VARCHAR(50),
	@idShop VARCHAR(50),
	@idProduct varchar(50),
	@unitPrice int,
	@amount int
as
begin
	begin try
		insert into tblHas(idOrder, idShop, idProduct, unitPrice, amount) values (@idOrder, @idShop, @idProduct, @unitPrice, @amount)
		print 'Insert has successfully'
		return @@ROWCOUNT
	end try
	begin catch
		print 'Error insert has'
		return 0
	end catch
end

go
create trigger check_amount_sell on tblSell for insert as
begin
	declare @amount int
	set @amount = (select amount from inserted)
	if (@amount < 0)
	begin
		print 'Error: amount < 0'
		rollback
	end
end


go
create trigger check_amount_has on tblHas for insert as
begin
	declare @amount int
	declare @amountSell int
	declare @idProduct Varchar(50)
	declare @idShop VARCHAR(50)
	set @amount = (select amount from inserted)
	set @idProduct = (select idProduct from inserted)
	set @idShop = (select idShop from inserted)
	set @amountSell = (select amount from tblSell where @idProduct = tblSell.idProduct and @idShop = tblSell.idShop)
	if (@amount <= 0 and @amount > @amountSell )
	begin
		print 'Error: amount <= 0 or amount > amountSell'
		rollback
	end
end


go
create trigger update_amount_sell on tblHas after insert as
begin
	update tblSell
	set tblSell.amount = tblSell.amount - (
		select amount
		from inserted
		where idShop = tblSell.idShop and idProduct = tblSell.idProduct
	)
	from tblSell
	join inserted on tblSell.idProduct = inserted.idProduct and tblSell.idShop = inserted.idShop
end

go
create procedure queryProductFromShop
	@idShop VARCHAR(50)
as
begin
	begin try
		print 'print id - name product shop sell'
		select idProduct, name, size, img, color, detail, amount, unitPrice
		from tblSell, tblProduct
		where tblSell.idShop = @idShop and tblProduct.id = tblSell.idProduct
		order by idProduct
	end try
	begin catch
		print 'Error query ProductFromShop'
	end catch
end

go
create procedure queryMoneyFromHas
	@idOrder VARCHAR(50)
as
begin
	begin try
		print 'query money from has'
		select idProduct, name, unitPrice, amount, (unitPrice*amount) as money
		from tblHas, tblProduct
		where tblHas.idOrder = @idOrder and tblHas.idProduct = tblProduct.id
		order by idProduct
	end try
	begin catch
		print 'Error query money from has'
	end catch
end

go
create procedure queryTotalMoney
	@idOrder VARCHAR(50)
as
begin
	begin try
		print 'query total money from has'	
		select sum(money) as total_money
		from (select (unitPrice*amount) as money
			from tblHas
			where tblHas.idOrder = @idOrder) as totalMoney
	end try
	begin catch
		print 'Error query total money from has'
	end catch
end		

go
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
create procedure findProductByNameOrID
	@stringFind NVARCHAR(100)
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
		select *
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
		select *
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
end

--drop proc findProductByNameOrID

go
create procedure sortProductByName
	@isIncrease bit
as
begin
	if @isIncrease = 1
	begin
		select *
		from tblProduct, tblSell
		where id = idProduct
		order by name
	end
	else
	begin
		select *
		from tblProduct, tblSell
		where id = idProduct
		order by name desc
	end
end

go
create procedure sortProductByMoney
	@isIncrease bit
as
begin
	if @isIncrease = 1
	begin
		select *
		from tblProduct, tblSell
		where id = idProduct
		order by unitPrice
	end
	else
	begin
		select *
		from tblProduct, tblSell
		where id = idProduct
		order by unitPrice desc
	end
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
create procedure sortProduct
	@stringFind NVARCHAR(100),
	@isName int, -- if 0 khong sort, if 1 sort theo ten, if 2 sort theo gia, if 3 sort theo ten va gia, if 4 sort theo gia va ten
	@isIncrease bit 
as
begin
	if @isName = 0
	begin 
		select * from findProduct(@stringFind) where id = idProduct
	end
	else if @isName = 1
	begin
		select * from findProduct(@stringFind) where id = idProduct order by name
	end
	else if @isName = 2
	begin
		if @isIncrease = 1
		begin
			select * from findProduct(@stringFind) where id = idProduct order by unitPrice
		end
		else
		begin
			select * from findProduct(@stringFind) where id = idProduct order by unitPrice desc
		end
	end
	else if @isName = 3
	begin
		if @isIncrease = 1
		begin
			select * from findProduct(@stringFind) where id = idProduct order by name, unitPrice
		end
		else
		begin
			select * from findProduct(@stringFind) where id = idProduct order by name, unitPrice desc
		end
	end
	else if @isName = 4
	begin
		if @isIncrease = 1
		begin
			select * from findProduct(@stringFind) where id = idProduct order by unitPrice, name
		end
		else
		begin
			select * from findProduct(@stringFind) where id = idProduct order by unitPrice desc, name
		end
	end
end
