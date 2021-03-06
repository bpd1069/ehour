/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


DROP TABLE IF EXISTS AUDIT;
CREATE TABLE AUDIT (
	AUDIT_ID INT(11)  NOT NULL AUTO_INCREMENT,
	USER_ID INT(11) default NULL,
	USER_FULLNAME VARCHAR(256),
	AUDIT_DATE datetime,
	PAGE VARCHAR(256),
	ACTION VARCHAR(256),
	PARAMETERS VARCHAR(1024),
	SUCCESS char(1) character set latin1 NOT NULL,
	AUDIT_ACTION_TYPE VARCHAR(32),
  PRIMARY KEY  (AUDIT_ID),
  KEY `IDX_AUDIT_DATE` (`AUDIT_DATE`),
  KEY `IDX_AUDIT_USER` (`USER_FULLNAME`),
  KEY `IDX_AUDIT_ACTION_TYPE` (`AUDIT_ACTION_TYPE`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
--
-- Table structure for table `CONFIGURATION`
--

DROP TABLE IF EXISTS `CONFIGURATION`;
CREATE TABLE `CONFIGURATION` (
  `config_key` varchar(255) NOT NULL,
  `config_value` varchar(255) default NULL,
  PRIMARY KEY  (`config_key`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `CONFIGURATION`
--

LOCK TABLES `CONFIGURATION` WRITE;
/*!40000 ALTER TABLE `CONFIGURATION` DISABLE KEYS */;
INSERT INTO `CONFIGURATION` VALUES ('initialized','false'),('completeDayHours','8'),('showTurnOver','true'),('localeLanguage','en'),('currency','Euro'),('localeCountry',NULL),('availableTranslations','en,nl,fr,it'),('mailFrom','noreply@localhost.net'),('smtpPort','25'),('mailSmtp','127.0.0.1'),('demoMode','false'),('version', '0.8.3');
/*!40000 ALTER TABLE `CONFIGURATION` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `CUSTOMER`
--

DROP TABLE IF EXISTS `CUSTOMER`;
CREATE TABLE `CUSTOMER` (
  `CUSTOMER_ID` int(11) NOT NULL auto_increment,
  `NAME` varchar(255) NOT NULL,
  `DESCRIPTION` varchar(1024) default NULL,
  `CODE` varchar(32) NOT NULL,
  `ACTIVE` char(1) NOT NULL default 'Y',
  PRIMARY KEY  (`CUSTOMER_ID`),
  UNIQUE KEY `NAME` (`NAME`,`CODE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `MAIL_LOG`
--

DROP TABLE IF EXISTS `MAIL_LOG`;
CREATE TABLE `MAIL_LOG` (
  `MAIL_LOG_ID` int(11) NOT NULL auto_increment,
  `MAIL_TYPE_ID` int(11) NOT NULL,
  `TIMESTAMP` datetime NOT NULL,
  `SUCCESS` char(1) NOT NULL,
  `TO_USER_ID` int(11) default NULL,
  `RESULT_MSG` varchar(255) default NULL,
  PRIMARY KEY  (`MAIL_LOG_ID`),
  UNIQUE KEY `MAIL_LOG_ID` (`MAIL_LOG_ID`),
  KEY `MAIL_TYPE_ID` (`MAIL_TYPE_ID`),
  KEY `TO_USER_ID` (`TO_USER_ID`),
  CONSTRAINT `MAIL_LOG_fk` FOREIGN KEY (`MAIL_TYPE_ID`) REFERENCES `MAIL_TYPE` (`MAIL_TYPE_ID`),
  CONSTRAINT `MAIL_LOG_fk1` FOREIGN KEY (`TO_USER_ID`) REFERENCES `USERS` (`USER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `MAIL_LOG_ASSIGNMENT`
--

DROP TABLE IF EXISTS `MAIL_LOG_ASSIGNMENT`;
CREATE TABLE `MAIL_LOG_ASSIGNMENT` (
  `MAIL_LOG_ID` int(11) NOT NULL,
  `PROJECT_ASSIGNMENT_ID` int(11) NOT NULL,
  `BOOKED_HOURS` float(9,3) default NULL,
  `BOOK_DATE` datetime default NULL,
  PRIMARY KEY  (`MAIL_LOG_ID`),
  UNIQUE KEY `MAIL_LOG_ID` (`MAIL_LOG_ID`),
  KEY `PROJECT_ASSIGNMENT_ID` (`PROJECT_ASSIGNMENT_ID`),
  CONSTRAINT `MAIL_LOG_ASSIGNMENT_fk` FOREIGN KEY (`MAIL_LOG_ID`) REFERENCES `MAIL_LOG` (`MAIL_LOG_ID`),
  CONSTRAINT `MAIL_LOG_ASSIGNMENT_fk1` FOREIGN KEY (`PROJECT_ASSIGNMENT_ID`) REFERENCES `PROJECT_ASSIGNMENT` (`ASSIGNMENT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `MAIL_TYPE`
--

DROP TABLE IF EXISTS `MAIL_TYPE`;
CREATE TABLE `MAIL_TYPE` (
  `MAIL_TYPE_ID` int(11) NOT NULL,
  `MAIL_TYPE` varchar(255) default NULL,
  PRIMARY KEY  (`MAIL_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `MAIL_TYPE`
--

LOCK TABLES `MAIL_TYPE` WRITE;
/*!40000 ALTER TABLE `MAIL_TYPE` DISABLE KEYS */;
INSERT INTO `MAIL_TYPE` VALUES (1,'FIXED_ALLOTTED_REACHED'),(2,'FLEX_ALLOTTED_REACHED'),(3,'FLEX_OVERRUN_REACHED');
/*!40000 ALTER TABLE `MAIL_TYPE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PROJECT`
--

DROP TABLE IF EXISTS `PROJECT`;
CREATE TABLE `PROJECT` (
  `PROJECT_ID` int(11) NOT NULL auto_increment,
  `CUSTOMER_ID` int(11) default NULL,
  `NAME` varchar(255) NOT NULL,
  `DESCRIPTION` varchar(1024) default NULL,
  `CONTACT` varchar(255) default NULL,
  `PROJECT_CODE` varchar(32) NOT NULL,
  `DEFAULT_PROJECT` char(1) NOT NULL default 'N',
  `ACTIVE` char(1) NOT NULL default 'Y',
  `BILLABLE` char(1) default 'Y',  
  `PROJECT_MANAGER` int(11) default NULL,
  PRIMARY KEY  (`PROJECT_ID`),
  KEY `CUSTOMER_ID` (`CUSTOMER_ID`),
  KEY `PROJECT_fk1` (`PROJECT_MANAGER`),
  CONSTRAINT `PROJECT_fk` FOREIGN KEY (`CUSTOMER_ID`) REFERENCES `CUSTOMER` (`CUSTOMER_ID`),
  CONSTRAINT `PROJECT_fk1` FOREIGN KEY (`PROJECT_MANAGER`) REFERENCES `USERS` (`USER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `PROJECT_ASSIGNMENT`
--

DROP TABLE IF EXISTS `PROJECT_ASSIGNMENT`;
CREATE TABLE `PROJECT_ASSIGNMENT` (
  `ASSIGNMENT_ID` int(11) NOT NULL auto_increment,
  `PROJECT_ID` int(11) NOT NULL,
  `HOURLY_RATE` float(9,3) default NULL,
  `DATE_START` date default NULL,
  `DATE_END` date default NULL,
  `ROLE` varchar(255) default NULL,
  `USER_ID` int(11) NOT NULL,
  `ACTIVE` char(1) character set latin1 NOT NULL default 'Y',
  `ASSIGNMENT_TYPE_ID` int(11) NOT NULL,
  `ALLOTTED_HOURS` float(9,3) default NULL,
  `ALLOTTED_HOURS_OVERRUN` float(9,3) default NULL,
  `NOTIFY_PM_ON_OVERRUN` char(1) NOT NULL default 'N',
  PRIMARY KEY  (`ASSIGNMENT_ID`),
  KEY `PROJECT_ID` (`PROJECT_ID`),
  KEY `USER_ID` (`USER_ID`),
  KEY `ASSIGNMENT_TYPE_ID` (`ASSIGNMENT_TYPE_ID`),
  CONSTRAINT `PROJECT_ASSIGNMENT_fk2` FOREIGN KEY (`ASSIGNMENT_TYPE_ID`) REFERENCES `PROJECT_ASSIGNMENT_TYPE` (`ASSIGNMENT_TYPE_ID`),
  CONSTRAINT `PROJECT_ASSIGNMENT_fk` FOREIGN KEY (`PROJECT_ID`) REFERENCES `PROJECT` (`PROJECT_ID`),
  CONSTRAINT `PROJECT_ASSIGNMENT_fk1` FOREIGN KEY (`USER_ID`) REFERENCES `USERS` (`USER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `PROJECT_ASSIGNMENT_TYPE`
--

DROP TABLE IF EXISTS `PROJECT_ASSIGNMENT_TYPE`;
CREATE TABLE `PROJECT_ASSIGNMENT_TYPE` (
  `ASSIGNMENT_TYPE_ID` int(11) NOT NULL,
  `ASSIGNMENT_TYPE` varchar(64) default NULL,
  PRIMARY KEY  (`ASSIGNMENT_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Dumping data for table `PROJECT_ASSIGNMENT_TYPE`
--

LOCK TABLES `PROJECT_ASSIGNMENT_TYPE` WRITE;
/*!40000 ALTER TABLE `PROJECT_ASSIGNMENT_TYPE` DISABLE KEYS */;
INSERT INTO `PROJECT_ASSIGNMENT_TYPE` VALUES (0,'DATE_TYPE'),(2,'TIME_ALLOTTED_FIXED'),(3,'TIME_ALLOTTED_FLEX');
/*!40000 ALTER TABLE `PROJECT_ASSIGNMENT_TYPE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `TIMESHEET_COMMENT`
--

DROP TABLE IF EXISTS `TIMESHEET_COMMENT`;
CREATE TABLE `TIMESHEET_COMMENT` (
  `USER_ID` int(11) NOT NULL,
  `COMMENT_DATE` date NOT NULL,
  `COMMENT` varchar(2048) default NULL,
  PRIMARY KEY  (`COMMENT_DATE`,`USER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `TIMESHEET_ENTRY`
--

DROP TABLE IF EXISTS `TIMESHEET_ENTRY`;
CREATE TABLE `TIMESHEET_ENTRY` (
  `ASSIGNMENT_ID` int(11) NOT NULL,
  `ENTRY_DATE` date NOT NULL,
  `UPDATE_DATE` TIMESTAMP,  
  `HOURS` float(9,3),
  `COMMENT` varchar(2048),
  PRIMARY KEY  (`ENTRY_DATE`,`ASSIGNMENT_ID`),
  KEY `ASSIGNMENT_ID` (`ASSIGNMENT_ID`),
  CONSTRAINT `TIMESHEET_ENTRY_fk` FOREIGN KEY (`ASSIGNMENT_ID`) REFERENCES `PROJECT_ASSIGNMENT` (`ASSIGNMENT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `USERS`
--

DROP TABLE IF EXISTS `USERS`;
CREATE TABLE `USERS` (
  `USER_ID` int(11) NOT NULL auto_increment,
  `USERNAME` varchar(64) NOT NULL,
  `PASSWORD` varchar(128) NOT NULL,
  `FIRST_NAME` varchar(64) default NULL,
  `LAST_NAME` varchar(64) NOT NULL,
  `DEPARTMENT_ID` int(11) NOT NULL,
  `EMAIL` varchar(128) default NULL,
  `SALT` int(11) default NULL,
  `ACTIVE` char(1) NOT NULL default 'Y',
  PRIMARY KEY  (`USER_ID`),
  UNIQUE KEY `USER_ID` (`USER_ID`),
  UNIQUE KEY `USERNAME` (`USERNAME`),
  UNIQUE KEY `USERNAME_ACTIVE` (`USERNAME`,`ACTIVE`),
  KEY `IDX_USERNAME_PASSWORD` (`USERNAME`,`PASSWORD`),
  KEY `ORGANISATION_ID` (`DEPARTMENT_ID`),
  CONSTRAINT `USER_fk` FOREIGN KEY (`DEPARTMENT_ID`) REFERENCES `USER_DEPARTMENT` (`DEPARTMENT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Dumping data for table `USERS`
--

LOCK TABLES `USERS` WRITE;
/*!40000 ALTER TABLE `USERS` DISABLE KEYS */;
INSERT INTO `USERS` (`USER_ID`, `USERNAME`, `PASSWORD`, `FIRST_NAME`, `LAST_NAME`, `DEPARTMENT_ID`, `EMAIL`, `ACTIVE`) VALUES (1,'admin','','eHour','Admin',1,'','Y');
/*!40000 ALTER TABLE `USERS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `USER_DEPARTMENT`
--

DROP TABLE IF EXISTS `USER_DEPARTMENT`;
CREATE TABLE `USER_DEPARTMENT` (
  `DEPARTMENT_ID` int(11) NOT NULL auto_increment,
  `NAME` varchar(512) NOT NULL,
  `CODE` varchar(64) NOT NULL,
  PRIMARY KEY  (`DEPARTMENT_ID`),
  UNIQUE KEY `DEPARTMENT_ID` (`DEPARTMENT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Dumping data for table `USER_DEPARTMENT`
--

LOCK TABLES `USER_DEPARTMENT` WRITE;
/*!40000 ALTER TABLE `USER_DEPARTMENT` DISABLE KEYS */;
INSERT INTO `USER_DEPARTMENT` (`DEPARTMENT_ID`, `NAME`, `CODE`) VALUES (1,'Internal','INT');
/*!40000 ALTER TABLE `USER_DEPARTMENT` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `USER_ROLE`
--

DROP TABLE IF EXISTS `USER_ROLE`;
CREATE TABLE `USER_ROLE` (
  `ROLE` varchar(128) NOT NULL,
  `NAME` varchar(128) NOT NULL,
  PRIMARY KEY  (`ROLE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Dumping data for table `USER_ROLE`
--

LOCK TABLES `USER_ROLE` WRITE;
/*!40000 ALTER TABLE `USER_ROLE` DISABLE KEYS */;
INSERT INTO `USER_ROLE` VALUES ('ROLE_ADMIN','Administrator'),('ROLE_CONSULTANT','Consultant'),('ROLE_PROJECTMANAGER','PM'),('ROLE_REPORT','Report role');
/*!40000 ALTER TABLE `USER_ROLE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `USER_TO_USERROLE`
--

DROP TABLE IF EXISTS `USER_TO_USERROLE`;
CREATE TABLE `USER_TO_USERROLE` (
  `ROLE` varchar(128) NOT NULL,
  `USER_ID` int(11) NOT NULL,
  PRIMARY KEY  (`ROLE`,`USER_ID`),
  KEY `ROLE` (`ROLE`),
  KEY `USER_ID` (`USER_ID`),
  CONSTRAINT `USER_TO_USERROLE_fk` FOREIGN KEY (`ROLE`) REFERENCES `USER_ROLE` (`ROLE`),
  CONSTRAINT `USER_TO_USERROLE_fk1` FOREIGN KEY (`USER_ID`) REFERENCES `USERS` (`USER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `USER_TO_USERROLE`
--

LOCK TABLES `USER_TO_USERROLE` WRITE;
/*!40000 ALTER TABLE `USER_TO_USERROLE` DISABLE KEYS */;
INSERT INTO `USER_TO_USERROLE` (`ROLE`, `USER_ID`) VALUES ('ROLE_ADMIN',1),('ROLE_REPORT',1);
/*!40000 ALTER TABLE `USER_TO_USERROLE` ENABLE KEYS */;
UNLOCK TABLES;

CREATE TABLE `CONFIGURATION_BIN` (
  `CONFIG_KEY` varchar(255) NOT NULL,
  `CONFIG_VALUE` longblob,
  `METADATA` varchar(255) default NULL,
  PRIMARY KEY  (`config_key`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2007-04-14 13:21:01

