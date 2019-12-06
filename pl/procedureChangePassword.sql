USE dbTipee
GO
CREATE PROCEDURE procedureChangePassword
	@username VARCHAR(50),
	@curpassword VARCHAR(50),
	@newpassword VARCHAR(50)
AS
BEGIN
	DECLARE @hashCurPass AS VARCHAR(500)
	SET @hashCurPass = CONVERT(VARCHAR(500), HASHBYTES('SHA2_512', @curpassword))
	DECLARE @password AS VARCHAR(500)
	SET @password = (SELECT password FROM dbo.tblAccount WHERE username = @username)
	IF @hashCurPass = @password
		BEGIN
			UPDATE dbo.tblAccount SET password = CONVERT(VARCHAR(500), HASHBYTES('SHA2_512', @newpassword)) WHERE username = @username;
			print 'Change Password Success!'
		END
	ELSE
		BEGIN
			print 'Incorrect current password' 
		END
END



















