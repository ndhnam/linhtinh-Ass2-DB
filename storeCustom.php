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
$psex="";
$pbirth="";
$ptel="";
$pstt="";
$pprovince="";
$pcity="";
$pward="";
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
    if(isset($_POST["psex"])) { $psex = $_POST['psex']; }
    if(isset($_POST["pbirth"])) { $pbirth = $_POST['pbirth']; }
    if(isset($_POST["ptel"])) { $ptel = $_POST['ptel']; }
    if(isset($_POST["pstt"])) { $pstt = $_POST['pstt']; }
    if(isset($_POST["pprovince"])) { $pprovince = $_POST['pprovince']; }
    if(isset($_POST["pcity"])) { $pcity = $_POST['pcity']; }
    if(isset($_POST["pward"])) { $pward = $_POST['pward']; }
}
$pid=(string)$pid;
$pname=(string)$pname;
$ppass=(string)$ppass;
$plname=(string)$plname;
$pfname=(string)$pfname;
$pemail=(string)$pemail;
$psex=(string)$psex;
$pbirth=(string)$pbirth;
$ptel=(string)$ptel;
$pstt=(int)$pstt;
$pprovince=(string)$pprovince;
$pcity=(string)$pcity;
$pward=(string)$pward;


$sql = "exec insertCustomerAccount '$pid', '$pname', '$ppass', '$plname', '$pfname', '$pemail', '$psex', '$pbirth', '$ptel', '$pstt', '$pprovince', '$pcity', '$pward'";
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
$indexURL = 'addCustom.php';
header('Location: '.$indexURL);
}
?>
</body>
</html>