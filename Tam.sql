--Tâm 1713057--
use dbTipee 
go
-- Table 
create TABLE tblCART(
	id			nvarchar(9) not null,
	primary key(id),
	--id nvarchar(9) primary key,
	idclient	nvarchar(10) not null,
	--foreign key(idclient) references Client(id)
);
GO
create TABLE tblADD_CART(
	idcart		nvarchar(9) not null,
	idproduct	VARCHAR(50) not null,
	idshop		VARCHAR(6) not null,
	primary key(idcart,idproduct,idshop),
	quantity	int )
;
GO
CREATE TABLE tblCATEGORY(
	id				char(3) not null,
	primary key(id),
	name			nvarchar(30),
	quantity		int			DEFAULT 0			--- tt dẫn xuất 
);
go
CREATE TABLE tblBELONG_CATEGORY(
	idproduct	varchar(50) not null,
	idcate		char(3) not null,
	primary key(idcate,idproduct)
);
go
/*Insert data*/
INSERT INTO tblCART VALUES ('1',12);

INSERT INTO tblADD_CART VALUES ('1','123a',167,5);

INSERT INTO tblCATEGORY VALUES ('DT',N'Điện tử',1);

INSERT INTO tblBELONG_CATEGORY VALUES ('123a','DT');
go

--ALTER TABLE tblCART
	ADD 
		CONSTRAINT		fk_cart_customer		FOREIGN KEY (idclient)
	REFERENCES tblCustomer(id)
	ON DELETE CASCADE
	ON UPDATE CASCADE;
go
--ALTER TABLE tblADD_CART   idproduct	VARCHAR(50);
go

ALTER TABLE tblADD_CART
	ADD 
		CONSTRAINT	fk_cart_addcart		FOREIGN KEY (idcart)
	REFERENCES tblCART(id)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
		CONSTRAINT	fk_pro_addcart		FOREIGN KEY (idproduct)
	REFERENCES tblProduct(id)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
		CONSTRAINT	fk_shop_addcart		FOREIGN KEY (idshop)
	REFERENCES tblShop(id)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
		CONSTRAINT	check_quantity		CHECK(quantity>0)
go

ALTER TABLE tblCATEGORY
	ADD 
		CONSTRAINT	check_quantity_cate 	CHECK(quantity>=0);
go

ALTER TABLE tblBELONG_CATEGORY
	ADD 
	CONSTRAINT	fk_cate	FOREIGN KEY (idcate)
	REFERENCES tblCATEGORY(id)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	CONSTRAINT	fk_cate_pro	FOREIGN KEY (idproduct)
	REFERENCES tblProduct(id)
	ON DELETE CASCADE
	ON UPDATE CASCADE;
go 

