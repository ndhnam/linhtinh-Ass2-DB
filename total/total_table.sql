USE dbTipee
GO
-- Phần của Linh --
CREATE TABLE tblAccount
(
	id			VARCHAR(6)		PRIMARY KEY,			-- ID
	username	VARCHAR(32)		NOT NULL,				-- Tên tài khoản
	password	VARCHAR(100)	NOT NULL,				-- Mật khẩu
);

CREATE TABLE tblShop
(
	id				VARCHAR(6)		PRIMARY KEY,	-- ID
	name			NVARCHAR(50)		NOT NULL,		-- Tên Shop
	number			INT,							-- Số điện thoại
	address			NVARCHAR(100),						-- Địa chỉ
	email			VARCHAR(50),					-- Email
	avatar			VARCHAR(100),					-- Ảnh đại diện
	classify		INT,							-- Phân loại (0 - không chuyên, 1 - chuyên)
	typesOfShop		NVARCHAR(30),						-- Sản phẩm chuyên về (danh mục)
	distribution	NVARCHAR(10),						-- Sỉ/lẻ
	total_rate		INT,							-- Tổng lượt đánh giá --
	CONSTRAINT fk_shop_acc_id FOREIGN KEY (id) REFERENCES tblAccount(id),
);

CREATE TABLE tblRate
(
	idCustomer		VARCHAR(6)		NOT NULL,		-- id khách hàng 
	idShop			VARCHAR(6)		NOT NULL,		-- id cửa hàng 
	star			INT				NOT NULL,		-- số sao khách hàng đánh giá 
	describe		NVARCHAR(100),						-- đánh giá 
	PRIMARY KEY(idCustomer, idShop),
	CONSTRAINT fk_rate_shop_id FOREIGN KEY (idShop) REFERENCES tblShop(id)
	--CONSTRAINT fk_rate_cus_id FOREIGN KEY (idCustomer) REFERENCES tblCustomer(id_customer)
);

-- Chạy bảng khách hàng trước mới chạy cái này nhaaaa!
ALTER TABLE dbo.tblRate
	ADD CONSTRAINT fk_rate_cus_id
	FOREIGN KEY (idCustomer) REFERENCES tblCustomer(id_customer)
	ON DELETE CASCADE

-- Phần của Nam --
CREATE TABLE tblProduct
(
    id VARCHAR(50) PRIMARY KEY,
    name NVARCHAR(100) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
    SIZE CHAR(50),
    img text,
    color NVARCHAR(100),
    detail text
)
 
GO
CREATE TABLE tblHas
(
    idOrder VARCHAR(50) NOT NULL,
    idShop VARCHAR(50)  NOT NULL,
    idProduct VARCHAR(50) NOT NULL,
    unitPrice INT NOT NULL,
    amount INT NOT NULL,
    PRIMARY KEY(idOrder, idShop, idProduct)
)
ALTER TABLE tblHas
    ADD CONSTRAINT fk_has_product_id
    FOREIGN KEY (idProduct) REFERENCES tblProduct(id)
    ON DELETE CASCADE
 
CREATE TABLE tblSell
(
    idShop VARCHAR(50) NOT NULL,
    idProduct VARCHAR(50) NOT NULL,
    amount INT NOT NULL,
    unitPrice INT NOT NULL,
    PRIMARY KEY(idShop, idProduct)
)
ALTER TABLE tblSell
    ADD CONSTRAINT fk_sell_product_id
    FOREIGN KEY (idProduct) REFERENCES tblProduct(id)
    ON DELETE CASCADE

-- Phần của Liêm --
CREATE TABLE tblPromotion
(
	id					VARCHAR(50)		PRIMARY KEY,
	startTime			Date		NOT NULL,
	endTime				Date		NOT NULL,
	amountOfPromotion	Int			NOT NULL,
	dicription			Text		NOT NULL,
	minTotal			Int			NOT NULL,
	classify			Nchar(10)	NOT NULL,
	depreciate			Int			NOT NULL,
	decreasePercent		Int			NOT NULL,
	decreaseMax			Int			NOT NULL,
	idShop				VARCHAR(50)	NOT NULL
);
 ALTER TABLE tblPromotion
 ADD CONSTRAINT fk_IdShop
 FOREIGN KEY (idShop) REFERENCES tblShop(id)
 ON DELETE CASCADE

CREATE TABLE tblTransportation
(
	id				VARCHAR(50)		PRIMARY KEY,
	nameTrans		Nchar(50)	NOT NULL,
	hotline			Int			NOT NULL,
	mail			Char(50)	NOT NULL,
	costLevel		Int			NOT NULL,
	addressTrans	Char(100)	NOT NULL
);

CREATE TABLE tblOrder
(
	id				VARCHAR(50)		PRIMARY KEY,
	methodOfPayment Nchar(50)	NOT NULL,
	bookingTime		Date		NOT NULL,
	deliveryTime	Date		NOT NULL,
	orderStatus		Nchar(50)	NOT NULL,
	transportCode	VARCHAR(50)	NOT NULL,
	transportCost	Int			NOT NULL,
	idCustomer		VARCHAR(50)	NOT NULL,
	promotionCode	VARCHAR(50)	NOT NULL
);

ALTER TABLE dbo.tblOrder
ADD CONSTRAINT fk_promotionCode
FOREIGN KEY(promotionCode) REFERENCES tblPromotion(id)
ON DELETE CASCADE
ALTER TABLE dbo.tblOrder
ADD CONSTRAINT fk_idCustomer
FOREIGN KEY(idCustomer) REFERENCES tblCustomer(id)
ON DELETE CASCADE

-- Phần của Tâm --
CREATE TABLE tblCART(
    id         VARCHAR(50) NOT NULL,
    PRIMARY KEY(id),
    --id nvarchar(9) primary key,
    idclient   VARCHAR(50) NOT NULL,
    --foreign key(idclient) references Client(id)
);
GO
CREATE TABLE tblADD_CART(
    idcart      VARCHAR(50) NOT NULL,
    idproduct   VARCHAR(50) NOT NULL,
    idshop      VARCHAR(50) NOT NULL,
    PRIMARY KEY(idcart,idproduct,idshop),
    quantity    INT )
;
GO
CREATE TABLE tblCATEGORY(
    id             VARCHAR(50) NOT NULL,
    PRIMARY KEY(id),
    name            nvarchar(30),
    quantity        INT         DEFAULT 0           --- tt dẫn xuất
);
GO
CREATE TABLE tblBELONG_CATEGORY(
    idproduct   VARCHAR(50) NOT NULL,
    idcate      VARCHAR(50) NOT NULL,
    PRIMARY KEY(idcate,idproduct)
);
GO

-- Phần của Ly --
CREATE TABLE tblCustomer 
(
	id_customer VARCHAR(50) PRIMARY KEY,
	last_name NVARCHAR(20), 
	first_name NVARCHAR(20),
	email VARCHAR(100) NOT NULL,
	sex BIT,
	date_of_birth DATE,
	id_intro VARCHAR(50),
	id_reduce VARCHAR(50)
);

CREATE TABLE tblTelephoneNumber
(
	tel_number VARCHAR(11),
	id_customer VARCHAR(50),
	PRIMARY KEY(tel_number, id_customer)
); 
ALTER TABLE tblTelephoneNumber 
ADD CONSTRAINT FK_CustomerTelephoneNumber
FOREIGN KEY(id_customer) REFERENCES tblCustomer(id_customer);

CREATE TABLE tblAdrress 
(
	addr NVARCHAR(100), 
	id_customer VARCHAR(50),
	province NVARCHAR(100),
	city NVARCHAR(100),
	ward NVARCHAR(100),
	detail NTEXT,
	type_address VARCHAR(10),
	PRIMARY KEY(addr, id_customer)
);
ALTER TABLE tblAdrress
ADD CONSTRAINT FK_Customer_Address
FOREIGN KEY(id_customer) REFERENCES tblCustomer(id_customer);