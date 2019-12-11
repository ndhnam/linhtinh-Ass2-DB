--Tâm 1713057--
use dbTipee 
go
-- Table 
create TABLE tblCART(
	id			varchar(50) not null,
	primary key(id),
	--id nvarchar(9) primary key,
	idclient	varchar(50) not null,
	--foreign key(idclient) references Client(id)
);
GO
create TABLE tblADD_CART(
	idcart		nvarchar(9) not null,
	idproduct	VARCHAR(50) not null,
	idshop		VARCHAR(6) not null,
	primary key(idcart,idproduct,idshop),
	quantity	int )
;
GO
CREATE TABLE tblCATEGORY(
	id				char(3) not null,
	primary key(id),
	name			nvarchar(30),
	quantity		int			DEFAULT 0			--- tt dẫn xuất 
);
go
CREATE TABLE tblBELONG_CATEGORY(
	idproduct	varchar(50) not null,
	idcate		char(3) not null,
	primary key(idcate,idproduct)
);
go
/*Insert data*/
INSERT INTO tblCART VALUES ('C01','KH0001');
INSERT INTO tblCART VALUES ('C02','KH0002');
INSERT INTO tblCART VALUES ('C03','KH0003');
INSERT INTO tblCART VALUES ('C04','KH0004');
INSERT INTO tblCART VALUES ('C05','KH0005');

INSERT INTO tblADD_CART VALUES ('CO1','8865872832669','CH0001',5);
INSERT INTO tblADD_CART VALUES ('CO1','4424616287949','CH0001',2);
INSERT INTO tblADD_CART VALUES ('CO1','4424616287949','CH0002',1);
INSERT INTO tblADD_CART VALUES ('CO2','4424616287949','CH0001',2);


INSERT INTO tblCATEGORY VALUES ('EL',N'Electronics',0);
INSERT INTO tblCATEGORY VALUES ('FA',N'Fashion',0);
INSERT INTO tblCATEGORY VALUES ('BO',N'Book',0);
INSERT INTO tblCATEGORY VALUES ('FO',N'FOOD',0);
INSERT INTO tblCATEGORY VALUES ('ST',N'Stationery',0);
INSERT INTO tblCATEGORY VALUES ('TO',N'Toy',0);

INSERT INTO tblBELONG_CATEGORY VALUES ('8865872832669','EL');
INSERT INTO tblBELONG_CATEGORY VALUES ('4424616287949','EL');
go

ALTER TABLE tblCART
	ADD 
		CONSTRAINT		fk_cart_customer		FOREIGN KEY (idclient)
	REFERENCES tblCustomer(id_customer)
	ON DELETE CASCADE
	ON UPDATE CASCADE;
go
--ALTER TABLE tblADD_CART   idproduct	VARCHAR(50);
go

ALTER TABLE tblADD_CART
	ADD 
		CONSTRAINT	fk_cart_addcart		FOREIGN KEY (idcart)
	REFERENCES tblCART(id)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
		CONSTRAINT	fk_pro_addcart		FOREIGN KEY (idproduct)
	REFERENCES tblProduct(id)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
		CONSTRAINT	fk_shop_addcart		FOREIGN KEY (idshop)
	REFERENCES tblShop(id)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
		CONSTRAINT	check_quantity		CHECK(quantity>0)
go

ALTER TABLE tblCATEGORY
	ADD 
		CONSTRAINT	check_quantity_cate 	CHECK(quantity>=0);
go

ALTER TABLE tblBELONG_CATEGORY
	ADD 
	CONSTRAINT	fk_cate	FOREIGN KEY (idcate)
	REFERENCES tblCATEGORY(id)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	CONSTRAINT	fk_cate_pro	FOREIGN KEY (idproduct)
	REFERENCES tblProduct(id)
	ON DELETE CASCADE
	ON UPDATE CASCADE;
go 
--- procedure insert + validate + print error
Create Proc usp_insert_cate
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
;
Go
exec usp_insert_cate 'HO','home',3;
exec usp_insert_cate 'HO','home',-1;
go
-- trigger after--
create trigger check_quantity_trigger on tblADD_CART
for insert
as 
begin
	declare @quantity int
	set @quantity = (select quantity from inserted)
	if (@quantity <=0)
	begin
		print 'error: quantity must have value'
		rollback
	end
end;
go
INSERT INTO tblADD_CART VALUES ('1','Toy','3',-1);
---trigger after affect other table---
CREATE TRIGGER Update_QuanofCate ON tblBELONG_CATEGORY
FOR INSERT 
AS
BEGIN

	DECLARE @idcate CHAR(3)

	SELECT @idcate = Inserted.idcate FROM Inserted

	UPDATE tblCATEGORY SET quantity=quantity+1 WHERE id = @idcate

END
GO
INSERT INTO tblBELONG_CATEGORY VALUES ('231','HO');
SELECT TOP 10 *
		FROM tblCATEGORY
		ORDER BY quantity ASC;
go
--Procedure has Query Statement hiểnthị dữ liệu,tham số đầu vào là giá trị trong mệnh đề WHERE và/hoặc Having
--a. 1 câu truy vấn từ 2 bảng trở lên có mệnh đề where, order by---
CREATE prOC usp_Sort_Name_Cate
	as
	begin

	end
go
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
exec	usp_List_Cart 'b','a'
WITH RESULT SETS
(
(
[Product ID] varchar(50),
[Product Name] nvarchar(100),
[Shop ID] varchar(50),
[Order Quantity] int
)
)
go
--procedure có aggreate function, group by, having, where và order by có liên kết từ 2 bảng trở lên
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
exec usp_Pro_MulFunction 'book'
with result sets (
	( [Code Cate] varchar(50) ,
		[Name Cate]	varchar(50)
	)
)

go
/* Chứa câu lệnh IF và/hoặc LOOP để tính toán dữ liệu được lưu trữ
b. Chứa câu lệnh truy vấn dữ liệu, lấy dữ liệu từ câu truy vấn để kiểm tra tính toán
c. Có tham số đầu vào và kiểm tra tham số đầu vào
Mỗi thành viên viết 2 câu SELECT để minh họa việc gọi hàm trong câu SELECT */
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
-- Function FavoriteShop--
