USE dbTipee
GO
CREATE TABLE tblAccount
(
	id			CHAR(9)		PRIMARY KEY,
	username	VARCHAR(32)	NOT NULL,
	password	VARCHAR(32)	NOT NULL,
);

CREATE TABLE tblShop
(
	id				CHAR(9)		PRIMARY KEY,
	name			VARCHAR(50)	NOT NULL,
	number			INT,
	address			VARCHAR(50),
	classify		VARCHAR(30),
	typesOfShop		VARCHAR(30),
	email			VARCHAR(50),
	distribution	VARCHAR(10),
);
CREATE TABLE tblRate
(
	idCustomer		CHAR(9)		NOT NULL,
	idShop			CHAR(9)		NOT NULL,
	star			INT			NOT NULL,
	describe		VARCHAR(100),
	PRIMARY KEY(idCustomer, idShop),
);
ALTER TABLE dbo.tblShop
	ADD CONSTRAINT fk_shop_acc_id
	FOREIGN KEY (id) REFERENCES tblAccount(id)
ALTER TABLE dbo.tblRate
	ADD CONSTRAINT fk_rate_shop_id
	FOREIGN KEY (idShop) REFERENCES tblShop(id)
--ALTER TABLE dbo.tblCustomer
--	ADD CONSTRAINT fk_rate_cus_id
--	FOREIGN KEY (idCustomer) REFERENCES tblCustomer(id)
INSERT INTO tblAccount VALUES
(
	123456789,
	'username',
	'password'
);