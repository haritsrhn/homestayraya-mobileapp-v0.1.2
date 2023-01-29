<?php
	
	if(!isset($_POST)) {
		$response = array('status' => 'failed', 'data' => null);
		sendJsonResponse($response);
		die();
	}
	
	include_once("dbconnect.php");
	$userid = $_POST['userid'];
	$hsname = $_POST['hsname'];
	$hsdesc = $_POST['hsdesc'];
	$hsprice = $_POST['hsprice'];
	$hsaddress = $_POST['hsaddress'];
	$state = $_POST['state'];
	$loc = $_POST['loc'];
	$lat = $_POST['lat'];
	$lng = $_POST['lng'];
	$image1 = $_POST['image1'];
	$image2 = $_POST['image2'];
	$image3 = $_POST['image3'];
	
	$sqlinsert = "INSERT INTO `tbl_homestay`(`user_id`, `hs_name`, `hs_desc`, `hs_price`, `hs_address`, `hs_state`, `hs_local`, `hs_lat`, `hs_lng`) 
	VALUES ('$userid','$hsname','$hsdesc','$hsprice','$hsaddress','$state','$loc','$lat','$lng')";
	
	try{
		if ($conn->query($sqlinsert) === TRUE) {
			$response = array('status' => 'success', 'data' => null);
			$decoded_string1 = base64_decode($image1);
			$decoded_string2 = base64_decode($image2);
			$decoded_string3 = base64_decode($image3);
			$filename = mysqli_insert_id($conn);
			$path1 = '../assets/homestay_image/'.$filename.'-1.png';
			$path2 = '../assets/homestay_image/'.$filename.'-2.png';
			$path3 = '../assets/homestay_image/'.$filename.'-3.png';
			file_put_contents($path1, $decoded_string1);
			file_put_contents($path2, $decoded_string2);
			file_put_contents($path3, $decoded_string3);
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