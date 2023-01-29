<?php
	error_reporting(0);
	include_once("dbconnect.php");
	$search  = $_GET["search"];
	$results_per_page = 6;
	$pageno = (int)$_GET['pageno'];
	$page_first_result = ($pageno - 1) * $results_per_page;
	
	if ($search =="all"){
			$sqlloadproduct = "SELECT * FROM tbl_homestay ORDER BY hs_date DESC";
	}else{
		$sqlloadproduct = "SELECT * FROM tbl_homestay WHERE hs_name LIKE '%$search%' ORDER BY hs_date DESC";
	}
	
	$result = $conn->query($sqlloadproduct);
	$number_of_result = $result->num_rows;
	$number_of_page = ceil($number_of_result / $results_per_page);
	$sqlloadproduct = $sqlloadproduct . " LIMIT $page_first_result , $results_per_page";
	$result = $conn->query($sqlloadproduct);
	
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
		$response = array('status' => 'success', 'numofpage'=>"$number_of_page",'numberofresult'=>"$number_of_result",'data' => $homestaysarray);
    sendJsonResponse($response);
		}else{
		$response = array('status' => 'failed','numofpage'=>"$number_of_page", 'numberofresult'=>"$number_of_result",'data' => null);
    sendJsonResponse($response);
	}
	
	function sendJsonResponse($sentArray)
	{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
	}