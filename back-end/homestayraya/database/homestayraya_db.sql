-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jan 29, 2023 at 05:57 PM
-- Server version: 10.4.25-MariaDB
-- PHP Version: 8.1.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `homestayraya_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `tbl_homestay`
--

CREATE TABLE `tbl_homestay` (
  `hs_id` int(5) NOT NULL,
  `user_id` varchar(10) NOT NULL,
  `hs_name` varchar(100) NOT NULL,
  `hs_desc` varchar(500) NOT NULL,
  `hs_price` float NOT NULL,
  `hs_address` varchar(500) NOT NULL,
  `hs_state` varchar(20) NOT NULL,
  `hs_local` varchar(50) NOT NULL,
  `hs_lat` varchar(15) NOT NULL,
  `hs_lng` varchar(15) NOT NULL,
  `hs_date` datetime(6) NOT NULL DEFAULT current_timestamp(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tbl_homestay`
--

INSERT INTO `tbl_homestay` (`hs_id`, `user_id`, `hs_name`, `hs_desc`, `hs_price`, `hs_address`, `hs_state`, `hs_local`, `hs_lat`, `hs_lng`, `hs_date`) VALUES
(3, '23', 'Iky Homestay', 'Fully furnished', 1000, 'Paluta Street', 'California', 'Mountain View', '37.4219983', '-122.084', '2023-01-27 02:51:34.156430'),
(4, '23', 'Raub Homestay', 'Deluxe bed, living room and 2 bathrooms', 350, 'Raub Street', 'Pahang', 'Raub', '3.7760633', '101.8538083', '2023-01-29 20:28:21.272455'),
(5, '23', 'Teratai Homestay', 'Traditional theme homestay', 760, '3rd Teratai Street', 'Selangor', 'Kuala Kubu Baru', '3.558725', '101.6468433', '2023-01-29 20:30:28.842707'),
(6, '24', 'Jeremy Homestay', '3 bedrooms, 2 bathrooms, living room', 700, '1st Bukit Jeremy Street', 'Federal Territory of', 'Kuala Lumpur', '3.141055', '101.6445217', '2023-01-29 20:34:20.521271'),
(7, '24', 'Lebak Homestay', '3 bedrooms, 2 bathrooms, swimming pool and living room', 1500, '23/108 Street', 'Wilayah Persekutuan ', 'Kuala Lumpur', '3.0938267', '101.7065717', '2023-01-29 20:37:49.598403'),
(8, '20', 'Nipah Guest House', 'Deluxe bed and 1 bathroom', 150, 'Pangkor Street', 'Perak', 'Pulau Pangkor', '4.2319133', '100.54809', '2023-01-29 20:43:01.010616'),
(9, '20', 'Zoey Guest House', '2 Bedrooms, 1 bathroom, living room, ktichen and dining room', 850, '27A Street', 'Wilayah Persekutuan ', 'Kuala Lumpur', '3.093845', '101.708115', '2023-01-29 20:48:39.724854');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_users`
--

CREATE TABLE `tbl_users` (
  `user_id` int(5) NOT NULL,
  `user_email` varchar(50) NOT NULL,
  `user_name` varchar(50) NOT NULL,
  `user_phone` varchar(15) NOT NULL,
  `user_address` varchar(500) NOT NULL,
  `user_datereg` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `user_otp` int(5) NOT NULL,
  `user_password` varchar(40) NOT NULL,
  `user_credit` int(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tbl_users`
--

INSERT INTO `tbl_users` (`user_id`, `user_email`, `user_name`, `user_phone`, `user_address`, `user_datereg`, `user_otp`, `user_password`, `user_credit`) VALUES
(16, 'shinta@gmail.com', 'Shinta', '01178658765', 'NA', '2022-12-12 22:12:14.686120', 93219, 'b0b87bb1da31d25d2bc1568bb9f1cd03b75d8055', 20),
(19, 'agung@gmail.com', 'Agung Gumelar', '01166778855', 'NA', '2022-12-14 20:49:38.533920', 41000, 'b0b87bb1da31d25d2bc1568bb9f1cd03b75d8055', 20),
(20, 'jojo@gmail.com', 'Jojo', '01166443322', 'NA', '2022-12-14 20:59:36.876928', 33857, 'b0b87bb1da31d25d2bc1568bb9f1cd03b75d8055', 20),
(21, 'reza@gmail.com', 'Reza', '01177666555', 'NA', '2022-12-15 04:10:55.936775', 61759, 'b0b87bb1da31d25d2bc1568bb9f1cd03b75d8055', 20),
(22, 'rizki@gmail.com', 'Rizki', '0118877665544', 'NA', '2022-12-15 20:57:38.015002', 77517, 'b0b87bb1da31d25d2bc1568bb9f1cd03b75d8055', 20),
(23, 'keanhiong@gmail.com', 'Kean Hiong', '01176548765', 'NA', '2023-01-04 18:17:30.091100', 42683, 'b0b87bb1da31d25d2bc1568bb9f1cd03b75d8055', 20),
(24, 'haritsrhn@gmail.com', 'Raihan', '01188668810', 'NA', '2023-01-04 21:10:55.490002', 68116, '9048ead9080d9b27d6b2b6ed363cbf8cce795f7f', 20);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tbl_homestay`
--
ALTER TABLE `tbl_homestay`
  ADD PRIMARY KEY (`hs_id`);

--
-- Indexes for table `tbl_users`
--
ALTER TABLE `tbl_users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `user_email` (`user_email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tbl_homestay`
--
ALTER TABLE `tbl_homestay`
  MODIFY `hs_id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `tbl_users`
--
ALTER TABLE `tbl_users`
  MODIFY `user_id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
