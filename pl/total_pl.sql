CREATE DATABASE dbTipee
USE dbTipee
GO
-- Phần của Linh --
CREATE TABLE tblAccount
(
	id			VARCHAR(6)		PRIMARY KEY,			-- ID
	username	VARCHAR(32)		NOT NULL,				-- Tên tài khoản
	password	VARCHAR(100)	NOT NULL,				-- Mật khẩu
);

CREATE TABLE tblShop
(
	id				VARCHAR(6)		PRIMARY KEY,	-- ID
	name			NVARCHAR(50)		NOT NULL,	-- Tên Shop
	number			INT,							-- Số điện thoại
	address			NVARCHAR(100),					-- Địa chỉ
	email			VARCHAR(50),					-- Email
	avatar			VARCHAR(100),					-- Ảnh đại diện
	classify		INT,							-- Phân loại (0 - không chuyên, 1 - chuyên)
	typesOfShop		NVARCHAR(30),					-- Sản phẩm chuyên về (danh mục)
	distribution	NVARCHAR(10),					-- Sỉ/lẻ
	total_rate		INT,							-- Tổng lượt đánh giá --
	CONSTRAINT fk_shop_acc_id FOREIGN KEY (id) REFERENCES tblAccount(id),
);

CREATE TABLE tblRate
(
	idCustomer		VARCHAR(6)		NOT NULL,		-- id khách hàng 
	idShop			VARCHAR(6)		NOT NULL,		-- id cửa hàng 
	star			INT				NOT NULL,		-- số sao khách hàng đánh giá 
	describe		NVARCHAR(100),					-- đánh giá 
	PRIMARY KEY(idCustomer, idShop),
	CONSTRAINT fk_rate_shop_id FOREIGN KEY (idShop) REFERENCES tblShop(id)
	--CONSTRAINT fk_rate_cus_id FOREIGN KEY (idCustomer) REFERENCES tblCustomer(id_customer)
);
CREATE TABLE tblCustomer 
(
	id_customer VARCHAR(6) PRIMARY KEY,
	last_name NVARCHAR(20), 
	first_name NVARCHAR(20),
	email VARCHAR(100) NOT NULL,
	sex BIT,
	date_of_birth DATE,
	id_intro VARCHAR(15),
	id_reduce VARCHAR(15),
	CONSTRAINT fk_cus_acc_id FOREIGN KEY (id_customer) REFERENCES tblAccount(id)
);

ALTER TABLE dbo.tblRate
	ADD CONSTRAINT fk_rate_cus_id
	FOREIGN KEY (idCustomer) REFERENCES tblCustomer(id_customer)
	ON DELETE CASCADE
/*
ALTER TABLE dbo.tblShop
	ADD CONSTRAINT fk_shop_acc_id
	FOREIGN KEY (id) REFERENCES tblAccount(id)
	ON DELETE CASCADE
ALTER TABLE dbo.tblRate
	ADD CONSTRAINT fk_rate_shop_id
	FOREIGN KEY (idShop) REFERENCES tblShop(id)
	ON DELETE CASCADE 
ALTER TABLE dbo.tblCustomer
	ADD CONSTRAINT fk_cus_acc_id
	FOREIGN KEY (id_customer) REFERENCES tblAccount(id)
	ON DELETE CASCADE
*/


GO
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

--INSERT INTO dbo.tblAccount(id, username, password) VALUES ('CH0004','admin','admin')
EXEC dbo.insertShopAccount 'CH0001', 'ch01', 'ch01', 'SHOP A', 111111111, N'7A/19 Thành Thái, Phường 14, Quận 10, Hồ Chí Minh, Việt Nam', 'email1@gmail.com', N'link', '1', N'THIẾT BỊ', N'Sỉ';
EXEC dbo.insertShopAccount 'CH0002', 'ch02', 'ch02', 'SHOP B', 999999999, N'Số 30 Đường Số 52, Lữ Gia, Phường 15, Quận 11, Hồ Chí Minh 72621, Việt Nam', 'email2@gmail.com', N'link', '0', N'THỜI TRANG', N'Lẻ';
EXEC dbo.insertShopAccount 'CH0003', 'ch03', 'ch03', 'SHOP C', 333333333, N'270B Lý Thường Kiệt, Phường 14, Quận 10, Hồ Chí Minh, Việt Nam', 'email3@gmail.com', N'link', '1', N'GIA DỤNG', N'Sỉ, lẻ';
EXEC dbo.insertShopAccount 'CH0004', 'ch04', 'ch04', 'SHOP D', 222222222, N'73 Đường Mai Thị Lựu, Đa Kao, Quận 1, Hồ Chí Minh 700000, Việt Nam', 'email4@gmail.com', N'link', '0', N'THỜI TRANG', N'Sỉ';
EXEC dbo.insertShopAccount 'CH0005', 'ch05', 'ch05', 'SHOP E', 555555555, N'282/20 Đường Bùi Hữu Nghĩa, Phường 2, Bình Thạnh, Hồ Chí Minh, Việt Nam', 'email5@gmail.com', N'link', '1', N'ĐỒNG HỒ', N'Lẻ';
EXEC dbo.insertShopAccount 'CH0006', 'ch06', 'ch06', 'SHOP F', 666666666, N'10 Đường Mai Chí Thọ, An Lợi Đông, Quận 2, Hồ Chí Minh 700000, Việt Nam', 'email6@gmail.com', N'link', '0', N'THỂ THAO', N'Sỉ, lẻ';
EXEC dbo.insertShopAccount 'CH0007', 'ch07', 'ch07', 'SHOP G', 666666666, N'10 Đường Mai Chí Thọ, An Lợi Đông, Quận 2, Hồ Chí Minh 700000, Việt Nam', 'email7', N'link', '0', N'THỂ THAO', N'Sỉ, lẻ';
EXEC dbo.insertShopAccount 'CH0008', 'ch08', 'ch08', 'SHOP H', 666666666, N'10 Đường Mai Chí Thọ, An Lợi Đông, Quận 2, Hồ Chí Minh 700000, Việt Nam', 'email8@gmail.com', N'link', '0', N'THỂ THAO', N'Sỉ, lẻ';
EXEC dbo.insertShopAccount 'CH0009', 'ch09', 'ch09', 'SHOP I', 123453234, N'10 Đường Mai Chí Thọ, An Lợi Đông, Quận 2, Hồ Chí Minh 700000, Việt Nam', 'email9', N'link', '0', N'THỂ THAO', N'Sỉ, lẻ';

GO
SELECT * FROM dbo.tblAccount
SELECT * FROM dbo.tblShop
SELECT * FROM dbo.tblRate
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
CREATE TRIGGER trgCountRate ON dbo.tblRate
AFTER INSERT
AS
BEGIN
	DECLARE @count_idCustomer INT = (SELECT COUNT(idCustomer) FROM dbo.tblRate WHERE idShop = (SELECT idShop FROM inserted))
	UPDATE dbo.tblShop SET total_rate = @count_idCustomer WHERE id = (SELECT idShop FROM inserted)
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
CREATE TRIGGER trgDeleteRate ON dbo.tblRate
FOR DELETE	
AS
BEGIN
	DECLARE @cur_idShop VARCHAR(6) = (SELECT idShop FROM deleted)
	DECLARE	@cur_idCustomer VARCHAR(6) = (SELECT idCustomer FROM deleted)
	DECLARE @curTotalRate INT = (SELECT total_rate FROM tblShop WHERE id = @cur_idShop) - 1 
	PRINT @curTotalRate
	UPDATE dbo.tblShop 
	SET total_rate = @curTotalRate
	WHERE id = @cur_idShop
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

EXEC insertCustomerAccount 'KH0001','kh01','kh01',N'Uzumaki',N'Naruto','naruto@gmail.com',0,'19991010','','';
EXEC insertCustomerAccount 'KH0002','kh02','kh02',N'Uchiha',N'Sasuke','sasuke@gmail.com',0,'19991010','','';
EXEC insertCustomerAccount 'KH0003','kh03','kh03',N'Nara',N'Shikamaru','shikamaru@gmail.com',0,'19991010','','';
SELECT * FROM dbo.tblAccount
SELECT * FROM dbo.tblCustomer

EXEC writeReviewShop 'CH0001', 'kh01', 'kh01', 5, N'Đẹp';
EXEC writeReviewShop 'CH0001', 'kh02', 'kh02', 4, N'Đẹp';
EXEC writeReviewShop 'CH0001', 'kh03', 'kh03', 5, N'Hàng tốt đó!';
EXEC writeReviewShop 'CH0001', 'kh04', 'kh04', 3, N'Tạm được!';
EXEC writeReviewShop 'CH0002', 'kh01', 'kh01', 3, N'Tạm được!';
EXEC writeReviewShop 'CH0002', 'kh01', 'kh01', 2, N'Tạm được!';
EXEC writeReviewShop 'CH0001', 'kh05', 'kh05', 5, N'OK đấy!';
SELECT * FROM dbo.tblRate
SELECT * FROM dbo.tblShop
EXEC deleteReviewShop 'CH0001','kh01','kh01';
EXEC deleteReviewShop 'CH0001','kh02','kh02';
SELECT * FROM dbo.tblRate
SELECT * FROM dbo.tblShop
GO
CREATE TRIGGER trgCheckEmail ON dbo.tblShop
AFTER INSERT
AS
BEGIN
	DECLARE @cur_email VARCHAR(50) = (SELECT email FROM inserted)
	DECLARE @check AS BIT;
	IF @cur_email NOT LIKE '%@%.%'
		BEGIN 
			PRINT 'Format of email is %@%.%'
			DELETE FROM dbo.tblAccount WHERE id = (SELECT id FROM inserted)
			--ROLLBACK
			--UPDATE dbo.tblShop SET email = (SELECT email FROM tblShop WHERE id = (SELECT id FROM inserted)) + '@gmail.com' WHERE id = (SELECT id FROM inserted)
		END
	ELSE
		PRINT 'SUCCESS'
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
SELECT * FROM dbo.tblRate
SELECT dbo.[funcAvgRate]('CH0001')
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
SELECT * FROM dbo.tblRate
SELECT * FROM dbo.[funcFindRate]('CH0001',5,1)

/*
Declare @Id int

While (Select Count(*) From ATable Where Processed = 0) > 0
Begin
    Select Top 1 @Id = Id From ATable Where Processed = 0

    --Do some processing here

    Update ATable Set Processed = 1 Where Id = @Id 

End
*/
-- Phần của Liêm --
GO
CREATE TABLE tblTransportation
(
	id				Char(9)		PRIMARY KEY,
	nameTrans		Nchar(50)	NOT NULL,
	hotline			Int			NOT NULL,
	mail			Char(50)	NOT NULL,
	costLevel		Int			NOT NULL,
	addressTrans	Char(100)	NOT NULL
);

CREATE TABLE tblOrder
(
	id				Char(9)		PRIMARY KEY,
	methodOfPayment Nchar(50)	NOT NULL,
	bookingTime		Date		NOT NULL,
	deliveryTime	Date		NOT NULL,
	orderStatus		Nchar(50)	NOT NULL,
	transportCode	Char(50)	NOT NULL,
	transportCost	Int			NOT NULL,
	idCustomer		Char(9)	NOT NULL,
	promotionCode	Char(50)	NOT NULL
);
-- Phần của Tâm --
CREATE TABLE tblCART(
    id          nvarchar(9) NOT NULL,
    PRIMARY KEY(id),
    --id nvarchar(9) primary key,
    idclient    nvarchar(10) NOT NULL,
    --foreign key(idclient) references Client(id)
);
GO
CREATE TABLE tblADD_CART(
    idcart      nvarchar(9) NOT NULL,
    idproduct   VARCHAR(50) NOT NULL,
    idshop      VARCHAR(6) NOT NULL,
    PRIMARY KEY(idcart,idproduct,idshop),
    quantity    INT )
;
GO
CREATE TABLE tblCATEGORY(
    id              CHAR(3) NOT NULL,
    PRIMARY KEY(id),
    name            nvarchar(30),
    quantity        INT         DEFAULT 0           --- tt dẫn xuất
);
GO
CREATE TABLE tblBELONG_CATEGORY(
    idproduct   VARCHAR(50) NOT NULL,
    idcate      CHAR(3) NOT NULL,
    PRIMARY KEY(idcate,idproduct)
);
GO

-- Phần của Ly --

CREATE TABLE tblTelephoneNumber
(
	tel_number VARCHAR(11),
	id_customer VARCHAR(10),
	PRIMARY KEY(tel_number, id_customer)
); 

CREATE TABLE tblAdrress 
(
	addr NVARCHAR(100), 
	id_customer VARCHAR(10),
	province NVARCHAR(100),
	city NVARCHAR(100),
	ward NVARCHAR(100),
	detail NTEXT,
	type_address VARCHAR(10),
	PRIMARY KEY(addr, id_customer)
);

ALTER TABLE tblTelephoneNumber 
ADD CONSTRAINT FK_CustomerTelephoneNumber
FOREIGN KEY(id_customer) REFERENCES tblCustomer(id_customer);

ALTER TABLE tblAdrress
ADD CONSTRAINT FK_Customer_Address
FOREIGN KEY(id_customer) REFERENCES tblCustomer(id_customer);
GO 

-- Phần của Nam --
CREATE TABLE tblProduct
(
    id VARCHAR(50) PRIMARY KEY,
    name NVARCHAR(100) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
    SIZE CHAR(50),
    img text,
    color NVARCHAR(100),
    detail text
)
 
GO
CREATE TABLE tblHas
(
    idOrder VARCHAR(50) NOT NULL,
    idShop VARCHAR(50)  NOT NULL,
    idProduct VARCHAR(50) NOT NULL,
    unitPrice INT NOT NULL,
    amount INT NOT NULL,
    PRIMARY KEY(idOrder, idShop, idProduct)
)
 
CREATE TABLE tblSell
(
    idShop VARCHAR(50) NOT NULL,
    idProduct VARCHAR(50) NOT NULL,
    amount INT NOT NULL,
    unitPrice INT NOT NULL,
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
 
CREATE PROCEDURE insertProduct
    @id VARCHAR(50),
    @name NVARCHAR(100),
    @SIZE CHAR(50),
    @img text,
    @color NVARCHAR(100),
    @detail text
AS
BEGIN
    BEGIN try
        INSERT INTO tblProduct(id, name, SIZE, img, color, detail) VALUES (@id, @name, @SIZE, @img, @color, @detail)
        print 'Insert product successfully'
        RETURN @@ROWCOUNT
    END try
    BEGIN catch
        print 'Error insert product
Product was already exist+ACE-'
        RETURN 0
    END catch
END
 
 
 
EXEC insertProduct '8865872832669',
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
 
EXEC insertProduct '4424616287949',
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
 
GO
CREATE PROCEDURE insertSell
    @idShop VARCHAR(50),
    @idProduct VARCHAR(50),
    @amount INT,
    @unitPrice INT 
AS
BEGIN
    BEGIN try
        INSERT INTO tblSell(idShop, idProduct, amount, unitPrice) VALUES (@idShop, @idProduct, @amount, @unitPrice)
        print 'Insert sell successfully'
        RETURN @@ROWCOUNT
    END try
    BEGIN catch
        print 'Error insert sell'
        RETURN 0
    END catch
END
 
GO
CREATE PROCEDURE updateSell
    @idShop VARCHAR(50),
    @idProduct VARCHAR(50),
    @amount INT,
    @unitPrice INT
AS
BEGIN
    BEGIN try
        UPDATE tblSell
        SET amount = @amount, unitPrice = @unitPrice
        WHERE idShop = @idShop AND idProduct = @idProduct
    END try
    BEGIN catch
        print 'Error update product
Product does not exist'
    END catch
END
 
 
EXEC insertSell '21710195',
'8865872832669',
'50',
'20700'
 
EXEC insertSell '21710187',
'4424616287949',
'21',
'21000'
 
 
EXEC insertSell '21710187',
'8865872832669',
'100',
'20410'
 
EXEC updateSell '21710187',
'8865872832669',
'90',
'20410'
 
GO
CREATE PROCEDURE insertHas
    @idOrder VARCHAR(50),
    @idShop VARCHAR(50),
    @idProduct VARCHAR(50),
    @unitPrice INT,
    @amount INT
AS
BEGIN
    BEGIN try
        INSERT INTO tblHas(idOrder, idShop, idProduct, unitPrice, amount) VALUES (@idOrder, @idShop, @idProduct, @unitPrice, @amount)
        print 'Insert has successfully'
        RETURN @@ROWCOUNT
    END try
    BEGIN catch
        print 'Error insert has'
        RETURN 0
    END catch
END
 
EXEC insertHas '061219171019501', '21710187', '8865872832669', '20410', '15'
 
EXEC insertHas '061219171019501', '21710187', '4424616287949', '19000', '10'
 
GO
CREATE TRIGGER check_amount_sell ON tblSell FOR INSERT AS
BEGIN
    DECLARE @amount INT
    SET @amount = (SELECT amount FROM inserted)
    IF (@amount < 0)
    BEGIN
        print 'Error: amount < 0'
        ROLLBACK
    END
END
 
 
GO
CREATE TRIGGER check_amount_has ON tblHas FOR INSERT AS
BEGIN
    DECLARE @amount INT
    DECLARE @amountSell INT
    DECLARE @idProduct VARCHAR(50)
    DECLARE @idShop VARCHAR(50)
    SET @amount = (SELECT amount FROM inserted)
    SET @idProduct = (SELECT idProduct FROM inserted)
    SET @idShop = (SELECT idShop FROM inserted)
    SET @amountSell = (SELECT amount FROM tblSell WHERE @idProduct = tblSell.idProduct AND @idShop = tblSell.idShop)
    IF (@amount <= 0 AND @amount > @amountSell )
    BEGIN
        print 'Error: amount <= 0 or amount > amountSell'
        ROLLBACK
    END
END
 
 
GO
CREATE TRIGGER update_amount_sell ON tblHas after INSERT AS
BEGIN
    UPDATE tblSell
    SET tblSell.amount = tblSell.amount - (
        SELECT amount
        FROM inserted
        WHERE idShop = tblSell.idShop AND idProduct = tblSell.idProduct
    )
    FROM tblSell
    JOIN inserted ON tblSell.idProduct = inserted.idProduct AND tblSell.idShop = inserted.idShop
END
 
GO
CREATE PROCEDURE queryProductFromShop
    @idShop VARCHAR(50)
AS
BEGIN
    BEGIN try
        print 'print id - name product shop sell'
        SELECT idProduct, name, SIZE, img, color, detail, amount, unitPrice
        FROM tblSell, tblProduct
        WHERE tblSell.idShop = @idShop AND tblProduct.id = tblSell.idProduct
        ORDER BY idProduct
    END try
    BEGIN catch
        print 'Error query ProductFromShop'
    END catch
END
 
EXEC queryProductFromShop '21710187'
 
GO
CREATE PROCEDURE queryMoneyFromHas
    @idOrder VARCHAR(50)
AS
BEGIN
    BEGIN try
        print 'query money from has'
        SELECT idProduct, name, unitPrice, amount, (unitPrice*amount) AS money
        FROM tblHas, tblProduct
        WHERE tblHas.idOrder = @idOrder AND tblHas.idProduct = tblProduct.id
        ORDER BY idProduct
    END try
    BEGIN catch
        print 'Error query money from has'
    END catch
END
 
 
GO
CREATE PROCEDURE queryTotalMoney
    @idOrder VARCHAR(50)
AS
BEGIN
    BEGIN try
        print 'query total money from has' 
        SELECT SUM(money) AS total_money
        FROM (SELECT (unitPrice*amount) AS money
            FROM tblHas
            WHERE tblHas.idOrder = @idOrder) AS totalMoney
    END try
    BEGIN catch
        print 'Error query total money from has'
    END catch
END    
 
 
EXEC queryMoneyFromHas '061219171019501'
 
EXEC queryTotalMoney '061219171019501'
 
GO
CREATE FUNCTION totalOrderFromShop
(
    @idShop VARCHAR(50)
)
RETURNS INT
AS
BEGIN
    DECLARE @COUNT INT
    SET @COUNT = 0
    SELECT @COUNT = COUNT(*)
    FROM (SELECT DISTINCT idOrder, idShop FROM tblHas) AS orderFromShop
    WHERE idShop = @idShop
    RETURN @COUNT
END
 
GO
SELECT dbo.totalOrderFromShop('21710187')
 
GO
CREATE FUNCTION totalShopSellProduct
(
    @idProduct VARCHAR(50)
)
RETURNS INT
AS
BEGIN
    IF EXISTS(SELECT 1 FROM tblProduct WHERE id = @idProduct)
    BEGIN
    DECLARE @COUNT INT
    SET @COUNT = 0
    SELECT @COUNT = COUNT(*)
    FROM (SELECT DISTINCT idShop, idProduct FROM tblSell) AS shopOrderProduct
    WHERE idProduct = @idProduct
    RETURN @COUNT
    END
    ELSE
    BEGIN
        RETURN -1
    END
    RETURN 0
END
 
GO
SELECT dbo.totalShopSellProduct('8865872832669')
 
GO
SELECT dbo.totalShopSellProduct('4424616287949')
 
GO
CREATE FUNCTION totalProductSellShop
(
    @idShop VARCHAR(50),
    @money INT
)
RETURNS INT
AS
BEGIN
    IF @money < 0
    BEGIN
        RETURN -1
    END
    DECLARE @COUNT INT
    SET @COUNT = 0
    SELECT @COUNT = COUNT(*)
    FROM tblSell
    WHERE idShop = @idShop AND unitPrice >= @money
    RETURN @COUNT
END
 
 
GO
SELECT dbo.totalProductSellShop('21710187', '19000')
 
GO
CREATE PROCEDURE findProductByNameOrID
    @stringFind NVARCHAR(100)
AS
BEGIN
    IF len(@stringFind) >= 5
    BEGIN
        DECLARE @leftString NVARChar(5)
        DECLARE @rightString NVARCHAR(5)
        DECLARE @SUBSTRING NVARCHAR(5)
        SET @leftString = LEFT(@stringFind, 5)
        SET @rightString = RIGHT(@stringFind, 5)
        SET @SUBSTRING = SUBSTRING(@stringFind, len(@stringFind)/2 - 2, 5)
        SELECT *
        FROM tblProduct, tblSell
        WHERE (id LIKE '%' + @leftString + '%'
        OR id LIKE '%' + @rightString + '%'
        OR id LIKE '%' + @SUBSTRING + '%'
        OR name LIKE '%' + @leftString + '%'
        OR name LIKE '%' + @rightString + '%'
        OR name LIKE '%' + @SUBSTRING + '%'
        OR detail LIKE '%' + @stringFind + '%')
        AND id = idProduct
        ORDER BY name
    END
    ELSE
    BEGIN
        SELECT *
        FROM tblProduct, tblSell
        WHERE (id LIKE '%' + @stringFind + '%'
        OR id LIKE '%' + @stringFind + '%'
        OR id LIKE '%' + @stringFind + '%'
        OR name LIKE '%' + @stringFind + '%'
        OR name LIKE '%' + @stringFind + '%'
        OR name LIKE '%' + @stringFind + '%'
        OR detail LIKE '%' + @stringFind + '%')
        AND id = idProduct
        ORDER BY name
    END
END
 
--drop proc findProductByNameOrID
 
EXEC findProductByNameOrID 'i5'
 
GO
CREATE PROCEDURE sortProductByName
    @isIncrease bit
AS
BEGIN
    IF @isIncrease = 1
    BEGIN
        SELECT *
        FROM tblProduct, tblSell
        WHERE id = idProduct
        ORDER BY name
    END
    ELSE
    BEGIN
        SELECT *
        FROM tblProduct, tblSell
        WHERE id = idProduct
        ORDER BY name DESC
    END
END
 
GO
CREATE PROCEDURE sortProductByMoney
    @isIncrease bit
AS
BEGIN
    IF @isIncrease = 1
    BEGIN
        SELECT *
        FROM tblProduct, tblSell
        WHERE id = idProduct
        ORDER BY unitPrice
    END
    ELSE
    BEGIN
        SELECT *
        FROM tblProduct, tblSell
        WHERE id = idProduct
        ORDER BY unitPrice DESC
    END
END
 
EXEC sortProductByName 'false'
 
EXEC sortProductByMoney 'false'
 
 
GO
CREATE FUNCTION findProduct
(
    @stringFind NVARCHAR(100)
)
    RETURNS @tempTable TABLE
    (id VARCHAR(50),
    name NVARCHAR(100) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
    SIZE CHAR(50),
    img text,
    color NVARCHAR(100),
    detail text,
    idProduct VARCHAR(50) NOT NULL,
    idShop VARCHAR(50) NOT NULL,
    amount INT NOT NULL,
    unitPrice INT NOT NULL)
AS
BEGIN
    IF len(@stringFind) >= 5
    BEGIN
        DECLARE @leftString NVARChar(5)
        DECLARE @rightString NVARCHAR(5)
        DECLARE @SUBSTRING NVARCHAR(5)
        SET @leftString = LEFT(@stringFind, 5)
        SET @rightString = RIGHT(@stringFind, 5)
        SET @SUBSTRING = SUBSTRING(@stringFind, len(@stringFind)/2 - 2, 5)
        INSERT INTO @tempTable
        SELECT id, name, SIZE, img, color, detail, idProduct, idShop, amount, unitPrice
        FROM tblProduct, tblSell
        WHERE (id LIKE '%' + @leftString + '%'
        OR id LIKE '%' + @rightString + '%'
        OR id LIKE '%' + @SUBSTRING + '%'
        OR name LIKE '%' + @leftString + '%'
        OR name LIKE '%' + @rightString + '%'
        OR name LIKE '%' + @SUBSTRING + '%'
        OR detail LIKE '%' + @stringFind + '%')
        AND id = idProduct
        ORDER BY name
    END
    ELSE
    BEGIN
        INSERT INTO @tempTable
        SELECT id, name, SIZE, img, color, detail, idProduct, idShop, amount, unitPrice
        FROM tblProduct, tblSell
        WHERE (id LIKE '%' + @stringFind + '%'
        OR id LIKE '%' + @stringFind + '%'
        OR id LIKE '%' + @stringFind + '%'
        OR name LIKE '%' + @stringFind + '%'
        OR name LIKE '%' + @stringFind + '%'
        OR name LIKE '%' + @stringFind + '%'
        OR detail LIKE '%' + @stringFind + '%')
        AND id = idProduct
        ORDER BY name
    END
    RETURN
END
 
-- ham sort san pham theo ten hoac theo gia
GO
CREATE PROCEDURE sortProduct
    @stringFind NVARCHAR(100),
    @isName INT, -- if 0 khong sort, if 1 sort theo ten, if 2 sort theo gia, if 3 sort theo ten va gia, if 4 sort theo gia va ten
    @isIncrease bit
AS
BEGIN
    IF @isName = 0
    BEGIN
        SELECT * FROM findProduct(@stringFind) WHERE id = idProduct
    END
    ELSE IF @isName = 1
    BEGIN
        SELECT * FROM findProduct(@stringFind) WHERE id = idProduct ORDER BY name
    END
    ELSE IF @isName = 2
    BEGIN
        IF @isIncrease = 1
        BEGIN
            SELECT * FROM findProduct(@stringFind) WHERE id = idProduct ORDER BY unitPrice
        END
        ELSE
        BEGIN
            SELECT * FROM findProduct(@stringFind) WHERE id = idProduct ORDER BY unitPrice DESC
        END
    END
    ELSE IF @isName = 3
    BEGIN
        IF @isIncrease = 1
        BEGIN
            SELECT * FROM findProduct(@stringFind) WHERE id = idProduct ORDER BY name, unitPrice
        END
        ELSE
        BEGIN
            SELECT * FROM findProduct(@stringFind) WHERE id = idProduct ORDER BY name, unitPrice DESC
        END
    END
    ELSE IF @isName = 4
    BEGIN
        IF @isIncrease = 1
        BEGIN
            SELECT * FROM findProduct(@stringFind) WHERE id = idProduct ORDER BY unitPrice, name
        END
        ELSE
        BEGIN
            SELECT * FROM findProduct(@stringFind) WHERE id = idProduct ORDER BY unitPrice DESC, name
        END
    END
END
 
EXEC sortProduct 'm', '0', '0'