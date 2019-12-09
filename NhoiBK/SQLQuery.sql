-- Ngô Thanh Liêm - 1711929
USE dbTipee
Go
-- Tạo bảng dữ liệu
CREATE TABLE tblPromotion
(
	id				Char(9)		PRIMARY KEY,
	startTime		Date		NOT NULL,
	endTime			Date		NOT NULL,
	dicription		Text		NOT NULL,
	minTotal		Int			NOT NULL,
	classify		Nchar(10)	NOT NULL,
	depreciate		Int			NOT NULL,
	decreasePercent Int			NOT NULL,
	decreaseMax		Int			NOT NULL,
	idShop			Int			NOT NULL
);

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

-- Thêm ràng buộc khóa ngoại
ALTER TABLE dbo.tblPromotion
ADD CONSTRAINT fk_IdShop
FOREIGN KEY(idShop) REFERENCES tblPromotion(id)
ON DELETE CASCADE
--ràng buộc danh mục
ALTER TABLE dbo.tblPromotion
ADD CONSTRAINT fk_classify
FOREIGN KEY(classify) REFERENCES 
ON DELETE CASCADE

ALTER TABLE dbo.tblOrder
ADD CONSTRAINT fk_TransportCode
FOREIGN KEY(transportCode) REFERENCES tblTransportation(id)	
ON DELETE CASCADE

ALTER TABLE dbo.tblOrder
ADD CONSTRAINT fk_promotionCode
FOREIGN KEY(promotionCode) REFERENCES tblPromotion(id)
ON DELETE CASCADE

--ràng buộc khách hàng
ALTER TABLE dbo.tblOrder
ADD CONSTRAINT fk_idCustomer
FOREIGN KEY(idCustomer) REFERENCES 
ON DELETE CASCADE

--ràng buộc phí vận chuyển
ALTER TABLE dbo.tblOrder
ADD CONSTRAINT fk_transportCost
FOREIGN KEY(transportCost) REFERENCES 
ON DELETE CASCADE


-- add dữ liệu mẫu
INSERT INTO tblPromotion VALUES ('TET2020',2019-12-01,2020-01-01,'chương trình khuyễn mãi tết 2020',500000,'đồ gia dụng',10,200000,IDSHOP)
INSERT INTO tblPromotion VALUES ('NOEL',2019-12-15,2019-12-25,'chương trình khuyễn mãi Noel 2020',200000,'thời trang',15,150000,IDSHOP)
INSERT INTO tblPromotion VALUES ('TIPEEMOMO',2019-01-01,2019-12-01,'giảm giá hoàn tiền siêu tiết kiệm cùng Tipee',30000,'đồ ăn nhanh',20,50000,IDSHOP)
INSERT INTO tblPromotion VALUES ('BLACKFRIDAY',2019-11-01,2019-11-30,'Săn ngay sản phẩm hot nhân dịp BlackFriday 2019',100000,'thời trang',5,200000,IDSHOP)
INSERT INTO tblPromotion VALUES ('FREESHIP',2019-01-01,2019-12-30,'Free ship cho hóa đơn trên 69k',69000,'đồ gia dụng',9,30000,IDSHOP)

INSERT INTO tblTransportation VALUES ('VIETTEL', 'Viettel post',1900 8095,'cskh@viettelpost.com.vn',phí,'Toà nhà N2, Km số 2, Đại lộ Thăng Long, Phường Mễ Trì, Quận Nam Từ Liêm, Hà Nội')
INSERT INTO tblTransportation VALUES ('GHN', 'Giao hàng nhanh',1800 6328,'cskh@ghn.vn',phí,'405/15 Xô Viết Nghệ Tĩnh, Phường 24, Quận Bình Thạnh, TP HCM')
INSERT INTO tblTransportation VALUES ('GRAB', 'Grab ',,'',phí,'268 Tô Hiến Thành, P.15, Q.10, TP Hồ Chí Minh')
INSERT INTO tblTransportation VALUES ('VNPOST', 'Bưu điện Việt Nam',1900 56 56 57,'vanphong@vnpost.vn',phí,'05 đường Phạm Hùng - Mỹ Đình 2 - Nam Từ Liêm - Hà Nội - Việt Nam ')
INSERT INTO tblTransportation VALUES ('ALOGN', 'Alo giao ngay',1900 636 085,'hotro@alogiaongay.com',phí,'Lầu 1, Toà nhà Lotus, 16 Cửu Long, Phường 2, Quận Tân Bình, TP.HCM')

INSERT INTO tblOrder VALUES ('MDH001','Trực tiếp',2019-12-09,2019-12-15,'Đang xử lý','VIETTEL',,'','BLACKFRIDAY')
INSERT INTO tblOrder VALUES ('MDH002','Chuyển khoản',2019-11-09,2019-11-12,'Đã giao','GHN','',,'TET2020')
INSERT INTO tblOrder VALUES ('MDH003','Chuyển khoản',2019-12-01,2019-12-05,'Đã giao','GRAB',,'','TIPEEMOMO')
INSERT INTO tblOrder VALUES ('MDH004','Trực tiếp',2019-12-09,2019-12-16,'Đang giao','VNPOST',,'','BLACKFRIDAY')
INSERT INTO tblOrder VALUES ('MDH005','Trực tiếp',2019-11-19,2019-11-21,'Đã giao','ALOGN',,'','FREESHIP')

-- trigger

-- thủ tục



-- hàm
CREATE FUNCTION Totalcost 