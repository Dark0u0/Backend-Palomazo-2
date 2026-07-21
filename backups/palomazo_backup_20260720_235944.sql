-- MySQL dump 10.13  Distrib 8.0.42, for Linux (x86_64)
--
-- Host: thomas.proxy.rlwy.net    Database: railway
-- ------------------------------------------------------
-- Server version	9.4.0

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
-- Current Database: `railway`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `railway` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `railway`;

--
-- Table structure for table `Genero`
--

DROP TABLE IF EXISTS `Genero`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Genero` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `Genero_nombre_key` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Genero`
--

LOCK TABLES `Genero` WRITE;
/*!40000 ALTER TABLE `Genero` DISABLE KEYS */;
INSERT INTO `Genero` VALUES (9,'Banda'),(4,'Blues'),(19,'Bossa Nova'),(17,'Clásica'),(7,'Cumbia'),(10,'Electrónica'),(18,'Flamenco'),(14,'Funk'),(11,'Hip Hop'),(16,'Indie'),(3,'Jazz'),(15,'Metal'),(8,'Norteño'),(2,'Pop'),(12,'R&B'),(5,'Reggae'),(1,'Rock'),(6,'Salsa'),(13,'Soul'),(20,'Tropical');
/*!40000 ALTER TABLE `Genero` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Local`
--

DROP TABLE IF EXISTS `Local`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Local` (
  `id` int NOT NULL AUTO_INCREMENT,
  `usuarioId` int NOT NULL,
  `nombreNegocio` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ubicacion` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text COLLATE utf8mb4_unicode_ci,
  `foto` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `galeria` json DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `Local_usuarioId_key` (`usuarioId`),
  CONSTRAINT `Local_usuarioId_fkey` FOREIGN KEY (`usuarioId`) REFERENCES `Usuario` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Local`
--

LOCK TABLES `Local` WRITE;
/*!40000 ALTER TABLE `Local` DISABLE KEYS */;
INSERT INTO `Local` VALUES (1,2,'Lo que sea 2','Playa del Carmen','ABAGUDFSBKA DSVLGÑONDV N,JSLSD.Ñ BVÑIAU HPHBKJ\nJHFJHAFBGLKSRBDV HJAVU',NULL,NULL),(2,6,'Prueba liberacion pago y reseña','Playa del Carmen','prueba',NULL,NULL);
/*!40000 ALTER TABLE `Local` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Musico`
--

DROP TABLE IF EXISTS `Musico`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Musico` (
  `id` int NOT NULL AUTO_INCREMENT,
  `usuarioId` int NOT NULL,
  `nombreArtistico` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `foto` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `biografia` text COLLATE utf8mb4_unicode_ci,
  `precioPorHora` decimal(10,2) NOT NULL,
  `localidad` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `galeria` json DEFAULT NULL,
  `stripeAccountId` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `Musico_usuarioId_key` (`usuarioId`),
  CONSTRAINT `Musico_usuarioId_fkey` FOREIGN KEY (`usuarioId`) REFERENCES `Usuario` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Musico`
--

LOCK TABLES `Musico` WRITE;
/*!40000 ALTER TABLE `Musico` DISABLE KEYS */;
INSERT INTO `Musico` VALUES (1,1,'Los de jalisco',NULL,',bjdshgbvdjkgfjksbf.ugsdLGBJFHUKGAÑ-ILFBJ,A\nJKGDflvj.,bvgulcgkjv bjkhfdvgbljbvj.hgvñodsl\nsdvdbjkbvd ,bsLIGVBKLBVDS.hvfl-bsvk.bvrsv\nnmsdvbj ,nsjvlBJV M.SBVIKBS.V -LKABPVDB NBVJKLVdsl-kñf\nSNdjifvKSV KLVIGIFBFK.BSVIPGVKB VI{VBSV\nVBSkdvbVJLBSVFlksd bvk.bsidhvbñl- S,KHIFEAO.',50.00,'Playa del carmen',NULL,'acct_1TtUnr35PuAp9tEX'),(2,3,'lo se prueba',NULL,'jkshudyFNLYGI8SPHIFSAN',100.00,'Playa del Carmen',NULL,NULL),(3,4,'Gabo UTRM',NULL,',lkahf,b,hjafb',100.00,'Playa del carmen',NULL,NULL),(4,5,'Dangel','https://res.cloudinary.com/dz3cc935x/image/upload/v1784508809/palomazo/kbpaxttioq3zgjc0ku29.jpg','Soy la musica',1500.00,'Playa del carmen','[]','acct_1Tv7Dv3TAzDLjDqN');
/*!40000 ALTER TABLE `Musico` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `MusicoGenero`
--

DROP TABLE IF EXISTS `MusicoGenero`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `MusicoGenero` (
  `musicoId` int NOT NULL,
  `generoId` int NOT NULL,
  PRIMARY KEY (`musicoId`,`generoId`),
  KEY `MusicoGenero_generoId_fkey` (`generoId`),
  CONSTRAINT `MusicoGenero_generoId_fkey` FOREIGN KEY (`generoId`) REFERENCES `Genero` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `MusicoGenero_musicoId_fkey` FOREIGN KEY (`musicoId`) REFERENCES `Musico` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `MusicoGenero`
--

LOCK TABLES `MusicoGenero` WRITE;
/*!40000 ALTER TABLE `MusicoGenero` DISABLE KEYS */;
INSERT INTO `MusicoGenero` VALUES (4,1),(4,2),(4,3),(1,4),(3,5),(3,8),(1,9),(4,16),(2,17),(2,18),(4,19);
/*!40000 ALTER TABLE `MusicoGenero` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Notificacion`
--

DROP TABLE IF EXISTS `Notificacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Notificacion` (
  `id` int NOT NULL AUTO_INCREMENT,
  `usuarioId` int NOT NULL,
  `solicitudId` int DEFAULT NULL,
  `tipo` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `mensaje` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `leida` tinyint(1) NOT NULL DEFAULT '0',
  `creadoEn` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  KEY `Notificacion_usuarioId_fkey` (`usuarioId`),
  KEY `Notificacion_solicitudId_fkey` (`solicitudId`),
  CONSTRAINT `Notificacion_solicitudId_fkey` FOREIGN KEY (`solicitudId`) REFERENCES `Solicitud` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `Notificacion_usuarioId_fkey` FOREIGN KEY (`usuarioId`) REFERENCES `Usuario` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Notificacion`
--

LOCK TABLES `Notificacion` WRITE;
/*!40000 ALTER TABLE `Notificacion` DISABLE KEYS */;
INSERT INTO `Notificacion` VALUES (1,3,1,'nueva_solicitud','Tienes una nueva solicitud de contratación',0,'2026-07-20 03:02:17.713'),(2,6,1,'respuesta_solicitud','El músico aceptó tu solicitud',0,'2026-07-20 03:02:27.996'),(3,5,2,'nueva_solicitud','Tienes una nueva solicitud de contratación',0,'2026-07-20 03:05:42.164'),(4,1,3,'nueva_solicitud','Tienes una nueva solicitud de contratación',0,'2026-07-20 03:07:23.651'),(5,1,4,'nueva_solicitud','Tienes una nueva solicitud de contratación',0,'2026-07-20 03:08:42.966'),(6,2,4,'respuesta_solicitud','El músico aceptó tu solicitud',0,'2026-07-20 03:09:06.884'),(7,1,5,'nueva_solicitud','Tienes una nueva solicitud de contratación',0,'2026-07-20 03:20:11.358'),(8,2,5,'respuesta_solicitud','El músico aceptó tu solicitud',0,'2026-07-20 03:20:44.248'),(9,2,3,'respuesta_solicitud','El músico aceptó tu solicitud',0,'2026-07-20 03:20:45.280'),(10,1,6,'nueva_solicitud','Tienes una nueva solicitud de contratación',0,'2026-07-20 03:27:47.932');
/*!40000 ALTER TABLE `Notificacion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Pago`
--

DROP TABLE IF EXISTS `Pago`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Pago` (
  `id` int NOT NULL AUTO_INCREMENT,
  `solicitudId` int NOT NULL,
  `monto` decimal(10,2) NOT NULL,
  `montoRetenido` decimal(10,2) NOT NULL,
  `montoLiberado` decimal(10,2) NOT NULL DEFAULT '0.00',
  `estado` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'retenido',
  `mpPagoId` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `musicoLlego` tinyint(1) NOT NULL DEFAULT '0',
  `fechaPago` datetime(3) DEFAULT NULL,
  `creadoEn` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `resenado` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `Pago_solicitudId_key` (`solicitudId`),
  CONSTRAINT `Pago_solicitudId_fkey` FOREIGN KEY (`solicitudId`) REFERENCES `Solicitud` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Pago`
--

LOCK TABLES `Pago` WRITE;
/*!40000 ALTER TABLE `Pago` DISABLE KEYS */;
INSERT INTO `Pago` VALUES (1,1,330.00,0.00,330.00,'liberado','ch_3Tv7Tk48Rus60lbU2MAAAhIR',1,'2026-07-20 03:02:54.809','2026-07-20 03:02:54.810',1),(2,4,165.00,97.50,52.50,'parcial','ch_3Tv7e848Rus60lbU2fbPzXXY',0,'2026-07-20 03:13:39.690','2026-07-20 03:13:39.694',0),(3,5,165.00,0.00,165.00,'liberado','ch_3Tv7m748Rus60lbU1mKFjaPF',1,'2026-07-20 03:21:54.694','2026-07-20 03:21:54.695',0),(4,3,165.00,0.00,165.00,'liberado','ch_3Tv7sv48Rus60lbU1fjqgS5K',1,'2026-07-20 03:28:56.734','2026-07-20 03:28:56.735',0);
/*!40000 ALTER TABLE `Pago` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`%`*/ /*!50003 TRIGGER `trg_un_pago_por_solicitud` BEFORE INSERT ON `Pago` FOR EACH ROW BEGIN
    DECLARE v_existe INT;

    SELECT COUNT(*) INTO v_existe
    FROM Pago
    WHERE solicitudId = NEW.solicitudId;

    IF v_existe > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Ya existe un pago registrado para esta solicitud';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `Resena`
--

DROP TABLE IF EXISTS `Resena`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Resena` (
  `id` int NOT NULL AUTO_INCREMENT,
  `localId` int NOT NULL,
  `musicoId` int NOT NULL,
  `calificacion` int NOT NULL,
  `comentario` text COLLATE utf8mb4_unicode_ci,
  `creadoEn` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  KEY `Resena_localId_fkey` (`localId`),
  KEY `Resena_musicoId_fkey` (`musicoId`),
  CONSTRAINT `Resena_localId_fkey` FOREIGN KEY (`localId`) REFERENCES `Local` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `Resena_musicoId_fkey` FOREIGN KEY (`musicoId`) REFERENCES `Musico` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Resena`
--

LOCK TABLES `Resena` WRITE;
/*!40000 ALTER TABLE `Resena` DISABLE KEYS */;
INSERT INTO `Resena` VALUES (1,2,2,4,'Prubea de reseñas','2026-07-20 03:04:08.913');
/*!40000 ALTER TABLE `Resena` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`%`*/ /*!50003 TRIGGER `trg_validar_calificacion` BEFORE INSERT ON `Resena` FOR EACH ROW BEGIN
    IF NEW.calificacion < 1 OR NEW.calificacion > 5 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La calificación debe estar entre 1 y 5';
    END IF;

    IF LENGTH(NEW.comentario) > 500 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El comentario no puede superar 500 caracteres';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `Rol`
--

DROP TABLE IF EXISTS `Rol`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Rol` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `Rol_nombre_key` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Rol`
--

LOCK TABLES `Rol` WRITE;
/*!40000 ALTER TABLE `Rol` DISABLE KEYS */;
INSERT INTO `Rol` VALUES (2,'local'),(1,'musico');
/*!40000 ALTER TABLE `Rol` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Solicitud`
--

DROP TABLE IF EXISTS `Solicitud`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Solicitud` (
  `id` int NOT NULL AUTO_INCREMENT,
  `localId` int NOT NULL,
  `musicoId` int NOT NULL,
  `fecha` datetime(3) NOT NULL,
  `estado` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pendiente',
  `creadoEn` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `comisionApp` decimal(10,2) NOT NULL,
  `duracionHoras` int NOT NULL,
  `horaFin` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `horaInicio` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `montoMusico` decimal(10,2) NOT NULL,
  `montoTotal` decimal(10,2) NOT NULL,
  `tipoEvento` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `notas` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `Solicitud_localId_fkey` (`localId`),
  KEY `Solicitud_musicoId_fkey` (`musicoId`),
  CONSTRAINT `Solicitud_localId_fkey` FOREIGN KEY (`localId`) REFERENCES `Local` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `Solicitud_musicoId_fkey` FOREIGN KEY (`musicoId`) REFERENCES `Musico` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Solicitud`
--

LOCK TABLES `Solicitud` WRITE;
/*!40000 ALTER TABLE `Solicitud` DISABLE KEYS */;
INSERT INTO `Solicitud` VALUES (1,2,2,'2026-07-28 00:00:00.000','pagada','2026-07-20 03:02:17.689',30.00,3,'00:00','21:00',300.00,330.00,NULL,'El músico debe llegar 2 horas antes de la hora de inicio para la prueba de sonido.'),(2,1,4,'2026-07-01 00:00:00.000','pendiente','2026-07-20 03:05:42.136',450.00,3,'00:00','21:00',4500.00,4950.00,NULL,'El músico debe llegar 2 horas antes de la hora de inicio para la prueba de sonido.'),(3,1,1,'2026-07-22 00:00:00.000','pagada','2026-07-20 03:07:23.626',15.00,3,'00:00','21:00',150.00,165.00,NULL,'El músico debe llegar 2 horas antes de la hora de inicio para la prueba de sonido.'),(4,1,1,'2026-07-28 00:00:00.000','pagada','2026-07-20 03:08:42.940',15.00,3,'00:00','21:00',150.00,165.00,NULL,'El músico debe llegar 2 horas antes de la hora de inicio para la prueba de sonido.'),(5,1,1,'2026-07-21 00:00:00.000','pagada','2026-07-20 03:20:11.329',15.00,3,'00:00','21:00',150.00,165.00,NULL,'El músico debe llegar 2 horas antes de la hora de inicio para la prueba de sonido.'),(6,1,1,'2026-07-22 00:00:00.000','pendiente','2026-07-20 03:27:47.901',15.00,3,'00:00','21:00',150.00,165.00,NULL,'El músico debe llegar 2 horas antes de la hora de inicio para la prueba de sonido.');
/*!40000 ALTER TABLE `Solicitud` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`%`*/ /*!50003 TRIGGER `trg_calcular_monto_total` BEFORE INSERT ON `Solicitud` FOR EACH ROW BEGIN
    IF NEW.montoTotal = 0 OR NEW.montoTotal IS NULL THEN
        SET NEW.montoTotal = NEW.montoMusico + NEW.comisionApp;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `Usuario`
--

DROP TABLE IF EXISTS `Usuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Usuario` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `creadoEn` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `telefono` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `rolId` int NOT NULL,
  `sessionToken` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `resetToken` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `resetTokenExpira` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `Usuario_email_key` (`email`),
  KEY `Usuario_rolId_fkey` (`rolId`),
  CONSTRAINT `Usuario_rolId_fkey` FOREIGN KEY (`rolId`) REFERENCES `Rol` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Usuario`
--

LOCK TABLES `Usuario` WRITE;
/*!40000 ALTER TABLE `Usuario` DISABLE KEYS */;
INSERT INTO `Usuario` VALUES (1,'Kevin Coleaza','kevin@gmail.com','$2b$10$8QY2FhulAjufky8L4FcOmuGyCXB.BWkM0gKXqgsC9zYL1.LdArHGO','2026-07-15 15:32:34.529','154751238165',1,1,NULL,NULL,NULL),(2,'Markus','kevs@gmail.com','$2b$10$6Ls6TOvCCo7H5Coczo6B6OkZp7aWKzAdc9iniWEyONX4l0KfHruuu','2026-07-15 15:43:14.325','25865216844',1,2,NULL,NULL,NULL),(3,'dangel','markus@gmail.com','$2b$10$zFKXbWo.mX/NiV7JKdzS7eD0KzMdIS6cl7CTJyiEWfMmPaIOrIqje','2026-07-15 16:00:47.685','6548103785',1,1,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Mywicm9sIjoibXVzaWNvIiwiaWF0IjoxNzg0NjA3NzA4LCJleHAiOjE3ODUyMTI1MDh9.Z2scqBFRGD9PEGx4S8guNTavuVfDe1RDoz4w2FMk3Po',NULL,NULL),(4,'Gabriel','gabo@gmail.com','$2b$10$SBR40Pu/SwEZ03n9Aqp9xemTdWdGESbKSp2EcJ3gAnH1mYxWVldRO','2026-07-15 16:01:46.074','3554524444556',1,1,NULL,NULL,NULL),(5,'Angel Daniel Villanueva Canul','dangeluwu@gmail.com','$2b$10$QQfS1b4xS8hiquY/72.ijewUkDUWKcVjB0YdCLTKKkzX9NqLEbmXa','2026-07-20 00:51:03.387','9843197845',1,1,NULL,NULL,NULL),(6,'Kevin','nose@gmail.com','$2b$10$O.lCFOjrsqYaRtU6LlBK0OimrLwakQrZ.qTAEKJwjX0S7M5.IG4Xq','2026-07-20 03:01:11.239','4794135647846',1,2,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Niwicm9sIjoibG9jYWwiLCJpYXQiOjE3ODQ1MTY0NzYsImV4cCI6MTc4NTEyMTI3Nn0.eD-hkqjkwAr5HeCjDZp7Zpb_27cq_u3KctK8B7mXeHk',NULL,NULL);
/*!40000 ALTER TABLE `Usuario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `_prisma_migrations`
--

DROP TABLE IF EXISTS `_prisma_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `_prisma_migrations` (
  `id` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `checksum` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `finished_at` datetime(3) DEFAULT NULL,
  `migration_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `logs` text COLLATE utf8mb4_unicode_ci,
  `rolled_back_at` datetime(3) DEFAULT NULL,
  `started_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `applied_steps_count` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `_prisma_migrations`
--

LOCK TABLES `_prisma_migrations` WRITE;
/*!40000 ALTER TABLE `_prisma_migrations` DISABLE KEYS */;
INSERT INTO `_prisma_migrations` VALUES ('16db2020-a154-4207-bf3c-cadb0691361f','ac497200b7b6372746c6127eb11a2dd91ebe887538bfd003c29925ef815bacce','2026-07-15 14:26:07.554','20260630062742_add_galeria_local',NULL,NULL,'2026-07-15 14:26:06.215',1),('519369a8-c2c7-4ce3-9f7a-485405e4fe1a','3c65bce8f2deb4fc72b36486d88aab0e8441535a8848a2625a8d00f44d8e0cc5','2026-07-15 14:25:55.176','20260609025722_init',NULL,NULL,'2026-07-15 14:25:52.290',1),('6666643b-8a90-4d98-9401-3f11dfa24e67','c6963d33800e15b3234ab2bf4aaa55022eebef26fac913684ed50dd85003c633','2026-07-15 14:26:17.365','20260702070240_add_reset_password',NULL,NULL,'2026-07-15 14:26:16.138',1),('6a1854d2-d33e-4407-87e5-be720c37c769','f8794f188a6642dbec2b6f4fac151353caeecdcb7032258c5969a6570effdb8f','2026-07-15 14:26:09.311','20260630110410_solicitudes_sin_chat',NULL,NULL,'2026-07-15 14:26:07.746',1),('85fe7b0c-0733-494c-a61e-b4f89c4ed7e9','4d82cf627ff6782fc23873e57e4cf53b0aeeb8f993fdb088fa1dab46a913e1f9','2026-07-15 14:26:19.023','20260709135206_add_stripe_account_musico',NULL,NULL,'2026-07-15 14:26:17.606',1),('97fea2b4-a81c-4562-a74e-e0d668ef4822','f060f470ccbb37281025f1aff34eb90186d70daca820f5937ae116965825f97d','2026-07-15 14:26:14.117','20260702042504_add_session_token',NULL,NULL,'2026-07-15 14:26:12.281',1),('983495a2-bc74-44fa-b764-bce6f8281a39','b3bffdca28fcb659f239cac4a0f70c0cc17240b43570137acf434638d6b11287','2026-07-15 14:26:15.746','20260702052440_add_resenado_pago',NULL,NULL,'2026-07-15 14:26:14.475',1),('99bec1ae-3166-482b-af2a-f3bac7f8b0d7','bf9f6a2ffb2be750162a73c46637f03c6b4d6435f86f567c94e6f2101b8871de','2026-07-15 14:26:11.523','20260630111411_add_notas_solicitud',NULL,NULL,'2026-07-15 14:26:10.075',1),('9cd22bb7-286a-411f-a75d-edf540ff5eb5','f97a7d9a1456f66f76fa3923477a2b014464f94f69ee498b6a654f8ddce79a24','2026-07-15 14:25:58.847','20260609030253_agregar_telefono_rol',NULL,NULL,'2026-07-15 14:25:56.107',1),('bc702e06-bcbd-4e6d-b652-ad2324ca0ba8','b7983c1f45f1cdf45ae47c67a84dabbab3843d2affa79ac4ac10f7e32c8d85b5','2026-07-15 14:26:06.021','20260630044307_add_galeria_musico',NULL,NULL,'2026-07-15 14:26:04.778',1),('be836ca7-093c-493a-b82e-c46c6b6c4fd8','22d69bb5a5a37e17531f6773db7cc6d480156ed70721ccd40fda9e8e82af5465','2026-07-15 14:26:01.843','20260626024851_estructura_completa',NULL,NULL,'2026-07-15 14:25:58.963',1),('fa1702bd-349e-4d53-b0e1-c64cd887fcc4','7a0241fa5305405e691c339a11d9936c8b2d422cb9e85a1998634fd41743b449','2026-07-15 14:26:04.425','20260626031201_agregar_generos',NULL,NULL,'2026-07-15 14:26:02.609',1);
/*!40000 ALTER TABLE `_prisma_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'railway'
--
/*!50003 DROP FUNCTION IF EXISTS `fn_calificacion_promedio_musico` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` FUNCTION `fn_calificacion_promedio_musico`(p_musicoId INT) RETURNS decimal(3,2)
    READS SQL DATA
    DETERMINISTIC
BEGIN
    DECLARE v_promedio DECIMAL(3,2);

    SELECT ROUND(AVG(calificacion), 2) INTO v_promedio
    FROM Resena
    WHERE musicoId = p_musicoId;

    RETURN IFNULL(v_promedio, 0.00);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fn_musico_disponible` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` FUNCTION `fn_musico_disponible`(
    p_musicoId   INT,
    p_fecha      DATE,
    p_horaInicio VARCHAR(10),
    p_horaFin    VARCHAR(10)
) RETURNS tinyint(1)
    READS SQL DATA
    DETERMINISTIC
BEGIN
    DECLARE v_conflictos INT;

    SELECT COUNT(*) INTO v_conflictos
    FROM Solicitud
    WHERE musicoId  = p_musicoId
      AND DATE(fecha) = p_fecha
      AND estado NOT IN ('rechazada', 'cancelada')
      AND (p_horaInicio < horaFin AND p_horaFin > horaInicio);

    RETURN IF(v_conflictos > 0, FALSE, TRUE);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fn_total_shows_local` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` FUNCTION `fn_total_shows_local`(p_localId INT) RETURNS int
    READS SQL DATA
    DETERMINISTIC
BEGIN
    DECLARE v_total INT;

    SELECT COUNT(*) INTO v_total
    FROM Solicitud
    WHERE localId = p_localId
      AND estado NOT IN ('rechazada', 'cancelada');

    RETURN IFNULL(v_total, 0);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_cancelar_cuenta_usuario` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_cancelar_cuenta_usuario`(
    IN p_usuarioId INT
)
BEGIN
    UPDATE Usuario
    SET activo = FALSE, sessionToken = NULL
    WHERE id = p_usuarioId;

    UPDATE Solicitud s
    INNER JOIN Local l ON l.id = s.localId
    SET s.estado = 'cancelada'
    WHERE l.usuarioId = p_usuarioId
      AND s.estado = 'pendiente';

    UPDATE Solicitud s
    INNER JOIN Musico m ON m.id = s.musicoId
    SET s.estado = 'cancelada'
    WHERE m.usuarioId = p_usuarioId
      AND s.estado = 'pendiente';
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_rechazar_solicitud_duplicada` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_rechazar_solicitud_duplicada`(
    IN p_localId   INT,
    IN p_musicoId  INT,
    IN p_fecha     DATE
)
BEGIN
    DECLARE v_existe INT;

    SELECT COUNT(*) INTO v_existe
    FROM Solicitud
    WHERE localId  = p_localId
      AND musicoId = p_musicoId
      AND DATE(fecha) = p_fecha
      AND estado NOT IN ('rechazada', 'cancelada');

    IF v_existe > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Ya existe una solicitud activa para este músico en esa fecha';
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_resumen_financiero_musico` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_resumen_financiero_musico`(
    IN p_musicoId INT
)
BEGIN
    SELECT
        COUNT(*)                        AS total_shows,
        COALESCE(SUM(p.montoLiberado + p.montoRetenido), 0) AS total_ganado,
        COALESCE(SUM(CASE WHEN MONTH(p.fechaPago) = MONTH(NOW())
                          AND YEAR(p.fechaPago)  = YEAR(NOW())
                          THEN p.montoLiberado + p.montoRetenido
                          ELSE 0 END), 0)        AS ganado_este_mes,
        COALESCE(SUM(CASE WHEN p.estado = 'liberado'
                          THEN p.montoLiberado ELSE 0 END), 0) AS ya_cobrado,
        COALESCE(SUM(CASE WHEN p.estado = 'parcial'
                          THEN p.montoRetenido ELSE 0 END), 0) AS pendiente_cobro
    FROM Pago p
    INNER JOIN Solicitud s ON s.id = p.solicitudId
    WHERE s.musicoId = p_musicoId;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-07-21  0:00:08
