-- Truc Ly 1710187 --
CREATE DATABASE dbTipee
GO
USE dbTipee
GO 

-- Table Customer
CREATE TABLE tblCustomer 
(
	id_customer		VARCHAR(6)		PRIMARY KEY,
	last_name		NVARCHAR(20)	NOT NULL,
	first_name		NVARCHAR(20)	NOT NULL,
	email			VARCHAR(100)	NOT NULL,
	sex				BIT				NOT NULL, -- 0: Female, 1: Male
	date_of_birth	DATE			NOT NULL,
	id_intro		VARCHAR(6),
	num_of_bills	INT DEFAULT 0
);

-- Table Intro
CREATE TABLE tblIntro
(
	id_intro	VARCHAR(6),
	id_reduce	VARCHAR(50)
)

-- Table Telephone
CREATE TABLE tblTelephoneNumber
(
	tel_number	VARCHAR(11),
	id_customer	VARCHAR(6),
	PRIMARY KEY(tel_number, id_customer)
); 

-- Table Address
CREATE TABLE tblAddress 
(
	stt				INT, 
	id_customer		VARCHAR(6),
	province		NVARCHAR(100),
	city			NVARCHAR(100),
	ward			NVARCHAR(100),
	detail			NTEXT,
	type_address	NVARCHAR(30),
	PRIMARY KEY(stt, id_customer)
);

-- Table Bill
CREATE TABLE tblOrder
(
	id				VARCHAR(6)	PRIMARY KEY,
	methodOfPayment Nchar(50)	NOT NULL,
	bookingTime		Date		NOT NULL,
	deliveryTime	Date		NOT NULL,
	orderStatus		Nchar(50)	NOT NULL,
	transportCode	Char(50)	NOT NULL,
	transportCost	Int			NOT NULL,
	idCustomer		VARCHAR(6)	NOT NULL,
	promotionCode	Char(50)	NOT NULL
);

-- Table Order
CREATE TABLE tblOrdering
(
	id_bill			VARCHAR(6) PRIMARY KEY,
	id_customer		VARCHAR(6),
	time_ordering	DATE
)

ALTER TABLE tblOrdering
ADD CONSTRAINT FK_OrderOdering
FOREIGN KEY(id_bill) REFERENCES tblOrder(id);

ALTER TABLE tblCustomer
ADD CONSTRAINT FK_Customer
FOREIGN KEY(id_intro) REFERENCES tblCustomer(id_customer);

ALTER TABLE tblTelephoneNumber 
ADD CONSTRAINT FK_CustomerTelephoneNumber
FOREIGN KEY(id_customer) REFERENCES tblCustomer(id_customer);

ALTER TABLE tblAdrress
ADD CONSTRAINT FK_Customer_Address
FOREIGN KEY(id_customer) REFERENCES tblCustomer(id_customer);

ALTER TABLE tblOrdering 
ADD CONSTRAINT FK_CustomerOrdering
FOREIGN KEY(id_customer) REFERENCES tblCustomer(id_customer);

ALTER TABLE tblIntro
ADD CONSTRAINT FK_IntroCustomer
FOREIGN KEY(id_intro) REFERENCES tblCustomer(id_customer)
ON DELETE CASCADE

-- Insert Data Telephone Number
INSERT INTO dbo.tblTelephoneNumber VALUES ('0834562109', 'KH0001')
INSERT INTO dbo.tblTelephoneNumber VALUES ( '0395914514', 'KH0002')
INSERT INTO dbo.tblTelephoneNumber VALUES ('0123456789', 'KH0003')
INSERT INTO dbo.tblTelephoneNumber VALUES ('0998656689', 'KH0005')

-- Insert Data Address
INSERT INTO dbo.tblAddress VALUES(1,'KH0001','An Giang','Long Xuyên','Mỹ Hòa Hưng',NULL, '')
INSERT INTO dbo.tblAddress VALUES(2,'KH0002','Hồ Chí Minh','Quận 10','P8',NULL, '')
INSERT INTO dbo.tblAddress VALUES(3,'KH0003','Tây Ninh','Châu Thành','ABC',NULL, '')
INSERT INTO dbo.tblAddress VALUES(4,'KH0004','Đồng Tháp','Sa Đéc','XYZ',NULL, '')
INSERT INTO dbo.tblAddress VALUES(5,'KH0005','An Giang','Châu Đốc','Mỹ Bình',NULL, '')

-- Insert Data Ordering
INSERT INTO dbo.tblOrdering VALUES('MDH001', 'KH0001', '')
INSERT INTO dbo.tblOrdering VALUES('MDH002', 'KH0002', '20190312')
INSERT INTO dbo.tblOrdering VALUES('MDH003', 'KH0002', '20190312')
INSERT INTO dbo.tblOrdering VALUES('MDH004', 'KH0002', '20190312')
INSERT INTO dbo.tblOrdering VALUES('MDH005', 'KH0002', '20191119')

------------------	INSERT -------------------

-- Customer Insert Information
GO 
CREATE PROCEDURE insertInformation
	@id_customer	VARCHAR(6),
	@last_name		NVARCHAR(20), 
	@first_name		NVARCHAR(20),
	@email			VARCHAR(100),
	@sex			BIT,
	@date_of_birth	DATE
AS
BEGIN
		IF @email not like '%@%'
		BEGIN
			RAISERROR (N'Email sai định dạng', 1, 1)
		END
		ELSE IF EXISTS(SELECT * from dbo.tblCustomer where @email  = email)
		BEGIN
			RAISERROR (N'Email này đã tồn tại!', 1, 1)
        END
		ELSE 
			INSERT INTO tblCustomer
			(		id_customer,
					last_name ,
					first_name ,
					email ,
					sex ,
					date_of_birth
			)
			VALUES  ( @id_customer,
					  @last_name ,
					  @first_name ,
					  @email ,
					  @sex ,
					  @date_of_birth
					)
END

-- Insert Data Customer
EXEC insertInformation 'KH0001', 'Nguyen', 'Ly','truclybk.cs@gmail.com', 0,'19990218'
EXEC insertInformation 'KH0002', 'Nguyen', 'Nam', 'namnguyen@gmail.com', 0, '19981230'
EXEC insertInformation 'KH0003', 'Huynh', 'Linh', 'hpplinh@gmail.com', 1, '19970101'
EXEC insertInformation 'KH0004', 'Tran', 'Tam', 'tvtam@hcmut.edu.vn', 1, '20000518'
EXEC insertInformation 'KH0005', 'Ngo', 'Liem', 'ntliem@hcmut.edu.vn', 1, '20011108'


------------------ TRIGGER ------------------

-- Trigger after insert bill
GO 
CREATE TRIGGER updateTotalBills ON tblOrdering AFTER INSERT AS
BEGIN
	DECLARE @count_id_bill INT = 
	(
		SELECT COUNT(id_bill) 
		FROM tblOrdering 
		WHERE id_customer = (SELECT id_customer FROM Inserted)
	)
	UPDATE tblCustomer SET num_of_bills = @count_id_bill 
	WHERE id_customer = (SELECT id_customer FROM Inserted)
END

-- Trigger Introduce Customer
GO
CREATE TRIGGER checkIntro ON tblCustomer FOR UPDATE AS
BEGIN
	DECLARE @count_bill_old INT = (SELECT num_of_bills FROM Deleted) 
	DECLARE @count_bill_cur INT = (SELECT num_of_bills FROM Inserted) 
	IF (@count_bill_cur = @count_bill_old) 
	BEGIN
		DECLARE @id_customer	VARCHAR(6)
		DECLARE @id_cur_intro	VARCHAR(6)
		DECLARE @id_intro	VARCHAR(6)
		SET @id_customer = (SELECT id_customer FROM inserted)
		SET @id_intro = (SELECT id_intro FROM inserted)
		SET @id_cur_intro = (SELECT id_intro FROM deleted)
		IF (@id_cur_intro IS NOT NULL) 
		BEGIN
			PRINT 'Tài khoản này đã được giới thiệu'
			ROLLBACK
		END
		IF (@id_customer = @id_intro) 
		BEGIN
			PRINT 'Không được tự giới thiệu chính mình'
			ROLLBACK
		END
		INSERT INTO tblIntro(id_intro, id_reduce) VALUES (@id_intro, @id_customer)
	END 
END

-- Update id introduce
UPDATE dbo.tblCustomer SET id_intro = 'KH0005' WHERE id_customer = 'KH0001'


------------------ PROCEDURE ------------------

-- Find all customers in one city and sort by ID
GO 
CREATE PROCEDURE queryCustomersInOneProvince
	@province nvarchar(100)
AS
BEGIN
	SELECT tblCustomer.id_customer, first_name, tel_number
	FROM tblAddress, tblCustomer, tblTelephoneNumber
	WHERE province = @province 
		AND tblAddress.id_customer = tblCustomer.id_customer 
		AND tblAddress.id_customer = tblTelephoneNumber.id_customer
	ORDER BY tblCustomer.id_customer
END

EXEC queryCustomersInOneProvince 'An Giang' 
EXEC queryCustomersInOneProvince 'Hồ Chí Minh'
EXEC queryCustomersInOneProvince 'Hà Nội'

-- Tìm tất cả các đơn hàng của một khách hàng trước một thời gian nào đó mà đang được xử lý
GO 
CREATE PROCEDURE queryBillsBeforeOneDate
	@date			DATE,
	@id_customer	VARCHAR(6)
AS
BEGIN
		SELECT id_bill, time_ordering
		FROM tblOrdering, tblOrder
        WHERE  id_customer = @id_customer AND DATEDIFF(DAY, @date, time_ordering) > 0 
        GROUP BY time_ordering, orderStatus, id_bill
		HAVING orderStatus = 'Đang xử lý'
		ORDER BY time_ordering
END 

INSERT INTO tblOrder VALUES ('MDH001','Trực tiếp','2019-12-09','2019-12-15','Đang xử lý','VIETTEL',30000,'','BLACKFRIDAY')
INSERT INTO tblOrder VALUES ('MDH002','Chuyển khoản','2019-11-09','2019-11-12','Đã giao','GHN',10000,'','TET2020')
INSERT INTO tblOrder VALUES ('MDH003','Chuyển khoản','2019-12-01','2019-12-05','Đã giao','GRAB',23000,'','TIPEEMOMO')
INSERT INTO tblOrder VALUES ('MDH004','Trực tiếp','2019-12-09','2019-12-16','Đang giao','VNPOST',50000,'','NOEL')
INSERT INTO tblOrder VALUES ('MDH005','Trực tiếp','2019-11-19','2019-11-21','Đang xử lý','ALOGN',15000,'','FREESHIP')

EXEC dbo.queryBillsBeforeOneDate '2019-12-11', 'KH0001' 

------------------ FUNCTION ------------------

-- Hàm tính tổng điểm số điểm của khách hàng dựa trên số bill
GO 
CREATE FUNCTION getScoreOfCustomer(@id_customer VARCHAR(6))
RETURNS INT
AS
BEGIN
	DECLARE @scores INT
	SET @scores = 0
	DECLARE @num_of_bills INT = (SELECT num_of_bills FROM dbo.tblCustomer WHERE id_customer = @id_customer)
	IF @num_of_bills <= 10
	BEGIN
		SET @scores = @num_of_bills 
	END
	ELSE IF @num_of_bills <= 50
	BEGIN
		SET @scores = 10 + (@num_of_bills - 10) * 2
	END
	ELSE IF @num_of_bills <= 100
	BEGIN
		SET @scores = 10 + 40 * 2 + (@num_of_bills - 50) * 3
    END    
	ELSE
    BEGIN
		SET @scores = 10 + 40 * 2 + 50 * 3 + (@num_of_bills - 100) * 5
    END
	RETURN @scores
END

GO 
SELECT dbo.getScoreOfCustomer('KH0001')

-- Lấy tất cả khách hàng có cùng một tháng sinh nào đó và tuổi nằm trong 1 khoảng
GO
CREATE FUNCTION queryCusInMonthBirth(@month INT, @age_low INT, @age_high INT)
RETURNS @tblCustomerBirth TABLE
(
	id_customer		VARCHAR(6),
	last_name		NVARCHAR(20),
	first_name		NVARCHAR(20),
	email			VARCHAR(100),
	sex				BIT,
	date_of_birth	DATE
)
AS
BEGIN
	IF @month < 0 OR @month > 12
	BEGIN
		RETURN
	END
	INSERT INTO @tblCustomerBirth
	SELECT id_customer, last_name, first_name, email, sex, date_of_birth
	FROM tblCustomer
	WHERE MONTH(date_of_birth) = @month AND  @age_low < (YEAR(GETDATE()) - YEAR(date_of_birth)) AND (YEAR(GETDATE()) - YEAR(date_of_birth)) < @age_high
	RETURN
END

GO
SELECT * FROM queryCusInMonthBirth(2, 18, 30)