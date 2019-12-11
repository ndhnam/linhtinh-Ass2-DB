use dbTipee
go
-----TRIGGEER------
------NGÔ THANH LIÊM------
	--KTRA SO LUONG \

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
<<<<<<< HEAD
<<<<<<< HEAD
go
=======
<<<<<<< HEAD
exec insertPromotion 'TET3','2019-12-01','2020-01-01',-6,'ch??ng trình khuy?n mãi t?t 2020',500000,'?? gia d?ng',150000,10,200000,'ch0001'
=======
>>>>>>> 12edffaf007d53022910e529222b94f437e4c143
=======
>>>>>>> 515323be6b987f7e10ce93f502a81104284cd58e
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
<<<<<<< HEAD
go
=======

--- Phần của Linh - 1710165 ---
GO
CREATE TRIGGER trgCountRate ON dbo.tblRate
AFTER INSERT
AS
BEGIN
	DECLARE @count_idCustomer INT = (SELECT COUNT(idCustomer) FROM dbo.tblRate WHERE idShop = (SELECT idShop FROM inserted))
	UPDATE dbo.tblShop SET total_rate = @count_idCustomer WHERE id = (SELECT idShop FROM inserted)
END
GO
CREATE TRIGGER trgDeleteRate ON dbo.tblRate
FOR DELETE	
AS
BEGIN
	DECLARE @cur_idShop VARCHAR(6) = (SELECT idShop FROM deleted)
	DECLARE	@cur_idCustomer VARCHAR(6) = (SELECT idCustomer FROM deleted)
	DECLARE @curTotalRate INT = (SELECT total_rate FROM tblShop WHERE id = @cur_idShop) - 1 
	PRINT @curTotalRate
	UPDATE dbo.tblShop 
	SET total_rate = @curTotalRate
	WHERE id = @cur_idShop
END
GO
CREATE TRIGGER trgCheckEmail ON dbo.tblShop
AFTER INSERT
AS
BEGIN
	DECLARE @cur_email VARCHAR(50) = (SELECT email FROM inserted)
	DECLARE @check AS BIT;
	IF @cur_email NOT LIKE '%@%.%'
		BEGIN 
			PRINT 'Format of email is %@%.%'
			DELETE FROM dbo.tblAccount WHERE id = (SELECT id FROM inserted)
			--ROLLBACK
			--UPDATE dbo.tblShop SET email = (SELECT email FROM tblShop WHERE id = (SELECT id FROM inserted)) + '@gmail.com' WHERE id = (SELECT id FROM inserted)
		END
	ELSE
		PRINT 'SUCCESS'
END
GO
<<<<<<< HEAD
>>>>>>> 12edffaf007d53022910e529222b94f437e4c143
=======

--- phần của Nam ---
create trigger check_amount_sell on tblSell for insert as
begin
	declare @amount int
	set @amount = (select amount from inserted)
	if (@amount < 0)
	begin
		print 'Error: amount < 0'
		rollback
	end
end
GO
create trigger check_amount_has on tblHas for insert as
begin
	declare @amount int
	declare @amountSell int
	declare @idProduct Varchar(50)
	declare @idShop VARCHAR(50)
	set @amount = (select amount from inserted)
	set @idProduct = (select idProduct from inserted)
	set @idShop = (select idShop from inserted)
	set @amountSell = (select amount from tblSell where @idProduct = tblSell.idProduct and @idShop = tblSell.idShop)
	if (@amount <= 0 and @amount > @amountSell )
	begin
		print 'Error: amount <= 0 or amount > amountSell'
		rollback
	end
end
GO
create trigger update_amount_sell on tblHas after insert as
begin
	update tblSell
	set tblSell.amount = tblSell.amount - (
		select amount
		from inserted
		where idShop = tblSell.idShop and idProduct = tblSell.idProduct
	)
	from tblSell
	join inserted on tblSell.idProduct = inserted.idProduct and tblSell.idShop = inserted.idShop
end
GO
>>>>>>> 515323be6b987f7e10ce93f502a81104284cd58e
