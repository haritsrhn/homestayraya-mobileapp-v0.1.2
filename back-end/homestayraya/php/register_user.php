<?php
if (!isset($_POST)) {
	$response = array('status' => 'failed', 'data' => null);
	sendJsonResponse($response);
	die();
}else{
	$response = array('status' => 'success', 'data' => null);
	sendJsonResponse($response);
	}
	
include_once("dbconnect.php");
$name = $_POST['name'];
$email = $_POST['email'];
$phone = $_POST['phone'];
$password = sha1($_POST['password']);
$otp = rand(10000,99999);
$address = "NA";
$credit = 20;
	
$sqlinsert = "INSERT INTO `tbl_users` (`user_email`, `user_name`, `user_phone`, `user_address`, `user_otp`, `user_password`,`user_credit`) 
	VALUES ('$email','$name','$phone','$address','$otp','$password', '$credit')";

try{
	if ($conn->query($sqlinsert) === TRUE) {
		$response = array('status' => 'success', 'data' => null);
		sendJsonResponse($response);
	}else{
		$response = array('status' => 'failed', 'data' => null);
		sendJsonResponse($response);
	}
}
catch(Exception $e){
	$response = array('status' => 'failed', 'data' => null);
	sendJsonResponse($response);
}

$conn->close();
	
function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>