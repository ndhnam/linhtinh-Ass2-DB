-- Ngô Thanh Liêm - 1711929
USE dbTipee
Go
-------------LINH----------------

CREATE PROCEDURE insertShopAccount
	@id VARCHAR(6),
	@username VARCHAR(32),
	@password VARCHAR(50),
	@name NCHAR(50),
	@number INT,
	@address NCHAR(100),
	@email VARCHAR(50),
	@avatar VARCHAR(100),
	@classify INT,
	@typesOfShop NCHAR(30),
	@distribution NCHAR(10)
AS
BEGIN
	DECLARE @hashPass VARBINARY(500) = HASHBYTES('SHA2_512', @password)
	DECLARE @afterHashPassword VARCHAR(500) = CONVERT(VARCHAR(500), @hashPass)
	DECLARE @count_id INT = (SELECT COUNT(id) FROM dbo.tblAccount WHERE id = @id)
	DECLARE @count_user INT = (SELECT COUNT(username) FROM dbo.tblAccount WHERE username = @username)
	IF @count_id = 0 AND @count_user = 0
	BEGIN
		INSERT INTO dbo.tblAccount(id, username, password) VALUES (@id, @username, @afterHashPassword)d
		IF @@ROWCOUNT > 0
		BEGIN
			INSERT INTO dbo.tblShop(id, name, number, address, email, avatar, classify, typesOfShop, distribution, total_rate) VALUES (@id, @name, @number, @address, @email, @avatar, @classify, @typesOfShop, @distribution, 0)
		END
	END
END
go
EXEC dbo.insertShopAccount 'CH0001', 'ch01', 'ch01', 'SHOP A', 111111111, N'7A/19 Thành Thái, Phường 14, Quận 10, Hồ Chí Minh, Việt Nam', 'email1@gmail.com', N'link', '1', N'THIẾT BỊ', N'Sỉ';
EXEC dbo.insertShopAccount 'CH0002', 'ch02', 'ch02', 'SHOP B', 999999999, N'Số 30 Đường Số 52, Lữ Gia, Phường 15, Quận 11, Hồ Chí Minh 72621, Việt Nam', 'email2@gmail.com', N'link', '0', N'THỜI TRANG', N'Lẻ';
EXEC dbo.insertShopAccount 'CH0003', 'ch03', 'ch03', 'SHOP C', 333333333, N'270B Lý Thường Kiệt, Phường 14, Quận 10, Hồ Chí Minh, Việt Nam', 'email3@gmail.com', N'link', '1', N'GIA DỤNG', N'Sỉ, lẻ';
EXEC dbo.insertShopAccount 'CH0004', 'ch04', 'ch04', 'SHOP D', 222222222, N'73 Đường Mai Thị Lựu, Đa Kao, Quận 1, Hồ Chí Minh 700000, Việt Nam', 'email4@gmail.com', N'link', '0', N'THỜI TRANG', N'Sỉ';
EXEC dbo.insertShopAccount 'CH0005', 'ch05', 'ch05', 'SHOP E', 555555555, N'282/20 Đường Bùi Hữu Nghĩa, Phường 2, Bình Thạnh, Hồ Chí Minh, Việt Nam', 'email5@gmail.com', N'link', '1', N'ĐỒNG HỒ', N'Lẻ';
EXEC dbo.insertShopAccount 'CH0006', 'ch06', 'ch06', 'SHOP F', 666666666, N'10 Đường Mai Chí Thọ, An Lợi Đông, Quận 2, Hồ Chí Minh 700000, Việt Nam', 'email6@gmail.com', N'link', '0', N'THỂ THAO', N'Sỉ, lẻ';
EXEC dbo.insertShopAccount 'CH0007', 'ch07', 'ch07', 'SHOP G', 666666666, N'10 Đường Mai Chí Thọ, An Lợi Đông, Quận 2, Hồ Chí Minh 700000, Việt Nam', 'email7', N'link', '0', N'THỂ THAO', N'Sỉ, lẻ';
EXEC dbo.insertShopAccount 'CH0008', 'ch08', 'ch08', 'SHOP H', 666666666, N'10 Đường Mai Chí Thọ, An Lợi Đông, Quận 2, Hồ Chí Minh 700000, Việt Nam', 'email8@gmail.com', N'link', '0', N'THỂ THAO', N'Sỉ, lẻ';
EXEC dbo.insertShopAccount 'CH0009', 'ch09', 'ch09', 'SHOP I', 123453234, N'10 Đường Mai Chí Thọ, An Lợi Đông, Quận 2, Hồ Chí Minh 700000, Việt Nam', 'email9', N'link', '0', N'THỂ THAO', N'Sỉ, lẻ';
go

CREATE PROCEDURE writeReviewShop
	@idShop VARCHAR(6),
	@idCustomer VARCHAR(6),
	@star INT,
	@describe NCHAR(100)
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
go
EXEC writeReviewShop 'CH0001', 'KH0001', 5, N'Đẹp';
EXEC writeReviewShop 'CH0001', 'KH0002', 4, N'Đẹp';
EXEC writeReviewShop 'CH0001', 'KH0003', 5, N'Hàng tốt đó!';
EXEC writeReviewShop 'CH0001', 'KH0004', 3, N'Tạm được!';
EXEC writeReviewShop 'CH0002', 'KH0001', 3, N'Tạm được!';
EXEC writeReviewShop 'CH0002', 'KH0004', 2, N'Tạm được!';
EXEC writeReviewShop 'CH0001', 'KH0005', 5, N'OK đấy!';

---- Ngô Thanh Liêm - 1711929-----
CREATE PROCEDURE insertPromotion 
	@id					Varchar(60),
	@startTime			date,
	@endTime			date,
	@amountOfPromotion	Int	,	
	@dicription			Text,
	@minTotal			Int	,
	@classify			Nchar,
	@depreciate			Int,
	@decreasePercent	Int,
	@decreaseMax		Int,
	@idShop				Varchar(6)
AS
BEGIN	
	BEGIN TRY
		INSERT INTO tblPromotion(id,startTime,endTime,amountOfPromotion,dicription,minTotal,classify,depreciate,decreasePercent,decreaseMax,idShop) 
		VALUES (@id,@startTime,@endTime,@amountOfPromotion,@dicription,@minTotal,@classify,@depreciate,@decreasePercent,@decreaseMax,@idShop)
		PRINT 'Insert has successfully'
		RETURN @@ROWCOUNT	
	END TRY
	BEGIN CATCH
		PRINT 'Insert Error'
		RETURN 0	
	END CATCH
END

exec insertPromotion 'TET2020','2019-12-01','2020-01-01',150,'chương trình khuyễn mãi tết 2020',500000,'đồ gia dụng',150000,10,200000,'CH0003'
exec insertPromotion 'NOEL2020','2019-12-15','2019-12-25',300,'chương trình khuyễn mãi Noel 2020',200000,'thời trang',86000,15,150000,'CH0001'
exec insertPromotion 'TIPEEMOMO','2019-01-01','2019-12-01',500,'giảm giá hoàn tiền siêu tiết kiệm cùng Tipee',30000,'đồ ăn nhanh',25000,20,50000,'CH0002'
exec insertPromotion 'BLACKFRIDAY','2019-11-01','2019-11-30',150,'Săn ngay sản phẩm hot nhân dịp BlackFriday 2019',100000,'thời trang',10000,5,200000,'CH0001'
exec insertPromotion 'FREESHIP','2019-01-01','2019-12-30',130,'Free ship cho hóa đơn trên 69k',69000,'đồ gia dụng',15000,9,30000,'CH0004'
go

CREATE PROCEDURE insertTransportation
	@id				Varchar(6),
	@nameTrans		Nchar(50),
	@hotline		Int,
	@mail			Char(50),
	@costLevel		Int,
	@addressTrans	Char(100)
AS
BEGIN	
	BEGIN TRY
		INSERT INTO tblTransportation(id,nameTrans,hotline,mail,costLevel,addressTrans) VALUES (@id,@nameTrans,@hotline,@mail,@costLevel,@addressTrans)
		PRINT 'Insert has successfully'
		RETURN @@ROWCOUNT	
	END TRY
	BEGIN CATCH
		PRINT 'Insert Error'
		RETURN 0	
	END CATCH
END

exec insertTransportation 'VIETTEL', 'Viettel post',19008095,'cskh@viettelpost.com.vn',30000,'Toà nhà N2, Km số 2, Đại lộ Thăng Long, Phường Mễ Trì, Quận Nam Từ Liêm, Hà Nội'
exec insertTransportation 'GHN', 'Giao hàng nhanh',18006328,'cskh@ghn.vn',20000,'405/15 Xô Viết Nghệ Tĩnh, Phường 24, Quận Bình Thạnh, TP HCM'
exec insertTransportation 'GRAB', 'Grab ',19001623,'cskh@grab.vn',250000,'268 Tô Hiến Thành, P.15, Q.10, TP Hồ Chí Minh'
exec insertTransportation 'VNPOST', 'Bưu điện Việt Nam',1900565657,'vanphong@vnpost.vn',50000,'05 đường Phạm Hùng - Mỹ Đình 2 - Nam Từ Liêm - Hà Nội - Việt Nam '
exec insertTransportation 'ALOGN', 'Alo giao ngay',1900636085,'hotro@alogiaongay.com',36000,'Lầu 1, Toà nhà Lotus, 16 Cửu Long, Phường 2, Quận Tân Bình, TP.HCM'
go

CREATE PROCEDURE insertOrder
	@id					Varchar(6),
	@methodOfPayment	Nchar(50),
	@bookingTime		Date,
	@deliveryTime		Date,
	@orderStatus		Nchar(50),
	@transportCode		Char(50),
	@transportCost		Int,
	@idCustomer			Char(9),
	@promotionCode		Char(50)
AS
BEGIN	
	BEGIN TRY
		INSERT INTO tblOrder(id,methodOfPayment,bookingTime,deliveryTime,orderStatus,transportCode,transportCost,idCustomer,promotionCode) VALUES (@id,@methodOfPayment,@bookingTime,@deliveryTime,@orderStatus,@transportCode,@transportCost,@idCustomer,@promotionCode)
		PRINT 'Insert has successfully'
		RETURN @@ROWCOUNT	
	END TRY
	BEGIN CATCH
		PRINT 'Insert Error'
		print error_message()
		RETURN 0	
	END CATCH
END
drop proc insertOrder
go
exec insertOrder 'MDH001','Trực tiếp','2019-12-09','2019-12-15','Đang xử lý','VIETTEL',30000,'','BLACKFRIDAY'
exec insertOrder 'MDH002','Chuyển khoản','2019-11-09','2019-11-12','Đã giao','GHN',10000,'','TET2020'
exec insertOrder 'MDH003','Chuyển khoản','2019-12-01','2019-12-05','Đã giao','GRAB',23000,'','TIPEEMOMO'
exec insertOrder 'MDH004','Trực tiếp','2019-12-09','2019-12-16','Đang giao','VNPOST',50000,'','NOEL'
exec insertOrder 'MDH005','Trực tiếp','2019-11-19','2019-11-21','Đã giao','ALOGN',15000,'','FREESHIP'
go


