<!DOCTYPE html>
<html>
<body>
	<p>123 Main Street, Anytown, CA 12345 – USA</p>
<?php
$id="";
$name="";
$tel="";
$mail="";
$cost="";
$adress="";

require('dbCon.php');

    if(isset($_POST["id"])) { $spid = $_POST['id']; }
    if(isset($_POST["name"])) { $spname = $_POST['name']; }
    if(isset($_POST["tel"])) { $sptel = $_POST['tel']; }
    if(isset($_POST["mail"])) { $sparea = $_POST['mail']; }
    if(isset($_POST["cost"])) { $spaddr = $_POST['cost']; }
    if(isset($_POST["adress"])) { $spemail = $_POST['adress']; }
$id=(string)$id;
$name=(string)$name;
$tel=(string)$tel;
$cost=(string)$cost;
$mail=(string)$mail;
$adress=(string)$adress;

$sql = "INSERT INTO tblTransportation(id, name, tel, mail, cost, adress) VALUES('$id','$name','$tel','$mail', '$cost', '$adress')";
$result=sqlsrv_query($conn, $sql);
	//echo $id;
	if ($result == false)
	{
		die( print_r( sqlsrv_errors(), true));
	}
?>
	<p>123 Main Street, Anytown, CA 12345 – USA</p>
</body>
</html>