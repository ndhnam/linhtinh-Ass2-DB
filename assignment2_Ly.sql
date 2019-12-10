-- Truc Ly 1710187 --
CREATE DATABASE dbTipee
GO
USE dbTipee
GO 

-- Table Customer
CREATE TABLE tblCustomer 
(
	id_customer VARCHAR(6) PRIMARY KEY,
	last_name NVARCHAR(20) NOT NULL, 
	first_name NVARCHAR(20) NOT NULL,
	email VARCHAR(100) NOT NULL,
	sex BIT NOT NULL, -- 0: Female, 1: Male
	date_of_birth DATE NOT NULL,
	id_intro VARCHAR(6),
	id_reduce VARCHAR(6), 
	num_of_bills INT
);

-- Table Telephone
CREATE TABLE tblTelephoneNumber
(
	tel_number VARCHAR(11),
	id_customer VARCHAR(6),
	PRIMARY KEY(tel_number, id_customer)
); 

-- Table Address
CREATE TABLE tblAdrress 
(
	stt int, 
	id_customer VARCHAR(6),
	province NVARCHAR(100),
	city NVARCHAR(100),
	ward NVARCHAR(100),
	detail NTEXT,
	type_address NVARCHAR(30),
	PRIMARY KEY(stt, id_customer)
);

-- Table Bill
CREATE TABLE tblOrder
(
	id				VARCHAR(6)		PRIMARY KEY,
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
	id_bill VARCHAR(6) PRIMARY KEY,
	id_customer VARCHAR(6),
	time_ordering DATE
)

ALTER TABLE tblOrdering
ADD CONSTRAINT FK_OrderOdering
FOREIGN KEY(id_bill) REFERENCES tblOrder(id)
ALTER TABLE dbo.tblOrdering DROP CONSTRAINT FK_OrderOdering

-- Foreign Key
ALTER TABLE tblCustomer
ADD CONSTRAINT FK_Customer
FOREIGN KEY(id_intro) REFERENCES tblCustomer(id_customer)

ALTER TABLE tblTelephoneNumber 
ADD CONSTRAINT FK_CustomerTelephoneNumber
FOREIGN KEY(id_customer) REFERENCES tblCustomer(id_customer);

ALTER TABLE tblAdrress
ADD CONSTRAINT FK_Customer_Address
FOREIGN KEY(id_customer) REFERENCES tblCustomer(id_customer);

ALTER TABLE tblOrdering 
ADD CONSTRAINT FK_CustomerOrdering
FOREIGN KEY(id_customer) REFERENCES tblCustomer(id_customer);

GO 
-- Customer Insert Information
CREATE PROCEDURE insertCustomer
	@id_customer VARCHAR(6),
	@last_name NVARCHAR(20), 
	@first_name NVARCHAR(20),
	@email VARCHAR(100),
	@sex BIT,
	@date_of_birth DATE
AS
BEGIN
	BEGIN TRY
		INSERT INTO tblCustomer
		        ( id_customer,
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
		PRINT 'Successful!'
		RETURN @@ROWCOUNT
    END TRY 
	BEGIN CATCH 
		PRINT 'Error Insert Information!'
		RETURN 0
	END CATCH
END;

-- Insert Data Customer
EXEC insertCustomer 'KH0001', 'Nguyen', 'Ly','truclybk.cs@gmail.com', 0,'19990218'
EXEC insertCustomer 'KH0002', 'Nguyen', 'Nam', 'namnguyen@gmail.com', 0, '19981230'
EXEC insertCustomer 'KH0003', 'Huynh', 'Linh', 'hpplinh@gmail.com', 1, '19970101'
EXEC insertCustomer 'KH0004', 'Tran', 'Tam', 'tvtam@hcmut.edu.vn', 1, '20000518'
EXEC insertCustomer 'KH0005', 'Ngo', 'Liem', 'ntliem@hcmut.edu.vn', 1, '20011108'


GO 
-- Insert Telephone Number
CREATE PROCEDURE insertTelephoneNumber
	@tel_number VARCHAR(11),
	@id_customer VARCHAR(6)
AS
BEGIN
	BEGIN TRY
		INSERT INTO tblTelephoneNumber(tel_number, id_customer) VALUES (@tel_number, @id_customer)
		PRINT 'Successful!'
		RETURN @@ROWCOUNT
    END TRY
	BEGIN CATCH
		PRINT 'Error Insert Telephone Number!'
		RETURN 0
	END CATCH
END;


-- Insert Data Telephone Number
EXEC insertTelephoneNumber '0834562109', 'KH0001'
EXEC insertTelephoneNumber '0395914514', 'KH0002'
EXEC insertTelephoneNumber '0123456789', 'KH0003'
EXEC insertTelephoneNumber '0998656689', 'KH0005'


GO 
-- Insert Address
CREATE PROCEDURE insertAddress
	@stt INT, 
	@id_customer VARCHAR(6),
	@province NVARCHAR(100),
	@city NVARCHAR(100),
	@ward NVARCHAR(100),
	@detail NTEXT,
	@type_address VARCHAR(30)
AS
BEGIN
	BEGIN TRY 
		INSERT INTO tblAdrress
		        ( stt ,
		          id_customer ,
		          province ,
		          city ,
		          ward ,
		          detail ,
		          type_address
		        )
		VALUES  ( @stt ,
		          @id_customer ,
		          @province ,
		          @city ,
		          @ward ,
		          @detail ,
		          @type_address
		        )
		PRINT 'Successful!'
		RETURN @@ROWCOUNT
	END TRY
	BEGIN CATCH 
		PRINT 'Error Insert Address!'
		RETURN 0
	END CATCH
END;

-- Insert Data Address
EXEC insertAddress 1,'KH0001','An Giang','Long Xuyên','Mỹ Hòa Hưng',NULL, ''
EXEC insertAddress 2,'KH0002','Hồ Chí Minh','Quận 10','P8',NULL, ''
EXEC insertAddress 3,'KH0003','Tây Ninh','Châu Thành','ABC',NULL, ''
EXEC insertAddress 4,'KH0004','Đồng Tháp','Sa Đéc','XYZ',NULL, ''
EXEC insertAddress 5,'KH0005','An Giang','Châu Đốc','Mỹ Bình',NULL, ''

GO 
CREATE PROCEDURE insertOrdering
	@id_bill VARCHAR(6),
	@id_customer VARCHAR(6),
	@time_ordering DATE
AS 
BEGIN 
	BEGIN TRY 
		INSERT INTO tblOrdering (id_bill, id_customer, time_ordering) VALUES (@id_bill, @id_customer, @time_ordering)
		PRINT 'Successfull!'
	END TRY 
	BEGIN CATCH
		PRINT ERROR_MESSAGE()
	END CATCH
END
DROP PROCEDURE dbo.insertOrdering
EXEC insertOrdering 'MDH001', 'KH0001', '20191212'
EXEC insertOrdering 'MDH002', 'KH0002', '20190312'
EXEC insertOrdering 'MDH003', 'KH0002', '20190312'
EXEC insertOrdering 'MDH004', 'KH0002', '20190312'
SELECT * FROM dbo.tblOrdering
SELECT * FROM dbo.tblCustomer

GO 
CREATE TRIGGER updateTotalBills ON tblOrdering AFTER INSERT AS
BEGIN
	DECLARE @count_id_bill INT = 
	(
		SELECT COUNT (id_bill) 
		FROM tblOrdering WHERE id_customer = (SELECT id_customer FROM Inserted)
	)
	UPDATE tblCustomer SET num_of_bills = @count_id_bill 
	WHERE id_customer = (SELECT id_customer FROM Inserted)
END



GO
CREATE TRIGGER 


GO 
-- Find all customers in one city and sort by ID
CREATE PROCEDURE queryCustomersInOneCity
	@province nvarchar(100)
AS
BEGIN
	BEGIN TRY
		SELECT tblCustomer.id_customer, first_name, tel_number
		FROM tblAdrress, tblCustomer, tblTelephoneNumber
		WHERE tblAdrress.province = @province AND tblAdrress.id_customer = tblCustomer.id_customer AND tblAdrress.id_customer = tblTelephoneNumber.id_customer
		ORDER BY tblCustomer.id_customer
	END TRY 
	BEGIN CATCH
		PRINT 'Cannot found!'
	END CATCH
END

EXEC queryCustomersInOneCity 'An Giang' 
EXEC queryCustomersInOneCity 'Hồ Chí Minh'
EXEC queryCustomersInOneCity 'Hà Nội'
EXEC queryCustomersInOneCity 'Đồng Tháp'

--Find all bills
CREATE PROCEDURE queryBillsBeforeOneDate
	@date Date
AS
BEGIN
	BEGIN TRY 
		SELECT SUM(
		FROM tblCustomer, tblOrdering, tblOrder
        WHERE time_ordering < @date
        GROUP BY orderStatus 
		HAVING COUNT(orderStatus) > 0
		ORDER BY transportCode
	END TRY
    BEGIN CATCH
	PRINT 'Cannot found!'
	END CATCH
END 


--Count bills
CREATE FUNCTION countBills
(
)

