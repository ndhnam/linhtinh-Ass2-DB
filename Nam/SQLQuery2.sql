CREATE DATABASE dbTipee

USE dbTipee

GO
CREATE TABLE tblProduct
(
	id VARCHAR(50) primary key,
	name NVARCHAR(100) COLLATE SQL_Latin1_General_CP1_CI_AI not null,
	size CHAR(50),
	img text,
	color NVARCHAR(100),
	detail text
)

GO
CREATE TABLE tblHas
(
	idOrder VARCHAR(50) not null,
	idShop VARCHAR(50)  not null,
	idProduct varchar(50) not null,
	unitPrice int not null,
	amount int not null,
	PRIMARY KEY(idOrder, idShop, idProduct)
)

CREATE TABLE tblSell
(
	idShop VARCHAR(50) not null,
	idProduct VARCHAR(50) not null,
	amount int not null,
	unitPrice int not null,
	PRIMARY KEY(idShop, idProduct)
)

ALTER TABLE tblHas
	ADD CONSTRAINT fk_has_product_id
	FOREIGN KEY (idProduct) REFERENCES tblProduct(id)
	ON DELETE CASCADE

ALTER TABLE tblSell
	ADD CONSTRAINT fk_sell_product_id
	FOREIGN KEY (idProduct) REFERENCES tblProduct(id)
	ON DELETE CASCADE

GO

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



exec insertProduct '8865872832669', 
'Laptop HP ENVY 13-AQ0026TU (Intel Core I5-8265U 8GB RAM DDR4 256GB SSD 13,3" FHD WIN10 HOME Pale gold-6ZF38PA)', 
'0',
'https://salt.tikicdn.com/cache/w1200/ts/product/51/ab/b1/c71ef2cd42a284c4304d6037b09cfaa0.jpg https://salt.tikicdn.com/cache/w1200/ts/product/a2/25/96/508afca637007c197146f43703742be0.jpg',
'silver', 
'Cutting-edge security: state-of-the-art security Features include webcam kill switch and integrated fingerprint reader
4K display: 13.3-Inch diagonal 4K IPS micro-edge WLED-backlit touchscreen with durable protective corning(r) Gorilla) Glass nbt(tm) (3840 x 2160) to stand up to everyday bumps and scrapes. 8.2 million pixels bring your content to life in mesmerizing quality with 178-degree wide-viewing angles
Bios recovery and protection: automatically checks the health of your PC, protects against unauthorized access, secures local storage and recovers itself from boot-up issues
Distinctive design: high-quality, durable, all-metal case Built to last, with premium design features including a brilliant backlit keyboard and geometric pattern speaker grill
Super Fast Processor: 8th Generation intel(r) core(tm) i7-8565u, quad-core, 1.8 GHz Base frequency, up to 4.6 GHz with Intel Turbo Boost Technology (8 MB Cache)
Memory and hard drive: 16 GB DDR4-2400 SDRAM (not upgradable), 512 GB pcie(r) nvmetm M.2 Solid State Drive
Battery life: up to 12 hours and 45 minutes (mixed usage), up to 9 hours and 45 minutes (video playback), up to 5 hours and 45 minutes (wireless streaming)
Dimensions AND weight (unpackaged): 12.08 in (H) x 8.32 in (W) x 0.57 in (L); 2.82 pounds
Operating System: Windows 10 Home
Warranty: 1-year limited hardware warranty with 24-hour, 7 days a week Web support
OS : Windows 10 Home'

exec insertProduct '4424616287949',
'Macbook Air 2017 MQD32 (13.3 inch)',
'0',
'https://salt.tikicdn.com/cache/w1200/ts/product/24/1b/e9/0771b005d8b7d4547b2a5fc0012d4721.jpg',
'silver',
'1.8 GHz dual-core Intel Core i5 Processor
Intel HD Graphics 6000
Fast SSD Storage
8GB memory
Two USB 3 ports
Thunderbolt 2 port
Sdxc port'

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


exec insertSell '21710195',
'8865872832669',
'50',
'20700'

exec insertSell '21710187',
'4424616287949',
'21',
'21000'


exec insertSell '21710187',
'8865872832669',
'100',
'20410'

exec updateSell '21710187',
'8865872832669',
'90',
'20410'

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

exec insertHas '061219171019501', '21710187', '8865872832669', '20410', '15'

exec insertHas '061219171019501', '21710187', '4424616287949', '19000', '10'

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

exec queryProductFromShop '21710187'

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


exec queryMoneyFromHas '061219171019501'

exec queryTotalMoney '061219171019501'

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
select dbo.totalOrderFromShop('21710187')

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
select dbo.totalShopSellProduct('8865872832669')

go
select dbo.totalShopSellProduct('4424616287949')

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
select dbo.totalProductSellShop('21710187', '19000')

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

exec findProductByNameOrID 'i5'

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

exec sortProductByName 'false'

exec sortProductByMoney 'false'


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

exec sortProduct 'm', '0', '0'