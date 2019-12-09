﻿USE dbTipee
GO
CREATE FUNCTION funcAvgRate (@idShop VARCHAR(6))
RETURNS FLOAT
AS
BEGIN
	DECLARE @avgRate AS FLOAT
	SET @avgRate = (SELECT AVG(CAST(star AS FLOAT)) FROM tblRate WHERE idShop = @idShop)
	RETURN @avgRate
END;