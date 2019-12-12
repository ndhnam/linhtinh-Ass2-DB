<!DOCTYPE html>
<html>
<body>
<?php
$pid="";
$pname="";
$ppass="";
$plname="";
$pfname="";
$pemail="";

$sql="";

require('connect_db.php');
if ($_SERVER['REQUEST_METHOD'] != 'POST')
    die('Invalid HTTP method!');
else {
    if(isset($_POST["pid"])) { $pid = $_POST['pid']; }
    if(isset($_POST["pname"])) { $pname = $_POST['pname']; }
    if(isset($_POST["ppass"])) { $ppass = $_POST['ppass']; }
    if(isset($_POST["plname"])) { $plname = $_POST['plname']; }
    if(isset($_POST["pfname"])) { $pfname = $_POST['pfname']; }
    if(isset($_POST["pemail"])) { $pemail = $_POST['pemail']; }

}
$pid=(string)$pid;
$pname=(string)$pname;
$ppass=(string)$ppass;
$plname=(string)$plname;
$pfname=(string)$pfname;
$pemail=(string)$pemail;



$sql = "exec insertProduct '$pid', '$pname', '$ppass', '$plname', '$pfname', '$pemail'";
$result=sqlsrv_query($conn, $sql);
if( $result === false ) {
    if( ($errors = sqlsrv_errors() ) != null) {
        foreach( $errors as $error ) {
            echo "SQLSTATE: ".$error[ 'SQLSTATE']."<br />";
            echo "code: ".$error[ 'code']."<br />";
            echo "message: ".$error[ 'message']."<br />";
            echo "<button type=";echo"button";echo" class=";echo "btn btn-warning"; echo "><a href="; echo"index.php"; echo " class="; echo"index";echo ">RETURN</a></button>";
        }
    }
}else{
$indexURL = 'addProduct.php';
header('Location: '.$indexURL);
}
?>
</body>
</html>