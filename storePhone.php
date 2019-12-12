<!DOCTYPE html>
<html>
<body>
<?php
$pid="";
$pname="";
$sql="";

require('connect_db.php');
if ($_SERVER['REQUEST_METHOD'] != 'POST')
    die('Invalid HTTP method!');
else {
    if(isset($_POST["pid"])) { $pid = $_POST['pid']; }
    if(isset($_POST["pname"])) { $pname = $_POST['pname']; }

}
$pid=(string)$pid;
$pname=(string)$pname;


$sql = "INSERT INTO tblTelephoneNumber VALUES ('$pid', '$pname')";
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
$indexURL = 'addPhone.php';
header('Location: '.$indexURL);
}
?>
</body>
</html>