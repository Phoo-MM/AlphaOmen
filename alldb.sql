-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Sep 15, 2025 at 05:47 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `alldb`
--

-- --------------------------------------------------------

--
-- Table structure for table `admin`
--

CREATE TABLE `admin` (
  `admin_id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `user_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admin`
--

INSERT INTO `admin` (`admin_id`, `username`, `email`, `password_hash`, `user_id`) VALUES
(1, 'adminuser', 'admin@example.com', 'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f', 3),
(2, 'admin2', 'admin2@example.com', 'ef797c8118f02dfb649607dd5d3f8c7623048c9c063d532cc95c5ed7a898a64f', 4),
(3, 'admin3', 'admin3@example.com', 'ef797c8118f02dfb649607dd5d3f8c7623048c9c063d532cc95c5ed7a898a64f', 5);

-- --------------------------------------------------------

--
-- Table structure for table `ads`
--

CREATE TABLE `ads` (
  `ad_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `content` text NOT NULL,
  `image_url` varchar(500) DEFAULT NULL,
  `link_url` varchar(500) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `display_type` enum('popup','banner','sidebar') DEFAULT 'popup'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `ads`
--

INSERT INTO `ads` (`ad_id`, `title`, `content`, `image_url`, `link_url`, `is_active`, `display_type`) VALUES
(2, 'Spotify Premium', 'Get ad-free music with Spotify Premium!', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQGkcythAwuQDNABf8y4gRyUDOgpDW7P8k27A&s', 'https://www.spotify.com/premium/', 1, 'banner'),
(6, 'Netflix Subscription', 'Stream movies and TV shows anytime!', 'https://upload.wikimedia.org/wikipedia/commons/6/69/Netflix_logo.svg', 'https://www.netflix.com/', 1, 'popup'),
(7, 'Coursera', 'Learn new skills from coursera', 'https://www.subsmart.in/wp-content/uploads/2023/12/Coursera-Plus-1-Year.jpg', 'https://www.coursera.org', 1, 'sidebar'),
(8, 'Facebook.', 'Join Us on Facebook!', 'https://www.nicepng.com/png/detail/371-3711515_facebook-headlines-join-us-on-facebook-banner.png', 'https://www.facebook.com', 1, 'banner');

-- --------------------------------------------------------

--
-- Table structure for table `moodtracker`
--

CREATE TABLE `moodtracker` (
  `mood_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `mood_value` varchar(50) NOT NULL,
  `mood_date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `moodtracker`
--

INSERT INTO `moodtracker` (`mood_id`, `user_id`, `mood_value`, `mood_date`) VALUES
(1, 3, 'Happy', '2025-08-01'),
(2, 3, 'Sad', '2025-08-02'),
(3, 3, 'Sad', '2025-08-03'),
(4, 3, 'Happy', '2025-08-04'),
(5, 3, 'Happy', '2025-08-05'),
(6, 3, 'Angry', '2025-08-06'),
(7, 3, 'Happy', '2025-08-07'),
(8, 3, 'Sad', '2025-08-08'),
(9, 3, 'Happy', '2025-08-09'),
(10, 3, 'Happy', '2025-08-10'),
(11, 1, 'Happy', '2025-08-11'),
(12, 1, 'Happy', '2025-08-12'),
(13, 1, 'Happy', '2025-08-13'),
(14, 3, 'Happy', '2025-08-14'),
(15, 3, 'Happy', '2025-08-15'),
(16, 3, 'Happy', '2025-08-16'),
(17, 1, 'Sad', '2025-08-17'),
(18, 1, 'Angry', '2025-08-18'),
(19, 1, 'Sad', '2025-08-19'),
(20, 1, 'Happy', '2025-08-20'),
(21, 1, 'Happy', '2025-08-21'),
(22, 1, 'Sad', '2025-08-25'),
(23, 1, 'Anxious', '2025-08-26'),
(24, 1, 'Angry', '2025-08-27'),
(25, 1, 'Anxious', '2025-08-28'),
(26, 14, 'Happy', '2025-08-26'),
(34, 1, 'Happy', '2025-08-22'),
(35, 1, 'Sad', '2025-08-23'),
(36, 1, 'Sad', '2025-08-24'),
(69, 1, 'Sad', '2025-08-29'),
(70, 14, 'Angry', '2025-08-31'),
(72, 14, 'Angry', '2025-08-30'),
(97, 14, 'Happy', '2025-09-02'),
(98, 14, 'Happy', '2025-09-03'),
(101, 3, 'Anxious', '2025-06-30'),
(231, 14, 'Anxious', '2025-09-06'),
(234, 14, 'Sad', '2025-09-04'),
(235, 6, 'Happy', '2024-12-01'),
(236, 6, 'Sad', '2024-12-02'),
(237, 6, 'Angry', '2024-12-03'),
(238, 6, 'Anxious', '2024-12-04'),
(239, 6, 'Happy', '2024-12-05'),
(240, 6, 'Sad', '2024-12-06'),
(241, 6, 'Angry', '2024-12-07'),
(242, 6, 'Anxious', '2024-12-08'),
(243, 6, 'Happy', '2024-12-09'),
(244, 6, 'Sad', '2024-12-10'),
(245, 6, 'Angry', '2024-12-11'),
(246, 6, 'Anxious', '2024-12-12'),
(247, 6, 'Happy', '2024-12-13'),
(248, 6, 'Sad', '2024-12-14'),
(249, 6, 'Angry', '2024-12-15'),
(250, 6, 'Anxious', '2024-12-16'),
(251, 6, 'Happy', '2024-12-17'),
(252, 6, 'Sad', '2024-12-18'),
(253, 6, 'Angry', '2024-12-19'),
(254, 6, 'Anxious', '2024-12-20'),
(255, 6, 'Happy', '2024-12-21'),
(256, 6, 'Sad', '2024-12-22'),
(257, 6, 'Angry', '2024-12-23'),
(258, 6, 'Anxious', '2024-12-24'),
(259, 6, 'Happy', '2024-12-25'),
(260, 6, 'Sad', '2024-12-26'),
(261, 6, 'Angry', '2024-12-27'),
(262, 6, 'Anxious', '2024-12-28'),
(263, 6, 'Happy', '2024-12-29'),
(264, 6, 'Sad', '2024-12-30'),
(265, 6, 'Angry', '2024-12-31'),
(266, 6, 'Anxious', '2025-01-01'),
(267, 6, 'Happy', '2025-01-02'),
(268, 6, 'Sad', '2025-01-03'),
(269, 6, 'Angry', '2025-01-04'),
(270, 6, 'Anxious', '2025-01-05'),
(271, 6, 'Happy', '2025-01-06'),
(272, 6, 'Sad', '2025-01-07'),
(273, 6, 'Angry', '2025-01-08'),
(274, 6, 'Anxious', '2025-01-09'),
(275, 6, 'Happy', '2025-01-10'),
(276, 6, 'Sad', '2025-01-11'),
(277, 6, 'Angry', '2025-01-12'),
(278, 6, 'Anxious', '2025-01-13'),
(279, 6, 'Happy', '2025-01-14'),
(280, 6, 'Sad', '2025-01-15'),
(281, 6, 'Angry', '2025-01-16'),
(282, 6, 'Anxious', '2025-01-17'),
(283, 6, 'Happy', '2025-01-18'),
(284, 6, 'Sad', '2025-01-19'),
(285, 6, 'Angry', '2025-01-20'),
(286, 6, 'Anxious', '2025-01-21'),
(287, 6, 'Happy', '2025-01-22'),
(288, 6, 'Sad', '2025-01-23'),
(289, 6, 'Angry', '2025-01-24'),
(290, 6, 'Anxious', '2025-01-25'),
(291, 6, 'Happy', '2025-01-26'),
(292, 6, 'Sad', '2025-01-27'),
(293, 6, 'Angry', '2025-01-28'),
(294, 6, 'Anxious', '2025-01-29'),
(295, 6, 'Happy', '2025-01-30'),
(296, 6, 'Sad', '2025-01-31'),
(297, 6, 'Angry', '2025-02-01'),
(298, 6, 'Anxious', '2025-02-02'),
(299, 6, 'Happy', '2025-02-03'),
(300, 6, 'Sad', '2025-02-04'),
(301, 6, 'Angry', '2025-02-05'),
(302, 6, 'Anxious', '2025-02-06'),
(303, 6, 'Happy', '2025-02-07'),
(304, 6, 'Sad', '2025-02-08'),
(305, 6, 'Angry', '2025-02-09'),
(306, 6, 'Anxious', '2025-02-10'),
(307, 6, 'Happy', '2025-02-11'),
(308, 6, 'Sad', '2025-02-12'),
(309, 6, 'Angry', '2025-02-13'),
(310, 6, 'Anxious', '2025-02-14'),
(311, 6, 'Happy', '2025-02-15'),
(312, 6, 'Sad', '2025-02-16'),
(313, 6, 'Angry', '2025-02-17'),
(314, 6, 'Anxious', '2025-02-18'),
(315, 6, 'Happy', '2025-02-19'),
(316, 6, 'Sad', '2025-02-20'),
(317, 6, 'Angry', '2025-02-21'),
(318, 6, 'Anxious', '2025-02-22'),
(319, 6, 'Happy', '2025-02-23'),
(320, 6, 'Sad', '2025-02-24'),
(321, 6, 'Angry', '2025-02-25'),
(322, 6, 'Anxious', '2025-02-26'),
(323, 6, 'Happy', '2025-02-27'),
(324, 6, 'Sad', '2025-02-28'),
(325, 6, 'Angry', '2025-03-01'),
(326, 6, 'Anxious', '2025-03-02'),
(327, 6, 'Happy', '2025-03-03'),
(328, 6, 'Sad', '2025-03-04'),
(329, 6, 'Angry', '2025-03-05'),
(330, 6, 'Anxious', '2025-03-06'),
(331, 6, 'Happy', '2025-03-07'),
(332, 6, 'Sad', '2025-03-08'),
(333, 6, 'Angry', '2025-03-09'),
(334, 6, 'Anxious', '2025-03-10'),
(335, 6, 'Happy', '2025-03-11'),
(336, 6, 'Sad', '2025-03-12'),
(337, 6, 'Angry', '2025-03-13'),
(338, 6, 'Anxious', '2025-03-14'),
(339, 6, 'Happy', '2025-03-15'),
(340, 6, 'Sad', '2025-03-16'),
(341, 6, 'Angry', '2025-03-17'),
(342, 6, 'Anxious', '2025-03-18'),
(343, 6, 'Happy', '2025-03-19'),
(344, 6, 'Sad', '2025-03-20'),
(345, 6, 'Angry', '2025-03-21'),
(346, 6, 'Anxious', '2025-03-22'),
(347, 6, 'Happy', '2025-03-23'),
(348, 6, 'Sad', '2025-03-24'),
(349, 6, 'Angry', '2025-03-25'),
(350, 6, 'Anxious', '2025-03-26'),
(351, 6, 'Happy', '2025-03-27'),
(352, 6, 'Sad', '2025-03-28'),
(353, 6, 'Angry', '2025-03-29'),
(354, 6, 'Anxious', '2025-03-30'),
(355, 6, 'Happy', '2025-03-31'),
(356, 6, 'Sad', '2025-04-01'),
(357, 6, 'Angry', '2025-04-02'),
(358, 6, 'Anxious', '2025-04-03'),
(359, 6, 'Happy', '2025-04-04'),
(360, 6, 'Sad', '2025-04-05'),
(361, 6, 'Angry', '2025-04-06'),
(362, 6, 'Anxious', '2025-04-07'),
(363, 6, 'Happy', '2025-04-08'),
(364, 6, 'Sad', '2025-04-09'),
(365, 6, 'Angry', '2025-04-10'),
(366, 6, 'Anxious', '2025-04-11'),
(367, 6, 'Happy', '2025-04-12'),
(368, 6, 'Sad', '2025-04-13'),
(369, 6, 'Angry', '2025-04-14'),
(370, 6, 'Anxious', '2025-04-15'),
(371, 6, 'Happy', '2025-04-16'),
(372, 6, 'Sad', '2025-04-17'),
(373, 6, 'Angry', '2025-04-18'),
(374, 6, 'Anxious', '2025-04-19'),
(375, 6, 'Happy', '2025-04-20'),
(376, 6, 'Sad', '2025-04-21'),
(377, 6, 'Angry', '2025-04-22'),
(378, 6, 'Anxious', '2025-04-23'),
(379, 6, 'Happy', '2025-04-24'),
(380, 6, 'Sad', '2025-04-25'),
(381, 6, 'Angry', '2025-04-26'),
(382, 6, 'Anxious', '2025-04-27'),
(383, 14, 'Angry', '2025-09-07'),
(387, 7, 'Happy', '2025-07-01'),
(388, 7, 'Happy', '2025-07-02'),
(389, 7, 'Happy', '2025-07-03'),
(390, 7, 'Happy', '2025-07-04'),
(391, 7, 'Happy', '2025-07-05'),
(392, 7, 'Happy', '2025-07-06'),
(393, 7, 'Happy', '2025-07-07'),
(394, 7, 'Happy', '2025-07-08'),
(395, 7, 'Happy', '2025-07-09'),
(396, 7, 'Happy', '2025-07-10'),
(397, 7, 'Sad', '2025-07-11'),
(398, 7, 'Sad', '2025-07-12'),
(399, 7, 'Sad', '2025-07-13'),
(400, 7, 'Anxious', '2025-07-14'),
(401, 7, 'Angry', '2025-07-15'),
(402, 7, 'Angry', '2025-07-16'),
(403, 7, 'Angry', '2025-07-17'),
(404, 7, 'Angry', '2025-07-18'),
(405, 7, 'Angry', '2025-07-19'),
(406, 7, 'Angry', '2025-07-20'),
(407, 7, 'Happy', '2025-07-21'),
(408, 7, 'Happy', '2025-07-22'),
(409, 7, 'Sad', '2025-07-23'),
(410, 7, 'Sad', '2025-07-24'),
(411, 7, 'Anxious', '2025-07-25'),
(412, 7, 'Anxious', '2025-07-26'),
(413, 7, 'Anxious', '2025-07-27'),
(414, 7, 'Happy', '2025-07-28'),
(415, 7, 'Happy', '2025-07-29'),
(416, 7, 'Happy', '2025-07-30'),
(417, 7, 'Sad', '2025-07-31'),
(418, 7, 'Sad', '2025-08-01'),
(419, 7, 'Sad', '2025-08-02'),
(420, 7, 'Anxious', '2025-08-03'),
(421, 7, 'Anxious', '2025-08-04'),
(422, 7, 'Angry', '2025-08-05'),
(423, 7, 'Happy', '2025-08-06'),
(424, 7, 'Happy', '2025-08-07'),
(425, 7, 'Anxious', '2025-08-08'),
(426, 7, 'Happy', '2025-08-09'),
(427, 7, 'Happy', '2025-08-10'),
(428, 7, 'Happy', '2025-08-11'),
(429, 7, 'Angry', '2025-08-12'),
(430, 7, 'Anxious', '2025-08-13'),
(431, 7, 'Happy', '2025-08-14'),
(432, 7, 'Happy', '2025-08-15'),
(433, 7, 'Happy', '2025-08-16'),
(434, 7, 'Anxious', '2025-08-17'),
(435, 7, 'Anxious', '2025-08-18'),
(436, 7, 'Happy', '2025-08-19'),
(437, 7, 'Sad', '2025-08-20'),
(438, 7, 'Anxious', '2025-08-21'),
(439, 7, 'Happy', '2025-08-22'),
(440, 7, 'Happy', '2025-08-23'),
(441, 7, 'Sad', '2025-08-24'),
(442, 7, 'Angry', '2025-08-25'),
(443, 7, 'Anxious', '2025-08-26'),
(444, 14, 'Happy', '2025-08-27'),
(445, 14, 'Happy', '2025-08-28'),
(446, 14, 'Happy', '2025-08-29'),
(447, 7, 'Anxious', '2025-08-30'),
(448, 7, 'Angry', '2025-08-31'),
(449, 7, 'Happy', '2025-09-01'),
(450, 7, 'Sad', '2025-09-02'),
(451, 14, 'Happy', '2025-09-01'),
(452, 7, 'Anxious', '2025-09-04'),
(453, 14, 'Angry', '2025-09-05'),
(455, 14, 'Anxious', '2025-09-08'),
(456, 14, 'Happy', '2025-09-09');

-- --------------------------------------------------------

--
-- Table structure for table `note`
--

CREATE TABLE `note` (
  `note_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `content` longtext DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `is_pinned` tinyint(1) DEFAULT 0,
  `color` varchar(50) DEFAULT NULL,
  `due_date` date DEFAULT NULL,
  `tag_id` int(11) DEFAULT NULL,
  `voice_note_path` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `note`
--

INSERT INTO `note` (`note_id`, `user_id`, `title`, `content`, `created_at`, `updated_at`, `is_pinned`, `color`, `due_date`, `tag_id`, `voice_note_path`) VALUES
(3, 1, 'If contents true, then edit works!', 'Content\r\nPin - 1\r\nColor - black\r\ndue date 22\r\ncategory bored', '2025-08-19 00:59:47', '2025-08-26 14:51:20', 0, '#400040', '2025-08-22', NULL, NULL),
(12, 1, 'Untitled', '<b><i><u><font color=\"#ff0000\" style=\"background-color: rgb(173, 216, 230);\" size=\"5\">This is an untitled note!!</font></u></i></b>', '2025-08-19 22:40:18', '2025-08-26 15:25:25', 0, '#ffffff', '2025-08-27', NULL, NULL),
(14, 1, 'Hi This is create test', '<b><i><u><font color=\"#0000ff\" style=\"background-color: rgb(255, 255, 0);\" size=\"5\">Testing working</font></u></i></b>', '2025-08-26 14:09:09', '2025-09-02 20:58:49', 1, '#4d3973', '2025-08-28', 3, NULL),
(21, 1, 'Imported Note ttt', '<div><b>INSERT <font size=\"1\">INTO</font></b> <i>`note`</i> <u>(`note_id`, `user_id`, `title`, `content`, `created_at`, `updated_at`, `is_pinned`, `color`, `due_date`, `voice_note_id`, `tag_id`</u>)<font color=\"#ff0000\"> VALUES</font><span style=\"background-color: rgb(173, 216, 230);\">\r\n(1, 1, \'Test Note\', \'This is a test\', \'2025-08-18 23:15:42\', \'2025-08-20 00:51:44\', 1, \'#ff0000\', NULL, NULL, 4)</span>,\r\n<font size=\"4\">(3, 1, \'If contents true, then edit works!\', \'Content\\r\\nPin - 1\\r\\nColor - black\\r\\ndue date 22\\r\\ncategory bo<font color=\"#008000\">red\', </font></font><font color=\"#008000\" size=\"3\">\'2025-08-19 00:59:47\', \'2025-08-19 23:06:11\', 0, \'#40</font><font color=\"#008000\" size=\"3\">0040\', \'2025-08-22\', NULL, 5),\r\n(8, 1, \'Hi this is amazing \', \'1111111</font><font color=\"#0000ff\" size=\"3\">1111111</font></div>', '2025-08-26 14:39:24', '2025-08-26 15:25:39', 1, '#4eb8c7', '2025-08-27', NULL, NULL),
(79, 2, 'VOICE IMPORT CHECK', 'WORKS PLS  ew', '2025-09-02 21:11:11', '2025-09-05 04:17:38', 0, '#ffffff', '2025-09-07', 40, 'voice_1756824115340.webm'),
(80, 2, 'ENter line break check', 'wegr\r\nfgio\r\n\r\n\r\n\r\n\r\n\r\nwrigwg', '2025-09-02 21:43:56', '2025-09-05 04:17:23', 1, '#ffffff', '2025-09-10', 50, 'null'),
(81, 2, 'Test', '<font color=\"#804040\">ghwr<br><font size=\"4\">jwen<br><span style=\"background-color: rgb(0, 0, 160);\">ewioew<br>nwegner</span></font></font><span style=\"background-color: rgb(0, 0, 160);\"><br>jigweie</span> ir<br>iwoi<br>jioenr<br>iownrer<br>', '2025-09-02 21:53:17', '2025-09-02 22:09:21', 0, '#ffffff', NULL, NULL, 'null'),
(82, 3, 'Hello Autocorrect Check', 'rehire are there <br>ewrhi<br>oiw<br>leaning<br>i ma \'<br>-]reg<br>RGRE<br>gRE<br>g<br>reG<br>reG<br>re<br>GRE<br>gre<br>g<br>erG<br>ER<br>mether<br>pthon<br>appoe', '2025-09-02 23:32:49', '2025-09-04 15:14:16', 1, '#ffffff', '2025-09-06', 53, 'voice_1756975456691.webm'),
(83, 3, 'Helllllllllllllllllllllllll', 'ghewhre<br>hrgrew', '2025-09-03 00:11:50', '2025-09-03 00:11:50', 0, '#ffffff', NULL, NULL, NULL),
(84, 2, ' ery43', '<span style=\"background-color: rgb(128, 128, 255);\">hrre<br>gieorioe<br>gjpo rnnerk</span>\r\n			troejiern<font color=\"#ff0080\"><br>jiprejhej;	\r\n		    nyh</font>', '2025-09-03 00:16:51', '2025-09-03 00:16:51', 0, '#ffffff', NULL, NULL, NULL),
(85, 3, 'gregtw bt4t34', '<font color=\"#0080c0\">rewgw<br>jewij<br>jwirogoier</font>', '2025-09-03 01:10:10', '2025-09-04 13:30:53', 1, '#ffffff', NULL, 55, 'null'),
(88, 2, 'hert w', 'ertwre', '2025-09-03 16:39:33', '2025-09-03 16:39:33', 0, '#ffffff', NULL, NULL, NULL),
(89, 2, 'h t4ew', 'he yer', '2025-09-03 16:39:43', '2025-09-03 16:39:43', 0, '#ffffff', NULL, NULL, NULL),
(90, 2, 'hery e4', 'ryre y4e', '2025-09-03 16:39:49', '2025-09-03 16:39:49', 0, '#ffffff', NULL, NULL, NULL),
(91, 2, 'h5y5e', 'hrey4eter', '2025-09-03 16:39:55', '2025-09-03 16:39:55', 0, '#ffffff', NULL, NULL, NULL),
(92, 2, 'h4643', 'htyere htry', '2025-09-03 16:40:07', '2025-09-03 16:40:07', 0, '#ffffff', NULL, NULL, NULL),
(93, 2, 'ey357m', 'n45365', '2025-09-03 16:40:13', '2025-09-03 16:40:13', 0, '#ffffff', NULL, NULL, NULL),
(94, 2, 'y e634', 'y45w', '2025-09-03 16:40:26', '2025-09-03 16:40:26', 0, '#ffffff', NULL, NULL, NULL),
(95, 3, 'Hello Autocorrect Check', 'gjgeo fwe jworw thia', '2025-09-03 21:11:10', '2025-09-03 21:11:10', 0, '#ffffff', NULL, NULL, NULL),
(96, 3, 'Good Morning', 'here \r\n			    herne here herne here hero hero haj eff hel held roper wryer racer roper raper rower rents renter rents rent rete wee rete rhee rev see', '2025-09-03 23:04:47', '2025-09-04 14:30:43', 0, '#ffffff', NULL, NULL, 'voice_1756972843644.webm'),
(99, 3, 'this woire', 'this \r\n			    wat a \r\n			      heavy \r\n			    \r\n			      bork', '2025-09-04 10:43:11', '2025-09-04 10:43:11', 0, '#ffffff', NULL, NULL, NULL),
(100, 3, 'etew', 'otic iwo view oink wit wept oe gi', '2025-09-04 11:01:01', '2025-09-04 11:01:01', 0, '#ffffff', NULL, NULL, NULL),
(101, 3, 'autocorrecting', 'just at piece or item ewe', '2025-09-04 11:03:28', '2025-09-04 11:03:28', 0, '#ffffff', NULL, NULL, NULL),
(103, 3, 'ffe', 'greyer war', '2025-09-04 12:26:10', '2025-09-04 12:26:10', 0, '#ffffff', NULL, NULL, NULL),
(106, 3, 'gewg', 'ew', '2025-09-04 16:04:27', '2025-09-04 16:04:27', 0, '#ffffff', NULL, NULL, 'voice_1756978467609.webm'),
(109, 1, 'he', 'hreher', '2025-09-05 08:44:36', '2025-09-05 08:44:36', 0, '#ffffff', NULL, NULL, NULL),
(110, 1, 'herre', 'berner', '2025-09-05 08:44:45', '2025-09-05 08:44:45', 0, '#ffffff', NULL, NULL, NULL),
(111, 1, 'nerher', 'nererger', '2025-09-05 08:44:55', '2025-09-05 08:44:55', 0, '#ffffff', NULL, NULL, NULL),
(112, 1, 'ber', 'nerher', '2025-09-05 08:45:19', '2025-09-05 08:45:19', 0, '#ffffff', NULL, NULL, NULL),
(113, 1, 'erger', 'nerre', '2025-09-05 08:45:24', '2025-09-05 08:45:24', 0, '#ffffff', NULL, NULL, NULL),
(114, 1, 'hreew', 'reger', '2025-09-05 08:45:29', '2025-09-05 08:45:29', 0, '#ffffff', NULL, NULL, NULL),
(115, 1, 'erger', 'nerer', '2025-09-05 08:45:32', '2025-09-05 08:45:32', 0, '#ffffff', NULL, NULL, NULL),
(116, 1, 'hretew', 'bwrehre', '2025-09-05 08:45:48', '2025-09-05 08:45:48', 0, '#ffffff', NULL, NULL, NULL),
(117, 6, 'What is Java', '<b><font color=\"#ff0000\" style=\"background-color: rgb(255, 255, 128);\">What is Java?</font></b>\r\n\r\n<i>Java is a popular programming language, created in 1995.</i>\r\n\r\n<i>It is owned by Oracle, and more than 3 billion devices run Java.</i>\r\n\r\n<u>It is used for:\r\n\r\n    Mobile applications (specially Android apps)\r\n    Desktop applications\r\n    Web applications\r\n    Web servers and application servers\r\n    Games\r\n    Database connection\r\n    And much, much more!\r\n</u>\r\n<b>Why Use Java?</b>\r\n\r\n    Java works on different platforms (Windows, Mac, Linux, Raspberry Pi, etc.)\r\n    It is one of the most popular programming languages in the world\r\n    It has a large demand in the current job market\r\n    It is easy to learn and simple to use\r\n    It is open-source and free\r\n    It is secure, fast and powerful\r\n    It has huge community support (tens of millions of developers)\r\n    Java is an object oriented language which gives a clear structure to programs and allows code to be reused, lowering development costs\r\n    As Java is close to C++ and C#, it makes it easy for programmers to switch to Java or vice versa\r\n\r\nGet Started\r\n\r\nWhen you are finished with this tutorial, you will be able to write basic Java programs and create real-life examples.\r\n\r\nIt is not necessary to have any prior programming experience.', '2025-09-05 11:37:50', '2025-09-05 12:14:46', 1, '#0080c0', '2025-09-05', 56, NULL),
(118, 6, 'What is Java(1)', 'What is Java?\r\n,,,,,...jo\r\nJava is a popular programming language, created in 1995......\r\n\r\nIt is owned by Oracle, and more than 3 billion devices run Java.\r\n\r\nIt is used for:\r\n\r\n    Mobile applications (specially Android apps)\r\n    Desktop applications\r\n    Web applications\r\n    Web servers and application servers\r\n    Games\r\n    Database connection\r\n    And much, much more!\r\n\r\nWhy Use Java?\r\n\r\n    Java works on different platforms (Windows, Mac, Linux, Raspberry Pi, etc.)\r\n    It is one of the most popular programming languages in the world\r\n    It has a large demand in the current job market\r\n    It is easy to learn and simple to use\r\n    It is open-source and free\r\n    It is secure, fast and powerful\r\n    It has huge community support (tens of millions of developers)\r\n    Java is an object oriented language which gives a clear structure to programs and allows code to be reused, lowering development costs\r\n    As Java is close to C++ and C#, it makes it easy for programmers to switch to Java or vice versa\r\n\r\nGet Started\r\n\r\nWhen you are finished with this tutorial, you will be able to write basic Java programs and create real-life examples.\r\n\r\nIt is not necessary to have any prior programming experience.', '2025-09-05 11:38:46', '2025-09-05 12:26:18', 0, '#ffffff', NULL, NULL, NULL),
(119, 6, 'The test', 'editor is something', '2025-09-05 12:05:18', '2025-09-05 12:26:22', 0, '#ffffff', NULL, NULL, NULL),
(125, 7, 'Project Assignment', 'Project Assignment is dued on 4/9/2025!!! 675 gie', '2025-09-05 13:40:57', '2025-09-05 14:45:34', 0, '#ff0000', '2025-09-04', 57, NULL),
(126, 14, 'Voice Note Test', '<font color=\"#004080\"><b>This is </b><span style=\"background-color: rgb(0, 128, 192);\"><i>voice <u>note check!!</u></i></span></font>', '2025-09-05 14:27:09', '2025-09-05 14:27:09', 0, '#ffffff', NULL, NULL, 'voice_1757059029135.webm'),
(127, 14, 'What is Java', 'What is Java?\r\n\r\nJava is a popular programming language, created in 1995.\r\n\r\nIt is owned by Oracle, and more than 3 billion devices run Java.\r\n\r\nIt is used for:\r\n\r\n    Mobile applications (specially Android apps)\r\n    Desktop applications\r\n    Web applications\r\n    Web servers and application servers\r\n    Games\r\n    Database connection\r\n    And much, much more!\r\n\r\nWhy Use Java?\r\n\r\n    Java works on different platforms (Windows, Mac, Linux, Raspberry Pi, etc.)\r\n    It is one of the most popular programming languages in the world\r\n    It has a large demand in the current job market\r\n    It is easy to learn and simple to use\r\n    It is open-source and free\r\n    It is secure, fast and powerful\r\n    It has huge community support (tens of millions of developers)\r\n    Java is an object oriented language which gives a clear structure to programs and allows code to be reused, lowering development costs\r\n    As Java is close to C++ and C#, it makes it easy for programmers to switch to Java or vice versa\r\n\r\nGet Started\r\n\r\nWhen you are finished with this tutorial, you will be able to write basic Java programs and create real-life examples.\r\n\r\nIt is not necessary to have any prior programming experience.', '2025-09-05 14:27:35', '2025-09-09 23:40:05', 0, '#ffffff', '2025-09-10', NULL, NULL),
(128, 14, 'Test', '<font size=\"7\">This is test check</font>', '2025-09-05 14:30:07', '2025-09-09 23:40:01', 1, '#400080', '2025-09-05', 58, NULL),
(129, 14, 'jgioeorehr', 'herrhet', '2025-09-05 14:30:40', '2025-09-05 14:30:40', 0, '#ffffff', NULL, NULL, NULL),
(130, 14, 'rthr', 'rtjrte', '2025-09-05 14:30:47', '2025-09-05 14:30:47', 0, '#ffffff', NULL, NULL, NULL),
(131, 7, 'test1', 'apple \r\n				is a \r\n				fruit', '2025-09-05 14:53:18', '2025-09-05 14:53:18', 0, '#ffffff', NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `otp_codes`
--

CREATE TABLE `otp_codes` (
  `otp_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `otp_code` varchar(6) NOT NULL,
  `expiry_time` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `is_used` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `otp_codes`
--

INSERT INTO `otp_codes` (`otp_id`, `user_id`, `otp_code`, `expiry_time`, `created_at`, `is_used`) VALUES
(4, 14, '227982', '2025-09-05 07:53:58', '2025-09-05 07:51:54', 1);

-- --------------------------------------------------------

--
-- Table structure for table `plan`
--

CREATE TABLE `plan` (
  `plan_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `ads_enabled` tinyint(1) DEFAULT 1,
  `price` decimal(10,2) NOT NULL,
  `duration_months` int(11) DEFAULT 12
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `plan`
--

INSERT INTO `plan` (`plan_id`, `name`, `ads_enabled`, `price`, `duration_months`) VALUES
(1, 'Free Plan', 0, 0.00, 0),
(2, 'Premium Plan', 1, 2.99, 5);

--
-- Triggers `plan`
--
DELIMITER $$
CREATE TRIGGER `trg_plan_duration_update` AFTER UPDATE ON `plan` FOR EACH ROW BEGIN
    DECLARE sStart DATE;

    -- Only if duration_months changes
    IF OLD.duration_months <> NEW.duration_months THEN
        -- Update all active subscriptions for this plan
        UPDATE subscription
        SET end_date = DATE_ADD(start_date, INTERVAL NEW.duration_months MONTH)
        WHERE plan_id = NEW.plan_id AND is_active = 1;
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `subscription`
--

CREATE TABLE `subscription` (
  `subscription_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `plan_id` int(11) NOT NULL,
  `transaction_id` int(11) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `is_active` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `subscription`
--

INSERT INTO `subscription` (`subscription_id`, `user_id`, `plan_id`, `transaction_id`, `start_date`, `end_date`, `is_active`) VALUES
(22, 3, 2, 30, '2025-09-05', '2026-02-05', 1),
(23, 4, 2, 31, '2025-09-05', '2026-02-05', 1),
(24, 5, 2, 32, '2025-09-05', '2026-02-05', 1),
(25, 6, 2, 33, '2025-09-05', '2026-02-05', 1),
(26, 14, 2, 34, '2025-09-05', '2026-02-05', 1),
(27, 7, 2, 35, '2025-09-05', '2026-02-05', 1);

--
-- Triggers `subscription`
--
DELIMITER $$
CREATE TRIGGER `reset_plan_on_subscription_delete` AFTER DELETE ON `subscription` FOR EACH ROW BEGIN
    DECLARE active_count INT;

    -- Count remaining active subscriptions for this user
    SELECT COUNT(*) INTO active_count
    FROM subscription
    WHERE user_id = OLD.user_id AND is_active = 1;

    -- If no active subscriptions left, set plan_id to 1 (Free Plan)
    IF active_count = 0 THEN
        UPDATE users
        SET plan_id = 1
        WHERE user_id = OLD.user_id;
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_subscription_start_update` BEFORE UPDATE ON `subscription` FOR EACH ROW BEGIN
    DECLARE planDuration INT;

    -- Only update if start_date changes
    IF OLD.start_date <> NEW.start_date THEN
        SELECT duration_months INTO planDuration
        FROM plan
        WHERE plan_id = NEW.plan_id;

        SET NEW.end_date = DATE_ADD(NEW.start_date, INTERVAL planDuration MONTH);
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `tag`
--

CREATE TABLE `tag` (
  `tag_id` int(11) NOT NULL,
  `tag_name` varchar(50) NOT NULL,
  `user_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tag`
--

INSERT INTO `tag` (`tag_id`, `tag_name`, `user_id`) VALUES
(1, 'Personal', 1),
(2, 'Work', 1),
(3, 'School', 1),
(4, 'Love', 1),
(39, 'Work', 2),
(40, 'Personal', 2),
(42, 'School', 2),
(50, 'Gaming', 2),
(51, 'Fun', 2),
(53, 'One', 3),
(54, 'Two', 3),
(55, 'Three', 3),
(56, 'Study', 6),
(57, 'School', 7),
(58, 'School', 14),
(59, 'Fun', 14),
(60, 'Work', 14),
(61, 'Project', 14),
(62, 'Home', 14),
(63, 'Game', 14);

-- --------------------------------------------------------

--
-- Table structure for table `transactions`
--

CREATE TABLE `transactions` (
  `transaction_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `plan_id` int(11) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `payment_method` varchar(50) DEFAULT 'KBZPay',
  `user_reference` varchar(100) DEFAULT NULL,
  `reference_number` varchar(100) DEFAULT NULL,
  `status` enum('PENDING','SUCCESS','FAILED') DEFAULT 'PENDING',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `verified` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `transactions`
--

INSERT INTO `transactions` (`transaction_id`, `user_id`, `plan_id`, `amount`, `payment_method`, `user_reference`, `reference_number`, `status`, `created_at`, `updated_at`, `verified`) VALUES
(30, 3, 2, 2.99, 'KBZPay', '12345678901234567890', '12345678901234567890', 'SUCCESS', '2025-09-05 05:03:39', '2025-09-05 05:03:39', 1),
(31, 4, 2, 2.99, 'KBZPay', '12345678901234567890', '12345678901234567890', 'SUCCESS', '2025-09-05 05:03:39', '2025-09-05 05:03:39', 1),
(32, 5, 2, 2.99, 'KBZPay', '12345678901234567890', '12345678901234567890', 'SUCCESS', '2025-09-05 05:03:39', '2025-09-05 05:03:39', 1),
(33, 6, 2, 2.99, 'KBZPay', '12345678901234567890', '12345678901234567890', 'SUCCESS', '2025-09-05 05:03:39', '2025-09-05 05:03:39', 1),
(34, 14, 2, 2.99, 'KBZPay', '01000390001058343234', '01000390001058343234', 'SUCCESS', '2025-09-05 08:04:58', '2025-09-05 08:06:13', 1),
(35, 7, 2, 2.99, 'KBZPay', '34365477777777777777', '34365477777777777777', 'SUCCESS', '2025-09-05 08:10:53', '2025-09-05 08:11:17', 1);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `plan_id` int(11) DEFAULT NULL,
  `is_admin` tinyint(1) DEFAULT 0,
  `is_verified` tinyint(1) DEFAULT 0,
  `last_login` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `username`, `email`, `password`, `plan_id`, `is_admin`, `is_verified`, `last_login`, `created_at`, `updated_at`) VALUES
(1, 'user', 'testuser1@example.com', 'ef797c8118f02dfb649607dd5d3f8c7623048c9c063d532cc95c5ed7a898a64f', 1, 0, 1, NULL, '2025-08-25 18:35:56', '2025-09-03 00:14:08'),
(2, 'freePlanUser', 'freeplan@example.com', 'ef797c8118f02dfb649607dd5d3f8c7623048c9c063d532cc95c5ed7a898a64f', 1, 0, 1, NULL, '2025-08-25 18:35:56', '2025-09-05 06:18:47'),
(3, 'admin1', 'admin1@example.com', 'ef797c8118f02dfb649607dd5d3f8c7623048c9c063d532cc95c5ed7a898a64f', 2, 1, 1, NULL, '2025-08-25 18:35:56', '2025-09-05 06:00:53'),
(4, 'admin2', 'admin2@example.com', 'ef797c8118f02dfb649607dd5d3f8c7623048c9c063d532cc95c5ed7a898a64f', 2, 1, 1, NULL, '2025-09-05 04:50:45', '2025-09-05 04:50:45'),
(5, 'admin3', 'admin3@example.com', 'ef797c8118f02dfb649607dd5d3f8c7623048c9c063d532cc95c5ed7a898a64f', 2, 1, 1, NULL, '2025-09-05 04:50:45', '2025-09-05 04:50:45'),
(6, 'regularUser2', 'user2@example.com', 'ef797c8118f02dfb649607dd5d3f8c7623048c9c063d532cc95c5ed7a898a64f', 2, 0, 1, NULL, '2025-09-05 04:50:45', '2025-09-05 04:50:45'),
(7, 'freeUser1', 'freeuser1@example.com', 'ef797c8118f02dfb649607dd5d3f8c7623048c9c063d532cc95c5ed7a898a64f', 2, 0, 1, NULL, '2025-09-05 04:50:45', '2025-09-05 08:11:17'),
(8, 'freeUser2', 'freeuser2@example.com', 'ef797c8118f02dfb649607dd5d3f8c7623048c9c063d532cc95c5ed7a898a64f', 1, 0, 1, NULL, '2025-09-05 04:50:45', '2025-09-05 04:50:45'),
(9, 'freeUser3', 'freeuser3@example.com', 'ef797c8118f02dfb649607dd5d3f8c7623048c9c063d532cc95c5ed7a898a64f', 1, 0, 1, NULL, '2025-09-05 04:50:45', '2025-09-05 04:50:45'),
(10, 'freeUser4', 'freeuser4@example.com', 'ef797c8118f02dfb649607dd5d3f8c7623048c9c063d532cc95c5ed7a898a64f', 1, 0, 1, NULL, '2025-09-05 04:50:45', '2025-09-05 04:50:45'),
(11, 'freeUser5', 'freeuser5@example.com', 'ef797c8118f02dfb649607dd5d3f8c7623048c9c063d532cc95c5ed7a898a64f', 1, 0, 1, NULL, '2025-09-05 04:50:45', '2025-09-05 04:50:45'),
(12, 'freeUser6', 'freeuser6@example.com', 'ef797c8118f02dfb649607dd5d3f8c7623048c9c063d532cc95c5ed7a898a64f', 1, 0, 1, NULL, '2025-09-05 04:50:45', '2025-09-05 04:50:45'),
(13, 'freeUser7', 'freeuser7@example.com', 'ef797c8118f02dfb649607dd5d3f8c7623048c9c063d532cc95c5ed7a898a64f', 1, 0, 1, NULL, '2025-09-05 04:50:45', '2025-09-05 04:50:45'),
(14, 'Hein', 'heinhlyanhenery@gmail.com', '6105689ad5171433f57e3f426d736de22c54fdd8f08789c187d7aadee9b5be59', 2, 0, 1, NULL, '2025-09-05 07:51:54', '2025-09-09 16:52:47');

--
-- Triggers `users`
--
DELIMITER $$
CREATE TRIGGER `after_user_insert` AFTER INSERT ON `users` FOR EACH ROW BEGIN
    IF NEW.is_admin = TRUE THEN
        INSERT INTO admin(user_id, username, email, password_hash) 
        VALUES (NEW.user_id, NEW.username, NEW.email, NEW.password);
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `prevent_premium_user_delete` BEFORE DELETE ON `users` FOR EACH ROW BEGIN
    IF OLD.plan_id = 2 THEN -- 2 = Premium Plan
        SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'Cannot delete premium plan user';
    END IF;
END
$$
DELIMITER ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`admin_id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `ads`
--
ALTER TABLE `ads`
  ADD PRIMARY KEY (`ad_id`);

--
-- Indexes for table `moodtracker`
--
ALTER TABLE `moodtracker`
  ADD PRIMARY KEY (`mood_id`),
  ADD UNIQUE KEY `unique_user_date` (`user_id`,`mood_date`);

--
-- Indexes for table `note`
--
ALTER TABLE `note`
  ADD PRIMARY KEY (`note_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `fk_note_tag` (`tag_id`);

--
-- Indexes for table `otp_codes`
--
ALTER TABLE `otp_codes`
  ADD PRIMARY KEY (`otp_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `plan`
--
ALTER TABLE `plan`
  ADD PRIMARY KEY (`plan_id`);

--
-- Indexes for table `subscription`
--
ALTER TABLE `subscription`
  ADD PRIMARY KEY (`subscription_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `plan_id` (`plan_id`),
  ADD KEY `fk_subscription_transaction` (`transaction_id`);

--
-- Indexes for table `tag`
--
ALTER TABLE `tag`
  ADD PRIMARY KEY (`tag_id`),
  ADD KEY `fk_tag_user` (`user_id`);

--
-- Indexes for table `transactions`
--
ALTER TABLE `transactions`
  ADD PRIMARY KEY (`transaction_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `plan_id` (`plan_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `plan_id` (`plan_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admin`
--
ALTER TABLE `admin`
  MODIFY `admin_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `ads`
--
ALTER TABLE `ads`
  MODIFY `ad_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `moodtracker`
--
ALTER TABLE `moodtracker`
  MODIFY `mood_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=461;

--
-- AUTO_INCREMENT for table `note`
--
ALTER TABLE `note`
  MODIFY `note_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=132;

--
-- AUTO_INCREMENT for table `otp_codes`
--
ALTER TABLE `otp_codes`
  MODIFY `otp_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `plan`
--
ALTER TABLE `plan`
  MODIFY `plan_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `subscription`
--
ALTER TABLE `subscription`
  MODIFY `subscription_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT for table `tag`
--
ALTER TABLE `tag`
  MODIFY `tag_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=64;

--
-- AUTO_INCREMENT for table `transactions`
--
ALTER TABLE `transactions`
  MODIFY `transaction_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=36;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `admin`
--
ALTER TABLE `admin`
  ADD CONSTRAINT `admin_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `moodtracker`
--
ALTER TABLE `moodtracker`
  ADD CONSTRAINT `moodtracker_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `note`
--
ALTER TABLE `note`
  ADD CONSTRAINT `fk_note_tag` FOREIGN KEY (`tag_id`) REFERENCES `tag` (`tag_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `note_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `otp_codes`
--
ALTER TABLE `otp_codes`
  ADD CONSTRAINT `fk_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `otp_codes_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `subscription`
--
ALTER TABLE `subscription`
  ADD CONSTRAINT `fk_subscription_transaction` FOREIGN KEY (`transaction_id`) REFERENCES `transactions` (`transaction_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `subscription_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `subscription_ibfk_2` FOREIGN KEY (`plan_id`) REFERENCES `plan` (`plan_id`);

--
-- Constraints for table `tag`
--
ALTER TABLE `tag`
  ADD CONSTRAINT `fk_tag_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `transactions`
--
ALTER TABLE `transactions`
  ADD CONSTRAINT `transactions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `transactions_ibfk_2` FOREIGN KEY (`plan_id`) REFERENCES `plan` (`plan_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_ibfk_1` FOREIGN KEY (`plan_id`) REFERENCES `plan` (`plan_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
