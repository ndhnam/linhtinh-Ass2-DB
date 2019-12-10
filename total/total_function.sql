-- Ngô Thanh Liêm - 1711929
USE dbTipee
Go

create function totalMoneyFromHas
(
	@idOrder Varchar(50)
)
returns int
as
begin
	declare @totalMoney int
	set @totalMoney = (select sum(money) as totalMoney
	from (select (unitPrice*amount) as money
		from tblHas
		where tblHas.idOrder = @idOrder) as totalMoneend)
	return @totalMoney
end
go
exec totalMoneyFromHas('MDH001')

CREATE FUNCTION totalMoneyByDepreciate
(
	@idOrder VARCHAR(50)
)
returns float
BEGIN
	declare @sum int
	set @sum = totalMoneyFromHas(@idOrder)
	if(@sum >= (select minTotal from tblOrder join tblPromotion on tblOrder.promotionCode = tblPromotion.id ))
	begin
		set @sum = ((totalMoneyFromHas(@idOrder)+(select costLevel From tblTransportation join tblOrder on tblTransportation.id = tblOrder.transportCode))-(select depreciate from tblOrder join tblPromotion on tblOrder.promotionCode = tblPromotion.id ))
	end
	return @sum
END

