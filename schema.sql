/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `commentron`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `commentron` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `commentron`;

--
-- Table structure for table `blocked_entry`
--

DROP TABLE IF EXISTS `blocked_entry`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `blocked_entry` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `blocked_channel_id` char(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `creator_channel_id` char(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `universally_blocked` tinyint(1) DEFAULT '0',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `blocked_list_id` bigint unsigned DEFAULT NULL,
  `delegated_moderator_channel_id` char(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `reason` mediumtext COLLATE utf8mb4_unicode_ci,
  `offending_comment_id` char(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `expiry` datetime DEFAULT NULL,
  `strikes` int DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `idx_blockedall` (`blocked_channel_id`,`creator_channel_id`,`universally_blocked`),
  KEY `idx_blocked_by` (`creator_channel_id`),
  KEY `idx_universal` (`universally_blocked`),
  KEY `fk_blocked_list` (`blocked_list_id`),
  KEY `fk_mod` (`delegated_moderator_channel_id`),
  KEY `fk_offending` (`offending_comment_id`),
  KEY `idx_blockedlist` (`blocked_channel_id`,`creator_channel_id`,`blocked_list_id`,`universally_blocked`),
  KEY `idx_expiry` (`expiry`),
  KEY `idx_strikes` (`strikes`),
  CONSTRAINT `blocked_entry_ibfk_1` FOREIGN KEY (`blocked_channel_id`) REFERENCES `channel` (`claim_id`),
  CONSTRAINT `blocked_entry_ibfk_2` FOREIGN KEY (`creator_channel_id`) REFERENCES `channel` (`claim_id`),
  CONSTRAINT `blocked_entry_ibfk_3` FOREIGN KEY (`blocked_list_id`) REFERENCES `blocked_list` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `blocked_entry_ibfk_4` FOREIGN KEY (`delegated_moderator_channel_id`) REFERENCES `channel` (`claim_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `blocked_entry_ibfk_5` FOREIGN KEY (`offending_comment_id`) REFERENCES `comment` (`comment_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `blocked_list`
--

DROP TABLE IF EXISTS `blocked_list`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `blocked_list` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `channel_id` char(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `category` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `description` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `member_invite_enabled` tinyint(1) DEFAULT '0',
  `strike_one` bigint unsigned DEFAULT NULL,
  `strike_two` bigint unsigned DEFAULT NULL,
  `strike_three` bigint unsigned DEFAULT NULL,
  `invite_expiration` bigint unsigned DEFAULT NULL,
  `curse_jar_amount` bigint unsigned DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_blocked_list_name` (`name`),
  KEY `idx_category` (`category`),
  KEY `idx_created_at` (`created_at`),
  KEY `idx_updated_at` (`updated_at`),
  KEY `fk_channel` (`channel_id`),
  CONSTRAINT `blocked_list_ibfk_1` FOREIGN KEY (`channel_id`) REFERENCES `channel` (`claim_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `blocked_list_appeal`
--

DROP TABLE IF EXISTS `blocked_list_appeal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `blocked_list_appeal` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `blocked_list_id` bigint unsigned DEFAULT NULL,
  `blocked_entry_id` bigint unsigned NOT NULL,
  `appeal` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `response` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `approved` tinyint(1) DEFAULT NULL,
  `escalated` tinyint(1) DEFAULT '0',
  `tx_id` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_appeal` (`blocked_list_id`,`approved`),
  KEY `idx_escalated` (`blocked_list_id`,`escalated`),
  KEY `idx_created_at` (`created_at`),
  KEY `idx_updated_at` (`updated_at`),
  KEY `fk_blocked_entry` (`blocked_entry_id`),
  CONSTRAINT `blocked_list_appeal_ibfk_1` FOREIGN KEY (`blocked_list_id`) REFERENCES `blocked_list` (`id`),
  CONSTRAINT `blocked_list_appeal_ibfk_2` FOREIGN KEY (`blocked_entry_id`) REFERENCES `blocked_entry` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `blocked_list_invite`
--

DROP TABLE IF EXISTS `blocked_list_invite`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `blocked_list_invite` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `blocked_list_id` bigint unsigned NOT NULL,
  `inviter_channel_id` char(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `invited_channel_id` char(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `accepted` tinyint(1) DEFAULT NULL,
  `message` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_unique_invite` (`blocked_list_id`,`inviter_channel_id`,`invited_channel_id`),
  KEY `idx_created_at` (`created_at`),
  KEY `idx_updated_at` (`updated_at`),
  KEY `fk_channel` (`inviter_channel_id`),
  KEY `fk_invited_channel` (`invited_channel_id`),
  CONSTRAINT `blocked_list_invite_ibfk_1` FOREIGN KEY (`blocked_list_id`) REFERENCES `blocked_list` (`id`),
  CONSTRAINT `blocked_list_invite_ibfk_2` FOREIGN KEY (`inviter_channel_id`) REFERENCES `channel` (`claim_id`),
  CONSTRAINT `blocked_list_invite_ibfk_3` FOREIGN KEY (`invited_channel_id`) REFERENCES `channel` (`claim_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `channel`
--

DROP TABLE IF EXISTS `channel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `channel` (
  `claim_id` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` char(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_spammer` tinyint(1) DEFAULT '0',
  `blocked_list_invite_id` bigint unsigned DEFAULT NULL,
  `blocked_list_id` bigint unsigned DEFAULT NULL,
  `sub` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`claim_id`),
  KEY `idx_is_spammer` (`is_spammer`),
  KEY `fk_invite` (`blocked_list_invite_id`),
  KEY `fk_blocked_list` (`blocked_list_id`),
  KEY `sub_idx` (`sub`,`claim_id`),
  CONSTRAINT `channel_ibfk_1` FOREIGN KEY (`blocked_list_invite_id`) REFERENCES `blocked_list` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `channel_ibfk_2` FOREIGN KEY (`blocked_list_id`) REFERENCES `blocked_list` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `comment`
--

DROP TABLE IF EXISTS `comment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `comment` (
  `comment_id` char(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `lbry_claim_id` char(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `channel_id` char(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `body` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `parent_id` char(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `signature` char(128) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `signingts` varchar(22) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `timestamp` int NOT NULL,
  `is_hidden` tinyint(1) DEFAULT '0',
  `is_pinned` tinyint(1) NOT NULL DEFAULT '0',
  `is_flagged` tinyint(1) NOT NULL DEFAULT '0',
  `amount` bigint unsigned DEFAULT NULL,
  `tx_id` varchar(70) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `popularity_score` int DEFAULT NULL,
  `controversy_score` int DEFAULT NULL,
  `is_fiat` tinyint(1) NOT NULL DEFAULT '0',
  `currency` varchar(25) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`comment_id`),
  KEY `parent_id` (`parent_id`),
  KEY `claim_comment_index` (`lbry_claim_id`,`comment_id`),
  KEY `channel_comment_index` (`channel_id`,`comment_id`),
  KEY `is_flagged_idx` (`is_flagged`),
  KEY `idx_amount` (`amount`),
  KEY `idx_comment_timestamp` (`lbry_claim_id`,`timestamp`),
  KEY `idx_comment_hidden` (`is_hidden`,`comment_id`,`timestamp`),
  KEY `idx_comment_popularity` (`lbry_claim_id`,`popularity_score`,`timestamp`),
  KEY `idx_comment_controversy` (`lbry_claim_id`,`controversy_score`,`timestamp`),
  KEY `idx_comment_fiat_amount` (`is_fiat`,`amount`,`currency`),
  KEY `idx_comment_is_fiat` (`is_fiat`,`timestamp`),
  KEY `idx_comment_is_fiat_by_claim` (`lbry_claim_id`,`is_fiat`,`timestamp`),
  CONSTRAINT `comment_ibfk_1` FOREIGN KEY (`channel_id`) REFERENCES `channel` (`claim_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `comment_ibfk_2` FOREIGN KEY (`parent_id`) REFERENCES `comment` (`comment_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `creator_setting`
--

DROP TABLE IF EXISTS `creator_setting`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `creator_setting` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `creator_channel_id` char(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `comments_enabled` tinyint(1) DEFAULT '0',
  `min_tip_amount_comment` bigint unsigned DEFAULT NULL,
  `min_tip_amount_super_chat` bigint unsigned DEFAULT NULL,
  `muted_words` text COLLATE utf8mb4_unicode_ci,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `slow_mode_min_gap` bigint unsigned DEFAULT NULL,
  `curse_jar_amount` bigint unsigned DEFAULT NULL,
  `is_filters_enabled` tinyint(1) DEFAULT NULL,
  `chat_overlay` tinyint(1) NOT NULL DEFAULT '1',
  `chat_overlay_position` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Left',
  `chat_remove_comment` bigint NOT NULL DEFAULT '30',
  `sticker_overlay` tinyint(1) NOT NULL DEFAULT '1',
  `sticker_overlay_keep` tinyint(1) NOT NULL DEFAULT '0',
  `sticker_overlay_remove` bigint NOT NULL DEFAULT '10',
  `viewercount_overlay` tinyint(1) NOT NULL DEFAULT '1',
  `viewercount_overlay_position` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Top Left',
  `viewercount_chat_bot` tinyint(1) NOT NULL DEFAULT '0',
  `tipgoal_overlay` tinyint(1) NOT NULL DEFAULT '1',
  `tipgoal_amount` bigint NOT NULL DEFAULT '1000',
  `tipgoal_overlay_position` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '1',
  `tipgoal_previous_donations` tinyint(1) NOT NULL DEFAULT '1',
  `tipgoal_currency` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'LBC',
  PRIMARY KEY (`id`),
  KEY `idx_comments_enabled` (`comments_enabled`),
  KEY `fk_creator_channel` (`creator_channel_id`),
  CONSTRAINT `creator_setting_ibfk_1` FOREIGN KEY (`creator_channel_id`) REFERENCES `channel` (`claim_id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `delegated_moderator`
--

DROP TABLE IF EXISTS `delegated_moderator`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `delegated_moderator` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `mod_channel_id` char(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `creator_channel_id` char(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `permissons` bigint unsigned NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_permissions` (`permissons`),
  KEY `fk_mod_channel` (`mod_channel_id`),
  KEY `fk_creator_channel` (`creator_channel_id`),
  CONSTRAINT `delegated_moderator_ibfk_1` FOREIGN KEY (`mod_channel_id`) REFERENCES `channel` (`claim_id`),
  CONSTRAINT `delegated_moderator_ibfk_2` FOREIGN KEY (`creator_channel_id`) REFERENCES `channel` (`claim_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gorp_migrations`
--

DROP TABLE IF EXISTS `gorp_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gorp_migrations` (
  `id` varchar(255) NOT NULL,
  `applied_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `moderator`
--

DROP TABLE IF EXISTS `moderator`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `moderator` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `mod_channel_id` char(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `mod_level` bigint NOT NULL DEFAULT '1',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_blocked` (`mod_channel_id`),
  CONSTRAINT `moderator_ibfk_1` FOREIGN KEY (`mod_channel_id`) REFERENCES `channel` (`claim_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `reaction`
--

DROP TABLE IF EXISTS `reaction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `reaction` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `comment_id` char(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `channel_id` char(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `claim_id` char(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `reaction_type_id` bigint unsigned NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_flagged` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_unique_reaction` (`channel_id`,`comment_id`,`claim_id`,`reaction_type_id`),
  KEY `idx_channel_reaction` (`channel_id`,`reaction_type_id`),
  KEY `idx_publish_reaction` (`claim_id`,`reaction_type_id`),
  KEY `idx_created_at` (`created_at`),
  KEY `idx_updated_at` (`updated_at`),
  KEY `reaction_ibfk_2` (`comment_id`),
  KEY `reaction_ibfk_3` (`reaction_type_id`),
  KEY `is_flagged_idx` (`is_flagged`),
  CONSTRAINT `reaction_ibfk_1` FOREIGN KEY (`channel_id`) REFERENCES `channel` (`claim_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `reaction_ibfk_2` FOREIGN KEY (`comment_id`) REFERENCES `comment` (`comment_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `reaction_ibfk_3` FOREIGN KEY (`reaction_type_id`) REFERENCES `reaction_type` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `reaction_type`
--

DROP TABLE IF EXISTS `reaction_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `reaction_type` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `social`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `social` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `social`;

--
-- Table structure for table `CHANNEL`
--

DROP TABLE IF EXISTS `CHANNEL`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `CHANNEL` (
  `claimid` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`claimid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `COMMENT`
--

DROP TABLE IF EXISTS `COMMENT`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `COMMENT` (
  `commentid` char(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `lbryclaimid` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `channelid` char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `body` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `parentid` char(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `signature` char(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `signingts` varchar(22) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `timestamp` int NOT NULL,
  `ishidden` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`commentid`),
  KEY `comment_channel_fk` (`channelid`),
  KEY `comment_parent_fk` (`parentid`),
  KEY `lbryclaimid` (`lbryclaimid`),
  CONSTRAINT `comment_channel_fk` FOREIGN KEY (`channelid`) REFERENCES `CHANNEL` (`claimid`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `comment_parent_fk` FOREIGN KEY (`parentid`) REFERENCES `COMMENT` (`commentid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
CREATE USER 'lbry-rw'@'localhost' IDENTIFIED BY 'lbry';
CREATE USER 'lbry-ro'@'localhost' IDENTIFIED BY 'lbry';
GRANT ALL ON commentron.* TO 'lbry-rw'@'localhost';
GRANT SELECT ON commentron.* TO 'lbry-ro'@'localhost';
GRANT ALL ON social.* TO 'lbry-rw'@'localhost';
