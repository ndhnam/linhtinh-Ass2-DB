<?php
$serverName = "DESKTOP-H4MS494";
$connectionInfo = array( "Database"=>"dbTipee");
$conn = sqlsrv_connect( $serverName, $connectionInfo);
if( $conn == false) 
{
	echo "Connection could not be established.<br />";
    //die( print_r( sqlsrv_errors(), true));
	 include ("lib/404.html");
}	
?>