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

-------PHẦN CỦA LIÊM---------
create procedure sortTransportationByCost
	@isIncrease bit
as
begin
	if @isIncrease = 1
	begin
		select *
		from tblTransportation
		order by costLevel
	end
	else
	begin
		select *
		from tblTransportation
		order by costLevel desc
	end
end
exec sortTransportationByCost 0
go

create procedure updateOrderStatus
	@idOrder Varchar(50),
	@orderStatus Nchar(50)
as
begin
	update tblOrder
	set orderStatus = @orderStatus
	Where id = @idOrder
end

create procedure searchPromotionOfShop
	@nameShop NVARCHAR(50)
as
begin
	select id,idShop,startTime,endTime
	from tblPromotion
	where exists
	(SELECT ID 
	FROM tblShop 
	where name = @nameShop)
	
end

drop procedure searchPromotionOfShop
--- PHẦN CỦA NAM ---
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

---- phần của tâm ----
CREATE PROC usp_insert_cate
	@id				char(3),
	@name			nvarchar(30),
	@quantity		int	
As	begin  
--declare set 
			begin try 
		insert into tblCATEGORY(id, name, quantity) values (@id, @name, @quantity)
		print 'Insert product successfully'
		return @@ROWCOUNT
			end try
--- catch
			begin catch
		print 'Error insert category
Category was already exist'
		return 0
			end catch
	end
Go
CREATE prOC usp_List_Cart		-- Link 4 relation: cart, product, addcart, customer
	@first_name		NVARCHAR(20),
	@last_name		NVARCHAR(20)
	as
	begin
	declare @id_cus	varchar(50)
	select @id_cus = id_customer from tblCustomer 
	where first_name=@first_name and last_name=@last_name;
	Select idproduct,name as name_pro,	idshop,	quantity
	from 	(tblADD_CART INNER JOIN tblProduct
	ON	tblADD_CART.idproduct=tblProduct.id) INNER JOIN tblCART 
	on	tblADD_CART.idcart=tblCART.id
	where	tblCART.idclient=@id_cus
	order by quantity ASC;	
	--Select id_customer from tblCustomer 

	end
go
CREATE PROCEDURE usp_Pro_MulFunction
	-- Add the parameters for the stored procedure here
	@name_pro nvarchar(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    -- Insert statements for procedure here
	select idcate, name 
	from tblBELONG_CATEGORY inner join
			tblCATEGORY on idcate=id
	where idproduct IN (SELECT idproduct 
	FROM tblBELONG_CATEGORY
	Group by idproduct
	Having count(idcate) > 1)
	and idproduct IN (select id from tblProduct 
						where name=@name_pro)
END
GO
