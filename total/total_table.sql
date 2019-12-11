
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
	--CONSTRAINT fk_shop_acc_id FOREIGN KEY (id) REFERENCES tblAccount(id),
);
ALTER TABLE dbo.tblShop
	ADD CONSTRAINT fk_shop_acc_id
	FOREIGN KEY (id) REFERENCES tblAccount(id)
	ON DELETE CASCADE
GO
CREATE TABLE tblRate
(
	idCustomer		VARCHAR(6)		NOT NULL,		-- id khách hàng 
	idShop			VARCHAR(6)		NOT NULL,		-- id cửa hàng 
	star			INT				NOT NULL,		-- số sao khách hàng đánh giá 
	describe		NVARCHAR(100),						-- đánh giá 
	PRIMARY KEY(idCustomer, idShop),
	--CONSTRAINT fk_rate_shop_id FOREIGN KEY (idShop) REFERENCES tblShop(id)
	--CONSTRAINT fk_rate_cus_id FOREIGN KEY (idCustomer) REFERENCES tblCustomer(id_customer)
);
ALTER TABLE dbo.tblRate
	ADD CONSTRAINT fk_rate_shop_id 
	FOREIGN KEY (idShop) REFERENCES tblShop(id)
	ON DELETE CASCADE
GO
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
GO
CREATE TABLE tblCART(
    id          VARCHAR(50) NOT NULL,
    PRIMARY KEY(id),
    --id nvarchar(9) primary key,
    idclient    VARCHAR(50) NOT NULL,
    --foreign key(idclient) references Client(id)
);
GO
CREATE TABLE tblADD_CART(
    idcart      nvarchar(9) NOT NULL,
    idproduct   VARCHAR(50) NOT NULL,
    idshop      VARCHAR(6) NOT NULL,
    PRIMARY KEY(idcart,idproduct,idshop),
    quantity    INT )
;
GO
CREATE TABLE tblCATEGORY(
    id              CHAR(3) NOT NULL,
    PRIMARY KEY(id),
    name            nvarchar(30),
    quantity        INT         DEFAULT 0           --- tt dẫn xuất
);
GO
CREATE TABLE tblBELONG_CATEGORY(
    idproduct   VARCHAR(50) NOT NULL,
    idcate      CHAR(3) NOT NULL,
    PRIMARY KEY(idcate,idproduct)
);
GO
ALTER TABLE tblCART
    ADD
        CONSTRAINT      fk_cart_customer        FOREIGN KEY (idclient)
    REFERENCES tblCustomer(id_customer)
    ON DELETE CASCADE
    ON UPDATE CASCADE;
GO
--ALTER TABLE tblADD_CART   idproduct   VARCHAR(50);
GO
 
ALTER TABLE tblADD_CART
    ADD
        CONSTRAINT  fk_cart_addcart     FOREIGN KEY (idcart)
    REFERENCES tblCART(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
        CONSTRAINT  fk_pro_addcart      FOREIGN KEY (idproduct)
    REFERENCES tblProduct(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
        CONSTRAINT  fk_shop_addcart     FOREIGN KEY (idshop)
    REFERENCES tblShop(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
        CONSTRAINT  check_quantity      CHECK(quantity>0)
GO
 
ALTER TABLE tblCATEGORY
    ADD
        CONSTRAINT  check_quantity_cate     CHECK(quantity>=0);
GO
 
ALTER TABLE tblBELONG_CATEGORY
    ADD
    CONSTRAINT  fk_cate FOREIGN KEY (idcate)
    REFERENCES tblCATEGORY(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    CONSTRAINT  fk_cate_pro FOREIGN KEY (idproduct)
    REFERENCES tblProduct(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE;
GO

-- Phần của Ly --
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