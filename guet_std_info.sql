-- phpMyAdmin SQL Dump
-- version 4.6.4
-- https://www.phpmyadmin.net/
--
-- Host: 192.168.3.2
-- Generation Time: 2016-11-12 07:02:08
-- 服务器版本： 5.6.27
-- PHP Version: 5.6.26

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `guet_std_info`
--

-- --------------------------------------------------------

--
-- 表的结构 `student_info`
--

CREATE TABLE `student_info` (
  `sid` int(11) NOT NULL,
  `name` varchar(5) DEFAULT NULL,
  `academy` varchar(20) DEFAULT NULL,
  `major` varchar(20) DEFAULT NULL,
  `pid` varchar(20) DEFAULT NULL,
  `tell` varchar(12) DEFAULT NULL,
  `sex` char(1) DEFAULT NULL,
  `headman` varchar(4) DEFAULT NULL,
  `parent` varchar(4) DEFAULT NULL,
  `parent_tell` varchar(12) DEFAULT NULL,
  `address` varchar(50) DEFAULT NULL,
  `bank` varchar(20) DEFAULT NULL,
  `birthday` varchar(12) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `students`
--
ALTER TABLE `students`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `sid` (`sid`);

--
-- Indexes for table `student_info`
--
ALTER TABLE `student_info`
  ADD PRIMARY KEY (`sid`);

--
-- 在导出的表使用AUTO_INCREMENT
--

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
