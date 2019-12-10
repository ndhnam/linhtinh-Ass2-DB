use dbTipee
go
-----TRIGGEER------
------NGÔ THANH LIÊM------
	--KTRA SO LUONG 
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
exec insertPromotion 'TET3','2019-12-01','2020-01-01',-6,'ch??ng trình khuy?n mãi t?t 2020',500000,'?? gia d?ng',150000,10,200000,'ch0001'
=======
exec insertPromotion 'TET3','2019-12-01','2020-01-01',-6,'chương trình khuyễn mãi tết 2020',500000,'đồ gia dụng',150000,10,200000,'ch0001'
>>>>>>> fec95bafb62f6779a3a24f7d2a40c56a7b7e95bb


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

<<<<<<< HEAD
 exec insertOrder 'MDH014','Chuy?n kho?n','2019-12-01','2019-12-05','?ã giao','GRAB',23000,'','BLACK'
=======
 exec insertOrder 'MDH014','Chuyển khoản','2019-12-01','2019-12-05','Đã giao','GRAB',23000,'','BLACK'
>>>>>>> fec95bafb62f6779a3a24f7d2a40c56a7b7e95bb
select * from tblPromotion
select * from tblOrder
select * from tblTransportation

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