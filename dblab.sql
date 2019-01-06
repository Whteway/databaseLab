-- MySQL dump 10.13  Distrib 8.0.13, for Win64 (x86_64)
--
-- Host: localhost    Database: dblab
-- ------------------------------------------------------
-- Server version	8.0.13

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
 SET NAMES utf8mb4 ;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `adminuser`
--

DROP TABLE IF EXISTS `adminuser`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `adminuser` (
  `adminID` varchar(20) NOT NULL,
  `password` varchar(20) NOT NULL,
  `adminname` varchar(10) DEFAULT NULL,
  `phone` varchar(11) DEFAULT NULL,
  PRIMARY KEY (`adminID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `adminuser`
--

LOCK TABLES `adminuser` WRITE;
/*!40000 ALTER TABLE `adminuser` DISABLE KEYS */;
INSERT INTO `adminuser` VALUES ('admin','admin','管理员','18888888888');
/*!40000 ALTER TABLE `adminuser` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `book`
--

DROP TABLE IF EXISTS `book`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `book` (
  `barcode` varchar(20) NOT NULL,
  `searchno` varchar(10) DEFAULT NULL,
  `position` varchar(15) DEFAULT NULL,
  `state` varchar(10) DEFAULT NULL,
  `historyborrowed` int(11) DEFAULT NULL,
  PRIMARY KEY (`barcode`),
  KEY `searchno` (`searchno`),
  CONSTRAINT `book_ibfk_1` FOREIGN KEY (`searchno`) REFERENCES `books` (`searchno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `book`
--

LOCK TABLES `book` WRITE;
/*!40000 ALTER TABLE `book` DISABLE KEYS */;
INSERT INTO `book` VALUES ('A00315367','1247:5','401借阅室','可借',5),('A00315368','1247:5','密集书库(2)','可借',5),('A00315369','1247:5','401借阅室','可借',5),('A00315370','1247:5','401借阅室','可借',5),('A00315371','1247:5','临时馆藏地2','可借',5),('A00665733','1712:45','密集书库(2)','借出',6),('A00665734','1712:45','密集书库(2)','借出',10),('A00665735','1712:45','密集书库(2)','可借',9),('A00665736','1712:45','401借阅室','可借',5),('A00682341','1247:5','密集书库(2)','可借',5),('A00830796','1245:5','401借阅室','可借',9),('A00830797','1245:5','401借阅室','非可借',9),('A00830798','1245:5','401借阅室','可借',9);
/*!40000 ALTER TABLE `book` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `books`
--

DROP TABLE IF EXISTS `books`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `books` (
  `searchno` varchar(10) NOT NULL,
  `ISBN` varchar(25) DEFAULT NULL,
  `BookName` varchar(20) NOT NULL,
  `publisher` varchar(20) DEFAULT NULL,
  `author` varchar(10) DEFAULT NULL,
  `type` varchar(20) DEFAULT NULL,
  `price` int(11) DEFAULT NULL,
  `num` int(11) DEFAULT NULL,
  PRIMARY KEY (`searchno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `books`
--

LOCK TABLES `books` WRITE;
/*!40000 ALTER TABLE `books` DISABLE KEYS */;
INSERT INTO `books` VALUES ('1245:5','978-7-5302-1018-5','平凡的世界','北京十月文艺出版社','路遥','长篇小说',88,3),('1247:5','7-5354-2730-8','狼图腾','长江文艺出版社','姜戎','长篇小说',32,6),('1712:45','7-208-06164-5','追风筝的人','上海人民出版社','卡勒德·胡塞尼','长篇小说',25,4);
/*!40000 ALTER TABLE `books` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `borrow`
--

DROP TABLE IF EXISTS `borrow`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `borrow` (
  `borrowid` int(11) NOT NULL AUTO_INCREMENT,
  `readerid` varchar(10) NOT NULL,
  `barcode` varchar(20) NOT NULL,
  `borrowdate` date DEFAULT NULL,
  `returndate` date DEFAULT NULL,
  PRIMARY KEY (`borrowid`),
  KEY `readerid` (`readerid`),
  KEY `barcode` (`barcode`),
  CONSTRAINT `borrow_ibfk_1` FOREIGN KEY (`readerid`) REFERENCES `userdetail` (`readerid`),
  CONSTRAINT `borrow_ibfk_2` FOREIGN KEY (`barcode`) REFERENCES `book` (`barcode`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `borrow`
--

LOCK TABLES `borrow` WRITE;
/*!40000 ALTER TABLE `borrow` DISABLE KEYS */;
INSERT INTO `borrow` VALUES (1,'123','A00665733','2018-12-30',NULL),(2,'456','A00665734','2018-12-30',NULL);
/*!40000 ALTER TABLE `borrow` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `user` (
  `userID` varchar(20) NOT NULL,
  `password` varchar(20) NOT NULL,
  PRIMARY KEY (`userID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES ('123','123'),('456','456'),('789','789');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `userdetail`
--

DROP TABLE IF EXISTS `userdetail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `userdetail` (
  `readerid` varchar(10) NOT NULL,
  `name` varchar(10) NOT NULL,
  `sex` varchar(10) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `phone` char(11) DEFAULT NULL,
  `IDCard` char(18) DEFAULT NULL,
  `borrowednum` int(11) DEFAULT '0',
  `maxborrow` int(11) DEFAULT '20',
  `userID` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`readerid`),
  KEY `userID` (`userID`),
  CONSTRAINT `userdetail_ibfk_1` FOREIGN KEY (`userID`) REFERENCES `user` (`userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `userdetail`
--

LOCK TABLES `userdetail` WRITE;
/*!40000 ALTER TABLE `userdetail` DISABLE KEYS */;
INSERT INTO `userdetail` VALUES ('123','张三','男','123@qq.com','13333333333','110101199801014236',1,20,'123'),('456','李四','男','456@qq.com','14444444444','110101199812122301',1,20,'456'),('789','王五','男','789@qq.com','15555555555','110101199902131425',0,20,'789');
/*!40000 ALTER TABLE `userdetail` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-01-05 21:18:58
