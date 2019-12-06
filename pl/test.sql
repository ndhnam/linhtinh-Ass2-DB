USE dbTipee
GO

--EXEC dbo.insertShopAccount 'test2', 'test2', 'SHOP B', 999999999, 'address', 'email2@gmail.com', 'link', '1', 'SPORT', 'Si';
--EXEC dbo.procedureChangePassword 'test1', 'test', 'test1';
EXEC dbo.procedureChangeProfileShop 'KH1', 'test1', 'test1', 'SHOP A', 111111111, 'address', 'email_1@gmail.com', 'link', '0', 'SPORT', 'Si';

SELECT * FROM dbo.tblAccount
SELECT * FROM dbo.tblShop