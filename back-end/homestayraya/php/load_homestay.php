<?php
	
	if(!isset($_GET)) {
		$response = array('status' => 'failed', 'data' => null);
		sendJsonResponse($response);
		die();
	}
	include_once("dbconnect.php");
	$userid = $_GET['userid'];
	$sqlload = "SELECT * FROM tbl_homestay WHERE user_id = '$userid' ORDER BY hs_date DESC";
	$result = $conn->query($sqlload);
	if ($result->num_rows > 0) {
		$homestaysarray["homestays"] = array();
		while ($row = $result->fetch_assoc()) {
			$hslist = array();
			$hslist['hs_id'] = $row['hs_id'];
			$hslist['user_id'] = $row['user_id'];
			$hslist['hs_name'] = $row['hs_name'];
			$hslist['hs_desc'] = $row['hs_desc'];
			$hslist['hs_price'] = $row['hs_price'];
			$hslist['hs_address'] = $row['hs_address'];
			$hslist['hs_state'] = $row['hs_state'];
			$hslist['hs_local'] = $row['hs_local'];
			$hslist['hs_lat'] = $row['hs_lat'];
			$hslist['hs_lng'] = $row['hs_lng'];
			$hslist['hs_date'] = $row['hs_date'];
			array_push($homestaysarray["homestays"],$hslist);
		}
		$response = array('status' => 'success', 'data' => $homestaysarray);
		sendJsonResponse($response);
		}else{
		$response = array('status' => 'failed', 'data' => null);
		sendJsonResponse($response);
	}
	function sendJsonResponse($sentArray)
	{
		header('Content-Type: application/json');
		echo json_encode($sentArray);
	}
	
?>	