<?php
    $serverName="NHOIBK\MSSQLSERVER01";
    $connectionInfo = array("Database"=>"dbTipee");
    $conn = sqlsrv_connect($serverName, $connectionInfo);
	if(isset($conn )) {
     	echo "Connection established.<br />";
	}else{
		echo "Connection could not be established.<br />";
     	die( print_r( sqlsrv_errors(), true));
	}
?>
