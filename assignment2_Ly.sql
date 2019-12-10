CREATE DATABASE dbTipee
GO
USE dbTipee
GO 

CREATE TABLE tblCustomer 
(
	id_customer VARCHAR(10) PRIMARY KEY,
	last_name NVARCHAR(20), 
	first_name NVARCHAR(20),
	email VARCHAR(100) NOT NULL,
	sex BIT,
	date_of_birth DATE,
	id_intro VARCHAR(15),
	id_reduce VARCHAR(15)
);

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
CREATE PROCEDURE insertCustomer
	@id_customer VARCHAR(10),
	@last_name NVARCHAR(20), 
	@first_name NVARCHAR(20),
	@email VARCHAR(100),
	@sex BIT,
	@date_of_birth DATE,
	@id_intro VARCHAR(15),
	@id_reduce VARCHAR(15)
AS
BEGIN
	BEGIN TRY
		INSERT INTO tblCustomer
		        ( id_customer ,
		          last_name ,
		          first_name ,
		          email ,
		          sex ,
		          date_of_birth ,
		          id_intro ,
		          id_reduce
		        )
		VALUES  ( @id_customer ,
		          @last_name ,
		          @first_name ,
		          @email ,
		          @sex ,
		          @date_of_birth ,
		          @id_intro ,
		          @id_reduce
		        )
		PRINT 'Successful!!!'
		RETURN @@ROWCOUNT
    END TRY 
	BEGIN CATCH 
		PRINT 'Error!!!'
		RETURN 0
	END CATCH
END;

EXEC insertCustomer @id_customer = '1710187', -- varchar(10)
    @last_name = N'Nguyen', -- nvarchar(20)
    @first_name = N'Ly', -- nvarchar(20)
    @email = 'truclybk.cs@gmail.com', -- varchar(100)
    @sex = 0, -- bit
    @date_of_birth = '19990218', -- date
    @id_intro = '', -- varchar(15)
    @id_reduce = '' -- varchar(15)

GO 
CREATE PROCEDURE insertTelephoneNumber
	@tel_number VARCHAR(11),
	@id_customer VARCHAR(10)
AS
BEGIN
	BEGIN TRY
		INSERT INTO tblTelephoneNumber(tel_number, id_customer) VALUES (@tel_number, @id_customer)
		PRINT 'Successful!!!'
		RETURN @@ROWCOUNT
    END TRY
	BEGIN CATCH
		PRINT 'Error!'
		RETURN 0
	END CATCH
END;

EXEC insertTelephoneNumber @tel_number = '0834562109', -- varchar(11)
    @id_customer = '1710187' -- varchar(10)
GO 
CREATE PROCEDURE insertAddress
	@addr NVARCHAR(100), 
	@id_customer VARCHAR(10),
	@province NVARCHAR(100),
	@city NVARCHAR(100),
	@ward NVARCHAR(100),
	@detail NTEXT,
	@type_address VARCHAR(10)
AS
BEGIN
	BEGIN TRY 
		INSERT INTO tblAdrress
		        ( addr ,
		          id_customer ,
		          province ,
		          city ,
		          ward ,
		          detail ,
		          type_address
		        )
		VALUES  ( @addr ,
		          @id_customer ,
		          @province ,
		          @city ,
		          @ward ,
		          @detail ,
		          @type_address
		        )
		PRINT 'Successful!!!'
		RETURN @@ROWCOUNT
	END TRY
	BEGIN CATCH 
		PRINT 'Error!'
		RETURN 0
	END CATCH
END;

EXEC insertAddress @addr = N'', -- nvarchar(100)
    @id_customer = '1710187', -- varchar(10)
    @province = N'An Giang', -- nvarchar(100)
    @city = N'Long Xuyên', -- nvarchar(100)
    @ward = N'Mỹ Hòa Hưng', -- nvarchar(100)
    @detail = NULL, -- ntext
    @type_address = '' -- varchar(10)
	
--GO 
--CREATE TRIGGER checkDateOfBirth ON tblCustomer FOR INSERT AS
--BEGIN 
	
--END

GO 
CREATE PROCEDURE queryCustomerInOneCity
	@province nvarchar(100)
AS
BEGIN
	BEGIN TRY
		SELECT tblCustomer.id_customer, last_name, first_name, tel_number
		FROM tblAdrress, tblCustomer, tblTelephoneNumber
		WHERE tblAdrress.province = @province AND tblAdrress.id_customer = tblCustomer.id_customer
		ORDER BY tblCustomer.id_customer
	END TRY 
	BEGIN CATCH
		PRINT 'error'
	END CATCH
END

EXEC dbo.queryCustomerInOneCity @province = N'An Giang' -- nvarchar(100)

GO
CREATE PROCEDURE query

