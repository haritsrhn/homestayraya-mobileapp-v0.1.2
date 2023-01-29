<?php
	if (!isset($_POST)) {
		$response = array('status' => 'failed', 'data' => null);
		sendJsonResponse($response);
		die();
	}
	include_once("dbconnect.php");
	$userid = $_POST['userid'];
	$hsid = $_POST['hsid'];
	$hsname = ucwords(addslashes($_POST['hsname']));
	$hsdesc = ucfirst(addslashes($_POST['hsdesc']));
	$hsprice = $_POST['hsprice'];
	$hsaddress = $_POST['hsaddress'];
	
	$sqlupdate = "UPDATE `tbl_homestay` SET `hs_name`='$hsname',`hs_desc`='$hsdesc',`hs_price`='$hsprice',`hs_address`='$hsaddress' WHERE `hs_id` = '$hsid' AND `user_id` = '$userid'";
	
	try {
		if ($conn->query($sqlupdate) === TRUE) {
			$response = array('status' => 'success', 'data' => null);
			sendJsonResponse($response);
		}
		else{
			$response = array('status' => 'failed', 'data' => null);
			sendJsonResponse($response);
		}
	}
	catch(Exception $e) {
		$response = array('status' => 'failed', 'data' => null);
		sendJsonResponse($response);
	}
	$conn->close();
	
	function sendJsonResponse($sentArray)
	{
		header('Content-Type = application/json');
		echo json_encode($sentArray);
	}
?>