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
exec insertPromotion 'TET3','2019-12-01','2020-01-01',-6,'ch??ng trình khuy?n mãi t?t 2020',500000,'?? gia d?ng',150000,10,200000,'ch0001'


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

 exec insertOrder 'MDH014','Chuy?n kho?n','2019-12-01','2019-12-05','?ã giao','GRAB',23000,'','BLACK'
select * from tblPromotion
select * from tblOrder
select * from tblTransportation