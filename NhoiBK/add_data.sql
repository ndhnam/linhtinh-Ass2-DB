-- Ngô Thanh Liêm - 1711929
USE dbTipee
Go
-- add dữ liệu mẫu
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

exec insertPromotion 'TET','2019-12-01','2020-01-01',150,'chương trình khuyễn mãi tết 2020',500000,'đồ gia dụng',150000,10,200000,'ch0001'
exec insertPromotion 'NOEL','2019-12-15','2019-12-25',300,'chương trình khuyễn mãi Noel 2020',200000,'thời trang',86000,15,150000,'ch000'
exec insertPromotion 'TIPEE','2019-01-01','2019-12-01',500,'giảm giá hoàn tiền siêu tiết kiệm cùng Tipee',30000,'đồ ăn nhanh',25000,20,50000,'ch0001'
exec insertPromotion 'BLACK','2019-11-01','2019-11-30',150,'Săn ngay sản phẩm hot nhân dịp BlackFriday 2019',100000,'thời trang',10000,5,200000,'ch0001'
exec insertPromotion 'FREE','2019-01-01','2019-12-30',130,'Free ship cho hóa đơn trên 69k',69000,'đồ gia dụng',15000,9,30000,'ch0003'
go

alter PROCEDURE insertTransportation
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

alter PROCEDURE insertOrder
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
		RETURN 0	
	END CATCH
END
go
exec insertOrder 'MDH001','Trực tiếp','2019-12-09','2019-12-15','Đang xử lý','VIETTEL',30000,'','BLACKFRIDAY'
exec insertOrder 'MDH002','Chuyển khoản','2019-11-09','2019-11-12','Đã giao','GHN',10000,'','TET2020'
exec insertOrder 'MDH003','Chuyển khoản','2019-12-01','2019-12-05','Đã giao','GRAB',23000,'','TIPEEMOMO'
exec insertOrder 'MDH004','Trực tiếp','2019-12-09','2019-12-16','Đang giao','VNPOST',50000,'','NOEL'
exec insertOrder 'MDH005','Trực tiếp','2019-11-19','2019-11-21','Đã giao','ALOGN',15000,'','FREESHIP'
go

CREATE TRIGGER check_amount_of_promotion ON tblPromotion FOR INSERT AS
BEGIN
	DECLARE @amountOfPromotion INT
	SET @amountOfPromotion = (SELECT amountOfPromotion FROM inserted)
	IF (@amountOfPromotion < 0)
	BEGIN
		PRINT 'Error: amount < 0'
		ROLLBACK
	END
END
go