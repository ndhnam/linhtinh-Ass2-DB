CREATE TABLE tblProduct
(
	id VARCHAR(50) primary key,
	name NVARCHAR(100) COLLATE SQL_Latin1_General_CP1_CI_AI not null,
	size CHAR(50),
	img text,
	color NVARCHAR(100),
	detail text
)

GO
CREATE TABLE tblHas
(
	idOrder VARCHAR(50) not null,
	idShop VARCHAR(50)  not null,
	idProduct varchar(50) not null,
	unitPrice int not null,
	amount int not null,
	PRIMARY KEY(idOrder, idShop, idProduct)
)

CREATE TABLE tblSell
(
	idShop VARCHAR(50) not null,
	idProduct VARCHAR(50) not null,
	amount int not null,
	unitPrice int not null,
	PRIMARY KEY(idShop, idProduct)
)

ALTER TABLE tblHas
	ADD CONSTRAINT fk_has_product_id
	FOREIGN KEY (idProduct) REFERENCES tblProduct(id)
	ON DELETE CASCADE

ALTER TABLE tblSell
	ADD CONSTRAINT fk_sell_product_id
	FOREIGN KEY (idProduct) REFERENCES tblProduct(id)
	ON DELETE CASCADE

GO