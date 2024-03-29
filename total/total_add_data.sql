﻿-- Ngô Thanh Liêm - 1711929
USE dbTipee
Go
-------------LINH----------------

EXEC dbo.insertShopAccount 'CH0001', 'ch01', 'ch01', 'SHOP A', 111111111, N'7A/19 Thành Thái, Phường 14, Quận 10, Hồ Chí Minh, Việt Nam', 'email1@gmail.com', N'link', '1', N'THIẾT BỊ', N'Sỉ';
EXEC dbo.insertShopAccount 'CH0002', 'ch02', 'ch02', 'SHOP B', 999999999, N'Số 30 Đường Số 52, Lữ Gia, Phường 15, Quận 11, Hồ Chí Minh 72621, Việt Nam', 'email2@gmail.com', N'link', '0', N'THỜI TRANG', N'Lẻ';
EXEC dbo.insertShopAccount 'CH0003', 'ch03', 'ch03', 'SHOP C', 333333333, N'270B Lý Thường Kiệt, Phường 14, Quận 10, Hồ Chí Minh, Việt Nam', 'email3@gmail.com', N'link', '1', N'GIA DỤNG', N'Sỉ, lẻ';
EXEC dbo.insertShopAccount 'CH0004', 'ch04', 'ch04', 'SHOP D', 222222222, N'73 Đường Mai Thị Lựu, Đa Kao, Quận 1, Hồ Chí Minh 700000, Việt Nam', 'email4@gmail.com', N'link', '0', N'THỜI TRANG', N'Sỉ';
EXEC dbo.insertShopAccount 'CH0005', 'ch05', 'ch05', 'SHOP E', 555555555, N'282/20 Đường Bùi Hữu Nghĩa, Phường 2, Bình Thạnh, Hồ Chí Minh, Việt Nam', 'email5@gmail.com', N'link', '1', N'ĐỒNG HỒ', N'Lẻ';
EXEC dbo.insertShopAccount 'CH0006', 'ch06', 'ch06', 'SHOP F', 666666666, N'10 Đường Mai Chí Thọ, An Lợi Đông, Quận 2, Hồ Chí Minh 700000, Việt Nam', 'email6@gmail.com', N'link', '0', N'THỂ THAO', N'Sỉ, lẻ';
EXEC dbo.insertShopAccount 'CH0007', 'ch07', 'ch07', 'SHOP G', 666666666, N'10 Đường Mai Chí Thọ, An Lợi Đông, Quận 2, Hồ Chí Minh 700000, Việt Nam', 'email7', N'link', '0', N'THỂ THAO', N'Sỉ, lẻ';
EXEC dbo.insertShopAccount 'CH0008', 'ch08', 'ch08', 'SHOP H', 666666666, N'10 Đường Mai Chí Thọ, An Lợi Đông, Quận 2, Hồ Chí Minh 700000, Việt Nam', 'email8@gmail.com', N'link', '0', N'THỂ THAO', N'Sỉ, lẻ';
EXEC dbo.insertShopAccount 'CH0009', 'ch09', 'ch09', 'SHOP I', 123453234, N'10 Đường Mai Chí Thọ, An Lợi Đông, Quận 2, Hồ Chí Minh 700000, Việt Nam', 'email9', N'link', '0', N'THỂ THAO', N'Sỉ, lẻ';
EXEC dbo.insertShopAccount 'CH0011', 'ch11', 'ch11', 'SHOP 11', 123453234, N'10 Đường Mai Chí Thọ, An Lợi Đông, Quận 2, Hồ Chí Minh 700000, Việt Nam', 'email9', N'link', '0', N'THỂ THAO', N'Sỉ, lẻ';
go
SELECT * FROM tblAccount
SELECT * FROM tblShop
GO
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

-- Phần của Linh --- 1710165 --
EXEC dbo.insertShopAccount 'CH0001', 'ch01', 'ch01', 'SHOP A', 111111111, N'7A/19 Thành Thái, Phường 14, Quận 10, Hồ Chí Minh, Việt Nam', 'email1@gmail.com', N'link', '1', N'THIẾT BỊ', N'Sỉ';
EXEC dbo.insertShopAccount 'CH0002', 'ch02', 'ch02', 'SHOP B', 999999999, N'Số 30 Đường Số 52, Lữ Gia, Phường 15, Quận 11, Hồ Chí Minh 72621, Việt Nam', 'email2@gmail.com', N'link', '0', N'THỜI TRANG', N'Lẻ';
EXEC dbo.insertShopAccount 'CH0003', 'ch03', 'ch03', 'SHOP C', 333333333, N'270B Lý Thường Kiệt, Phường 14, Quận 10, Hồ Chí Minh, Việt Nam', 'email3@gmail.com', N'link', '1', N'GIA DỤNG', N'Sỉ, lẻ';
EXEC dbo.insertShopAccount 'CH0004', 'ch04', 'ch04', 'SHOP D', 222222222, N'73 Đường Mai Thị Lựu, Đa Kao, Quận 1, Hồ Chí Minh 700000, Việt Nam', 'email4@gmail.com', N'link', '0', N'THỜI TRANG', N'Sỉ';
EXEC dbo.insertShopAccount 'CH0005', 'ch05', 'ch05', 'SHOP E', 555555555, N'282/20 Đường Bùi Hữu Nghĩa, Phường 2, Bình Thạnh, Hồ Chí Minh, Việt Nam', 'email5@gmail.com', N'link', '1', N'ĐỒNG HỒ', N'Lẻ';
EXEC dbo.insertShopAccount 'CH0006', 'ch06', 'ch06', 'SHOP F', 666666666, N'10 Đường Mai Chí Thọ, An Lợi Đông, Quận 2, Hồ Chí Minh 700000, Việt Nam', 'email6@gmail.com', N'link', '0', N'THỂ THAO', N'Sỉ, lẻ';
EXEC dbo.insertShopAccount 'CH0007', 'ch07', 'ch07', 'SHOP G', 666666666, N'10 Đường Mai Chí Thọ, An Lợi Đông, Quận 2, Hồ Chí Minh 700000, Việt Nam', 'email7', N'link', '0', N'THỂ THAO', N'Sỉ, lẻ';
EXEC dbo.insertShopAccount 'CH0008', 'ch08', 'ch08', 'SHOP H', 666666666, N'10 Đường Mai Chí Thọ, An Lợi Đông, Quận 2, Hồ Chí Minh 700000, Việt Nam', 'email8@gmail.com', N'link', '0', N'THỂ THAO', N'Sỉ, lẻ';
EXEC dbo.insertShopAccount 'CH0009', 'ch09', 'ch09', 'SHOP I', 123453234, N'10 Đường Mai Chí Thọ, An Lợi Đông, Quận 2, Hồ Chí Minh 700000, Việt Nam', 'email9', N'link', '0', N'THỂ THAO', N'Sỉ, lẻ';

EXEC insertCustomerAccount 'KH0006','kh06','kh06','Nguyen', 'Ly','truclybk.cs@gmail.com', 0,'19990218';
EXEC insertCustomerAccount 'KH0002','kh02','kh02','Nguyen', 'Nam', 'namnguyen@gmail.com', 0, '19981230';
EXEC insertCustomerAccount 'KH0003','kh03','kh03','Huynh', 'Linh', 'hpplinh@gmail.com', 1, '19970101';
EXEC insertCustomerAccount 'KH0004','kh04','kh04','Tran', 'Tam', 'tvtam@hcmut.edu.vn', 1, '20000518';
EXEC insertCustomerAccount 'KH0005','kh05','kh05','Ngo', 'Liem', 'ntliem@hcmut.edu.vn', 1, '20011108';

select * from tblAccount
select * from tblCustomer
EXEC writeReviewShop 'CH0001', 'kh06', 'kh06', 5, N'Đẹp';
EXEC writeReviewShop 'CH0001', 'kh02', 'kh02', 4, N'Đẹp';
EXEC writeReviewShop 'CH0001', 'kh03', 'kh03', 5, N'Hàng tốt đó!';
EXEC writeReviewShop 'CH0001', 'kh04', 'kh04', 3, N'Tạm được!';
EXEC writeReviewShop 'CH0002', 'kh06', 'kh06', 3, N'Tạm được!';
EXEC writeReviewShop 'CH0002', 'kh02', 'kh02', 2, N'Tạm được!';
EXEC writeReviewShop 'CH0001', 'kh05', 'kh05', 5, N'OK đấy!';

select * from tblShop
select * from tblRate

EXEC deleteReviewShop 'CH0001','kh03','kh03';
EXEC deleteReviewShop 'CH0001','kh02','kh02';

SELECT dbo.[funcAvgRate]('CH0001')

--- phần của Nam ---
 
exec insertProduct '8865872832669',
'Laptop HP ENVY 13-AQ0026TU (Intel Core I5-8265U 8GB RAM DDR4 256GB SSD 13,3" FHD WIN10 HOME Pale gold-6ZF38PA)',
'0',
'https://salt.tikicdn.com/cache/w1200/ts/product/51/ab/b1/c71ef2cd42a284c4304d6037b09cfaa0.jpg https://salt.tikicdn.com/cache/w1200/ts/product/a2/25/96/508afca637007c197146f43703742be0.jpg',
'silver',
'Warranty: 1-year limited hardware warranty with 24-hour, 7 days a week Web support
OS : Windows 10 Home'
 
exec insertProduct '4424616287949',
'Macbook Air 2017 MQD32 (13.3 inch)',
'0',
'https://salt.tikicdn.com/cache/w1200/ts/product/24/1b/e9/0771b005d8b7d4547b2a5fc0012d4721.jpg',
'silver',
'1.8 GHz dual-core Intel Core i5 Processor Intel HD Graphics 6000
Fast SSD Storage 8GB memory Two USB 3 ports
Thunderbolt 2 port Sdxc port'
 
exec insertProduct '4478226675450',
'Legendary Whitetails Mens Buck Camp Flannel Shirt',
'S M L XL XXL',
'https://images-na.ssl-images-amazon.com/images/I/81EMrdLdgiL._AC_UL320_SR312,320_.jpg',
'army navy black',
'100% Cotton Imported Button closure
Contrasting corduroy lined collar and cuffs'
 
exec insertProduct '6118019675578',
'Men is Full-Zip Polar Fleece Jacket',
'S M L XL XXL',
'https://salt.tikicdn.com/cache/w1200/ts/product/be/c7/ba/053e1e37e14e56dfd4933103c2cd17b6.jpg',
'yellow-black black-white red-black',
'100% Polyester Imported Machine Wash'
 
exec insertProduct '7528313095320',
'T-shirt for women Basic Prefall19 Marc Fashion',
'S M L',
'https://salt.tikicdn.com/cache/w1200/ts/product/dc/c5/15/92a6211ba57293d30b3548569b8c23bd.jpg https://salt.tikicdn.com/cache/w1200/ts/product/94/58/ad/cfd000c085d752cfb61c18cc9cf6a49f.jpg',
'skin yellow',
'56% Cotton, 38% Modal, 6% Spandex Imported Machine Wash'
 
exec insertProduct'9463516425544',
'Shirts for Young Women GT0033 - White',
'S M',
'https://salt.tikicdn.com/cache/w1200/ts/product/a4/04/2f/c647444f0a4c2aaec1ba76a93d3e259f.jpg https://salt.tikicdn.com/cache/w1200/ts/product/e8/1e/25/2640f4126f9052364d3478216a01e231.jpg',
'white',
'70% COTTON, 30% POLYESTER Imported Button closure Machine Wash
Cotton Blend Oxford 50 Wash Tested Shrink & Fade Resistant Wrinkle No More Fabric For Easy Care'
 
exec insertProduct '2604488473943',
'Bicycle Fixed Gear Air Bike MK78',
'0',
'https://salt.tikicdn.com/cache/w1200/ts/product/9e/03/71/04a8efc747c8c3cab1868ed63baa0a2d.jpg',
'pink white yellow',
'The 4130 Steel Line earned .
LIGHTWEIGHT STRENGTH | Drilled high-flange hubs'
 
exec insertProduct '4269415114481',
'Headphone MRD-XB450AP',
'0',
'https://salt.tikicdn.com/cache/w1200/media/catalog/producttmp/12/10/f8/0d0734c7a733f769aa6101056ecbab07.jpg',
'blue white black red yellow',
'30 millimeter drivers for rich, full frequency response'
 
exec insertProduct '4250102889072',
'ear phone Bluetooth I7s',
'0',
'https://salt.tikicdn.com/cache/w1200/ts/product/a1/bf/9c/11ceb3f82e7f17a1f05ba47688cbd086.jpg',
'white',
'Features1. Listening to songs and calls, supporting listening to songs and making calls.'
select * from tblProduct
exec insertSell 'CH0001',
'8865872832669',
'50',
'20700'

exec insertSell 'CH0002',
'4424616287949',
'21',
'21000'


exec insertSell 'CH0003',
'8865872832669',
'100',
'20410'

exec updateSell 'CH0003',
'8865872832669',
'90',
'20410'

SELECT * FROM tblShop
SELECT * FROM tblSell


exec insertHas '061219171019501', 'CH0002', '8865872832669', '20410', '15'

exec insertHas '061219171019501', 'CH0002', '4424616287949', '19000', '10'

SELECT * FROM tblHas

exec queryProductFromShop '21710187'

select dbo.totalMoneyFromHas('061219171019501')

exec queryMoneyFromHas '061219171019501'

exec queryTotalMoney '061219171019501'

select dbo.totalOrderFromShop('21710187')

go
select dbo.totalShopSellProduct('8865872832669')

go
select dbo.totalShopSellProduct('4424616287949')

go
select dbo.totalProductSellShop('21710187', '19000')

exec findProductByNameOrID 'i5'

exec sortProductByName 'false'

exec sortProductByMoney 'false'

exec sortProduct 'm', '0', '0'

--- PHẦN CỦA TÂM ---
INSERT INTO tblCART VALUES ('C01','KH0006');
INSERT INTO tblCART VALUES ('C02','KH0002');
INSERT INTO tblCART VALUES ('C03','KH0003');
INSERT INTO tblCART VALUES ('C04','KH0004');
INSERT INTO tblCART VALUES ('C05','KH0005');

select * from tblCART

INSERT INTO tblADD_CART VALUES ('CO1','8865872832669','CH0001',5);
INSERT INTO tblADD_CART VALUES ('CO1','4424616287949','CH0001',2);
INSERT INTO tblADD_CART VALUES ('CO1','4424616287949','CH0002',1);
INSERT INTO tblADD_CART VALUES ('CO2','4424616287949','CH0001',2);

select * from tblADD_CART

INSERT INTO tblCATEGORY VALUES ('EL',N'Electronics',0);
INSERT INTO tblCATEGORY VALUES ('FA',N'Fashion',0);
INSERT INTO tblCATEGORY VALUES ('BO',N'Book',0);
INSERT INTO tblCATEGORY VALUES ('FO',N'FOOD',0);
INSERT INTO tblCATEGORY VALUES ('ST',N'Stationery',0);
INSERT INTO tblCATEGORY VALUES ('TO',N'Toy',0);

INSERT INTO tblBELONG_CATEGORY VALUES ('8865872832669','EL');
INSERT INTO tblBELONG_CATEGORY VALUES ('4424616287949','EL');
exec usp_insert_cate 'HO','home',3;
exec usp_insert_cate 'HO','home',-1;
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
exec usp_Pro_MulFunction 'book'
with result sets (
	( [Code Cate] varchar(50) ,
		[Name Cate]	varchar(50)
	)
)
-- phần của ly --
EXEC insertCustomerAccount 'KH0007','kh07','kh07','Nguyenn', 'Lyy','truclybk.cse@gmail.com', 0,'19990218','0834562109',1,'An Giang','Long Xuyên','Mỹ Hòa Hưng';
-- Insert Data Telephone Number
select * from tblCustomer
select * from tblTelephoneNumber
INSERT INTO dbo.tblTelephoneNumber VALUES ('0834562109', 'KH0006')
INSERT INTO dbo.tblTelephoneNumber VALUES ( '0395914514', 'KH0002')
INSERT INTO dbo.tblTelephoneNumber VALUES ('0123456789', 'KH0003')
INSERT INTO dbo.tblTelephoneNumber VALUES ('0998656689', 'KH0005')

-- Insert Data Address
INSERT INTO dbo.tblAddress VALUES(1,'KH0006','An Giang','Long Xuyên','Mỹ Hòa Hưng',NULL, '')
INSERT INTO dbo.tblAddress VALUES(2,'KH0002','Hồ Chí Minh','Quận 10','P8',NULL, '')
INSERT INTO dbo.tblAddress VALUES(3,'KH0003','Tây Ninh','Châu Thành','ABC',NULL, '')
INSERT INTO dbo.tblAddress VALUES(4,'KH0004','Đồng Tháp','Sa Đéc','XYZ',NULL, '')
INSERT INTO dbo.tblAddress VALUES(5,'KH0005','An Giang','Châu Đốc','Mỹ Bình',NULL, '')

-- Insert Data Ordering
select * from tblProduct
INSERT INTO dbo.tblOrdering VALUES('MDH001', 'KH0006', '')
INSERT INTO dbo.tblOrdering VALUES('MDH002', 'KH0002', '20190312')
INSERT INTO dbo.tblOrdering VALUES('MDH003', 'KH0002', '20190312')
INSERT INTO dbo.tblOrdering VALUES('MDH004', 'KH0002', '20190312')
INSERT INTO dbo.tblOrdering VALUES('MDH005', 'KH0002', '20191119')

-- Update id introduce
UPDATE dbo.tblCustomer SET id_intro = 'KH0005' WHERE id_customer = 'KH0001'
INSERT INTO tblOrder VALUES ('MDH001','Trực tiếp','2019-12-09','2019-12-15','Đang xử lý','VIETTEL',30000,'','BLACKFRIDAY')
INSERT INTO tblOrder VALUES ('MDH002','Chuyển khoản','2019-11-09','2019-11-12','Đã giao','GHN',10000,'','TET2020')
INSERT INTO tblOrder VALUES ('MDH003','Chuyển khoản','2019-12-01','2019-12-05','Đã giao','GRAB',23000,'','TIPEEMOMO')
INSERT INTO tblOrder VALUES ('MDH004','Trực tiếp','2019-12-09','2019-12-16','Đang giao','VNPOST',50000,'','NOEL')
INSERT INTO tblOrder VALUES ('MDH005','Trực tiếp','2019-11-19','2019-11-21','Đang xử lý','ALOGN',15000,'','FREESHIP')

EXEC dbo.queryBillsBeforeOneDate '2019-12-11', 'KH0001' 
select dbo.totalMoneyFromHas('MDH001')

GO
EXEC dbo.updateTelNum '0904523964', 'KH0001'
EXEC queryCustomersInOneProvince 'An Giang' 
EXEC queryCustomersInOneProvince 'Hồ Chí Minh'
EXEC queryCustomersInOneProvince 'Hà Nội'