CREATE DATABASE  IF NOT EXISTS `buyme` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `buyme`;
-- MySQL dump 10.13  Distrib 8.0.36, for macos14 (x86_64)
--
-- Host: localhost    Database: buyme
-- ------------------------------------------------------
-- Server version	8.0.21

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `admin`
--

DROP TABLE IF EXISTS `admin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admin` (
  `admin_username` varchar(30) NOT NULL,
  `admin_password` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`admin_username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin`
--

LOCK TABLES `admin` WRITE;
/*!40000 ALTER TABLE `admin` DISABLE KEYS */;
INSERT INTO `admin` VALUES ('admin','adminpassword');
/*!40000 ALTER TABLE `admin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `admin_rep`
--

DROP TABLE IF EXISTS `admin_rep`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admin_rep` (
  `admin_id` varchar(30) DEFAULT NULL,
  `rep_id` varchar(30) DEFAULT NULL,
  KEY `admin_id` (`admin_id`),
  KEY `rep_id` (`rep_id`),
  CONSTRAINT `admin_rep_ibfk_1` FOREIGN KEY (`admin_id`) REFERENCES `admin` (`admin_username`),
  CONSTRAINT `admin_rep_ibfk_2` FOREIGN KEY (`rep_id`) REFERENCES `customer_rep` (`rep_username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin_rep`
--

LOCK TABLES `admin_rep` WRITE;
/*!40000 ALTER TABLE `admin_rep` DISABLE KEYS */;
/*!40000 ALTER TABLE `admin_rep` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auto_bids`
--

DROP TABLE IF EXISTS `auto_bids`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auto_bids` (
  `auto_bid_id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(30) DEFAULT NULL,
  `listing_id` int DEFAULT NULL,
  `increment` decimal(10,2) DEFAULT NULL,
  `upper_limit` decimal(10,2) DEFAULT NULL,
  `active` tinyint(1) DEFAULT '1',
  `bid_id` int DEFAULT NULL,
  PRIMARY KEY (`auto_bid_id`),
  KEY `username` (`username`),
  KEY `listing_id` (`listing_id`),
  KEY `fk_auto_bids_bids` (`bid_id`),
  CONSTRAINT `auto_bids_ibfk_1` FOREIGN KEY (`username`) REFERENCES `users` (`username`),
  CONSTRAINT `auto_bids_ibfk_2` FOREIGN KEY (`listing_id`) REFERENCES `listings` (`listing_id`),
  CONSTRAINT `fk_auto_bids_bids` FOREIGN KEY (`bid_id`) REFERENCES `bids` (`bid_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auto_bids`
--

LOCK TABLES `auto_bids` WRITE;
/*!40000 ALTER TABLE `auto_bids` DISABLE KEYS */;
/*!40000 ALTER TABLE `auto_bids` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bids`
--

DROP TABLE IF EXISTS `bids`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bids` (
  `bid_id` int NOT NULL AUTO_INCREMENT,
  `price` decimal(10,2) DEFAULT NULL,
  `bid_dt` datetime DEFAULT NULL,
  PRIMARY KEY (`bid_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bids`
--

LOCK TABLES `bids` WRITE;
/*!40000 ALTER TABLE `bids` DISABLE KEYS */;
/*!40000 ALTER TABLE `bids` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bidsOn`
--

DROP TABLE IF EXISTS `bidsOn`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bidsOn` (
  `listing_id` int DEFAULT NULL,
  `bid_id` int NOT NULL,
  PRIMARY KEY (`bid_id`),
  KEY `listing_id` (`listing_id`),
  CONSTRAINT `bidson_ibfk_1` FOREIGN KEY (`listing_id`) REFERENCES `listings` (`listing_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `bidson_ibfk_2` FOREIGN KEY (`bid_id`) REFERENCES `bids` (`bid_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bidsOn`
--

LOCK TABLES `bidsOn` WRITE;
/*!40000 ALTER TABLE `bidsOn` DISABLE KEYS */;
/*!40000 ALTER TABLE `bidsOn` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer_rep`
--

DROP TABLE IF EXISTS `customer_rep`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customer_rep` (
  `rep_username` varchar(30) NOT NULL,
  `rep_password` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`rep_username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer_rep`
--

LOCK TABLES `customer_rep` WRITE;
/*!40000 ALTER TABLE `customer_rep` DISABLE KEYS */;
/*!40000 ALTER TABLE `customer_rep` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `generate`
--

DROP TABLE IF EXISTS `generate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `generate` (
  `sale_id` int NOT NULL,
  `listing_id` int DEFAULT NULL,
  PRIMARY KEY (`sale_id`),
  KEY `listing_id` (`listing_id`),
  CONSTRAINT `generate_ibfk_1` FOREIGN KEY (`sale_id`) REFERENCES `sales` (`sale_id`) ON DELETE CASCADE,
  CONSTRAINT `generate_ibfk_2` FOREIGN KEY (`listing_id`) REFERENCES `listings` (`listing_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `generate`
--

LOCK TABLES `generate` WRITE;
/*!40000 ALTER TABLE `generate` DISABLE KEYS */;
/*!40000 ALTER TABLE `generate` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `interests`
--

DROP TABLE IF EXISTS `interests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `interests` (
  `interest_id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(30) DEFAULT NULL,
  `listing_id` int DEFAULT NULL,
  PRIMARY KEY (`interest_id`),
  KEY `username` (`username`),
  KEY `listing_id` (`listing_id`),
  CONSTRAINT `interests_ibfk_1` FOREIGN KEY (`username`) REFERENCES `users` (`username`),
  CONSTRAINT `interests_ibfk_2` FOREIGN KEY (`listing_id`) REFERENCES `listings` (`listing_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `interests`
--

LOCK TABLES `interests` WRITE;
/*!40000 ALTER TABLE `interests` DISABLE KEYS */;
/*!40000 ALTER TABLE `interests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `listings`
--

DROP TABLE IF EXISTS `listings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `listings` (
  `listing_id` int NOT NULL AUTO_INCREMENT,
  `make` varchar(30) DEFAULT NULL,
  `model` varchar(30) DEFAULT NULL,
  `color` varchar(30) DEFAULT NULL,
  `year` int DEFAULT NULL,
  `initial_price` decimal(10,2) DEFAULT NULL,
  `min_sale` decimal(10,2) DEFAULT NULL,
  `date_time` datetime DEFAULT NULL,
  `open_close` int DEFAULT '0',
  PRIMARY KEY (`listing_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `listings`
--

LOCK TABLES `listings` WRITE;
/*!40000 ALTER TABLE `listings` DISABLE KEYS */;
/*!40000 ALTER TABLE `listings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `places`
--

DROP TABLE IF EXISTS `places`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `places` (
  `username` varchar(30) DEFAULT NULL,
  `bid_id` int NOT NULL,
  PRIMARY KEY (`bid_id`),
  KEY `username` (`username`),
  CONSTRAINT `places_ibfk_1` FOREIGN KEY (`username`) REFERENCES `users` (`username`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `places_ibfk_2` FOREIGN KEY (`bid_id`) REFERENCES `bids` (`bid_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `places`
--

LOCK TABLES `places` WRITE;
/*!40000 ALTER TABLE `places` DISABLE KEYS */;
/*!40000 ALTER TABLE `places` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `posts`
--

DROP TABLE IF EXISTS `posts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `posts` (
  `listing_id` int NOT NULL,
  `username` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`listing_id`),
  KEY `username` (`username`),
  CONSTRAINT `posts_ibfk_1` FOREIGN KEY (`listing_id`) REFERENCES `listings` (`listing_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `posts_ibfk_2` FOREIGN KEY (`username`) REFERENCES `users` (`username`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `posts`
--

LOCK TABLES `posts` WRITE;
/*!40000 ALTER TABLE `posts` DISABLE KEYS */;
/*!40000 ALTER TABLE `posts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qa`
--

DROP TABLE IF EXISTS `qa`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qa` (
  `qa_id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(30) DEFAULT NULL,
  `rep_username` varchar(30) DEFAULT NULL,
  `status` varchar(8) DEFAULT NULL,
  `question` varchar(500) DEFAULT NULL,
  `answer` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`qa_id`),
  KEY `username` (`username`),
  KEY `rep_username` (`rep_username`),
  CONSTRAINT `qa_ibfk_1` FOREIGN KEY (`username`) REFERENCES `users` (`username`) ON UPDATE CASCADE,
  CONSTRAINT `qa_ibfk_2` FOREIGN KEY (`rep_username`) REFERENCES `customer_rep` (`rep_username`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qa`
--

LOCK TABLES `qa` WRITE;
/*!40000 ALTER TABLE `qa` DISABLE KEYS */;
/*!40000 ALTER TABLE `qa` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sales`
--

DROP TABLE IF EXISTS `sales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sales` (
  `sale_id` int NOT NULL AUTO_INCREMENT,
  `sale_dt` datetime DEFAULT NULL,
  `amount` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`sale_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sales`
--

LOCK TABLES `sales` WRITE;
/*!40000 ALTER TABLE `sales` DISABLE KEYS */;
/*!40000 ALTER TABLE `sales` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `username` varchar(30) NOT NULL,
  `password` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-04-30 19:22:19
