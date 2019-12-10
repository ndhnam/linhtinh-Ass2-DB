USE dbTipee
GO
CREATE TABLE tblAccount
(
	id			VARCHAR(6)		PRIMARY KEY,			-- ID
	username	VARCHAR(32)		NOT NULL,				-- Tên tài khoản
	password	VARCHAR(500)	NOT NULL,				-- Mật khẩu
);

CREATE TABLE tblShop
(
	id				VARCHAR(6)		PRIMARY KEY,	-- ID
	name			VARCHAR(50)	NOT NULL,			-- Tên Shop
	number			INT,							-- Số điện thoại
	address			NCHAR(50),					-- Địa chỉ
	email			VARCHAR(50),					-- Email
	avatar			VARCHAR(100),					-- Ảnh đại diện
	classify		INT,							-- Phân loại (0 - không chuyên, 1 - chuyên)
	typesOfShop		VARCHAR(30),					-- Sản phẩm chuyên về
	distribution	VARCHAR(10),					-- Sỉ/lẻ
);
CREATE TABLE tblRate
(
	idCustomer		VARCHAR(6)		NOT NULL,
	idShop			VARCHAR(6)		NOT NULL,
	star			INT			NOT NULL,
	describe		VARCHAR(100),
	PRIMARY KEY(idCustomer, idShop),
);
ALTER TABLE dbo.tblShop
	ADD CONSTRAINT fk_shop_acc_id
	FOREIGN KEY (id) REFERENCES tblAccount(id)
	ON DELETE CASCADE
ALTER TABLE dbo.tblRate
	ADD CONSTRAINT fk_rate_shop_id
	FOREIGN KEY (idShop) REFERENCES tblShop(id)
	ON DELETE CASCADE
--ALTER TABLE dbo.tblCustomer
--	ADD CONSTRAINT fk_rate_cus_id
--	FOREIGN KEY (idCustomer) REFERENCES tblCustomer(id)
