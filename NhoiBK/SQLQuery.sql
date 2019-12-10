-- Ngô Thanh Liêm - 1711929
USE dbTipee
Go
-- Tạo bảng dữ liệu

------------------------Table cua NHOIBK------------------------------------------
CREATE TABLE tblPromotion
(
	id					VARCHAR(6)	PRIMARY KEY,
	startTime			text		NOT NULL,
	endTime				text		NOT NULL,
	amountOfPromotion	Int			NOT NULL,	
	dicription			Text		NOT NULL,
	minTotal			Int			NOT NULL,
	classify			Nchar(10)	NOT NULL,
	depreciate			Int			NOT NULL,
	decreasePercent		Int			NOT NULL,
	decreaseMax			Int			NOT NULL,
	idShop				VARCHAR(6)	NOT NULL
);

CREATE TABLE tblTransportation
(
	id				VARCHAR(6)	PRIMARY KEY,
	nameTrans		Nchar(50)	NOT NULL,
	hotline			Int			NOT NULL,
	mail			Char(50)	NOT NULL,
	costLevel		Int			NOT NULL,
	addressTrans	nChar(100)	NOT NULL
);
CREATE TABLE tblOrder
(
	id				VARCHAR(6)	PRIMARY KEY,
	methodOfPayment Nchar(50)	NOT NULL,
	bookingTime		Date		NOT NULL,
	deliveryTime	Date		NOT NULL,
	orderStatus		Nchar(50)	NOT NULL,
	transportCode	VARCHAR(6)	NOT NULL,
	transportCost	Int			NOT NULL,
	idCustomer		Char(9)		NOT NULL,
	promotionCode	VARCHAR(6)	NOT NULL
); 
-- Thêm ràng buộc khóa ngoại

ALTER TABLE dbo.tblPromotion
	ADD CONSTRAINT fk_IdShop
	FOREIGN KEY(idShop) REFERENCES tblShop(id)
	ON DELETE CASCADE

--ràng buộc danh mục
--ALTER TABLE dbo.tblPromotion
--	ADD CONSTRAINT fk_classify
--	FOREIGN KEY(classify) REFERENCES 
--	ON DELETE CASCADE

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
FOREIGN KEY(idCustomer) REFERENCES tblCustomer(id)
ON DELETE CASCADE

--ràng buộc phí vận chuyển
ALTER TABLE dbo.tblOrder
ADD CONSTRAINT fk_transportCost
FOREIGN KEY(transportCost) REFERENCES tblTranportation(costLevel)
ON DELETE CASCADE
go

-- trigger
--KTRA SO LUONG 
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
drop trigger check_amount_of_promotion
exec insertPromotion 'TET3','2019-12-01','2020-01-01',-6,'chương trình khuyễn mãi tết 2020',500000,'đồ gia dụng',150000,10,200000,'ch0001'




	--thay doi so luong khuyen mai
 Create TRIGGER update_amount_of_Promotion ON tblOrder AFTER INSERT AS
 BEGIN
	DECLARE @promotionCode Varchar(50)
	SET @promotionCode = (SELECT promotionCode FROM inserted)
	IF exists(select * from tblPromotion where id = @promotionCode) 
	BEGIN
		print @promotionCode
		UPDATE tblPromotion 
		SET amountOfPromotion = (select amountOfPromotion from tblPromotion WHERE tblPromotion.id = @promotionCode) - 1 
		FROM tblPromotion
		WHERE tblPromotion.id = @promotionCode
	END
 END
 go
 drop trigger update_amount_of_Promotion

 exec insertOrder 'MDH014','Chuyển khoản','2019-12-01','2019-12-05','Đã giao','GRAB',23000,'','BLACK'
select * from tblPromotion
select * from tblOrder
select * from tblTransportation
	-- cap nhat phi van chuyen


-- thủ tục
	--sort
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
	--tim kiem
	

-- hàm




