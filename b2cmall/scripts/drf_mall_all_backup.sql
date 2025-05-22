-- MySQL dump 10.13  Distrib 8.0.40, for Win64 (x86_64)
--
-- Host: localhost    Database: drf_mall
-- ------------------------------------------------------
-- Server version	8.0.40

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `areas_region`
--

DROP TABLE IF EXISTS `areas_region`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `areas_region` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `level` varchar(50) NOT NULL,
  `parent_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `areas_region_parent_id_1adf1e98_fk_areas_region_id` (`parent_id`),
  CONSTRAINT `areas_region_parent_id_1adf1e98_fk_areas_region_id` FOREIGN KEY (`parent_id`) REFERENCES `areas_region` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=773 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `areas_region`
--

LOCK TABLES `areas_region` WRITE;
/*!40000 ALTER TABLE `areas_region` DISABLE KEYS */;
INSERT INTO `areas_region` VALUES (1,'臺北市','city',NULL),(2,'基隆市','city',NULL),(3,'新北市','city',NULL),(4,'連江縣','city',NULL),(5,'宜蘭縣','city',NULL),(6,'釣魚臺','city',NULL),(7,'新竹市','city',NULL),(8,'新竹縣','city',NULL),(9,'桃園市','city',NULL),(10,'苗栗縣','city',NULL),(11,'臺中市','city',NULL),(12,'彰化縣','city',NULL),(13,'南投縣','city',NULL),(14,'嘉義市','city',NULL),(15,'嘉義縣','city',NULL),(16,'雲林縣','city',NULL),(17,'臺南市','city',NULL),(18,'高雄市','city',NULL),(19,'南海島','city',NULL),(20,'澎湖縣','city',NULL),(21,'金門縣','city',NULL),(22,'屏東縣','city',NULL),(23,'臺東縣','city',NULL),(24,'花蓮縣','city',NULL),(25,'中正區','district',1),(26,'大同區','district',1),(27,'中山區','district',1),(28,'松山區','district',1),(29,'大安區','district',1),(30,'萬華區','district',1),(31,'信義區','district',1),(32,'士林區','district',1),(33,'北投區','district',1),(34,'內湖區','district',1),(35,'南港區','district',1),(36,'文山區','district',1),(37,'仁愛區','district',2),(38,'信義區','district',2),(39,'中正區','district',2),(40,'中山區','district',2),(41,'安樂區','district',2),(42,'暖暖區','district',2),(43,'七堵區','district',2),(44,'萬里區','district',3),(45,'金山區','district',3),(46,'板橋區','district',3),(47,'汐止區','district',3),(48,'深坑區','district',3),(49,'石碇區','district',3),(50,'瑞芳區','district',3),(51,'平溪區','district',3),(52,'雙溪區','district',3),(53,'貢寮區','district',3),(54,'新店區','district',3),(55,'坪林區','district',3),(56,'烏來區','district',3),(57,'永和區','district',3),(58,'中和區','district',3),(59,'土城區','district',3),(60,'三峽區','district',3),(61,'樹林區','district',3),(62,'鶯歌區','district',3),(63,'三重區','district',3),(64,'新莊區','district',3),(65,'泰山區','district',3),(66,'林口區','district',3),(67,'蘆洲區','district',3),(68,'五股區','district',3),(69,'八里區','district',3),(70,'淡水區','district',3),(71,'三芝區','district',3),(72,'石門區','district',3),(73,'南竿鄉','district',4),(74,'北竿鄉','district',4),(75,'莒光鄉','district',4),(76,'東引鄉','district',4),(77,'宜蘭市','district',5),(78,'壯圍鄉','district',5),(79,'頭城鎮','district',5),(80,'礁溪鄉','district',5),(81,'員山鄉','district',5),(82,'羅東鎮','district',5),(83,'三星鄉','district',5),(84,'大同鄉','district',5),(85,'五結鄉','district',5),(86,'冬山鄉','district',5),(87,'蘇澳鎮','district',5),(88,'南澳鄉','district',5),(89,'釣魚臺','district',5),(90,'釣魚臺','district',6),(91,'東區','district',7),(92,'北區','district',7),(93,'香山區','district',7),(94,'寶山鄉','district',8),(95,'竹北市','district',8),(96,'湖口鄉','district',8),(97,'新豐鄉','district',8),(98,'新埔鎮','district',8),(99,'關西鎮','district',8),(100,'芎林鄉','district',8),(101,'竹東鎮','district',8),(102,'五峰鄉','district',8),(103,'橫山鄉','district',8),(104,'尖石鄉','district',8),(105,'北埔鄉','district',8),(106,'峨眉鄉','district',8),(107,'中壢區','district',9),(108,'平鎮區','district',9),(109,'龍潭區','district',9),(110,'楊梅區','district',9),(111,'新屋區','district',9),(112,'觀音區','district',9),(113,'桃園區','district',9),(114,'龜山區','district',9),(115,'八德區','district',9),(116,'大溪區','district',9),(117,'復興區','district',9),(118,'大園區','district',9),(119,'蘆竹區','district',9),(120,'竹南鎮','district',10),(121,'頭份市','district',10),(122,'三灣鄉','district',10),(123,'南庄鄉','district',10),(124,'獅潭鄉','district',10),(125,'後龍鎮','district',10),(126,'通霄鎮','district',10),(127,'苑裡鎮','district',10),(128,'苗栗市','district',10),(129,'造橋鄉','district',10),(130,'頭屋鄉','district',10),(131,'公館鄉','district',10),(132,'大湖鄉','district',10),(133,'泰安鄉','district',10),(134,'銅鑼鄉','district',10),(135,'三義鄉','district',10),(136,'西湖鄉','district',10),(137,'卓蘭鎮','district',10),(138,'中區','district',11),(139,'東區','district',11),(140,'南區','district',11),(141,'西區','district',11),(142,'北區','district',11),(143,'北屯區','district',11),(144,'西屯區','district',11),(145,'南屯區','district',11),(146,'太平區','district',11),(147,'大里區','district',11),(148,'霧峰區','district',11),(149,'烏日區','district',11),(150,'豐原區','district',11),(151,'后里區','district',11),(152,'石岡區','district',11),(153,'東勢區','district',11),(154,'和平區','district',11),(155,'新社區','district',11),(156,'潭子區','district',11),(157,'大雅區','district',11),(158,'神岡區','district',11),(159,'大肚區','district',11),(160,'沙鹿區','district',11),(161,'龍井區','district',11),(162,'梧棲區','district',11),(163,'清水區','district',11),(164,'大甲區','district',11),(165,'外埔區','district',11),(166,'大安區','district',11),(167,'彰化市','district',12),(168,'芬園鄉','district',12),(169,'花壇鄉','district',12),(170,'秀水鄉','district',12),(171,'鹿港鎮','district',12),(172,'福興鄉','district',12),(173,'線西鄉','district',12),(174,'和美鎮','district',12),(175,'伸港鄉','district',12),(176,'員林市','district',12),(177,'社頭鄉','district',12),(178,'永靖鄉','district',12),(179,'埔心鄉','district',12),(180,'溪湖鎮','district',12),(181,'大村鄉','district',12),(182,'埔鹽鄉','district',12),(183,'田中鎮','district',12),(184,'北斗鎮','district',12),(185,'田尾鄉','district',12),(186,'埤頭鄉','district',12),(187,'溪州鄉','district',12),(188,'竹塘鄉','district',12),(189,'二林鎮','district',12),(190,'大城鄉','district',12),(191,'芳苑鄉','district',12),(192,'二水鄉','district',12),(193,'南投市','district',13),(194,'中寮鄉','district',13),(195,'草屯鎮','district',13),(196,'國姓鄉','district',13),(197,'埔里鎮','district',13),(198,'仁愛鄉','district',13),(199,'名間鄉','district',13),(200,'集集鎮','district',13),(201,'水里鄉','district',13),(202,'魚池鄉','district',13),(203,'信義鄉','district',13),(204,'竹山鎮','district',13),(205,'鹿谷鄉','district',13),(206,'西區','district',14),(207,'東區','district',14),(208,'番路鄉','district',15),(209,'梅山鄉','district',15),(210,'竹崎鄉','district',15),(211,'阿里山鄉','district',15),(212,'中埔鄉','district',15),(213,'大埔鄉','district',15),(214,'水上鄉','district',15),(215,'鹿草鄉','district',15),(216,'太保市','district',15),(217,'朴子市','district',15),(218,'東石鄉','district',15),(219,'六腳鄉','district',15),(220,'新港鄉','district',15),(221,'民雄鄉','district',15),(222,'大林鎮','district',15),(223,'溪口鄉','district',15),(224,'義竹鄉','district',15),(225,'布袋鎮','district',15),(226,'斗南鎮','district',16),(227,'大埤鄉','district',16),(228,'虎尾鎮','district',16),(229,'土庫鎮','district',16),(230,'褒忠鄉','district',16),(231,'東勢鄉','district',16),(232,'臺西鄉','district',16),(233,'崙背鄉','district',16),(234,'麥寮鄉','district',16),(235,'斗六市','district',16),(236,'林內鄉','district',16),(237,'古坑鄉','district',16),(238,'莿桐鄉','district',16),(239,'西螺鎮','district',16),(240,'二崙鄉','district',16),(241,'北港鎮','district',16),(242,'水林鄉','district',16),(243,'口湖鄉','district',16),(244,'四湖鄉','district',16),(245,'元長鄉','district',16),(246,'中西區','district',17),(247,'東區','district',17),(248,'南區','district',17),(249,'北區','district',17),(250,'安平區','district',17),(251,'安南區','district',17),(252,'永康區','district',17),(253,'歸仁區','district',17),(254,'新化區','district',17),(255,'左鎮區','district',17),(256,'玉井區','district',17),(257,'楠西區','district',17),(258,'南化區','district',17),(259,'仁德區','district',17),(260,'關廟區','district',17),(261,'龍崎區','district',17),(262,'官田區','district',17),(263,'麻豆區','district',17),(264,'佳里區','district',17),(265,'西港區','district',17),(266,'七股區','district',17),(267,'將軍區','district',17),(268,'學甲區','district',17),(269,'北門區','district',17),(270,'新營區','district',17),(271,'後壁區','district',17),(272,'白河區','district',17),(273,'東山區','district',17),(274,'六甲區','district',17),(275,'下營區','district',17),(276,'柳營區','district',17),(277,'鹽水區','district',17),(278,'善化區','district',17),(279,'新市區','district',17),(280,'大內區','district',17),(281,'山上區','district',17),(282,'安定區','district',17),(283,'新興區','district',18),(284,'前金區','district',18),(285,'苓雅區','district',18),(286,'鹽埕區','district',18),(287,'鼓山區','district',18),(288,'旗津區','district',18),(289,'前鎮區','district',18),(290,'三民區','district',18),(291,'楠梓區','district',18),(292,'小港區','district',18),(293,'左營區','district',18),(294,'仁武區','district',18),(295,'大社區','district',18),(296,'東沙群島','district',18),(297,'南沙群島','district',18),(298,'岡山區','district',18),(299,'路竹區','district',18),(300,'阿蓮區','district',18),(301,'田寮區','district',18),(302,'燕巢區','district',18),(303,'橋頭區','district',18),(304,'梓官區','district',18),(305,'彌陀區','district',18),(306,'永安區','district',18),(307,'湖內區','district',18),(308,'鳳山區','district',18),(309,'大寮區','district',18),(310,'林園區','district',18),(311,'鳥松區','district',18),(312,'大樹區','district',18),(313,'旗山區','district',18),(314,'美濃區','district',18),(315,'六龜區','district',18),(316,'內門區','district',18),(317,'杉林區','district',18),(318,'甲仙區','district',18),(319,'桃源區','district',18),(320,'那瑪夏區','district',18),(321,'茂林區','district',18),(322,'茄萣區','district',18),(323,'東沙群島','district',19),(324,'南沙群島','district',19),(325,'馬公市','district',20),(326,'西嶼鄉','district',20),(327,'望安鄉','district',20),(328,'七美鄉','district',20),(329,'白沙鄉','district',20),(330,'湖西鄉','district',20),(331,'金沙鎮','district',21),(332,'金湖鎮','district',21),(333,'金寧鄉','district',21),(334,'金城鎮','district',21),(335,'烈嶼鄉','district',21),(336,'烏坵鄉','district',21),(337,'屏東市','district',22),(338,'三地門鄉','district',22),(339,'霧臺鄉','district',22),(340,'瑪家鄉','district',22),(341,'九如鄉','district',22),(342,'里港鄉','district',22),(343,'高樹鄉','district',22),(344,'鹽埔鄉','district',22),(345,'長治鄉','district',22),(346,'麟洛鄉','district',22),(347,'竹田鄉','district',22),(348,'內埔鄉','district',22),(349,'萬丹鄉','district',22),(350,'潮州鎮','district',22),(351,'泰武鄉','district',22),(352,'來義鄉','district',22),(353,'萬巒鄉','district',22),(354,'崁頂鄉','district',22),(355,'新埤鄉','district',22),(356,'南州鄉','district',22),(357,'林邊鄉','district',22),(358,'東港鎮','district',22),(359,'琉球鄉','district',22),(360,'佳冬鄉','district',22),(361,'新園鄉','district',22),(362,'枋寮鄉','district',22),(363,'枋山鄉','district',22),(364,'春日鄉','district',22),(365,'獅子鄉','district',22),(366,'車城鄉','district',22),(367,'牡丹鄉','district',22),(368,'恆春鎮','district',22),(369,'滿州鄉','district',22),(370,'臺東市','district',23),(371,'綠島鄉','district',23),(372,'蘭嶼鄉','district',23),(373,'延平鄉','district',23),(374,'卑南鄉','district',23),(375,'鹿野鄉','district',23),(376,'關山鎮','district',23),(377,'海端鄉','district',23),(378,'池上鄉','district',23),(379,'東河鄉','district',23),(380,'成功鎮','district',23),(381,'長濱鄉','district',23),(382,'太麻里鄉','district',23),(383,'金峰鄉','district',23),(384,'大武鄉','district',23),(385,'達仁鄉','district',23),(386,'花蓮市','district',24),(387,'新城鄉','district',24),(388,'秀林鄉','district',24),(389,'吉安鄉','district',24),(390,'壽豐鄉','district',24),(391,'鳳林鎮','district',24),(392,'光復鄉','district',24),(393,'豐濱鄉','district',24),(394,'瑞穗鄉','district',24),(395,'萬榮鄉','district',24),(396,'玉里鎮','district',24),(397,'卓溪鄉','district',24),(398,'富里鄉','district',24),(399,'100','postal_code',25),(400,'103','postal_code',26),(401,'104','postal_code',27),(402,'105','postal_code',28),(403,'106','postal_code',29),(404,'108','postal_code',30),(405,'110','postal_code',31),(406,'111','postal_code',32),(407,'112','postal_code',33),(408,'114','postal_code',34),(409,'115','postal_code',35),(410,'116','postal_code',36),(411,'200','postal_code',37),(412,'201','postal_code',38),(413,'202','postal_code',39),(414,'203','postal_code',40),(415,'204','postal_code',41),(416,'205','postal_code',42),(417,'206','postal_code',43),(418,'207','postal_code',44),(419,'208','postal_code',45),(420,'220','postal_code',46),(421,'221','postal_code',47),(422,'222','postal_code',48),(423,'223','postal_code',49),(424,'224','postal_code',50),(425,'226','postal_code',51),(426,'227','postal_code',52),(427,'228','postal_code',53),(428,'231','postal_code',54),(429,'232','postal_code',55),(430,'233','postal_code',56),(431,'234','postal_code',57),(432,'235','postal_code',58),(433,'236','postal_code',59),(434,'237','postal_code',60),(435,'238','postal_code',61),(436,'239','postal_code',62),(437,'241','postal_code',63),(438,'242','postal_code',64),(439,'243','postal_code',65),(440,'244','postal_code',66),(441,'247','postal_code',67),(442,'248','postal_code',68),(443,'249','postal_code',69),(444,'251','postal_code',70),(445,'252','postal_code',71),(446,'253','postal_code',72),(447,'209','postal_code',73),(448,'210','postal_code',74),(449,'211','postal_code',75),(450,'212','postal_code',76),(451,'260','postal_code',77),(452,'263','postal_code',78),(453,'261','postal_code',79),(454,'262','postal_code',80),(455,'264','postal_code',81),(456,'265','postal_code',82),(457,'266','postal_code',83),(458,'267','postal_code',84),(459,'268','postal_code',85),(460,'269','postal_code',86),(461,'270','postal_code',87),(462,'272','postal_code',88),(463,'290','postal_code',89),(464,'290','postal_code',90),(465,'300','postal_code',91),(466,'300','postal_code',92),(467,'300','postal_code',93),(468,'308','postal_code',94),(469,'302','postal_code',95),(470,'303','postal_code',96),(471,'304','postal_code',97),(472,'305','postal_code',98),(473,'306','postal_code',99),(474,'307','postal_code',100),(475,'310','postal_code',101),(476,'311','postal_code',102),(477,'312','postal_code',103),(478,'313','postal_code',104),(479,'314','postal_code',105),(480,'315','postal_code',106),(481,'320','postal_code',107),(482,'324','postal_code',108),(483,'325','postal_code',109),(484,'326','postal_code',110),(485,'327','postal_code',111),(486,'328','postal_code',112),(487,'330','postal_code',113),(488,'333','postal_code',114),(489,'334','postal_code',115),(490,'335','postal_code',116),(491,'336','postal_code',117),(492,'337','postal_code',118),(493,'338','postal_code',119),(494,'350','postal_code',120),(495,'351','postal_code',121),(496,'352','postal_code',122),(497,'353','postal_code',123),(498,'354','postal_code',124),(499,'356','postal_code',125),(500,'357','postal_code',126),(501,'358','postal_code',127),(502,'360','postal_code',128),(503,'361','postal_code',129),(504,'362','postal_code',130),(505,'363','postal_code',131),(506,'364','postal_code',132),(507,'365','postal_code',133),(508,'366','postal_code',134),(509,'367','postal_code',135),(510,'368','postal_code',136),(511,'369','postal_code',137),(512,'400','postal_code',138),(513,'401','postal_code',139),(514,'402','postal_code',140),(515,'403','postal_code',141),(516,'404','postal_code',142),(517,'406','postal_code',143),(518,'407','postal_code',144),(519,'408','postal_code',145),(520,'411','postal_code',146),(521,'412','postal_code',147),(522,'413','postal_code',148),(523,'414','postal_code',149),(524,'420','postal_code',150),(525,'421','postal_code',151),(526,'422','postal_code',152),(527,'423','postal_code',153),(528,'424','postal_code',154),(529,'426','postal_code',155),(530,'427','postal_code',156),(531,'428','postal_code',157),(532,'429','postal_code',158),(533,'432','postal_code',159),(534,'433','postal_code',160),(535,'434','postal_code',161),(536,'435','postal_code',162),(537,'436','postal_code',163),(538,'437','postal_code',164),(539,'438','postal_code',165),(540,'439','postal_code',166),(541,'500','postal_code',167),(542,'502','postal_code',168),(543,'503','postal_code',169),(544,'504','postal_code',170),(545,'505','postal_code',171),(546,'506','postal_code',172),(547,'507','postal_code',173),(548,'508','postal_code',174),(549,'509','postal_code',175),(550,'510','postal_code',176),(551,'511','postal_code',177),(552,'512','postal_code',178),(553,'513','postal_code',179),(554,'514','postal_code',180),(555,'515','postal_code',181),(556,'516','postal_code',182),(557,'520','postal_code',183),(558,'521','postal_code',184),(559,'522','postal_code',185),(560,'523','postal_code',186),(561,'524','postal_code',187),(562,'525','postal_code',188),(563,'526','postal_code',189),(564,'527','postal_code',190),(565,'528','postal_code',191),(566,'530','postal_code',192),(567,'540','postal_code',193),(568,'541','postal_code',194),(569,'542','postal_code',195),(570,'544','postal_code',196),(571,'545','postal_code',197),(572,'546','postal_code',198),(573,'551','postal_code',199),(574,'552','postal_code',200),(575,'553','postal_code',201),(576,'555','postal_code',202),(577,'556','postal_code',203),(578,'557','postal_code',204),(579,'558','postal_code',205),(580,'600','postal_code',206),(581,'600','postal_code',207),(582,'602','postal_code',208),(583,'603','postal_code',209),(584,'604','postal_code',210),(585,'605','postal_code',211),(586,'606','postal_code',212),(587,'607','postal_code',213),(588,'608','postal_code',214),(589,'611','postal_code',215),(590,'612','postal_code',216),(591,'613','postal_code',217),(592,'614','postal_code',218),(593,'615','postal_code',219),(594,'616','postal_code',220),(595,'621','postal_code',221),(596,'622','postal_code',222),(597,'623','postal_code',223),(598,'624','postal_code',224),(599,'625','postal_code',225),(600,'630','postal_code',226),(601,'631','postal_code',227),(602,'632','postal_code',228),(603,'633','postal_code',229),(604,'634','postal_code',230),(605,'635','postal_code',231),(606,'636','postal_code',232),(607,'637','postal_code',233),(608,'638','postal_code',234),(609,'640','postal_code',235),(610,'643','postal_code',236),(611,'646','postal_code',237),(612,'647','postal_code',238),(613,'648','postal_code',239),(614,'649','postal_code',240),(615,'651','postal_code',241),(616,'652','postal_code',242),(617,'653','postal_code',243),(618,'654','postal_code',244),(619,'655','postal_code',245),(620,'700','postal_code',246),(621,'701','postal_code',247),(622,'702','postal_code',248),(623,'704','postal_code',249),(624,'708','postal_code',250),(625,'709','postal_code',251),(626,'710','postal_code',252),(627,'711','postal_code',253),(628,'712','postal_code',254),(629,'713','postal_code',255),(630,'714','postal_code',256),(631,'715','postal_code',257),(632,'716','postal_code',258),(633,'717','postal_code',259),(634,'718','postal_code',260),(635,'719','postal_code',261),(636,'720','postal_code',262),(637,'721','postal_code',263),(638,'722','postal_code',264),(639,'723','postal_code',265),(640,'724','postal_code',266),(641,'725','postal_code',267),(642,'726','postal_code',268),(643,'727','postal_code',269),(644,'730','postal_code',270),(645,'731','postal_code',271),(646,'732','postal_code',272),(647,'733','postal_code',273),(648,'734','postal_code',274),(649,'735','postal_code',275),(650,'736','postal_code',276),(651,'737','postal_code',277),(652,'741','postal_code',278),(653,'744','postal_code',279),(654,'742','postal_code',280),(655,'743','postal_code',281),(656,'745','postal_code',282),(657,'800','postal_code',283),(658,'801','postal_code',284),(659,'802','postal_code',285),(660,'803','postal_code',286),(661,'804','postal_code',287),(662,'805','postal_code',288),(663,'806','postal_code',289),(664,'807','postal_code',290),(665,'811','postal_code',291),(666,'812','postal_code',292),(667,'813','postal_code',293),(668,'814','postal_code',294),(669,'815','postal_code',295),(670,'817','postal_code',296),(671,'819','postal_code',297),(672,'820','postal_code',298),(673,'821','postal_code',299),(674,'822','postal_code',300),(675,'823','postal_code',301),(676,'824','postal_code',302),(677,'825','postal_code',303),(678,'826','postal_code',304),(679,'827','postal_code',305),(680,'828','postal_code',306),(681,'829','postal_code',307),(682,'830','postal_code',308),(683,'831','postal_code',309),(684,'832','postal_code',310),(685,'833','postal_code',311),(686,'840','postal_code',312),(687,'842','postal_code',313),(688,'843','postal_code',314),(689,'844','postal_code',315),(690,'845','postal_code',316),(691,'846','postal_code',317),(692,'847','postal_code',318),(693,'848','postal_code',319),(694,'849','postal_code',320),(695,'851','postal_code',321),(696,'852','postal_code',322),(697,'817','postal_code',323),(698,'819','postal_code',324),(699,'880','postal_code',325),(700,'881','postal_code',326),(701,'882','postal_code',327),(702,'883','postal_code',328),(703,'884','postal_code',329),(704,'885','postal_code',330),(705,'890','postal_code',331),(706,'891','postal_code',332),(707,'892','postal_code',333),(708,'893','postal_code',334),(709,'894','postal_code',335),(710,'896','postal_code',336),(711,'900','postal_code',337),(712,'901','postal_code',338),(713,'902','postal_code',339),(714,'903','postal_code',340),(715,'904','postal_code',341),(716,'905','postal_code',342),(717,'906','postal_code',343),(718,'907','postal_code',344),(719,'908','postal_code',345),(720,'909','postal_code',346),(721,'911','postal_code',347),(722,'912','postal_code',348),(723,'913','postal_code',349),(724,'920','postal_code',350),(725,'921','postal_code',351),(726,'922','postal_code',352),(727,'923','postal_code',353),(728,'924','postal_code',354),(729,'925','postal_code',355),(730,'926','postal_code',356),(731,'927','postal_code',357),(732,'928','postal_code',358),(733,'929','postal_code',359),(734,'931','postal_code',360),(735,'932','postal_code',361),(736,'940','postal_code',362),(737,'941','postal_code',363),(738,'942','postal_code',364),(739,'943','postal_code',365),(740,'944','postal_code',366),(741,'945','postal_code',367),(742,'946','postal_code',368),(743,'947','postal_code',369),(744,'950','postal_code',370),(745,'951','postal_code',371),(746,'952','postal_code',372),(747,'953','postal_code',373),(748,'954','postal_code',374),(749,'955','postal_code',375),(750,'956','postal_code',376),(751,'957','postal_code',377),(752,'958','postal_code',378),(753,'959','postal_code',379),(754,'961','postal_code',380),(755,'962','postal_code',381),(756,'963','postal_code',382),(757,'964','postal_code',383),(758,'965','postal_code',384),(759,'966','postal_code',385),(760,'970','postal_code',386),(761,'971','postal_code',387),(762,'972','postal_code',388),(763,'973','postal_code',389),(764,'974','postal_code',390),(765,'975','postal_code',391),(766,'976','postal_code',392),(767,'977','postal_code',393),(768,'978','postal_code',394),(769,'979','postal_code',395),(770,'981','postal_code',396),(771,'982','postal_code',397),(772,'983','postal_code',398);
/*!40000 ALTER TABLE `areas_region` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group`
--

DROP TABLE IF EXISTS `auth_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group`
--

LOCK TABLES `auth_group` WRITE;
/*!40000 ALTER TABLE `auth_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group_permissions`
--

DROP TABLE IF EXISTS `auth_group_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `group_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group_permissions`
--

LOCK TABLES `auth_group_permissions` WRITE;
/*!40000 ALTER TABLE `auth_group_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_permission`
--

DROP TABLE IF EXISTS `auth_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_permission` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content_type_id` int NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=93 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_permission`
--

LOCK TABLES `auth_permission` WRITE;
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
INSERT INTO `auth_permission` VALUES (1,'Can add log entry',1,'add_logentry'),(2,'Can change log entry',1,'change_logentry'),(3,'Can delete log entry',1,'delete_logentry'),(4,'Can view log entry',1,'view_logentry'),(5,'Can add permission',2,'add_permission'),(6,'Can change permission',2,'change_permission'),(7,'Can delete permission',2,'delete_permission'),(8,'Can view permission',2,'view_permission'),(9,'Can add group',3,'add_group'),(10,'Can change group',3,'change_group'),(11,'Can delete group',3,'delete_group'),(12,'Can view group',3,'view_group'),(13,'Can add content type',4,'add_contenttype'),(14,'Can change content type',4,'change_contenttype'),(15,'Can delete content type',4,'delete_contenttype'),(16,'Can view content type',4,'view_contenttype'),(17,'Can add session',5,'add_session'),(18,'Can change session',5,'change_session'),(19,'Can delete session',5,'delete_session'),(20,'Can view session',5,'view_session'),(21,'Can add blacklisted token',6,'add_blacklistedtoken'),(22,'Can change blacklisted token',6,'change_blacklistedtoken'),(23,'Can delete blacklisted token',6,'delete_blacklistedtoken'),(24,'Can view blacklisted token',6,'view_blacklistedtoken'),(25,'Can add outstanding token',7,'add_outstandingtoken'),(26,'Can change outstanding token',7,'change_outstandingtoken'),(27,'Can delete outstanding token',7,'delete_outstandingtoken'),(28,'Can view outstanding token',7,'view_outstandingtoken'),(29,'Can add 用戶',8,'add_user'),(30,'Can change 用戶',8,'change_user'),(31,'Can delete 用戶',8,'delete_user'),(32,'Can view 用戶',8,'view_user'),(33,'Can add 用戶收件地址',9,'add_useraddress'),(34,'Can change 用戶收件地址',9,'change_useraddress'),(35,'Can delete 用戶收件地址',9,'delete_useraddress'),(36,'Can view 用戶收件地址',9,'view_useraddress'),(37,'Can add 社交帳號',10,'add_usersocialaccount'),(38,'Can change 社交帳號',10,'change_usersocialaccount'),(39,'Can delete 社交帳號',10,'delete_usersocialaccount'),(40,'Can view 社交帳號',10,'view_usersocialaccount'),(41,'Can add 台灣行政區域',11,'add_region'),(42,'Can change 台灣行政區域',11,'change_region'),(43,'Can delete 台灣行政區域',11,'delete_region'),(44,'Can view 台灣行政區域',11,'view_region'),(45,'Can add 商品',12,'add_goods'),(46,'Can change 商品',12,'change_goods'),(47,'Can delete 商品',12,'delete_goods'),(48,'Can view 商品',12,'view_goods'),(49,'Can add SKU規格',13,'add_skuspecification'),(50,'Can change SKU規格',13,'change_skuspecification'),(51,'Can delete SKU規格',13,'delete_skuspecification'),(52,'Can view SKU規格',13,'view_skuspecification'),(53,'Can add SKU圖片',14,'add_skuimage'),(54,'Can change SKU圖片',14,'change_skuimage'),(55,'Can delete SKU圖片',14,'delete_skuimage'),(56,'Can view SKU圖片',14,'view_skuimage'),(57,'Can add 商品類別',15,'add_goodscategory'),(58,'Can change 商品類別',15,'change_goodscategory'),(59,'Can delete 商品類別',15,'delete_goodscategory'),(60,'Can view 商品類別',15,'view_goodscategory'),(61,'Can add 商品頻道',16,'add_goodschannel'),(62,'Can change 商品頻道',16,'change_goodschannel'),(63,'Can delete 商品頻道',16,'delete_goodschannel'),(64,'Can view 商品頻道',16,'view_goodschannel'),(65,'Can add 商品SKU',17,'add_sku'),(66,'Can change 商品SKU',17,'change_sku'),(67,'Can delete 商品SKU',17,'delete_sku'),(68,'Can view 商品SKU',17,'view_sku'),(69,'Can add 規格選項',18,'add_specificationoption'),(70,'Can change 規格選項',18,'change_specificationoption'),(71,'Can delete 規格選項',18,'delete_specificationoption'),(72,'Can view 規格選項',18,'view_specificationoption'),(73,'Can add 品牌',19,'add_brand'),(74,'Can change 品牌',19,'change_brand'),(75,'Can delete 品牌',19,'delete_brand'),(76,'Can view 品牌',19,'view_brand'),(77,'Can add 商品規格',20,'add_goodsspecification'),(78,'Can change 商品規格',20,'change_goodsspecification'),(79,'Can delete 商品規格',20,'delete_goodsspecification'),(80,'Can view 商品規格',20,'view_goodsspecification'),(81,'Can add 廣告內容',21,'add_content'),(82,'Can change 廣告內容',21,'change_content'),(83,'Can delete 廣告內容',21,'delete_content'),(84,'Can view 廣告內容',21,'view_content'),(85,'Can add 廣告分組類',22,'add_contentcategory'),(86,'Can change 廣告分組類',22,'change_contentcategory'),(87,'Can delete 廣告分組類',22,'delete_contentcategory'),(88,'Can view 廣告分組類',22,'view_contentcategory'),(89,'Can add test',23,'add_test'),(90,'Can change test',23,'change_test'),(91,'Can delete test',23,'delete_test'),(92,'Can view test',23,'view_test');
/*!40000 ALTER TABLE `auth_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_admin_log`
--

DROP TABLE IF EXISTS `django_admin_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_admin_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint unsigned NOT NULL,
  `change_message` longtext NOT NULL,
  `content_type_id` int DEFAULT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  KEY `django_admin_log_user_id_c564eba6_fk_users_id` (`user_id`),
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_users_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `django_admin_log_chk_1` CHECK ((`action_flag` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=71 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_admin_log`
--

LOCK TABLES `django_admin_log` WRITE;
/*!40000 ALTER TABLE `django_admin_log` DISABLE KEYS */;
INSERT INTO `django_admin_log` VALUES (1,'2025-05-18 09:57:27.469242','1','Test object (1)',1,'[{\"added\": {}}]',23,3),(2,'2025-05-18 10:01:42.509378','1','Test object (1)',3,'',23,3),(3,'2025-05-18 10:14:21.485523','2','Test object (2)',1,'[{\"added\": {}}]',23,3),(4,'2025-05-18 10:14:21.493507','3','Test object (3)',1,'[{\"added\": {}}]',23,3),(5,'2025-05-18 10:20:55.447398','3','Test object (3)',3,'',23,3),(6,'2025-05-18 10:20:55.448425','2','Test object (2)',3,'',23,3),(7,'2025-05-18 10:20:55.483395','3','Test object (3)',3,'',23,3),(8,'2025-05-18 10:20:55.483395','2','Test object (2)',3,'',23,3),(9,'2025-05-18 10:21:15.502186','4','Test object (4)',1,'[{\"added\": {}}]',23,3),(10,'2025-05-18 10:21:15.517170','5','Test object (5)',1,'[{\"added\": {}}]',23,3),(11,'2025-05-18 10:34:15.288145','5','Test object (5)',3,'',23,3),(12,'2025-05-18 10:34:15.288145','4','Test object (4)',3,'',23,3),(13,'2025-05-18 10:34:25.144403','6','Test object (6)',1,'[{\"added\": {}}]',23,3),(14,'2025-05-18 10:35:07.143944','6','Test object (6)',3,'',23,3),(15,'2025-05-18 10:38:56.856484','7','Test object (7)',1,'[{\"added\": {}}]',23,3),(16,'2025-05-18 10:38:56.861352','8','Test object (8)',1,'[{\"added\": {}}]',23,3),(17,'2025-05-18 10:43:12.910935','8','Test object (8)',3,'',23,3),(18,'2025-05-18 10:43:12.910935','7','Test object (7)',3,'',23,3),(19,'2025-05-18 10:43:24.858994','9','Test object (9)',1,'[{\"added\": {}}]',23,3),(20,'2025-05-18 10:44:11.832330','10','Test object (10)',1,'[{\"added\": {}}]',23,3),(21,'2025-05-18 13:32:07.541591','11','Test object (11)',1,'[{\"added\": {}}]',23,3),(22,'2025-05-18 14:17:16.408617','11','Test object (11)',3,'',23,3),(23,'2025-05-18 14:17:16.408617','10','Test object (10)',3,'',23,3),(24,'2025-05-18 14:17:16.409575','9','Test object (9)',3,'',23,3),(25,'2025-05-18 14:17:30.224604','12','Test object (12)',1,'[{\"added\": {}}]',23,3),(26,'2025-05-19 13:14:24.302241','1','Test object (1)',1,'[{\"added\": {}}]',23,3),(27,'2025-05-20 14:27:13.840714','1','Apple',1,'[{\"added\": {}}]',19,3),(28,'2025-05-20 14:30:52.926940','2','HUAWEI',1,'[{\"added\": {}}]',19,3),(29,'2025-05-20 15:08:23.863070','1','輪播圖: 美圖M8S',2,'[{\"changed\": {\"fields\": [\"\\u5716\\u7247\"]}}]',21,3),(30,'2025-05-20 15:14:24.894311','2','輪播圖: 黑色星期五',2,'[{\"changed\": {\"fields\": [\"\\u5716\\u7247\"]}}]',21,3),(31,'2025-05-20 15:14:51.384943','3','輪播圖: 廚衛365',2,'[{\"changed\": {\"fields\": [\"\\u5716\\u7247\"]}}]',21,3),(32,'2025-05-20 15:15:01.157357','4','輪播圖: 君樂寶買一送一',2,'[{\"changed\": {\"fields\": [\"\\u5716\\u7247\"]}}]',21,3),(33,'2025-05-20 15:26:02.648582','12','頁頭廣告: 好友聯盟雙雙賺',2,'[{\"changed\": {\"fields\": [\"\\u5716\\u7247\"]}}]',21,3),(34,'2025-05-20 15:26:26.121518','14','1樓Logo: 榮耀V10',2,'[{\"changed\": {\"fields\": [\"\\u5716\\u7247\"]}}]',21,3),(35,'2025-05-20 16:02:38.939997','28','1樓時尚新品: 360手機 N6 Pro 全網通',2,'[{\"changed\": {\"fields\": [\"\\u5716\\u7247\"]}}]',21,3),(36,'2025-05-20 16:02:53.271310','29','1樓時尚新品: iPhone X',2,'[{\"changed\": {\"fields\": [\"\\u5716\\u7247\"]}}]',21,3),(37,'2025-05-20 16:03:10.117039','30','1樓時尚新品: 榮耀 暢玩7A 全網通 極光藍',2,'[{\"changed\": {\"fields\": [\"\\u5716\\u7247\"]}}]',21,3),(38,'2025-05-20 16:03:47.279385','77','2樓Logo: 小米筆記本Air',2,'[{\"changed\": {\"fields\": [\"\\u5716\\u7247\"]}}]',21,3),(39,'2025-05-20 16:04:10.564222','76','2樓暢享低價: 360電話手錶 X1Pro',2,'[{\"changed\": {\"fields\": [\"\\u5716\\u7247\"]}}]',21,3),(40,'2025-05-20 16:04:24.318359','75','2樓暢享低價: Apple Watch S3 蜂窩版',2,'[{\"changed\": {\"fields\": [\"\\u5716\\u7247\"]}}]',21,3),(41,'2025-05-20 16:04:37.708156','74','2樓暢享低價: HTC VR眼鏡',2,'[{\"changed\": {\"fields\": [\"\\u5716\\u7247\"]}}]',21,3),(42,'2025-05-20 16:04:47.033328','73','2樓暢享低價: Lenovo 星際大戰 絕地挑戰 AR眼鏡',2,'[{\"changed\": {\"fields\": [\"\\u5716\\u7247\"]}}]',21,3),(43,'2025-05-20 16:04:57.765400','72','2樓暢享低價: 360 巴迪龍兒童手錶',2,'[{\"changed\": {\"fields\": [\"\\u5716\\u7247\"]}}]',21,3),(44,'2025-05-20 16:05:07.686380','71','2樓暢享低價: 艾比格特 無線移動WIFI',2,'[{\"changed\": {\"fields\": [\"\\u5716\\u7247\"]}}]',21,3),(45,'2025-05-20 16:05:22.640142','70','2樓暢享低價: 華碩飛行堡壘五代遊戲筆電',2,'[{\"changed\": {\"fields\": [\"\\u5716\\u7247\"]}}]',21,3),(46,'2025-05-20 16:06:12.636896','69','2樓暢享低價: ThinkPad T480',2,'[{\"changed\": {\"fields\": [\"\\u5716\\u7247\"]}}]',21,3),(47,'2025-05-20 16:06:23.425509','68','2樓暢享低價: 華碩飛行堡壘五代遊戲本',2,'[{\"changed\": {\"fields\": [\"\\u5716\\u7247\"]}}]',21,3),(48,'2025-05-20 16:06:35.180819','67','2樓暢享低價: Apple iPad 平板電腦 2018款',2,'[{\"changed\": {\"fields\": [\"\\u5716\\u7247\"]}}]',21,3),(49,'2025-05-20 16:07:04.356091','66','2樓加價換購: 360記錄儀M301',2,'[{\"changed\": {\"fields\": [\"\\u5716\\u7247\"]}}]',21,3),(50,'2025-05-20 16:07:18.386123','65','2樓加價換購: ILIFE V5 智慧掃地機器人',2,'[{\"changed\": {\"fields\": [\"\\u5716\\u7247\"]}}]',21,3),(51,'2025-05-20 16:07:53.235191','64','2樓加價換購: Apple AirPods藍牙耳機',2,'[{\"changed\": {\"fields\": [\"\\u5716\\u7247\"]}}]',21,3),(52,'2025-05-20 16:08:15.782837','63','2樓加價換購: 科大訊飛 翻譯機',2,'[{\"changed\": {\"fields\": [\"\\u5716\\u7247\"]}}]',21,3),(53,'2025-05-20 16:08:16.140774','63','2樓加價換購: 科大訊飛 翻譯機',2,'[{\"changed\": {\"fields\": [\"\\u5716\\u7247\"]}}]',21,3),(54,'2025-05-20 16:08:36.299658','62','2樓加價換購: S2PGHW-521藍牙耳機',2,'[{\"changed\": {\"fields\": [\"\\u5716\\u7247\"]}}]',21,3),(55,'2025-05-20 16:09:03.195152','61','2樓加價換購: 360兒童手錶電話SE2',2,'[{\"changed\": {\"fields\": [\"\\u5716\\u7247\"]}}]',21,3),(56,'2025-05-20 16:09:13.542523','60','2樓加價換購: 裴訊智慧體脂秤S7P',2,'[{\"changed\": {\"fields\": [\"\\u5716\\u7247\"]}}]',21,3),(57,'2025-05-20 16:09:55.655332','59','2樓加價換購: Apple Watch S3 GPS版',2,'[{\"changed\": {\"fields\": [\"\\u5716\\u7247\"]}}]',21,3),(58,'2025-05-20 16:10:19.751388','59','2樓加價換購: Apple Watch S3 GPS版',2,'[{\"changed\": {\"fields\": [\"\\u5716\\u7247\"]}}]',21,3),(59,'2025-05-20 16:25:36.750150','91','3樓Logo: 水星家紡',2,'[{\"changed\": {\"fields\": [\"\\u5716\\u7247\"]}}]',21,3),(60,'2025-05-20 16:26:10.939380','91','3樓Logo: 水星家紡',2,'[{\"changed\": {\"fields\": [\"\\u5716\\u7247\"]}}]',21,3),(61,'2025-05-20 16:26:44.888116','77','2樓Logo: 小米筆記本Air',2,'[{\"changed\": {\"fields\": [\"\\u5716\\u7247\"]}}]',21,3),(62,'2025-05-20 16:26:57.287707','77','2樓Logo: 小米筆記本Air',2,'[{\"changed\": {\"fields\": [\"\\u5716\\u7247\"]}}]',21,3),(63,'2025-05-20 16:34:37.764120','105','3樓生活用品: 花仙子除濕劑',2,'[{\"changed\": {\"fields\": [\"\\u5716\\u7247\"]}}]',21,3),(64,'2025-05-20 16:34:57.609482','105','3樓生活用品: 花仙子除濕劑',2,'[{\"changed\": {\"fields\": [\"\\u5716\\u7247\"]}}]',21,3),(65,'2025-05-20 17:43:10.048110','1','Apple MacBook Pro 筆記型電腦',1,'[{\"added\": {}}]',12,3),(66,'2025-05-20 17:46:33.073809','1','Apple MacBook Pro 筆記型電腦',2,'[{\"changed\": {\"fields\": [\"\\u7522\\u54c1\\u4ecb\\u7d39\", \"\\u552e\\u5f8c\\u670d\\u52d9\"]}}]',12,3),(67,'2025-05-20 17:46:45.028363','1','Apple MacBook Pro 筆記型電腦',2,'[{\"changed\": {\"fields\": [\"\\u552e\\u5f8c\\u670d\\u52d9\"]}}]',12,3),(68,'2025-05-22 05:45:06.671519','2','Apple iPhone 8 Plus',1,'[{\"added\": {}}]',12,3),(69,'2025-05-22 05:46:53.528634','3','華為 HUAWEI P10 Plus',1,'[{\"added\": {}}]',12,3),(70,'2025-05-22 06:20:21.372344','16','16: 華為 HUAWEI P10 Plus 6GB+128GB 曜石黑 移動聯通電信4G手機 雙卡雙待',2,'[{\"changed\": {\"fields\": [\"\\u9810\\u8a2d\\u5716\\u7247\"]}}]',17,3);
/*!40000 ALTER TABLE `django_admin_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_content_type`
--

DROP TABLE IF EXISTS `django_content_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_content_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_content_type`
--

LOCK TABLES `django_content_type` WRITE;
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
INSERT INTO `django_content_type` VALUES (1,'admin','logentry'),(11,'areas','region'),(3,'auth','group'),(2,'auth','permission'),(21,'contents','content'),(22,'contents','contentcategory'),(4,'contenttypes','contenttype'),(19,'goods','brand'),(12,'goods','goods'),(15,'goods','goodscategory'),(16,'goods','goodschannel'),(20,'goods','goodsspecification'),(17,'goods','sku'),(14,'goods','skuimage'),(13,'goods','skuspecification'),(18,'goods','specificationoption'),(23,'goods','test'),(10,'oauth','usersocialaccount'),(5,'sessions','session'),(6,'token_blacklist','blacklistedtoken'),(7,'token_blacklist','outstandingtoken'),(8,'users','user'),(9,'users','useraddress');
/*!40000 ALTER TABLE `django_content_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_migrations`
--

DROP TABLE IF EXISTS `django_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_migrations` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_migrations`
--

LOCK TABLES `django_migrations` WRITE;
/*!40000 ALTER TABLE `django_migrations` DISABLE KEYS */;
INSERT INTO `django_migrations` VALUES (1,'contenttypes','0001_initial','2025-05-11 17:06:23.242396'),(2,'contenttypes','0002_remove_content_type_name','2025-05-11 17:06:23.335206'),(3,'auth','0001_initial','2025-05-11 17:06:23.705435'),(4,'auth','0002_alter_permission_name_max_length','2025-05-11 17:06:23.814443'),(5,'auth','0003_alter_user_email_max_length','2025-05-11 17:06:23.823435'),(6,'auth','0004_alter_user_username_opts','2025-05-11 17:06:23.831438'),(7,'auth','0005_alter_user_last_login_null','2025-05-11 17:06:23.840440'),(8,'auth','0006_require_contenttypes_0002','2025-05-11 17:06:23.842443'),(9,'auth','0007_alter_validators_add_error_messages','2025-05-11 17:06:23.850461'),(10,'auth','0008_alter_user_username_max_length','2025-05-11 17:06:23.864459'),(11,'auth','0009_alter_user_last_name_max_length','2025-05-11 17:06:23.872465'),(12,'auth','0010_alter_group_name_max_length','2025-05-11 17:06:23.901464'),(13,'auth','0011_update_proxy_permissions','2025-05-11 17:06:23.910613'),(14,'auth','0012_alter_user_first_name_max_length','2025-05-11 17:06:23.921612'),(15,'areas','0001_initial','2025-05-11 17:06:24.007102'),(16,'users','0001_initial','2025-05-11 17:06:24.782110'),(17,'admin','0001_initial','2025-05-11 17:06:24.944313'),(18,'admin','0002_logentry_remove_auto_add','2025-05-11 17:06:24.954355'),(19,'admin','0003_logentry_add_action_flag_choices','2025-05-11 17:06:24.963920'),(20,'oauth','0001_initial','2025-05-11 17:06:25.006429'),(21,'oauth','0002_initial','2025-05-11 17:06:25.121118'),(22,'sessions','0001_initial','2025-05-11 17:06:25.154036'),(23,'token_blacklist','0001_initial','2025-05-11 17:06:25.358264'),(24,'token_blacklist','0002_outstandingtoken_jti_hex','2025-05-11 17:06:25.406268'),(25,'token_blacklist','0003_auto_20171017_2007','2025-05-11 17:06:25.441841'),(26,'token_blacklist','0004_auto_20171017_2013','2025-05-11 17:06:25.579711'),(27,'token_blacklist','0005_remove_outstandingtoken_jti','2025-05-11 17:06:25.655863'),(28,'token_blacklist','0006_auto_20171017_2113','2025-05-11 17:06:25.697877'),(29,'token_blacklist','0007_auto_20171017_2214','2025-05-11 17:06:26.001239'),(30,'token_blacklist','0008_migrate_to_bigautofield','2025-05-11 17:06:26.327489'),(31,'token_blacklist','0010_fix_migrate_to_bigautofield','2025-05-11 17:06:26.424060'),(32,'token_blacklist','0011_linearizes_history','2025-05-11 17:06:26.428060'),(33,'token_blacklist','0012_alter_outstandingtoken_user','2025-05-11 17:06:26.444673'),(34,'users','0002_alter_useraddress_options','2025-05-12 13:32:20.748770'),(44,'contents','0001_initial','2025-05-20 14:15:15.616368'),(45,'goods','0001_initial','2025-05-20 14:15:19.060946');
/*!40000 ALTER TABLE `django_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_session`
--

DROP TABLE IF EXISTS `django_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_session`
--

LOCK TABLES `django_session` WRITE;
/*!40000 ALTER TABLE `django_session` DISABLE KEYS */;
/*!40000 ALTER TABLE `django_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oauth_usersocialaccount`
--

DROP TABLE IF EXISTS `oauth_usersocialaccount`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `oauth_usersocialaccount` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `provider` varchar(20) NOT NULL,
  `uid` varchar(255) NOT NULL,
  `email` varchar(254) DEFAULT NULL,
  `update_at` datetime(6) NOT NULL,
  `create_at` datetime(6) NOT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uid` (`uid`),
  UNIQUE KEY `oauth_usersocialaccount_user_id_provider_2d71b1ec_uniq` (`user_id`,`provider`),
  CONSTRAINT `oauth_usersocialaccount_user_id_2f00d9e1_fk_users_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oauth_usersocialaccount`
--

LOCK TABLES `oauth_usersocialaccount` WRITE;
/*!40000 ALTER TABLE `oauth_usersocialaccount` DISABLE KEYS */;
INSERT INTO `oauth_usersocialaccount` VALUES (1,'google','22af18065bd61f2dc81e6bb68309c20959f05f6058388770bb61d271fe0f8c40','a0976202920@gmail.com','2025-05-11 17:08:08.245429','2025-05-11 17:08:08.245429',1),(2,'google','761978bd72b7451688f12df7b915bf30caf9668bf54060e647c7d05af6270abc','hellendjango@gmail.com','2025-05-12 13:08:37.982279','2025-05-12 13:08:37.982279',2);
/*!40000 ALTER TABLE `oauth_usersocialaccount` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_brand`
--

DROP TABLE IF EXISTS `tb_brand`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_brand` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `create_time` datetime(6) NOT NULL,
  `update_time` datetime(6) NOT NULL,
  `name` varchar(20) NOT NULL,
  `logo` varchar(100) NOT NULL,
  `first_letter` varchar(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_brand`
--

LOCK TABLES `tb_brand` WRITE;
/*!40000 ALTER TABLE `tb_brand` DISABLE KEYS */;
INSERT INTO `tb_brand` VALUES (1,'2025-05-20 14:27:11.155323','2025-05-20 14:27:11.155323','Apple','Apple_logo_grey.svg.jpg','A'),(2,'2025-05-20 14:30:51.696884','2025-05-20 14:30:51.696884','HUAWEI','HUAWEL_LOGO.png','H');
/*!40000 ALTER TABLE `tb_brand` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_content`
--

DROP TABLE IF EXISTS `tb_content`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_content` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `create_time` datetime(6) NOT NULL,
  `update_time` datetime(6) NOT NULL,
  `title` varchar(100) NOT NULL,
  `url` varchar(300) NOT NULL,
  `image` varchar(100) DEFAULT NULL,
  `text` longtext,
  `sequence` int NOT NULL,
  `status` tinyint(1) NOT NULL,
  `category_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `tb_content_category_id_c6e5ac73_fk_tb_content_category_id` (`category_id`),
  CONSTRAINT `tb_content_category_id_c6e5ac73_fk_tb_content_category_id` FOREIGN KEY (`category_id`) REFERENCES `tb_content_category` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=124 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_content`
--

LOCK TABLES `tb_content` WRITE;
/*!40000 ALTER TABLE `tb_content` DISABLE KEYS */;
INSERT INTO `tb_content` VALUES (1,'2018-04-09 16:50:23.230734','2025-05-20 15:08:22.448347','美圖M8S','http://www.itcast.cn','slide01.jpg','',1,1,1),(2,'2018-04-09 16:51:46.173309','2025-05-20 15:14:22.863916','黑色星期五','http://www.itcast.cn','slide02.jpg','',2,1,1),(3,'2018-04-09 16:52:22.471123','2025-05-20 15:14:50.245019','廚衛365','http://www.itcast.cn','slide03.jpg','',3,1,1),(4,'2018-04-09 16:53:10.539505','2025-05-20 15:15:00.044658','君樂寶買一送一','http://www.itcast.cn','slide04.jpg','',4,1,1),(5,'2018-04-09 16:53:57.409847','2018-04-09 16:53:57.409913','i7頑石低至4199元','http://www.itcast.cn','','',1,1,2),(6,'2018-04-09 16:54:36.805870','2018-04-09 16:54:36.805912','奧克斯專場 正1匹空調1313元搶','http://www.itcast.cn','','',2,1,2),(7,'2018-04-09 16:55:37.481628','2018-04-09 16:55:37.481707','榮耀9青春版 高配 領券立減220元','http://www.itcast.cn','','',3,1,2),(8,'2018-04-09 16:55:59.644645','2018-04-09 16:55:59.644697','美多探索公益新模式','http://www.itcast.cn','','',4,1,2),(9,'2018-04-09 16:57:05.390017','2018-04-09 16:57:05.390098','冰箱洗衣機專場 套購9折','http://www.itcast.cn','','',5,1,2),(10,'2018-04-09 16:57:41.680151','2018-04-09 16:57:41.680198','超市美食家 滿188減100','http://www.itcast.cn','','',6,1,2),(11,'2018-04-09 16:58:27.074643','2018-04-09 16:58:27.074831','電競之日 電腦最高減1000元','http://www.itcast.cn','','',7,1,2),(12,'2018-04-09 16:59:36.669624','2025-05-20 15:26:01.507890','好友聯盟雙雙賺','http://www.itcast.cn','adv01.jpg','',1,1,3),(14,'2018-04-09 17:01:42.028961','2025-05-20 15:26:24.995012','榮耀V10','http://www.itcast.cn','banner01.jpg','',1,1,5),(15,'2018-04-09 17:01:56.504762','2018-04-09 17:01:56.504805','手機','http://www.itcast.cn','','',1,1,6),(16,'2018-04-09 17:02:11.330329','2018-04-09 17:02:11.330373','配件','http://www.itcast.cn','','',2,1,6),(17,'2018-04-09 17:02:27.171626','2018-04-09 17:02:27.171669','儲值','http://www.itcast.cn','','',3,1,6),(18,'2018-04-09 17:02:47.086939','2018-04-09 17:02:47.086983','優惠券','http://www.itcast.cn','','',4,1,6),(19,'2018-04-09 17:03:06.144946','2018-04-09 17:03:06.144990','榮耀手機','http://www.itcast.cn','','',1,1,7),(20,'2018-04-09 17:03:23.268285','2018-04-09 17:03:23.268333','國美手機','http://www.itcast.cn','','',2,1,7),(21,'2018-04-09 17:03:36.403398','2018-04-09 17:03:36.403463','華為手機','http://www.itcast.cn','','',3,1,7),(22,'2018-04-09 17:03:54.000395','2018-04-09 17:03:54.000460','熱銷推薦','http://www.itcast.cn','','',4,1,7),(23,'2018-04-09 17:04:12.517924','2018-04-09 17:04:12.517972','以舊換新','http://www.itcast.cn','','',5,1,7),(24,'2018-04-09 17:04:29.338056','2018-04-09 17:04:29.338132','潮3C','http://www.itcast.cn','','',6,1,7),(25,'2018-04-09 17:04:45.403852','2018-04-09 17:04:45.403917','全面屏','http://www.itcast.cn','','',7,1,7),(26,'2018-04-09 17:04:58.159270','2018-04-09 17:04:58.159321','守護寶','http://www.itcast.cn','','',8,1,7),(27,'2018-04-09 17:05:14.234438','2018-04-09 17:05:14.234482','記憶卡','http://www.itcast.cn','','',9,1,7),(28,'2018-04-10 08:51:33.422870','2025-05-20 16:02:36.886891','360手機 N6 Pro 全網通','http://www.itcast.cn','goods003.jpg','￥ 2699.00',1,1,8),(29,'2018-04-10 08:52:50.280197','2025-05-20 16:02:52.376576','iPhone X','http://www.itcast.cn','goods002.jpg','￥ 7788.00',2,1,8),(30,'2018-04-10 08:56:33.016220','2025-05-20 16:03:09.275036','榮耀 暢玩7A 全網通 極光藍','http://www.itcast.cn','goods005.jpg','￥ 749.00',3,1,8),(31,'2018-04-10 08:57:52.744863','2018-04-10 09:18:36.211831','魅藍 S6 全網通','http://www.itcast.cn','goods002.jpg','￥1199.00',4,1,8),(32,'2018-04-10 08:59:19.379261','2018-04-10 09:20:59.490599','紅米5Plus 全網通 淺藍','http://www.itcast.cn','goods002.jpg','￥1299.00',5,1,8),(33,'2018-04-10 09:19:52.078636','2018-04-10 09:21:15.251997','OPPO A1 全網通 深海藍','http://www.itcast.cn','goods002.jpg','￥1399.00',6,1,8),(34,'2018-04-10 09:20:43.322594','2018-04-10 09:21:08.660170','華為 nova3e 全網通 幻夜黑','http://www.itcast.cn','goods002.jpg','￥1999.00',7,1,8),(35,'2018-04-10 09:22:14.074590','2018-04-10 09:22:14.074656','OPPO R15 全網通 夢鏡紅','http://www.itcast.cn','goods002.jpg','￥3299.00',8,1,8),(36,'2018-04-10 09:22:52.988391','2018-04-10 09:22:52.988518','榮耀V10 全網通 標配版 沙灘金','http://www.itcast.cn','goods002.jpg','￥2499.00',9,1,8),(37,'2018-04-10 09:23:26.963050','2018-04-10 09:23:26.963128','vivo X21 異形全面屏 全網通','http://www.itcast.cn','goods002.jpg','￥3198.00',10,1,8),(38,'2018-04-10 09:29:30.877589','2018-04-10 09:29:30.877630','華為P10 全網通','http://www.itcast.cn','goods002.jpg','￥3488.00',1,1,10),(39,'2018-04-10 09:29:59.145437','2018-04-10 09:29:59.145821','小米 紅米5 全網通版','http://www.itcast.cn','goods002.jpg','￥699.00',2,1,10),(40,'2018-04-10 09:30:29.868913','2018-04-10 09:30:29.868969','魅藍 Note6 全網通公眾版','http://www.itcast.cn','goods002.jpg','￥1499.00',3,1,10),(41,'2018-04-10 09:31:07.855868','2018-04-10 09:31:07.855915','紅米5Plus 全網通','http://www.itcast.cn','goods002.jpg','￥1299.00',4,1,10),(42,'2018-04-10 09:31:42.980397','2018-04-10 09:31:42.980445','榮耀9青春版 標配版','http://www.itcast.cn','goods002.jpg','￥1099.00',5,1,10),(43,'2018-04-10 09:34:08.867671','2018-04-10 09:34:08.867712','華為 暢享8 全網通','http://www.itcast.cn','goods002.jpg','￥1299.00',6,1,10),(44,'2018-04-10 09:35:12.710916','2018-04-10 09:35:12.710989','榮耀 暢玩7X 尊享版','http://www.itcast.cn','goods002.jpg','￥1799.00',7,1,10),(45,'2018-04-10 09:35:42.251919','2018-04-10 09:35:42.251963','華為 nova3e 全網通 幻夜黑','http://www.itcast.cn','goods002.jpg','￥1999.00',8,1,10),(46,'2018-04-10 09:36:12.028644','2018-04-10 09:36:12.028685','魅族 PRO 7 Plus 全網通','http://www.itcast.cn','goods002.jpg','￥2799.00',9,1,10),(47,'2018-04-10 09:36:36.804759','2018-04-10 09:36:36.804804','三星 S8 Plus 全網通','http://www.itcast.cn','goods002.jpg','￥5499.00',10,1,10),(48,'2018-04-10 09:38:59.226650','2018-04-10 09:38:59.226695','Aogress一體雙用資料線DC-28金','http://www.itcast.cn','goods002.jpg','￥29.00',1,1,11),(49,'2018-04-10 09:39:32.483523','2018-04-10 09:39:32.483585','黑客iPhone X 鋼化膜','http://www.itcast.cn','goods002.jpg','￥29.00',2,1,11),(50,'2018-04-10 09:40:08.968290','2018-04-10 09:40:08.968367','黑客 3D曲面 全屏鋼化膜','http://www.itcast.cn','goods002.jpg','￥99.00',4,1,11),(51,'2018-04-10 09:40:40.405191','2018-04-10 09:40:40.405231','三星（SAMSUNG）儲存卡 64G','http://www.itcast.cn','goods002.jpg','￥169.00',5,1,11),(52,'2018-04-10 09:42:15.130337','2018-04-10 09:42:15.130419','浦諾菲(pivoful) PUC-15 Type-C 資料線','http://www.itcast.cn','goods002.jpg','￥19.90',6,1,11),(53,'2018-04-10 09:43:07.486074','2018-04-10 09:43:07.486118','好格(Aogress) A-100E移動電源','http://www.itcast.cn','goods002.jpg','￥99.00',7,1,11),(54,'2018-04-10 09:43:38.901332','2018-04-10 09:43:38.901374','卡士奇 儲存卡','http://www.itcast.cn','goods002.jpg','￥29.90',8,1,11),(55,'2018-04-10 09:44:39.359738','2018-04-10 09:44:39.359783','捷波朗(Jabra)OTE23 運動藍牙耳機','http://www.itcast.cn','goods002.jpg','￥299.00',9,1,11),(56,'2018-04-10 09:45:17.804328','2018-04-10 09:45:17.804368','besiterBST-0109FO強尼思','http://www.itcast.cn','goods002.jpg','￥99.00',10,1,11),(57,'2018-04-10 09:58:35.242596','2018-04-10 09:58:35.242654','小米九號平衡車','http://www.itcast.cn','goods002.jpg','加100元送小米汽車',1,1,16),(58,'2018-04-10 09:59:16.706582','2018-04-10 09:59:16.706628','小米空氣淨化器2','http://www.itcast.cn','goods002.jpg','加價10元送濾芯',2,1,16),(59,'2018-04-11 06:39:11.953183','2025-05-20 16:10:18.602064','Apple Watch S3 GPS版','http://www.itcast.cn','goods002.jpg','加1元換購藍牙耳機',3,1,16),(60,'2018-04-11 06:40:29.270078','2025-05-20 16:09:12.612025','裴訊智慧體脂秤S7P','http://www.itcast.cn','goods002.jpg','加1元換購南浮電池',4,1,16),(61,'2018-04-11 06:41:03.054344','2025-05-20 16:09:02.247129','360兒童手錶電話SE2','http://www.itcast.cn','goods002.jpg','￥169.00',5,1,16),(62,'2018-04-11 06:42:11.402524','2025-05-20 16:08:35.332051','S2PGHW-521藍牙耳機','http://www.itcast.cn','goods002.jpg','￥449.00',6,1,16),(63,'2018-04-11 06:42:47.985726','2025-05-20 16:08:15.379692','科大訊飛 翻譯機','http://www.itcast.cn','goods002.jpg','加1元換購電池',7,1,16),(64,'2018-04-11 06:43:19.285413','2025-05-20 16:07:52.131945','Apple AirPods藍牙耳機','http://www.itcast.cn','goods002.jpg','￥1288.00',8,1,16),(65,'2018-04-11 06:43:59.651504','2025-05-20 16:07:17.441281','ILIFE V5 智慧掃地機器人','http://www.itcast.cn','goods002.jpg','加1元換購充電器',9,1,16),(66,'2018-04-11 06:44:29.649982','2025-05-20 16:07:03.513132','360記錄儀M301','http://www.itcast.cn','goods002.jpg','￥319.00',10,1,16),(67,'2018-04-11 06:46:32.465443','2025-05-20 16:06:34.309109','Apple iPad 平板電腦 2018款','http://www.itcast.cn','goods002.jpg','￥2388.00',1,1,18),(68,'2018-04-11 06:47:11.689035','2025-05-20 16:06:22.555087','華碩飛行堡壘五代遊戲本','http://www.itcast.cn','goods002.jpg','￥5999.00',2,1,18),(69,'2018-04-11 06:48:08.629095','2025-05-20 16:06:11.345282','ThinkPad T480','http://www.itcast.cn','goods002.jpg','￥8399.00',3,1,18),(70,'2018-04-11 06:48:34.571822','2025-05-20 16:05:21.231218','華碩飛行堡壘五代遊戲筆電','http://www.itcast.cn','goods002.jpg','￥6299.00',4,1,18),(71,'2018-04-11 06:49:16.497815','2025-05-20 16:05:06.517379','艾比格特 無線移動WIFI','http://www.itcast.cn','goods002.jpg','￥1399.00',5,1,18),(72,'2018-04-11 06:49:49.839309','2025-05-20 16:04:56.379346','360 巴迪龍兒童手錶','http://www.itcast.cn','goods002.jpg','￥999.00',6,1,18),(73,'2018-04-11 06:50:19.092920','2025-05-20 16:04:46.214886','Lenovo 星際大戰 絕地挑戰 AR眼鏡','http://www.itcast.cn','goods002.jpg','￥1999.00',7,1,18),(74,'2018-04-11 06:50:41.252312','2025-05-20 16:04:36.275224','HTC VR眼鏡','http://www.itcast.cn','goods002.jpg','￥4299.00',8,1,18),(75,'2018-04-11 06:51:12.922333','2025-05-20 16:04:23.330044','Apple Watch S3 蜂窩版','http://www.itcast.cn','goods002.jpg','￥3188.00',9,1,18),(76,'2018-04-11 06:51:40.271373','2025-05-20 16:04:09.759038','360電話手錶 X1Pro','http://www.itcast.cn','goods001.jpg','￥1499.00',10,1,18),(77,'2018-04-11 06:53:31.774835','2025-05-20 16:26:56.203219','小米筆記本Air','http://www.itcast.cn','banner02.jpg','',1,1,13),(78,'2018-04-11 06:53:46.540973','2018-04-11 06:53:46.541041','電腦','http://www.itcast.cn','','',1,1,14),(79,'2018-04-11 06:54:00.356620','2018-04-11 06:54:00.356669','數碼','http://www.itcast.cn','','',2,1,14),(80,'2018-04-11 06:54:11.361324','2018-04-11 06:54:11.361367','配件','http://www.itcast.cn','','',3,1,14),(81,'2018-04-11 06:54:21.777505','2018-04-11 06:54:21.777549','潮電子','http://www.itcast.cn','','',4,1,14),(82,'2018-04-11 06:54:36.170021','2018-04-11 06:54:36.170082','iPad 新品','http://www.itcast.cn','','',1,1,15),(83,'2018-04-11 06:54:50.484452','2018-04-11 06:54:50.484499','限量購','http://www.itcast.cn','','',2,1,15),(84,'2018-04-11 06:55:11.333884','2018-04-11 06:55:11.333934','單眼相機','http://www.itcast.cn','','',3,1,15),(85,'2018-04-11 06:55:31.975211','2018-04-11 06:55:31.975285','智慧傢俱','http://www.itcast.cn','','',4,1,15),(86,'2018-04-11 06:55:43.070748','2018-04-11 06:55:43.070796','智慧路由器','http://www.itcast.cn','','',5,1,15),(87,'2018-04-11 06:55:57.563944','2018-04-11 06:55:57.563999','限時搶','http://www.itcast.cn','','',6,1,15),(88,'2018-04-11 06:56:14.604570','2018-04-11 06:56:14.604661','頌拓','http://www.itcast.cn','','',7,1,15),(89,'2018-04-11 06:56:25.639226','2018-04-11 06:56:25.639271','微單眼','http://www.itcast.cn','','',8,1,15),(90,'2018-04-11 06:56:34.836303','2018-04-11 06:56:34.836374','耳機','http://www.itcast.cn','','',9,1,15),(91,'2018-04-11 06:56:58.113652','2025-05-20 16:26:09.936063','水星家紡','http://www.itcast.cn','banner03.jpg','',1,1,21),(92,'2018-04-11 06:57:13.215501','2018-04-11 06:57:13.215548','家具日用','http://www.itcast.cn','','',1,1,22),(93,'2018-04-11 06:57:30.689560','2018-04-11 06:57:30.689647','家紡寢具','http://www.itcast.cn','','',2,1,22),(94,'2018-04-11 06:57:50.983438','2018-04-11 06:57:50.983481','住宅家具','http://www.itcast.cn','','',3,1,22),(95,'2018-04-11 06:58:03.324082','2018-04-11 06:58:03.324128','廚具餐飲','http://www.itcast.cn','','',1,1,23),(96,'2018-04-11 06:58:13.694750','2018-04-11 06:58:13.694795','被子','http://www.itcast.cn','','',2,1,23),(97,'2018-04-11 06:58:31.412903','2018-04-11 06:58:31.412949','實木床','http://www.itcast.cn','','',3,1,23),(98,'2018-04-11 06:58:52.598947','2018-04-11 06:58:52.598992','箭牌馬桶','http://www.itcast.cn','','',4,1,23),(99,'2018-04-11 06:59:07.562439','2018-04-11 06:59:07.562541','指紋鎖','http://www.itcast.cn','','',5,1,23),(100,'2018-04-11 06:59:24.628095','2018-04-11 06:59:24.628162','電飯煲','http://www.itcast.cn','','',6,1,23),(101,'2018-04-11 06:59:37.707050','2018-04-11 06:59:37.707098','熱水器','http://www.itcast.cn','','',7,1,23),(102,'2018-04-11 06:59:48.635658','2018-04-11 06:59:48.635707','席夢思','http://www.itcast.cn','','',8,1,23),(103,'2018-04-11 06:59:57.465653','2018-04-11 06:59:57.465696','沙發','http://www.itcast.cn','','',9,1,23),(104,'2018-04-11 07:02:03.780376','2018-04-11 07:02:03.780419','潔柔紙巾','http://www.itcast.cn','goods009.jpg','￥45.90',1,1,24),(105,'2018-04-11 07:02:46.547111','2025-05-20 16:34:56.579756','花仙子除濕劑','http://www.itcast.cn','goods009.jpg','￥19.90',2,1,24),(106,'2018-04-11 07:03:18.325791','2018-04-11 07:03:18.325869','超能洗衣液','http://www.itcast.cn','goods009.jpg','驚喜價',3,1,24),(107,'2018-04-11 07:04:04.509724','2018-04-11 07:04:04.509770','創簡坊 掃帚','http://www.itcast.cn','goods009.jpg','驚喜價',4,1,24),(108,'2018-04-11 07:04:34.799452','2018-04-11 07:04:34.799494','萬象玻璃杯','http://www.itcast.cn','goods009.jpg','爆款熱銷',5,1,24),(109,'2018-04-11 07:05:10.845016','2018-04-11 07:05:10.845072','愛麗絲收納箱','http://www.itcast.cn','goods009.jpg','￥66.00',6,1,24),(110,'2018-04-11 07:05:41.147138','2018-04-11 07:05:41.147210','塑膠袋 加厚','http://www.itcast.cn','goods009.jpg','跳樓價',7,1,24),(111,'2018-04-11 07:06:12.674584','2018-04-11 07:06:12.674634','特白惠 塑膠杯','http://www.itcast.cn','goods009.jpg','實惠價',8,1,24),(112,'2018-04-11 07:06:54.675238','2018-04-11 07:06:54.675282','Bormioli Rocco 義大利進口水果杯','http://www.itcast.cn','goods009.jpg','買一送一',9,1,24),(113,'2018-04-11 07:07:29.946108','2018-04-11 07:07:29.946151','宜興紫砂壺','http://www.itcast.cn','goods009.jpg','￥220.00',10,1,24),(114,'2018-04-11 07:09:57.168028','2018-04-11 07:09:57.168075','蘇泊爾 炒鍋','http://www.itcast.cn','goods009.jpg','￥329.00 惠',1,1,25),(115,'2018-04-11 07:10:32.939492','2018-04-11 07:10:32.939538','雙立人 多用雙刀','http://www.itcast.cn','goods009.jpg','驚喜價',2,1,25),(116,'2018-04-11 07:11:13.792342','2018-04-11 07:11:13.792386','愛仕達高壓鍋','http://www.itcast.cn','goods009.jpg','特惠價',3,1,25),(117,'2018-04-11 07:12:01.447582','2018-04-11 07:12:01.447628','維艾圓形不鏽鋼盆','http://www.itcast.cn','goods009.jpg','￥69.90',4,1,25),(118,'2018-04-11 07:12:34.001525','2018-04-11 07:12:34.001609','家栢利304不鏽鋼壁掛','http://www.itcast.cn','goods009.jpg','￥198.00',5,1,25),(119,'2018-04-11 07:13:17.630873','2018-04-11 07:13:17.630916','生物海瓷','http://www.itcast.cn','goods009.jpg','震撼價',6,1,25),(120,'2018-04-11 07:13:45.655300','2018-04-11 07:13:45.655340','實木筷','http://www.itcast.cn','goods009.jpg','買二送一',7,1,25),(121,'2018-04-11 07:14:11.876255','2018-04-11 07:14:11.876328','菜板','http://www.itcast.cn','goods009.jpg','只要￥149.00',8,1,25),(122,'2018-04-11 07:14:42.828364','2018-04-11 07:14:42.828410','刻度玻璃瓶','http://www.itcast.cn','goods009.jpg','白菜價',9,1,25),(123,'2018-04-11 07:15:11.019433','2018-04-11 07:15:11.019475','韓國進口 密封盒','http://www.itcast.cn','goods009.jpg','￥39.00',10,1,25);
/*!40000 ALTER TABLE `tb_content` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_content_category`
--

DROP TABLE IF EXISTS `tb_content_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_content_category` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `create_time` datetime(6) NOT NULL,
  `update_time` datetime(6) NOT NULL,
  `name` varchar(50) NOT NULL,
  `key` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_content_category`
--

LOCK TABLES `tb_content_category` WRITE;
/*!40000 ALTER TABLE `tb_content_category` DISABLE KEYS */;
INSERT INTO `tb_content_category` VALUES (1,'2018-04-09 16:04:47.411368','2018-04-09 16:15:26.439825','輪播圖','index_lbt'),(2,'2018-04-09 16:06:12.495372','2018-04-09 16:15:32.385060','快訊','index_kx'),(3,'2018-04-09 16:08:36.725277','2018-04-09 16:15:39.930440','頁頭廣告','index_ytgg'),(5,'2018-04-09 16:16:47.531007','2018-04-09 16:16:47.531082','1樓Logo','index_1f_logo'),(6,'2018-04-09 16:17:49.114299','2018-04-09 16:17:49.114342','1樓頻道','index_1f_pd'),(7,'2018-04-09 16:18:04.659549','2018-04-09 16:18:04.659588','1樓標籤','index_1f_bq'),(8,'2018-04-09 16:18:36.176926','2018-04-09 16:18:36.176991','1樓時尚新品','index_1f_ssxp'),(10,'2018-04-09 16:19:24.489532','2018-04-10 09:49:38.621008','1樓暢享低價','index_1f_cxdj'),(11,'2018-04-09 16:19:46.992482','2018-04-09 16:19:46.992525','1樓手機配件','index_1f_sjpj'),(13,'2018-04-09 16:20:32.331884','2018-04-09 16:20:32.331927','2樓Logo','index_2f_logo'),(14,'2018-04-09 16:20:46.334441','2018-04-09 16:20:46.334481','2樓頻道','index_2f_pd'),(15,'2018-04-09 16:21:04.265294','2018-04-09 16:21:04.265336','2樓標籤','index_2f_bq'),(16,'2018-04-09 16:21:22.869586','2018-04-10 09:51:49.310917','2樓加價換購','index_2f_jjhg'),(18,'2018-04-09 16:21:59.579570','2018-04-10 09:49:44.891002','2樓暢享低價','index_2f_cxdj'),(21,'2018-04-09 16:22:43.365608','2018-04-09 16:22:43.365653','3樓Logo','index_3f_logo'),(22,'2018-04-09 16:22:55.358798','2018-04-09 16:22:55.358856','3樓頻道','index_3f_pd'),(23,'2018-04-09 16:23:05.211747','2018-04-09 16:23:05.211785','3樓標籤','index_3f_bq'),(24,'2018-04-09 16:24:01.858753','2018-04-09 16:24:01.858803','3樓生活用品','index_3f_shyp'),(25,'2018-04-09 16:24:17.621898','2018-04-09 16:24:17.621942','3樓厨房用品','index_3f_cfyp');
/*!40000 ALTER TABLE `tb_content_category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_goods`
--

DROP TABLE IF EXISTS `tb_goods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_goods` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `create_time` datetime(6) NOT NULL,
  `update_time` datetime(6) NOT NULL,
  `name` varchar(50) NOT NULL,
  `sales` int NOT NULL,
  `comments` int NOT NULL,
  `desc_detail` longtext NOT NULL,
  `desc_pack` longtext NOT NULL,
  `desc_service` longtext NOT NULL,
  `brand_id` bigint NOT NULL,
  `category1_id` bigint NOT NULL,
  `category2_id` bigint NOT NULL,
  `category3_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `tb_goods_brand_id_5c5be571_fk_tb_brand_id` (`brand_id`),
  KEY `tb_goods_category1_id_49c4fab9_fk_tb_goods_category_id` (`category1_id`),
  KEY `tb_goods_category2_id_ea351ced_fk_tb_goods_category_id` (`category2_id`),
  KEY `tb_goods_category3_id_d3ea8415_fk_tb_goods_category_id` (`category3_id`),
  CONSTRAINT `tb_goods_brand_id_5c5be571_fk_tb_brand_id` FOREIGN KEY (`brand_id`) REFERENCES `tb_brand` (`id`),
  CONSTRAINT `tb_goods_category1_id_49c4fab9_fk_tb_goods_category_id` FOREIGN KEY (`category1_id`) REFERENCES `tb_goods_category` (`id`),
  CONSTRAINT `tb_goods_category2_id_ea351ced_fk_tb_goods_category_id` FOREIGN KEY (`category2_id`) REFERENCES `tb_goods_category` (`id`),
  CONSTRAINT `tb_goods_category3_id_d3ea8415_fk_tb_goods_category_id` FOREIGN KEY (`category3_id`) REFERENCES `tb_goods_category` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_goods`
--

LOCK TABLES `tb_goods` WRITE;
/*!40000 ALTER TABLE `tb_goods` DISABLE KEYS */;
INSERT INTO `tb_goods` VALUES (1,'2025-05-20 17:43:09.743813','2025-05-20 17:46:44.993336','Apple MacBook Pro 筆記型電腦',1,1,'<p><span style=\"color:#c0392b\"><span style=\"font-size:22px\"><strong>您最得力的助手</strong></span></span></p>\r\n\r\n<p><img src=\"https://drfmall.s3.amazonaws.com/2025/05/21/image.png\" style=\"height:630px; width:630px\" /></p>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<p><img src=\"https://drfmall.s3.amazonaws.com/2025/05/21/image.png\" style=\"height:597px; width:597px\" /></p>','<p><span style=\"font-size:48px\"><span style=\"color:#2ecc71\">包裝清單</span></span></p>\r\n\r\n<p><span style=\"font-size:22px\">電源適配器 交流電源插頭 電源線</span></p>','<p><strong>廠家服務</strong></p>\r\n\r\n<ol>\r\n	<li>\r\n	<p>Mac 電腦整機及所含附件自原始購買之日起享有 1 年保修期。主要部件享有自購買之日起 2 年保修期。</p>\r\n\r\n	<ul>\r\n		<li>\r\n		<p>Mac 台式電腦的主要部件包括：主板 (MLB)、處理器 (CPU)、內存、硬碟 (HDD/SSD)、電源和顯卡。</p>\r\n		</li>\r\n		<li>\r\n		<p>Mac 筆記本電腦的主要部件包括：主板 (MLB)、處理器 (CPU)、內存、硬碟 (HDD/SSD)、電源適配器、鍵盤和顯示屏 (LCD)。</p>\r\n		</li>\r\n		<li>\r\n		<p>可另外購買 AppleCare Protection Plan 全方位服務計劃。</p>\r\n		</li>\r\n	</ul>\r\n	</li>\r\n	<li>\r\n	<p>Mac 電腦不支持 7 天無理由退換貨，請您再三確認需求後再下單購買。如因質量問題或故障，憑廠商維修中心或特約維修點的質量檢測證明，享受以下三包服務：</p>\r\n\r\n	<ul>\r\n		<li>\r\n		<p>7 日內退貨</p>\r\n		</li>\r\n		<li>\r\n		<p>15 日內換貨</p>\r\n		</li>\r\n		<li>\r\n		<p>15 日以上在質保期內享受免費保修</p>\r\n		</li>\r\n	</ul>\r\n	</li>\r\n	<li>\r\n	<p>Apple 官方售後服務電話：400-666-8800</p>\r\n\r\n	<ul>\r\n		<li>\r\n		<p>您可以查詢本品牌在各地售後服務中心的聯絡方式與地址。</p>\r\n		</li>\r\n		<li>\r\n		<p>品牌官方網站：<a href=\"http://www.apple.com.cn/\" rel=\"noopener\" target=\"_new\">http://www.apple.com.cn/</a></p>\r\n		</li>\r\n	</ul>\r\n	</li>\r\n</ol>\r\n\r\n<p><strong>正品行貨</strong></p>\r\n\r\n<p>京東商城向您保證所售商品均為正品行貨，京東自營商品開具機打發票或電子發票。</p>\r\n\r\n<p><strong>全國聯保</strong></p>\r\n\r\n<p>憑質保證書及京東商城發票，可享受全國聯保服務（奢侈品、鐘錶除外；奢侈品、鐘錶由京東聯絡保修，享受法定三包售後服務），與您親臨商場選購的商品享受相同的質量保證。</p>\r\n\r\n<p>京東商城還為您提供具有競爭力的商品價格和運費政策，請您放心購買！</p>\r\n\r\n<p><strong>注意事項</strong></p>\r\n\r\n<p>因廠家可能在未通知的情況下更改產品包裝、產地或部分附件，本司無法保證客戶收到的商品與商城圖片、產地、附件說明完全一致。僅能確保為原廠正貨，並與市場上同類新品一致。如未及時更新，敬請見諒。</p>',1,4,45,157),(2,'2025-05-22 05:45:06.424437','2025-05-22 05:45:06.424437','Apple iPhone 8 Plus',3,1,'<p><span style=\"color:#c0392b\"><span style=\"font-size:22px\"><strong>您最得力的助手</strong></span></span></p><p><img src=\"https://drfmall.s3.amazonaws.com/2025/05/21/image.png\" style=\"height:630px; width:630px\" /></p><p>&nbsp;</p><p><img src=\"https://drfmall.s3.amazonaws.com/2025/05/21/image.png\" style=\"height:597px; width:597px\" /></p>','<p><span style=\"font-size:48px\"><span style=\"color:#2ecc71\">包裝清單</span></span></p><p><span style=\"font-size:22px\">電源適配器 交流電源插頭 電源線</spa','<p><strong>廠家服務</strong></p><ol>	<li>	<p>Mac 電腦整機及所含附件自原始購買之日起享有 1 年保修期。主要部件享有自購買之日起 2 年保修期。</p>	<ul>		<li>		<p>Mac 台式電腦的主要部件包括：主板 (MLB)、處理器 (CPU)、內存、硬碟 (HDD/SSD)、電源和顯卡。</p>		</li>		<li>		<p>Mac 筆記本電腦的主要部件包括：主板 (MLB)、處理器 (CPU)、內存、硬碟 (HDD/SSD)、電源適配器、鍵盤和顯示屏 (LCD)。</p>		</li>		<li>		<p>可另外購買 AppleCare Protection Plan 全方位服務計劃。</p>		</li>	</ul>	</li>	<li>	<p>Mac 電腦不支持 7 天無理由退換貨，請您再三確認需求後再下單購買。如因質量問題或故障，憑廠商維修中心或特約維修點的質量檢測證明，享受以下三包服務：</p>	<ul>		<li>		<p>7 日內退貨</p>		</li>		<li>		<p>15 日內換貨</p>		</li>		<li>		<p>15 日以上在質保期內享受免費保修</p>		</li>	</ul>	</li>	<li>	<p>Apple 官方售後服務電話：400-666-8800</p>	<ul>		<li>		<p>您可以查詢本品牌在各地售後服務中心的聯絡方式與地址。</p>		</li>		<li>		<p>品牌官方網站：<a href=\"http://www.apple.com.cn/\" rel=\"noopener\" target=\"_new\">http://www.apple.com.cn/</a></p>		</li>	</ul>	</li></ol><p><strong>正品行貨</strong></p><p>京東商城向您保證所售商品均為正品行貨，京東自營商品開具機打發票或電子發票。</p><p><strong>全國聯保</strong></p><p>憑質保證書及京東商城發票，可享受全國聯保服務（奢侈品、鐘錶除外；奢侈品、鐘錶由京東聯絡保修，享受法定三包售後服務），與您親臨商場選購的商品享受相同的質量保證。</p><p>京東商城還為您提供具有競爭力的商品價格和運費政策，請您放心購買！</p><p><strong>注意事項</strong></p><p>因廠家可能在未通知的情況下更改產品包裝、產地或部分附件，本司無法保證客戶收到的商品與商城圖片、產地、附件說明完全一致。僅能確保為原廠正貨，並與市場上同類新品一致。如未及時更新，敬請見諒。</p>',1,1,38,115),(3,'2025-05-22 05:46:53.455718','2025-05-22 05:46:53.456685','華為 HUAWEI P10 Plus',1,8,'<p><span style=\"color:#c0392b\"><span style=\"font-size:22px\"><strong>您最得力的助手</strong></span></span></p><p><img src=\"https://drfmall.s3.amazonaws.com/2025/05/21/image.png\" style=\"height:630px; width:630px\" /></p><p>&nbsp;</p><p><img src=\"https://drfmall.s3.amazonaws.com/2025/05/21/image.png\" style=\"height:597px; width:597px\" /></p>','<p><span style=\"font-size:48px\"><span style=\"color:#2ecc71\">包裝清單</span></span></p><p><span style=\"font-size:22px\">電源適配器 交流電源插頭 電源線</spa','<p><strong>廠家服務</strong></p><ol>	<li>	<p>Mac 電腦整機及所含附件自原始購買之日起享有 1 年保修期。主要部件享有自購買之日起 2 年保修期。</p>	<ul>		<li>		<p>Mac 台式電腦的主要部件包括：主板 (MLB)、處理器 (CPU)、內存、硬碟 (HDD/SSD)、電源和顯卡。</p>		</li>		<li>		<p>Mac 筆記本電腦的主要部件包括：主板 (MLB)、處理器 (CPU)、內存、硬碟 (HDD/SSD)、電源適配器、鍵盤和顯示屏 (LCD)。</p>		</li>		<li>		<p>可另外購買 AppleCare Protection Plan 全方位服務計劃。</p>		</li>	</ul>	</li>	<li>	<p>Mac 電腦不支持 7 天無理由退換貨，請您再三確認需求後再下單購買。如因質量問題或故障，憑廠商維修中心或特約維修點的質量檢測證明，享受以下三包服務：</p>	<ul>		<li>		<p>7 日內退貨</p>		</li>		<li>		<p>15 日內換貨</p>		</li>		<li>		<p>15 日以上在質保期內享受免費保修</p>		</li>	</ul>	</li>	<li>	<p>Apple 官方售後服務電話：400-666-8800</p>	<ul>		<li>		<p>您可以查詢本品牌在各地售後服務中心的聯絡方式與地址。</p>		</li>		<li>		<p>品牌官方網站：<a href=\"http://www.apple.com.cn/\" rel=\"noopener\" target=\"_new\">http://www.apple.com.cn/</a></p>		</li>	</ul>	</li></ol><p><strong>正品行貨</strong></p><p>京東商城向您保證所售商品均為正品行貨，京東自營商品開具機打發票或電子發票。</p><p><strong>全國聯保</strong></p><p>憑質保證書及京東商城發票，可享受全國聯保服務（奢侈品、鐘錶除外；奢侈品、鐘錶由京東聯絡保修，享受法定三包售後服務），與您親臨商場選購的商品享受相同的質量保證。</p><p>京東商城還為您提供具有競爭力的商品價格和運費政策，請您放心購買！</p><p><strong>注意事項</strong></p><p>因廠家可能在未通知的情況下更改產品包裝、產地或部分附件，本司無法保證客戶收到的商品與商城圖片、產地、附件說明完全一致。僅能確保為原廠正貨，並與市場上同類新品一致。如未及時更新，敬請見諒。</p>',2,1,38,115);
/*!40000 ALTER TABLE `tb_goods` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_goods_category`
--

DROP TABLE IF EXISTS `tb_goods_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_goods_category` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `create_time` datetime(6) NOT NULL,
  `update_time` datetime(6) NOT NULL,
  `name` varchar(10) NOT NULL,
  `parent_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `tb_goods_category_parent_id_5abc16fa_fk_tb_goods_category_id` (`parent_id`),
  CONSTRAINT `tb_goods_category_parent_id_5abc16fa_fk_tb_goods_category_id` FOREIGN KEY (`parent_id`) REFERENCES `tb_goods_category` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=556 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_goods_category`
--

LOCK TABLES `tb_goods_category` WRITE;
/*!40000 ALTER TABLE `tb_goods_category` DISABLE KEYS */;
INSERT INTO `tb_goods_category` VALUES (1,'2018-04-09 08:03:18.507741','2018-04-09 08:03:18.507787','手機',NULL),(2,'2018-04-09 08:04:06.884304','2018-04-09 08:04:06.884389','相機',NULL),(3,'2018-04-09 08:04:10.066446','2018-04-09 08:04:10.066496','數碼',NULL),(4,'2018-04-09 08:05:08.975211','2018-04-09 08:05:08.975276','電腦',NULL),(5,'2018-04-09 08:05:11.678905','2018-04-09 08:05:11.678946','辦公',NULL),(6,'2018-04-09 08:05:15.661520','2018-04-09 08:05:15.661563','家用電器',NULL),(7,'2018-04-09 08:05:31.640302','2018-04-09 08:05:31.640350','家居',NULL),(8,'2018-04-09 08:05:36.662490','2018-04-09 08:05:36.662589','傢俱',NULL),(9,'2018-04-09 08:05:48.522108','2018-04-09 08:05:48.522167','家裝',NULL),(10,'2018-04-09 08:05:51.761687','2018-04-09 08:05:51.761729','廚具',NULL),(11,'2018-04-09 08:06:00.668337','2018-04-09 08:06:00.668376','男裝',NULL),(12,'2018-04-09 08:06:03.390254','2018-04-09 08:06:03.390309','女裝',NULL),(13,'2018-04-09 08:06:06.366323','2018-04-09 08:06:06.366365','童裝',NULL),(14,'2018-04-09 08:06:11.022792','2018-04-09 08:06:11.022872','內衣',NULL),(15,'2018-04-09 08:06:39.183635','2018-04-09 08:06:39.183676','女鞋',NULL),(16,'2018-04-09 08:08:55.929149','2018-04-09 08:08:55.929221','箱包',NULL),(17,'2018-04-09 08:09:02.512577','2018-04-09 08:09:02.512622','鐘表',NULL),(18,'2018-04-09 08:09:32.381612','2018-04-09 08:09:32.381652','珠寶',NULL),(19,'2018-04-09 08:09:46.196811','2018-04-09 08:09:46.196853','男鞋',NULL),(20,'2018-04-09 08:09:50.331597','2018-04-09 08:09:50.331661','運動',NULL),(21,'2018-04-09 08:09:53.161070','2018-04-09 08:09:53.161115','戶外',NULL),(22,'2018-04-09 08:11:25.870180','2018-04-09 08:11:25.870221','房產',NULL),(23,'2018-04-09 08:11:32.357967','2018-04-09 08:11:32.358008','汽車',NULL),(24,'2018-04-09 08:11:38.193287','2018-04-09 08:11:38.193342','汽車用品',NULL),(25,'2018-04-09 08:11:43.723485','2018-04-09 08:11:43.723526','母嬰',NULL),(26,'2018-04-09 08:11:53.163455','2018-04-09 08:11:53.163509','玩具樂器',NULL),(27,'2018-04-09 08:56:04.627338','2018-04-09 08:56:04.627400','食品',NULL),(28,'2018-04-09 08:56:09.781208','2018-04-09 08:56:09.781251','酒類',NULL),(29,'2018-04-09 08:56:13.794667','2018-04-09 08:56:13.794706','生鮮',NULL),(30,'2018-04-09 08:56:16.944058','2018-04-09 08:56:16.944197','特產',NULL),(31,'2018-04-09 08:56:20.053145','2018-04-09 08:56:20.053183','圖書',NULL),(32,'2018-04-09 08:56:33.399045','2018-04-09 08:56:33.399100','音像',NULL),(33,'2018-04-09 08:56:40.072007','2018-04-09 08:56:40.072045','電子書',NULL),(34,'2018-04-09 08:56:44.456894','2018-04-09 08:56:44.456936','機票',NULL),(35,'2018-04-09 08:56:50.652838','2018-04-09 08:56:50.652918','酒店',NULL),(36,'2018-04-09 08:56:59.213818','2018-04-09 08:56:59.213867','旅遊',NULL),(37,'2018-04-09 08:57:04.589202','2018-04-09 08:57:04.589251','生活',NULL),(38,'2018-04-09 09:29:22.371056','2018-04-09 09:29:22.371100','手機通訊',1),(39,'2018-04-09 09:30:48.196806','2018-04-09 09:30:48.196857','手機配件',1),(40,'2018-04-09 09:34:17.533219','2018-04-09 09:34:17.533261','攝影攝像',2),(41,'2018-04-09 09:34:34.235105','2018-04-09 09:34:34.235143','數碼配件',3),(42,'2018-04-09 09:35:34.785967','2018-04-09 09:35:34.786010','影音娛樂',3),(43,'2018-04-09 09:35:45.307642','2018-04-09 09:35:45.307682','智能設備',3),(44,'2018-04-09 09:35:52.032395','2018-04-09 09:35:52.032460','電子教育',3),(45,'2018-04-09 09:37:07.280693','2018-04-09 09:37:07.280744','電腦整機',4),(46,'2018-04-09 09:37:18.429870','2018-04-09 09:37:18.429912','電腦配件',4),(47,'2018-04-09 09:37:28.654365','2018-04-09 09:37:28.654407','外設產品',4),(48,'2018-04-09 09:37:40.238157','2018-04-09 09:37:40.238206','辦公設備',5),(49,'2018-04-09 09:37:49.104183','2018-04-09 09:37:49.104222','文具耗材',5),(51,'2018-04-09 09:38:02.637781','2018-04-09 09:38:02.637834','空調',6),(52,'2018-04-09 09:38:07.771986','2018-04-09 09:38:07.772027','洗衣機',6),(53,'2018-04-09 09:38:12.913525','2018-04-09 09:38:12.913568','冰箱',6),(55,'2018-04-09 09:38:38.885029','2018-04-09 09:38:38.885076','生活電器',6),(56,'2018-04-09 09:40:41.787484','2018-04-09 09:40:41.787552','生活日用',7),(57,'2018-04-09 09:41:13.610650','2018-04-09 09:41:13.610693','家紡',7),(58,'2018-04-09 09:41:29.602616','2018-04-09 09:41:29.602671','燈具',8),(59,'2018-04-09 09:41:36.701091','2018-04-09 09:41:36.701133','傢俱',8),(60,'2018-04-09 09:42:05.085107','2018-04-09 09:42:05.085176','家裝軟飾',9),(61,'2018-04-09 09:42:14.306983','2018-04-09 09:42:14.307046','家裝主材',9),(62,'2018-04-09 09:42:27.065822','2018-04-09 09:42:27.065865','五金電工',9),(63,'2018-04-09 09:42:33.681358','2018-04-09 09:42:33.681419','廚具',10),(64,'2018-04-09 09:42:44.381715','2018-04-09 09:42:44.381761','廚房衛浴',10),(65,'2018-04-09 09:43:11.880846','2018-04-09 09:43:11.880932','男裝',11),(66,'2018-04-09 09:43:20.531461','2018-04-09 09:43:20.531505','女裝',12),(67,'2018-04-09 09:43:32.392066','2018-04-09 09:43:32.392117','童裝',13),(68,'2018-04-09 09:43:43.728460','2018-04-09 09:43:43.728501','童鞋',13),(69,'2018-04-09 09:43:52.886429','2018-04-09 09:43:52.886473','內衣',14),(70,'2018-04-09 09:44:48.786459','2018-04-09 09:44:48.786505','配飾',14),(71,'2018-04-09 09:45:52.322960','2018-04-09 09:45:52.323019','時尚女鞋',15),(72,'2018-04-09 09:46:13.344472','2018-04-09 09:46:13.344512','潮流女包',16),(73,'2018-04-09 09:46:26.135392','2018-04-09 09:46:26.135450','精品男包',16),(74,'2018-04-09 09:46:32.838944','2018-04-09 09:46:32.838985','功能箱包',16),(75,'2018-04-09 09:46:46.934480','2018-04-09 09:46:46.934544','鐘表',17),(76,'2018-04-09 09:47:06.012737','2018-04-09 09:47:06.012780','珠寶首飾',18),(77,'2018-04-09 09:49:49.168425','2018-04-09 09:49:49.168465','流行男鞋',19),(78,'2018-04-09 09:49:59.855801','2018-04-09 09:49:59.855840','運動鞋包',20),(79,'2018-04-09 09:50:11.153031','2018-04-09 09:50:11.153072','運動服飾',20),(80,'2018-04-09 09:50:25.907804','2018-04-09 09:50:25.907850','健身訓練',20),(81,'2018-04-09 09:50:44.505123','2018-04-09 09:50:44.505169','騎行運動',20),(82,'2018-04-09 09:50:52.703445','2018-04-09 09:50:52.703485','體育用品',20),(83,'2018-04-09 09:51:03.497014','2018-04-09 09:51:03.497061','戶外鞋服',21),(84,'2018-04-09 09:51:23.359440','2018-04-09 09:51:23.359483','戶外裝備',21),(85,'2018-04-09 09:51:51.629105','2018-04-09 09:51:51.629160','房產',22),(86,'2018-04-09 09:52:55.706995','2018-04-09 09:52:55.707037','汽車車型',23),(87,'2018-04-09 09:53:17.292113','2018-04-09 09:53:17.292164','維修保養',23),(88,'2018-04-09 09:53:27.099413','2018-04-09 09:53:27.099455','汽車裝飾',24),(89,'2018-04-09 09:53:35.047364','2018-04-09 09:53:35.047410','車載電器',24),(90,'2018-04-09 09:53:47.657176','2018-04-09 09:53:47.657269','安全自駕',24),(91,'2018-04-09 09:54:40.431814','2018-04-09 09:54:40.431856','奶粉',25),(92,'2018-04-09 09:55:00.705824','2018-04-09 09:55:00.705930','營養輔食',25),(93,'2018-04-09 09:55:31.822948','2018-04-09 09:55:31.822990','尿褲濕斤',25),(94,'2018-04-09 09:55:53.206682','2018-04-09 09:55:53.206725','玩具',26),(95,'2018-04-09 09:55:59.998048','2018-04-09 09:55:59.998088','樂器',26),(96,'2018-04-09 09:56:37.026947','2018-04-09 09:56:37.026990','新鮮水果',27),(97,'2018-04-09 09:56:47.145970','2018-04-09 09:56:47.146014','蔬菜蛋品',27),(98,'2018-04-09 09:57:06.761066','2018-04-09 09:57:06.761109','精選肉類',27),(99,'2018-04-09 09:57:18.402356','2018-04-09 09:57:18.402429','中外名酒',28),(100,'2018-04-09 09:57:32.278070','2018-04-09 09:57:32.278132','海鮮水產',29),(101,'2018-04-09 09:57:55.205251','2018-04-09 09:57:55.205317','冷飲凍食',29),(102,'2018-04-09 09:58:08.325159','2018-04-09 09:58:08.325199','地方特產',30),(103,'2018-04-09 09:59:23.347674','2018-04-09 09:59:23.347716','少兒',31),(104,'2018-04-09 09:59:41.251268','2018-04-09 09:59:41.251307','教育',31),(105,'2018-04-09 09:59:47.532578','2018-04-09 09:59:47.532627','文藝',31),(106,'2018-04-09 10:00:07.689899','2018-04-09 10:00:07.689986','音像',32),(107,'2018-04-09 10:00:15.146903','2018-04-09 10:00:15.146943','電子書',33),(108,'2018-04-09 10:00:24.463854','2018-04-09 10:00:24.463893','科技',31),(109,'2018-04-09 10:01:04.222035','2018-04-09 10:01:04.222085','交通出行',34),(110,'2018-04-09 10:01:26.371711','2018-04-09 10:01:26.371761','酒店預訂',35),(111,'2018-04-09 10:01:38.237549','2018-04-09 10:01:38.237624','旅遊度假',36),(112,'2018-04-09 10:01:54.257150','2018-04-09 10:01:54.257190','演出票務',37),(113,'2018-04-09 10:02:04.652269','2018-04-09 10:02:04.652320','生活繳費',37),(114,'2018-04-09 10:02:12.979008','2018-04-09 10:02:12.979053','生活服務',37),(115,'2018-04-09 10:03:27.799903','2018-04-09 10:03:27.799952','手機',38),(116,'2018-04-09 10:03:36.651429','2018-04-09 10:03:36.651502','遊戲手機',38),(117,'2018-04-09 10:03:50.946486','2018-04-09 10:03:50.946530','老人機',38),(118,'2018-04-09 10:04:03.363153','2018-04-09 10:04:03.363464','對講機',38),(119,'2018-04-09 10:04:29.550363','2018-04-09 10:04:29.550406','手機殼',39),(120,'2018-04-09 10:04:40.174739','2018-04-09 10:04:40.174807','貼膜',39),(121,'2018-04-09 10:04:49.015076','2018-04-09 10:04:49.015119','手機存儲卡',39),(122,'2018-04-09 10:04:55.274758','2018-04-09 10:04:55.274991','資料線',39),(123,'2018-04-09 10:05:01.247210','2018-04-09 10:05:01.247253','充電器',39),(124,'2018-04-09 10:05:08.572487','2018-04-09 10:05:08.572568','無線充電器',39),(125,'2018-04-09 10:05:15.548216','2018-04-09 10:05:15.548283','手機耳機',39),(126,'2018-04-09 10:05:24.038601','2018-04-09 10:05:24.038668','移動電源',39),(127,'2018-04-09 10:05:33.149296','2018-04-09 10:05:33.149367','手機支架',39),(128,'2018-04-09 10:05:43.691569','2018-04-09 10:05:43.691625','數碼相機',40),(129,'2018-04-09 10:06:02.872228','2018-04-09 10:06:02.872272','微單相機',40),(130,'2018-04-09 10:06:12.120240','2018-04-09 10:06:12.120292','單反相機',40),(131,'2018-04-09 10:06:24.655699','2018-04-09 10:06:24.655738','拍立得',40),(132,'2018-04-09 10:06:32.889706','2018-04-09 10:06:32.889745','運動相機',40),(133,'2018-04-09 10:06:40.857296','2018-04-09 10:06:40.857348','攝像機',40),(134,'2018-04-09 10:06:47.823916','2018-04-09 10:06:47.823964','鏡頭',40),(135,'2018-04-09 10:06:59.148589','2018-04-09 10:06:59.148671','數碼相框',40),(136,'2018-04-09 10:07:12.634274','2018-04-09 10:07:12.634339','存儲卡',41),(137,'2018-04-09 10:07:21.818264','2018-04-09 10:07:21.818310','三腳架',41),(138,'2018-04-09 10:07:47.797150','2018-04-09 10:07:47.797241','閃光燈',41),(139,'2018-04-09 10:08:05.025411','2018-04-09 10:08:05.025455','電池充電器',41),(140,'2018-04-09 10:08:14.509554','2018-04-09 10:08:14.509593','讀卡器',41),(141,'2018-04-09 10:08:27.331909','2018-04-09 10:08:27.332059','耳機耳麥',42),(142,'2018-04-09 10:08:39.528114','2018-04-09 10:08:39.528322','音箱音響',42),(143,'2018-04-09 10:08:55.509999','2018-04-09 10:08:55.510276','智能音箱',42),(144,'2018-04-09 10:09:04.503537','2018-04-09 10:09:04.503583','收音機',42),(145,'2018-04-09 10:09:15.076932','2018-04-09 10:09:15.077010','麥克風',42),(146,'2018-04-09 10:09:29.493302','2018-04-09 10:09:29.493374','專業音頻',42),(147,'2018-04-09 10:09:38.404834','2018-04-09 10:09:38.404878','智能手環',43),(148,'2018-04-09 10:09:47.213524','2018-04-09 10:09:47.213567','智能手表',43),(149,'2018-04-09 10:10:04.097229','2018-04-09 10:10:04.097339','智能眼鏡',43),(150,'2018-04-09 10:10:10.770129','2018-04-09 10:10:10.770173','智能機器人',43),(151,'2018-04-09 10:10:32.247134','2018-04-09 10:10:32.247204','健康監測',43),(152,'2018-04-09 10:10:47.727920','2018-04-09 10:10:47.727987','學生平板',44),(153,'2018-04-09 10:11:01.757694','2018-04-09 10:11:01.757734','點讀機',44),(154,'2018-04-09 10:11:46.678814','2018-04-09 10:11:46.678857','早教益智',44),(155,'2018-04-09 10:12:00.019422','2018-04-09 10:12:00.019466','電紙書',44),(156,'2018-04-09 10:12:08.762703','2018-04-09 10:12:08.762746','電子詞典',44),(157,'2018-04-09 10:12:54.929293','2018-04-09 10:12:54.929354','筆記型電腦',45),(158,'2018-04-09 10:13:12.992620','2018-04-09 10:13:12.992705','遊戲本',45),(159,'2018-04-09 10:13:21.687276','2018-04-09 10:13:21.687320','平板電腦',45),(160,'2018-04-09 10:13:41.221773','2018-04-09 10:13:41.221816','台式機',45),(161,'2018-04-09 10:13:51.268043','2018-04-09 10:13:51.268533','一體機',45),(162,'2018-04-09 10:14:07.305384','2018-04-09 10:14:07.305465','工作站',45),(163,'2018-04-09 10:16:57.458227','2018-04-09 10:16:57.458275','顯示器',46),(164,'2018-04-09 10:17:08.245240','2018-04-09 10:17:08.245285','CPU',46),(165,'2018-04-09 10:17:15.241497','2018-04-09 10:17:15.241614','主板',46),(166,'2018-04-09 10:17:25.695159','2018-04-09 10:17:25.695207','顯卡',46),(167,'2018-04-09 10:17:35.032649','2018-04-09 10:17:35.032696','硬盤',46),(168,'2018-04-09 10:17:42.230729','2018-04-09 10:17:42.230770','內存',46),(169,'2018-04-09 10:17:50.016675','2018-04-09 10:17:50.016722','機箱',46),(170,'2018-04-09 10:17:55.578428','2018-04-09 10:17:55.578482','電源',46),(171,'2018-04-09 10:18:05.104997','2018-04-09 10:18:05.105038','散熱器',46),(172,'2018-04-09 10:18:18.113135','2018-04-09 10:18:18.113185','鼠標',47),(173,'2018-04-09 10:18:26.352592','2018-04-09 10:18:26.352654','鍵盤',47),(174,'2018-04-09 10:18:45.584707','2018-04-09 10:18:45.584746','鍵鼠套裝',47),(175,'2018-04-09 10:18:54.592085','2018-04-09 10:18:54.592146','U盤',47),(176,'2018-04-09 10:19:02.774592','2018-04-09 10:19:02.774644','移動硬盤',47),(177,'2018-04-09 10:19:29.344648','2018-04-09 10:19:29.344688','鼠標墊',47),(178,'2018-04-09 10:20:01.647599','2018-04-09 10:20:01.647652','攝像頭',47),(179,'2018-04-09 10:20:10.633329','2018-04-09 10:20:10.633371','線纜',47),(180,'2018-04-09 10:20:29.108708','2018-04-09 10:20:29.108750','手寫板',47),(181,'2018-04-09 10:20:50.965054','2018-04-09 10:20:50.965110','投影機',48),(182,'2018-04-09 10:21:11.973042','2018-04-09 10:21:11.973085','投影配件',48),(183,'2018-04-09 10:28:38.875264','2018-04-09 10:28:38.875323','多功能一體機',48),(184,'2018-04-09 10:28:58.044119','2018-04-09 10:28:58.044161','打印機',48),(185,'2018-04-09 10:29:24.286741','2018-04-09 10:29:24.286786','硒鼓墨粉',49),(186,'2018-04-09 10:29:32.433762','2018-04-09 10:29:32.433832','墨盒',49),(187,'2018-04-09 10:29:40.185494','2018-04-09 10:29:40.185535','色帶',49),(188,'2018-04-09 10:29:51.285563','2018-04-09 10:29:51.285630','紙類',49),(189,'2018-04-09 10:30:02.125287','2018-04-09 10:30:02.125326','辦公文具',49),(190,'2018-04-09 10:30:13.747314','2018-04-09 10:30:13.747366','文件收納',49),(191,'2018-04-09 10:30:25.486463','2018-04-09 10:30:25.486503','計算器',49),(192,'2018-04-09 10:30:33.569198','2018-04-09 10:30:33.569262','筆類',49),(197,'2018-04-09 10:31:30.282436','2018-04-09 10:31:30.282480','壁掛式空調',51),(198,'2018-04-09 10:31:46.070209','2018-04-09 10:31:46.070256','櫃式空調',51),(199,'2018-04-09 10:31:53.705108','2018-04-09 10:31:53.705152','中央空調',51),(200,'2018-04-09 10:32:02.828470','2018-04-09 10:32:02.828512','節能空調',51),(201,'2018-04-09 10:32:10.699372','2018-04-09 10:32:10.699438','智能空調',51),(202,'2018-04-09 10:32:21.537627','2018-04-09 10:32:21.537671','滾筒洗衣機',52),(203,'2018-04-09 10:32:40.271821','2018-04-09 10:32:40.271865','洗烘一體機',52),(204,'2018-04-09 10:33:07.290966','2018-04-09 10:33:07.291127','波輪洗衣機',52),(205,'2018-04-09 10:33:17.913196','2018-04-09 10:33:17.913237','迷你洗衣機',52),(206,'2018-04-09 10:33:30.617336','2018-04-09 10:33:30.617428','多門',53),(207,'2018-04-09 10:35:16.138738','2018-04-09 10:35:16.138781','對開門',53),(208,'2018-04-09 10:35:27.196414','2018-04-09 10:35:27.196483','三門',53),(209,'2018-04-09 10:35:35.870793','2018-04-09 10:35:35.870876','雙門',53),(215,'2018-04-09 10:44:09.292409','2018-04-09 10:44:09.292481','空氣凈化器',55),(216,'2018-04-09 10:44:21.773107','2018-04-09 10:44:21.773185','電風扇',55),(217,'2018-04-09 10:44:30.623621','2018-04-09 10:44:30.623668','掃地機器人',55),(218,'2018-04-09 10:44:47.127513','2018-04-09 10:44:47.127554','拖地機',55),(219,'2018-04-09 10:44:57.367766','2018-04-09 10:44:57.367812','幹衣機',55),(220,'2018-04-09 10:45:05.140806','2018-04-09 10:45:05.140845','電話機',55),(221,'2018-04-09 10:45:43.383869','2018-04-09 10:45:43.383911','收納用品',56),(222,'2018-04-09 10:45:55.997898','2018-04-09 10:45:55.997945','雨傘雨具',56),(223,'2018-04-09 10:46:11.700313','2018-04-09 10:46:11.700382','凈化除味',56),(224,'2018-04-09 10:46:21.798864','2018-04-09 10:46:21.798963','浴室用品',56),(225,'2018-04-09 10:46:38.851705','2018-04-09 10:46:38.851744','縫紉針織',56),(226,'2018-04-09 10:47:29.768792','2018-04-09 10:47:29.768851','床品套件',57),(227,'2018-04-09 10:47:43.068195','2018-04-09 10:47:43.068238','被子',57),(228,'2018-04-09 10:47:55.954652','2018-04-09 10:47:55.954704','枕芯',57),(229,'2018-04-09 10:48:07.054248','2018-04-09 10:48:07.054299','蚊帳',57),(230,'2018-04-09 10:48:13.148110','2018-04-09 10:48:13.148207','涼席',57),(231,'2018-04-09 10:48:22.983566','2018-04-09 10:48:22.983608','毛巾浴巾',57),(232,'2018-04-09 10:48:40.536740','2018-04-09 10:48:40.537102','吸頂燈',58),(233,'2018-04-09 10:48:49.011808','2018-04-09 10:48:49.011852','吊燈',58),(234,'2018-04-09 10:48:57.503376','2018-04-09 10:48:57.503551','台燈',58),(235,'2018-04-09 10:49:09.990632','2018-04-09 10:49:09.990674','筒燈射燈',58),(236,'2018-04-09 10:49:19.476924','2018-04-09 10:49:19.476970','裝飾燈',58),(237,'2018-04-09 10:49:34.463529','2018-04-09 10:49:34.463587','臥室傢俱',59),(238,'2018-04-09 10:49:43.863760','2018-04-09 10:49:43.863805','客廳傢俱',59),(239,'2018-04-09 10:49:52.890521','2018-04-09 10:49:52.890566','餐廳傢俱',59),(240,'2018-04-09 10:50:00.371566','2018-04-09 10:50:00.371818','書房傢俱',59),(241,'2018-04-09 10:50:07.098922','2018-04-09 10:50:07.098961','兒童傢俱',59),(242,'2018-04-09 10:50:19.143462','2018-04-09 10:50:19.143527','裝飾字畫',60),(243,'2018-04-09 10:50:26.723524','2018-04-09 10:50:26.723568','裝飾擺件',60),(244,'2018-04-09 10:50:37.529642','2018-04-09 10:50:37.529683','十字繡',60),(245,'2018-04-09 10:51:02.366545','2018-04-09 10:51:02.366585','墻貼',60),(246,'2018-04-09 10:51:14.673577','2018-04-09 10:51:14.673622','瓷磚',61),(247,'2018-04-09 10:51:20.529141','2018-04-09 10:51:20.529261','地板',61),(248,'2018-04-09 10:51:31.121585','2018-04-09 10:51:31.121641','油漆塗料',61),(249,'2018-04-09 10:51:39.261015','2018-04-09 10:51:39.261077','壁紙',61),(250,'2018-04-09 10:52:03.520983','2018-04-09 10:52:03.521024','鎖具',62),(251,'2018-04-09 10:52:12.470392','2018-04-09 10:52:12.470482','電動工具',62),(252,'2018-04-09 10:52:21.041130','2018-04-09 10:52:21.041174','手動工具',62),(253,'2018-04-09 10:52:31.599209','2018-04-09 10:52:31.599255','測量工具',62),(254,'2018-04-09 10:52:49.673907','2018-04-09 10:52:49.673945','勞防用品',62),(255,'2018-04-09 10:53:22.230127','2018-04-09 10:53:22.230194','水具酒具',63),(256,'2018-04-09 10:53:36.874892','2018-04-09 10:53:36.874935','烹飪鍋具',63),(257,'2018-04-09 10:53:46.025047','2018-04-09 10:53:46.025129','餐具',63),(258,'2018-04-09 10:53:59.183741','2018-04-09 10:53:59.183788','廚房配件',63),(259,'2018-04-09 10:54:17.154351','2018-04-09 10:54:17.154409','刀剪菜板',63),(260,'2018-04-09 10:54:28.054467','2018-04-09 10:54:28.054511','鍋具套裝',63),(261,'2018-04-09 10:54:39.436215','2018-04-09 10:54:39.436460','水槽',64),(262,'2018-04-09 10:54:48.490520','2018-04-09 10:54:48.490561','龍頭',64),(263,'2018-04-09 10:54:58.615841','2018-04-09 10:54:58.616299','淋浴花灑',64),(264,'2018-04-09 10:55:07.214304','2018-04-09 10:55:07.214363','馬桶',64),(265,'2018-04-09 10:55:24.453550','2018-04-09 10:55:24.453593','廚衛掛件',64),(266,'2018-04-09 10:55:37.042973','2018-04-09 10:55:37.043014','浴室櫃',64),(267,'2018-04-09 10:55:58.093400','2018-04-09 10:55:58.093487','T恤',65),(268,'2018-04-09 10:56:06.167659','2018-04-09 10:56:06.167702','牛仔褲',65),(269,'2018-04-09 10:56:15.579739','2018-04-09 10:56:15.579781','襯衫',65),(270,'2018-04-09 10:56:21.330228','2018-04-09 10:56:21.330268','短褲',65),(271,'2018-04-09 10:56:31.432431','2018-04-09 10:56:31.432506','羽絨服',65),(272,'2018-04-09 10:56:45.065922','2018-04-09 10:56:45.065962','衛衣',65),(273,'2018-04-09 10:57:07.546075','2018-04-09 10:57:07.546116','西服套裝',65),(274,'2018-04-09 10:57:18.823678','2018-04-09 10:57:18.823720','襯衫',66),(275,'2018-04-09 10:57:41.556178','2018-04-09 10:57:41.556225','雪紡衫',66),(276,'2018-04-09 10:57:52.929657','2018-04-09 10:57:52.929697','短衣套',66),(277,'2018-04-09 10:57:59.657898','2018-04-09 10:57:59.657943','衛衣',66),(278,'2018-04-09 10:58:07.246701','2018-04-09 10:58:07.246743','休閒褲',66),(279,'2018-04-09 10:58:17.075213','2018-04-09 10:58:17.075255','牛仔褲',66),(280,'2018-04-09 10:58:28.783506','2018-04-09 10:58:28.783624','小西裝',66),(281,'2018-04-09 10:58:39.734123','2018-04-09 10:58:39.734165','套裝',67),(282,'2018-04-09 10:58:54.035921','2018-04-09 10:58:54.035999','衛衣',67),(283,'2018-04-09 10:59:01.809045','2018-04-09 10:59:01.809112','褲子',67),(284,'2018-04-09 10:59:11.529237','2018-04-09 10:59:11.529278','襯衫',67),(285,'2018-04-09 10:59:19.701142','2018-04-09 10:59:19.701182','羽絨服',67),(286,'2018-04-09 10:59:29.917807','2018-04-09 10:59:29.917935','棉服',67),(287,'2018-04-09 10:59:37.808649','2018-04-09 10:59:37.808697','內衣褲',67),(288,'2018-04-09 10:59:47.335110','2018-04-09 10:59:47.335153','運動鞋',68),(289,'2018-04-09 10:59:55.048010','2018-04-09 10:59:55.048115','靴子',68),(290,'2018-04-09 11:00:01.655226','2018-04-09 11:00:01.655389','帆布鞋',68),(291,'2018-04-09 11:00:10.050759','2018-04-09 11:00:10.050847','棉鞋',68),(292,'2018-04-09 11:00:36.252685','2018-04-09 11:00:36.252727','睡衣',69),(293,'2018-04-09 11:00:51.916631','2018-04-09 11:00:51.916725','打底褲',69),(294,'2018-04-09 11:01:03.507003','2018-04-09 11:01:03.507082','保暖內衣',69),(295,'2018-04-09 11:01:17.165081','2018-04-09 11:01:17.165123','背心',69),(296,'2018-04-09 11:01:27.044001','2018-04-09 11:01:27.044043','男士內褲',69),(297,'2018-04-09 11:01:36.242881','2018-04-09 11:01:36.242924','女士內褲',69),(298,'2018-04-09 11:01:54.834481','2018-04-09 11:01:54.834524','披肩',70),(299,'2018-04-09 11:02:00.645511','2018-04-09 11:02:00.645551','圍巾',70),(300,'2018-04-09 11:02:11.482667','2018-04-09 11:02:11.482721','鏡片',70),(301,'2018-04-09 11:02:20.022779','2018-04-09 11:02:20.022826','太陽鏡',70),(302,'2018-04-09 11:02:34.084449','2018-04-09 11:02:34.084490','毛線帽',70),(303,'2018-04-09 11:02:46.119130','2018-04-09 11:02:46.119177','禮貌',70),(304,'2018-04-09 11:02:58.516680','2018-04-09 11:02:58.516821','口罩',70),(305,'2018-04-09 11:03:18.478719','2018-04-09 11:03:18.478762','單鞋',71),(306,'2018-04-09 11:03:34.487317','2018-04-09 11:03:34.487363','休閒鞋',71),(307,'2018-04-09 11:03:43.157761','2018-04-09 11:03:43.157841','帆布鞋',71),(308,'2018-04-09 11:03:52.414196','2018-04-09 11:03:52.414241','媽媽鞋',71),(309,'2018-04-09 11:04:07.541405','2018-04-09 11:04:07.541475','女靴',71),(310,'2018-04-09 11:04:21.823807','2018-04-09 11:04:21.823863','高跟鞋',71),(311,'2018-04-09 11:04:33.148296','2018-04-09 11:04:33.148342','涼鞋',71),(312,'2018-04-09 11:04:42.712939','2018-04-09 11:04:42.712979','真皮包',72),(313,'2018-04-09 11:05:01.537643','2018-04-09 11:05:01.537695','單肩包',72),(314,'2018-04-09 11:05:10.452996','2018-04-09 11:05:10.453036','手提包',72),(315,'2018-04-09 11:05:21.516678','2018-04-09 11:05:21.516722','鞋挎包',72),(316,'2018-04-09 11:18:13.518247','2018-04-09 11:18:13.518288','雙肩包',72),(317,'2018-04-09 11:18:24.704274','2018-04-09 11:18:24.704314','錢包',72),(318,'2018-04-09 11:21:41.102117','2018-04-09 11:21:41.102167','男士錢包',73),(319,'2018-04-09 11:21:51.040168','2018-04-09 11:21:51.040272','雙肩包',73),(320,'2018-04-09 11:22:20.721731','2018-04-09 11:22:20.721812','單肩包',73),(321,'2018-04-09 11:22:37.133514','2018-04-09 11:22:37.133556','商務公文包',73),(322,'2018-04-09 11:22:51.040191','2018-04-09 11:22:51.040233','男士手包',73),(323,'2018-04-09 11:24:09.390104','2018-04-09 11:24:09.390170','拉桿箱',74),(324,'2018-04-09 11:24:20.905499','2018-04-09 11:24:20.905542','拉桿包',74),(325,'2018-04-09 11:24:38.908847','2018-04-09 11:24:38.908888','旅行包',74),(326,'2018-04-09 11:24:59.546666','2018-04-09 11:24:59.546709','電腦包',74),(327,'2018-04-09 11:25:09.425172','2018-04-09 11:25:09.425223','休閒運動包',74),(328,'2018-04-09 11:25:17.336990','2018-04-09 11:25:17.337047','書包',74),(329,'2018-04-09 11:25:29.965879','2018-04-09 11:25:29.965945','登山包',74),(330,'2018-04-09 11:25:56.939364','2018-04-09 11:25:56.939402','天梭',75),(331,'2018-04-09 11:26:13.919984','2018-04-09 11:26:13.920027','浪琴',75),(332,'2018-04-09 11:26:51.898328','2018-04-09 11:26:51.898506','歐米茄',75),(333,'2018-04-09 11:27:09.494057','2018-04-09 11:27:09.494120','泰格豪雅',75),(334,'2018-04-09 11:27:15.382732','2018-04-09 11:27:15.382833','DW',75),(335,'2018-04-09 11:27:24.784177','2018-04-09 11:27:24.784225','卡西歐',75),(336,'2018-04-09 11:27:31.447596','2018-04-09 11:27:31.447669','西鐵城',75),(337,'2018-04-09 11:27:42.642805','2018-04-09 11:27:42.642852','黃金',76),(338,'2018-04-09 11:27:49.327614','2018-04-09 11:27:49.327665','K金',76),(339,'2018-04-09 11:28:01.614654','2018-04-09 11:28:01.614700','時尚飾品',76),(340,'2018-04-09 11:28:09.412255','2018-04-09 11:28:09.412299','鉆石',76),(341,'2018-04-09 11:28:22.916617','2018-04-09 11:28:22.916662','翡翠玉石',76),(342,'2018-04-09 11:28:30.345615','2018-04-09 11:28:30.345663','銀飾',76),(343,'2018-04-09 11:28:39.321423','2018-04-09 11:28:39.321477','水晶瑪瑙',76),(344,'2018-04-09 11:28:57.657591','2018-04-09 11:28:57.657636','休閒鞋',77),(345,'2018-04-09 12:08:16.560944','2018-04-11 12:37:00.856809','商務休閒鞋',77),(346,'2018-04-09 12:09:27.344880','2018-04-09 12:09:27.344924','正裝鞋',77),(347,'2018-04-09 12:09:36.131127','2018-04-09 12:09:36.131175','帆布鞋',77),(348,'2018-04-09 12:09:46.733096','2018-04-09 12:09:46.733135','涼鞋',77),(349,'2018-04-09 12:10:12.669806','2018-04-09 12:10:12.669851','跑步鞋',78),(350,'2018-04-09 12:10:24.462717','2018-04-09 12:10:24.462757','休閒鞋',78),(351,'2018-04-09 12:10:33.369187','2018-04-09 12:10:33.369266','籃球鞋',78),(352,'2018-04-09 12:10:41.678099','2018-04-09 12:10:41.678147','帆布鞋',77),(353,'2018-04-09 12:10:52.832621','2018-04-09 12:10:52.832671','板鞋',77),(354,'2018-04-09 12:11:11.611198','2018-04-09 12:11:11.611250','拖鞋',78),(355,'2018-04-09 12:11:20.463957','2018-04-09 12:11:20.464001','運動包',78),(356,'2018-04-09 12:11:37.214241','2018-04-09 12:11:37.214291','足球鞋',78),(357,'2018-04-09 12:13:15.915511','2018-04-09 12:13:15.915579','T恤',79),(358,'2018-04-09 12:13:38.332607','2018-04-09 12:13:38.332682','運動套裝',79),(359,'2018-04-09 12:13:48.314684','2018-04-09 12:13:48.314757','運動褲',79),(360,'2018-04-09 12:13:58.115856','2018-04-09 12:13:58.115930','衛衣',79),(361,'2018-04-09 12:14:05.741448','2018-04-09 12:14:05.741497','夾克',79),(362,'2018-04-09 12:14:13.258943','2018-04-09 12:14:13.258986','羽絨服',79),(363,'2018-04-09 12:14:44.556933','2018-04-09 12:14:44.556986','跑步機',80),(364,'2018-04-09 12:15:14.348396','2018-04-09 12:15:14.348504','動感單車',80),(365,'2018-04-09 12:15:25.182779','2018-04-09 12:15:25.182818','健身車',80),(366,'2018-04-09 12:15:39.011764','2018-04-09 12:15:39.011803','橢圓機',80),(367,'2018-04-09 12:15:52.191090','2018-04-09 12:15:52.191133','綜合訓練器',80),(368,'2018-04-09 12:16:00.759984','2018-04-09 12:16:00.760022','劃船機',80),(369,'2018-04-09 12:16:23.743936','2018-04-09 12:16:23.743975','甩脂機',80),(370,'2018-04-09 12:16:37.158374','2018-04-09 12:16:37.158419','山地車',81),(371,'2018-04-09 12:16:47.227313','2018-04-09 12:16:47.227353','公路車',81),(372,'2018-04-09 12:16:54.949681','2018-04-09 12:16:54.949725','折疊車',81),(373,'2018-04-09 12:17:05.820361','2018-04-09 12:17:05.820407','騎行服',81),(374,'2018-04-09 12:17:13.605959','2018-04-09 12:17:13.606000','電動車',81),(375,'2018-04-09 12:17:33.944309','2018-04-09 12:17:33.944412','電動滑板車',81),(376,'2018-04-09 12:17:50.672612','2018-04-09 12:17:50.672823','乒乓球',82),(377,'2018-04-09 12:18:02.249051','2018-04-09 12:18:02.249115','羽毛球',81),(378,'2018-04-09 12:18:17.658163','2018-04-09 12:18:32.143808','籃球',82),(379,'2018-04-09 12:18:44.169275','2018-04-09 12:18:44.169314','足球',82),(380,'2018-04-09 12:18:59.052389','2018-04-09 12:18:59.052430','輪滑滑板',82),(381,'2018-04-09 12:19:13.369855','2018-04-09 12:19:13.369895','網球',82),(382,'2018-04-09 12:19:20.514040','2018-04-09 12:19:20.514088','高爾夫',82),(383,'2018-04-09 12:19:41.478550','2018-04-09 12:19:41.478590','戶外風衣',83),(384,'2018-04-09 12:19:50.948351','2018-04-09 12:19:50.948402','徒步鞋',83),(385,'2018-04-09 12:20:00.773041','2018-04-09 12:20:00.773107','T恤',83),(386,'2018-04-09 12:20:13.572677','2018-04-09 12:20:13.572731','沖鋒衣褲',83),(387,'2018-04-09 12:20:35.830642','2018-04-09 12:20:35.830691','速幹衣褲',83),(388,'2018-04-09 12:20:45.236874','2018-04-09 12:20:45.236916','越野跑鞋',83),(389,'2018-04-09 12:20:53.484799','2018-04-09 12:20:53.484931','滑雪服',83),(390,'2018-04-09 12:21:03.664043','2018-04-09 12:21:03.664087','背包',84),(391,'2018-04-09 12:21:13.588552','2018-04-09 12:21:13.588761','帳篷',84),(392,'2018-04-09 12:21:22.627360','2018-04-09 12:21:22.627441','望遠鏡',84),(393,'2018-04-09 12:21:31.571427','2018-04-09 12:21:31.571470','燒烤用具',84),(394,'2018-04-09 12:21:43.436347','2018-04-09 12:21:43.436386','編寫桌椅床',84),(395,'2018-04-09 12:21:51.496392','2018-04-09 12:21:51.496432','戶外配飾',84),(396,'2018-04-09 12:22:03.144795','2018-04-09 12:22:03.144838','軍迷用品',84),(397,'2018-04-09 12:22:19.174208','2018-04-09 12:22:19.174256','最新開盤',85),(398,'2018-04-09 12:22:32.680341','2018-04-09 12:22:32.680381','普通住宅',85),(399,'2018-04-09 12:23:13.036354','2018-04-09 12:23:13.036402','別墅',85),(400,'2018-04-09 12:23:20.661348','2018-04-09 12:23:20.661400','商業辦公',85),(401,'2018-04-09 12:23:32.836788','2018-04-09 12:23:32.836830','海外房產',85),(402,'2018-04-09 12:23:47.819951','2018-04-09 12:23:47.820002','微型車',86),(403,'2018-04-09 12:23:56.486888','2018-04-09 12:23:56.486929','小型車',86),(404,'2018-04-09 12:24:09.346459','2018-04-09 12:24:09.346508','緊湊型車',86),(405,'2018-04-09 12:24:23.609500','2018-04-09 12:24:23.609542','中型車',86),(406,'2018-04-09 12:24:34.464050','2018-04-09 12:24:34.464093','中大行車',86),(407,'2018-04-09 12:24:46.157301','2018-04-09 12:24:46.157342','機油',87),(408,'2018-04-09 12:24:54.173351','2018-04-09 12:24:54.173391','輪胎',87),(409,'2018-04-09 12:25:01.636545','2018-04-09 12:25:01.636588','添加劑',87),(410,'2018-04-09 12:25:13.324702','2018-04-09 12:25:13.324750','防凍液',87),(411,'2018-04-09 12:25:23.875459','2018-04-09 12:25:23.875500','濾清器',87),(412,'2018-04-09 12:25:35.605448','2018-04-09 12:25:35.605489','蓄電池',87),(413,'2018-04-09 12:25:48.272607','2018-04-09 12:25:48.272647','雨刷',87),(414,'2018-04-09 12:26:04.737314','2018-04-09 12:26:04.737356','座墊座套',88),(415,'2018-04-09 12:26:25.466016','2018-04-09 12:26:25.466060','腳墊',88),(416,'2018-04-09 12:26:41.636108','2018-04-09 12:26:41.636148','頭枕腰靠',88),(417,'2018-04-09 12:26:50.317697','2018-04-09 12:26:50.317737','方向盤套',88),(418,'2018-04-09 12:27:04.852657','2018-04-09 12:27:04.852698','後備箱墊',88),(419,'2018-04-09 12:27:28.245163','2018-04-09 12:27:28.245206','車載支架',88),(420,'2018-04-09 12:27:42.249996','2018-04-09 12:27:42.250040','掛件擺件',88),(421,'2018-04-09 12:27:56.558508','2018-04-09 12:27:56.558549','行車記錄儀',89),(422,'2018-04-09 12:28:07.738113','2018-04-09 12:28:07.738158','車載充電器',89),(423,'2018-04-09 12:28:20.669977','2018-04-09 12:28:20.670037','車機導航',89),(424,'2018-04-09 12:28:30.768756','2018-04-09 12:28:30.768865','車載藍牙',89),(425,'2018-04-09 12:28:40.911231','2018-04-09 12:28:40.911300','智能駕駛',89),(426,'2018-04-09 12:28:50.264210','2018-04-09 12:28:50.264251','車載凈化器',89),(427,'2018-04-09 12:29:05.698627','2018-04-09 12:29:05.698671','車載吸塵器',89),(428,'2018-04-09 12:29:21.396287','2018-04-09 12:29:21.396347','胎壓監測',90),(429,'2018-04-09 12:29:29.941158','2018-04-09 12:29:29.941199','充氣泵',90),(430,'2018-04-09 12:29:38.039932','2018-04-09 12:29:38.039976','滅火器',90),(431,'2018-04-09 12:29:45.055847','2018-04-09 12:29:45.055888','車載床',90),(432,'2018-04-09 12:29:53.265950','2018-04-09 12:29:53.265998','應急救援',90),(433,'2018-04-09 12:30:04.204188','2018-04-09 12:30:04.204227','防盜設備',90),(434,'2018-04-09 12:30:21.022724','2018-04-09 12:30:21.022771','1段',91),(435,'2018-04-09 12:30:28.705125','2018-04-09 12:30:28.705297','2段',91),(436,'2018-04-09 12:30:41.640737','2018-04-09 12:30:41.640777','3段',91),(437,'2018-04-09 12:30:47.938600','2018-04-09 12:30:47.938654','4段',91),(438,'2018-04-09 12:31:01.503065','2018-04-09 12:31:01.503251','孕媽奶粉',91),(439,'2018-04-09 12:31:10.862232','2018-04-09 12:31:10.862287','有機奶粉',91),(440,'2018-04-09 12:31:20.344400','2018-04-09 12:31:20.344443','米粉',92),(441,'2018-04-09 12:31:30.706523','2018-04-09 12:31:30.706688','面條',92),(442,'2018-04-09 12:31:44.035896','2018-04-09 12:31:44.035975','果泥',92),(443,'2018-04-09 12:31:57.403136','2018-04-09 12:31:57.403180','益生菌',92),(444,'2018-04-09 12:32:10.384580','2018-04-09 12:32:10.384629','DHA',92),(445,'2018-04-09 12:32:21.916098','2018-04-09 12:32:21.916144','NB',93),(446,'2018-04-09 12:32:29.287475','2018-04-09 12:32:29.287523','S',93),(447,'2018-04-09 12:32:36.424841','2018-04-09 12:32:36.424887','M',93),(448,'2018-04-09 12:32:42.132988','2018-04-09 12:32:42.133030','L',93),(449,'2018-04-09 12:32:50.778168','2018-04-09 12:32:50.778233','XL',93),(450,'2018-04-09 12:32:57.068461','2018-04-09 12:32:57.068502','XXL',93),(451,'2018-04-09 12:33:06.777164','2018-04-09 12:33:06.777211','拉拉褲',93),(452,'2018-04-09 12:33:24.613039','2018-04-09 12:33:24.613080','遙控電動',94),(453,'2018-04-09 12:33:31.652664','2018-04-09 12:33:31.652732','益智玩具',94),(454,'2018-04-09 12:33:45.339728','2018-04-09 12:33:45.339766','積木拼插',94),(455,'2018-04-09 12:33:55.126028','2018-04-09 12:33:55.126067','動漫玩具',94),(456,'2018-04-09 12:34:11.655807','2018-04-09 12:34:11.655851','毛絨布藝',94),(457,'2018-04-09 12:34:20.900620','2018-04-09 12:34:20.900691','鋼琴',95),(458,'2018-04-09 12:34:28.181696','2018-04-09 12:34:28.181746','電鋼琴',95),(459,'2018-04-09 12:34:39.033787','2018-04-09 12:34:39.033837','電子琴',95),(460,'2018-04-09 12:34:44.586005','2018-04-09 12:34:44.586048','吉他',95),(461,'2018-04-09 12:35:00.803528','2018-04-09 12:35:00.803568','尤克里里',95),(462,'2018-04-09 12:35:17.639608','2018-04-09 12:35:17.639654','蘋果',96),(463,'2018-04-09 12:35:24.396253','2018-04-09 12:35:24.396333','香蕉',96),(464,'2018-04-09 12:35:38.853589','2018-04-09 12:35:38.853630','梨',96),(465,'2018-04-09 12:35:44.700034','2018-04-09 12:35:44.700076','橙子',96),(466,'2018-04-09 12:35:54.523749','2018-04-09 12:35:54.523791','奇異果',96),(467,'2018-04-09 12:36:04.893146','2018-04-09 12:36:04.893199','火龍果',96),(468,'2018-04-09 12:36:14.484152','2018-04-09 12:36:14.485197','蛋品',97),(469,'2018-04-09 12:36:28.415979','2018-04-09 12:36:28.416033','葉菜類',97),(470,'2018-04-09 12:36:37.316846','2018-04-09 12:36:37.316905','根莖類',97),(471,'2018-04-09 12:36:56.682895','2018-04-09 12:36:56.682936','蔥姜蒜椒',97),(472,'2018-04-09 12:37:09.086730','2018-04-09 12:37:09.086801','豬肉',98),(473,'2018-04-09 12:37:14.763994','2018-04-09 12:37:14.764035','牛肉',98),(474,'2018-04-09 12:37:23.722896','2018-04-09 12:37:23.722937','羊肉',98),(475,'2018-04-09 12:37:31.952876','2018-04-09 12:37:31.952917','雞肉',98),(476,'2018-04-09 12:37:40.185669','2018-04-09 12:37:40.185708','鴨肉',98),(477,'2018-04-09 12:37:54.541087','2018-04-09 12:37:54.541206','白酒',99),(478,'2018-04-09 12:38:00.476058','2018-04-09 12:38:00.476103','葡萄酒',99),(479,'2018-04-09 12:38:07.401633','2018-04-09 12:38:07.401673','洋酒',99),(480,'2018-04-09 12:38:15.374182','2018-04-09 12:38:15.374237','啤酒',99),(481,'2018-04-09 12:38:22.161741','2018-04-09 12:38:22.162162','黃酒',99),(482,'2018-04-09 12:38:34.069996','2018-04-09 12:38:34.070069','魚類',100),(483,'2018-04-09 12:38:40.454694','2018-04-09 12:38:40.454748','蝦類',100),(484,'2018-04-09 12:38:50.430100','2018-04-09 12:38:50.430144','蟹類',100),(485,'2018-04-09 12:38:59.664340','2018-04-09 12:38:59.664378','貝類',100),(486,'2018-04-09 12:39:07.324234','2018-04-09 12:39:07.324272','海參',100),(487,'2018-04-09 12:39:17.066508','2018-04-09 12:39:17.066561','魷魚',100),(488,'2018-04-09 12:39:24.459066','2018-04-09 12:39:24.459109','水餃',101),(489,'2018-04-09 12:39:34.604818','2018-04-09 12:39:34.604873','湯圓',101),(490,'2018-04-09 12:39:41.951256','2018-04-09 12:39:41.951389','面點',101),(491,'2018-04-09 12:39:56.644602','2018-04-09 12:39:56.644666','烘培半成品',101),(492,'2018-04-09 12:40:06.995033','2018-04-09 12:40:06.995079','方便速食',101),(493,'2018-04-09 12:40:18.989451','2018-04-09 12:40:18.989491','華北',102),(494,'2018-04-09 12:40:24.498405','2018-04-09 12:40:24.498446','華東',102),(495,'2018-04-09 12:40:35.291572','2018-04-09 12:40:35.291613','華南',102),(496,'2018-04-09 12:40:44.577503','2018-04-09 12:40:44.577596','華中',102),(497,'2018-04-09 12:40:50.353640','2018-04-09 12:40:50.353719','東北',102),(498,'2018-04-09 12:40:59.948664','2018-04-09 12:40:59.948705','西北',102),(499,'2018-04-09 12:41:04.991165','2018-04-09 12:41:04.991210','西南',102),(500,'2018-04-09 12:41:20.415788','2018-04-09 12:41:33.490500','0-2歲',103),(501,'2018-04-09 12:41:51.393210','2018-04-09 12:41:51.393266','3-6歲',103),(502,'2018-04-09 12:42:00.521776','2018-04-09 12:42:00.521834','7-10歲',103),(503,'2018-04-09 12:42:06.853828','2018-04-09 12:42:06.853879','11-14歲',103),(504,'2018-04-09 12:42:15.217304','2018-04-09 12:42:15.217346','兒童文藝',103),(505,'2018-04-09 12:42:21.085464','2018-04-09 12:42:21.085572','繪本',103),(506,'2018-04-09 12:42:26.635396','2018-04-09 12:42:26.635436','科普',103),(507,'2018-04-09 12:42:35.299418','2018-04-09 12:42:35.299457','教材',104),(508,'2018-04-09 12:42:44.941114','2018-04-09 12:42:44.941153','中小學教輔',104),(509,'2018-04-09 12:42:51.391709','2018-04-09 12:42:51.391751','考試',104),(510,'2018-04-09 12:43:03.953751','2018-04-09 12:43:03.953795','外語學習',104),(511,'2018-04-09 12:43:13.404857','2018-04-09 12:43:13.404902','字典詞典',104),(512,'2018-04-09 12:43:22.635176','2018-04-09 12:43:22.635220','小說',105),(513,'2018-04-09 12:43:29.185733','2018-04-09 12:43:29.185956','文學',105),(514,'2018-04-09 12:43:36.123019','2018-04-09 12:43:36.123619','青春文學',105),(515,'2018-04-09 12:43:57.373715','2018-04-09 12:43:57.373760','傳記',105),(516,'2018-04-09 12:44:02.905921','2018-04-09 12:44:02.905961','動漫',105),(517,'2018-04-09 12:44:10.930632','2018-04-09 12:44:10.930677','藝術',105),(518,'2018-04-09 12:44:22.797355','2018-04-09 12:44:22.797407','音樂',106),(519,'2018-04-09 12:44:29.689156','2018-04-09 12:44:29.689196','影視',106),(520,'2018-04-09 12:44:41.896114','2018-04-09 12:44:41.896156','教育音像',106),(521,'2018-04-09 12:44:52.139493','2018-04-09 12:44:52.139567','遊戲',106),(522,'2018-04-09 12:45:04.183430','2018-04-09 12:45:04.183788','小說',107),(523,'2018-04-09 12:45:12.853989','2018-04-09 12:45:12.854064','勵志與成功',107),(524,'2018-04-09 12:45:20.095013','2018-04-09 12:45:20.095176','經濟金融',107),(525,'2018-04-09 12:45:29.048014','2018-04-09 12:45:29.048060','文學',107),(526,'2018-04-09 12:45:45.137162','2018-04-09 12:45:45.137200','計算機與互聯網',108),(527,'2018-04-09 12:45:55.864096','2018-04-09 12:45:55.864135','科普',108),(528,'2018-04-09 12:46:02.495930','2018-04-09 12:46:02.495974','建築',108),(529,'2018-04-09 12:46:12.225136','2018-04-09 12:46:12.225451','工業技術',108),(530,'2018-04-09 12:46:22.281103','2018-04-09 12:46:22.281142','電子通信',108),(531,'2018-04-09 12:46:28.058464','2018-04-09 12:46:28.058510','醫學',108),(532,'2018-04-09 12:46:34.969122','2018-04-09 12:46:34.969166','農林',108),(533,'2018-04-09 12:46:50.460306','2018-04-09 12:46:50.460367','國內機票',109),(534,'2018-04-09 12:47:03.136221','2018-04-09 12:47:03.136285','國際機票',109),(535,'2018-04-09 12:47:08.441450','2018-04-09 12:47:08.441508','火車票',109),(536,'2018-04-09 12:47:15.969474','2018-04-09 12:47:15.969514','機場服務',109),(537,'2018-04-09 12:47:27.075057','2018-04-09 12:47:27.075338','國內酒店',110),(538,'2018-04-09 12:47:37.048895','2018-04-09 12:47:37.048936','國際酒店',110),(539,'2018-04-09 12:47:49.230938','2018-04-09 12:47:49.230980','超值精選酒店',110),(540,'2018-04-09 12:47:59.488914','2018-04-09 12:47:59.488958','國內旅遊',111),(541,'2018-04-09 12:48:13.464137','2018-04-09 12:48:13.464184','出境旅遊',111),(542,'2018-04-09 12:48:25.847481','2018-04-09 12:48:25.847528','景點門票',111),(543,'2018-04-09 12:48:43.599292','2018-04-09 12:48:43.599333','電影選座',112),(544,'2018-04-09 12:49:00.580843','2018-04-09 12:49:00.580886','演唱會',112),(545,'2018-04-09 12:49:09.886332','2018-04-09 12:49:09.886374','音樂會',112),(546,'2018-04-09 12:49:24.549168','2018-04-09 12:49:24.549214','話劇歌劇',112),(547,'2018-04-09 12:49:31.673625','2018-04-09 12:49:31.673733','體育賽事',112),(548,'2018-04-09 12:49:40.124527','2018-04-09 12:49:40.124722','水費',113),(549,'2018-04-09 12:49:47.944100','2018-04-09 12:49:47.944139','電費',113),(550,'2018-04-09 12:49:55.874111','2018-04-09 12:49:55.874156','煤氣費',113),(551,'2018-04-09 12:50:05.470708','2018-04-09 12:50:05.470749','城市通',113),(552,'2018-04-09 12:50:21.772953','2018-04-09 12:50:21.773025','家政保潔',114),(553,'2018-04-09 12:50:36.536493','2018-04-09 12:50:36.536542','攝影寫真',114),(554,'2018-04-09 12:50:50.325220','2018-04-09 12:50:50.325264','養生',114),(555,'2018-04-09 12:51:01.075371','2018-04-26 14:51:12.471116','代理代辦',114);
/*!40000 ALTER TABLE `tb_goods_category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_goods_channel`
--

DROP TABLE IF EXISTS `tb_goods_channel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_goods_channel` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `create_time` datetime(6) NOT NULL,
  `update_time` datetime(6) NOT NULL,
  `group_id` int NOT NULL,
  `url` varchar(50) NOT NULL,
  `sequence` int NOT NULL,
  `category_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `tb_goods_channel_category_id_8e1b1d82_fk_tb_goods_category_id` (`category_id`),
  CONSTRAINT `tb_goods_channel_category_id_8e1b1d82_fk_tb_goods_category_id` FOREIGN KEY (`category_id`) REFERENCES `tb_goods_category` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_goods_channel`
--

LOCK TABLES `tb_goods_channel` WRITE;
/*!40000 ALTER TABLE `tb_goods_channel` DISABLE KEYS */;
INSERT INTO `tb_goods_channel` VALUES (1,'2018-04-09 09:15:38.057078','2018-04-09 09:15:38.057150',1,'http://shouji.jd.com',1,1),(2,'2018-04-09 09:17:29.097657','2018-04-09 09:17:29.097706',1,'http://www.itcast.cn',2,2),(3,'2018-04-09 09:17:45.065222','2018-04-09 09:17:45.065264',1,'http://www.itcast.cn',3,3),(4,'2018-04-09 09:18:10.865628','2018-04-09 09:18:10.865669',2,'http://www.itcast.cn',1,4),(5,'2018-04-09 09:18:26.508512','2018-04-09 09:18:26.508581',2,'http://www.itcast.cn',2,5),(6,'2018-04-09 09:18:44.054270','2018-04-09 09:18:44.054322',2,'http://www.itcast.cn',3,6),(7,'2018-04-09 09:19:17.539464','2018-04-09 09:19:17.539538',3,'http://www.itcast.cn',1,7),(8,'2018-04-09 09:19:27.460701','2018-04-09 09:19:27.460744',3,'http://www.itcast.cn',2,8),(9,'2018-04-09 09:19:40.863343','2018-04-09 09:19:40.863387',3,'http://www.itcast.cn',3,9),(10,'2018-04-09 09:19:50.561302','2018-04-09 09:19:50.561364',3,'http://www.itcast.cn',4,10),(11,'2018-04-09 09:20:01.493344','2018-04-09 09:20:01.493495',4,'http://www.itcast.cn',1,11),(12,'2018-04-09 09:20:34.086724','2018-04-09 09:20:34.086785',4,'http://www.itcast.cn',2,12),(13,'2018-04-09 09:20:42.379403','2018-04-09 09:20:42.379451',4,'http://www.itcast.cn',4,13),(14,'2018-04-09 09:21:28.958754','2018-04-09 09:21:28.958795',4,'http://www.itcast.cn',4,14),(15,'2018-04-09 09:21:40.106887','2018-04-09 09:21:40.106969',5,'http://www.itcast.cn',1,15),(16,'2018-04-09 09:21:53.353755','2018-04-09 09:21:53.353799',5,'http://www.itcast.cn',2,16),(17,'2018-04-09 09:22:00.609357','2018-04-09 09:22:00.609399',5,'http://www.itcast.cn',3,17),(18,'2018-04-09 09:22:22.954795','2018-04-09 09:22:22.954840',5,'http://www.itcast.cn',4,18),(19,'2018-04-09 09:22:36.104435','2018-04-09 09:22:36.104479',6,'http://www.itcast.cn',1,19),(20,'2018-04-09 09:22:45.332578','2018-04-09 09:22:45.332620',6,'http://www.itcast.cn',2,20),(21,'2018-04-09 09:22:54.175772','2018-04-09 09:22:54.176014',6,'http://www.itcast.cn',3,21),(22,'2018-04-09 09:23:05.485045','2018-04-09 09:23:05.485122',7,'http://www.itcast.cn',1,22),(23,'2018-04-09 09:23:15.810944','2018-04-09 09:23:15.810994',7,'http://www.itcast.cn',2,23),(24,'2018-04-09 09:23:23.689513','2018-04-09 09:23:23.689560',7,'http://www.itcast.cn',3,24),(25,'2018-04-09 09:23:35.724733','2018-04-09 09:23:35.724773',8,'http://www.itcast.cn',1,25),(26,'2018-04-09 09:23:48.261767','2018-04-09 09:23:48.261814',8,'http://www.itcast.cn',2,26),(27,'2018-04-09 09:24:03.645182','2018-04-09 09:24:03.645227',9,'http://www.itcast.cn',1,27),(28,'2018-04-09 09:24:23.379561','2018-04-09 09:24:23.379603',9,'http://www.itcast.cn',2,28),(29,'2018-04-09 09:24:35.402469','2018-04-09 09:24:35.402513',9,'http://www.itcast.cn',3,29),(30,'2018-04-09 09:24:52.890507','2018-04-09 09:24:52.890549',9,'http://www.itcast.cn',4,30),(31,'2018-04-09 09:25:00.005576','2018-04-09 09:25:00.005658',10,'http://www.itcast.cn',1,31),(32,'2018-04-09 09:25:06.989099','2018-04-09 09:25:06.989139',10,'http://www.itcast.cn',2,32),(33,'2018-04-09 09:25:13.785850','2018-04-09 09:25:13.785911',10,'http://www.itcast.cn',3,33),(34,'2018-04-09 09:25:21.231690','2018-04-09 09:25:21.231772',11,'http://www.itcast.cn',1,34),(35,'2018-04-09 09:25:30.766132','2018-04-09 09:25:30.766177',11,'http://www.itcast.cn',2,35),(36,'2018-04-09 09:25:43.574584','2018-04-09 09:25:43.574629',11,'http://www.itcast.cn',3,36),(37,'2018-04-09 09:26:00.332843','2018-04-26 13:13:00.959857',11,'http://www.itcast.cn',4,37);
/*!40000 ALTER TABLE `tb_goods_channel` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_goods_specification`
--

DROP TABLE IF EXISTS `tb_goods_specification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_goods_specification` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `create_time` datetime(6) NOT NULL,
  `update_time` datetime(6) NOT NULL,
  `name` varchar(20) NOT NULL,
  `goods_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `tb_goods_specification_goods_id_41f4eda6_fk_tb_goods_id` (`goods_id`),
  CONSTRAINT `tb_goods_specification_goods_id_41f4eda6_fk_tb_goods_id` FOREIGN KEY (`goods_id`) REFERENCES `tb_goods` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_goods_specification`
--

LOCK TABLES `tb_goods_specification` WRITE;
/*!40000 ALTER TABLE `tb_goods_specification` DISABLE KEYS */;
INSERT INTO `tb_goods_specification` VALUES (1,'2018-04-11 17:20:30.142577','2018-04-11 17:20:30.142657','螢幕尺寸',1),(2,'2018-04-11 17:21:57.862419','2018-04-11 17:21:57.862464','顏色',1),(3,'2018-04-11 17:22:04.687913','2018-04-11 17:22:04.687956','版本',1),(4,'2018-04-14 02:10:32.810681','2018-04-14 02:10:32.810728','顏色',2),(5,'2018-04-14 02:10:39.748266','2018-04-14 02:10:39.748314','記憶體',2),(6,'2018-04-14 03:04:39.450373','2018-04-14 03:04:39.450418','顏色',3),(7,'2018-04-14 03:04:50.182073','2018-04-14 03:04:50.182118','版本',3);
/*!40000 ALTER TABLE `tb_goods_specification` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_sku`
--

DROP TABLE IF EXISTS `tb_sku`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_sku` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `create_time` datetime(6) NOT NULL,
  `update_time` datetime(6) NOT NULL,
  `name` varchar(50) NOT NULL,
  `caption` varchar(100) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `cost_price` decimal(10,2) NOT NULL,
  `market_price` decimal(10,2) NOT NULL,
  `stock` int NOT NULL,
  `sales` int NOT NULL,
  `comments` int NOT NULL,
  `is_launched` tinyint(1) NOT NULL,
  `default_image_url` varchar(200) DEFAULT NULL,
  `category_id` bigint NOT NULL,
  `goods_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `tb_sku_category_id_23dd76b7_fk_tb_goods_category_id` (`category_id`),
  KEY `tb_sku_goods_id_fa5267c2_fk_tb_goods_id` (`goods_id`),
  CONSTRAINT `tb_sku_category_id_23dd76b7_fk_tb_goods_category_id` FOREIGN KEY (`category_id`) REFERENCES `tb_goods_category` (`id`),
  CONSTRAINT `tb_sku_goods_id_fa5267c2_fk_tb_goods_id` FOREIGN KEY (`goods_id`) REFERENCES `tb_goods` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_sku`
--

LOCK TABLES `tb_sku` WRITE;
/*!40000 ALTER TABLE `tb_sku` DISABLE KEYS */;
INSERT INTO `tb_sku` VALUES (1,'2018-04-11 17:28:21.804713','2018-04-25 11:09:04.532866','Apple MacBook Pro 13.3英吋筆記型電腦 銀色','【全新2017款】MacBook Pro，一身才華，一觸，即發 了解【黑五返場特惠】 更多產品請點擊【美多官方Apple旗艦店】',11388.00,10350.00,13388.00,5,5,1,1,'https://drfmall.s3.ap-northeast-3.amazonaws.com/goods002.jpg',157,1),(2,'2018-04-12 06:53:54.575306','2018-04-23 11:44:03.825103','Apple MacBook Pro 13.3英吋筆記型電腦 深灰色','【全新2017款】MacBook Pro，一身才華，一觸，即發 了解【黑五返場特惠】 更多產品請點擊【美多官方Apple旗艦店】',11398.00,10388.00,13398.00,0,1,0,1,'https://drfmall.s3.ap-northeast-3.amazonaws.com/goods002.jpg',157,1),(3,'2018-04-14 02:14:04.599169','2018-04-14 17:26:54.041015','Apple iPhone 8 Plus (A1864) 64GB 金色 移動聯通電信4G手機','選【移動優惠購】新機配新卡，198優質靚號，流量不限量！',6499.00,6300.00,6598.00,10,0,0,1,'https://drfmall.s3.ap-northeast-3.amazonaws.com/goods002.jpg',115,2),(4,'2018-04-14 02:20:33.355996','2018-04-14 17:27:12.736139','Apple iPhone 8 Plus (A1864) 256GB 金色 移動聯通電信4G手機','選【移動優惠購】新機配新卡，198優質靚號，流量不限量！',7988.00,7888.00,8088.00,8,2,0,1,'https://drfmall.s3.ap-northeast-3.amazonaws.com/goods002.jpg',115,2),(5,'2018-04-14 02:45:23.341909','2018-04-14 17:27:17.181609','Apple iPhone 8 Plus (A1864) 64GB 深空灰色 移動聯通電信4G手機','選【移動優惠購】新機配新卡，198優質靚號，流量不限量！',6688.00,6588.00,6788.00,10,0,0,1,'https://drfmall.s3.ap-northeast-3.amazonaws.com/goods002.jpg',115,2),(6,'2018-04-14 02:49:40.912682','2018-04-25 11:09:35.936530','Apple iPhone 8 Plus (A1864) 256GB 深空灰色 移動聯通電信4G手機','選【移動優惠購】新機配新卡，198優質靚號，流量不限量！',7988.00,7888.00,7988.00,0,5,1,1,'https://drfmall.s3.ap-northeast-3.amazonaws.com/goods002.jpg',115,2),(7,'2018-04-14 02:55:11.172604','2018-04-14 17:27:28.772353','Apple iPhone 8 Plus (A1864) 64GB 銀色 移動聯通電信4G手機','選【移動優惠購】新機配新卡，198優質靚號，流量不限量！',6688.00,6588.00,6788.00,3,0,0,1,'https://drfmall.s3.ap-northeast-3.amazonaws.com/goods002.jpg',115,2),(8,'2018-04-14 02:56:17.331169','2018-04-14 17:27:34.536772','Apple iPhone 8 Plus (A1864) 256GB 銀色 移動聯通電信4G手機','選【移動優惠購】新機配新卡，198優質靚號，流量不限量！',7988.00,7888.00,7988.00,9,1,0,1,'https://drfmall.s3.ap-northeast-3.amazonaws.com/goods002.jpg',115,2),(9,'2018-04-14 03:09:00.909709','2018-04-14 17:27:40.624770','華為 HUAWEI P10 Plus 6GB+64GB 鑽雕金 移動聯通電信4G手機 雙卡雙待','wifi雙天線設計！徠卡人像攝影！P10徠卡雙攝拍照，低至2988元！',3388.00,3288.00,3388.00,4,0,0,1,'https://drfmall.s3.ap-northeast-3.amazonaws.com/goods002.jpg',115,3),(10,'2018-04-14 03:13:40.226704','2018-04-25 11:06:55.087206','華為 HUAWEI P10 Plus 6GB+128GB 鑽雕金 移動聯通電信4G手機 雙卡雙待','wifi雙天線設計！徠卡人像攝影！P10徠卡雙攝拍照，低至2988元！',3788.00,3588.00,3888.00,3,0,5,1,'https://drfmall.s3.ap-northeast-3.amazonaws.com/goods002.jpgm88158618',115,3),(11,'2018-04-14 03:16:27.620102','2018-04-25 10:56:51.267674','華為 HUAWEI P10 Plus 6GB+128GB 鑽雕藍 移動聯通電信4G手機 雙卡雙待','wifi雙天線設計！徠卡人像攝影！P10徠卡雙攝拍照，低至2988元！',3788.00,3588.00,3888.00,5,0,2,1,'https://drfmall.s3.ap-northeast-3.amazonaws.com/goods002.jpg',115,3),(12,'2018-04-14 03:17:25.671905','2018-04-14 17:28:06.649098','華為 HUAWEI P10 Plus 6GB+64GB 鑽雕藍 移動聯通電信4G手機 雙卡雙待','wifi雙天線設計！徠卡人像攝影！P10徠卡雙攝拍照，低至2988元！',3388.00,3288.00,3488.00,5,0,0,1,'https://drfmall.s3.ap-northeast-3.amazonaws.com/goods002.jpg',115,3),(13,'2018-04-14 03:18:04.588296','2018-04-14 17:28:23.886231','華為 HUAWEI P10 Plus 6GB+64GB 玫瑰金 移動聯通電信4G手機 雙卡雙待','wifi雙天線設計！徠卡人像攝影！P10徠卡雙攝拍照，低至2988元！',3388.00,3288.00,3488.00,5,0,0,1,'https://drfmall.s3.ap-northeast-3.amazonaws.com/goods002.jpg',115,3),(14,'2018-04-14 03:19:03.691772','2018-04-25 11:10:51.316291','華為 HUAWEI P10 Plus 6GB+128GB 玫瑰金 移動聯通電信4G手機 雙卡雙待','wifi雙天線設計！徠卡人像攝影！P10徠卡雙攝拍照，低至2988元！',3788.00,3588.00,3888.00,0,4,1,1,'https://drfmall.s3.ap-northeast-3.amazonaws.com/goods002.jpg',115,3),(15,'2018-04-14 03:20:00.777150','2018-04-14 17:28:16.738212','華為 HUAWEI P10 Plus 6GB+64GB 曜石黑 移動聯通電信4G手機 雙卡雙待','wifi雙天線設計！徠卡人像攝影！P10徠卡雙攝拍照，低至2988元！',3388.00,3288.00,3488.00,3,2,0,1,'https://drfmall.s3.ap-northeast-3.amazonaws.com/goods002.jpg',115,3),(16,'2018-04-14 03:20:36.855901','2025-05-22 06:20:21.199450','華為 HUAWEI P10 Plus 6GB+128GB 曜石黑 移動聯通電信4G手機 雙卡雙待','666 wifi雙天線設計！徠卡人像攝影！P10徠卡雙攝拍照，低至2988元！',3788.00,3588.00,3888.00,5,0,0,1,'https://drfmall.s3.ap-northeast-3.amazonaws.com/goods002.jpg',115,3);
/*!40000 ALTER TABLE `tb_sku` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_sku_image`
--

DROP TABLE IF EXISTS `tb_sku_image`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_sku_image` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `create_time` datetime(6) NOT NULL,
  `update_time` datetime(6) NOT NULL,
  `image` varchar(100) NOT NULL,
  `sku_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `tb_sku_image_sku_id_8c6d7195_fk_tb_sku_id` (`sku_id`),
  CONSTRAINT `tb_sku_image_sku_id_8c6d7195_fk_tb_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `tb_sku` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_sku_image`
--

LOCK TABLES `tb_sku_image` WRITE;
/*!40000 ALTER TABLE `tb_sku_image` DISABLE KEYS */;
INSERT INTO `tb_sku_image` VALUES (1,'2018-04-12 07:15:13.873180','2018-04-14 17:26:14.513939','https://drfmall.s3.ap-northeast-3.amazonaws.com/goods005.jpg',1),(2,'2018-04-12 07:15:21.029143','2018-04-12 07:15:21.029186','https://drfmall.s3.ap-northeast-3.amazonaws.com/goods005.jpg',1),(3,'2018-04-12 07:15:28.362779','2018-04-12 07:15:28.362824','https://drfmall.s3.ap-northeast-3.amazonaws.com/goods005.jpg',1),(4,'2018-04-12 07:17:23.935313','2018-04-14 17:26:49.549376','https://drfmall.s3.ap-northeast-3.amazonaws.com/goods005.jpg',2),(5,'2018-04-12 07:17:31.408278','2018-04-12 07:17:31.408320','https://drfmall.s3.ap-northeast-3.amazonaws.com/goods005.jpg',2),(6,'2018-04-12 07:17:39.201787','2018-04-12 07:17:39.201830','https://drfmall.s3.ap-northeast-3.amazonaws.com/goods005.jpg',2),(7,'2018-04-14 02:15:06.992811','2018-04-14 17:26:54.035453','https://drfmall.s3.ap-northeast-3.amazonaws.com/goods005.jpg',3),(8,'2018-04-14 02:15:14.933468','2018-04-14 02:15:14.933510','https://drfmall.s3.ap-northeast-3.amazonaws.com/goods005.jpg',3),(9,'2018-04-14 02:15:23.533360','2018-04-14 02:15:23.533402','https://drfmall.s3.ap-northeast-3.amazonaws.com/goods005.jpg',3),(10,'2018-04-12 07:15:13.873180','2018-04-14 17:26:14.513939','https://drfmall.s3.ap-northeast-3.amazonaws.com/goods005.jpg',1),(11,'2018-04-12 07:15:21.029143','2018-04-12 07:15:21.029186','https://drfmall.s3.ap-northeast-3.amazonaws.com/goods005.jpg',1),(12,'2018-04-12 07:15:28.362779','2018-04-12 07:15:28.362824','https://drfmall.s3.ap-northeast-3.amazonaws.com/goods005.jpg',1),(13,'2018-04-12 07:17:23.935313','2018-04-14 17:26:49.549376','https://drfmall.s3.ap-northeast-3.amazonaws.com/goods005.jpg',2),(14,'2018-04-12 07:17:31.408278','2018-04-12 07:17:31.408320','https://drfmall.s3.ap-northeast-3.amazonaws.com/goods005.jpg',2),(15,'2018-04-12 07:17:39.201787','2018-04-12 07:17:39.201830','https://drfmall.s3.ap-northeast-3.amazonaws.com/goods005.jpg',2),(16,'2018-04-14 02:15:06.992811','2018-04-14 17:26:54.035453','https://drfmall.s3.ap-northeast-3.amazonaws.com/goods005.jpg',3),(17,'2018-04-14 02:15:14.933468','2018-04-14 02:15:14.933510','https://drfmall.s3.ap-northeast-3.amazonaws.com/goods005.jpg',3),(18,'2018-04-14 02:15:23.533360','2018-04-14 02:15:23.533402','https://drfmall.s3.ap-northeast-3.amazonaws.com/goods005.jpg',3),(19,'2018-04-12 07:15:13.873180','2018-04-14 17:26:14.513939','https://drfmall.s3.ap-northeast-3.amazonaws.com/goods005.jpg',1),(20,'2018-04-12 07:15:21.029143','2018-04-12 07:15:21.029186','https://drfmall.s3.ap-northeast-3.amazonaws.com/goods005.jpg',1),(21,'2018-04-12 07:15:28.362779','2018-04-12 07:15:28.362824','https://drfmall.s3.ap-northeast-3.amazonaws.com/goods005.jpg',1),(22,'2018-04-12 07:17:23.935313','2018-04-14 17:26:49.549376','https://drfmall.s3.ap-northeast-3.amazonaws.com/goods005.jpg',2),(23,'2018-04-12 07:17:31.408278','2018-04-12 07:17:31.408320','https://drfmall.s3.ap-northeast-3.amazonaws.com/goods005.jpg',2),(24,'2018-04-12 07:17:39.201787','2018-04-12 07:17:39.201830','https://drfmall.s3.ap-northeast-3.amazonaws.com/goods005.jpg',2),(25,'2018-04-14 02:15:06.992811','2018-04-14 17:26:54.035453','https://drfmall.s3.ap-northeast-3.amazonaws.com/goods005.jpg',3),(26,'2018-04-14 02:15:14.933468','2018-04-14 02:15:14.933510','https://drfmall.s3.ap-northeast-3.amazonaws.com/goods005.jpg',3),(27,'2018-04-14 02:15:23.533360','2018-04-14 02:15:23.533402','https://drfmall.s3.ap-northeast-3.amazonaws.com/goods005.jpg',3),(28,'2018-04-12 07:15:13.873180','2018-04-14 17:26:14.513939','https://drfmall.s3.ap-northeast-3.amazonaws.com/goods005.jpg',1),(29,'2018-04-12 07:15:21.029143','2018-04-12 07:15:21.029186','https://drfmall.s3.ap-northeast-3.amazonaws.com/goods005.jpg',1),(30,'2018-04-12 07:15:28.362779','2018-04-12 07:15:28.362824','https://drfmall.s3.ap-northeast-3.amazonaws.com/goods005.jpg',1),(31,'2018-04-12 07:17:23.935313','2018-04-14 17:26:49.549376','https://drfmall.s3.ap-northeast-3.amazonaws.com/goods005.jpg',2),(32,'2018-04-12 07:17:31.408278','2018-04-12 07:17:31.408320','https://drfmall.s3.ap-northeast-3.amazonaws.com/goods005.jpg',2),(33,'2018-04-12 07:17:39.201787','2018-04-12 07:17:39.201830','https://drfmall.s3.ap-northeast-3.amazonaws.com/goods005.jpg',2),(34,'2018-04-14 02:15:06.992811','2018-04-14 17:26:54.035453','https://drfmall.s3.ap-northeast-3.amazonaws.com/goods005.jpg',3),(35,'2018-04-14 02:15:14.933468','2018-04-14 02:15:14.933510','https://drfmall.s3.ap-northeast-3.amazonaws.com/goods005.jpg',3),(36,'2018-04-14 02:15:23.533360','2018-04-14 02:15:23.533402','https://drfmall.s3.ap-northeast-3.amazonaws.com/goods005.jpg',3),(37,'2018-04-12 07:15:13.873180','2018-04-14 17:26:14.513939','https://drfmall.s3.ap-northeast-3.amazonaws.com/goods005.jpg',1),(38,'2018-04-12 07:15:21.029143','2018-04-12 07:15:21.029186','https://drfmall.s3.ap-northeast-3.amazonaws.com/goods005.jpg',1),(39,'2018-04-12 07:15:28.362779','2018-04-12 07:15:28.362824','https://drfmall.s3.ap-northeast-3.amazonaws.com/goods005.jpg',1),(40,'2018-04-12 07:17:23.935313','2018-04-14 17:26:49.549376','https://drfmall.s3.ap-northeast-3.amazonaws.com/goods005.jpg',2);
/*!40000 ALTER TABLE `tb_sku_image` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_sku_specification`
--

DROP TABLE IF EXISTS `tb_sku_specification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_sku_specification` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `create_time` datetime(6) NOT NULL,
  `update_time` datetime(6) NOT NULL,
  `sku_id` bigint NOT NULL,
  `spec_id` bigint NOT NULL,
  `option_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `tb_sku_specification_sku_id_10aee5ae_fk_tb_sku_id` (`sku_id`),
  KEY `tb_sku_specification_spec_id_5aa6db0c_fk_tb_goods_` (`spec_id`),
  KEY `tb_sku_specification_option_id_80a17a3d_fk_tb_specif` (`option_id`),
  CONSTRAINT `tb_sku_specification_option_id_80a17a3d_fk_tb_specif` FOREIGN KEY (`option_id`) REFERENCES `tb_specification_option` (`id`),
  CONSTRAINT `tb_sku_specification_sku_id_10aee5ae_fk_tb_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `tb_sku` (`id`),
  CONSTRAINT `tb_sku_specification_spec_id_5aa6db0c_fk_tb_goods_` FOREIGN KEY (`spec_id`) REFERENCES `tb_goods_specification` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_sku_specification`
--

LOCK TABLES `tb_sku_specification` WRITE;
/*!40000 ALTER TABLE `tb_sku_specification` DISABLE KEYS */;
INSERT INTO `tb_sku_specification` VALUES (1,'2018-04-11 17:53:37.178101','2018-04-11 17:53:37.178148',1,1,1),(2,'2018-04-11 17:56:00.141036','2018-04-11 17:56:00.141078',1,2,4),(3,'2018-04-11 17:56:17.907973','2018-04-11 17:56:17.908017',1,3,7),(4,'2018-04-12 07:11:20.138634','2018-04-12 07:11:20.138677',2,1,1),(5,'2018-04-12 07:11:28.227056','2018-04-12 07:11:28.227099',2,2,3),(6,'2018-04-12 07:11:48.046789','2018-04-12 07:11:48.046885',2,3,7),(7,'2018-04-14 02:16:36.204410','2018-04-14 02:16:36.204453',3,4,8),(8,'2018-04-14 02:16:44.309888','2018-04-14 02:16:44.309972',3,5,11),(9,'2018-04-14 02:20:55.765324','2018-04-14 02:20:55.765377',4,4,8),(10,'2018-04-14 02:21:04.971106','2018-04-14 02:21:04.971155',4,5,12),(11,'2018-04-14 02:45:41.913322','2018-04-14 02:45:41.913372',5,4,9),(12,'2018-04-14 02:45:50.801926','2018-04-14 02:45:50.802005',5,5,11),(13,'2018-04-14 02:50:00.232648','2018-04-14 02:50:00.232694',6,4,9),(14,'2018-04-14 02:50:08.715882','2018-04-14 02:50:08.715927',6,5,12),(15,'2018-04-14 02:56:48.320934','2018-04-14 02:56:48.320980',7,4,10),(16,'2018-04-14 02:56:55.879794','2018-04-14 02:56:55.879839',7,5,11),(17,'2018-04-14 02:57:04.305406','2018-04-14 02:57:04.305462',8,4,10),(18,'2018-04-14 02:57:12.212999','2018-04-14 02:57:12.213047',8,5,12),(19,'2018-04-14 03:10:09.203601','2018-04-14 03:10:09.203646',9,6,13),(20,'2018-04-14 03:10:19.242994','2018-04-14 03:10:19.243421',9,7,20),(21,'2018-04-14 03:14:02.319574','2018-04-14 03:14:02.319621',10,6,13),(22,'2018-04-14 03:14:14.554189','2018-04-14 03:14:14.554237',10,7,21),(23,'2018-04-14 03:21:25.602470','2018-04-14 03:21:25.602519',11,6,14),(24,'2018-04-14 03:21:38.123239','2018-04-14 03:21:38.123285',11,7,21),(25,'2018-04-14 03:21:48.843531','2018-04-14 03:21:48.843577',12,6,14),(26,'2018-04-14 03:22:01.324252','2018-04-14 03:22:01.324321',12,7,20),(27,'2018-04-14 03:22:11.921568','2018-04-14 03:22:11.921613',13,6,15),(28,'2018-04-14 03:22:23.702276','2018-04-14 03:22:23.702323',13,7,20),(29,'2018-04-14 03:22:45.382268','2018-04-14 03:22:45.382313',14,6,15),(30,'2018-04-14 03:22:53.418091','2018-04-14 03:22:53.418147',14,7,21),(31,'2018-04-14 03:23:02.508118','2018-04-14 03:23:02.508186',15,6,16),(32,'2018-04-14 03:23:12.294204','2018-04-14 03:23:12.294255',15,7,20),(33,'2018-04-14 03:23:20.134049','2018-04-14 03:23:20.134095',16,6,16),(34,'2018-04-14 03:23:36.250798','2018-04-14 03:23:36.250844',16,7,21);
/*!40000 ALTER TABLE `tb_sku_specification` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_specification_option`
--

DROP TABLE IF EXISTS `tb_specification_option`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_specification_option` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `create_time` datetime(6) NOT NULL,
  `update_time` datetime(6) NOT NULL,
  `value` varchar(20) NOT NULL,
  `spec_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `tb_specification_opt_spec_id_3f11adee_fk_tb_goods_` (`spec_id`),
  CONSTRAINT `tb_specification_opt_spec_id_3f11adee_fk_tb_goods_` FOREIGN KEY (`spec_id`) REFERENCES `tb_goods_specification` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_specification_option`
--

LOCK TABLES `tb_specification_option` WRITE;
/*!40000 ALTER TABLE `tb_specification_option` DISABLE KEYS */;
INSERT INTO `tb_specification_option` VALUES (1,'2018-04-11 17:22:55.126053','2018-04-11 17:22:55.126095','13.3英寸',1),(2,'2018-04-11 17:24:04.841221','2018-04-11 17:24:04.841265','15.4英寸',1),(3,'2018-04-11 17:24:23.862341','2018-04-11 17:24:23.862385','深灰色',2),(4,'2018-04-11 17:24:35.256820','2018-04-11 17:24:35.256868','銀色',2),(5,'2018-04-11 17:25:04.607535','2018-04-11 17:25:04.607604','core i5/8G記憶體/256G儲存',3),(6,'2018-04-11 17:25:15.969671','2018-04-11 17:25:15.969714','core i5/8G記憶體/128G儲存',3),(7,'2018-04-11 17:25:35.025857','2018-04-12 07:12:08.090494','core i5/8G記憶體/512G儲存',3),(8,'2018-04-14 02:11:12.231649','2018-04-14 02:11:12.231700','金色',4),(9,'2018-04-14 02:11:21.073811','2018-04-14 02:11:21.073917','深空灰',4),(10,'2018-04-14 02:11:27.692284','2018-04-14 02:11:27.692329','銀色',4),(11,'2018-04-14 02:11:35.967113','2018-04-14 02:11:35.967163','64GB',5),(12,'2018-04-14 02:11:42.557263','2018-04-14 02:11:42.557354','256GB',5),(13,'2018-04-14 03:05:48.316724','2018-04-14 03:05:48.316835','鈷雕金',6),(14,'2018-04-14 03:05:58.478640','2018-04-14 03:05:58.478689','鈷雕藍',6),(15,'2018-04-14 03:06:05.995609','2018-04-14 03:06:05.995652','玫瑰金',6),(16,'2018-04-14 03:06:37.587555','2018-04-14 03:06:37.587603','曜石黑',6),(20,'2018-04-14 03:07:15.727628','2018-04-14 03:07:15.727670','64GB',7),(21,'2018-04-14 03:07:23.480154','2018-04-14 03:07:23.480237','128GB',7);
/*!40000 ALTER TABLE `tb_specification_option` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `test_image_upload`
--

DROP TABLE IF EXISTS `test_image_upload`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `test_image_upload` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `create_time` datetime(6) NOT NULL,
  `update_time` datetime(6) NOT NULL,
  `image1` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `test_image_upload`
--

LOCK TABLES `test_image_upload` WRITE;
/*!40000 ALTER TABLE `test_image_upload` DISABLE KEYS */;
INSERT INTO `test_image_upload` VALUES (1,'2025-05-19 13:14:20.826428','2025-05-19 13:14:20.826428','goods/img2.jpg');
/*!40000 ALTER TABLE `test_image_upload` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `token_blacklist_blacklistedtoken`
--

DROP TABLE IF EXISTS `token_blacklist_blacklistedtoken`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `token_blacklist_blacklistedtoken` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `blacklisted_at` datetime(6) NOT NULL,
  `token_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `token_id` (`token_id`),
  CONSTRAINT `token_blacklist_blacklistedtoken_token_id_3cc7fe56_fk` FOREIGN KEY (`token_id`) REFERENCES `token_blacklist_outstandingtoken` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `token_blacklist_blacklistedtoken`
--

LOCK TABLES `token_blacklist_blacklistedtoken` WRITE;
/*!40000 ALTER TABLE `token_blacklist_blacklistedtoken` DISABLE KEYS */;
INSERT INTO `token_blacklist_blacklistedtoken` VALUES (1,'2025-05-12 13:24:11.778799',7),(2,'2025-05-12 13:49:34.381871',10),(4,'2025-05-12 15:16:49.380009',14),(6,'2025-05-12 15:34:41.641394',17),(7,'2025-05-18 14:54:09.133353',21);
/*!40000 ALTER TABLE `token_blacklist_blacklistedtoken` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `token_blacklist_outstandingtoken`
--

DROP TABLE IF EXISTS `token_blacklist_outstandingtoken`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `token_blacklist_outstandingtoken` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `token` longtext NOT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `expires_at` datetime(6) NOT NULL,
  `user_id` bigint DEFAULT NULL,
  `jti` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `token_blacklist_outstandingtoken_jti_hex_d9bdf6f7_uniq` (`jti`),
  KEY `token_blacklist_outstandingtoken_user_id_83bc629a_fk_users_id` (`user_id`),
  CONSTRAINT `token_blacklist_outstandingtoken_user_id_83bc629a_fk_users_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `token_blacklist_outstandingtoken`
--

LOCK TABLES `token_blacklist_outstandingtoken` WRITE;
/*!40000 ALTER TABLE `token_blacklist_outstandingtoken` DISABLE KEYS */;
INSERT INTO `token_blacklist_outstandingtoken` VALUES (1,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc0NzA2OTY4OCwiaWF0IjoxNzQ2OTgzMjg4LCJqdGkiOiJjMmM2M2M4YmQxZDc0Y2UyOTE2NTE0ZmRmZWQzMGRhOCIsInVzZXJfaWQiOjF9.nfEhJDmF63O4SRsWBnT1FjdO4boIEMimwKpmbp4bEos','2025-05-11 17:08:08.251445','2025-05-12 17:08:08.000000',1,'c2c63c8bd1d74ce2916514fdfed30da8'),(2,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc0NzA2OTcyMSwiaWF0IjoxNzQ2OTgzMzIxLCJqdGkiOiIyNTlhMGMwNGYyMWE0YzcyOTNkMTBlNWE1NTU2YzBjOCIsInVzZXJfaWQiOjF9.FAcFUdC_eg522x-ha_YzOiQZVpi9A2KMSMBgPfzTywg','2025-05-11 17:08:41.863765','2025-05-12 17:08:41.000000',1,'259a0c04f21a4c7293d10e5a5556c0c8'),(3,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc0NzA2OTg5NSwiaWF0IjoxNzQ2OTgzNDk1LCJqdGkiOiI2OWFiNTZiNWJhNWI0ZTY2YjZjMmMwZmIxMzNjOWE4MCIsInVzZXJfaWQiOjF9.zam4aCCtd8W_TXRDb-AzAoR5EYmN30m6XQKaL8EaHB0','2025-05-11 17:11:35.496485','2025-05-12 17:11:35.000000',1,'69ab56b5ba5b4e66b6c2c0fb133c9a80'),(4,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc0NzA3MDAwMSwiaWF0IjoxNzQ2OTgzNjAxLCJqdGkiOiJmYmNhNTFhZTI1MWU0ZDFkODZlMzUxMzczMjFiZjg4YyIsInVzZXJfaWQiOjF9.BQ_9dpCbpP5nG9kyRl4nijBPchQ44qRRGm1MydXbKaE','2025-05-11 17:13:21.506265','2025-05-12 17:13:21.000000',1,'fbca51ae251e4d1d86e35137321bf88c'),(5,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc0NzE0MTY5MSwiaWF0IjoxNzQ3MDU1MjkxLCJqdGkiOiIwYTNlMjE1YmRlMjI0NzQxOWFkYTJmNDA2MmQzNWNhNiIsInVzZXJfaWQiOjJ9.GkQrVbxxmDmHnQaVitCw3tGgIB11jKDgSP4hUt9Y5rw','2025-05-12 13:08:11.519979','2025-05-13 13:08:11.000000',2,'0a3e215bde2247419ada2f4062d35ca6'),(6,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc0NzE0MTcxNywiaWF0IjoxNzQ3MDU1MzE3LCJqdGkiOiI4MTk3YWY2YWZhYjY0ZTQ1OGVlZGMwOGM3OWIyMmZkYyIsInVzZXJfaWQiOjJ9.SC5Tn95GNpG5rTcHXyn4gKQQwEkfqWtyM27L05eg7kk','2025-05-12 13:08:37.986278','2025-05-13 13:08:37.000000',2,'8197af6afab64e458eedc08c79b22fdc'),(7,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc0NzE0MTcyOSwiaWF0IjoxNzQ3MDU1MzI5LCJqdGkiOiI0Yzc3MGVmOTY0NzA0Mjk5YjZjZDk1YWQyZjMzOWIyNiIsInVzZXJfaWQiOjJ9.tdNHYhutvTwg3N55gS9qQ4ZNyxaWgFx-gN-zjznQP24','2025-05-12 13:08:49.318510','2025-05-13 13:08:49.000000',2,'4c770ef964704299b6cd95ad2f339b26'),(8,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc0NzE0MjY1MSwiaWF0IjoxNzQ3MDU2MjUxLCJqdGkiOiJhYWVmZDYzZmFmOTU0ZmI0OGM2NzVmYTg2NDU0ZDcxZSIsInVzZXJfaWQiOjJ9.f-Mq2fLnsxCeUm4TxxhO36nrVLruzDEYi0BfWjd4rx0','2025-05-12 13:24:11.712819','2025-05-13 13:24:11.000000',2,'aaefd63faf954fb48c675fa86454d71e'),(9,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc0NzE0MzE5NCwiaWF0IjoxNzQ3MDU2Nzk0LCJqdGkiOiJkNWU4MzFmOTRlOWM0NDdiYTNlMmMwOTQxMjE5YjVjMyIsInVzZXJfaWQiOjF9.V5-n-42D0ae9v5rYvnQYbtLWdLd6vmnzdh1-i28r7VA','2025-05-12 13:33:14.097797','2025-05-13 13:33:14.000000',1,'d5e831f94e9c447ba3e2c0941219b5c3'),(10,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc0NzE0MzIwNSwiaWF0IjoxNzQ3MDU2ODA1LCJqdGkiOiIyZTNlYjg5MDJiNjM0YTUyOWMwYmU3ZDYzMWQwNWQwMyIsInVzZXJfaWQiOjJ9.4U_5_SBD0f8Lfku1LVdoI9ctg0Ky0rKMA-pduutGk1Y','2025-05-12 13:33:25.377587','2025-05-13 13:33:25.000000',2,'2e3eb8902b634a529c0be7d631d05d03'),(11,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc0NzE0NDE3NCwiaWF0IjoxNzQ3MDU3Nzc0LCJqdGkiOiJiZTlhYzFlM2JmOWI0NjdlOGM0NTA0Y2VjY2Q0ZGU1NCIsInVzZXJfaWQiOjJ9.WbMAVFVcyBFL8-12TJXKFRH_-MUMCMB822KdS85S2KE','2025-05-12 13:49:34.370858','2025-05-13 13:49:34.000000',2,'be9ac1e3bf9b467e8c4504ceccd4de54'),(12,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc0NzE0NDE3NCwiaWF0IjoxNzQ3MDU3Nzc0LCJqdGkiOiI1MWRiNDU2NGQ3OWQ0ZjgyOGMzZmUxMWU1NTk4OTQ1YyIsInVzZXJfaWQiOjJ9._7eavllmL-kNS4ft-R659SZ2C7mh00nclRg8VlKMWr0','2025-05-12 13:49:34.368892','2025-05-13 13:49:34.000000',2,'51db4564d79d4f828c3fe11e5598945c'),(13,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc0NzE0ODM0MiwiaWF0IjoxNzQ3MDYxOTQyLCJqdGkiOiJiY2ZlOTM5MDJiZWM0NmNmYmYwYTAyOWZjNTFlOTRmYSIsInVzZXJfaWQiOjF9.d3JWO4tWG4PIGyJrks1CsVbOOr7oAtMRHWPI_8R_UB8','2025-05-12 14:59:02.830271','2025-05-13 14:59:02.000000',1,'bcfe93902bec46cfbf0a029fc51e94fa'),(14,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc0NzE0ODM1NSwiaWF0IjoxNzQ3MDYxOTU1LCJqdGkiOiJhMThmMzUzZmI3YjA0Y2NlOGZjMWM0Y2M1YjI3NDYxOSIsInVzZXJfaWQiOjJ9.Zb3GBOHQm6XR7rK8yX0PFNwvLxFFlo9ZHaXXKkxKx_Q','2025-05-12 14:59:15.267953','2025-05-13 14:59:15.000000',2,'a18f353fb7b04cce8fc1c4cc5b274619'),(15,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc0NzE0OTQwOSwiaWF0IjoxNzQ3MDYzMDA5LCJqdGkiOiIyMWM0MDM5ZjVkZmE0NDBmODg5N2Y1YzUxZWFhOTRmNyIsInVzZXJfaWQiOjJ9.tXdzFnZJXKfv-jbgYxISjc3BkrvpUWKucAs0FI0fTJs','2025-05-12 15:16:49.361968','2025-05-13 15:16:49.000000',2,'21c4039f5dfa440f8897f5c51eaa94f7'),(16,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc0NzE0OTQwOSwiaWF0IjoxNzQ3MDYzMDA5LCJqdGkiOiJkY2U5ZWI1OThlNWY0ZTU5YWY0YmU5MjQ4NmI5YjUzMSIsInVzZXJfaWQiOjJ9.lAiW7njXmdtjuWFW0ulcfoDE3SpYR0be2o-zXlV3GXE','2025-05-12 15:16:49.364967','2025-05-13 15:16:49.000000',2,'dce9eb598e5f4e59af4be92486b9b531'),(17,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc0NzE0OTUwMiwiaWF0IjoxNzQ3MDYzMTAyLCJqdGkiOiJiYjM2OThmNzQxZmQ0NDU3YjMwMTI0MDRlYWU4OWI5NCIsInVzZXJfaWQiOjJ9.Ig5tQ8RLUTwan3zR9TDMj5hIg4r2ObPZFEc4vGlgcdM','2025-05-12 15:18:22.321783','2025-05-13 15:18:22.000000',2,'bb3698f741fd4457b3012404eae89b94'),(18,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc0NzE1MDQ4MSwiaWF0IjoxNzQ3MDY0MDgxLCJqdGkiOiIxOTY0NWRmY2VkNTg0MjAzOTJjMzZhNzUxZTEwNTgxZSIsInVzZXJfaWQiOjJ9.SORWcFPCYltxxRTAou2iZtuaIYZ0rAgOCSjjuD_fGfw','2025-05-12 15:34:41.626408','2025-05-13 15:34:41.000000',2,'19645dfced58420392c36a751e10581e'),(19,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc0NzU3NDYyOCwiaWF0IjoxNzQ3NDg4MjI4LCJqdGkiOiJkZWRiNDU5ZDJlMjY0MDNiYTQxNGIzMzhjY2UwZWE0YSIsInVzZXJfaWQiOjF9.vz_JiyoMi21IVC-_4BhX6P2WwNrI7Gu89m1TirYfCYo','2025-05-17 13:23:48.382380','2025-05-18 13:23:48.000000',1,'dedb459d2e26403ba414b338cce0ea4a'),(20,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc0NzU3NTIyMCwiaWF0IjoxNzQ3NDg4ODIwLCJqdGkiOiI3MzNkMmEzMWI3M2I0MmYxOTg4YzgyNGM0Yjg0MzMzZSIsInVzZXJfaWQiOjF9.oC6XYcQfvpRK6nDTY1W6ZyFZ6FBlBU4x9fLU7eT0Q1c','2025-05-17 13:33:40.157708','2025-05-18 13:33:40.000000',1,'733d2a31b73b42f1988c824c4b84333e'),(21,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc0NzY2NDE0OSwiaWF0IjoxNzQ3NTc3NzQ5LCJqdGkiOiI3Y2IzYjY1ZTk4MGQ0MWQxOGY5OGMyMTE5Y2Q5NTA5OCIsInVzZXJfaWQiOjF9.Y2gE7C6YHKZ8xaPHbimi5HaoY_RQ5CIugIy3bCTpL-I','2025-05-18 14:15:49.633566','2025-05-19 14:15:49.000000',1,'7cb3b65e980d41d18f98c2119cd95098'),(22,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc0NzY2NjQ0OCwiaWF0IjoxNzQ3NTgwMDQ4LCJqdGkiOiI2Y2E0N2Y3MjhiMDk0NzUyYmY2Mzc5NDY2ZTE4OTI0MCIsInVzZXJfaWQiOjF9.18u41eBu7XgTQQeKlkpEAt5MaO3FI6tzEcVTLemfj_s','2025-05-18 14:54:08.645175','2025-05-19 14:54:08.000000',1,'6ca47f728b094752bf6379466e189240'),(23,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc0NzY2NjcyNCwiaWF0IjoxNzQ3NTgwMzI0LCJqdGkiOiI2ZWJkNGU3YzljZmE0YjE1ODMwODdkMTQ0ZWY2NjgxYyIsInVzZXJfaWQiOjF9.ifQUBSKHhekeAlKhtHo-PGx-rPtKgt_JD5bJUARk0Vo','2025-05-18 14:58:44.029880','2025-05-19 14:58:44.000000',1,'6ebd4e7c9cfa4b1583087d144ef6681c'),(24,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc0Nzc1MjY1NSwiaWF0IjoxNzQ3NjY2MjU1LCJqdGkiOiIwMTI5ZGQ5NDM1NzU0OGNiYjE4YzU4OTVkYTQxMTQzNiIsInVzZXJfaWQiOjF9.xFr9UYXckUc0NKE4I3m81hx7uiVWFj17Tnb5Gl40QMw','2025-05-19 14:50:55.758943','2025-05-20 14:50:55.000000',1,'0129dd94357548cbb18c5895da411436');
/*!40000 ALTER TABLE `token_blacklist_outstandingtoken` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `useraddresses`
--

DROP TABLE IF EXISTS `useraddresses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `useraddresses` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `title` varchar(20) DEFAULT NULL,
  `receiver` varchar(20) NOT NULL,
  `place` varchar(50) NOT NULL,
  `mobile` varchar(10) NOT NULL,
  `tel` varchar(20) DEFAULT NULL,
  `email` varchar(254) DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `city_id` bigint NOT NULL,
  `district_id` bigint NOT NULL,
  `postal_code_id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `useraddresses_city_id_8af85d1b_fk_areas_region_id` (`city_id`),
  KEY `useraddresses_district_id_eb24fac9_fk_areas_region_id` (`district_id`),
  KEY `useraddresses_postal_code_id_345cc424_fk_areas_region_id` (`postal_code_id`),
  KEY `useraddresses_user_id_f45829d7_fk_users_id` (`user_id`),
  CONSTRAINT `useraddresses_city_id_8af85d1b_fk_areas_region_id` FOREIGN KEY (`city_id`) REFERENCES `areas_region` (`id`),
  CONSTRAINT `useraddresses_district_id_eb24fac9_fk_areas_region_id` FOREIGN KEY (`district_id`) REFERENCES `areas_region` (`id`),
  CONSTRAINT `useraddresses_postal_code_id_345cc424_fk_areas_region_id` FOREIGN KEY (`postal_code_id`) REFERENCES `areas_region` (`id`),
  CONSTRAINT `useraddresses_user_id_f45829d7_fk_users_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `useraddresses`
--

LOCK TABLES `useraddresses` WRITE;
/*!40000 ALTER TABLE `useraddresses` DISABLE KEYS */;
INSERT INTO `useraddresses` VALUES (1,'蔡大茲','蔡大衣','台南路5號','0912345678','0000000','a123@gmail.com',0,'2025-05-12 13:24:34.205302','2025-05-12 15:43:58.401722',17,248,622,2),(2,'林俊傑','林俊傑','茄萣路5號','0912345678','','',1,'2025-05-12 13:29:42.811194','2025-05-12 13:34:45.923329',18,322,696,2),(3,'周杰倫','周杰倫','杰倫路5號','0912345678','','',1,'2025-05-12 13:30:19.164988','2025-05-12 13:30:31.007793',20,328,702,2),(4,'林大叔','林大叔','北門路5號','0912345678','','',1,'2025-05-12 13:33:57.151364','2025-05-12 13:37:35.509113',17,249,623,2),(5,'孫小童','孫燕姿','月天祿8號','0912345678','0622222222','A123456@GMAIL.COM',0,'2025-05-12 13:34:40.603769','2025-05-12 15:04:38.998273',17,251,625,2),(6,'方大同','方大同','路族路8號','0911111111','','',1,'2025-05-12 13:38:15.951525','2025-05-12 13:45:06.551339',16,234,608,2),(7,'林大','周杰文','田中路6665號','0912345678','0612345678','',1,'2025-05-12 13:45:00.981172','2025-05-12 15:12:29.751075',12,183,557,2),(8,'大中小','大中小','小小路4號','0912345678','','test@gmail.com',1,'2025-05-12 13:45:31.627301','2025-05-12 13:47:19.558502',17,262,636,2),(9,'蔡小提','蔡小提','安平路88號','0912345678','','',1,'2025-05-12 15:12:52.768288','2025-05-12 15:45:06.486045',17,250,624,2),(10,'王曉明xxx','王曉明','路族路8號','0911111111','','',1,'2025-05-17 13:33:58.910775','2025-05-17 13:34:08.443586',1,27,401,1),(11,'林憶蓮','林憶蓮','路族路8號','0911111111','','',0,'2025-05-17 13:34:16.205054','2025-05-17 13:34:16.205054',5,80,454,1),(12,'王大','王大','路族路8號','0911111111','','',0,'2025-05-18 14:16:13.661975','2025-05-18 14:16:13.661975',1,25,399,1);
/*!40000 ALTER TABLE `useraddresses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  `mobile` varchar(10) NOT NULL,
  `email` varchar(254) NOT NULL,
  `email_is_active` tinyint(1) DEFAULT NULL,
  `default_address_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `mobile` (`mobile`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `default_address_id` (`default_address_id`),
  CONSTRAINT `users_default_address_id_aed6e254_fk_useraddresses_id` FOREIGN KEY (`default_address_id`) REFERENCES `useraddresses` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'',NULL,0,'a2625801','','',0,1,'2025-05-11 17:08:08.231909','0976202920','a0976202920@gmail.com',1,10),(2,'pbkdf2_sha256$1000000$3X1CMoPEB98fnbDofi1P4d$bis/nC4YV5aPFk5E/y+UhcF1RQ+HKJnomTEwVo2Y9w4=','2025-05-17 15:52:21.507801',0,'as402023','','',0,1,'2025-05-12 13:08:10.562024','0976111111','hellendjango@gmail.com',1,5),(3,'pbkdf2_sha256$1000000$Z8dKJhlDGH1CMq35MeiAWQ$F0FcFU+mlIgH0XWxhLvmRusOzghBVCTNK/vCpYPlLkw=','2025-05-19 13:26:21.571956',1,'hellen','','',1,1,'2025-05-17 15:53:57.275349','','cxsuting@gmail.com',0,NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users_groups`
--

DROP TABLE IF EXISTS `users_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users_groups` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `group_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_groups_user_id_group_id_fc7788e8_uniq` (`user_id`,`group_id`),
  KEY `users_groups_group_id_2f3517aa_fk_auth_group_id` (`group_id`),
  CONSTRAINT `users_groups_group_id_2f3517aa_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `users_groups_user_id_f500bee5_fk_users_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_groups`
--

LOCK TABLES `users_groups` WRITE;
/*!40000 ALTER TABLE `users_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `users_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users_user_permissions`
--

DROP TABLE IF EXISTS `users_user_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users_user_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_user_permissions_user_id_permission_id_3b86cbdf_uniq` (`user_id`,`permission_id`),
  KEY `users_user_permissio_permission_id_6d08dcd2_fk_auth_perm` (`permission_id`),
  CONSTRAINT `users_user_permissio_permission_id_6d08dcd2_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `users_user_permissions_user_id_92473840_fk_users_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_user_permissions`
--

LOCK TABLES `users_user_permissions` WRITE;
/*!40000 ALTER TABLE `users_user_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `users_user_permissions` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-05-22 15:28:26
