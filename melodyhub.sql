-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Máy chủ: localhost
-- Thời gian đã tạo: Th5 27, 2026 lúc 03:34 AM
-- Phiên bản máy phục vụ: 8.1.0
-- Phiên bản PHP: 8.4.14

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Cơ sở dữ liệu: `melodyhub`
--

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `admin_activity_logs`
--

CREATE TABLE `admin_activity_logs` (
  `id` bigint UNSIGNED NOT NULL,
  `admin_id` bigint UNSIGNED NOT NULL,
  `action` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `module` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `target_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'user, song, artist, etc',
  `target_id` bigint UNSIGNED DEFAULT NULL,
  `old_values` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'JSON',
  `new_values` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'JSON',
  `ip_address` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `advertisements`
--

CREATE TABLE `advertisements` (
  `id` bigint UNSIGNED NOT NULL,
  `partner_id` bigint UNSIGNED DEFAULT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` enum('audio','banner','video','sponsored_content') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `advertiser_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `advertiser_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `media_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `thumbnail_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `click_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `duration` int DEFAULT NULL COMMENT 'Seconds for audio/video',
  `file_size` bigint DEFAULT NULL,
  `target_age_min` int DEFAULT NULL,
  `target_age_max` int DEFAULT NULL,
  `target_gender` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT 'all',
  `target_location` json DEFAULT NULL,
  `target_audience` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'JSON: age, gender, location, etc',
  `target_genres` json DEFAULT NULL,
  `budget_total` decimal(10,2) DEFAULT '0.00',
  `budget_spent` decimal(10,2) DEFAULT '0.00',
  `cost_per_play` decimal(10,4) DEFAULT '0.0000',
  `cost_per_click` decimal(10,4) DEFAULT '0.0000',
  `max_plays_per_user_per_day` int DEFAULT '3',
  `priority` int NOT NULL DEFAULT '0',
  `start_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  `total_impressions` bigint NOT NULL DEFAULT '0',
  `total_plays` bigint NOT NULL DEFAULT '0',
  `total_clicks` bigint NOT NULL DEFAULT '0',
  `total_revenue` decimal(10,2) NOT NULL DEFAULT '0.00',
  `total_skips` bigint NOT NULL DEFAULT '0',
  `status` enum('pending','active','paused','completed','cancelled') COLLATE utf8mb4_unicode_ci DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `frequency_cap` int DEFAULT '5' COMMENT 'Max impressions per user per day',
  `approved_at` timestamp NULL DEFAULT NULL,
  `approved_by` bigint UNSIGNED DEFAULT NULL,
  `rejected_reason` text COLLATE utf8mb4_unicode_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `advertisements`
--

INSERT INTO `advertisements` (`id`, `partner_id`, `name`, `type`, `advertiser_name`, `advertiser_url`, `media_url`, `thumbnail_url`, `click_url`, `duration`, `file_size`, `target_age_min`, `target_age_max`, `target_gender`, `target_location`, `target_audience`, `target_genres`, `budget_total`, `budget_spent`, `cost_per_play`, `cost_per_click`, `max_plays_per_user_per_day`, `priority`, `start_date`, `end_date`, `total_impressions`, `total_plays`, `total_clicks`, `total_revenue`, `total_skips`, `status`, `created_at`, `updated_at`, `frequency_cap`, `approved_at`, `approved_by`, `rejected_reason`) VALUES
(2, 18, 'Shoppe', 'banner', 'Melody Hub', NULL, 'https://shopee.vn/-SI%C3%8AU-SALE-%C3%81o-c%C3%A2u-c%C3%A1-Xsamtin-Nh%C3%A3-Lam-v%E1%BA%A3i-co-gi%C3%A3n-4-chi%E1%BB%81u-th%E1%BA%A5m-h%C3%BAt-m%E1%BB%93-h%C3%B4i-c%C3%B3-t%C3%BAi-2-b%C3%AAn-k%C3%A9o-kh%C3%B3a-ti%E1%BB%87n-l%E1%BB%A3i-i.52227950.45104444983?extraParams=%7B%22display_model_id%22%3A310416811642%2C%22model_selection_logic%22%3A3%7D', 'https://res.cloudinary.com/djgps2bk9/image/upload/v1776670983/ads/thumbnails/mjnoxamlt6tsjcaqh3gd.jpg', 'https://shopee.vn/-SI%C3%8AU-SALE-%C3%81o-c%C3%A2u-c%C3%A1-Xsamtin-Nh%C3%A3-Lam-v%E1%BA%A3i-co-gi%C3%A3n-4-chi%E1%BB%81u-th%E1%BA%A5m-h%C3%BAt-m%E1%BB%93-h%C3%B4i-c%C3%B3-t%C3%BAi-2-b%C3%AAn-k%C3%A9o-kh%C3%B3a-ti%E1%BB%87n-l%E1%BB%A3i-i.52227950.45104444983?extraParams=%7B%22display_model_id%22%3A310416811642%2C%22model_selection_logic%22%3A3%7D', 0, NULL, 15, 50, 'male', '[\"VN\"]', NULL, NULL, 1000.00, 1.45, 0.0200, 0.0500, 3, 0, '2026-04-20', '2026-04-30', 145, 0, 4, 1.45, 0, 'active', '2026-04-20 00:43:04', '2026-05-11 07:32:00', 5, NULL, NULL, NULL),
(3, 18, 'Tiktok shop', 'banner', 'Melody Hub', NULL, 'https://seller-vn.tiktok.com/account/login?redirect_url=https%3A%2F%2Fseller-vn.tiktok.com%2Fhomepage', 'https://res.cloudinary.com/djgps2bk9/image/upload/v1776678525/ads/thumbnails/e0wniqteeeaykyptjcyw.png', 'https://seller-vn.tiktok.com/account/login?redirect_url=https%3A%2F%2Fseller-vn.tiktok.com%2Fhomepage', 0, NULL, NULL, NULL, 'female', '[\"VN\", \"TH\", \"ID\"]', NULL, '[\"11\", \"1\", \"2\", \"3\", \"5\", \"4\", \"6\", \"7\", \"9\", \"8\", \"10\"]', 2000.00, 0.71, 0.1000, 0.2500, 20, 100, '2026-04-20', '2026-04-30', 64, 0, 3, 0.71, 0, 'active', '2026-04-20 02:48:46', '2026-05-26 07:32:01', 30, NULL, NULL, NULL),
(4, 18, 'Melody Hub chúc mừng ngày 30/4 nạp các gói VIP sẽ được giảm 34%', 'banner', 'Melody Hub', 'http://localhost:5173/', 'https://res.cloudinary.com/djgps2bk9/image/upload/v1777648609/ads/media/j7wxd1nfk3sbbhhcyqiq.png', 'https://res.cloudinary.com/djgps2bk9/image/upload/v1777648604/ads/thumbnails/fczs1rmrfytybczucg7t.png', 'http://localhost:5173/user/upgrade', 0, 920990, NULL, NULL, 'all', NULL, NULL, NULL, 1000.00, 3.85, 0.1000, 0.2500, 20, 100, '2026-05-01', NULL, 30, 0, 5, 3.85, 0, 'active', '2026-05-01 07:45:41', '2026-05-26 08:10:54', 30, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `ad_priority_tiers`
--

CREATE TABLE `ad_priority_tiers` (
  `id` bigint UNSIGNED NOT NULL,
  `value` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Tier key: standard, enhanced, premium',
  `label` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Display name',
  `color` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '#888fa0' COMMENT 'Hex color for UI',
  `min_cpm` decimal(10,6) NOT NULL DEFAULT '0.002000' COMMENT 'Minimum cost per play',
  `min_cpc` decimal(10,6) NOT NULL DEFAULT '0.005000' COMMENT 'Minimum cost per click',
  `max_priority` int UNSIGNED NOT NULL DEFAULT '33' COMMENT 'Max priority value for this tier',
  `description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Short description shown in UI',
  `sort_order` int UNSIGNED NOT NULL DEFAULT '0',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `ad_priority_tiers`
--

INSERT INTO `ad_priority_tiers` (`id`, `value`, `label`, `color`, `min_cpm`, `min_cpc`, `max_priority`, `description`, `sort_order`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'standard', 'Standard', '#888fa0', 0.020000, 0.050000, 33, 'General reach, competitive queue', 1, 1, '2026-05-01 08:26:16', '2026-05-01 09:26:08'),
(2, 'enhanced', 'Enhanced', '#00aaff', 0.050000, 0.120000, 66, 'Higher visibility, better placement', 2, 1, '2026-05-01 08:26:16', '2026-05-01 09:26:15'),
(3, 'premium', 'Premium', '#f59e0b', 0.100000, 0.250000, 100, 'Top priority, maximum exposure', 3, 1, '2026-05-01 08:26:16', '2026-05-01 09:26:24');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `ad_tracking`
--

CREATE TABLE `ad_tracking` (
  `id` bigint UNSIGNED NOT NULL,
  `ad_id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED DEFAULT NULL,
  `session_id` varchar(255) DEFAULT NULL,
  `event_type` enum('impression','click','dismiss','skip','complete') NOT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text,
  `referrer` text,
  `tracked_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Đang đổ dữ liệu cho bảng `ad_tracking`
--

INSERT INTO `ad_tracking` (`id`, `ad_id`, `user_id`, `session_id`, `event_type`, `ip_address`, `user_agent`, `referrer`, `tracked_at`, `created_at`, `updated_at`) VALUES
(1, 2, 17, NULL, 'click', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-25 22:56:59', '2026-04-25 22:57:02', '2026-04-25 22:57:02'),
(2, 2, 17, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-25 23:02:08', '2026-04-25 23:02:08', '2026-04-25 23:02:08'),
(3, 3, 19, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', 'http://localhost:5173/', '2026-04-25 23:03:27', '2026-04-25 23:03:28', '2026-04-25 23:03:28'),
(4, 3, 19, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', 'http://localhost:5173/', '2026-04-25 23:03:28', '2026-04-25 23:03:28', '2026-04-25 23:03:28'),
(5, 2, 19, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', 'http://localhost:5173/', '2026-04-25 23:03:34', '2026-04-25 23:03:34', '2026-04-25 23:03:34'),
(6, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', 'http://localhost:5173/', '2026-04-25 23:03:49', '2026-04-25 23:03:50', '2026-04-25 23:03:50'),
(7, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', 'http://localhost:5173/', '2026-04-25 23:05:51', '2026-04-25 23:05:52', '2026-04-25 23:05:52'),
(8, 2, 17, NULL, 'click', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-25 23:05:57', '2026-04-25 23:06:00', '2026-04-25 23:06:00'),
(9, 2, 17, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-25 23:07:20', '2026-04-25 23:07:23', '2026-04-25 23:07:23'),
(10, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-25 23:07:39', '2026-04-25 23:07:39', '2026-04-25 23:07:39'),
(11, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-25 23:07:52', '2026-04-25 23:07:53', '2026-04-25 23:07:53'),
(12, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-25 23:25:32', '2026-04-25 23:25:33', '2026-04-25 23:25:33'),
(13, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', 'http://localhost:5173/', '2026-04-25 23:28:47', '2026-04-25 23:28:48', '2026-04-25 23:28:48'),
(14, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', 'http://localhost:5173/', '2026-04-25 23:28:48', '2026-04-25 23:28:48', '2026-04-25 23:28:48'),
(15, 2, 1, NULL, 'click', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', 'http://localhost:5173/', '2026-04-25 23:29:01', '2026-04-25 23:29:02', '2026-04-25 23:29:02'),
(16, 3, 19, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', 'http://localhost:5173/', '2026-04-25 23:29:23', '2026-04-25 23:29:24', '2026-04-25 23:29:24'),
(17, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-25 23:32:29', '2026-04-25 23:32:30', '2026-04-25 23:32:30'),
(18, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-26 00:19:38', '2026-04-26 00:19:39', '2026-04-26 00:19:39'),
(19, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-26 00:20:35', '2026-04-26 00:20:35', '2026-04-26 00:20:35'),
(20, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-26 01:40:52', '2026-04-26 01:40:53', '2026-04-26 01:40:53'),
(21, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/albums/saigon-noir-messe-ep', '2026-04-26 01:41:17', '2026-04-26 01:41:18', '2026-04-26 01:41:18'),
(22, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-26 01:42:46', '2026-04-26 01:42:46', '2026-04-26 01:42:46'),
(23, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-26 01:42:53', '2026-04-26 01:42:53', '2026-04-26 01:42:53'),
(24, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-26 01:44:14', '2026-04-26 01:44:15', '2026-04-26 01:44:15'),
(25, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-26 01:44:37', '2026-04-26 01:44:38', '2026-04-26 01:44:38'),
(26, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-26 01:45:52', '2026-04-26 01:45:52', '2026-04-26 01:45:52'),
(27, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-26 01:46:14', '2026-04-26 01:46:15', '2026-04-26 01:46:15'),
(28, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-26 01:46:25', '2026-04-26 01:46:26', '2026-04-26 01:46:26'),
(29, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-26 02:42:56', '2026-04-26 02:42:56', '2026-04-26 02:42:56'),
(30, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-26 02:46:14', '2026-04-26 02:46:14', '2026-04-26 02:46:14'),
(31, 3, 19, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', 'http://localhost:5173/', '2026-04-26 03:22:33', '2026-04-26 03:22:34', '2026-04-26 03:22:34'),
(32, 3, 19, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', 'http://localhost:5173/', '2026-04-26 03:22:59', '2026-04-26 03:23:00', '2026-04-26 03:23:00'),
(33, 3, 19, NULL, 'click', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', 'http://localhost:5173/', '2026-04-26 03:23:03', '2026-04-26 03:23:04', '2026-04-26 03:23:04'),
(34, 2, 19, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', 'http://localhost:5173/', '2026-04-26 03:23:08', '2026-04-26 03:23:08', '2026-04-26 03:23:08'),
(35, 2, 2, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', 'http://localhost:5173/', '2026-04-26 03:33:05', '2026-04-26 03:33:05', '2026-04-26 03:33:05'),
(36, 2, 2, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', 'http://localhost:5173/', '2026-04-26 03:33:22', '2026-04-26 03:33:23', '2026-04-26 03:33:23'),
(37, 2, 2, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', 'http://localhost:5173/', '2026-04-26 03:33:48', '2026-04-26 03:33:48', '2026-04-26 03:33:48'),
(38, 2, 2, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', 'http://localhost:5173/', '2026-04-26 03:34:27', '2026-04-26 03:34:27', '2026-04-26 03:34:27'),
(39, 2, 2, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', 'http://localhost:5173/', '2026-04-26 03:34:40', '2026-04-26 03:34:40', '2026-04-26 03:34:40'),
(40, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-26 03:35:44', '2026-04-26 03:35:45', '2026-04-26 03:35:45'),
(41, 2, 2, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', 'http://localhost:5173/', '2026-04-26 03:36:11', '2026-04-26 03:36:12', '2026-04-26 03:36:12'),
(42, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-26 03:39:41', '2026-04-26 03:39:44', '2026-04-26 03:39:44'),
(43, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-26 03:40:04', '2026-04-26 03:40:06', '2026-04-26 03:40:06'),
(44, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-26 03:44:13', '2026-04-26 03:44:15', '2026-04-26 03:44:15'),
(45, 2, 2, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', 'http://localhost:5173/', '2026-04-26 03:44:31', '2026-04-26 03:44:35', '2026-04-26 03:44:35'),
(46, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-26 03:44:37', '2026-04-26 03:44:37', '2026-04-26 03:44:37'),
(47, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-26 03:44:51', '2026-04-26 03:44:53', '2026-04-26 03:44:53'),
(48, 2, 2, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', 'http://localhost:5173/', '2026-04-26 03:45:02', '2026-04-26 03:45:03', '2026-04-26 03:45:03'),
(49, 2, 2, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', 'http://localhost:5173/', '2026-04-26 03:45:44', '2026-04-26 03:45:45', '2026-04-26 03:45:45'),
(50, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-26 03:53:02', '2026-04-26 03:53:03', '2026-04-26 03:53:03'),
(51, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-26 05:44:06', '2026-04-26 05:44:08', '2026-04-26 05:44:08'),
(52, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-26 22:52:30', '2026-04-26 22:52:32', '2026-04-26 22:52:32'),
(53, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-26 23:39:16', '2026-04-26 23:39:17', '2026-04-26 23:39:17'),
(54, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-26 23:45:26', '2026-04-26 23:45:27', '2026-04-26 23:45:27'),
(55, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-26 23:51:49', '2026-04-26 23:51:50', '2026-04-26 23:51:50'),
(56, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-26 23:53:31', '2026-04-26 23:53:32', '2026-04-26 23:53:32'),
(57, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-26 23:53:45', '2026-04-26 23:53:46', '2026-04-26 23:53:46'),
(58, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-26 23:54:00', '2026-04-26 23:54:01', '2026-04-26 23:54:01'),
(59, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-26 23:56:30', '2026-04-26 23:56:31', '2026-04-26 23:56:31'),
(60, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-27 00:36:19', '2026-04-27 00:36:19', '2026-04-27 00:36:19'),
(61, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-27 00:45:59', '2026-04-27 00:45:59', '2026-04-27 00:45:59'),
(62, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-27 00:49:43', '2026-04-27 00:49:45', '2026-04-27 00:49:45'),
(63, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-27 00:50:06', '2026-04-27 00:50:07', '2026-04-27 00:50:07'),
(64, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-27 00:53:02', '2026-04-27 00:53:03', '2026-04-27 00:53:03'),
(65, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-27 00:56:12', '2026-04-27 00:56:13', '2026-04-27 00:56:13'),
(66, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-27 00:57:06', '2026-04-27 00:57:06', '2026-04-27 00:57:06'),
(67, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-27 01:06:58', '2026-04-27 01:06:58', '2026-04-27 01:06:58'),
(68, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-27 01:07:43', '2026-04-27 01:07:43', '2026-04-27 01:07:43'),
(69, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-27 01:08:45', '2026-04-27 01:08:45', '2026-04-27 01:08:45'),
(70, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-27 01:17:33', '2026-04-27 01:17:36', '2026-04-27 01:17:36'),
(71, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-27 01:23:10', '2026-04-27 01:23:13', '2026-04-27 01:23:13'),
(72, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-27 01:31:00', '2026-04-27 01:31:01', '2026-04-27 01:31:01'),
(73, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-27 01:37:49', '2026-04-27 01:37:52', '2026-04-27 01:37:52'),
(74, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-27 01:42:29', '2026-04-27 01:42:30', '2026-04-27 01:42:30'),
(75, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-27 01:43:02', '2026-04-27 01:43:05', '2026-04-27 01:43:05'),
(76, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-27 01:45:19', '2026-04-27 01:45:20', '2026-04-27 01:45:20'),
(77, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-27 01:45:27', '2026-04-27 01:45:28', '2026-04-27 01:45:28'),
(78, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-27 01:46:35', '2026-04-27 01:46:36', '2026-04-27 01:46:36'),
(79, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-27 01:48:09', '2026-04-27 01:48:10', '2026-04-27 01:48:10'),
(80, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-27 01:48:19', '2026-04-27 01:48:22', '2026-04-27 01:48:22'),
(81, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-27 01:58:26', '2026-04-27 01:58:29', '2026-04-27 01:58:29'),
(82, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-27 01:58:52', '2026-04-27 01:58:53', '2026-04-27 01:58:53'),
(83, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-27 05:29:45', '2026-04-27 05:29:45', '2026-04-27 05:29:45'),
(84, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-27 07:24:28', '2026-04-27 07:24:28', '2026-04-27 07:24:28'),
(85, 3, 19, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', 'http://localhost:5173/', '2026-04-27 07:26:06', '2026-04-27 07:26:07', '2026-04-27 07:26:07'),
(86, 3, 19, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', 'http://localhost:5173/', '2026-04-27 07:26:08', '2026-04-27 07:26:09', '2026-04-27 07:26:09'),
(87, 2, 19, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', 'http://localhost:5173/', '2026-04-27 07:26:12', '2026-04-27 07:26:12', '2026-04-27 07:26:12'),
(88, 3, 19, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', 'http://localhost:5173/', '2026-04-27 07:27:33', '2026-04-27 07:27:33', '2026-04-27 07:27:33'),
(89, 3, 19, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', 'http://localhost:5173/', '2026-04-27 07:40:36', '2026-04-27 07:40:36', '2026-04-27 07:40:36'),
(90, 2, 19, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', 'http://localhost:5173/', '2026-04-27 07:40:42', '2026-04-27 07:40:43', '2026-04-27 07:40:43'),
(91, 3, 19, NULL, 'click', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', 'http://localhost:5173/', '2026-04-27 07:41:11', '2026-04-27 07:41:12', '2026-04-27 07:41:12'),
(92, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-27 08:04:03', '2026-04-27 08:04:03', '2026-04-27 08:04:03'),
(93, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-27 08:09:21', '2026-04-27 08:09:22', '2026-04-27 08:09:22'),
(94, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-27 08:09:36', '2026-04-27 08:09:37', '2026-04-27 08:09:37'),
(95, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-27 08:19:26', '2026-04-27 08:19:27', '2026-04-27 08:19:27'),
(96, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-27 08:19:58', '2026-04-27 08:19:58', '2026-04-27 08:19:58'),
(97, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-27 08:36:22', '2026-04-27 08:36:22', '2026-04-27 08:36:22'),
(98, 3, 19, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', 'http://localhost:5173/', '2026-04-27 08:44:04', '2026-04-27 08:44:05', '2026-04-27 08:44:05'),
(99, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-27 08:44:19', '2026-04-27 08:44:20', '2026-04-27 08:44:20'),
(100, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-27 08:54:06', '2026-04-27 08:54:07', '2026-04-27 08:54:07'),
(101, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-27 08:54:40', '2026-04-27 08:54:40', '2026-04-27 08:54:40'),
(102, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-27 08:55:51', '2026-04-27 08:55:53', '2026-04-27 08:55:53'),
(103, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-27 08:55:52', '2026-04-27 08:55:54', '2026-04-27 08:55:54'),
(104, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-27 08:56:08', '2026-04-27 08:56:09', '2026-04-27 08:56:09'),
(105, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-27 08:59:40', '2026-04-27 08:59:43', '2026-04-27 08:59:43'),
(106, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-28 07:20:04', '2026-04-28 07:20:06', '2026-04-28 07:20:06'),
(107, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-28 07:20:49', '2026-04-28 07:20:50', '2026-04-28 07:20:50'),
(108, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-28 07:21:08', '2026-04-28 07:21:11', '2026-04-28 07:21:11'),
(109, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-28 07:35:03', '2026-04-28 07:35:04', '2026-04-28 07:35:04'),
(110, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-28 07:35:04', '2026-04-28 07:35:05', '2026-04-28 07:35:05'),
(111, 2, 1, NULL, 'click', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-28 07:35:10', '2026-04-28 07:35:12', '2026-04-28 07:35:12'),
(112, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-28 08:58:48', '2026-04-28 08:58:49', '2026-04-28 08:58:49'),
(113, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/albums/saigon-noir-messe-ep', '2026-04-28 08:59:00', '2026-04-28 08:59:01', '2026-04-28 08:59:01'),
(114, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/albums/saigon-noir-messe-ep', '2026-04-28 08:59:22', '2026-04-28 08:59:23', '2026-04-28 08:59:23'),
(115, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/albums/saigon-noir-messe-ep', '2026-04-28 09:02:43', '2026-04-28 09:02:46', '2026-04-28 09:02:46'),
(116, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/albums/saigon-noir-messe-ep', '2026-04-28 09:02:56', '2026-04-28 09:02:58', '2026-04-28 09:02:58'),
(117, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-28 09:06:19', '2026-04-28 09:06:20', '2026-04-28 09:06:20'),
(118, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-28 09:09:43', '2026-04-28 09:09:43', '2026-04-28 09:09:43'),
(119, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-28 09:10:44', '2026-04-28 09:10:45', '2026-04-28 09:10:45'),
(120, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-28 09:46:28', '2026-04-28 09:46:29', '2026-04-28 09:46:29'),
(121, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-28 09:47:25', '2026-04-28 09:47:25', '2026-04-28 09:47:25'),
(122, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-28 09:47:48', '2026-04-28 09:47:48', '2026-04-28 09:47:48'),
(123, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-28 09:48:28', '2026-04-28 09:48:28', '2026-04-28 09:48:28'),
(124, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/music/charts', '2026-04-28 09:48:45', '2026-04-28 09:48:45', '2026-04-28 09:48:45'),
(125, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/music/charts', '2026-04-28 09:48:50', '2026-04-28 09:48:50', '2026-04-28 09:48:50'),
(126, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-28 22:16:26', '2026-04-28 22:16:27', '2026-04-28 22:16:27'),
(127, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-28 22:16:36', '2026-04-28 22:16:36', '2026-04-28 22:16:36'),
(128, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-28 22:22:38', '2026-04-28 22:22:38', '2026-04-28 22:22:38'),
(129, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-29 00:43:17', '2026-04-29 00:43:17', '2026-04-29 00:43:17'),
(130, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-29 01:17:30', '2026-04-29 01:17:32', '2026-04-29 01:17:32'),
(131, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-29 01:38:18', '2026-04-29 01:38:19', '2026-04-29 01:38:19'),
(132, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-29 01:51:32', '2026-04-29 01:51:34', '2026-04-29 01:51:34'),
(133, 3, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-29 01:56:50', '2026-04-29 01:56:52', '2026-04-29 01:56:52'),
(134, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-29 01:56:57', '2026-04-29 01:57:00', '2026-04-29 01:57:00'),
(135, 3, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-29 02:05:38', '2026-04-29 02:05:38', '2026-04-29 02:05:38'),
(136, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-29 02:05:45', '2026-04-29 02:05:48', '2026-04-29 02:05:48'),
(137, 3, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-29 02:07:31', '2026-04-29 02:07:31', '2026-04-29 02:07:31'),
(138, 3, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-29 02:07:50', '2026-04-29 02:07:50', '2026-04-29 02:07:50'),
(139, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-29 02:07:57', '2026-04-29 02:07:58', '2026-04-29 02:07:58'),
(140, 3, 1, NULL, 'click', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-29 02:08:41', '2026-04-29 02:08:44', '2026-04-29 02:08:44'),
(141, 3, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-29 02:09:15', '2026-04-29 02:09:16', '2026-04-29 02:09:16'),
(142, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-29 02:09:23', '2026-04-29 02:09:23', '2026-04-29 02:09:23'),
(143, 3, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-29 02:22:26', '2026-04-29 02:22:27', '2026-04-29 02:22:27'),
(144, 3, 19, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', 'http://localhost:5173/', '2026-04-29 03:05:28', '2026-04-29 03:05:29', '2026-04-29 03:05:29'),
(145, 3, 19, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', 'http://localhost:5173/', '2026-04-29 03:05:28', '2026-04-29 03:05:29', '2026-04-29 03:05:29'),
(146, 2, 19, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', 'http://localhost:5173/', '2026-04-29 03:05:35', '2026-04-29 03:05:35', '2026-04-29 03:05:35'),
(147, 3, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-29 03:20:03', '2026-04-29 03:20:04', '2026-04-29 03:20:04'),
(148, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-29 03:20:10', '2026-04-29 03:20:11', '2026-04-29 03:20:11'),
(149, 3, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-29 06:35:53', '2026-04-29 06:35:54', '2026-04-29 06:35:54'),
(150, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-29 06:36:01', '2026-04-29 06:36:01', '2026-04-29 06:36:01'),
(151, 3, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-29 06:37:28', '2026-04-29 06:37:29', '2026-04-29 06:37:29'),
(152, 3, 19, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', 'http://localhost:5173/', '2026-04-29 06:37:45', '2026-04-29 06:37:46', '2026-04-29 06:37:46'),
(153, 2, 19, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', 'http://localhost:5173/', '2026-04-29 06:37:51', '2026-04-29 06:37:53', '2026-04-29 06:37:53'),
(154, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-29 06:37:56', '2026-04-29 06:37:58', '2026-04-29 06:37:58'),
(155, 3, 17, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-29 06:41:32', '2026-04-29 06:41:35', '2026-04-29 06:41:35'),
(156, 3, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-29 07:47:40', '2026-04-29 07:47:49', '2026-04-29 07:47:49'),
(157, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-29 07:47:47', '2026-04-29 07:47:50', '2026-04-29 07:47:50'),
(158, 3, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-29 07:57:13', '2026-04-29 07:57:14', '2026-04-29 07:57:14'),
(159, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-29 07:57:22', '2026-04-29 07:57:24', '2026-04-29 07:57:24'),
(160, 3, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-29 07:58:23', '2026-04-29 07:58:24', '2026-04-29 07:58:24'),
(161, 3, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-29 08:37:18', '2026-04-29 08:37:18', '2026-04-29 08:37:18'),
(162, 3, 19, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', 'http://localhost:5173/', '2026-04-29 08:40:29', '2026-04-29 08:40:30', '2026-04-29 08:40:30'),
(163, 3, 19, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', 'http://localhost:5173/', '2026-04-29 08:40:30', '2026-04-29 08:40:30', '2026-04-29 08:40:30'),
(164, 2, 19, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', 'http://localhost:5173/', '2026-04-29 08:40:36', '2026-04-29 08:40:36', '2026-04-29 08:40:36'),
(165, 3, 5, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', 'http://localhost:5173/', '2026-04-29 08:52:01', '2026-04-29 08:52:02', '2026-04-29 08:52:02'),
(166, 3, 5, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', 'http://localhost:5173/', '2026-04-29 08:52:17', '2026-04-29 08:52:18', '2026-04-29 08:52:18'),
(167, 3, 5, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', 'http://localhost:5173/', '2026-04-29 08:52:42', '2026-04-29 08:52:42', '2026-04-29 08:52:42'),
(168, 3, 5, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', 'http://localhost:5173/', '2026-04-29 08:53:26', '2026-04-29 08:53:26', '2026-04-29 08:53:26'),
(169, 3, 5, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', 'http://localhost:5173/', '2026-04-29 08:53:41', '2026-04-29 08:53:41', '2026-04-29 08:53:41'),
(170, 2, 5, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', 'http://localhost:5173/', '2026-04-29 08:53:48', '2026-04-29 08:53:49', '2026-04-29 08:53:49'),
(171, 3, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-29 09:01:06', '2026-04-29 09:01:07', '2026-04-29 09:01:07'),
(172, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-29 09:01:13', '2026-04-29 09:01:16', '2026-04-29 09:01:16'),
(173, 3, 5, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', 'http://localhost:5173/', '2026-04-29 09:02:39', '2026-04-29 09:02:40', '2026-04-29 09:02:40'),
(174, 2, 5, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', 'http://localhost:5173/', '2026-04-29 09:03:28', '2026-04-29 09:03:28', '2026-04-29 09:03:28'),
(175, 3, 5, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', 'http://localhost:5173/', '2026-04-29 09:03:38', '2026-04-29 09:03:38', '2026-04-29 09:03:38'),
(176, 3, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-29 09:06:12', '2026-04-29 09:06:13', '2026-04-29 09:06:13'),
(177, 3, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-29 09:06:25', '2026-04-29 09:06:26', '2026-04-29 09:06:26'),
(178, 3, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-29 09:26:10', '2026-04-29 09:26:11', '2026-04-29 09:26:11'),
(179, 3, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-30 04:56:40', '2026-04-30 04:56:41', '2026-04-30 04:56:41'),
(180, 3, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-30 04:56:50', '2026-04-30 04:56:51', '2026-04-30 04:56:51'),
(181, 3, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-30 05:05:20', '2026-04-30 05:05:22', '2026-04-30 05:05:22'),
(182, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-30 05:05:27', '2026-04-30 05:05:30', '2026-04-30 05:05:30'),
(183, 3, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-30 05:18:25', '2026-04-30 05:18:26', '2026-04-30 05:18:26'),
(184, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-30 05:18:35', '2026-04-30 05:18:37', '2026-04-30 05:18:37'),
(185, 3, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-30 05:25:07', '2026-04-30 05:25:08', '2026-04-30 05:25:08'),
(186, 3, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-30 05:25:30', '2026-04-30 05:25:31', '2026-04-30 05:25:31'),
(187, 3, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-30 05:26:00', '2026-04-30 05:26:01', '2026-04-30 05:26:01'),
(188, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-30 05:26:27', '2026-04-30 05:26:30', '2026-04-30 05:26:30'),
(189, 3, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-30 05:26:50', '2026-04-30 05:26:51', '2026-04-30 05:26:51'),
(190, 3, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-30 05:29:38', '2026-04-30 05:29:42', '2026-04-30 05:29:42'),
(191, 3, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-30 05:30:07', '2026-04-30 05:30:08', '2026-04-30 05:30:08'),
(192, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-30 05:31:03', '2026-04-30 05:31:06', '2026-04-30 05:31:06'),
(193, 3, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-30 05:33:46', '2026-04-30 05:33:48', '2026-04-30 05:33:48'),
(194, 3, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-30 05:34:23', '2026-04-30 05:34:24', '2026-04-30 05:34:24'),
(195, 3, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-30 05:34:48', '2026-04-30 05:34:49', '2026-04-30 05:34:49'),
(196, 3, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-30 05:35:05', '2026-04-30 05:35:06', '2026-04-30 05:35:06'),
(197, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-30 05:35:31', '2026-04-30 05:35:35', '2026-04-30 05:35:35'),
(198, 3, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-30 06:45:48', '2026-04-30 06:45:49', '2026-04-30 06:45:49'),
(199, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-30 06:45:56', '2026-04-30 06:45:59', '2026-04-30 06:45:59'),
(200, 3, 17, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-30 06:46:39', '2026-04-30 06:46:39', '2026-04-30 06:46:39'),
(201, 3, 17, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-30 06:47:12', '2026-04-30 06:47:12', '2026-04-30 06:47:12'),
(202, 2, 17, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-30 06:47:19', '2026-04-30 06:47:22', '2026-04-30 06:47:22'),
(203, 3, 17, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-30 06:52:15', '2026-04-30 06:52:16', '2026-04-30 06:52:16'),
(204, 2, 17, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-30 06:52:22', '2026-04-30 06:52:25', '2026-04-30 06:52:25'),
(205, 3, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-30 07:19:08', '2026-04-30 07:19:10', '2026-04-30 07:19:10'),
(206, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-30 07:19:16', '2026-04-30 07:19:18', '2026-04-30 07:19:18'),
(207, 3, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-30 07:25:51', '2026-04-30 07:25:52', '2026-04-30 07:25:52'),
(208, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-30 07:25:52', '2026-04-30 07:25:53', '2026-04-30 07:25:53'),
(209, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-30 07:25:59', '2026-04-30 07:26:01', '2026-04-30 07:26:01'),
(210, 3, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-30 07:29:21', '2026-04-30 07:29:21', '2026-04-30 07:29:21'),
(211, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-30 07:29:28', '2026-04-30 07:29:31', '2026-04-30 07:29:31'),
(212, 3, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-30 07:30:30', '2026-04-30 07:30:31', '2026-04-30 07:30:31'),
(213, 3, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-30 07:30:39', '2026-04-30 07:30:39', '2026-04-30 07:30:39'),
(214, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-30 07:30:46', '2026-04-30 07:30:49', '2026-04-30 07:30:49'),
(215, 3, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-30 07:31:31', '2026-04-30 07:31:32', '2026-04-30 07:31:32'),
(216, 2, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-04-30 07:32:40', '2026-04-30 07:32:42', '2026-04-30 07:32:42');
INSERT INTO `ad_tracking` (`id`, `ad_id`, `user_id`, `session_id`, `event_type`, `ip_address`, `user_agent`, `referrer`, `tracked_at`, `created_at`, `updated_at`) VALUES
(217, 4, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-05-01 08:54:26', '2026-05-01 08:54:27', '2026-05-01 08:54:27'),
(218, 4, 1, NULL, 'click', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-05-01 08:54:30', '2026-05-01 08:54:30', '2026-05-01 08:54:30'),
(219, 4, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-05-01 09:26:35', '2026-05-01 09:26:36', '2026-05-01 09:26:36'),
(220, 4, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-05-01 09:28:36', '2026-05-01 09:28:36', '2026-05-01 09:28:36'),
(221, 4, 1, NULL, 'click', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-05-01 09:28:38', '2026-05-01 09:28:39', '2026-05-01 09:28:39'),
(222, 4, 1, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-05-01 09:36:21', '2026-05-01 09:36:23', '2026-05-01 09:36:23'),
(223, 4, 17, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', 'http://localhost:5173/', '2026-05-11 07:46:32', '2026-05-11 07:46:32', '2026-05-11 07:46:32'),
(224, 4, 19, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', 'http://localhost:5173/', '2026-05-18 06:04:20', '2026-05-18 06:04:20', '2026-05-18 06:04:20'),
(225, 4, 19, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', 'http://localhost:5173/', '2026-05-18 06:04:20', '2026-05-18 06:04:21', '2026-05-18 06:04:21'),
(226, 4, 18, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', 'http://localhost:5173/', '2026-05-18 22:20:01', '2026-05-18 22:20:01', '2026-05-18 22:20:01'),
(227, 4, 18, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', 'http://localhost:5173/', '2026-05-18 22:32:18', '2026-05-18 22:32:19', '2026-05-18 22:32:19'),
(228, 4, 18, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', 'http://localhost:5173/', '2026-05-18 22:32:18', '2026-05-18 22:32:20', '2026-05-18 22:32:20'),
(229, 4, 18, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', 'http://localhost:5173/partner/music?processing=106', '2026-05-18 22:34:20', '2026-05-18 22:34:21', '2026-05-18 22:34:21'),
(230, 4, 18, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', 'http://localhost:5173/partner/music?processing=106', '2026-05-18 22:34:40', '2026-05-18 22:34:41', '2026-05-18 22:34:41'),
(231, 4, 18, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', 'http://localhost:5173/songs/106', '2026-05-18 22:36:41', '2026-05-18 22:36:41', '2026-05-18 22:36:41'),
(232, 4, 18, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', 'http://localhost:5173/', '2026-05-18 22:51:35', '2026-05-18 22:51:36', '2026-05-18 22:51:36'),
(233, 4, 18, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', 'http://localhost:5173/', '2026-05-18 22:51:41', '2026-05-18 22:51:41', '2026-05-18 22:51:41'),
(234, 4, 18, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', 'http://localhost:5173/', '2026-05-18 22:51:52', '2026-05-18 22:51:52', '2026-05-18 22:51:52'),
(235, 4, 18, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', 'http://localhost:5173/', '2026-05-18 22:52:05', '2026-05-18 22:52:05', '2026-05-18 22:52:05'),
(236, 4, 18, NULL, 'click', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', 'http://localhost:5173/', '2026-05-18 22:52:17', '2026-05-18 22:52:18', '2026-05-18 22:52:18'),
(237, 4, 18, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', 'http://localhost:5173/', '2026-05-20 03:09:37', '2026-05-20 03:09:38', '2026-05-20 03:09:38'),
(238, 4, 18, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', 'http://localhost:5173/', '2026-05-20 03:23:07', '2026-05-20 03:23:09', '2026-05-20 03:23:09'),
(239, 4, 18, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', 'http://localhost:5173/', '2026-05-20 03:23:09', '2026-05-20 03:23:10', '2026-05-20 03:23:10'),
(240, 4, 18, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', 'http://localhost:5173/', '2026-05-20 05:43:06', '2026-05-20 05:43:06', '2026-05-20 05:43:06'),
(241, 4, 18, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', 'http://localhost:5173/', '2026-05-20 05:43:06', '2026-05-20 05:43:07', '2026-05-20 05:43:07'),
(242, 4, 21, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', 'http://localhost:5173/', '2026-05-21 01:34:38', '2026-05-21 01:34:39', '2026-05-21 01:34:39'),
(243, 4, 21, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', 'http://localhost:5173/', '2026-05-21 01:34:57', '2026-05-21 01:34:58', '2026-05-21 01:34:58'),
(244, 4, 21, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', 'http://localhost:5173/', '2026-05-21 01:35:35', '2026-05-21 01:35:35', '2026-05-21 01:35:35'),
(245, 4, 21, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', 'http://localhost:5173/', '2026-05-21 01:39:28', '2026-05-21 01:39:28', '2026-05-21 01:39:28'),
(246, 4, 21, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', 'http://localhost:5173/', '2026-05-21 01:39:49', '2026-05-21 01:39:49', '2026-05-21 01:39:49'),
(247, 4, 21, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', 'http://localhost:5173/', '2026-05-21 01:40:42', '2026-05-21 01:40:42', '2026-05-21 01:40:42'),
(248, 4, 21, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', 'http://localhost:5173/', '2026-05-21 01:41:33', '2026-05-21 01:41:33', '2026-05-21 01:41:33'),
(249, 4, 21, NULL, 'click', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', 'http://localhost:5173/', '2026-05-21 01:41:36', '2026-05-21 01:41:39', '2026-05-21 01:41:39'),
(250, 4, 17, NULL, 'impression', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', 'http://localhost:5173/', '2026-05-26 08:10:52', '2026-05-26 08:10:52', '2026-05-26 08:10:52'),
(251, 4, 17, NULL, 'click', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', 'http://localhost:5173/', '2026-05-26 08:10:54', '2026-05-26 08:10:54', '2026-05-26 08:10:54');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `albums`
--

CREATE TABLE `albums` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `artist_id` bigint UNSIGNED NOT NULL,
  `cover_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `release_date` date DEFAULT NULL,
  `album_type` enum('album','single','ep','compilation','live') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'album',
  `label` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Record label',
  `total_tracks` int NOT NULL DEFAULT '0',
  `total_duration` int NOT NULL DEFAULT '0',
  `total_plays` bigint NOT NULL DEFAULT '0',
  `total_likes` bigint NOT NULL DEFAULT '0',
  `like_count` int NOT NULL DEFAULT '0',
  `is_featured` tinyint(1) NOT NULL DEFAULT '0',
  `is_premium` tinyint(1) NOT NULL DEFAULT '0',
  `partner_id` bigint UNSIGNED DEFAULT NULL,
  `status` enum('published','draft','pending','rejected','archived') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'draft',
  `published_at` timestamp NULL DEFAULT NULL,
  `seo_title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `seo_description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `albums`
--

INSERT INTO `albums` (`id`, `name`, `slug`, `artist_id`, `cover_url`, `description`, `release_date`, `album_type`, `label`, `total_tracks`, `total_duration`, `total_plays`, `total_likes`, `like_count`, `is_featured`, `is_premium`, `partner_id`, `status`, `published_at`, `seo_title`, `seo_description`, `created_at`, `updated_at`, `deleted_at`) VALUES
(2, 'Nhạc cỗ đánh đỗ dân chơi của MTP', 'nh-c-c-nh-d-n-ch-i-c-a-mtp', 1, 'covers/albums/1775984753_RBFsc7dfV7.jpg', NULL, '2026-04-12', 'album', NULL, 10, 2476, 0, 0, 1, 1, 0, 15, 'published', NULL, NULL, NULL, '2026-04-12 02:05:53', '2026-05-20 05:58:14', NULL),
(3, 'Nhạc bất hứu của ca sĩ Jack', 'nh-c-b-t-h-u-c-a-ca-s-jack', 23, 'covers/albums/1776411616_BLo3tJIDJB.jpg', NULL, '2026-04-17', 'album', NULL, 3, 804, 0, 0, 0, 1, 0, 16, 'published', NULL, NULL, NULL, '2026-04-17 00:40:17', '2026-04-17 00:40:17', NULL),
(5, 'Nhạc hot của Hiếu Thứ 2 năm 2025', 'nh-c-hot-c-a-hi-u-th-2-n-m-2025', 26, 'covers/albums/1776438069_JcY3eaJbHq.jpg', NULL, '2026-04-18', 'album', NULL, 2, 423, 0, 0, 0, 1, 1, 17, 'published', NULL, NULL, NULL, '2026-04-17 08:01:10', '2026-04-17 19:48:23', NULL),
(9, 'Ca Sĩ Giấu Mặt', 'ca-s-gi-u-m-t', 29, 'covers/albums/1776782934_WR2sco7tRZ.webp', NULL, '2026-04-21', 'album', NULL, 6, 1499, 0, 0, 1, 1, 1, 21, 'published', NULL, NULL, NULL, '2026-04-21 07:48:54', '2026-05-18 22:33:50', NULL),
(10, 'Saigon Noir | Messe (EP)', 'saigon-noir-messe-ep', 30, 'covers/albums/1777100230_M0Arw7IVgm.png', NULL, '2026-04-25', 'album', NULL, 2, 495, 0, 0, 1, 1, 1, 22, 'published', NULL, NULL, NULL, '2026-04-24 23:57:10', '2026-04-28 08:30:17', NULL),
(11, 'Nhạc bất hữu của TRÚC NHÂN', 'nh-c-b-t-h-u-c-a-tr-c-nh-n', 6, 'covers/albums/1777550086_J4JCzI37hp.jpg', NULL, '2026-04-30', 'album', NULL, 6, 1632, 0, 0, 1, 1, 1, 23, 'published', NULL, NULL, NULL, '2026-04-30 04:54:46', '2026-04-30 06:36:39', NULL),
(12, 'Nhạc chill của Long', 'nh-c-chill-c-a-long', 31, 'covers/albums/1777815452_ibqh2FRbvF.jpg', NULL, '2026-05-03', 'album', NULL, 4, 891, 0, 0, 1, 1, 1, 18, 'published', NULL, NULL, NULL, '2026-05-03 06:37:32', '2026-05-11 07:22:51', NULL);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `album_likes`
--

CREATE TABLE `album_likes` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `album_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `album_likes`
--

INSERT INTO `album_likes` (`id`, `user_id`, `album_id`, `created_at`, `updated_at`) VALUES
(2, 1, 10, '2026-04-28 08:30:16', '2026-04-28 08:30:16'),
(3, 1, 2, '2026-04-29 00:42:17', '2026-04-29 00:42:17'),
(4, 5, 9, '2026-04-29 09:09:47', '2026-04-29 09:09:47'),
(5, 5, 11, '2026-04-30 04:55:07', '2026-04-30 04:55:07'),
(6, 1, 12, '2026-05-11 07:22:51', '2026-05-11 07:22:51');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `album_tracks`
--

CREATE TABLE `album_tracks` (
  `id` bigint UNSIGNED NOT NULL,
  `album_id` bigint UNSIGNED NOT NULL,
  `track_id` bigint UNSIGNED NOT NULL,
  `position` int NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `album_tracks`
--

INSERT INTO `album_tracks` (`id`, `album_id`, `track_id`, `position`, `created_at`, `updated_at`) VALUES
(4, 3, 38, 1, '2026-04-17 00:40:17', '2026-04-17 00:40:17'),
(5, 3, 37, 2, '2026-04-17 00:40:17', '2026-04-17 00:40:17'),
(6, 3, 36, 3, '2026-04-17 00:40:17', '2026-04-17 00:40:17'),
(21, 5, 40, 1, '2026-04-17 19:52:12', '2026-04-17 19:52:12'),
(22, 5, 39, 2, '2026-04-17 19:52:12', '2026-04-17 19:52:12'),
(23, 6, 47, 1, '2026-04-21 07:15:45', '2026-04-21 07:15:45'),
(24, 6, 46, 2, '2026-04-21 07:15:45', '2026-04-21 07:15:45'),
(25, 6, 45, 3, '2026-04-21 07:15:45', '2026-04-21 07:15:45'),
(26, 6, 44, 4, '2026-04-21 07:15:45', '2026-04-21 07:15:45'),
(27, 6, 43, 5, '2026-04-21 07:15:45', '2026-04-21 07:15:45'),
(28, 7, 47, 1, '2026-04-21 07:33:35', '2026-04-21 07:33:35'),
(29, 7, 46, 2, '2026-04-21 07:33:35', '2026-04-21 07:33:35'),
(30, 7, 45, 3, '2026-04-21 07:33:35', '2026-04-21 07:33:35'),
(31, 7, 43, 4, '2026-04-21 07:33:35', '2026-04-21 07:33:35'),
(32, 7, 44, 5, '2026-04-21 07:33:35', '2026-04-21 07:33:35'),
(33, 8, 47, 1, '2026-04-21 07:43:06', '2026-04-21 07:43:06'),
(34, 8, 46, 2, '2026-04-21 07:43:06', '2026-04-21 07:43:06'),
(35, 8, 45, 3, '2026-04-21 07:43:06', '2026-04-21 07:43:06'),
(36, 8, 44, 4, '2026-04-21 07:43:06', '2026-04-21 07:43:06'),
(37, 8, 43, 5, '2026-04-21 07:43:06', '2026-04-21 07:43:06'),
(38, 9, 47, 1, '2026-04-21 07:48:54', '2026-04-21 07:48:54'),
(39, 9, 46, 2, '2026-04-21 07:48:54', '2026-04-21 07:48:54'),
(40, 9, 45, 3, '2026-04-21 07:48:54', '2026-04-21 07:48:54'),
(41, 9, 43, 4, '2026-04-21 07:48:54', '2026-04-21 07:48:54'),
(42, 9, 44, 5, '2026-04-21 07:48:54', '2026-04-21 07:48:54'),
(43, 10, 49, 1, '2026-04-24 23:57:10', '2026-04-24 23:57:10'),
(44, 10, 48, 2, '2026-04-24 23:57:10', '2026-04-24 23:57:10'),
(57, 11, 58, 1, '2026-04-30 06:43:31', '2026-04-30 06:43:31'),
(58, 11, 57, 2, '2026-04-30 06:43:31', '2026-04-30 06:43:31'),
(59, 11, 54, 3, '2026-04-30 06:43:31', '2026-04-30 06:43:31'),
(60, 11, 55, 4, '2026-04-30 06:43:31', '2026-04-30 06:43:31'),
(61, 11, 53, 5, '2026-04-30 06:43:31', '2026-04-30 06:43:31'),
(62, 11, 56, 6, '2026-04-30 06:43:31', '2026-04-30 06:43:31'),
(63, 12, 60, 1, '2026-05-03 06:37:32', '2026-05-03 06:37:32'),
(64, 12, 59, 2, '2026-05-03 06:37:32', '2026-05-03 06:37:32'),
(65, 12, 104, 3, '2026-05-11 07:20:44', '2026-05-11 07:20:44'),
(66, 12, 100, 4, '2026-05-11 07:21:13', '2026-05-11 07:21:13'),
(67, 9, 106, 6, '2026-05-18 22:33:50', '2026-05-18 22:33:50'),
(68, 2, 35, 1, '2026-05-20 05:58:14', '2026-05-20 05:58:14'),
(69, 2, 29, 2, '2026-05-20 05:58:14', '2026-05-20 05:58:14'),
(70, 2, 28, 3, '2026-05-20 05:58:14', '2026-05-20 05:58:14'),
(71, 2, 114, 4, '2026-05-20 05:58:14', '2026-05-20 05:58:14'),
(72, 2, 113, 5, '2026-05-20 05:58:14', '2026-05-20 05:58:14'),
(73, 2, 112, 6, '2026-05-20 05:58:14', '2026-05-20 05:58:14'),
(74, 2, 111, 7, '2026-05-20 05:58:14', '2026-05-20 05:58:14'),
(75, 2, 110, 8, '2026-05-20 05:58:14', '2026-05-20 05:58:14'),
(76, 2, 109, 9, '2026-05-20 05:58:14', '2026-05-20 05:58:14'),
(77, 2, 108, 10, '2026-05-20 05:58:14', '2026-05-20 05:58:14');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `api_logs`
--

CREATE TABLE `api_logs` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED DEFAULT NULL,
  `endpoint` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `method` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `request_headers` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `request_body` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `response_status` int DEFAULT NULL,
  `response_body` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `ip_address` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `execution_time` decimal(10,3) DEFAULT NULL COMMENT 'milliseconds',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `artists`
--

CREATE TABLE `artists` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `bio` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `avatar_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `banner_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `country` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `website` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `facebook_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `instagram_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `twitter_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `youtube_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `verified` tinyint(1) NOT NULL DEFAULT '0',
  `is_featured` tinyint(1) NOT NULL DEFAULT '0',
  `total_followers` bigint NOT NULL DEFAULT '0',
  `total_plays` bigint NOT NULL DEFAULT '0',
  `total_songs` int NOT NULL DEFAULT '0',
  `total_albums` int NOT NULL DEFAULT '0',
  `partner_id` bigint UNSIGNED DEFAULT NULL,
  `status` enum('active','inactive','pending','rejected') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `seo_title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `seo_description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `seo_keywords` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `artists`
--

INSERT INTO `artists` (`id`, `name`, `slug`, `bio`, `avatar_url`, `banner_url`, `country`, `website`, `facebook_url`, `instagram_url`, `twitter_url`, `youtube_url`, `verified`, `is_featured`, `total_followers`, `total_plays`, `total_songs`, `total_albums`, `partner_id`, `status`, `seo_title`, `seo_description`, `seo_keywords`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'Sơn Tùng M-TP', 'son-tung-m-tp', 'Sơn Tùng M-TP là nam ca sĩ, nhạc sĩ, nhà sản xuất âm nhạc người Việt Nam. Anh được biết đến với phong cách âm nhạc đa dạng và những sản phẩm âm nhạc chất lượng cao.', 'avatars/artists/1773411290_clV6lgeUCg.png', 'banners/artists/1773410175_wm5D3uxmrp.jpg', 'Vietnam', 'https://sontungmtp.com', 'https://facebook.com/MTP.Fan', 'https://instagram.com/sontungmtp', 'https://twitter.com/sontungmtp', 'https://youtube.com/c/SonTungMTP', 1, 1, 12500000, 985000000, 85, 12, 15, 'active', 'Sơn Tùng M-TP - Ca sĩ hàng đầu Việt Nam', 'Sơn Tùng M-TP, ca sĩ Việt Nam với nhiều hit đình đám như Chạy Ngay Đi, Hãy Trao Cho Anh, Chúng Ta Của Hiện Tại', 'son tung mtp, ca sĩ việt nam, nhạc trẻ, pop việt', '2026-02-04 11:16:47', '2026-03-13 07:14:50', NULL),
(2, 'Đen Vâu', 'den-vau', 'Đen Vâu là nam rapper, nhạc sĩ người Việt Nam. Anh nổi tiếng với những bài hát rap mang tính triết lý, xã hội sâu sắc.', 'avatars/artists/1773411401_wov5nXxy0H.jpg', 'banners/artists/1773412552_Ppl8pqGvp9.jpg', 'Vietnam', NULL, 'https://facebook.com/denvau', 'https://instagram.com/denvau_', 'https://twitter.com/denvau_', 'https://youtube.com/c/DenVauOfficial', 1, 1, 8500000, 750000000, 42, 5, 14, 'active', 'Đen Vâu - Rapper triệu view', 'Đen Vâu, rapper Việt Nam với những ca khúc triệu view như Đi Về Nhà, Lối Nhỏ, Một Triệu Like', 'den vau, rapper việt nam, rap việt, âm nhạc underground', '2026-02-04 11:16:47', '2026-03-13 07:35:52', NULL),
(3, 'Hòa Minzy', 'hoa-minzy', 'Hòa Minzy là nữ ca sĩ, nhạc sĩ người Việt Nam. Cô được mệnh danh là \"Nữ hoàng phòng trà\" với chất giọng khỏe và truyền cảm.', 'avatars/artists/1773411564_zeGFfWeYHd.jpg', 'banners/artists/1773412572_JdePlbt46V.jpg', 'Vietnam', 'https://hoaminzy.vn', 'https://facebook.com/HoaminzyOfficial', 'https://instagram.com/hoaminzy', 'https://twitter.com/hoaminzy', 'https://youtube.com/c/HoaMinzyOfficial', 1, 1, 7200000, 680000000, 78, 8, NULL, 'active', 'Hòa Minzy - Nữ hoàng phòng trà', 'Hòa Minzy, ca sĩ Việt Nam với những bản hit như Thương, Đừng Yêu Nữa Em Mệt Rồi, Có Em Chờ', 'hoa minzy, ca sĩ nữ việt nam, nhạc trữ tình, pop ballad', '2026-02-04 11:16:47', '2026-03-13 07:36:12', NULL),
(4, 'Bích Phương', 'bich-phuong', 'Bích Phương là nữ ca sĩ người Việt Nam. Cô nổi tiếng với những ca khúc pop sôi động và phong cách biểu diễn năng lượng.', 'avatars/artists/1773411736_bYk9Ts9ImK.jpg', 'banners/artists/1773412598_91mj63CifS.jpg', 'Vietnam', NULL, 'https://facebook.com/BichPhuongOfficial', 'https://instagram.com/bichphuongofficial', 'https://twitter.com/bichphuong', 'https://youtube.com/c/BichPhuongOfficial', 1, 1, 5800000, 520000000, 65, 7, NULL, 'active', 'Bích Phương - Nữ hoàng nhạc pop Việt', 'Bích Phương, ca sĩ Việt Nam với những hit như Bùa Yêu, Gửi Anh Xa Nhớ, Đi Đu Đưa Đi', 'bich phuong, ca sĩ nữ, nhạc pop việt, vpop', '2026-02-04 11:16:47', '2026-03-13 07:36:38', NULL),
(5, 'Mỹ Tâm', 'my-tam', 'Mỹ Tâm là nữ ca sĩ, nhạc sĩ, diễn viên người Việt Nam. Cô được mệnh danh là \"Họa mi tóc nâu\" và là một trong những diva hàng đầu của Vpop.', 'avatars/artists/1773411889_Xw4logXE86.jpg', 'banners/artists/1773412615_9wKpXjx9Nh.jpg', 'Vietnam', 'https://mytam.info', 'https://facebook.com/mytamfanpage', 'https://instagram.com/mytamhmt', 'https://twitter.com/mytamhmt', 'https://youtube.com/c/MyTamOfficial', 1, 1, 9500000, 890000000, 120, 15, NULL, 'active', 'Mỹ Tâm - Họa mi tóc nâu', 'Mỹ Tâm, diva của làng nhạc Việt với những ca khúc bất hủ như Họa Mi Tóc Nâu, Đừng Hỏi Em, Nơi Ấy Con Tìm Về', 'my tam, hoa mi toc nau, diva việt nam, nhạc trữ tình', '2026-02-04 11:16:47', '2026-03-13 07:36:55', NULL),
(6, 'Trúc Nhân', 'truc-nhan', 'Trúc Nhân là nam ca sĩ, nhạc sĩ người Việt Nam. Anh nổi tiếng với chất giọng đặc biệt và khả năng sáng tác đa dạng thể loại.', 'avatars/artists/1773412021_VJ9tS12r7f.jpg', 'banners/artists/1773412634_M931dxAi4W.jpg', 'Vietnam', NULL, 'https://facebook.com/TrucNhanOfficial', 'https://instagram.com/trucnhantoday', 'https://twitter.com/trucnhantoday', 'https://youtube.com/c/TrucNhanOfficial', 1, 0, 3200000, 285000000, 45, 4, 23, 'active', 'Trúc Nhân - Ca sĩ đa tài', 'Trúc Nhân, ca sĩ Việt Nam với những ca khúc như Lạ Lùng, Con Tim Tan Vỡ, Đông', 'truc nhan, ca sĩ nam việt nam, nhạc pop, r&b', '2026-02-04 11:16:47', '2026-03-13 07:37:14', NULL),
(8, 'Vũ Cát Tường', 'vu-cat-tuong', 'Vũ Cát Tường là nữ ca sĩ, nhạc sĩ, nhà sản xuất âm nhạc người Việt Nam. Cô được biết đến với phong cách âm nhạc indie và jazz.', 'avatars/artists/1773412101_urOUvPzq0n.jpg', 'banners/artists/1773412652_kMWGSfItCR.jpg', 'Vietnam', 'https://vucattuong.com', 'https://facebook.com/VuCatTuongOfficial', 'https://instagram.com/vucattuong', 'https://twitter.com/vucattuong', 'https://youtube.com/c/VuCatTuongOfficial', 1, 0, 2800000, 195000000, 52, 6, NULL, 'active', 'Vũ Cát Tường - Nữ nhạc sĩ tài hoa', 'Vũ Cát Tường, ca sĩ kiêm nhạc sĩ với những sáng tác như Yêu Xa, Gió, Mơ, Anh Và Em', 'vu cat tuong, nhạc sĩ việt nam, nhạc indie, jazz việt', '2026-02-04 11:16:47', '2026-03-13 07:37:32', NULL),
(9, 'Chi Dân', 'chi-dan', 'Chi Dân là nam ca sĩ, diễn viên người Việt Nam. Anh được biết đến qua nhiều bản hit tình cảm lãng mạn.', 'avatars/artists/1773412186_oCOdKQg2Zk.jpg', 'banners/artists/1773412502_Wwptzh0I2V.jpg', 'Vietnam', NULL, 'https://facebook.com/chidanofficial', 'https://instagram.com/chidanofficial', 'https://twitter.com/chidanofficial', 'https://youtube.com/c/ChiDanOfficial', 1, 0, 2600000, 230000000, 41, 4, NULL, 'inactive', 'Chi Dân - Chàng ca sĩ tình cảm', 'Chi Dân, ca sĩ Việt Nam với những ca khúc như Người Lạ Thoáng Qua, Sóng Gió, Em Là', 'chi dan, ca sĩ nam, nhạc trữ tình, ballad', '2026-02-04 11:16:47', '2026-03-13 07:35:02', NULL),
(10, 'Đức Phúc', 'duc-phuc', 'Đức Phúc là nam ca sĩ người Việt Nam. Anh nổi tiếng từ cuộc thi The Voice và có chất giọng trầm ấm đặc trưng.', 'avatars/artists/1773412738_4qLweJ5Ddb.jpg', 'banners/artists/1773412738_zMYb0cV7X2.jpg', 'Vietnam', NULL, 'https://facebook.com/DucPhucOfficial', 'https://instagram.com/ducphucofficial', 'https://twitter.com/ducphucofficial', 'https://youtube.com/c/DucPhucOfficial', 1, 0, 3100000, 275000000, 48, 5, NULL, 'active', 'Đức Phúc - Giọng ca trầm ấm', 'Đức Phúc, ca sĩ Việt Nam với những bản hit như Hồng Nhan, Tình Nhạt Phai, Vì Mẹ Anh Bắt Chia Tay', 'duc phuc, the voice, ca sĩ nam việt nam, ballad', '2026-02-04 11:16:47', '2026-03-13 07:38:58', NULL),
(11, 'tlinh', 'tlinh', 'tlinh là nữ rapper trẻ người Việt Nam, thành viên của nhóm nhạc Deadline. Cô nổi tiếng với flow rap độc đáo và phong cách cá tính.', 'avatars/artists/1773412832_V905BAmrsb.jpg', 'banners/artists/1773412832_kDwKSeMOG3.jpg', 'Vietnam', NULL, 'https://facebook.com/tlinh.rapper', 'https://instagram.com/t.linhh', 'https://twitter.com/tlinhrapper', 'https://youtube.com/c/tlinhOfficial', 1, 0, 1800000, 165000000, 28, 2, NULL, 'active', 'tlinh - Nữ rapper trẻ tài năng', 'tlinh, nữ rapper trẻ với những ca khúc như Ghệ ơi, 2 Phút Hơn, Đen Đá Không Đường', 'tlinh, rapper nữ, deadline, hiphop việt', '2026-02-04 11:16:47', '2026-03-13 07:40:32', NULL),
(12, 'MCK', 'mck', 'MCK (tên thật Nguyễn Viết Hoàng) là nam rapper người Việt Nam. Anh nổi tiếng với những bài hát rap đậm chất đường phố và cá tính mạnh mẽ.', 'avatars/artists/1773412922_E6c05YwwLR.jpg', 'banners/artists/1773412922_5BmXtd8bh1.jpg', 'Vietnam', NULL, 'https://facebook.com/mck.rap', 'https://instagram.com/mck.rap', 'https://twitter.com/mckrap', 'https://youtube.com/c/MCKOfficial', 1, 0, 2200000, 190000000, 35, 3, NULL, 'active', 'MCK - Rapper đường phố', 'MCK, rapper Việt Nam với phong cách rap street và những hit như Nâng Chén Tiêu Sầu, Trời Giấu Trời Mang Đi', 'mck, rapper việt nam, rap đường phố, hiphop', '2026-02-04 11:16:47', '2026-03-13 07:42:02', NULL),
(13, 'Thịnh Suy', 'thinh-suy', 'Thịnh Suy là nam ca sĩ, nhạc sĩ trẻ người Việt Nam. Anh nổi tiếng với những sáng tác indie và phong cách âm nhạc độc đáo.', 'avatars/artists/1773413025_zLCScyqQ4j.jpg', 'banners/artists/1773413025_boNSeOVW6W.jpg', 'Vietnam', NULL, 'https://facebook.com/thinhsuy.music', 'https://instagram.com/thinh_suy', 'https://twitter.com/thinh_suy', 'https://youtube.com/c/ThinhSuyOfficial', 0, 0, 850000, 78000000, 22, 2, NULL, 'active', 'Thịnh Suy - Nhạc sĩ indie trẻ', 'Thịnh Suy, ca sĩ kiêm nhạc sĩ với phong cách indie và những sáng tác như Có Chàng Trai Viết Lên Cây, Đừng Làm Trái Tim Anh Đau', 'thinh suy, nhạc indie việt, ca sĩ trẻ, acoustic', '2026-02-04 11:16:47', '2026-03-13 07:43:45', NULL),
(23, 'Jack', 'jack---trinh-tran-phuong-tuan', 'Jack (J97) tên thật là Trịnh Trần Phương Tuấn, sinh ngày 12 tháng 4 năm 1997 tại Bến Tre, Việt Nam. Anh là ca sĩ, nhạc sĩ và rapper nổi tiếng của V-Pop, được biết đến với phong cách âm nhạc kết hợp giữa pop, rap và âm hưởng dân gian Việt Nam.\r\n\r\nJack bắt đầu được chú ý vào năm 2019 khi phát hành ca khúc “Hồng Nhan”, nhanh chóng trở thành hiện tượng trên các nền tảng nghe nhạc trực tuyến. Sau thành công đó, anh tiếp tục ra mắt nhiều bản hit như “Bạc Phận” và “Sóng Gió”, giúp tên tuổi của anh lan rộng và thu hút lượng người hâm mộ lớn.\r\n\r\nSau khi tách khỏi công ty quản lý cũ, Jack hoạt động độc lập với nghệ danh J97 và tiếp tục phát hành các sản phẩm âm nhạc như “Hoa Hải Đường”, “Laylalay” và “Ngôi Sao Cô Đơn”. Các ca khúc của anh thường đạt hàng triệu lượt xem trên YouTube và đứng đầu nhiều bảng xếp hạng âm nhạc tại Việt Nam.\r\n\r\nKhông chỉ gây ấn tượng với giọng hát đặc trưng, Jack còn được biết đến với khả năng sáng tác và xây dựng hình ảnh nghệ sĩ trẻ sáng tạo. Anh sở hữu cộng đồng người hâm mộ đông đảo mang tên Đom Đóm, góp phần giúp các sản phẩm âm nhạc của anh nhanh chóng trở thành xu hướng trên mạng xã hội.\r\n\r\nNgày nay, Jack (J97) vẫn là một trong những nghệ sĩ trẻ có sức ảnh hưởng lớn trong làng nhạc V-Pop, liên tục thử nghiệm phong cách mới và mở rộng sự nghiệp âm nhạc của mình.', 'avatars/artists/1772720705_jI3KLnHeI9.png', 'banners/artists/1772720705_DdMFFZMeqb.jpg', 'Vietnam', NULL, 'https://www.facebook.com/jack.phuongtuan1204', 'https://www.instagram.com/iamjack1997/', NULL, 'https://www.youtube.com/channel/UChUJa1JyBc7Lc4orkiNKKQg', 1, 1, 0, 0, 0, 0, 16, 'active', 'Jack (J97) - Tiểu sử, bài hát nổi bật và tin tức mới nhất', 'Jack (J97) là ca sĩ và nhạc sĩ nổi tiếng của Việt Nam với nhiều bản hit như Sóng Gió, Hồng Nhan, Bạc Phận. Khám phá tiểu sử, danh sách bài hát và tin tức mới nhất về Jack tại MelodyHub.', 'Jack J97, ca sĩ Jack, Jack Việt Nam, bài hát Jack, Jack J97 tiểu sử, nhạc Jack, Sóng Gió Jack, Hồng Nhan Jack, Jack singer Vietnam', '2026-03-05 07:25:05', '2026-04-09 01:55:02', NULL),
(26, 'Hiếu Thứ 2', 'hi-u-th-2', 'HIEUTHUHAI (Trần Minh Hiếu, sinh năm 1999) là\r\nnam rapper, ca sĩ kiêm diễn viên nổi tiếng người Việt Nam, nổi lên từ King of Rap 2020. Thành viên nhóm GERDNANG, anh thành công qua các show 2 Ngày 1 Đêm, Anh Trai \"Say Hi\" và sở hữu nhiều bản hit với phong cách trẻ trung.', 'avatars/artists/1773411046_WMPqeaSXcc.jpg', 'banners/artists/1773409792_Q6uFjZiWko.jpg', 'Vietnam', 'https://fchieuthuhai.com/', 'https://www.facebook.com/HIEUTHUHAIOFFICIAL/', 'https://www.instagram.com/hieuthuhai', NULL, 'https://www.youtube.com/@HIEUTHUHAIOFFICIAL', 1, 1, 0, 0, 0, 0, 17, 'active', 'HIEUTHUHAI tại [Tên Show]: Những khoảnh khắc \"gây bão\" mạng xã hội', 'Cập nhật những hình ảnh và video mới nhất của HIEUTHUHAI trong các chương trình truyền hình thực tế. Xem ngay lý do vì sao HIEUTHUHAI trở thành \"chồng quốc dân\" trong lòng người hâm mộ.', 'HIEUTHUHAI 2 ngày 1 đêm, HIEUTHUHAI Anh Trai Say Hi, khoảnh khắc hài hước HIEUTHUHAI, thời trang HIEUTHUHAI.', '2026-03-13 06:22:15', '2026-04-17 01:27:30', NULL),
(27, 'VIEENT Music', 'vieent-music', NULL, 'avatars/artists/1776491372_4UfUFLiSz8.jpg', NULL, 'Vietnam', NULL, NULL, NULL, NULL, NULL, 1, 1, 0, 0, 0, 0, NULL, 'active', NULL, NULL, NULL, '2026-04-17 22:49:32', '2026-04-17 22:49:32', NULL),
(28, 'Khác (A.I)', 'khc-ai', NULL, 'avatars/artists/1776491802_3RArQDvGvI.jpg', NULL, 'Vietnam', NULL, NULL, NULL, NULL, NULL, 1, 1, 0, 0, 0, 0, NULL, 'active', NULL, NULL, NULL, '2026-04-17 22:56:42', '2026-04-17 22:56:42', NULL),
(29, 'Nam Ca Sĩ Giấu Mặt', 'nam-ca-s-giu-mt', NULL, 'avatars/artists/1776767513_Y47ui393dn.jpg', NULL, 'Vietnam', NULL, NULL, NULL, NULL, NULL, 1, 1, 0, 0, 0, 0, 21, 'active', NULL, NULL, NULL, '2026-04-21 03:31:54', '2026-04-21 03:31:54', NULL),
(30, 's o u l w a r e 🧊', 's-o-u-l-w-a-r-e', NULL, 'avatars/artists/1777099494_6azuPpvQCS.jpg', NULL, 'Vietnam', NULL, NULL, NULL, NULL, 'https://www.youtube.com/channel/UCS8pGW38b9ryaFJfpz5072w', 1, 1, 0, 0, 0, 0, 22, 'active', NULL, NULL, NULL, '2026-04-24 23:44:55', '2026-04-24 23:44:55', NULL),
(31, 'Long Nón Lá', 'long-nn-l', NULL, 'avatars/artists/1777815150_NFypgEwwZY.jpg', NULL, 'Vietnam', NULL, NULL, NULL, NULL, 'https://www.youtube.com/channel/UCnicUh3j6A3h0XYm4mXa2Qw', 1, 1, 0, 0, 0, 0, 18, 'active', NULL, NULL, NULL, '2026-05-03 06:32:31', '2026-05-03 06:32:31', NULL);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `artist_followers`
--

CREATE TABLE `artist_followers` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `artist_id` bigint UNSIGNED NOT NULL,
  `followed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `artist_followers`
--

INSERT INTO `artist_followers` (`id`, `user_id`, `artist_id`, `followed_at`) VALUES
(8, 1, 1, '2026-04-15 02:23:44'),
(9, 1, 23, '2026-04-15 02:45:16'),
(10, 1, 28, '2026-04-19 20:52:42'),
(11, 1, 29, '2026-04-29 01:33:35');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `cache`
--

CREATE TABLE `cache` (
  `key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `cache`
--

INSERT INTO `cache` (`key`, `value`, `expiration`) VALUES
('melodyhub-cache-admin_token_2a057c5801c42ea707df1d76894cf345648b32a49709d746c129b862d902a334', 'a:6:{s:7:\"user_id\";i:1;s:5:\"email\";s:27:\"nguyenbui26102003@gmail.com\";s:4:\"name\";s:18:\"Trung Nguyên Boss\";s:10:\"role_flags\";a:8:{s:8:\"is_admin\";b:0;s:7:\"is_boss\";b:1;s:18:\"is_content_manager\";b:0;s:10:\"is_partner\";b:1;s:12:\"is_moderator\";b:0;s:18:\"is_user_vip_yearly\";b:1;s:19:\"is_user_vip_monthly\";b:0;s:12:\"is_user_free\";b:0;}s:10:\"created_at\";s:19:\"2026-05-22 06:07:52\";s:10:\"expires_at\";s:19:\"2026-05-22 14:07:52\";}', 1779458872),
('melodyhub-cache-admin_token_92a84020d0b7169c2853c2aa7c9bdf71d1bad9f8def695c117bb574ad59652cf', 'a:6:{s:7:\"user_id\";i:1;s:5:\"email\";s:27:\"nguyenbui26102003@gmail.com\";s:4:\"name\";s:18:\"Trung Nguyên Boss\";s:10:\"role_flags\";a:8:{s:8:\"is_admin\";b:0;s:7:\"is_boss\";b:1;s:18:\"is_content_manager\";b:0;s:10:\"is_partner\";b:1;s:12:\"is_moderator\";b:0;s:18:\"is_user_vip_yearly\";b:1;s:19:\"is_user_vip_monthly\";b:0;s:12:\"is_user_free\";b:0;}s:10:\"created_at\";s:19:\"2026-05-21 07:07:53\";s:10:\"expires_at\";s:19:\"2026-05-21 15:07:53\";}', 1779376073),
('melodyhub-cache-admin_token_eef1305796f47b9aef461eeb620c79dde06ae8e41bf5f3fc645e5b4ab87fbb0b', 'a:6:{s:7:\"user_id\";i:1;s:5:\"email\";s:27:\"nguyenbui26102003@gmail.com\";s:4:\"name\";s:18:\"Trung Nguyên Boss\";s:10:\"role_flags\";a:8:{s:8:\"is_admin\";b:0;s:7:\"is_boss\";b:1;s:18:\"is_content_manager\";b:0;s:10:\"is_partner\";b:1;s:12:\"is_moderator\";b:0;s:18:\"is_user_vip_yearly\";b:1;s:19:\"is_user_vip_monthly\";b:0;s:12:\"is_user_free\";b:0;}s:10:\"created_at\";s:19:\"2026-05-27 02:18:49\";s:10:\"expires_at\";s:19:\"2026-05-27 10:18:49\";}', 1779877129),
('melodyhub-cache-forgot-password|127.0.0.1', 'i:1;', 1779353298),
('melodyhub-cache-forgot-password|127.0.0.1:timer', 'i:1779353298;', 1779353298),
('melodyhub-cache-trnguyen26102k3@gmail.com|127.0.0.1', 'i:5;', 1779449529),
('melodyhub-cache-trnguyen26102k3@gmail.com|127.0.0.1:timer', 'i:1779449529;', 1779449529);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `cache_locks`
--

CREATE TABLE `cache_locks` (
  `key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `owner` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `comments`
--

CREATE TABLE `comments` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `song_id` bigint UNSIGNED NOT NULL,
  `parent_id` bigint UNSIGNED DEFAULT NULL COMMENT 'For replies',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `timestamp` int DEFAULT NULL COMMENT 'Comment at specific time in song',
  `total_likes` int NOT NULL DEFAULT '0',
  `total_replies` int NOT NULL DEFAULT '0',
  `is_pinned` tinyint(1) NOT NULL DEFAULT '0',
  `is_edited` tinyint(1) NOT NULL DEFAULT '0',
  `status` enum('active','hidden','deleted','flagged') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `comment_likes`
--

CREATE TABLE `comment_likes` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `comment_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `copyrights`
--

CREATE TABLE `copyrights` (
  `id` bigint UNSIGNED NOT NULL,
  `song_id` bigint UNSIGNED NOT NULL,
  `partner_id` bigint UNSIGNED NOT NULL,
  `copyright_type` enum('author','performer','producer','publisher','exclusive','non_exclusive','creative_commons','public_domain') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'author',
  `owner_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `registration_number` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `registration_date` date DEFAULT NULL,
  `registration_country` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `valid_from` date NOT NULL,
  `valid_until` date DEFAULT NULL,
  `territory` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'Worldwide',
  `rights_included` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'JSON: streaming, download, sync, etc',
  `document_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `status` enum('active','expired','pending','disputed','revoked') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `verified_at` timestamp NULL DEFAULT NULL,
  `verified_by` bigint UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `copyrights`
--

INSERT INTO `copyrights` (`id`, `song_id`, `partner_id`, `copyright_type`, `owner_name`, `registration_number`, `registration_date`, `registration_country`, `valid_from`, `valid_until`, `territory`, `rights_included`, `document_url`, `notes`, `status`, `verified_at`, `verified_by`, `created_at`, `updated_at`) VALUES
(1, 35, 15, 'author', 'Sơn Tùng MTP', 'USUYG1749557', '2026-05-15', 'Viet Nam', '2026-05-15', NULL, 'Vietnam', '[\"reproduction\",\"distribution\",\"performance\",\"broadcast\",\"sync\",\"digital\"]', 'https://res.cloudinary.com/djgps2bk9/raw/upload/v1778827999/copyright_documents/USUYG1749557_1778827990.docx', NULL, 'active', '2026-05-18 07:19:13', NULL, '2026-05-14 23:53:20', '2026-05-18 07:19:13'),
(2, 61, 18, 'author', 'Long Nón Lá', 'OST Tiểu Đội 1978', '2026-05-19', 'Viet Nam', '2026-05-19', NULL, 'Vietnam', '[\"reproduction\",\"distribution\",\"performance\",\"broadcast\",\"sync\"]', 'https://res.cloudinary.com/djgps2bk9/raw/upload/v1779167146/copyright_documents/OST%20Ti%E1%BB%83u%20%C4%90%E1%BB%99i%201978_1779167136.docx', 'cần fix lại tài liệu nhé', 'revoked', NULL, NULL, '2026-05-18 22:05:47', '2026-05-18 22:07:16'),
(3, 61, 18, 'author', 'Long Nón Lá', 'OST Tiểu Đội 1978', '2026-05-19', 'Viet Nam', '2026-05-19', NULL, 'Vietnam', '[\"reproduction\",\"distribution\",\"performance\",\"broadcast\",\"sync\",\"digital\"]', 'https://res.cloudinary.com/djgps2bk9/raw/upload/v1779167575/copyright_documents/OST%20Ti%E1%BB%83u%20%C4%90%E1%BB%99i%201978_1779167572.docx', NULL, 'active', '2026-05-18 22:13:24', NULL, '2026-05-18 22:12:56', '2026-05-18 22:13:24'),
(4, 100, 18, 'author', 'Long Nón Lá', 'VCPMC', '2026-05-20', 'Viet Nam', '2026-05-20', NULL, 'Vietnam', '[\"reproduction\",\"performance\",\"broadcast\",\"sync\",\"digital\",\"distribution\"]', NULL, NULL, 'active', '2026-05-19 23:42:03', NULL, '2026-05-19 23:40:02', '2026-05-19 23:42:03'),
(5, 105, 18, 'author', 'Long nón lá', '00000012', '2026-05-26', 'Viet Nam', '2026-05-26', NULL, 'Vietnam', '[\"reproduction\",\"distribution\",\"performance\",\"broadcast\",\"sync\",\"digital\"]', 'https://res.cloudinary.com/djgps2bk9/image/upload/v1779766827/copyright_documents/00000012_1779766816.pdf', 'Tài liệu bị lỗi', 'revoked', NULL, NULL, '2026-05-25 20:40:27', '2026-05-25 20:45:55'),
(6, 105, 18, 'author', 'Long Nón Lá', '0111000', '2026-05-26', 'Viet Nam', '2026-05-26', NULL, 'Vietnam', '[\"reproduction\",\"distribution\",\"performance\",\"broadcast\",\"digital\",\"sync\"]', 'https://res.cloudinary.com/djgps2bk9/raw/upload/v1779767596/copyright_documents/0111000_1779767592.docx', NULL, 'active', '2026-05-25 20:53:45', NULL, '2026-05-25 20:53:16', '2026-05-25 20:53:45');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `copyright_reports`
--

CREATE TABLE `copyright_reports` (
  `id` bigint UNSIGNED NOT NULL,
  `reporter_type` enum('partner','artist','user') COLLATE utf8mb4_unicode_ci NOT NULL,
  `reporter_partner_id` bigint UNSIGNED DEFAULT NULL,
  `reporter_user_id` bigint UNSIGNED DEFAULT NULL,
  `claimant_copyright_id` bigint UNSIGNED DEFAULT NULL,
  `original_song_id` bigint UNSIGNED NOT NULL,
  `infringing_song_id` bigint UNSIGNED NOT NULL,
  `violation_type` enum('melody','lyrics','beat','full_copy','unauthorized_remix','other') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `evidence_files` json DEFAULT NULL,
  `similarity_score` decimal(5,2) DEFAULT NULL,
  `similarity_raw` decimal(6,5) DEFAULT NULL COMMENT 'Raw score from soundalike (0-1)',
  `ai_report_path` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `comparison_duration_ms` int DEFAULT NULL COMMENT 'Time taken for comparison (milliseconds)',
  `fingerprint_cache_hit` tinyint(1) DEFAULT '0' COMMENT 'Did we use cached fingerprint?',
  `status` enum('pending','ai_scanning','auto_rejected','reviewing','resolved_removed','resolved_kept','rejected') COLLATE utf8mb4_unicode_ci DEFAULT 'pending',
  `resolution_note` text COLLATE utf8mb4_unicode_ci,
  `resolved_by` bigint UNSIGNED DEFAULT NULL,
  `resolved_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `copyright_reports`
--

INSERT INTO `copyright_reports` (`id`, `reporter_type`, `reporter_partner_id`, `reporter_user_id`, `claimant_copyright_id`, `original_song_id`, `infringing_song_id`, `violation_type`, `description`, `evidence_files`, `similarity_score`, `similarity_raw`, `ai_report_path`, `comparison_duration_ms`, `fingerprint_cache_hit`, `status`, `resolution_note`, `resolved_by`, `resolved_at`, `created_at`, `updated_at`) VALUES
(5, 'partner', 18, NULL, NULL, 100, 106, 'melody', 'Vi phạm về bản quyền', '[]', 50.70, 0.50700, '{\"success\":true,\"similarity_raw\":0.507,\"similarity_percent\":50.7,\"is_violation\":false}', 2992, 0, 'auto_rejected', NULL, NULL, NULL, '2026-05-20 02:54:44', '2026-05-20 02:54:49'),
(7, 'partner', 18, NULL, NULL, 100, 107, 'melody', 'Vi Phạm bản quyền của tôi', '[]', 86.10, 0.86100, '{\"success\":true,\"similarity_raw\":0.861,\"similarity_percent\":86.1,\"is_violation\":true}', 3724, 0, 'resolved_removed', NULL, NULL, '2026-05-20 03:46:50', '2026-05-20 03:38:13', '2026-05-20 03:46:50');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `coupon_codes`
--

CREATE TABLE `coupon_codes` (
  `id` bigint UNSIGNED NOT NULL,
  `code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` enum('percentage','fixed_amount','free_trial') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `discount_value` decimal(10,2) NOT NULL,
  `currency` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'VND',
  `max_uses` int DEFAULT NULL,
  `used_count` int NOT NULL DEFAULT '0',
  `max_uses_per_user` int DEFAULT '1',
  `min_purchase_amount` decimal(10,2) DEFAULT '0.00',
  `applicable_plans` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'JSON array of plan IDs',
  `valid_from` timestamp NULL DEFAULT NULL,
  `valid_until` timestamp NULL DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `coupon_usage`
--

CREATE TABLE `coupon_usage` (
  `id` bigint UNSIGNED NOT NULL,
  `coupon_id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `payment_id` bigint UNSIGNED DEFAULT NULL,
  `discount_applied` decimal(10,2) NOT NULL,
  `used_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `daily_statistics`
--

CREATE TABLE `daily_statistics` (
  `id` bigint UNSIGNED NOT NULL,
  `date` date NOT NULL,
  `total_users` int NOT NULL DEFAULT '0',
  `new_users` int NOT NULL DEFAULT '0',
  `active_users` int NOT NULL DEFAULT '0',
  `total_songs` int NOT NULL DEFAULT '0',
  `new_songs` int NOT NULL DEFAULT '0',
  `total_plays` bigint NOT NULL DEFAULT '0',
  `total_downloads` bigint NOT NULL DEFAULT '0',
  `total_likes` bigint NOT NULL DEFAULT '0',
  `total_comments` int NOT NULL DEFAULT '0',
  `total_shares` int NOT NULL DEFAULT '0',
  `vip_subscriptions` int NOT NULL DEFAULT '0',
  `new_subscriptions` int NOT NULL DEFAULT '0',
  `cancelled_subscriptions` int NOT NULL DEFAULT '0',
  `subscription_revenue` decimal(15,2) NOT NULL DEFAULT '0.00',
  `ad_revenue` decimal(15,2) NOT NULL DEFAULT '0.00',
  `total_revenue` decimal(15,2) NOT NULL DEFAULT '0.00',
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `email_logs`
--

CREATE TABLE `email_logs` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED DEFAULT NULL,
  `template_id` bigint UNSIGNED DEFAULT NULL,
  `to_email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `subject` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `body` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` enum('pending','sent','failed','bounced') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `sent_at` timestamp NULL DEFAULT NULL,
  `failed_reason` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `opens` int NOT NULL DEFAULT '0',
  `clicks` int NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `email_templates`
--

CREATE TABLE `email_templates` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `subject` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `body` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `variables` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'JSON: available variables',
  `category` enum('transactional','marketing','notification','system') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint UNSIGNED NOT NULL,
  `uuid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `connection` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `failed_jobs`
--

INSERT INTO `failed_jobs` (`id`, `uuid`, `connection`, `queue`, `payload`, `exception`, `failed_at`) VALUES
(71, '8b82d7dc-10cb-4acf-89df-3711e5c3fd49', 'database', 'copyright', '{\"uuid\":\"8b82d7dc-10cb-4acf-89df-3711e5c3fd49\",\"displayName\":\"App\\\\Jobs\\\\ProcessCopyrightReport\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":3,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":\"30\",\"timeout\":180,\"retryUntil\":null,\"data\":{\"commandName\":\"App\\\\Jobs\\\\ProcessCopyrightReport\",\"command\":\"O:31:\\\"App\\\\Jobs\\\\ProcessCopyrightReport\\\":1:{s:9:\\\"\\u0000*\\u0000report\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:26:\\\"App\\\\Models\\\\CopyrightReport\\\";s:2:\\\"id\\\";i:1;s:9:\\\"relations\\\";a:0:{}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}}\"},\"createdAt\":1779268429,\"delay\":null}', 'GuzzleHttp\\Exception\\ConnectException: cURL error 6: Could not resolve host: compare-urls (see https://curl.haxx.se/libcurl/c/libcurl-errors.html) in D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\guzzlehttp\\guzzle\\src\\Handler\\CurlFactory.php:277\nStack trace:\n#0 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\guzzlehttp\\guzzle\\src\\Handler\\CurlFactory.php(207): GuzzleHttp\\Handler\\CurlFactory::createRejection(Object(GuzzleHttp\\Handler\\EasyHandle), Array)\n#1 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\guzzlehttp\\guzzle\\src\\Handler\\CurlFactory.php(159): GuzzleHttp\\Handler\\CurlFactory::finishError(Object(GuzzleHttp\\Handler\\CurlHandler), Object(GuzzleHttp\\Handler\\EasyHandle), Object(GuzzleHttp\\Handler\\CurlFactory))\n#2 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\guzzlehttp\\guzzle\\src\\Handler\\CurlHandler.php(47): GuzzleHttp\\Handler\\CurlFactory::finish(Object(GuzzleHttp\\Handler\\CurlHandler), Object(GuzzleHttp\\Handler\\EasyHandle), Object(GuzzleHttp\\Handler\\CurlFactory))\n#3 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\guzzlehttp\\guzzle\\src\\Handler\\Proxy.php(28): GuzzleHttp\\Handler\\CurlHandler->__invoke(Object(GuzzleHttp\\Psr7\\Request), Array)\n#4 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\guzzlehttp\\guzzle\\src\\Handler\\Proxy.php(48): GuzzleHttp\\Handler\\Proxy::GuzzleHttp\\Handler\\{closure}(Object(GuzzleHttp\\Psr7\\Request), Array)\n#5 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Http\\Client\\PendingRequest.php(1401): GuzzleHttp\\Handler\\Proxy::GuzzleHttp\\Handler\\{closure}(Object(GuzzleHttp\\Psr7\\Request), Array)\n#6 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Http\\Client\\PendingRequest.php(1367): Illuminate\\Http\\Client\\PendingRequest->Illuminate\\Http\\Client\\{closure}(Object(GuzzleHttp\\Psr7\\Request), Array)\n#7 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Http\\Client\\PendingRequest.php(1353): Illuminate\\Http\\Client\\PendingRequest->Illuminate\\Http\\Client\\{closure}(Object(GuzzleHttp\\Psr7\\Request), Array)\n#8 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\guzzlehttp\\guzzle\\src\\PrepareBodyMiddleware.php(64): Illuminate\\Http\\Client\\PendingRequest->Illuminate\\Http\\Client\\{closure}(Object(GuzzleHttp\\Psr7\\Request), Array)\n#9 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\guzzlehttp\\guzzle\\src\\Middleware.php(38): GuzzleHttp\\PrepareBodyMiddleware->__invoke(Object(GuzzleHttp\\Psr7\\Request), Array)\n#10 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\guzzlehttp\\guzzle\\src\\RedirectMiddleware.php(71): GuzzleHttp\\Middleware::GuzzleHttp\\{closure}(Object(GuzzleHttp\\Psr7\\Request), Array)\n#11 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\guzzlehttp\\guzzle\\src\\Middleware.php(63): GuzzleHttp\\RedirectMiddleware->__invoke(Object(GuzzleHttp\\Psr7\\Request), Array)\n#12 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\guzzlehttp\\guzzle\\src\\HandlerStack.php(75): GuzzleHttp\\Middleware::GuzzleHttp\\{closure}(Object(GuzzleHttp\\Psr7\\Request), Array)\n#13 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\guzzlehttp\\guzzle\\src\\Client.php(333): GuzzleHttp\\HandlerStack->__invoke(Object(GuzzleHttp\\Psr7\\Request), Array)\n#14 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\guzzlehttp\\guzzle\\src\\Client.php(169): GuzzleHttp\\Client->transfer(Object(GuzzleHttp\\Psr7\\Request), Array)\n#15 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\guzzlehttp\\guzzle\\src\\Client.php(189): GuzzleHttp\\Client->requestAsync(\'POST\', Object(GuzzleHttp\\Psr7\\Uri), Array)\n#16 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Http\\Client\\PendingRequest.php(1199): GuzzleHttp\\Client->request(\'POST\', \'compare-urls\', Array)\n#17 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Http\\Client\\PendingRequest.php(944): Illuminate\\Http\\Client\\PendingRequest->sendRequest(\'POST\', \'compare-urls\', Array)\n#18 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Support\\helpers.php(329): Illuminate\\Http\\Client\\PendingRequest->Illuminate\\Http\\Client\\{closure}(1)\n#19 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Http\\Client\\PendingRequest.php(942): retry(0, Object(Closure), 100, Object(Closure))\n#20 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Http\\Client\\PendingRequest.php(830): Illuminate\\Http\\Client\\PendingRequest->send(\'POST\', \'compare-urls\', Array)\n#21 D:\\Project_Music_MelodyHub\\source\\Backend\\app\\Services\\SoundalikeService.php(20): Illuminate\\Http\\Client\\PendingRequest->post(\'/compare-urls\', Array)\n#22 D:\\Project_Music_MelodyHub\\source\\Backend\\app\\Jobs\\ProcessCopyrightReport.php(94): App\\Services\\SoundalikeService->compare(\'https://res.clo...\', \'https://res.clo...\')\n#23 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\BoundMethod.php(36): App\\Jobs\\ProcessCopyrightReport->handle(Object(App\\Services\\SoundalikeService))\n#24 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\Util.php(43): Illuminate\\Container\\BoundMethod::Illuminate\\Container\\{closure}()\n#25 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#26 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#27 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\Container.php(836): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#28 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Bus\\Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#29 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Pipeline\\Pipeline.php(180): Illuminate\\Bus\\Dispatcher->Illuminate\\Bus\\{closure}(Object(App\\Jobs\\ProcessCopyrightReport))\n#30 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Pipeline\\Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->Illuminate\\Pipeline\\{closure}(Object(App\\Jobs\\ProcessCopyrightReport))\n#31 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Bus\\Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#32 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\CallQueuedHandler.php(134): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(App\\Jobs\\ProcessCopyrightReport), false)\n#33 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Pipeline\\Pipeline.php(180): Illuminate\\Queue\\CallQueuedHandler->Illuminate\\Queue\\{closure}(Object(App\\Jobs\\ProcessCopyrightReport))\n#34 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Pipeline\\Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->Illuminate\\Pipeline\\{closure}(Object(App\\Jobs\\ProcessCopyrightReport))\n#35 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\CallQueuedHandler.php(127): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#36 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\CallQueuedHandler.php(68): Illuminate\\Queue\\CallQueuedHandler->dispatchThroughMiddleware(Object(Illuminate\\Queue\\Jobs\\DatabaseJob), Object(App\\Jobs\\ProcessCopyrightReport))\n#37 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Jobs\\Job.php(102): Illuminate\\Queue\\CallQueuedHandler->call(Object(Illuminate\\Queue\\Jobs\\DatabaseJob), Array)\n#38 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Worker.php(451): Illuminate\\Queue\\Jobs\\Job->fire()\n#39 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Worker.php(401): Illuminate\\Queue\\Worker->process(\'database\', Object(Illuminate\\Queue\\Jobs\\DatabaseJob), Object(Illuminate\\Queue\\WorkerOptions))\n#40 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Worker.php(187): Illuminate\\Queue\\Worker->runJob(Object(Illuminate\\Queue\\Jobs\\DatabaseJob), \'database\', Object(Illuminate\\Queue\\WorkerOptions))\n#41 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Console\\WorkCommand.php(148): Illuminate\\Queue\\Worker->daemon(\'database\', \'copyright\', Object(Illuminate\\Queue\\WorkerOptions))\n#42 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Console\\WorkCommand.php(131): Illuminate\\Queue\\Console\\WorkCommand->runWorker(\'database\', \'copyright\')\n#43 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\BoundMethod.php(36): Illuminate\\Queue\\Console\\WorkCommand->handle()\n#44 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\Util.php(43): Illuminate\\Container\\BoundMethod::Illuminate\\Container\\{closure}()\n#45 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#46 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#47 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\Container.php(836): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#48 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Console\\Command.php(211): Illuminate\\Container\\Container->call(Array)\n#49 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\symfony\\console\\Command\\Command.php(318): Illuminate\\Console\\Command->execute(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#50 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Console\\Command.php(180): Symfony\\Component\\Console\\Command\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#51 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\symfony\\console\\Application.php(1110): Illuminate\\Console\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#52 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\symfony\\console\\Application.php(359): Symfony\\Component\\Console\\Application->doRunCommand(Object(Illuminate\\Queue\\Console\\WorkCommand), Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#53 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\symfony\\console\\Application.php(194): Symfony\\Component\\Console\\Application->doRun(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#54 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Foundation\\Console\\Kernel.php(197): Symfony\\Component\\Console\\Application->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#55 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Foundation\\Application.php(1235): Illuminate\\Foundation\\Console\\Kernel->handle(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#56 D:\\Project_Music_MelodyHub\\source\\Backend\\artisan(16): Illuminate\\Foundation\\Application->handleCommand(Object(Symfony\\Component\\Console\\Input\\ArgvInput))\n#57 {main}\n\nNext Illuminate\\Http\\Client\\ConnectionException: cURL error 6: Could not resolve host: compare-urls (see https://curl.haxx.se/libcurl/c/libcurl-errors.html) in D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Http\\Client\\PendingRequest.php:1653\nStack trace:\n#0 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Http\\Client\\PendingRequest.php(979): Illuminate\\Http\\Client\\PendingRequest->marshalConnectionException(Object(GuzzleHttp\\Exception\\ConnectException))\n#1 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Support\\helpers.php(329): Illuminate\\Http\\Client\\PendingRequest->Illuminate\\Http\\Client\\{closure}(1)\n#2 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Http\\Client\\PendingRequest.php(942): retry(0, Object(Closure), 100, Object(Closure))\n#3 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Http\\Client\\PendingRequest.php(830): Illuminate\\Http\\Client\\PendingRequest->send(\'POST\', \'compare-urls\', Array)\n#4 D:\\Project_Music_MelodyHub\\source\\Backend\\app\\Services\\SoundalikeService.php(20): Illuminate\\Http\\Client\\PendingRequest->post(\'/compare-urls\', Array)\n#5 D:\\Project_Music_MelodyHub\\source\\Backend\\app\\Jobs\\ProcessCopyrightReport.php(94): App\\Services\\SoundalikeService->compare(\'https://res.clo...\', \'https://res.clo...\')\n#6 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\BoundMethod.php(36): App\\Jobs\\ProcessCopyrightReport->handle(Object(App\\Services\\SoundalikeService))\n#7 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\Util.php(43): Illuminate\\Container\\BoundMethod::Illuminate\\Container\\{closure}()\n#8 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#9 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#10 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\Container.php(836): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#11 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Bus\\Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#12 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Pipeline\\Pipeline.php(180): Illuminate\\Bus\\Dispatcher->Illuminate\\Bus\\{closure}(Object(App\\Jobs\\ProcessCopyrightReport))\n#13 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Pipeline\\Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->Illuminate\\Pipeline\\{closure}(Object(App\\Jobs\\ProcessCopyrightReport))\n#14 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Bus\\Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#15 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\CallQueuedHandler.php(134): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(App\\Jobs\\ProcessCopyrightReport), false)\n#16 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Pipeline\\Pipeline.php(180): Illuminate\\Queue\\CallQueuedHandler->Illuminate\\Queue\\{closure}(Object(App\\Jobs\\ProcessCopyrightReport))\n#17 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Pipeline\\Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->Illuminate\\Pipeline\\{closure}(Object(App\\Jobs\\ProcessCopyrightReport))\n#18 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\CallQueuedHandler.php(127): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#19 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\CallQueuedHandler.php(68): Illuminate\\Queue\\CallQueuedHandler->dispatchThroughMiddleware(Object(Illuminate\\Queue\\Jobs\\DatabaseJob), Object(App\\Jobs\\ProcessCopyrightReport))\n#20 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Jobs\\Job.php(102): Illuminate\\Queue\\CallQueuedHandler->call(Object(Illuminate\\Queue\\Jobs\\DatabaseJob), Array)\n#21 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Worker.php(451): Illuminate\\Queue\\Jobs\\Job->fire()\n#22 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Worker.php(401): Illuminate\\Queue\\Worker->process(\'database\', Object(Illuminate\\Queue\\Jobs\\DatabaseJob), Object(Illuminate\\Queue\\WorkerOptions))\n#23 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Worker.php(187): Illuminate\\Queue\\Worker->runJob(Object(Illuminate\\Queue\\Jobs\\DatabaseJob), \'database\', Object(Illuminate\\Queue\\WorkerOptions))\n#24 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Console\\WorkCommand.php(148): Illuminate\\Queue\\Worker->daemon(\'database\', \'copyright\', Object(Illuminate\\Queue\\WorkerOptions))\n#25 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Console\\WorkCommand.php(131): Illuminate\\Queue\\Console\\WorkCommand->runWorker(\'database\', \'copyright\')\n#26 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\BoundMethod.php(36): Illuminate\\Queue\\Console\\WorkCommand->handle()\n#27 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\Util.php(43): Illuminate\\Container\\BoundMethod::Illuminate\\Container\\{closure}()\n#28 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#29 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#30 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\Container.php(836): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#31 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Console\\Command.php(211): Illuminate\\Container\\Container->call(Array)\n#32 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\symfony\\console\\Command\\Command.php(318): Illuminate\\Console\\Command->execute(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#33 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Console\\Command.php(180): Symfony\\Component\\Console\\Command\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#34 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\symfony\\console\\Application.php(1110): Illuminate\\Console\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#35 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\symfony\\console\\Application.php(359): Symfony\\Component\\Console\\Application->doRunCommand(Object(Illuminate\\Queue\\Console\\WorkCommand), Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#36 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\symfony\\console\\Application.php(194): Symfony\\Component\\Console\\Application->doRun(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#37 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Foundation\\Console\\Kernel.php(197): Symfony\\Component\\Console\\Application->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#38 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Foundation\\Application.php(1235): Illuminate\\Foundation\\Console\\Kernel->handle(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#39 D:\\Project_Music_MelodyHub\\source\\Backend\\artisan(16): Illuminate\\Foundation\\Application->handleCommand(Object(Symfony\\Component\\Console\\Input\\ArgvInput))\n#40 {main}', '2026-05-20 02:15:03'),
(72, '28d42f03-9aea-404e-a309-7d7dc431e502', 'database', 'lyrics', '{\"uuid\":\"28d42f03-9aea-404e-a309-7d7dc431e502\",\"displayName\":\"App\\\\Jobs\\\\GenerateLyricsJob\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":3,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":\"30,60,120\",\"timeout\":300,\"retryUntil\":null,\"data\":{\"commandName\":\"App\\\\Jobs\\\\GenerateLyricsJob\",\"command\":\"O:26:\\\"App\\\\Jobs\\\\GenerateLyricsJob\\\":3:{s:6:\\\"songId\\\";i:108;s:5:\\\"queue\\\";s:6:\\\"lyrics\\\";s:5:\\\"delay\\\";O:25:\\\"Illuminate\\\\Support\\\\Carbon\\\":3:{s:4:\\\"date\\\";s:26:\\\"2026-05-20 12:32:56.999990\\\";s:13:\\\"timezone_type\\\";i:3;s:8:\\\"timezone\\\";s:3:\\\"UTC\\\";}}\"},\"createdAt\":1779280367,\"delay\":9}', 'TypeError: App\\Jobs\\GenerateLyricsJob::buildAudioUrl(): Argument #1 ($publicId) must be of type string, null given, called in D:\\Project_Music_MelodyHub\\source\\Backend\\app\\Jobs\\GenerateLyricsJob.php on line 89 and defined in D:\\Project_Music_MelodyHub\\source\\Backend\\app\\Jobs\\GenerateLyricsJob.php:279\nStack trace:\n#0 D:\\Project_Music_MelodyHub\\source\\Backend\\app\\Jobs\\GenerateLyricsJob.php(89): App\\Jobs\\GenerateLyricsJob->buildAudioUrl(NULL)\n#1 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\BoundMethod.php(36): App\\Jobs\\GenerateLyricsJob->handle()\n#2 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\Util.php(43): Illuminate\\Container\\BoundMethod::Illuminate\\Container\\{closure}()\n#3 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#4 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#5 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\Container.php(836): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#6 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Bus\\Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#7 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Pipeline\\Pipeline.php(180): Illuminate\\Bus\\Dispatcher->Illuminate\\Bus\\{closure}(Object(App\\Jobs\\GenerateLyricsJob))\n#8 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Pipeline\\Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->Illuminate\\Pipeline\\{closure}(Object(App\\Jobs\\GenerateLyricsJob))\n#9 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Bus\\Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#10 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\CallQueuedHandler.php(134): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(App\\Jobs\\GenerateLyricsJob), false)\n#11 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Pipeline\\Pipeline.php(180): Illuminate\\Queue\\CallQueuedHandler->Illuminate\\Queue\\{closure}(Object(App\\Jobs\\GenerateLyricsJob))\n#12 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Pipeline\\Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->Illuminate\\Pipeline\\{closure}(Object(App\\Jobs\\GenerateLyricsJob))\n#13 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\CallQueuedHandler.php(127): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#14 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\CallQueuedHandler.php(68): Illuminate\\Queue\\CallQueuedHandler->dispatchThroughMiddleware(Object(Illuminate\\Queue\\Jobs\\DatabaseJob), Object(App\\Jobs\\GenerateLyricsJob))\n#15 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Jobs\\Job.php(102): Illuminate\\Queue\\CallQueuedHandler->call(Object(Illuminate\\Queue\\Jobs\\DatabaseJob), Array)\n#16 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Worker.php(451): Illuminate\\Queue\\Jobs\\Job->fire()\n#17 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Worker.php(401): Illuminate\\Queue\\Worker->process(\'database\', Object(Illuminate\\Queue\\Jobs\\DatabaseJob), Object(Illuminate\\Queue\\WorkerOptions))\n#18 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Worker.php(187): Illuminate\\Queue\\Worker->runJob(Object(Illuminate\\Queue\\Jobs\\DatabaseJob), \'database\', Object(Illuminate\\Queue\\WorkerOptions))\n#19 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Console\\WorkCommand.php(148): Illuminate\\Queue\\Worker->daemon(\'database\', \'lyrics,default\', Object(Illuminate\\Queue\\WorkerOptions))\n#20 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Console\\WorkCommand.php(131): Illuminate\\Queue\\Console\\WorkCommand->runWorker(\'database\', \'lyrics,default\')\n#21 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\BoundMethod.php(36): Illuminate\\Queue\\Console\\WorkCommand->handle()\n#22 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\Util.php(43): Illuminate\\Container\\BoundMethod::Illuminate\\Container\\{closure}()\n#23 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#24 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#25 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\Container.php(836): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#26 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Console\\Command.php(211): Illuminate\\Container\\Container->call(Array)\n#27 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\symfony\\console\\Command\\Command.php(318): Illuminate\\Console\\Command->execute(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#28 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Console\\Command.php(180): Symfony\\Component\\Console\\Command\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#29 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\symfony\\console\\Application.php(1110): Illuminate\\Console\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#30 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\symfony\\console\\Application.php(359): Symfony\\Component\\Console\\Application->doRunCommand(Object(Illuminate\\Queue\\Console\\WorkCommand), Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#31 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\symfony\\console\\Application.php(194): Symfony\\Component\\Console\\Application->doRun(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#32 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Foundation\\Console\\Kernel.php(197): Symfony\\Component\\Console\\Application->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#33 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Foundation\\Application.php(1235): Illuminate\\Foundation\\Console\\Kernel->handle(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#34 D:\\Project_Music_MelodyHub\\source\\Backend\\artisan(16): Illuminate\\Foundation\\Application->handleCommand(Object(Symfony\\Component\\Console\\Input\\ArgvInput))\n#35 {main}', '2026-05-20 05:34:30'),
(73, 'b6a43de0-9db6-4c74-8b40-23a0832bcf5c', 'database', 'lyrics', '{\"uuid\":\"b6a43de0-9db6-4c74-8b40-23a0832bcf5c\",\"displayName\":\"App\\\\Jobs\\\\GenerateLyricsJob\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":3,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":\"30,60,120\",\"timeout\":300,\"retryUntil\":null,\"data\":{\"commandName\":\"App\\\\Jobs\\\\GenerateLyricsJob\",\"command\":\"O:26:\\\"App\\\\Jobs\\\\GenerateLyricsJob\\\":3:{s:6:\\\"songId\\\";i:109;s:5:\\\"queue\\\";s:6:\\\"lyrics\\\";s:5:\\\"delay\\\";O:25:\\\"Illuminate\\\\Support\\\\Carbon\\\":3:{s:4:\\\"date\\\";s:26:\\\"2026-05-20 12:34:11.866072\\\";s:13:\\\"timezone_type\\\";i:3;s:8:\\\"timezone\\\";s:3:\\\"UTC\\\";}}\"},\"createdAt\":1779280441,\"delay\":10}', 'TypeError: App\\Jobs\\GenerateLyricsJob::buildAudioUrl(): Argument #1 ($publicId) must be of type string, null given, called in D:\\Project_Music_MelodyHub\\source\\Backend\\app\\Jobs\\GenerateLyricsJob.php on line 89 and defined in D:\\Project_Music_MelodyHub\\source\\Backend\\app\\Jobs\\GenerateLyricsJob.php:279\nStack trace:\n#0 D:\\Project_Music_MelodyHub\\source\\Backend\\app\\Jobs\\GenerateLyricsJob.php(89): App\\Jobs\\GenerateLyricsJob->buildAudioUrl(NULL)\n#1 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\BoundMethod.php(36): App\\Jobs\\GenerateLyricsJob->handle()\n#2 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\Util.php(43): Illuminate\\Container\\BoundMethod::Illuminate\\Container\\{closure}()\n#3 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#4 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#5 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\Container.php(836): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#6 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Bus\\Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#7 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Pipeline\\Pipeline.php(180): Illuminate\\Bus\\Dispatcher->Illuminate\\Bus\\{closure}(Object(App\\Jobs\\GenerateLyricsJob))\n#8 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Pipeline\\Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->Illuminate\\Pipeline\\{closure}(Object(App\\Jobs\\GenerateLyricsJob))\n#9 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Bus\\Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#10 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\CallQueuedHandler.php(134): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(App\\Jobs\\GenerateLyricsJob), false)\n#11 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Pipeline\\Pipeline.php(180): Illuminate\\Queue\\CallQueuedHandler->Illuminate\\Queue\\{closure}(Object(App\\Jobs\\GenerateLyricsJob))\n#12 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Pipeline\\Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->Illuminate\\Pipeline\\{closure}(Object(App\\Jobs\\GenerateLyricsJob))\n#13 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\CallQueuedHandler.php(127): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#14 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\CallQueuedHandler.php(68): Illuminate\\Queue\\CallQueuedHandler->dispatchThroughMiddleware(Object(Illuminate\\Queue\\Jobs\\DatabaseJob), Object(App\\Jobs\\GenerateLyricsJob))\n#15 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Jobs\\Job.php(102): Illuminate\\Queue\\CallQueuedHandler->call(Object(Illuminate\\Queue\\Jobs\\DatabaseJob), Array)\n#16 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Worker.php(451): Illuminate\\Queue\\Jobs\\Job->fire()\n#17 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Worker.php(401): Illuminate\\Queue\\Worker->process(\'database\', Object(Illuminate\\Queue\\Jobs\\DatabaseJob), Object(Illuminate\\Queue\\WorkerOptions))\n#18 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Worker.php(187): Illuminate\\Queue\\Worker->runJob(Object(Illuminate\\Queue\\Jobs\\DatabaseJob), \'database\', Object(Illuminate\\Queue\\WorkerOptions))\n#19 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Console\\WorkCommand.php(148): Illuminate\\Queue\\Worker->daemon(\'database\', \'lyrics,default\', Object(Illuminate\\Queue\\WorkerOptions))\n#20 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Console\\WorkCommand.php(131): Illuminate\\Queue\\Console\\WorkCommand->runWorker(\'database\', \'lyrics,default\')\n#21 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\BoundMethod.php(36): Illuminate\\Queue\\Console\\WorkCommand->handle()\n#22 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\Util.php(43): Illuminate\\Container\\BoundMethod::Illuminate\\Container\\{closure}()\n#23 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#24 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#25 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\Container.php(836): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#26 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Console\\Command.php(211): Illuminate\\Container\\Container->call(Array)\n#27 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\symfony\\console\\Command\\Command.php(318): Illuminate\\Console\\Command->execute(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#28 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Console\\Command.php(180): Symfony\\Component\\Console\\Command\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#29 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\symfony\\console\\Application.php(1110): Illuminate\\Console\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#30 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\symfony\\console\\Application.php(359): Symfony\\Component\\Console\\Application->doRunCommand(Object(Illuminate\\Queue\\Console\\WorkCommand), Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#31 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\symfony\\console\\Application.php(194): Symfony\\Component\\Console\\Application->doRun(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#32 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Foundation\\Console\\Kernel.php(197): Symfony\\Component\\Console\\Application->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#33 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Foundation\\Application.php(1235): Illuminate\\Foundation\\Console\\Kernel->handle(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#34 D:\\Project_Music_MelodyHub\\source\\Backend\\artisan(16): Illuminate\\Foundation\\Application->handleCommand(Object(Symfony\\Component\\Console\\Input\\ArgvInput))\n#35 {main}', '2026-05-20 05:35:43'),
(74, '7925bbe5-a90f-49f5-a9a9-3ad31f3a71d4', 'database', 'lyrics', '{\"uuid\":\"7925bbe5-a90f-49f5-a9a9-3ad31f3a71d4\",\"displayName\":\"App\\\\Jobs\\\\GenerateLyricsJob\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":3,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":\"30,60,120\",\"timeout\":300,\"retryUntil\":null,\"data\":{\"commandName\":\"App\\\\Jobs\\\\GenerateLyricsJob\",\"command\":\"O:26:\\\"App\\\\Jobs\\\\GenerateLyricsJob\\\":3:{s:6:\\\"songId\\\";i:110;s:5:\\\"queue\\\";s:6:\\\"lyrics\\\";s:5:\\\"delay\\\";O:25:\\\"Illuminate\\\\Support\\\\Carbon\\\":3:{s:4:\\\"date\\\";s:26:\\\"2026-05-20 12:35:50.319236\\\";s:13:\\\"timezone_type\\\";i:3;s:8:\\\"timezone\\\";s:3:\\\"UTC\\\";}}\"},\"createdAt\":1779280540,\"delay\":10}', 'TypeError: App\\Jobs\\GenerateLyricsJob::buildAudioUrl(): Argument #1 ($publicId) must be of type string, null given, called in D:\\Project_Music_MelodyHub\\source\\Backend\\app\\Jobs\\GenerateLyricsJob.php on line 89 and defined in D:\\Project_Music_MelodyHub\\source\\Backend\\app\\Jobs\\GenerateLyricsJob.php:279\nStack trace:\n#0 D:\\Project_Music_MelodyHub\\source\\Backend\\app\\Jobs\\GenerateLyricsJob.php(89): App\\Jobs\\GenerateLyricsJob->buildAudioUrl(NULL)\n#1 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\BoundMethod.php(36): App\\Jobs\\GenerateLyricsJob->handle()\n#2 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\Util.php(43): Illuminate\\Container\\BoundMethod::Illuminate\\Container\\{closure}()\n#3 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#4 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#5 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\Container.php(836): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#6 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Bus\\Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#7 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Pipeline\\Pipeline.php(180): Illuminate\\Bus\\Dispatcher->Illuminate\\Bus\\{closure}(Object(App\\Jobs\\GenerateLyricsJob))\n#8 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Pipeline\\Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->Illuminate\\Pipeline\\{closure}(Object(App\\Jobs\\GenerateLyricsJob))\n#9 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Bus\\Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#10 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\CallQueuedHandler.php(134): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(App\\Jobs\\GenerateLyricsJob), false)\n#11 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Pipeline\\Pipeline.php(180): Illuminate\\Queue\\CallQueuedHandler->Illuminate\\Queue\\{closure}(Object(App\\Jobs\\GenerateLyricsJob))\n#12 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Pipeline\\Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->Illuminate\\Pipeline\\{closure}(Object(App\\Jobs\\GenerateLyricsJob))\n#13 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\CallQueuedHandler.php(127): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#14 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\CallQueuedHandler.php(68): Illuminate\\Queue\\CallQueuedHandler->dispatchThroughMiddleware(Object(Illuminate\\Queue\\Jobs\\DatabaseJob), Object(App\\Jobs\\GenerateLyricsJob))\n#15 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Jobs\\Job.php(102): Illuminate\\Queue\\CallQueuedHandler->call(Object(Illuminate\\Queue\\Jobs\\DatabaseJob), Array)\n#16 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Worker.php(451): Illuminate\\Queue\\Jobs\\Job->fire()\n#17 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Worker.php(401): Illuminate\\Queue\\Worker->process(\'database\', Object(Illuminate\\Queue\\Jobs\\DatabaseJob), Object(Illuminate\\Queue\\WorkerOptions))\n#18 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Worker.php(187): Illuminate\\Queue\\Worker->runJob(Object(Illuminate\\Queue\\Jobs\\DatabaseJob), \'database\', Object(Illuminate\\Queue\\WorkerOptions))\n#19 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Console\\WorkCommand.php(148): Illuminate\\Queue\\Worker->daemon(\'database\', \'lyrics,default\', Object(Illuminate\\Queue\\WorkerOptions))\n#20 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Console\\WorkCommand.php(131): Illuminate\\Queue\\Console\\WorkCommand->runWorker(\'database\', \'lyrics,default\')\n#21 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\BoundMethod.php(36): Illuminate\\Queue\\Console\\WorkCommand->handle()\n#22 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\Util.php(43): Illuminate\\Container\\BoundMethod::Illuminate\\Container\\{closure}()\n#23 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#24 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#25 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\Container.php(836): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#26 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Console\\Command.php(211): Illuminate\\Container\\Container->call(Array)\n#27 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\symfony\\console\\Command\\Command.php(318): Illuminate\\Console\\Command->execute(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#28 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Console\\Command.php(180): Symfony\\Component\\Console\\Command\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#29 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\symfony\\console\\Application.php(1110): Illuminate\\Console\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#30 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\symfony\\console\\Application.php(359): Symfony\\Component\\Console\\Application->doRunCommand(Object(Illuminate\\Queue\\Console\\WorkCommand), Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#31 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\symfony\\console\\Application.php(194): Symfony\\Component\\Console\\Application->doRun(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#32 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Foundation\\Console\\Kernel.php(197): Symfony\\Component\\Console\\Application->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#33 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Foundation\\Application.php(1235): Illuminate\\Foundation\\Console\\Kernel->handle(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#34 D:\\Project_Music_MelodyHub\\source\\Backend\\artisan(16): Illuminate\\Foundation\\Application->handleCommand(Object(Symfony\\Component\\Console\\Input\\ArgvInput))\n#35 {main}', '2026-05-20 05:37:22');
INSERT INTO `failed_jobs` (`id`, `uuid`, `connection`, `queue`, `payload`, `exception`, `failed_at`) VALUES
(75, '1a25b44e-3acb-40c3-8c4a-bd46199a8499', 'database', 'lyrics', '{\"uuid\":\"1a25b44e-3acb-40c3-8c4a-bd46199a8499\",\"displayName\":\"App\\\\Jobs\\\\GenerateLyricsJob\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":3,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":\"30,60,120\",\"timeout\":300,\"retryUntil\":null,\"data\":{\"commandName\":\"App\\\\Jobs\\\\GenerateLyricsJob\",\"command\":\"O:26:\\\"App\\\\Jobs\\\\GenerateLyricsJob\\\":3:{s:6:\\\"songId\\\";i:111;s:5:\\\"queue\\\";s:6:\\\"lyrics\\\";s:5:\\\"delay\\\";O:25:\\\"Illuminate\\\\Support\\\\Carbon\\\":3:{s:4:\\\"date\\\";s:26:\\\"2026-05-20 12:37:01.079544\\\";s:13:\\\"timezone_type\\\";i:3;s:8:\\\"timezone\\\";s:3:\\\"UTC\\\";}}\"},\"createdAt\":1779280611,\"delay\":10}', 'TypeError: App\\Jobs\\GenerateLyricsJob::buildAudioUrl(): Argument #1 ($publicId) must be of type string, null given, called in D:\\Project_Music_MelodyHub\\source\\Backend\\app\\Jobs\\GenerateLyricsJob.php on line 89 and defined in D:\\Project_Music_MelodyHub\\source\\Backend\\app\\Jobs\\GenerateLyricsJob.php:279\nStack trace:\n#0 D:\\Project_Music_MelodyHub\\source\\Backend\\app\\Jobs\\GenerateLyricsJob.php(89): App\\Jobs\\GenerateLyricsJob->buildAudioUrl(NULL)\n#1 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\BoundMethod.php(36): App\\Jobs\\GenerateLyricsJob->handle()\n#2 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\Util.php(43): Illuminate\\Container\\BoundMethod::Illuminate\\Container\\{closure}()\n#3 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#4 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#5 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\Container.php(836): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#6 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Bus\\Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#7 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Pipeline\\Pipeline.php(180): Illuminate\\Bus\\Dispatcher->Illuminate\\Bus\\{closure}(Object(App\\Jobs\\GenerateLyricsJob))\n#8 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Pipeline\\Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->Illuminate\\Pipeline\\{closure}(Object(App\\Jobs\\GenerateLyricsJob))\n#9 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Bus\\Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#10 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\CallQueuedHandler.php(134): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(App\\Jobs\\GenerateLyricsJob), false)\n#11 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Pipeline\\Pipeline.php(180): Illuminate\\Queue\\CallQueuedHandler->Illuminate\\Queue\\{closure}(Object(App\\Jobs\\GenerateLyricsJob))\n#12 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Pipeline\\Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->Illuminate\\Pipeline\\{closure}(Object(App\\Jobs\\GenerateLyricsJob))\n#13 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\CallQueuedHandler.php(127): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#14 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\CallQueuedHandler.php(68): Illuminate\\Queue\\CallQueuedHandler->dispatchThroughMiddleware(Object(Illuminate\\Queue\\Jobs\\DatabaseJob), Object(App\\Jobs\\GenerateLyricsJob))\n#15 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Jobs\\Job.php(102): Illuminate\\Queue\\CallQueuedHandler->call(Object(Illuminate\\Queue\\Jobs\\DatabaseJob), Array)\n#16 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Worker.php(451): Illuminate\\Queue\\Jobs\\Job->fire()\n#17 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Worker.php(401): Illuminate\\Queue\\Worker->process(\'database\', Object(Illuminate\\Queue\\Jobs\\DatabaseJob), Object(Illuminate\\Queue\\WorkerOptions))\n#18 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Worker.php(187): Illuminate\\Queue\\Worker->runJob(Object(Illuminate\\Queue\\Jobs\\DatabaseJob), \'database\', Object(Illuminate\\Queue\\WorkerOptions))\n#19 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Console\\WorkCommand.php(148): Illuminate\\Queue\\Worker->daemon(\'database\', \'lyrics,default\', Object(Illuminate\\Queue\\WorkerOptions))\n#20 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Console\\WorkCommand.php(131): Illuminate\\Queue\\Console\\WorkCommand->runWorker(\'database\', \'lyrics,default\')\n#21 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\BoundMethod.php(36): Illuminate\\Queue\\Console\\WorkCommand->handle()\n#22 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\Util.php(43): Illuminate\\Container\\BoundMethod::Illuminate\\Container\\{closure}()\n#23 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#24 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#25 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\Container.php(836): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#26 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Console\\Command.php(211): Illuminate\\Container\\Container->call(Array)\n#27 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\symfony\\console\\Command\\Command.php(318): Illuminate\\Console\\Command->execute(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#28 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Console\\Command.php(180): Symfony\\Component\\Console\\Command\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#29 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\symfony\\console\\Application.php(1110): Illuminate\\Console\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#30 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\symfony\\console\\Application.php(359): Symfony\\Component\\Console\\Application->doRunCommand(Object(Illuminate\\Queue\\Console\\WorkCommand), Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#31 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\symfony\\console\\Application.php(194): Symfony\\Component\\Console\\Application->doRun(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#32 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Foundation\\Console\\Kernel.php(197): Symfony\\Component\\Console\\Application->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#33 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Foundation\\Application.php(1235): Illuminate\\Foundation\\Console\\Kernel->handle(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#34 D:\\Project_Music_MelodyHub\\source\\Backend\\artisan(16): Illuminate\\Foundation\\Application->handleCommand(Object(Symfony\\Component\\Console\\Input\\ArgvInput))\n#35 {main}', '2026-05-20 05:38:32'),
(76, '01027b35-d125-42fa-a62d-b18c7a013a23', 'database', 'lyrics', '{\"uuid\":\"01027b35-d125-42fa-a62d-b18c7a013a23\",\"displayName\":\"App\\\\Jobs\\\\GenerateLyricsJob\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":3,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":\"30,60,120\",\"timeout\":300,\"retryUntil\":null,\"data\":{\"commandName\":\"App\\\\Jobs\\\\GenerateLyricsJob\",\"command\":\"O:26:\\\"App\\\\Jobs\\\\GenerateLyricsJob\\\":3:{s:6:\\\"songId\\\";i:112;s:5:\\\"queue\\\";s:6:\\\"lyrics\\\";s:5:\\\"delay\\\";O:25:\\\"Illuminate\\\\Support\\\\Carbon\\\":3:{s:4:\\\"date\\\";s:26:\\\"2026-05-20 12:38:02.571705\\\";s:13:\\\"timezone_type\\\";i:3;s:8:\\\"timezone\\\";s:3:\\\"UTC\\\";}}\"},\"createdAt\":1779280672,\"delay\":10}', 'TypeError: App\\Jobs\\GenerateLyricsJob::buildAudioUrl(): Argument #1 ($publicId) must be of type string, null given, called in D:\\Project_Music_MelodyHub\\source\\Backend\\app\\Jobs\\GenerateLyricsJob.php on line 89 and defined in D:\\Project_Music_MelodyHub\\source\\Backend\\app\\Jobs\\GenerateLyricsJob.php:279\nStack trace:\n#0 D:\\Project_Music_MelodyHub\\source\\Backend\\app\\Jobs\\GenerateLyricsJob.php(89): App\\Jobs\\GenerateLyricsJob->buildAudioUrl(NULL)\n#1 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\BoundMethod.php(36): App\\Jobs\\GenerateLyricsJob->handle()\n#2 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\Util.php(43): Illuminate\\Container\\BoundMethod::Illuminate\\Container\\{closure}()\n#3 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#4 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#5 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\Container.php(836): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#6 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Bus\\Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#7 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Pipeline\\Pipeline.php(180): Illuminate\\Bus\\Dispatcher->Illuminate\\Bus\\{closure}(Object(App\\Jobs\\GenerateLyricsJob))\n#8 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Pipeline\\Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->Illuminate\\Pipeline\\{closure}(Object(App\\Jobs\\GenerateLyricsJob))\n#9 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Bus\\Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#10 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\CallQueuedHandler.php(134): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(App\\Jobs\\GenerateLyricsJob), false)\n#11 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Pipeline\\Pipeline.php(180): Illuminate\\Queue\\CallQueuedHandler->Illuminate\\Queue\\{closure}(Object(App\\Jobs\\GenerateLyricsJob))\n#12 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Pipeline\\Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->Illuminate\\Pipeline\\{closure}(Object(App\\Jobs\\GenerateLyricsJob))\n#13 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\CallQueuedHandler.php(127): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#14 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\CallQueuedHandler.php(68): Illuminate\\Queue\\CallQueuedHandler->dispatchThroughMiddleware(Object(Illuminate\\Queue\\Jobs\\DatabaseJob), Object(App\\Jobs\\GenerateLyricsJob))\n#15 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Jobs\\Job.php(102): Illuminate\\Queue\\CallQueuedHandler->call(Object(Illuminate\\Queue\\Jobs\\DatabaseJob), Array)\n#16 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Worker.php(451): Illuminate\\Queue\\Jobs\\Job->fire()\n#17 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Worker.php(401): Illuminate\\Queue\\Worker->process(\'database\', Object(Illuminate\\Queue\\Jobs\\DatabaseJob), Object(Illuminate\\Queue\\WorkerOptions))\n#18 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Worker.php(187): Illuminate\\Queue\\Worker->runJob(Object(Illuminate\\Queue\\Jobs\\DatabaseJob), \'database\', Object(Illuminate\\Queue\\WorkerOptions))\n#19 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Console\\WorkCommand.php(148): Illuminate\\Queue\\Worker->daemon(\'database\', \'lyrics,default\', Object(Illuminate\\Queue\\WorkerOptions))\n#20 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Console\\WorkCommand.php(131): Illuminate\\Queue\\Console\\WorkCommand->runWorker(\'database\', \'lyrics,default\')\n#21 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\BoundMethod.php(36): Illuminate\\Queue\\Console\\WorkCommand->handle()\n#22 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\Util.php(43): Illuminate\\Container\\BoundMethod::Illuminate\\Container\\{closure}()\n#23 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#24 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#25 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\Container.php(836): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#26 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Console\\Command.php(211): Illuminate\\Container\\Container->call(Array)\n#27 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\symfony\\console\\Command\\Command.php(318): Illuminate\\Console\\Command->execute(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#28 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Console\\Command.php(180): Symfony\\Component\\Console\\Command\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#29 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\symfony\\console\\Application.php(1110): Illuminate\\Console\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#30 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\symfony\\console\\Application.php(359): Symfony\\Component\\Console\\Application->doRunCommand(Object(Illuminate\\Queue\\Console\\WorkCommand), Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#31 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\symfony\\console\\Application.php(194): Symfony\\Component\\Console\\Application->doRun(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#32 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Foundation\\Console\\Kernel.php(197): Symfony\\Component\\Console\\Application->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#33 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Foundation\\Application.php(1235): Illuminate\\Foundation\\Console\\Kernel->handle(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#34 D:\\Project_Music_MelodyHub\\source\\Backend\\artisan(16): Illuminate\\Foundation\\Application->handleCommand(Object(Symfony\\Component\\Console\\Input\\ArgvInput))\n#35 {main}', '2026-05-20 05:39:32'),
(77, '030bf822-b983-4082-89c0-9af25681879b', 'database', 'lyrics', '{\"uuid\":\"030bf822-b983-4082-89c0-9af25681879b\",\"displayName\":\"App\\\\Jobs\\\\GenerateLyricsJob\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":3,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":\"30,60,120\",\"timeout\":300,\"retryUntil\":null,\"data\":{\"commandName\":\"App\\\\Jobs\\\\GenerateLyricsJob\",\"command\":\"O:26:\\\"App\\\\Jobs\\\\GenerateLyricsJob\\\":3:{s:6:\\\"songId\\\";i:113;s:5:\\\"queue\\\";s:6:\\\"lyrics\\\";s:5:\\\"delay\\\";O:25:\\\"Illuminate\\\\Support\\\\Carbon\\\":3:{s:4:\\\"date\\\";s:26:\\\"2026-05-20 12:40:32.385182\\\";s:13:\\\"timezone_type\\\";i:3;s:8:\\\"timezone\\\";s:3:\\\"UTC\\\";}}\"},\"createdAt\":1779280822,\"delay\":10}', 'TypeError: App\\Jobs\\GenerateLyricsJob::buildAudioUrl(): Argument #1 ($publicId) must be of type string, null given, called in D:\\Project_Music_MelodyHub\\source\\Backend\\app\\Jobs\\GenerateLyricsJob.php on line 89 and defined in D:\\Project_Music_MelodyHub\\source\\Backend\\app\\Jobs\\GenerateLyricsJob.php:279\nStack trace:\n#0 D:\\Project_Music_MelodyHub\\source\\Backend\\app\\Jobs\\GenerateLyricsJob.php(89): App\\Jobs\\GenerateLyricsJob->buildAudioUrl(NULL)\n#1 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\BoundMethod.php(36): App\\Jobs\\GenerateLyricsJob->handle()\n#2 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\Util.php(43): Illuminate\\Container\\BoundMethod::Illuminate\\Container\\{closure}()\n#3 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#4 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#5 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\Container.php(836): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#6 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Bus\\Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#7 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Pipeline\\Pipeline.php(180): Illuminate\\Bus\\Dispatcher->Illuminate\\Bus\\{closure}(Object(App\\Jobs\\GenerateLyricsJob))\n#8 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Pipeline\\Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->Illuminate\\Pipeline\\{closure}(Object(App\\Jobs\\GenerateLyricsJob))\n#9 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Bus\\Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#10 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\CallQueuedHandler.php(134): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(App\\Jobs\\GenerateLyricsJob), false)\n#11 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Pipeline\\Pipeline.php(180): Illuminate\\Queue\\CallQueuedHandler->Illuminate\\Queue\\{closure}(Object(App\\Jobs\\GenerateLyricsJob))\n#12 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Pipeline\\Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->Illuminate\\Pipeline\\{closure}(Object(App\\Jobs\\GenerateLyricsJob))\n#13 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\CallQueuedHandler.php(127): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#14 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\CallQueuedHandler.php(68): Illuminate\\Queue\\CallQueuedHandler->dispatchThroughMiddleware(Object(Illuminate\\Queue\\Jobs\\DatabaseJob), Object(App\\Jobs\\GenerateLyricsJob))\n#15 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Jobs\\Job.php(102): Illuminate\\Queue\\CallQueuedHandler->call(Object(Illuminate\\Queue\\Jobs\\DatabaseJob), Array)\n#16 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Worker.php(451): Illuminate\\Queue\\Jobs\\Job->fire()\n#17 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Worker.php(401): Illuminate\\Queue\\Worker->process(\'database\', Object(Illuminate\\Queue\\Jobs\\DatabaseJob), Object(Illuminate\\Queue\\WorkerOptions))\n#18 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Worker.php(187): Illuminate\\Queue\\Worker->runJob(Object(Illuminate\\Queue\\Jobs\\DatabaseJob), \'database\', Object(Illuminate\\Queue\\WorkerOptions))\n#19 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Console\\WorkCommand.php(148): Illuminate\\Queue\\Worker->daemon(\'database\', \'lyrics,default\', Object(Illuminate\\Queue\\WorkerOptions))\n#20 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Console\\WorkCommand.php(131): Illuminate\\Queue\\Console\\WorkCommand->runWorker(\'database\', \'lyrics,default\')\n#21 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\BoundMethod.php(36): Illuminate\\Queue\\Console\\WorkCommand->handle()\n#22 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\Util.php(43): Illuminate\\Container\\BoundMethod::Illuminate\\Container\\{closure}()\n#23 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#24 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#25 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\Container.php(836): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#26 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Console\\Command.php(211): Illuminate\\Container\\Container->call(Array)\n#27 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\symfony\\console\\Command\\Command.php(318): Illuminate\\Console\\Command->execute(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#28 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Console\\Command.php(180): Symfony\\Component\\Console\\Command\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#29 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\symfony\\console\\Application.php(1110): Illuminate\\Console\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#30 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\symfony\\console\\Application.php(359): Symfony\\Component\\Console\\Application->doRunCommand(Object(Illuminate\\Queue\\Console\\WorkCommand), Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#31 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\symfony\\console\\Application.php(194): Symfony\\Component\\Console\\Application->doRun(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#32 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Foundation\\Console\\Kernel.php(197): Symfony\\Component\\Console\\Application->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#33 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Foundation\\Application.php(1235): Illuminate\\Foundation\\Console\\Kernel->handle(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#34 D:\\Project_Music_MelodyHub\\source\\Backend\\artisan(16): Illuminate\\Foundation\\Application->handleCommand(Object(Symfony\\Component\\Console\\Input\\ArgvInput))\n#35 {main}', '2026-05-20 05:42:03'),
(78, '88f2192d-a27f-4e5f-9ff0-c873fd5e7453', 'database', 'lyrics', '{\"uuid\":\"88f2192d-a27f-4e5f-9ff0-c873fd5e7453\",\"displayName\":\"App\\\\Jobs\\\\GenerateLyricsJob\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":3,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":\"30,60,120\",\"timeout\":300,\"retryUntil\":null,\"data\":{\"commandName\":\"App\\\\Jobs\\\\GenerateLyricsJob\",\"command\":\"O:26:\\\"App\\\\Jobs\\\\GenerateLyricsJob\\\":3:{s:6:\\\"songId\\\";i:114;s:5:\\\"queue\\\";s:6:\\\"lyrics\\\";s:5:\\\"delay\\\";O:25:\\\"Illuminate\\\\Support\\\\Carbon\\\":3:{s:4:\\\"date\\\";s:26:\\\"2026-05-20 12:42:54.819702\\\";s:13:\\\"timezone_type\\\";i:3;s:8:\\\"timezone\\\";s:3:\\\"UTC\\\";}}\"},\"createdAt\":1779280964,\"delay\":10}', 'TypeError: App\\Jobs\\GenerateLyricsJob::buildAudioUrl(): Argument #1 ($publicId) must be of type string, null given, called in D:\\Project_Music_MelodyHub\\source\\Backend\\app\\Jobs\\GenerateLyricsJob.php on line 89 and defined in D:\\Project_Music_MelodyHub\\source\\Backend\\app\\Jobs\\GenerateLyricsJob.php:279\nStack trace:\n#0 D:\\Project_Music_MelodyHub\\source\\Backend\\app\\Jobs\\GenerateLyricsJob.php(89): App\\Jobs\\GenerateLyricsJob->buildAudioUrl(NULL)\n#1 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\BoundMethod.php(36): App\\Jobs\\GenerateLyricsJob->handle()\n#2 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\Util.php(43): Illuminate\\Container\\BoundMethod::Illuminate\\Container\\{closure}()\n#3 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#4 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#5 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\Container.php(836): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#6 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Bus\\Dispatcher.php(129): Illuminate\\Container\\Container->call(Array)\n#7 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Pipeline\\Pipeline.php(180): Illuminate\\Bus\\Dispatcher->Illuminate\\Bus\\{closure}(Object(App\\Jobs\\GenerateLyricsJob))\n#8 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Pipeline\\Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->Illuminate\\Pipeline\\{closure}(Object(App\\Jobs\\GenerateLyricsJob))\n#9 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Bus\\Dispatcher.php(133): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#10 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\CallQueuedHandler.php(134): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(App\\Jobs\\GenerateLyricsJob), false)\n#11 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Pipeline\\Pipeline.php(180): Illuminate\\Queue\\CallQueuedHandler->Illuminate\\Queue\\{closure}(Object(App\\Jobs\\GenerateLyricsJob))\n#12 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Pipeline\\Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->Illuminate\\Pipeline\\{closure}(Object(App\\Jobs\\GenerateLyricsJob))\n#13 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\CallQueuedHandler.php(127): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#14 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\CallQueuedHandler.php(68): Illuminate\\Queue\\CallQueuedHandler->dispatchThroughMiddleware(Object(Illuminate\\Queue\\Jobs\\DatabaseJob), Object(App\\Jobs\\GenerateLyricsJob))\n#15 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Jobs\\Job.php(102): Illuminate\\Queue\\CallQueuedHandler->call(Object(Illuminate\\Queue\\Jobs\\DatabaseJob), Array)\n#16 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Worker.php(451): Illuminate\\Queue\\Jobs\\Job->fire()\n#17 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Worker.php(401): Illuminate\\Queue\\Worker->process(\'database\', Object(Illuminate\\Queue\\Jobs\\DatabaseJob), Object(Illuminate\\Queue\\WorkerOptions))\n#18 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Worker.php(187): Illuminate\\Queue\\Worker->runJob(Object(Illuminate\\Queue\\Jobs\\DatabaseJob), \'database\', Object(Illuminate\\Queue\\WorkerOptions))\n#19 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Console\\WorkCommand.php(148): Illuminate\\Queue\\Worker->daemon(\'database\', \'lyrics,default\', Object(Illuminate\\Queue\\WorkerOptions))\n#20 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Console\\WorkCommand.php(131): Illuminate\\Queue\\Console\\WorkCommand->runWorker(\'database\', \'lyrics,default\')\n#21 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\BoundMethod.php(36): Illuminate\\Queue\\Console\\WorkCommand->handle()\n#22 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\Util.php(43): Illuminate\\Container\\BoundMethod::Illuminate\\Container\\{closure}()\n#23 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#24 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#25 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\Container.php(836): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#26 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Console\\Command.php(211): Illuminate\\Container\\Container->call(Array)\n#27 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\symfony\\console\\Command\\Command.php(318): Illuminate\\Console\\Command->execute(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#28 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Console\\Command.php(180): Symfony\\Component\\Console\\Command\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#29 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\symfony\\console\\Application.php(1110): Illuminate\\Console\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#30 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\symfony\\console\\Application.php(359): Symfony\\Component\\Console\\Application->doRunCommand(Object(Illuminate\\Queue\\Console\\WorkCommand), Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#31 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\symfony\\console\\Application.php(194): Symfony\\Component\\Console\\Application->doRun(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#32 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Foundation\\Console\\Kernel.php(197): Symfony\\Component\\Console\\Application->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#33 D:\\Project_Music_MelodyHub\\source\\Backend\\vendor\\laravel\\framework\\src\\Illuminate\\Foundation\\Application.php(1235): Illuminate\\Foundation\\Console\\Kernel->handle(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#34 D:\\Project_Music_MelodyHub\\source\\Backend\\artisan(16): Illuminate\\Foundation\\Application->handleCommand(Object(Symfony\\Component\\Console\\Input\\ArgvInput))\n#35 {main}', '2026-05-20 05:44:25');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `featured_content`
--

CREATE TABLE `featured_content` (
  `id` bigint UNSIGNED NOT NULL,
  `content_type` enum('song','album','artist','playlist') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `content_id` bigint UNSIGNED NOT NULL,
  `section` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'homepage_hero, trending, new_releases, etc',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `image_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `order` int NOT NULL DEFAULT '0',
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `genres`
--

CREATE TABLE `genres` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `cover_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `color` varchar(7) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Hex color code',
  `parent_id` bigint UNSIGNED DEFAULT NULL,
  `order` int NOT NULL DEFAULT '0',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `total_songs` bigint NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `genres`
--

INSERT INTO `genres` (`id`, `name`, `slug`, `description`, `cover_url`, `color`, `parent_id`, `order`, `is_active`, `total_songs`, `created_at`, `updated_at`) VALUES
(1, 'Pop', 'pop', 'Popular music', 'covers/genres/1776063864_FaOtyr87BS.jpg', '#FF6B9D', NULL, 1, 1, 0, '2025-11-11 08:44:02', '2026-04-13 00:04:24'),
(2, 'Rock', 'rock', 'Rock music', 'covers/genres/1776063914_JG3AQ7xblx.jpg', '#C41E3A', NULL, 2, 1, 0, '2025-11-11 08:44:02', '2026-05-25 06:57:22'),
(3, 'Hip Hop', 'hip-hop', 'Hip hop & rap', 'covers/genres/1776063959_BQJqZJD3Z0.jpg', '#FFD700', NULL, 3, 1, 0, '2025-11-11 08:44:02', '2026-04-13 00:05:59'),
(4, 'Electronic', 'electronic', 'Electronic dance music', 'covers/genres/1776063986_ZY2yd5WLar.jpg', '#00FFFF', NULL, 4, 1, 0, '2025-11-11 08:44:02', '2026-04-13 00:06:26'),
(5, 'Jazz', 'jazz', 'Jazz music', 'covers/genres/1776064020_VGHiFoj12F.jpg', '#8B4513', NULL, 5, 1, 0, '2025-11-11 08:44:02', '2026-04-13 00:07:00'),
(6, 'Classical', 'classical', 'Classical music', 'covers/genres/1776064056_ocrwRRDYWh.jpg', '#4B0082', NULL, 6, 1, 0, '2025-11-11 08:44:02', '2026-04-13 00:07:36'),
(7, 'Country', 'country', 'Country music', 'covers/genres/1776064088_wC8GjNCdPn.jpg', '#DEB887', NULL, 7, 1, 0, '2025-11-11 08:44:02', '2026-04-13 00:08:08'),
(8, 'R&B', 'rnb', 'Rhythm and blues', 'covers/genres/1776064129_JJd8EyPeL3.jpg', '#9370DB', NULL, 8, 1, 0, '2025-11-11 08:44:02', '2026-04-13 00:08:49'),
(9, 'Vietnamese Pop', 'v-pop', 'Vietnamese popular music', 'covers/genres/1776064159_o32NGAtsnK.jpg', '#DA291C', 1, 9, 1, 0, '2025-11-11 08:44:02', '2026-04-13 00:09:19'),
(10, 'K-Pop', 'k-pop', 'Korean pop music', 'covers/genres/1776064204_LgvxorLg0T.jpg', '#0047A0', 1, 10, 1, 0, '2025-11-11 08:44:02', '2026-04-13 00:10:04'),
(11, 'Lofi Chill', 'lofi-chill', NULL, 'covers/genres/1776009463_zc3EG2GEG9.jpg', '#FFC947', NULL, 5, 1, 0, '2026-04-12 08:57:44', '2026-04-12 08:57:44');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `invoices`
--

CREATE TABLE `invoices` (
  `id` bigint UNSIGNED NOT NULL,
  `invoice_number` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `payment_id` bigint UNSIGNED DEFAULT NULL,
  `subscription_id` bigint UNSIGNED DEFAULT NULL,
  `amount` decimal(10,2) NOT NULL,
  `tax_amount` decimal(10,2) DEFAULT '0.00',
  `discount_amount` decimal(10,2) DEFAULT '0.00',
  `total_amount` decimal(10,2) NOT NULL,
  `currency` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'VND',
  `status` enum('draft','issued','paid','overdue','cancelled','refunded') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'draft',
  `issued_at` timestamp NULL DEFAULT NULL,
  `due_date` date DEFAULT NULL,
  `paid_at` timestamp NULL DEFAULT NULL,
  `invoice_data` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'JSON data',
  `notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `jobs`
--

CREATE TABLE `jobs` (
  `id` bigint UNSIGNED NOT NULL,
  `queue` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `attempts` tinyint UNSIGNED NOT NULL,
  `reserved_at` int UNSIGNED DEFAULT NULL,
  `available_at` int UNSIGNED NOT NULL,
  `created_at` int UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `job_batches`
--

CREATE TABLE `job_batches` (
  `id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_jobs` int NOT NULL,
  `pending_jobs` int NOT NULL,
  `failed_jobs` int NOT NULL,
  `failed_job_ids` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `options` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `cancelled_at` int DEFAULT NULL,
  `created_at` int NOT NULL,
  `finished_at` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `listening_history`
--

CREATE TABLE `listening_history` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `song_id` bigint UNSIGNED NOT NULL,
  `played_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `play_count` int NOT NULL DEFAULT '1',
  `last_position` int DEFAULT '0' COMMENT 'Last playback position'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `login_history`
--

CREATE TABLE `login_history` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `ip_address` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_agent` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `device_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `browser` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `os` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `country` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `city` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` enum('success','failed','blocked') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `fail_reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `logged_in_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `menu`
--

CREATE TABLE `menu` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `display_name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `icon` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `parent_id` bigint UNSIGNED DEFAULT NULL,
  `module_id` bigint UNSIGNED DEFAULT NULL,
  `order` int NOT NULL DEFAULT '0',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `is_visible` tinyint(1) NOT NULL DEFAULT '1',
  `target` enum('_self','_blank') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '_self',
  `css_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `migrations`
--

CREATE TABLE `migrations` (
  `id` int UNSIGNED NOT NULL,
  `migration` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '2026_04_20_064320_add_targeting_to_advertisements_table', 1),
(2, '2026_05_01_152512_create_ad_priority_tiers_table', 2),
(3, '2026_05_07_000001_add_lyrics_debug_info_to_songs_table', 3),
(4, '2026_05_14_083541_update_notifications_table', 4),
(5, '2026_05_15_100000_update_copyright_type_enum', 5),
(6, '2026_05_20_094720_add_copyright_report_types_to_notifications_table', 6),
(7, '2026_05_20_120000_add_new_copyright_report_type_to_notifications_table', 7),
(8, '0001_01_01_000000_create_users_table', 8),
(9, '0001_01_01_000001_create_cache_table', 8),
(10, '0001_01_01_000002_create_jobs_table', 8),
(11, '2025_04_12_000001_create_album_tracks_table', 8),
(12, '2025_10_23_124058_create_activity_logs_table', 8),
(13, '2025_10_23_124059_create_albums_table', 8),
(14, '2025_10_23_124059_create_artists_table', 8),
(15, '2025_10_23_124100_create_cache_locks_table', 8),
(16, '2025_10_23_124100_create_cache_table', 8),
(17, '2025_10_23_124101_create_comments_table', 8),
(18, '2025_10_23_124101_create_copyright_claims_table', 8),
(19, '2025_10_23_124102_create_downloads_table', 8),
(20, '2025_10_23_124105_create_failed_jobs_table', 8),
(21, '2025_10_23_124107_create_genre_song_table', 8),
(22, '2025_10_23_124108_create_genres_table', 8),
(23, '2025_10_23_124108_create_job_batches_table', 8),
(24, '2025_10_23_124109_create_jobs_table', 8),
(25, '2025_10_23_124109_create_migrations_table', 8),
(26, '2025_10_23_124109_create_notifications_table', 8),
(27, '2025_10_23_124110_create_partner_applications_table', 8),
(28, '2025_10_23_124110_create_payments_table', 8),
(29, '2025_10_23_124112_create_permissions_table', 8),
(30, '2025_10_23_124115_create_personal_access_tokens_table', 8),
(31, '2025_10_23_124116_create_playlist_songs_table', 8),
(32, '2025_10_23_124117_create_playlists_table', 8),
(33, '2025_10_23_124117_create_recommendations_table', 8),
(34, '2025_10_23_124118_create_reports_table', 8),
(35, '2025_10_23_124118_create_role_permission_table', 8),
(36, '2025_10_23_124118_create_roles_table', 8),
(37, '2025_10_23_124119_create_song_likes_table', 8),
(38, '2025_10_23_124119_create_song_plays_table', 8),
(39, '2025_10_23_124122_create_songs_table', 8),
(40, '2025_10_23_124125_create_subscriptions_table', 8),
(41, '2025_10_23_124125_create_system_settings_table', 8),
(42, '2025_10_23_124126_create_user_statistics_table', 8),
(43, '2025_10_23_124126_create_users_table', 8),
(44, '2026_05_14_083539_add_copyright_status_to_songs_table', 8),
(45, '2026_05_14_083540_create_copyright_reports_table', 8),
(46, '2026_05_15_053536_create_copyrights_table', 8),
(47, '2026_05_15_053729_create_copyright_reports_table', 8),
(48, '2026_05_19_091603_create_song_fingerprints_table', 8),
(49, '2026_05_21_082736_add_google_fields_to_users_table', 9),
(51, '2026_05_26_084719_update_song_play_revenue_trigger', 10),
(52, '2026_05_26_131852_add_unique_key_to_partner_revenues_table', 11),
(53, '2026_05_26_133140_sync_songs_total_plays_from_song_plays_table', 12);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `modules`
--

CREATE TABLE `modules` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `display_name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `icon` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `route_prefix` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `parent_id` bigint UNSIGNED DEFAULT NULL,
  `order` int NOT NULL DEFAULT '0',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `is_system` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `modules`
--

INSERT INTO `modules` (`id`, `name`, `display_name`, `description`, `icon`, `route_prefix`, `parent_id`, `order`, `is_active`, `is_system`, `created_at`, `updated_at`) VALUES
(1, 'dashboard', 'Dashboard', 'System overview', 'dashboard', '/dashboard', NULL, 1, 1, 1, '2025-11-11 08:45:18', '2025-11-11 08:45:18'),
(2, 'user_management', 'User Management', 'Manage users', 'users', '/users', NULL, 2, 1, 1, '2025-11-11 08:45:18', '2025-11-11 08:45:18'),
(3, 'role_management', 'Role Management', 'Manage roles & permissions', 'shield', '/roles', NULL, 3, 1, 1, '2025-11-11 08:45:18', '2025-11-11 08:45:18'),
(4, 'content_management', 'Content Management', 'Manage music content', 'music', '/content', NULL, 4, 1, 1, '2025-11-11 08:45:18', '2025-11-11 08:45:18'),
(5, 'artist_management', 'Artist Management', 'Manage artists', 'mic', '/artists', 4, 5, 1, 1, '2025-11-11 08:45:18', '2025-11-11 08:45:18'),
(6, 'album_management', 'Album Management', 'Manage albums', 'disc', '/albums', 4, 6, 1, 1, '2025-11-11 08:45:18', '2025-11-11 08:45:18'),
(7, 'song_management', 'Song Management', 'Manage songs', 'music-note', '/songs', 4, 7, 1, 1, '2025-11-11 08:45:18', '2025-11-11 08:45:18'),
(8, 'partner_management', 'Partner Management', 'Manage content partners', 'briefcase', '/partners', NULL, 8, 1, 1, '2025-11-11 08:45:18', '2025-11-11 08:45:18'),
(9, 'subscription_management', 'Subscription Management', 'Manage VIP plans', 'credit-card', '/subscriptions', NULL, 9, 1, 1, '2025-11-11 08:45:18', '2025-11-11 08:45:18'),
(10, 'payment_management', 'Payment Management', 'Manage payments & invoices', 'dollar-sign', '/payments', NULL, 10, 1, 1, '2025-11-11 08:45:18', '2025-11-11 08:45:18'),
(11, 'analytics', 'Analytics & Reports', 'Statistics and analytics', 'chart-bar', '/analytics', NULL, 11, 1, 1, '2025-11-11 08:45:18', '2025-11-11 08:45:18'),
(12, 'advertising', 'Advertising', 'Manage advertisements', 'megaphone', '/ads', NULL, 12, 1, 1, '2025-11-11 08:45:18', '2025-11-11 08:45:18'),
(13, 'notification_center', 'Notification Center', 'Manage notifications', 'bell', '/notifications', NULL, 13, 1, 1, '2025-11-11 08:45:18', '2025-11-11 08:45:18'),
(14, 'security', 'Security & Logs', 'Security management', 'lock', '/security', NULL, 14, 1, 1, '2025-11-11 08:45:18', '2025-11-11 08:45:18'),
(15, 'system_settings', 'System Settings', 'System configuration', 'settings', '/settings', NULL, 15, 1, 1, '2025-11-11 08:45:18', '2025-11-11 08:45:18');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `notifications`
--

CREATE TABLE `notifications` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `type` enum('copyright_unverified','copyright_pending','copyright_approved','copyright_rejected','copyright_disputed','report_resolved','copyright_report_submitted','copyright_report_resolved_removed','copyright_report_resolved_kept','copyright_report_rejected','copyright_report_updated','new_copyright_report','system') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'system',
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `message` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `data` json DEFAULT NULL,
  `action_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_read` tinyint(1) NOT NULL DEFAULT '0',
  `read_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `notifications`
--

INSERT INTO `notifications` (`id`, `user_id`, `type`, `title`, `message`, `data`, `action_url`, `is_read`, `read_at`, `created_at`, `updated_at`) VALUES
(6, 5, 'copyright_unverified', 'Copyright Registration Reminder', 'You have 6 song(s) without copyright registration. Register now to protect your work and get a verified ✓ badge.', '\"{\\\"unverified_count\\\":6,\\\"partner_id\\\":23}\"', '/center/copyright-registration', 0, NULL, '2026-05-18 06:03:44', '2026-05-18 06:03:44'),
(7, 19, 'copyright_unverified', 'Copyright Registration Reminder', 'You have 4 song(s) without copyright registration. Register now to protect your work and get a verified ✓ badge.', '\"{\\\"unverified_count\\\":4,\\\"partner_id\\\":22}\"', '/center/copyright-registration', 0, NULL, '2026-05-18 06:04:04', '2026-05-18 06:04:04'),
(21, 18, 'copyright_unverified', 'Copyright Registration Reminder', 'You have 6 song(s) without copyright registration. Register now to protect your work and get a verified ✓ badge.', '\"{\\\"unverified_count\\\":6,\\\"partner_id\\\":21}\"', '/center/copyright-registration', 0, NULL, '2026-05-20 03:48:05', '2026-05-20 03:48:05'),
(22, 1, 'copyright_unverified', 'Copyright Registration Reminder', 'You have 7 song(s) without copyright registration. Register now to protect your work and get a verified ✓ badge.', '\"{\\\"unverified_count\\\":7,\\\"partner_id\\\":18}\"', '/center/copyright-registration', 0, NULL, '2026-05-20 03:53:44', '2026-05-25 20:53:52'),
(23, 2, 'copyright_unverified', 'Copyright Registration Reminder', 'You have 9 song(s) without copyright registration. Register now to protect your work and get a verified ✓ badge.', '\"{\\\"unverified_count\\\":9,\\\"partner_id\\\":15}\"', '/center/copyright-registration', 0, NULL, '2026-05-20 05:47:02', '2026-05-20 07:24:33'),
(25, 1, 'copyright_approved', 'Copyright Approved ✓', 'Your copyright registration for \"NỮ TÀI NHÂN\" has been approved.', '\"{\\\"copyright_id\\\":6,\\\"song_id\\\":105}\"', '/center/copyright-registration', 0, NULL, '2026-05-25 20:53:45', '2026-05-25 20:53:45'),
(26, 17, 'copyright_unverified', 'Copyright Registration Reminder', 'You have 2 song(s) without copyright registration. Register now to protect your work and get a verified ✓ badge.', '\"{\\\"unverified_count\\\":2,\\\"partner_id\\\":17}\"', '/center/copyright-registration', 0, NULL, '2026-05-26 08:10:50', '2026-05-26 08:10:50');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `partners`
--

CREATE TABLE `partners` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `partner_type_id` bigint UNSIGNED NOT NULL,
  `company_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `company_email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `company_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `company_address` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `tax_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `website` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `logo_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `contract_number` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `contract_file_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `contract_start_date` date DEFAULT NULL,
  `contract_end_date` date DEFAULT NULL,
  `revenue_share_percentage` decimal(5,2) DEFAULT '70.00',
  `payment_threshold` decimal(10,2) DEFAULT '1000000.00' COMMENT 'Minimum for payout',
  `payment_frequency` enum('weekly','monthly','quarterly') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'monthly',
  `bank_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `bank_branch` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `bank_account_number` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `bank_account_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` enum('active','pending','suspended','terminated') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `verified_at` timestamp NULL DEFAULT NULL,
  `verified_by` bigint UNSIGNED DEFAULT NULL,
  `notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `partners`
--

INSERT INTO `partners` (`id`, `user_id`, `partner_type_id`, `company_name`, `company_email`, `company_phone`, `company_address`, `tax_code`, `website`, `logo_url`, `description`, `contract_number`, `contract_file_url`, `contract_start_date`, `contract_end_date`, `revenue_share_percentage`, `payment_threshold`, `payment_frequency`, `bank_name`, `bank_branch`, `bank_account_number`, `bank_account_name`, `status`, `verified_at`, `verified_by`, `notes`, `created_at`, `updated_at`, `deleted_at`) VALUES
(14, 14, 1, 'Đen Vâu', 'denvau@gmail.com', NULL, 'Hạ Long, Quảng Ninh, Việt Nam', NULL, 'https://dventertainment.com', NULL, 'Rapper, nhạc sĩ nổi tiếng người Việt Nam, được biết đến với phong cách âm nhạc mộc mạc, tự sự và nhiều ca khúc hit như \"Đưa nhau đi trốn\", \"Mang tiền về cho mẹ\", \"Nấu ăn cho em\". Hoạt động với tư cách nghệ sĩ độc lập, có lượng fan đông đảo tên \"Đồng Âm\".', NULL, NULL, NULL, NULL, 70.00, 100.00, 'monthly', NULL, NULL, NULL, NULL, 'active', NULL, NULL, 'Đối tác là nghệ sĩ độc lập, hoạt động cùng ekip riêng (team Đen Vâu). Thường xuyên thực hiện các dự án thiện nguyện từ doanh thu âm nhạc.', '2026-03-18 02:27:42', '2026-04-20 23:14:08', NULL),
(15, 2, 1, 'M-TP Entertainment', 'mtp@mtptalent.com', NULL, 'Phòng 1901, Tầng 19, Tòa nhà Saigon Trade Center, 37 Tôn Đức Thắng, Phường Bến Nghé, Quận 1, TP. Hồ Chí Minh.', '0314101016', 'mtpentertainment.com', NULL, NULL, 'HD947691', 'https://res.cloudinary.com/djgps2bk9/raw/upload/v1775038214/contracts/HD947691_1775038211.tmp', '2026-04-01', '2027-04-01', 70.00, 100.00, 'monthly', 'Techcombank', 'Techcombank Cần Thơ', '19075048224017', 'BUI TRUNG NGUYEN', 'active', NULL, NULL, NULL, '2026-04-01 03:10:20', '2026-04-20 23:13:59', NULL),
(16, 3, 1, 'J97 Entertainment', 'j97ent.booking@gmail.com', NULL, '81 Cách Mạng Tháng Tám, Phường 7, Bến Thành, Hồ Chí Minh', '0316324836', 'https://j97entertainment.com/', NULL, NULL, 'HD804431', 'https://res.cloudinary.com/djgps2bk9/raw/upload/v1775283125/contracts/HD804431_1775283098.tmp', '2026-04-04', '2027-04-04', 70.00, 100.00, 'monthly', 'VIB Bank', 'VIB Bank Cần Thơ', '795892904', 'TRAN THI CAM LAI', 'active', NULL, NULL, NULL, '2026-04-03 23:12:05', '2026-04-20 21:46:11', NULL),
(17, 17, 1, 'Công ty TNHH GERDNANG', 'hieuthuhai.gerdnang@gmail.com', NULL, 'Việt Nam', '0316512741', 'https://www.facebook.com/GERDNANG/', NULL, NULL, 'HD685304', 'https://res.cloudinary.com/djgps2bk9/raw/upload/v1776412696/contracts/HD685304_1776412675.tmp', '2026-04-17', '2027-04-17', 70.00, 100.00, 'monthly', 'VIB', 'VIB Ngân hàng Quốc tế Việt Nam', '79589904', 'TRAN THI CAM LAI', 'active', NULL, NULL, NULL, '2026-04-17 00:58:16', '2026-04-20 23:18:39', NULL),
(18, 1, 2, 'Melody Hub', 'nguyenbui26102003@gmail.com', NULL, 'Can Tho', '090998877', 'http://localhost:5173/', NULL, NULL, 'HD641639', 'https://res.cloudinary.com/djgps2bk9/raw/upload/v1776496025/contracts/HD641639_1776496016.tmp', '2026-04-18', '2027-04-18', 30.00, 100.00, 'monthly', 'VietinBank', 'VietinBank Vĩnh Long', '100880352623', 'TRAN THI CAM LAI', 'active', NULL, NULL, NULL, '2026-04-18 00:07:03', '2026-04-20 21:29:12', NULL),
(21, 18, 1, 'Ca Sĩ Giấu Mặt', 'CaSiGiauMat@gmail.com', NULL, 'Viet Nam', '09000093', 'http://localhost:5173/', NULL, NULL, 'HD496638', 'https://res.cloudinary.com/djgps2bk9/raw/upload/v1776766294/contracts/HD496638_1776766287.tmp', '2026-04-21', '2027-04-21', 70.00, 100.00, 'monthly', 'vietinbank', 'vietinbank', '09999999999', 'NGUYEN VAN A', 'active', NULL, NULL, NULL, '2026-04-21 03:11:35', '2026-04-21 03:12:48', NULL),
(22, 19, 1, 's o u l w a r e', 'soulware999@gmail.com', NULL, 'Viet Nam', '019000002', 'https://www.youtube.com/@soulware999', NULL, NULL, 'HD932126', 'https://res.cloudinary.com/djgps2bk9/raw/upload/v1777099239/contracts/HD932126_1777099220.tmp', '2026-04-25', '2027-04-25', 70.00, 100.00, 'monthly', 'Vietcombank', 'Vietcombank Hồ Chí Minh', '0338228118', 'soulware', 'active', NULL, NULL, NULL, '2026-04-24 23:40:40', '2026-04-24 23:42:00', NULL),
(23, 5, 1, 'CÔNG TY TNHH TRÚC NHÂN ENTERTAINMENT', 'trucnhanEntertaiment@gmail.com', NULL, 'TP. Hồ Chí Minh.', '0314136185', 'https://masothue.com/0314136185-cong-ty-tnhh-truc-nhan-entertainment', NULL, NULL, 'HD155421', 'https://res.cloudinary.com/djgps2bk9/raw/upload/v1777479273/contracts/HD155421_1777479233.tmp', '2026-04-29', '2027-04-29', 70.00, 100.00, 'monthly', 'Sacombank', 'Sacombank Hồ Chí Minh', '0999900000', 'Truc Nhan', 'active', NULL, NULL, NULL, '2026-04-29 09:14:33', '2026-04-29 09:26:37', NULL),
(24, 1, 1, 'MelodyHub', 'nguyenbui26102003@gmail.com', NULL, 'Can Tho', '090998877', 'http://localhost:5173/', NULL, NULL, 'HD786121', 'https://res.cloudinary.com/djgps2bk9/raw/upload/v1777625110/contracts/HD786121_1777625077.tmp', '2026-05-01', '2027-05-01', 70.00, 100.00, 'monthly', 'VietinBank', 'VietinBank Vĩnh Long', '100880352623', 'TRAN THI CAM LAI', 'active', NULL, NULL, NULL, '2026-05-01 01:45:11', '2026-05-01 02:10:08', NULL),
(26, 2, 2, 'M-TP Entertainment', 'mtp@mtptalent.com', NULL, 'Phòng 1901, Tầng 19, Tòa nhà Saigon Trade Center, 37 Tôn Đức Thắng, Phường Bến Nghé, Quận 1, TP. Hồ Chí Minh.', '0314101016', 'mtpentertainment.com', NULL, NULL, 'HD654853', 'https://res.cloudinary.com/djgps2bk9/raw/upload/v1778822475/contracts/HD654853_1778822446.docx', '2026-05-15', '2027-05-15', 30.00, 100.00, 'monthly', 'Techcombank', 'Techcombank Cần Thơ', '19075048224017', 'BUI TRUNG NGUYEN', 'active', NULL, NULL, NULL, '2026-05-14 22:21:16', '2026-05-18 06:28:14', NULL);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `partner_payouts`
--

CREATE TABLE `partner_payouts` (
  `id` bigint UNSIGNED NOT NULL,
  `partner_id` bigint UNSIGNED NOT NULL,
  `payout_period_start` date NOT NULL,
  `payout_period_end` date NOT NULL,
  `total_revenue_ids` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'JSON array of revenue IDs',
  `total_amount` decimal(15,2) NOT NULL,
  `fee_amount` decimal(15,2) NOT NULL DEFAULT '0.00',
  `net_amount` decimal(15,2) NOT NULL,
  `currency` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'VND',
  `payment_method` enum('bank_transfer','paypal','wire_transfer','check') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `transaction_reference` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `bank_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `account_number` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` enum('pending','processing','completed','failed','cancelled') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `processed_at` timestamp NULL DEFAULT NULL,
  `processed_by` bigint UNSIGNED DEFAULT NULL,
  `completed_at` timestamp NULL DEFAULT NULL,
  `failed_reason` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `partner_revenues`
--

CREATE TABLE `partner_revenues` (
  `id` bigint UNSIGNED NOT NULL,
  `partner_id` bigint UNSIGNED NOT NULL,
  `song_id` bigint UNSIGNED DEFAULT NULL,
  `period_type` enum('daily','weekly','monthly','quarterly','yearly') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'monthly',
  `period_start` date NOT NULL,
  `period_end` date NOT NULL,
  `total_plays` bigint NOT NULL DEFAULT '0',
  `total_downloads` bigint NOT NULL DEFAULT '0',
  `ad_revenue` decimal(15,2) NOT NULL DEFAULT '0.00',
  `subscription_revenue` decimal(15,2) NOT NULL DEFAULT '0.00',
  `total_revenue` decimal(15,2) NOT NULL DEFAULT '0.00',
  `partner_share_percentage` decimal(5,2) NOT NULL,
  `partner_share_amount` decimal(15,2) NOT NULL DEFAULT '0.00',
  `platform_share_amount` decimal(15,2) NOT NULL DEFAULT '0.00',
  `tax_amount` decimal(15,2) NOT NULL DEFAULT '0.00',
  `net_payout` decimal(15,2) NOT NULL DEFAULT '0.00',
  `status` enum('pending','calculated','approved','paid','disputed') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `calculated_at` timestamp NULL DEFAULT NULL,
  `approved_at` timestamp NULL DEFAULT NULL,
  `approved_by` bigint UNSIGNED DEFAULT NULL,
  `paid_at` timestamp NULL DEFAULT NULL,
  `payment_reference` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `partner_revenues`
--

INSERT INTO `partner_revenues` (`id`, `partner_id`, `song_id`, `period_type`, `period_start`, `period_end`, `total_plays`, `total_downloads`, `ad_revenue`, `subscription_revenue`, `total_revenue`, `partner_share_percentage`, `partner_share_amount`, `platform_share_amount`, `tax_amount`, `net_payout`, `status`, `calculated_at`, `approved_at`, `approved_by`, `paid_at`, `payment_reference`, `notes`, `created_at`, `updated_at`) VALUES
(688, 14, 20, 'monthly', '2026-04-01', '2026-04-30', 5, 0, 0.25, 0.00, 0.25, 70.00, 0.18, 0.08, 0.02, 0.16, 'calculated', '2026-05-26 06:18:25', NULL, NULL, NULL, NULL, NULL, '2026-05-26 06:18:25', '2026-05-26 06:18:25'),
(689, 14, 20, 'monthly', '2026-05-01', '2026-05-31', 1, 0, 0.05, 0.00, 0.05, 70.00, 0.04, 0.02, 0.00, 0.03, 'calculated', '2026-05-26 06:18:25', NULL, NULL, NULL, NULL, NULL, '2026-05-26 06:18:25', '2026-05-26 06:18:25'),
(690, 14, 21, 'monthly', '2026-04-01', '2026-04-30', 4, 0, 0.20, 0.00, 0.20, 70.00, 0.14, 0.06, 0.01, 0.13, 'calculated', '2026-05-26 06:18:25', NULL, NULL, NULL, NULL, NULL, '2026-05-26 06:18:25', '2026-05-26 06:18:25'),
(691, 14, 22, 'monthly', '2026-04-01', '2026-04-30', 2, 0, 0.10, 0.00, 0.10, 70.00, 0.07, 0.03, 0.01, 0.06, 'calculated', '2026-05-26 06:18:25', NULL, NULL, NULL, NULL, NULL, '2026-05-26 06:18:25', '2026-05-26 06:18:25'),
(692, 14, 22, 'monthly', '2026-05-01', '2026-05-31', 1, 0, 0.05, 0.00, 0.05, 70.00, 0.04, 0.02, 0.00, 0.03, 'calculated', '2026-05-26 06:18:25', NULL, NULL, NULL, NULL, NULL, '2026-05-26 06:18:25', '2026-05-26 06:18:25'),
(693, 14, 25, 'monthly', '2026-04-01', '2026-04-30', 5, 0, 0.25, 0.00, 0.25, 70.00, 0.18, 0.08, 0.02, 0.16, 'calculated', '2026-05-26 06:18:25', NULL, NULL, NULL, NULL, NULL, '2026-05-26 06:18:25', '2026-05-26 06:18:25'),
(694, 14, 25, 'monthly', '2026-05-01', '2026-05-31', 1, 0, 0.05, 0.00, 0.05, 70.00, 0.04, 0.02, 0.00, 0.03, 'calculated', '2026-05-26 06:18:25', NULL, NULL, NULL, NULL, NULL, '2026-05-26 06:18:25', '2026-05-26 06:18:25'),
(695, 14, 26, 'monthly', '2026-04-01', '2026-04-30', 6, 0, 0.30, 0.00, 0.30, 70.00, 0.21, 0.09, 0.02, 0.19, 'calculated', '2026-05-26 06:18:25', NULL, NULL, NULL, NULL, NULL, '2026-05-26 06:18:25', '2026-05-26 06:18:25'),
(696, 14, 26, 'monthly', '2026-05-01', '2026-05-31', 2, 0, 0.10, 0.00, 0.10, 70.00, 0.07, 0.03, 0.01, 0.06, 'calculated', '2026-05-26 06:18:25', NULL, NULL, NULL, NULL, NULL, '2026-05-26 06:18:25', '2026-05-26 06:18:25'),
(697, 14, 34, 'monthly', '2026-04-01', '2026-04-30', 17, 0, 0.85, 0.00, 0.85, 70.00, 0.60, 0.26, 0.06, 0.54, 'calculated', '2026-05-26 06:18:25', NULL, NULL, NULL, NULL, NULL, '2026-05-26 06:18:25', '2026-05-26 06:18:25'),
(698, 15, 28, 'monthly', '2026-04-01', '2026-04-30', 9, 0, 0.45, 0.00, 0.45, 70.00, 0.32, 0.14, 0.03, 0.28, 'calculated', '2026-05-26 06:18:25', NULL, NULL, NULL, NULL, NULL, '2026-05-26 06:18:25', '2026-05-26 06:18:25'),
(699, 15, 28, 'monthly', '2026-05-01', '2026-05-31', 2, 0, 0.10, 0.00, 0.10, 70.00, 0.07, 0.03, 0.01, 0.06, 'calculated', '2026-05-26 06:18:25', NULL, NULL, NULL, NULL, NULL, '2026-05-26 06:18:25', '2026-05-26 06:18:25'),
(700, 15, 29, 'monthly', '2026-04-01', '2026-04-30', 15, 0, 0.75, 0.00, 0.75, 70.00, 0.53, 0.23, 0.05, 0.47, 'calculated', '2026-05-26 06:18:25', NULL, NULL, NULL, NULL, NULL, '2026-05-26 06:18:25', '2026-05-26 06:18:25'),
(701, 15, 29, 'monthly', '2026-05-01', '2026-05-31', 3, 0, 0.15, 0.00, 0.15, 70.00, 0.11, 0.05, 0.01, 0.09, 'calculated', '2026-05-26 06:18:25', NULL, NULL, NULL, NULL, NULL, '2026-05-26 06:18:25', '2026-05-26 06:18:25'),
(702, 15, 35, 'monthly', '2026-04-01', '2026-04-30', 20, 0, 1.00, 0.00, 1.00, 70.00, 0.70, 0.30, 0.07, 0.63, 'calculated', '2026-05-26 06:18:25', NULL, NULL, NULL, NULL, NULL, '2026-05-26 06:18:25', '2026-05-26 06:18:25'),
(703, 15, 35, 'monthly', '2026-05-01', '2026-05-31', 4, 0, 0.20, 0.00, 0.20, 70.00, 0.14, 0.06, 0.01, 0.13, 'calculated', '2026-05-26 06:18:25', NULL, NULL, NULL, NULL, NULL, '2026-05-26 06:18:25', '2026-05-26 06:18:25'),
(704, 15, 108, 'monthly', '2026-05-01', '2026-05-31', 3, 0, 0.15, 0.00, 0.15, 70.00, 0.11, 0.05, 0.01, 0.09, 'calculated', '2026-05-26 06:18:25', NULL, NULL, NULL, NULL, NULL, '2026-05-26 06:18:25', '2026-05-26 06:18:25'),
(705, 15, 109, 'monthly', '2026-05-01', '2026-05-31', 3, 0, 0.15, 0.00, 0.15, 70.00, 0.11, 0.05, 0.01, 0.09, 'calculated', '2026-05-26 06:18:25', NULL, NULL, NULL, NULL, NULL, '2026-05-26 06:18:25', '2026-05-26 06:18:25'),
(706, 15, 110, 'monthly', '2026-05-01', '2026-05-31', 2, 0, 0.10, 0.00, 0.10, 70.00, 0.07, 0.03, 0.01, 0.06, 'calculated', '2026-05-26 06:18:25', NULL, NULL, NULL, NULL, NULL, '2026-05-26 06:18:25', '2026-05-26 06:18:25'),
(707, 15, 111, 'monthly', '2026-05-01', '2026-05-31', 2, 0, 0.10, 0.00, 0.10, 70.00, 0.07, 0.03, 0.01, 0.06, 'calculated', '2026-05-26 06:18:25', NULL, NULL, NULL, NULL, NULL, '2026-05-26 06:18:25', '2026-05-26 06:18:25'),
(708, 15, 112, 'monthly', '2026-05-01', '2026-05-31', 2, 0, 0.10, 0.00, 0.10, 70.00, 0.07, 0.03, 0.01, 0.06, 'calculated', '2026-05-26 06:18:25', NULL, NULL, NULL, NULL, NULL, '2026-05-26 06:18:25', '2026-05-26 06:18:25'),
(709, 15, 113, 'monthly', '2026-05-01', '2026-05-31', 2, 0, 0.10, 0.00, 0.10, 70.00, 0.07, 0.03, 0.01, 0.06, 'calculated', '2026-05-26 06:18:25', NULL, NULL, NULL, NULL, NULL, '2026-05-26 06:18:25', '2026-05-26 06:18:25'),
(710, 15, 114, 'monthly', '2026-05-01', '2026-05-31', 2, 0, 0.10, 0.00, 0.10, 70.00, 0.07, 0.03, 0.01, 0.06, 'calculated', '2026-05-26 06:18:25', NULL, NULL, NULL, NULL, NULL, '2026-05-26 06:18:25', '2026-05-26 06:18:25'),
(711, 16, 36, 'monthly', '2026-04-01', '2026-04-30', 19, 0, 0.95, 0.00, 0.95, 70.00, 0.67, 0.29, 0.07, 0.60, 'calculated', '2026-05-26 06:18:25', NULL, NULL, NULL, NULL, NULL, '2026-05-26 06:18:25', '2026-05-26 06:18:25'),
(712, 16, 36, 'monthly', '2026-05-01', '2026-05-31', 4, 0, 0.20, 0.00, 0.20, 70.00, 0.14, 0.06, 0.01, 0.13, 'calculated', '2026-05-26 06:18:25', NULL, NULL, NULL, NULL, NULL, '2026-05-26 06:18:25', '2026-05-26 06:18:25'),
(713, 16, 37, 'monthly', '2026-04-01', '2026-04-30', 22, 0, 1.10, 0.00, 1.10, 70.00, 0.77, 0.33, 0.08, 0.69, 'calculated', '2026-05-26 06:18:25', NULL, NULL, NULL, NULL, NULL, '2026-05-26 06:18:25', '2026-05-26 06:18:25'),
(714, 16, 37, 'monthly', '2026-05-01', '2026-05-31', 5, 0, 0.25, 0.00, 0.25, 70.00, 0.18, 0.08, 0.02, 0.16, 'calculated', '2026-05-26 06:18:25', NULL, NULL, NULL, NULL, NULL, '2026-05-26 06:18:25', '2026-05-26 06:18:25'),
(715, 16, 38, 'monthly', '2026-04-01', '2026-04-30', 6, 0, 0.30, 0.00, 0.30, 70.00, 0.21, 0.09, 0.02, 0.19, 'calculated', '2026-05-26 06:18:25', NULL, NULL, NULL, NULL, NULL, '2026-05-26 06:18:25', '2026-05-26 06:18:25'),
(716, 16, 38, 'monthly', '2026-05-01', '2026-05-31', 5, 0, 0.25, 0.00, 0.25, 70.00, 0.18, 0.08, 0.02, 0.16, 'calculated', '2026-05-26 06:18:25', NULL, NULL, NULL, NULL, NULL, '2026-05-26 06:18:25', '2026-05-26 06:18:25'),
(717, 17, 39, 'monthly', '2026-04-01', '2026-04-30', 7, 0, 0.35, 0.00, 0.35, 70.00, 0.25, 0.11, 0.02, 0.22, 'calculated', '2026-05-26 06:18:25', NULL, NULL, NULL, NULL, NULL, '2026-05-26 06:18:25', '2026-05-26 06:18:25'),
(718, 17, 39, 'monthly', '2026-05-01', '2026-05-31', 3, 0, 0.15, 0.00, 0.15, 70.00, 0.11, 0.05, 0.01, 0.09, 'calculated', '2026-05-26 06:18:25', NULL, NULL, NULL, NULL, NULL, '2026-05-26 06:18:25', '2026-05-26 06:18:25'),
(719, 17, 40, 'monthly', '2026-04-01', '2026-04-30', 11, 0, 0.55, 0.00, 0.55, 70.00, 0.39, 0.17, 0.04, 0.35, 'calculated', '2026-05-26 06:18:25', NULL, NULL, NULL, NULL, NULL, '2026-05-26 06:18:25', '2026-05-26 06:18:25'),
(720, 17, 40, 'monthly', '2026-05-01', '2026-05-31', 5, 0, 0.25, 0.00, 0.25, 70.00, 0.18, 0.08, 0.02, 0.16, 'calculated', '2026-05-26 06:18:25', NULL, NULL, NULL, NULL, NULL, '2026-05-26 06:18:25', '2026-05-26 06:18:25'),
(721, 18, 59, 'monthly', '2026-05-01', '2026-05-31', 8, 0, 0.40, 0.00, 0.40, 30.00, 0.12, 0.28, 0.01, 0.11, 'calculated', '2026-05-26 06:18:25', NULL, NULL, NULL, NULL, NULL, '2026-05-26 06:18:25', '2026-05-26 06:18:25'),
(722, 18, 60, 'monthly', '2026-05-01', '2026-05-31', 10, 0, 0.50, 0.00, 0.50, 30.00, 0.15, 0.35, 0.02, 0.14, 'calculated', '2026-05-26 06:18:25', NULL, NULL, NULL, NULL, NULL, '2026-05-26 06:18:25', '2026-05-26 06:18:25'),
(723, 18, 61, 'monthly', '2026-05-01', '2026-05-31', 15, 0, 0.75, 0.00, 0.75, 30.00, 0.23, 0.53, 0.02, 0.20, 'calculated', '2026-05-26 06:18:25', NULL, NULL, NULL, NULL, NULL, '2026-05-26 06:18:25', '2026-05-26 06:18:25'),
(724, 18, 90, 'monthly', '2026-05-01', '2026-05-31', 8, 0, 0.40, 0.00, 0.40, 30.00, 0.12, 0.28, 0.01, 0.11, 'calculated', '2026-05-26 06:18:25', NULL, NULL, NULL, NULL, NULL, '2026-05-26 06:18:25', '2026-05-26 06:18:25'),
(725, 18, 91, 'monthly', '2026-05-01', '2026-05-31', 8, 0, 0.40, 0.00, 0.40, 30.00, 0.13, 0.29, 0.01, 0.10, 'calculated', '2026-05-26 06:18:25', NULL, NULL, NULL, NULL, NULL, '2026-05-26 06:18:25', '2026-05-26 13:25:03'),
(726, 18, 94, 'monthly', '2026-05-01', '2026-05-31', 8, 0, 0.40, 0.00, 0.40, 30.00, 0.13, 0.29, 0.01, 0.10, 'calculated', '2026-05-26 06:18:25', NULL, NULL, NULL, NULL, NULL, '2026-05-26 06:18:25', '2026-05-26 13:20:38'),
(727, 18, 95, 'monthly', '2026-05-01', '2026-05-31', 11, 0, 0.55, 0.00, 0.55, 30.00, 0.17, 0.39, 0.02, 0.15, 'calculated', '2026-05-26 06:18:25', NULL, NULL, NULL, NULL, NULL, '2026-05-26 06:18:25', '2026-05-26 06:18:25'),
(728, 18, 100, 'monthly', '2026-05-01', '2026-05-31', 10, 0, 0.50, 0.00, 0.50, 30.00, 0.15, 0.35, 0.02, 0.14, 'calculated', '2026-05-26 06:18:25', NULL, NULL, NULL, NULL, NULL, '2026-05-26 06:18:25', '2026-05-26 06:18:25'),
(729, 18, 104, 'monthly', '2026-05-01', '2026-05-31', 10, 0, 0.50, 0.00, 0.50, 30.00, 0.15, 0.35, 0.02, 0.14, 'calculated', '2026-05-26 06:18:25', NULL, NULL, NULL, NULL, NULL, '2026-05-26 06:18:25', '2026-05-26 06:18:25'),
(730, 18, 105, 'monthly', '2026-05-01', '2026-05-31', 7, 0, 0.35, 0.00, 0.35, 30.00, 0.11, 0.25, 0.01, 0.09, 'calculated', '2026-05-26 06:18:25', NULL, NULL, NULL, NULL, NULL, '2026-05-26 06:18:25', '2026-05-26 06:18:25'),
(731, 21, 43, 'monthly', '2026-04-01', '2026-04-30', 4, 0, 0.20, 0.00, 0.20, 70.00, 0.14, 0.06, 0.01, 0.13, 'calculated', '2026-05-26 06:18:25', NULL, NULL, NULL, NULL, NULL, '2026-05-26 06:18:25', '2026-05-26 06:18:25'),
(732, 21, 43, 'monthly', '2026-05-01', '2026-05-31', 5, 0, 0.25, 0.00, 0.25, 70.00, 0.18, 0.08, 0.02, 0.16, 'calculated', '2026-05-26 06:18:25', NULL, NULL, NULL, NULL, NULL, '2026-05-26 06:18:25', '2026-05-26 06:18:25'),
(733, 21, 44, 'monthly', '2026-04-01', '2026-04-30', 5, 0, 0.25, 0.00, 0.25, 70.00, 0.18, 0.08, 0.02, 0.16, 'calculated', '2026-05-26 06:18:25', NULL, NULL, NULL, NULL, NULL, '2026-05-26 06:18:25', '2026-05-26 06:18:25'),
(734, 21, 44, 'monthly', '2026-05-01', '2026-05-31', 6, 0, 0.30, 0.00, 0.30, 70.00, 0.21, 0.09, 0.02, 0.19, 'calculated', '2026-05-26 06:18:25', NULL, NULL, NULL, NULL, NULL, '2026-05-26 06:18:25', '2026-05-26 06:18:25'),
(735, 21, 45, 'monthly', '2026-04-01', '2026-04-30', 6, 0, 0.30, 0.00, 0.30, 70.00, 0.21, 0.09, 0.02, 0.19, 'calculated', '2026-05-26 06:18:25', NULL, NULL, NULL, NULL, NULL, '2026-05-26 06:18:25', '2026-05-26 06:18:25'),
(736, 21, 45, 'monthly', '2026-05-01', '2026-05-31', 7, 0, 0.35, 0.00, 0.35, 70.00, 0.25, 0.11, 0.02, 0.22, 'calculated', '2026-05-26 06:18:25', NULL, NULL, NULL, NULL, NULL, '2026-05-26 06:18:25', '2026-05-26 06:18:25'),
(737, 21, 46, 'monthly', '2026-04-01', '2026-04-30', 10, 0, 0.50, 0.00, 0.50, 70.00, 0.35, 0.15, 0.04, 0.32, 'calculated', '2026-05-26 06:18:25', NULL, NULL, NULL, NULL, NULL, '2026-05-26 06:18:25', '2026-05-26 06:18:25'),
(738, 21, 46, 'monthly', '2026-05-01', '2026-05-31', 8, 0, 0.40, 0.00, 0.40, 70.00, 0.28, 0.12, 0.03, 0.25, 'calculated', '2026-05-26 06:18:25', NULL, NULL, NULL, NULL, NULL, '2026-05-26 06:18:25', '2026-05-26 06:18:25'),
(739, 21, 47, 'monthly', '2026-04-01', '2026-04-30', 10, 0, 0.50, 0.00, 0.50, 70.00, 0.35, 0.15, 0.04, 0.32, 'calculated', '2026-05-26 06:18:25', NULL, NULL, NULL, NULL, NULL, '2026-05-26 06:18:25', '2026-05-26 06:18:25'),
(740, 21, 47, 'monthly', '2026-05-01', '2026-05-31', 6, 0, 0.30, 0.00, 0.30, 70.00, 0.21, 0.09, 0.02, 0.19, 'calculated', '2026-05-26 06:18:25', NULL, NULL, NULL, NULL, NULL, '2026-05-26 06:18:25', '2026-05-26 06:18:25'),
(741, 21, 106, 'monthly', '2026-05-01', '2026-05-31', 6, 0, 0.30, 0.00, 0.30, 70.00, 0.21, 0.09, 0.02, 0.19, 'calculated', '2026-05-26 06:18:25', NULL, NULL, NULL, NULL, NULL, '2026-05-26 06:18:25', '2026-05-26 06:18:25'),
(742, 22, 48, 'monthly', '2026-04-01', '2026-04-30', 10, 0, 0.50, 0.00, 0.50, 70.00, 0.35, 0.15, 0.04, 0.32, 'calculated', '2026-05-26 06:18:25', NULL, NULL, NULL, NULL, NULL, '2026-05-26 06:18:25', '2026-05-26 06:18:25'),
(743, 22, 48, 'monthly', '2026-05-01', '2026-05-31', 7, 0, 0.35, 0.00, 0.35, 70.00, 0.25, 0.11, 0.02, 0.22, 'calculated', '2026-05-26 06:18:25', NULL, NULL, NULL, NULL, NULL, '2026-05-26 06:18:25', '2026-05-26 06:18:25'),
(744, 22, 49, 'monthly', '2026-04-01', '2026-04-30', 18, 0, 0.90, 0.00, 0.90, 70.00, 0.63, 0.27, 0.06, 0.57, 'calculated', '2026-05-26 06:18:25', NULL, NULL, NULL, NULL, NULL, '2026-05-26 06:18:25', '2026-05-26 06:18:25'),
(745, 22, 49, 'monthly', '2026-05-01', '2026-05-31', 7, 0, 0.35, 0.00, 0.35, 70.00, 0.25, 0.11, 0.02, 0.22, 'calculated', '2026-05-26 06:18:25', NULL, NULL, NULL, NULL, NULL, '2026-05-26 06:18:25', '2026-05-26 06:18:25'),
(746, 22, 51, 'monthly', '2026-04-01', '2026-04-30', 9, 0, 0.45, 0.00, 0.45, 70.00, 0.32, 0.14, 0.03, 0.28, 'calculated', '2026-05-26 06:18:25', NULL, NULL, NULL, NULL, NULL, '2026-05-26 06:18:25', '2026-05-26 06:18:25'),
(747, 22, 51, 'monthly', '2026-05-01', '2026-05-31', 5, 0, 0.25, 0.00, 0.25, 70.00, 0.18, 0.08, 0.02, 0.16, 'calculated', '2026-05-26 06:18:25', NULL, NULL, NULL, NULL, NULL, '2026-05-26 06:18:25', '2026-05-26 06:18:25'),
(748, 22, 52, 'monthly', '2026-04-01', '2026-04-30', 10, 0, 0.50, 0.00, 0.50, 70.00, 0.35, 0.15, 0.04, 0.32, 'calculated', '2026-05-26 06:18:25', NULL, NULL, NULL, NULL, NULL, '2026-05-26 06:18:25', '2026-05-26 06:18:25'),
(749, 22, 52, 'monthly', '2026-05-01', '2026-05-31', 3, 0, 0.15, 0.00, 0.15, 70.00, 0.11, 0.05, 0.01, 0.09, 'calculated', '2026-05-26 06:18:25', NULL, NULL, NULL, NULL, NULL, '2026-05-26 06:18:25', '2026-05-26 06:18:25'),
(750, 23, 53, 'monthly', '2026-04-01', '2026-04-30', 4, 0, 0.20, 0.00, 0.20, 70.00, 0.14, 0.06, 0.01, 0.13, 'calculated', '2026-05-26 06:18:25', NULL, NULL, NULL, NULL, NULL, '2026-05-26 06:18:25', '2026-05-26 06:18:25'),
(751, 23, 53, 'monthly', '2026-05-01', '2026-05-31', 3, 0, 0.15, 0.00, 0.15, 70.00, 0.11, 0.05, 0.01, 0.09, 'calculated', '2026-05-26 06:18:25', NULL, NULL, NULL, NULL, NULL, '2026-05-26 06:18:25', '2026-05-26 06:18:25'),
(752, 23, 54, 'monthly', '2026-04-01', '2026-04-30', 2, 0, 0.10, 0.00, 0.10, 70.00, 0.07, 0.03, 0.01, 0.06, 'calculated', '2026-05-26 06:18:25', NULL, NULL, NULL, NULL, NULL, '2026-05-26 06:18:25', '2026-05-26 06:18:25'),
(753, 23, 54, 'monthly', '2026-05-01', '2026-05-31', 4, 0, 0.20, 0.00, 0.20, 70.00, 0.14, 0.06, 0.01, 0.13, 'calculated', '2026-05-26 06:18:25', NULL, NULL, NULL, NULL, NULL, '2026-05-26 06:18:25', '2026-05-26 06:18:25'),
(754, 23, 55, 'monthly', '2026-04-01', '2026-04-30', 4, 0, 0.20, 0.00, 0.20, 70.00, 0.14, 0.06, 0.01, 0.13, 'calculated', '2026-05-26 06:18:25', NULL, NULL, NULL, NULL, NULL, '2026-05-26 06:18:25', '2026-05-26 06:18:25'),
(755, 23, 55, 'monthly', '2026-05-01', '2026-05-31', 6, 0, 0.30, 0.00, 0.30, 70.00, 0.21, 0.09, 0.02, 0.19, 'calculated', '2026-05-26 06:18:25', NULL, NULL, NULL, NULL, NULL, '2026-05-26 06:18:25', '2026-05-26 06:18:25'),
(756, 23, 56, 'monthly', '2026-04-01', '2026-04-30', 2, 0, 0.10, 0.00, 0.10, 70.00, 0.07, 0.03, 0.01, 0.06, 'calculated', '2026-05-26 06:18:25', NULL, NULL, NULL, NULL, NULL, '2026-05-26 06:18:25', '2026-05-26 06:18:25'),
(757, 23, 56, 'monthly', '2026-05-01', '2026-05-31', 7, 0, 0.35, 0.00, 0.35, 70.00, 0.25, 0.11, 0.02, 0.22, 'calculated', '2026-05-26 06:18:25', NULL, NULL, NULL, NULL, NULL, '2026-05-26 06:18:25', '2026-05-26 06:18:25'),
(758, 23, 57, 'monthly', '2026-04-01', '2026-04-30', 1, 0, 0.05, 0.00, 0.05, 70.00, 0.04, 0.02, 0.00, 0.03, 'calculated', '2026-05-26 06:18:25', NULL, NULL, NULL, NULL, NULL, '2026-05-26 06:18:25', '2026-05-26 06:18:25'),
(759, 23, 57, 'monthly', '2026-05-01', '2026-05-31', 6, 0, 0.30, 0.00, 0.30, 70.00, 0.21, 0.09, 0.02, 0.19, 'calculated', '2026-05-26 06:18:25', NULL, NULL, NULL, NULL, NULL, '2026-05-26 06:18:25', '2026-05-26 06:18:25'),
(760, 23, 58, 'monthly', '2026-04-01', '2026-04-30', 2, 0, 0.10, 0.00, 0.10, 70.00, 0.07, 0.03, 0.01, 0.06, 'calculated', '2026-05-26 06:18:25', NULL, NULL, NULL, NULL, NULL, '2026-05-26 06:18:25', '2026-05-26 06:18:25'),
(761, 23, 58, 'monthly', '2026-05-01', '2026-05-31', 8, 0, 0.40, 0.00, 0.40, 70.00, 0.28, 0.12, 0.03, 0.25, 'calculated', '2026-05-26 06:18:25', NULL, NULL, NULL, NULL, NULL, '2026-05-26 06:18:25', '2026-05-26 06:18:25'),
(763, 18, NULL, 'monthly', '2026-05-01', '2026-05-31', 188, 0, 1880.00, 0.00, 1880.00, 30.00, 564.00, 1316.00, 56.40, 507.60, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-26 06:20:38', '2026-05-26 06:20:38'),
(765, 18, NULL, 'monthly', '2026-05-01', '2026-05-31', 190, 0, 1900.00, 0.00, 1900.00, 30.00, 570.00, 1330.00, 57.00, 513.00, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-26 06:25:03', '2026-05-26 06:25:03');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `partner_types`
--

CREATE TABLE `partner_types` (
  `id` bigint UNSIGNED NOT NULL,
  `code` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'music_distribution | advertising',
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Tên hiển thị',
  `description` text COLLATE utf8mb4_unicode_ci,
  `can_upload_songs` tinyint(1) NOT NULL DEFAULT '0',
  `can_manage_artists` tinyint(1) NOT NULL DEFAULT '0',
  `can_book_ads` tinyint(1) NOT NULL DEFAULT '0',
  `default_revenue_share` decimal(5,2) NOT NULL DEFAULT '70.00',
  `default_payment_frequency` enum('weekly','monthly','quarterly') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'monthly',
  `default_payment_threshold` decimal(10,2) NOT NULL DEFAULT '1000000.00',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `partner_types`
--

INSERT INTO `partner_types` (`id`, `code`, `name`, `description`, `can_upload_songs`, `can_manage_artists`, `can_book_ads`, `default_revenue_share`, `default_payment_frequency`, `default_payment_threshold`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'music_distribution', 'Music distribution partners', 'Partner companies upload and distribute music to the platform.', 1, 1, 0, 70.00, 'monthly', 100.00, 1, NULL, NULL),
(2, 'advertising', 'Advertising partners', 'Partner for booking and managing advertising on the platform.', 0, 0, 1, 30.00, 'monthly', 100.00, 1, NULL, NULL);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `payments`
--

CREATE TABLE `payments` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `subscription_plan_id` bigint UNSIGNED DEFAULT NULL,
  `payment_type` enum('subscription','upgrade','renewal','refund','topup') COLLATE utf8mb4_unicode_ci NOT NULL,
  `amount` decimal(15,2) NOT NULL,
  `currency` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'VND',
  `status` enum('pending','processing','completed','failed','refunded','cancelled') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `transfer_content` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `gateway_transaction_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `bank_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `payment_details` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'JSON data từ SePay',
  `paid_at` timestamp NULL DEFAULT NULL,
  `failed_reason` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `refunded_amount` decimal(15,2) DEFAULT '0.00',
  `refunded_at` timestamp NULL DEFAULT NULL,
  `notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `payments`
--

INSERT INTO `payments` (`id`, `user_id`, `subscription_plan_id`, `payment_type`, `amount`, `currency`, `status`, `transfer_content`, `gateway_transaction_id`, `bank_code`, `payment_details`, `paid_at`, `failed_reason`, `refunded_amount`, `refunded_at`, `notes`, `created_at`, `updated_at`) VALUES
(75, 2, 3, 'subscription', 5000.00, 'VND', 'completed', 'SEVQR SEPAY 75', NULL, NULL, NULL, '2026-02-01 03:35:32', NULL, 0.00, NULL, NULL, '2026-02-01 03:34:39', '2026-02-01 03:35:32'),
(82, 1, NULL, 'topup', 2000.00, 'VND', 'completed', 'SEVQR SEPAY 82', NULL, NULL, NULL, '2026-04-19 23:20:40', NULL, 0.00, NULL, NULL, '2026-04-19 23:20:21', '2026-04-19 23:20:40'),
(83, 1, NULL, 'topup', 3000.00, 'VND', 'completed', 'SEVQR SEPAY 83', NULL, NULL, NULL, '2026-04-19 23:23:56', NULL, 0.00, NULL, NULL, '2026-04-19 23:23:39', '2026-04-19 23:23:56'),
(84, 5, 3, 'subscription', 5000.00, 'VND', 'completed', 'SEVQR SEPAY 84', NULL, NULL, NULL, '2026-04-29 08:53:22', NULL, 0.00, NULL, NULL, '2026-04-29 08:52:49', '2026-04-29 08:53:22'),
(85, 20, 2, 'subscription', 2000.00, 'VND', 'completed', 'SEVQR SEPAY 85', NULL, NULL, NULL, '2026-05-01 01:30:22', NULL, 0.00, NULL, NULL, '2026-04-30 21:35:23', '2026-05-01 01:30:22'),
(87, 1, 3, 'subscription', 5000.00, 'VND', 'completed', 'SEVQR SEPAY 87', NULL, NULL, NULL, '2026-05-01 09:37:11', NULL, 0.00, NULL, NULL, '2026-05-01 09:36:50', '2026-05-01 09:37:11'),
(88, 21, 2, 'subscription', 2000.00, 'VND', 'completed', 'SEVQR SEPAY 88', NULL, NULL, NULL, '2026-05-21 01:43:14', NULL, 0.00, NULL, NULL, '2026-05-21 01:42:52', '2026-05-21 01:43:14'),
(89, 1, NULL, 'topup', 5000.00, 'VND', 'pending', 'SEVQR SEPAY 89', NULL, NULL, NULL, NULL, NULL, 0.00, NULL, NULL, '2026-05-26 08:03:45', '2026-05-26 08:03:45');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `permissions`
--

CREATE TABLE `permissions` (
  `id` bigint UNSIGNED NOT NULL,
  `module_id` bigint UNSIGNED NOT NULL,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `display_name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `tokenable_id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `abilities` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `personal_access_tokens`
--

INSERT INTO `personal_access_tokens` (`id`, `tokenable_type`, `tokenable_id`, `name`, `token`, `abilities`, `last_used_at`, `expires_at`, `created_at`, `updated_at`) VALUES
(145, 'App\\Models\\User', 10, 'api-token', '1308f3d85687dc634397db4d966549915b83e6a2e40568a47fdb7403053654b7', '[\"*\"]', '2026-02-07 19:24:44', NULL, '2026-02-07 19:23:59', '2026-02-07 19:24:44'),
(253, 'App\\Models\\User', 21, 'api-token', 'eade8d8e5765c8d072d222141f0c2e0b956ed1bdd1c3db4c3a465d11f95e2168', '[\"*\"]', '2026-05-21 01:48:45', '2026-06-20 01:38:38', '2026-05-21 01:38:38', '2026-05-21 01:48:45'),
(254, 'App\\Models\\User', 21, 'google-auth', '6d5e4b436888d5b2ff638c4aaf6e157a38690f206d25db722cc5678aaa99bd93', '[\"*\"]', '2026-05-21 01:39:34', '2026-06-20 01:39:21', '2026-05-21 01:39:21', '2026-05-21 01:39:34'),
(256, 'App\\Models\\User', 1, 'google-auth', '787f4b89d2955e2e8d7a28df042590d03bdd1c2f349ccc4ecb303f6d66e07210', '[\"*\"]', '2026-05-26 20:33:26', '2026-06-21 04:55:26', '2026-05-22 04:55:26', '2026-05-26 20:33:26'),
(257, 'App\\Models\\User', 17, 'api-token', '09b20420c737eeaaaddf80030741292e3851f9461111a1b5ab90feadeb8cc285', '[\"*\"]', '2026-05-26 08:26:29', '2026-06-25 08:10:47', '2026-05-26 08:10:46', '2026-05-26 08:26:29');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `playlists`
--

CREATE TABLE `playlists` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `cover_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_public` tinyint(1) NOT NULL DEFAULT '0',
  `is_collaborative` tinyint(1) NOT NULL DEFAULT '0',
  `is_system` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'System-generated playlists',
  `total_songs` int NOT NULL DEFAULT '0',
  `total_duration` int NOT NULL DEFAULT '0',
  `total_followers` int NOT NULL DEFAULT '0',
  `total_plays` bigint NOT NULL DEFAULT '0',
  `play_count_last_30d` int NOT NULL DEFAULT '0',
  `status` enum('active','archived','deleted') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `playlists`
--

INSERT INTO `playlists` (`id`, `user_id`, `name`, `slug`, `description`, `cover_url`, `is_public`, `is_collaborative`, `is_system`, `total_songs`, `total_duration`, `total_followers`, `total_plays`, `play_count_last_30d`, `status`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 1, 'Nhạc đáng nghe', 'nhac-dang-nghe-Ow3DD', NULL, 'playlist_covers/BAMoDrFfYJD8H0jOp4K7aDZEp6UvDL8qonbuVUuv.jpg', 1, 0, 0, 20, 5335, 0, 0, 0, 'active', '2026-04-27 08:34:06', '2026-05-03 06:46:22', NULL);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `playlist_collaborators`
--

CREATE TABLE `playlist_collaborators` (
  `id` bigint UNSIGNED NOT NULL,
  `playlist_id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `role` enum('editor','viewer') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'editor',
  `invited_by` bigint UNSIGNED NOT NULL,
  `invited_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `accepted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `playlist_followers`
--

CREATE TABLE `playlist_followers` (
  `id` bigint UNSIGNED NOT NULL,
  `playlist_id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `followed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `playlist_songs`
--

CREATE TABLE `playlist_songs` (
  `id` bigint UNSIGNED NOT NULL,
  `playlist_id` bigint UNSIGNED NOT NULL,
  `song_id` bigint UNSIGNED NOT NULL,
  `added_by` bigint UNSIGNED NOT NULL,
  `position` int NOT NULL DEFAULT '0',
  `added_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `playlist_songs`
--

INSERT INTO `playlist_songs` (`id`, `playlist_id`, `song_id`, `added_by`, `position`, `added_at`) VALUES
(1, 1, 50, 1, 1, '2026-04-27 08:34:07'),
(2, 1, 51, 1, 2, '2026-04-27 08:34:31'),
(3, 1, 46, 1, 3, '2026-04-28 22:22:52'),
(4, 1, 56, 1, 4, '2026-05-01 09:47:29'),
(5, 1, 55, 1, 5, '2026-05-01 09:49:07'),
(6, 1, 54, 1, 6, '2026-05-01 09:49:16'),
(7, 1, 53, 1, 7, '2026-05-01 09:49:25'),
(8, 1, 61, 1, 8, '2026-05-03 06:44:13'),
(9, 1, 42, 1, 9, '2026-05-03 06:44:58'),
(10, 1, 40, 1, 10, '2026-05-03 06:45:05'),
(11, 1, 38, 1, 11, '2026-05-03 06:45:13'),
(12, 1, 37, 1, 12, '2026-05-03 06:45:22'),
(13, 1, 36, 1, 13, '2026-05-03 06:45:30'),
(14, 1, 35, 1, 14, '2026-05-03 06:45:38'),
(15, 1, 34, 1, 15, '2026-05-03 06:45:46'),
(16, 1, 29, 1, 16, '2026-05-03 06:45:51'),
(17, 1, 28, 1, 17, '2026-05-03 06:46:00'),
(18, 1, 21, 1, 18, '2026-05-03 06:46:06'),
(19, 1, 20, 1, 19, '2026-05-03 06:46:15'),
(20, 1, 26, 1, 20, '2026-05-03 06:46:22');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `recommendations`
--

CREATE TABLE `recommendations` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `recommended_type` enum('song','album','artist','playlist') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `recommended_id` bigint UNSIGNED NOT NULL,
  `reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Because you listened to...',
  `score` decimal(10,2) NOT NULL DEFAULT '0.00',
  `algorithm` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_shown` tinyint(1) NOT NULL DEFAULT '0',
  `is_clicked` tinyint(1) NOT NULL DEFAULT '0',
  `shown_at` timestamp NULL DEFAULT NULL,
  `clicked_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `roles`
--

CREATE TABLE `roles` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `display_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `level` tinyint NOT NULL DEFAULT '0' COMMENT 'Higher = More permissions',
  `is_system` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `roles`
--

INSERT INTO `roles` (`id`, `name`, `display_name`, `description`, `level`, `is_system`, `created_at`, `updated_at`) VALUES
(1, 'boss', 'Boss/Owner', 'System owner - highest authority', 100, 1, '2025-11-11 08:45:28', '2025-11-11 08:45:28'),
(2, 'admin', 'Administrator', 'System administrator', 90, 1, '2025-11-11 08:45:28', '2025-11-11 08:45:28'),
(3, 'content_manager', 'Content Manager', 'Manage songs, albums, artists', 70, 1, '2025-11-11 08:45:28', '2025-11-11 08:45:28'),
(4, 'partner', 'Partner/Producer', 'Content provider with copyright', 50, 1, '2025-11-11 08:45:28', '2025-11-11 08:45:28'),
(5, 'moderator', 'Moderator', 'Content moderation', 40, 1, '2025-11-11 08:45:28', '2025-11-11 08:45:28'),
(6, 'user_vip_yearly', 'VIP Yearly User', 'Premium user - yearly subscription', 30, 1, '2025-11-11 08:45:28', '2025-11-11 08:45:28'),
(7, 'user_vip_monthly', 'VIP Monthly User', 'Premium user - monthly subscription', 25, 1, '2025-11-11 08:45:28', '2025-11-11 08:45:28'),
(8, 'user_free', 'Free User', 'Free tier user', 10, 1, '2025-11-11 08:45:28', '2025-11-11 08:45:28');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `role_permissions`
--

CREATE TABLE `role_permissions` (
  `id` bigint UNSIGNED NOT NULL,
  `role_id` bigint UNSIGNED NOT NULL,
  `permission_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `security_logs`
--

CREATE TABLE `security_logs` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED DEFAULT NULL,
  `event_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'login_failed, password_changed, etc',
  `severity` enum('low','medium','high','critical') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'low',
  `ip_address` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `metadata` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'JSON data',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `seo_meta`
--

CREATE TABLE `seo_meta` (
  `id` bigint UNSIGNED NOT NULL,
  `entity_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'song, album, artist, genre, etc',
  `entity_id` bigint UNSIGNED DEFAULT NULL,
  `url_path` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `keywords` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `og_title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `og_description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `og_image` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `twitter_title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `twitter_description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `twitter_image` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `canonical_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `robots` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'index,follow',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `payload` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_activity` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `sessions`
--

INSERT INTO `sessions` (`id`, `user_id`, `ip_address`, `user_agent`, `payload`, `last_activity`) VALUES
('5xGlvf2L4TG4vBKOZSDRkwytdF3uvQ3lP6OmstSm', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoid3dmUjVpa3pRZVFwVVJUN3U1NmVPZERjWlI1elJPM3RMbzJad29nQyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1774770372),
('AwP9vJSlmr5QcSaz2fdia5pPSXDQcmOcdeMfsbEU', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiMHRXQUVhYjlnd00yMjFtS0g3MXl0QTZqVHRESDhkUUlrZ2xsYlZQWSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzM1OiJodHRwOi8vbG9jYWxob3N0OjgwMDAvYXV0aC9nb29nbGUvY2FsbGJhY2s/YXV0aHVzZXI9MCZjb2RlPTQlMkYwQWVvV3VNOUFvcFlYS1FILUNjUnlQTnBLYjl2S3JfVUhxYjdJRGZhd3FoNV91YlYyTUw3bk5uVGxBU1dRa3hnQmNCVzFMdyZpc3M9aHR0cHMlM0ElMkYlMkZhY2NvdW50cy5nb29nbGUuY29tJnByb21wdD1ub25lJnNjb3BlPWVtYWlsJTIwcHJvZmlsZSUyMGh0dHBzJTNBJTJGJTJGd3d3Lmdvb2dsZWFwaXMuY29tJTJGYXV0aCUyRnVzZXJpbmZvLmVtYWlsJTIwaHR0cHMlM0ElMkYlMkZ3d3cuZ29vZ2xlYXBpcy5jb20lMkZhdXRoJTJGdXNlcmluZm8ucHJvZmlsZSUyMG9wZW5pZCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1779450926),
('EFAOGG6XnQpOh7ZVCQrv6RXcYZBkXXutXfZRZbh5', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiaHJ1WTVxVDNQTzR0TVM0cE1vWTdqZ2Nsc2EwdlJ0N3c0aFNKNVJMNiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1766045617),
('HLCDUcRH2cJ74OLL60kP7BDU1bb6U2qsfH1ATeI4', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:146.0) Gecko/20100101 Firefox/146.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiVFFOQ2dCUkJibTJQUHVNcTZmSGd3NlZldlg1aGtCMTJCdEUxNUNlSCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDE6Imh0dHA6Ly9sb2NhbGhvc3Q6ODAwMC9zYW5jdHVtL2NzcmYtY29va2llIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1764302466),
('lsIFLqGlLSgvo1p32SzwvozVfBDvjzrWkuOCd0Ob', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiOUphOEhnU2llMnRkNFZkNGFYbm05MTc5MWxKUWdTeG1xSElqWWVOSCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NTk6Imh0dHA6Ly9vdmVyY29uc2lkZXJhdGVseS11bmludGVuc2lmaWVkLWdlbmlhLm5ncm9rLWZyZWUuZGV2Ijt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1768925073),
('NghxdogngwWom44d6ESLP42KENHO30UzmaYCJYUe', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiekQ2ZjBVbk9jT2xMT292WkFiSlhZak4zOWtXZXo2Vld6UnhwRkVzdiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzM4OiJodHRwOi8vbG9jYWxob3N0OjgwMDAvYXV0aC9nb29nbGUvY2FsbGJhY2s/YXV0aHVzZXI9MCZjb2RlPTQlMkYwQWVvV3VNOUhnajd3QzZYcUo0Qnp2SWVqeEVqbGxGUVIzVjN5MTRSTWk1emplRW1Ga1pvTlV0Y1BWLWlDRlBqTEtQMVFzQSZpc3M9aHR0cHMlM0ElMkYlMkZhY2NvdW50cy5nb29nbGUuY29tJnByb21wdD1jb25zZW50JnNjb3BlPWVtYWlsJTIwcHJvZmlsZSUyMGh0dHBzJTNBJTJGJTJGd3d3Lmdvb2dsZWFwaXMuY29tJTJGYXV0aCUyRnVzZXJpbmZvLnByb2ZpbGUlMjBodHRwcyUzQSUyRiUyRnd3dy5nb29nbGVhcGlzLmNvbSUyRmF1dGglMkZ1c2VyaW5mby5lbWFpbCUyMG9wZW5pZCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1779430000),
('qlqlBShNDZAuFSVtWaAb3hnl2mF5ttFRdH8DS1fi', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiN0ZUTnZTbTlBZG9jN3RIbDdsbWxaQkVWWHgydGd3TW1XTXZmMGo1diI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1767603491),
('raEdMLg7k3oeAmVcfqublEjjxIlT6SLc8vniKL3o', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:146.0) Gecko/20100101 Firefox/146.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiTFVBZUNabjMzZVRIOG1UWTVyNFBDS25BV3BvdEQ5Vk1ITmZTdU14dyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDE6Imh0dHA6Ly9sb2NhbGhvc3Q6ODAwMC9zYW5jdHVtL2NzcmYtY29va2llIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1765461915),
('uTdQwGHPwvSENTLkGJOiJdAmxfbagEFt69ofKNSn', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.120.0 Chrome/142.0.7444.265 Electron/39.8.8 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiSHhhVWZJYzRUR0ZrakVUOTFETmZzMnVwcjJtenBrSjVLTTY4cTloeiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NTk6Imh0dHA6Ly9vdmVyY29uc2lkZXJhdGVseS11bmludGVuc2lmaWVkLWdlbmlhLm5ncm9rLWZyZWUuZGV2Ijt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1779369986),
('WR6orZ1yKLIPi1jtrJfPfDOZVJ2jAZXWeAiQVvHf', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiZjYyNjI1aGNkVGhyRWU2YWRucXNkWmw1YVJzMFRZaWdpT25udkNrSSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzU0OiJodHRwOi8vbG9jYWxob3N0OjgwMDAvYXV0aC9nb29nbGUvY2FsbGJhY2s/YXV0aHVzZXI9MCZjb2RlPTQlMkYwQWVvV3VNOTgyLVpfcWxQNVFSek5DdThOSmZlTmgxY3VyX2c2WUxhc21Ld05jSEV6RXJqY3VESk9yemQxcnRVUjFBU0NFZyZoZD1jdXNjLmN0dS5lZHUudm4maXNzPWh0dHBzJTNBJTJGJTJGYWNjb3VudHMuZ29vZ2xlLmNvbSZwcm9tcHQ9bm9uZSZzY29wZT1lbWFpbCUyMHByb2ZpbGUlMjBodHRwcyUzQSUyRiUyRnd3dy5nb29nbGVhcGlzLmNvbSUyRmF1dGglMkZ1c2VyaW5mby5lbWFpbCUyMG9wZW5pZCUyMGh0dHBzJTNBJTJGJTJGd3d3Lmdvb2dsZWFwaXMuY29tJTJGYXV0aCUyRnVzZXJpbmZvLnByb2ZpbGUiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1779352761),
('yNuEHEj9pWs5GdGIThQTkTS1R3VL5rq853DDIEgq', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiTHFydFVNeUFrQzVGbXNCSkU1UkxrU1ZQMVkyQ1JzdW5zYzFOTVpFMCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzM4OiJodHRwOi8vbG9jYWxob3N0OjgwMDAvYXV0aC9nb29nbGUvY2FsbGJhY2s/YXV0aHVzZXI9MCZjb2RlPTQlMkYwQWVvV3VNOHJmVUhGRmkyb2VNVVdaTkhIME1zRVlMMHotNTdsZUtKUHNUWUR5WDVVNzdiSlZFQ2tscDdSbmVIQ0pNMVZhQSZpc3M9aHR0cHMlM0ElMkYlMkZhY2NvdW50cy5nb29nbGUuY29tJnByb21wdD1jb25zZW50JnNjb3BlPWVtYWlsJTIwcHJvZmlsZSUyMGh0dHBzJTNBJTJGJTJGd3d3Lmdvb2dsZWFwaXMuY29tJTJGYXV0aCUyRnVzZXJpbmZvLnByb2ZpbGUlMjBodHRwcyUzQSUyRiUyRnd3dy5nb29nbGVhcGlzLmNvbSUyRmF1dGglMkZ1c2VyaW5mby5lbWFpbCUyMG9wZW5pZCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1779352612);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `songs`
--

CREATE TABLE `songs` (
  `id` bigint UNSIGNED NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `artist_id` bigint UNSIGNED NOT NULL,
  `album_id` bigint UNSIGNED DEFAULT NULL,
  `genre_id` bigint UNSIGNED DEFAULT NULL,
  `duration` int NOT NULL COMMENT 'Duration in seconds',
  `track_number` int DEFAULT NULL,
  `disc_number` int DEFAULT '1',
  `year` smallint DEFAULT NULL,
  `lyrics` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `lyrics_status` enum('pending','processing','completed','failed') COLLATE utf8mb4_unicode_ci DEFAULT 'pending' COMMENT 'Status of lyrics generation',
  `lyrics_processed_at` timestamp NULL DEFAULT NULL COMMENT 'When lyrics were generated',
  `lyrics_error` text COLLATE utf8mb4_unicode_ci COMMENT 'Error message if lyrics generation failed',
  `lyrics_debug_info` json DEFAULT NULL,
  `song_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `audio_public_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Cloudinary public ID for audio',
  `audio_processed_at` timestamp NULL DEFAULT NULL,
  `audio_processing_error` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `song_url_hq` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `song_url_lossless` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cover_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `waveform_data` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'JSON waveform data',
  `file_size` bigint DEFAULT NULL COMMENT 'File size in bytes',
  `bitrate` int DEFAULT NULL COMMENT 'kbps',
  `quality` enum('standard','high','lossless') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'standard',
  `isrc` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'International Standard Recording Code',
  `is_premium` tinyint(1) NOT NULL DEFAULT '0',
  `is_explicit` tinyint(1) NOT NULL DEFAULT '0',
  `is_featured` tinyint(1) NOT NULL DEFAULT '0',
  `allow_download` tinyint(1) NOT NULL DEFAULT '0',
  `total_plays` bigint NOT NULL DEFAULT '0',
  `total_likes` bigint NOT NULL DEFAULT '0',
  `total_comments` int NOT NULL DEFAULT '0',
  `total_shares` int NOT NULL DEFAULT '0',
  `total_downloads` bigint NOT NULL DEFAULT '0',
  `partner_id` bigint UNSIGNED DEFAULT NULL,
  `copyright_owner` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `license_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `copyright_status` enum('unverified','pending','verified','rejected','disputed') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'unverified' COMMENT 'unverified=chưa nộp hồ sơ, pending=đang chờ duyệt, verified=tick xanh, rejected=bị từ chối, disputed=đang tranh chấp',
  `status` enum('draft','published','blocked','processing','processing_failed') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'draft',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Descriptions` text COLLATE utf8mb4_unicode_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Songs table';

--
-- Đang đổ dữ liệu cho bảng `songs`
--

INSERT INTO `songs` (`id`, `title`, `slug`, `artist_id`, `album_id`, `genre_id`, `duration`, `track_number`, `disc_number`, `year`, `lyrics`, `lyrics_status`, `lyrics_processed_at`, `lyrics_error`, `lyrics_debug_info`, `song_url`, `audio_public_id`, `audio_processed_at`, `audio_processing_error`, `song_url_hq`, `song_url_lossless`, `cover_url`, `waveform_data`, `file_size`, `bitrate`, `quality`, `isrc`, `is_premium`, `is_explicit`, `is_featured`, `allow_download`, `total_plays`, `total_likes`, `total_comments`, `total_shares`, `total_downloads`, `partner_id`, `copyright_owner`, `license_type`, `copyright_status`, `status`, `created_at`, `updated_at`, `Descriptions`) VALUES
(20, 'Lối Nhỏ', 'loi-nho', 2, NULL, 3, 297, NULL, 1, 2019, NULL, NULL, NULL, NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/video/upload/v1774588768/songs/audio/20/standard/v4k64q35ih0rtok2edms.mp3', NULL, NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/video/upload/v1774588749/songs/audio/20/low/gy89z1lcfemu7upgdihb.mp3', 'https://res.cloudinary.com/djgps2bk9/video/upload/v1774588790/songs/audio/20/lossless/axrxjkig1rdtwp42frjz.flac', 'https://res.cloudinary.com/djgps2bk9/image/upload/v1774588663/songs/partners/Kh%C3%B4ng_c%C3%B3_ti%C3%AAu_%C4%91%E1%BB%81_jeypfs.jpg', NULL, 4998271, 320, 'high', NULL, 0, 0, 1, 1, 6, 0, 0, 0, 0, 14, 'Đen - Phương Anh Đào', NULL, 'unverified', 'published', '2026-03-26 22:18:43', '2026-05-26 13:32:24', NULL),
(21, 'Đi Về Nhà', 'i-ve-nha', 2, NULL, 3, 206, NULL, 1, 2020, NULL, NULL, NULL, NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/video/upload/v1774588944/songs/audio/21/standard/nmywbbyocptgi8r2d0th.mp3', NULL, NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/video/upload/v1774588938/songs/audio/21/low/w3uncpvgnixujl0kwwd5.mp3', 'https://res.cloudinary.com/djgps2bk9/video/upload/v1774588958/songs/audio/21/lossless/eema11fcy48lpzmg9vvi.flac', 'https://res.cloudinary.com/djgps2bk9/image/upload/v1774588862/songs/partners/https___images.genius.com_077868d7042c0997c7a09de6efae0264.1000x1000x1_hiftv0.png', NULL, 7364742, 320, 'high', NULL, 0, 0, 1, 1, 4, 0, 0, 0, 0, 14, 'Đen - JustaTee', NULL, 'unverified', 'published', '2026-03-26 22:21:55', '2026-05-26 13:32:24', NULL),
(22, 'Vị Nhà', 'vi-nha', 2, NULL, 3, 315, NULL, 1, 2025, NULL, NULL, NULL, NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/video/upload/v1774589785/songs/audio/22/standard/quzvvcxab12o9aedsfrg.mp3', NULL, NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/video/upload/v1774589759/songs/audio/22/low/co83z5qell0n4n26ny9i.mp3', 'https://res.cloudinary.com/djgps2bk9/video/upload/v1774589822/songs/audio/22/lossless/gnz8l5tymm0h3bufpooc.flac', 'https://res.cloudinary.com/djgps2bk9/image/upload/v1774589695/songs/partners/vi_nha_img_vgnzw0.jpg', NULL, 8860091, 320, 'high', NULL, 0, 0, 1, 1, 3, 1, 0, 0, 0, 14, 'Đen', NULL, 'unverified', 'published', '2026-03-26 22:35:17', '2026-05-26 13:32:24', NULL),
(23, 'Triệu Điều Nhỏ Xíu XIêu Lòng', 'trieu-ieu-nho-xiu-xieu-long', 2, NULL, 3, 296, NULL, 1, 2024, NULL, NULL, NULL, NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/video/upload/v1774589974/songs/audio/23/standard/aphukke9dlul5c72phzg.mp3', NULL, NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/video/upload/v1774589967/songs/audio/23/low/qgf02n8w3avymavcxksr.mp3', 'https://res.cloudinary.com/djgps2bk9/video/upload/v1774590001/songs/audio/23/lossless/doairtnyu7a8bib8dshb.flac', 'https://res.cloudinary.com/djgps2bk9/image/upload/v1774589907/songs/partners/https___images.genius.com_6bb8744bca74098f5478cfc6171793d1.1000x1000x1_at7v6u.jpg', NULL, 6053924, 320, 'high', NULL, 0, 0, 1, 1, 0, 0, 0, 0, 0, 14, 'Đen', NULL, 'unverified', 'published', '2026-03-26 22:39:01', '2026-05-26 13:32:24', NULL),
(25, 'Đưa Nhau Đi Trốn', 'ua-nhau-i-tron', 2, NULL, 3, 242, NULL, 1, 2026, '[{\"start\":30.13,\"end\":32.14,\"text\":\"Bố em hút rất nhiều thuốc\"},{\"start\":32.14,\"end\":33.86,\"text\":\"Mẹ em khóc mắt lệ nhòa\"},{\"start\":33.86,\"end\":37.73,\"text\":\"Bố anh thì đi lại còn mẹ anh gọi điện thoại đến từng nhà\"},{\"start\":37.73,\"end\":39.39,\"text\":\"Nhiều ngày rồi mình không về\"},{\"start\":39.39,\"end\":41.43,\"text\":\"Không liên lạc được gì cả\"},{\"start\":41.43,\"end\":42.95,\"text\":\"Chỉ vỏn vẹn lại mảnh giấy: ​\"},{\"start\":42.95,\"end\":45.33,\"text\":\"\\\"Đừng lo, đêm nay con đi chơi xa\\\"\"},{\"start\":45.33,\"end\":46.53,\"text\":\"Em ơi đi trốn với anh\"},{\"start\":46.53,\"end\":48.42,\"text\":\"Mình đi đến nơi có biển bạc núi xanh​\"},{\"start\":48.42,\"end\":50.09,\"text\":\"Chạy con xe anh chở em tròng trành\"},{\"start\":50.09,\"end\":52.16,\"text\":\"Mình phóng tầm mắt ngắm chân trời mới toanh\"},{\"start\":52.16,\"end\":54.57,\"text\":\"Mình ngủ một giấc mà không cần báo thức\"},{\"start\":54.57,\"end\":56.03,\"text\":\"Giờ này mọi khi anh đang trong ca trực\"},{\"start\":56.03,\"end\":58.22,\"text\":\"Em thì đang lo ngày mai giảng đường\"},{\"start\":58.22,\"end\":60.08,\"text\":\"Ôi những thứ chán chường không tẹo nào háo hức\"},{\"start\":60.08,\"end\":62.28,\"text\":\"Mình rời thành phố chật chội náo nức\"},{\"start\":62.28,\"end\":64,\"text\":\"Nơi mà cả việc thở cũng làm ta lao lực\"},{\"start\":64,\"end\":67.79,\"text\":\"Mơ những con đường xa làm anh thấy rạo rực, muốn đưa em đi trốn đến tận cùng Trái Đất\"},{\"start\":67.79,\"end\":69.68,\"text\":\"Anh chẳng cần biết là ngày nắng đẹp rạng ngời\"},{\"start\":69.68,\"end\":71.54,\"text\":\"Hay gió về, hay bão táp mưa rơi\"},{\"start\":71.54,\"end\":75.03,\"text\":\"Ngày mình đi với nhau ấy là ngày đẹp trời thì theo anh đi trốn em ơi\"},{\"start\":75.03,\"end\":78.46,\"text\":\"Thật lòng em mơ,​ mơ cùng anh đi đến tận cùng\"},{\"start\":78.46,\"end\":82.05,\"text\":\"Tận cùng chân mây vượt núi cao hay biển sâu\"},{\"start\":82.05,\"end\":84.15,\"text\":\"Biết mấy là yêu cho vừa\"},{\"start\":84.15,\"end\":86.95,\"text\":\"Giết mấy thời gian cho vừa\"},{\"start\":86.95,\"end\":90.1,\"text\":\"Khi yêu ta mơ về nhau\"},{\"start\":90.1,\"end\":94.08,\"text\":\"Để thấy lắm lúc lòng mình nhẹ, nhiều khi\"},{\"start\":94.08,\"end\":97.32,\"text\":\"Muốn ném hết tất cả để mà đi\"},{\"start\":97.32,\"end\":101.61,\"text\":\"Một lần mình sống như những đứa nhóc không nhà\"},{\"start\":101.61,\"end\":104.93,\"text\":\"Sớm thức dậy ở một nơi xa\"},{\"start\":104.93,\"end\":105.57,\"text\":\"Yeah\"},{\"start\":105.57,\"end\":107.41,\"text\":\"Em ơi anh chẳng muốn sống đời vẻ vang\"},{\"start\":107.41,\"end\":109.39,\"text\":\"Đời lên voi xuống chó, danh vọng hoặc bẽ bàng\"},{\"start\":109.39,\"end\":111.04,\"text\":\"Chỉ muốn êm ả với nhau qua ngày tháng\"},{\"start\":111.04,\"end\":113.03,\"text\":\"Hè xối gàu nước mát, lửa hồng khi đông sang\"},{\"start\":113.03,\"end\":114.8,\"text\":\"Nhưng ta càng lớn càng không có sức để phòng thủ\"},{\"start\":114.8,\"end\":116.97,\"text\":\"Đời cuốn xô ta cả khi ta trốn trong phòng ngủ\"},{\"start\":116.97,\"end\":118.82,\"text\":\"Âu lo theo về dù ta đã khóa ba lần cửa\"},{\"start\":118.82,\"end\":120.84,\"text\":\"Trốn đi, trốn đi, không để giết ta lần nữa\"},{\"start\":120.84,\"end\":122.25,\"text\":\"Em ơi đi trốn với nhau\"},{\"start\":122.25,\"end\":124.02,\"text\":\"Kệ vòng xe đó đưa mình đi tới đâu\"},{\"start\":124.02,\"end\":125.76,\"text\":\"Kệ cho nắng cháy, cho bụi phủ vai gầy\"},{\"start\":125.76,\"end\":127.74,\"text\":\"Kệ cơm, kệ áo, kệ no đủ mai này\"},{\"start\":127.74,\"end\":129.34,\"text\":\"Sau lưng là bụi, trước mặt đường chân trời\"},{\"start\":129.34,\"end\":131.41,\"text\":\"Mình kệ những luật lệ mà mình thường vâng lời\"},{\"start\":131.41,\"end\":131.96,\"text\":\"Đời\"},{\"start\":131.96,\"end\":133.99,\"text\":\"Nói mình vô trách nhiệm, có vẻ không oan\"},{\"start\":133.99,\"end\":135.56,\"text\":\"Ừ thì một lần mình là trẻ không ngoan\"},{\"start\":135.56,\"end\":137.51,\"text\":\"Anh chưa từng lên kế hoạch cho cuộc đời anh\"},{\"start\":137.51,\"end\":139.22,\"text\":\"Sẽ là mây đen kéo đến hay trời ngời xanh\"},{\"start\":139.22,\"end\":143.5,\"text\":\"Nhưng nếu em muốn thấy chân trời mới toanh thì em ơi đi trốn với anh\"},{\"start\":143.5,\"end\":145.33,\"text\":\"Nhiều hơn bầu không khí\"},{\"start\":145.33,\"end\":147.25,\"text\":\"Bớt đi những mệt nhoài\"},{\"start\":147.25,\"end\":149.11,\"text\":\"Cuộc đời đâu được mấy\"},{\"start\":149.11,\"end\":150.96,\"text\":\"Bình yên những sớm mai\"},{\"start\":150.96,\"end\":152.26,\"text\":\"Em ơi đi trốn với anh\"},{\"start\":152.26,\"end\":154.12,\"text\":\"Mình đi đến nơi có biển bạc núi xanh\"},{\"start\":154.12,\"end\":155.85,\"text\":\"Chạy con xe anh chở em tròng trành\"},{\"start\":155.85,\"end\":158.05,\"text\":\"Mình phóng tầm mắt ngắm chân trời mới toanh\"},{\"start\":158.05,\"end\":158.52,\"text\":\"Và\"},{\"start\":158.52,\"end\":160.31,\"text\":\"Sẽ là những bình mình không có tiếng chuông báo thức\"},{\"start\":160.31,\"end\":161.77,\"text\":\"Và tất cả điều đó làm anh thấy háo hức\"},{\"start\":161.77,\"end\":164.23,\"text\":\"Thật lòng em mơ, mơ cùng anh\"},{\"start\":164.23,\"end\":166.1,\"text\":\"Em ơi đi trốn với anh\"},{\"start\":166.1,\"end\":169.21,\"text\":\"Em ơi đi trốn với anh\"},{\"start\":169.21,\"end\":171.68,\"text\":\"Thật lòng em mơ, mơ cùng anh\"},{\"start\":171.68,\"end\":173.57,\"text\":\"Em ơi đi trốn với anh\"},{\"start\":173.57,\"end\":176.57,\"text\":\"Em ơi đi trốn với anh\"},{\"start\":176.57,\"end\":180.23,\"text\":\"Thật lòng em mơ, mơ cùng anh đi đến tận cùng\"},{\"start\":180.23,\"end\":184.27,\"text\":\"Tận cùng chân mây vượt núi cao hay biển sâu\"},{\"start\":184.27,\"end\":186.03,\"text\":\"Biết mấy là yêu cho vừa\"},{\"start\":186.03,\"end\":188.88,\"text\":\"Giết mấy thời gian cho vừa\"},{\"start\":188.88,\"end\":192.03,\"text\":\"Khi yêu ta mơ về nhau\"},{\"start\":192.03,\"end\":195.92,\"text\":\"Để thấy lắm lúc lòng mình nhẹ, nhiều khi\"},{\"start\":195.92,\"end\":199.42,\"text\":\"Muốn ném hết tất cả để mà đi\"},{\"start\":199.42,\"end\":203.5,\"text\":\"Một lần mình sống như những đứa nhóc không nhà\"},{\"start\":203.5,\"end\":0,\"text\":\"Sớm thức dậy ở một nơi xa\"}]', 'completed', '2026-04-03 21:17:21', NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/video/upload/v1775275586/songs/audio/25/j20wmqujw1ehr87tvqlu.mp3', 'songs/audio/25/j20wmqujw1ehr87tvqlu', NULL, NULL, NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/image/upload/v1774590752/songs/partners/t%E1%BA%A3i_xu%E1%BB%91ng_hzw9bt.jpg', NULL, 6552737, 320, 'high', NULL, 0, 0, 1, 1, 6, 1, 0, 2, 0, 14, 'Đen - Linh Cáo', NULL, 'unverified', 'published', '2026-03-26 22:52:48', '2026-05-26 13:32:24', NULL),
(26, 'Một Triệu Like', 'mot-trieu-like', 2, NULL, 3, 261, NULL, 1, 2022, '[{\"start\":7.91,\"end\":9.82,\"text\":\"Ay\"},{\"start\":9.82,\"end\":12.53,\"text\":\"Đen Vâu\"},{\"start\":12.53,\"end\":14.03,\"text\":\"Talk to myself\"},{\"start\":14.03,\"end\":17.2,\"text\":\"Một cái beat thật chill đưa ta về với bản chất\"},{\"start\":17.2,\"end\":20.3,\"text\":\"Denvau keep it real, rap theo kiểu đơn giản nhất\"},{\"start\":20.3,\"end\":23.16,\"text\":\"Cuộc chơi đi hơi xa, hơn cả thứ mà ta từng mơ về\"},{\"start\":23.16,\"end\":26.26,\"text\":\"Bật cho ta con beat, coi Denvau tiếp tục làm thơ nà\"},{\"start\":26.26,\"end\":29.25,\"text\":\"Con gấu kiếm ăn đủ, thì nó mới có thể ngủ đông\"},{\"start\":29.25,\"end\":32.42,\"text\":\"Đại bàng tập đập cánh, trước cả khi nó đã đủ lông\"},{\"start\":32.42,\"end\":35.47,\"text\":\"Chịu nhiều vết thương nhất, mới đủ sức làm con sói đầu đàn\"},{\"start\":35.47,\"end\":38.41,\"text\":\"Con người trong nghịch cảnh, càng không được phép chịu đầu hàng\"},{\"start\":38.41,\"end\":41.53,\"text\":\"Trong đầu là vàng, lửa trong tim, dưới chân sỏi đá\"},{\"start\":41.53,\"end\":44.34,\"text\":\"Không có hoa hồng, nếu không làm, mà chỉ giỏi phá\"},{\"start\":44.34,\"end\":47.34,\"text\":\"Có lẽ việc ta làm, chỉ là thứ gì đó đang hợp thời\"},{\"start\":47.34,\"end\":50.21,\"text\":\"Cũng vui vì làm chiếc lá, trong vô vàn hoa lá bay rợp trời\"},{\"start\":50.21,\"end\":53.66,\"text\":\"Cũng may không làm idol, không phải mang gánh nặng đến trĩu vai\"},{\"start\":53.66,\"end\":56.58,\"text\":\"Một bài nhạc lộn xộn, kỉ niệm ngày có được một triệu like\"},{\"start\":56.58,\"end\":59.53,\"text\":\"Nếu mỗi người cho ta một ngàn, là ta sẽ có ngay một tỷ đồng\"},{\"start\":59.53,\"end\":63.26,\"text\":\"Lấy tiền đó lên vùng xa, xây được mấy cái lớp học vỡ lòng\"},{\"start\":63.26,\"end\":66.95,\"text\":\"Ánh nắng cuối cùng dần buông xuống\"},{\"start\":66.95,\"end\":69.29,\"text\":\"Bỗng thấy thèm một ly trà đắng chát\"},{\"start\":69.29,\"end\":73.02,\"text\":\"Ai về trên phố hai bên hàng cây\"},{\"start\":73.02,\"end\":75.56,\"text\":\"Mai có lẽ là một ngày nắng khác\"},{\"start\":75.56,\"end\":78.97,\"text\":\"Hồng tàn một đoá nắm trong bàn tay\"},{\"start\":78.97,\"end\":81.35,\"text\":\"Trước khi theo con gió mà khô đi\"},{\"start\":81.35,\"end\":85.06,\"text\":\"Cho ta giữ trọn giấc mơ cuối ngày\"},{\"start\":85.06,\"end\":87.1,\"text\":\"Để ta biết mình không hề vô tri\"},{\"start\":87.1,\"end\":90.07,\"text\":\"Gọi ta là Mít-đặc, bạn ta là Biết-tuốt\"},{\"start\":90.07,\"end\":93.03,\"text\":\"Và ta đang phiêu lưu, chuyến đi không biết trước\"},{\"start\":93.03,\"end\":96.3,\"text\":\"Đâu có ai mà biết được, mấy thằng thích hát ca\"},{\"start\":96.3,\"end\":99.07,\"text\":\"Lông bông từ ngày đó, đến bây giờ là rap star?\"},{\"start\":99.07,\"end\":101.45,\"text\":\"Đám người ở trong chuồng, nói tụi ta ngông cuồng\"},{\"start\":101.45,\"end\":103.62,\"text\":\"Nói ta vô văn hoá, nhưng mà ta không buồn\"},{\"start\":103.62,\"end\":106,\"text\":\"Đẹp hơn hoa trong vườn, đôi khi như bác sĩ\"},{\"start\":106,\"end\":108.76,\"text\":\"Moi móc hết tâm can mặc kệ người khác nghĩ\"},{\"start\":108.76,\"end\":110.52,\"text\":\"Cũng đã quen với đắng cay\"},{\"start\":110.52,\"end\":113.58,\"text\":\"Bước vào đời tay trắng cùng lắm lại trở về với trắng tay\"},{\"start\":113.58,\"end\":116.52,\"text\":\"Mỗi ngày ta thức dậy, dành một lúc ngắm nhìn mây trắng bay\"},{\"start\":116.52,\"end\":119.96,\"text\":\"Khi mày yêu cuộc đời, cuộc đời cũng sẽ yêu mày đắm say\"},{\"start\":119.96,\"end\":121.79,\"text\":\"Có quá nhiều thứ muốn anh chi\"},{\"start\":121.79,\"end\":124.8,\"text\":\"Nhiều người thì cũng muốn anh sẽ xuống nhanh đi\"},{\"start\":124.8,\"end\":128.28,\"text\":\"Khi tóc còn như vườn cải, còn đang bổ luống xanh rì\"},{\"start\":128.28,\"end\":131.11,\"text\":\"Như Trịnh Công Sơn anh muốn để gió cuốn anh đi\"},{\"start\":131.11,\"end\":134.34,\"text\":\"Hạnh phúc là khi về nhà, mẹ vẫn chờ ba dang rộng cửa\"},{\"start\":134.34,\"end\":137.31,\"text\":\"Những lúc như thế, đời chẳng còn gì quan trọng nữa\"},{\"start\":137.31,\"end\":139.91,\"text\":\"Mày sẽ không biết mày đã từng may mắn tới cỡ nào\"},{\"start\":139.91,\"end\":144.09,\"text\":\"Cho tới khi mày hiểu được sự nhẹ nhõm của một cái thở phào\"},{\"start\":144.09,\"end\":148.31,\"text\":\"Ta chỉ muốn được yên, đừng nỡ nào...\"},{\"start\":148.31,\"end\":151.86,\"text\":\"Ánh nắng cuối cùng dần buông xuống\"},{\"start\":151.86,\"end\":154.25,\"text\":\"Bỗng thấy thèm một ly trà đắng chát\"},{\"start\":154.25,\"end\":158.16,\"text\":\"Ai về trên phố hai bên hàng cây\"},{\"start\":158.16,\"end\":160.56,\"text\":\"Mai có lẽ là một ngày nắng khác\"},{\"start\":160.56,\"end\":164.08,\"text\":\"Hồng tàn một đoá nắm trong bàn tay\"},{\"start\":164.08,\"end\":166.52,\"text\":\"Trước khi theo con gió mà khô đi\"},{\"start\":166.52,\"end\":170.23,\"text\":\"Cho ta giữ trọn giấc mơ cuối ngày\"},{\"start\":170.23,\"end\":171.83,\"text\":\"Để ta biết mình không hề vô tri\"},{\"start\":171.83,\"end\":174.78,\"text\":\"Sống phải hiền chứ đừng quá lành, lành quá tụi nó bắt nạt\"},{\"start\":174.78,\"end\":178.03,\"text\":\"Tụi nó sẽ vắt kiệt mày đến từng đồng xu cắc bạc\"},{\"start\":178.03,\"end\":180.71,\"text\":\"Dù mày cầm tinh con gì, tụi nó cũng muốn cưỡi lên\"},{\"start\":180.71,\"end\":183.92,\"text\":\"Cưỡi lên đầu cưỡi lên cổ, cho dù mày có lè lưỡi rên\"},{\"start\":183.92,\"end\":187.14,\"text\":\"Khi mày đã từng nghèo khó, tay mày đã từng chai và sạn\"},{\"start\":187.14,\"end\":190.09,\"text\":\"Tao tin là mày sẽ biết ở bên mày có ai là bạn\"},{\"start\":190.09,\"end\":193.27,\"text\":\"Thử ngã một lần mà coi, mấy ai chịu đỡ mày đâu\"},{\"start\":193.27,\"end\":196.26,\"text\":\"Đa số là cười vào mặt, rồi tiện thể đạp xuống thật sâu\"},{\"start\":196.26,\"end\":198.5,\"text\":\"Vì trò đời mà, chua như là dưa ghém\"},{\"start\":198.5,\"end\":201.44,\"text\":\"Tụi nó thích hạ thấp người khác để che đậy cảm giác thua kém\"},{\"start\":201.44,\"end\":204.38,\"text\":\"Tụi nó sẽ phán xét mày bằng tư duy chưa quá lớp chồi\"},{\"start\":204.38,\"end\":207.76,\"text\":\"Mày ngã, tụi nó cười to, mồm nó há như cá đớp mồi\"},{\"start\":207.76,\"end\":210.86,\"text\":\"Rải một chút cám cò, tìm tụi nó không cần phải lội ao\"},{\"start\":210.86,\"end\":213.54,\"text\":\"Nhiều khi tao thấy tiếc, niềm thân ái mà tao đã vội trao\"},{\"start\":213.54,\"end\":216.75,\"text\":\"Tụi nó sẽ không xuất hiện khi không thấy được một chút lợi nào\"},{\"start\":216.75,\"end\":221.25,\"text\":\"Làm bạn tao thì được, đừng có muốn làm ông cố nội tao!\"},{\"start\":221.25,\"end\":224.8,\"text\":\"Ánh nắng cuối cùng dần buông xuống\"},{\"start\":224.8,\"end\":227.26,\"text\":\"Bỗng thấy thèm một ly trà đắng chát\"},{\"start\":227.26,\"end\":230.97,\"text\":\"Ai về trên phố hai bên hàng cây\"},{\"start\":230.97,\"end\":233.41,\"text\":\"Mai có lẽ là một ngày nắng khác\"},{\"start\":233.41,\"end\":236.98,\"text\":\"Hồng tàn một đoá nắm trong bàn tay\"},{\"start\":236.98,\"end\":239.55,\"text\":\"Trước khi theo con gió mà khô đi\"},{\"start\":239.55,\"end\":243.01,\"text\":\"Cho ta giữ trọn giấc mơ cuối ngày\"},{\"start\":243.01,\"end\":256.64,\"text\":\"Để ta biết mình không hề vô tri\"},{\"start\":256.64,\"end\":0,\"text\":\"Nếu mỗi người cho ta một ngàn\"}]', 'completed', '2026-04-03 20:57:39', NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/video/upload/v1774690186/songs/audio/26/standard/aylcf7uuymcyvu9iruup.mp3', NULL, NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/video/upload/v1774690150/songs/audio/26/low/tl5obtlm3md4w7ey0ifh.mp3', 'https://res.cloudinary.com/djgps2bk9/video/upload/v1774690204/songs/audio/26/lossless/mvcif5j1uzjblspjfwnb.flac', 'https://res.cloudinary.com/djgps2bk9/image/upload/v1774689867/songs/partners/t%E1%BA%A3i_xu%E1%BB%91ng_1_dqcy5i.jpg', NULL, 7445186, 320, 'high', NULL, 0, 0, 1, 1, 8, 0, 0, 0, 0, 14, 'Đen', NULL, 'unverified', 'published', '2026-03-28 02:28:38', '2026-05-26 13:32:24', NULL),
(28, 'Lạc Trôi', 'lac-troi', 1, 2, 10, 233, NULL, 1, 2017, '[{\"start\":0,\"end\":28,\"text\":\"🎶\"},{\"start\":28,\"end\":30.76,\"text\":\"Theo hương ma mây bù răng nối\"},{\"start\":30.76,\"end\":34.68,\"text\":\"Lan sương khói vội vai đưa bước ai xa rồi\"},{\"start\":34.68,\"end\":37.18,\"text\":\"Đơn côi mình ta vẫn vương\"},{\"start\":37.18,\"end\":40.66,\"text\":\"Ngồi ước trong me say chiều mưa buông\"},{\"start\":40.66,\"end\":45.22,\"text\":\"Ngân giọt lẻ ngừng khiến khoe mi sầu đi\"},{\"start\":45.22,\"end\":48.62,\"text\":\"Tình xưa nát cốt nhẫn từ giá biển ly\"},{\"start\":48.62,\"end\":51.12,\"text\":\"Cánh hoa rụng rời\"},{\"start\":51.12,\"end\":55.08,\"text\":\"Thật duyên mong manh rẽ lỗi trong mơ về tương phu\"},{\"start\":55.08,\"end\":58.36,\"text\":\"Tình không còn đeo lần gió bay\"},{\"start\":58.36,\"end\":62.02,\"text\":\"Các quả sớm quá khuyên vẫn hãy chẳng tàn bởi nay\"},{\"start\":62.02,\"end\":65.44,\"text\":\"Trong bao bóng ai dặn thao hề\"},{\"start\":65.44,\"end\":72.34,\"text\":\"Và xin nguyện khát đi trong tim\"},{\"start\":72.34,\"end\":75.02,\"text\":\"Tình đồng đeo say mắt cho tóc mây\"},{\"start\":75.02,\"end\":76.84,\"text\":\"Vương lên môi môi tay\"},{\"start\":76.84,\"end\":80.06,\"text\":\"Mong thương mình ta là trôi giữa đời\"},{\"start\":80.06,\"end\":83.56,\"text\":\"Ta là trôi giữa trời\"},{\"start\":83.56,\"end\":141.48611,\"text\":\"H subscribe cho k Ghi M G kh b l nh video h d H subscribe cho k Ghi M G kh b l nh video h d\"},{\"start\":141.50612,\"end\":143.66612,\"text\":\"Đừng có muốn theo lắm gió bay\"},{\"start\":143.66612,\"end\":147.54611,\"text\":\"Qua sớm ta quên vẫn hay chẳng ngàn nơi này\"},{\"start\":147.54611,\"end\":150.74612,\"text\":\"Chúng ta vẫn mãi dành bao ngày\"},{\"start\":150.74612,\"end\":157.64612,\"text\":\"Lòng ta xin người khác đi trong tim\"},{\"start\":157.64612,\"end\":160.34612,\"text\":\"Tình mong mơ xoay mất cho tháng mây\"},{\"start\":160.34612,\"end\":162.14612,\"text\":\"Bước lên môi ngôi tay\"},{\"start\":162.14612,\"end\":165.40613,\"text\":\"Mong vòng mình ta là trôi giữa đời\"},{\"start\":165.40613,\"end\":168.60611,\"text\":\"Ta là trôi giữa trời\"},{\"start\":171.50612,\"end\":183.22612,\"text\":\"Ta lạc trôi, ta lạc trôi giữa đời, lạc trôi giữa trời\"},{\"start\":201.50612,\"end\":203.50612,\"text\":\"Ta đang làm nơi nào\"},{\"start\":203.50612,\"end\":205.50612,\"text\":\"Nơi nào, nơi nào\"},{\"start\":205.50612,\"end\":207.50612,\"text\":\"Oh oh oh\"},{\"start\":207.50612,\"end\":209.50612,\"text\":\"Ta đang làm nơi nào\"},{\"start\":209.50612,\"end\":211.50612,\"text\":\"Nơi nào, nơi nào\"},{\"start\":211.50612,\"end\":213.50612,\"text\":\"Oh oh oh\"},{\"start\":213.50612,\"end\":215.50612,\"text\":\"Nói mọi điều với mọi người\"},{\"start\":215.50612,\"end\":217.50612,\"text\":\"Ta đang làm nơi nào\"},{\"start\":217.50612,\"end\":219.50612,\"text\":\"Oh oh oh\"},{\"start\":219.50612,\"end\":221.50612,\"text\":\"Oh oh oh\"},{\"start\":221.50612,\"end\":223.50612,\"text\":\"Nói chờ và muốn nhiều người ta\"},{\"start\":223.50612,\"end\":225.50612,\"text\":\"Ta đang làm nơi nào\"},{\"start\":225.50612,\"end\":227.50612,\"text\":\"Oh oh oh\"},{\"start\":227.50612,\"end\":229.50612,\"text\":\"Oh oh oh\"},{\"start\":231.50612,\"end\":232.90613,\"text\":\"Hãy subscribe cho kênh La La School Để không bỏ lỡ những video hấp dẫn\"}]', 'completed', '2026-04-03 04:04:13', NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/video/upload/v1775214248/songs/audio/28/ksvl2zrikj6kletyjfdn.mp3', 'songs/audio/28/ksvl2zrikj6kletyjfdn', NULL, NULL, NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/image/upload/v1774883243/songs/partners/t%E1%BA%A3i_xu%E1%BB%91ng_2_frncfl.jpg', NULL, 3729041, 320, 'high', NULL, 0, 0, 1, 1, 11, 0, 0, 0, 0, 15, 'Sơn Tùng MTP', NULL, 'unverified', 'published', '2026-03-30 08:07:37', '2026-05-26 13:32:24', NULL),
(29, 'Hãy Trao Cho Anh', 'hay-trao-cho-anh', 1, 2, 10, 246, NULL, 1, 2019, '[{\"start\":10.36,\"end\":12.71,\"text\":\"La-la-la-la-la-la-la-la-la-la-la-la (Yeah, yeah)\"},{\"start\":12.71,\"end\":15.27,\"text\":\"La-la-la-la-la-la-la-la-la-la-la-la (Yeah, yeah)\"},{\"start\":15.27,\"end\":17.89,\"text\":\"La-la-la-la-la-la-la-la-la-la-la-la, la (Yeah, yeah)\"},{\"start\":17.89,\"end\":19.82,\"text\":\"(Good boy)\"},{\"start\":19.82,\"end\":21.85,\"text\":\"Hình bóng ai đó nhẹ nhàng vụt qua nơi đây\"},{\"start\":21.85,\"end\":24.33,\"text\":\"Quyến rũ ngây ngất loạn nhịp làm tim mê say\"},{\"start\":24.33,\"end\":26.74,\"text\":\"Cuốn lấy áng mây theo cơn sóng xô dập dìu\"},{\"start\":26.74,\"end\":30.33,\"text\":\"Nụ cười ngọt ngào cho ta tan vào phút giây miên man quên hết con đường về eh\"},{\"start\":30.33,\"end\":31.35,\"text\":\"(Let me know your name)\"},{\"start\":31.35,\"end\":32.95,\"text\":\"Chẳng thể tìm thấy lối về eh\"},{\"start\":32.95,\"end\":33.89,\"text\":\"(Let me know your name)\"},{\"start\":33.89,\"end\":36.29,\"text\":\"Điệu nhạc hòa quyện trong ánh mắt đôi môi\"},{\"start\":36.29,\"end\":38.85,\"text\":\"Dẫn lối những bối rối rung động khẽ lên ngôi\"},{\"start\":38.85,\"end\":39.53,\"text\":\"(Và rồi khẽ, và rồi khẽ khẽ)\"},{\"start\":39.53,\"end\":40.31,\"text\":\"Chạm nhau mang vô vàn\"},{\"start\":40.31,\"end\":41.52,\"text\":\"Đắm đuối vấn vương dâng tràn\"},{\"start\":41.52,\"end\":42.5,\"text\":\"Lấp kín chốn nhân gian\"},{\"start\":42.5,\"end\":44.22,\"text\":\"Làn gió hoá sắc hương mơ màng\"},{\"start\":44.22,\"end\":45.28,\"text\":\"Một giây ngang qua đời\"},{\"start\":45.28,\"end\":46.53,\"text\":\"Cất tiếng nói không nên lời\"},{\"start\":46.53,\"end\":49.38,\"text\":\"Ấm áp đến trao tay ngàn sao trời lòng càng thêm chơi vơi\"},{\"start\":49.38,\"end\":50.54,\"text\":\"Dịu êm không gian bừng sáng\"},{\"start\":50.54,\"end\":51.6,\"text\":\"Đánh thức muôn hoa mừng\"},{\"start\":51.6,\"end\":54.09,\"text\":\"Quấn quít hát ngân nga từng chút níu bước chân em dừng\"},{\"start\":54.09,\"end\":56.56,\"text\":\"Bao ý thơ tương tư ngẩn ngơ\"},{\"start\":56.56,\"end\":60.42,\"text\":\"Lưu dấu nơi mê cung đẹp thẫn thờ\"},{\"start\":60.42,\"end\":61.97,\"text\":\"Hãy trao cho anh\"},{\"start\":61.97,\"end\":63.07,\"text\":\"Hãy trao cho anh\"},{\"start\":63.07,\"end\":65.54,\"text\":\"Hãy trao cho anh thứ anh đang mong chờ\"},{\"start\":65.54,\"end\":66.84,\"text\":\"Hãy trao cho anh\"},{\"start\":66.84,\"end\":68.06,\"text\":\"Hãy trao cho anh\"},{\"start\":68.06,\"end\":70.55,\"text\":\"Hãy mau làm điều ta muốn vào khoảnh khắc này đê\"},{\"start\":70.55,\"end\":71.77,\"text\":\"Hãy trao cho anh\"},{\"start\":71.77,\"end\":73.11,\"text\":\"Hãy trao cho anh\"},{\"start\":73.11,\"end\":76.12,\"text\":\"Hãy trao anh trao cho anh đi những yêu thương nồng cháy\"},{\"start\":76.12,\"end\":78.88,\"text\":\"Trao anh ái ân nguyên vẹn đong đầy\"},{\"start\":78.88,\"end\":83.66,\"text\":\"La-la, la-la-la-la-la\"},{\"start\":83.66,\"end\":89.1,\"text\":\"La-la, la-la-la-la-la\"},{\"start\":89.1,\"end\":93.75,\"text\":\"La-la, la-la-la-la-la\"},{\"start\":93.75,\"end\":100.15,\"text\":\"La-la, la-la-la-la-la\"},{\"start\":100.15,\"end\":102.6,\"text\":\"Looking at my Gucci is about that time\"},{\"start\":102.6,\"end\":104.97,\"text\":\"We can smoke a blunt and pop a bottle of wine\"},{\"start\":104.97,\"end\":107.43,\"text\":\"Now get yourself together and be ready by nine\"},{\"start\":107.43,\"end\":109.78,\"text\":\"Cuz we gon\' do some things that will shatter your spine\"},{\"start\":109.78,\"end\":113.36,\"text\":\"Come one, undone, Snoop Dogg, Son Tung\"},{\"start\":113.36,\"end\":115.84,\"text\":\"Long Beach is the city that I come from\"},{\"start\":115.84,\"end\":117.56,\"text\":\"So if you want some, get some\"},{\"start\":117.56,\"end\":119.49,\"text\":\"Better enough take some, take some\"},{\"start\":119.49,\"end\":120.37,\"text\":\"Chạm nhau mang vô vàn\"},{\"start\":120.37,\"end\":121.55,\"text\":\"Đắm đuối vấn vương dâng tràn\"},{\"start\":121.55,\"end\":122.54,\"text\":\"Lấp kín chốn nhân gian làn\"},{\"start\":122.54,\"end\":124.31,\"text\":\"Gió hóa sắc hương mơ màng\"},{\"start\":124.31,\"end\":125.33,\"text\":\"Một giây ngang qua đời\"},{\"start\":125.33,\"end\":126.56,\"text\":\"Cất tiếng nói không nên lời\"},{\"start\":126.56,\"end\":129.46,\"text\":\"Ấm áp đến trao tay ngàn sao trời lòng càng thêm chơi vơi\"},{\"start\":129.46,\"end\":130.51,\"text\":\"Dịu êm không gian bừng sáng\"},{\"start\":130.51,\"end\":131.59,\"text\":\"Đánh thức muôn hoa mừng\"},{\"start\":131.59,\"end\":134.13,\"text\":\"Quấn quít hát ngân nga từng chút níu bước chân em dừng\"},{\"start\":134.13,\"end\":136.63,\"text\":\"Bao ý thơ tương tư ngẩn ngơ\"},{\"start\":136.63,\"end\":140.35,\"text\":\"Lưu dấu nơi mê cung đẹp thẫn thờ\"},{\"start\":140.35,\"end\":141.82,\"text\":\"Hãy trao cho anh\"},{\"start\":141.82,\"end\":143.06,\"text\":\"Hãy trao cho anh\"},{\"start\":143.06,\"end\":145.36,\"text\":\"Hãy trao cho anh thứ anh đang mong chờ\"},{\"start\":145.36,\"end\":146.86,\"text\":\"Hãy trao cho anh\"},{\"start\":146.86,\"end\":148.17,\"text\":\"Hãy trao cho anh\"},{\"start\":148.17,\"end\":150.51,\"text\":\"Hãy mau làm điều ta muốn vào khoảnh khắc này đê\"},{\"start\":150.51,\"end\":152.07,\"text\":\"Hãy trao cho anh\"},{\"start\":152.07,\"end\":153.17,\"text\":\"Hãy trao cho anh\"},{\"start\":153.17,\"end\":156.05,\"text\":\"Hãy trao anh trao cho anh đi những yêu thương nồng cháy\"},{\"start\":156.05,\"end\":158.82,\"text\":\"Trao anh ái ân nguyên vẹn đong đầy\"},{\"start\":158.82,\"end\":163.78,\"text\":\"La-la, la-la-la-la-la\"},{\"start\":163.78,\"end\":169.1,\"text\":\"La-la, la-la-la-la-la\"},{\"start\":169.1,\"end\":173.62,\"text\":\"La-la, la-la-la-la-la\"},{\"start\":173.62,\"end\":179.53,\"text\":\"La-la, la-la-la-la-la\"},{\"start\":179.53,\"end\":181.94,\"text\":\"Em cho ta ngắm thiên đàng vội vàng qua chốc lát\"},{\"start\":181.94,\"end\":184.52,\"text\":\"Như thanh âm chứa bao lời gọi mời trong khúc hát\"},{\"start\":184.52,\"end\":186.7,\"text\":\"Liêu xiêu ta xuyến xao rạo rực khát khao trông mong\"},{\"start\":186.7,\"end\":189.46,\"text\":\"Dịu dàng lại gần nhau hơn dang tay ôm em vào lòng\"},{\"start\":189.46,\"end\":191.93,\"text\":\"Trao đi trao hết đi đừng ngập ngừng che dấu nữa\"},{\"start\":191.93,\"end\":194.47,\"text\":\"Quên đi quên hết đi ngại ngùng lại gần thêm chút nữa\"},{\"start\":194.47,\"end\":199.39,\"text\":\"Chìm đắm giữa khung trời riêng hai ta như dần hòa quyện mắt nhắm mắt tay đan tay hồn lạc về miền trăng sao\"},{\"start\":199.39,\"end\":201.86,\"text\":\"Em cho ta ngắm thiên đàng vội vàng qua chốc lát\"},{\"start\":201.86,\"end\":204.3,\"text\":\"Như thanh âm chứa bao lời gọi mời trong khúc hát\"},{\"start\":204.3,\"end\":206.76,\"text\":\"Liêu xiêu ta xuyến xao rạo rực khát khao trông mong\"},{\"start\":206.76,\"end\":209.32,\"text\":\"Dịu dàng lại gần nhau hơn dang tay ôm em vào lòng\"},{\"start\":209.32,\"end\":211.97,\"text\":\"Trao đi trao hết đi đừng ngập ngừng che dấu nữa\"},{\"start\":211.97,\"end\":214.4,\"text\":\"Quên đi quên hết đi ngại ngùng lại gần thêm chút nữa\"},{\"start\":214.4,\"end\":221.02,\"text\":\"Chìm đắm giữa khung trời riêng hai ta như dần hòa quyện mắt nhắm mắt tay đan tay hồn lạc về miền trăng sao\"},{\"start\":221.02,\"end\":222.03,\"text\":\"Hãy trao cho anh\"},{\"start\":222.03,\"end\":223.08,\"text\":\"Hãy trao cho anh\"},{\"start\":223.08,\"end\":224.17,\"text\":\"Hãy trao cho anh\"},{\"start\":224.17,\"end\":225.81,\"text\":\"Cho anh, cho anh\"},{\"start\":225.81,\"end\":227.01,\"text\":\"Hãy trao cho anh\"},{\"start\":227.01,\"end\":228.11,\"text\":\"Hãy trao cho anh\"},{\"start\":228.11,\"end\":229.23,\"text\":\"Hãy trao cho anh\"},{\"start\":229.23,\"end\":230.93,\"text\":\"Cho anh, cho anh, cho anh\"},{\"start\":230.93,\"end\":232.03,\"text\":\"Hãy trao cho anh\"},{\"start\":232.03,\"end\":233.27,\"text\":\"Hãy trao cho anh\"},{\"start\":233.27,\"end\":234.25,\"text\":\"Hãy trao cho anh\"},{\"start\":234.25,\"end\":235.89,\"text\":\"Cho anh, cho anh\"},{\"start\":235.89,\"end\":237,\"text\":\"Hãy trao cho anh\"},{\"start\":237,\"end\":240.33,\"text\":\"Hãy trao cho anh\"},{\"start\":240.33,\"end\":242.3,\"text\":\"Hãy trao cho anh thứ anh đang mong chờ\"},{\"start\":242.3,\"end\":0,\"text\":\"By TrinhDHoang\"}]', 'completed', '2026-04-03 04:08:47', NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/video/upload/v1775214522/songs/audio/29/lsqs0u41ujh6zx3ctlvb.mp3', 'songs/audio/29/lsqs0u41ujh6zx3ctlvb', NULL, NULL, NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/image/upload/v1775110974/songs/partners/0_e6vlbv.jpg', NULL, 4007776, 320, 'high', NULL, 0, 0, 1, 1, 18, 0, 0, 1, 0, 15, 'Snoop Dogg', NULL, 'unverified', 'published', '2026-04-01 23:26:05', '2026-05-26 13:32:24', NULL),
(34, 'Mang Tiền Về Cho Mẹ', 'mang-tien-ve-cho-me', 2, NULL, 3, 402, NULL, 1, 2021, '[{\"start\":0,\"end\":4.94,\"text\":\"Alo mẹ, tuần sau con về mẹ có cần mua gì không ạ?\"},{\"start\":6.46,\"end\":10,\"text\":\"Thôi thôi, không cần phải mua gì đâu, nhà đủ hết rồi\"},{\"start\":10.52,\"end\":17.26,\"text\":\"Mang tình về cho mẹ, mang tình về cho mẹ\"},{\"start\":17.26,\"end\":20.8,\"text\":\"Mang tình về cho mẹ, đừng mang ưu phình về cho mẹ\"},{\"start\":20.8,\"end\":24.3,\"text\":\"Mang tình về cho mẹ, mang tình về cho mẹ\"},{\"start\":24.3,\"end\":27.84,\"text\":\"Mang tình về cho mẹ, đừng mang ưu phình về cho mẹ\"},{\"start\":27.84,\"end\":31.44,\"text\":\"Nếu không có mẹ, con cũng chỉ là đồ bỏ mà thôi\"},{\"start\":31.44,\"end\":35.02,\"text\":\"Sẽ không có nề có nếp, dù đặt mình lên cái trỏ đồ xôi\"},{\"start\":35.02,\"end\":38.44,\"text\":\"Cái mê tính mà con thu âm mấy bài đầu, mẹ đổ bằng nhiều ngày đổ mồ hôi\"},{\"start\":38.44,\"end\":42.06,\"text\":\"Giờ con đã đi làm và con kiếm tiền về, mẹ chỉ cần ngồi đó mà sơi\"},{\"start\":42.06,\"end\":45.56,\"text\":\"Ôi những ngày xăm nguét, gió liu siêu dán mẹ gầy xo\"},{\"start\":45.56,\"end\":48.96,\"text\":\"Có khi mẹ ngất giữa đường, vì cả ngày chẳng có gì no\"},{\"start\":48.96,\"end\":52.66,\"text\":\"Mẹ không dám ăn, không dám mặc, không dám tiêu cũng chỉ vì lo\"},{\"start\":52.66,\"end\":56.24,\"text\":\"Giờ con đeo túi to te đi mua cho mẹ cái túi Dior\"},{\"start\":56.24,\"end\":58.2,\"text\":\"Tiếng nói đầu tiên là do ai dạy\"},{\"start\":58.2,\"end\":59.84,\"text\":\"Nét chữ đầu tiên là tay ai cầm\"},{\"start\":59.84,\"end\":61.78,\"text\":\"Sai lầm đầu tiên là nhờ ai sửa\"},{\"start\":61.78,\"end\":63.34,\"text\":\"Vất ngã đôi đời là được ai nâng\"},{\"start\":63.34,\"end\":66.76,\"text\":\"Bài hát hay nhất trần đời là lời mẹ ru giữa trưa nắng hè\"},{\"start\":66.76,\"end\":70.32,\"text\":\"Nắng ngày dài nhất trần đời là mẹ đi chợ xa chưa thấy về\"},{\"start\":70.32,\"end\":73.7,\"text\":\"Thức ăn ngon nhất trần đời là cơm bếp củi mẹ nấu son gan\"},{\"start\":73.7,\"end\":77.36,\"text\":\"Bước ra đời lòng này bà nọ trở về nhà là một đứa con ngoan\"},{\"start\":77.36,\"end\":81.78,\"text\":\"Bước ra đời lòng này bà nọ trở về nhà là một đứa con ngoan\"},{\"start\":81.78,\"end\":88,\"text\":\"Những đứa trẻ rồi sẽ đi xa nhà\"},{\"start\":88,\"end\":91.16,\"text\":\"Sẽ có rất nhiều hành trình qua trong đời\"},{\"start\":91.16,\"end\":95.12,\"text\":\"Mặc dù đời có lúc chẳng được như mong đợi\"},{\"start\":95.12,\"end\":109.06163,\"text\":\"R xa m nh hong c ai n chi Nh tr s ph xa nh S th em r nhi m ng cay chua M ch mu ch m ph t lo cho m\"},{\"start\":109.06163,\"end\":112.74164,\"text\":\"Để đấy mà cây là mẹ cho ăn đau\"},{\"start\":112.74164,\"end\":116.081635,\"text\":\"Mang tình về cho mẹ, mang tình về cho mẹ\"},{\"start\":116.081635,\"end\":119.64163,\"text\":\"Mang tình về cho mẹ, đừng mang ưu phình về cho mẹ\"},{\"start\":119.64163,\"end\":123.14163,\"text\":\"Mang tình về cho mẹ, mang tình về cho mẹ\"},{\"start\":123.14163,\"end\":126.761635,\"text\":\"Mang tiền về cho mẹ, đừng mang ưu phiền về cho mẹ\"},{\"start\":126.761635,\"end\":130.48163,\"text\":\"Con đã kiếm được tiền từ hình ảnh, kiếm được tiền từ âm thanh\"},{\"start\":130.48163,\"end\":133.92163,\"text\":\"Tất cả đều do cha sinh mẹ đẻ, dù không phải thế việc hay châm anh\"},{\"start\":133.92163,\"end\":137.56163,\"text\":\"Người hâm mộ đời con từ đồng khởi, xếp hàng dài đến hết đường ký con\"},{\"start\":137.56163,\"end\":141.08163,\"text\":\"Xin chào ký con, con rất quý họ và cũng hy vọng là họ được quý con\"},{\"start\":141.08163,\"end\":144.40164,\"text\":\"Tiền của con không có cần phải rửa, nó còn chỉ ám mùi mồ hôi\"},{\"start\":144.40164,\"end\":148.04163,\"text\":\"Mẹ yên tâm con là công dân tốt, đóng thuế đều và chỉ có đủ mà thôi\"},{\"start\":148.04163,\"end\":151.46164,\"text\":\"Nhà con phiêu ở nhiều phương diện, tiền con kiếm là tiền lương thiện\"},{\"start\":151.46164,\"end\":153.14163,\"text\":\"Đem sức lực ra làm phương tiện\"},{\"start\":153.14163,\"end\":154.90164,\"text\":\"Sống phải đẹp như là hoa hậu\"},{\"start\":154.90164,\"end\":156.70163,\"text\":\"Dù không cần thiết được tặng vương nguyện\"},{\"start\":156.70163,\"end\":158.90164,\"text\":\"Con trai giống mẹ nên là con hiền khô\"},{\"start\":158.90164,\"end\":160.60162,\"text\":\"La vào đời không làm mẹ thêm phiền lo\"},{\"start\":160.60162,\"end\":162.46164,\"text\":\"Bỏ qua giày biểu không cho cơm no\"},{\"start\":162.46164,\"end\":164.20163,\"text\":\"Mang về cho mẹ toàn thiền thơm thiền thò\"},{\"start\":164.20163,\"end\":165.68164,\"text\":\"Mẹ là mẹ của con\"},{\"start\":165.68164,\"end\":167.34164,\"text\":\"Con là của mọi người\"},{\"start\":167.34164,\"end\":169.12164,\"text\":\"Lên sân khấu làm mọi người vui\"},{\"start\":169.12164,\"end\":170.82162,\"text\":\"Về nhà làm cho mẹ cười\"},{\"start\":170.82162,\"end\":172.52164,\"text\":\"Vì thời gian nó thật là tàn khốc\"},{\"start\":172.52164,\"end\":174.30164,\"text\":\"Nên con thấy mình càng ngày càng non gian\"},{\"start\":174.30164,\"end\":176.04163,\"text\":\"Bao nhiêu tiền mua lại được một ngày\"},{\"start\":176.04163,\"end\":177.84164,\"text\":\"Mà con còn ngồi vừa lọt cái son gian\"},{\"start\":177.84164,\"end\":181.38164,\"text\":\"Muốn được nghe tiếng mẹ mắng mỗi ngày để con thấy mình còn chưa được khôn ngoan\"},{\"start\":181.38164,\"end\":185.42163,\"text\":\"Con trai mẹ chỉ là người phục vụ nhưng muốn đời đối xử với mẹ như một bà hoàng\"},{\"start\":185.42163,\"end\":187.54163,\"text\":\"Như một bà hoàng\"},{\"start\":187.54163,\"end\":190.30164,\"text\":\"Những đứa trẻ rồi sẽ đi xa nhà\"},{\"start\":190.30164,\"end\":193.50163,\"text\":\"Sẽ có rất nhiều hành trình qua trong đời\"},{\"start\":193.50163,\"end\":225.78326,\"text\":\"M d v l l nh video h d\"},{\"start\":225.80327,\"end\":229.14326,\"text\":\"Chạy xe ra đường đứng dấu gà bóng đau\"},{\"start\":229.14326,\"end\":232.68327,\"text\":\"Ra biến ngoài học điều hay mang về\"},{\"start\":232.68327,\"end\":235.98328,\"text\":\"Đừng mang bất dậy mày về đây tao đây\"},{\"start\":235.98328,\"end\":239.78326,\"text\":\"Tiền đã có kiếm rồi tâm sẽ chắc tiết kiệm\"},{\"start\":239.78326,\"end\":243.38327,\"text\":\"Hút thuốc nhiều mày lại như bà mày\"},{\"start\":243.38327,\"end\":258.98328,\"text\":\"À ơi, à ơi\"},{\"start\":273.38327,\"end\":307.2049,\"text\":\"H subscribe cho k Ghi M G kh b l nh n th m V tay m c c qu nhi v chai N con ti m c cho n ch\"},{\"start\":307.2049,\"end\":309.2049,\"text\":\"Chim thì có tổ, là con người thì chắc chắn phải có tổ\"},{\"start\":309.2049,\"end\":311.2049,\"text\":\"Muốn bay vào trời cao rộng, con nào không còn có lông\"},{\"start\":311.2049,\"end\":313.2049,\"text\":\"Mang tiền về cho mẹ hiền, để mờ mai thêm lưỡi cánh\"},{\"start\":313.2049,\"end\":315.2049,\"text\":\"Mang buồn về cho mẹ phiền, sẽ gặp ngay thì lừa đánh\"},{\"start\":315.2049,\"end\":317.2049,\"text\":\"Nhạc Rap đến từ Đông Nam Á\"},{\"start\":317.2049,\"end\":319.2049,\"text\":\"Mang lời mẹ bật cho bảy lúc đĩa nghe\"},{\"start\":319.2049,\"end\":321.2049,\"text\":\"Có bảy lúc địa nghi, vớn lời mẹ\"},{\"start\":321.2049,\"end\":324.2049,\"text\":\"Không gian trá, xác khẩu âm nhạc mang tiền về\"},{\"start\":324.2049,\"end\":327.2049,\"text\":\"Yeah, đưa tiền cho mẹ, mẹ là tiền về\"},{\"start\":327.2049,\"end\":329.2049,\"text\":\"Đừng làm điều xấu sẽ thành tiền lệ\"},{\"start\":329.2049,\"end\":331.2049,\"text\":\"Lao động hăng say hơn cả tiền đề\"},{\"start\":331.2049,\"end\":333.2049,\"text\":\"Cầm về tiền tốt đừng có cầm về tiền tệ\"},{\"start\":333.2049,\"end\":337.2049,\"text\":\"Yeah, đưa tiền cho mẹ, mẹ là tiền về\"},{\"start\":337.2049,\"end\":339.2049,\"text\":\"Đừng làm điều xấu sẽ thành tiền lệ\"},{\"start\":339.2049,\"end\":341.2049,\"text\":\"Lao động hăng say hơn cả tiền đề\"},{\"start\":341.2049,\"end\":343.2049,\"text\":\"Cầm về tiền tốt đừng có cầm về tiền tệ\"},{\"start\":343.2049,\"end\":346.2049,\"text\":\"Yeah, cũng may đã từng lênh đênh\"},{\"start\":346.2049,\"end\":348.2049,\"text\":\"Để con biết yếu thì đừng ra gió\"},{\"start\":348.2049,\"end\":378.1849,\"text\":\"Hãy subscribe cho kênh Ghiền Mì Gõ Để không bỏ lỡ những video hấp dẫn\"},{\"start\":378.2049,\"end\":398.2049,\"text\":\"Hãy subscribe cho kênh Ghiền Mì Gõ Để không bỏ lỡ những video hấp dẫn\"}]', 'processing', '2026-04-03 20:48:05', NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/video/upload/v1775274479/songs/audio/34/uxnwnohv0354yjfr62jp.mp3', 'songs/audio/34/uxnwnohv0354yjfr62jp', NULL, NULL, NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/image/upload/v1775272496/songs/partners/0_1_uogvpf.jpg', NULL, 10488542, 320, 'high', NULL, 0, 0, 1, 1, 17, 0, 0, 1, 0, 14, 'Đen Vâu', NULL, 'unverified', 'published', '2026-04-03 20:47:30', '2026-05-26 13:32:24', NULL),
(35, 'Nơi Này Có Anh', 'noi-nay-co-anh', 1, 2, 10, 260, NULL, 1, 2017, '[{\"start\":22.09,\"end\":25.07,\"text\":\"Em là ai từ đâu bước đến nơi đây\"},{\"start\":25.07,\"end\":28.02,\"text\":\"Dịu dàng chân phương\"},{\"start\":28.02,\"end\":31,\"text\":\"Em là ai tựa như ánh nắng ban mai\"},{\"start\":31,\"end\":33.02,\"text\":\"Ngọt ngào trong sương\"},{\"start\":33.02,\"end\":36.02,\"text\":\"Ngắm em thật lâu\"},{\"start\":36.02,\"end\":38.05,\"text\":\"Con tim anh yếu mềm\"},{\"start\":38.05,\"end\":40.04,\"text\":\"Đắm say từ phút đó\"},{\"start\":40.04,\"end\":43.07,\"text\":\"Từng giây trôi yêu thêm\"},{\"start\":43.07,\"end\":45.1,\"text\":\"Bao ngày qua bình minh đánh thức\"},{\"start\":45.1,\"end\":48.09,\"text\":\"Xua tan bộn bề nơi anh\"},{\"start\":48.09,\"end\":51.02,\"text\":\"Bao ngày qua niềm thương nỗi nhớ\"},{\"start\":51.02,\"end\":54.01,\"text\":\"Bay theo bầu trời trong xanh\"},{\"start\":54.01,\"end\":57.01,\"text\":\"Lướt đôi hàng mi\"},{\"start\":57.01,\"end\":59.04,\"text\":\"Mong manh anh thẫn thờ\"},{\"start\":59.04,\"end\":61.03,\"text\":\"Muốn hôn nhẹ mái tóc\"},{\"start\":61.03,\"end\":64.05,\"text\":\"Bờ môi em anh mơ\"},{\"start\":64.05,\"end\":67.02,\"text\":\"Cầm tay anh dựa vai anh\"},{\"start\":67.02,\"end\":69.05,\"text\":\"Kề bên anh nơi này có anh\"},{\"start\":69.05,\"end\":70.1,\"text\":\"Gió mang câu tình ca\"},{\"start\":70.1,\"end\":72.01,\"text\":\"Ngàn ánh sao vụt qua\"},{\"start\":72.01,\"end\":75.01,\"text\":\"Nhẹ ôm lấy em\"},{\"start\":75.01,\"end\":77.07,\"text\":\"Cầm tay anh dựa vai anh\"},{\"start\":77.07,\"end\":79.09,\"text\":\"Kề bên anh nơi này có anh\"},{\"start\":79.09,\"end\":81.04,\"text\":\"Khép đôi mi thật lâu\"},{\"start\":81.04,\"end\":82.05,\"text\":\"Nguyện mãi bên cạnh nhau\"},{\"start\":82.05,\"end\":85.02,\"text\":\"Yêu say đắm như ngày đầu\"},{\"start\":85.02,\"end\":88.04,\"text\":\"Mùa xuân đến bình yên\"},{\"start\":88.04,\"end\":90.04,\"text\":\"Cho anh những giấc mơ\"},{\"start\":90.04,\"end\":93.07,\"text\":\"Hạ lưu giữ ngày mưa\"},{\"start\":93.07,\"end\":95.06,\"text\":\"Ngọt ngào nên thơ\"},{\"start\":95.06,\"end\":98.08,\"text\":\"Mùa thu lá vàng rơi\"},{\"start\":98.08,\"end\":100.08,\"text\":\"Đông sang anh nhớ em\"},{\"start\":100.08,\"end\":104,\"text\":\"Tình yêu bé nhỏ xin\"},{\"start\":104,\"end\":117.03,\"text\":\"Dành tặng riêng em\"},{\"start\":117.03,\"end\":118.04,\"text\":\"Còn đó tiếng nói ấy\"},{\"start\":118.04,\"end\":120.01,\"text\":\"Bên tai vấn vương bao ngày qua\"},{\"start\":120.01,\"end\":120.09,\"text\":\"Ánh mắt bối rối\"},{\"start\":120.09,\"end\":122.08,\"text\":\"Nhớ thương bao ngày qua\"},{\"start\":122.08,\"end\":123.08,\"text\":\"Yêu em anh thẫn thờ\"},{\"start\":123.08,\"end\":125.01,\"text\":\"Con tim bâng khuâng đâu có ngờ\"},{\"start\":125.01,\"end\":126.05,\"text\":\"Chẳng bao giờ phải mong chờ\"},{\"start\":126.05,\"end\":127.08,\"text\":\"Đợi ai trong chiều hoàng hôn mờ\"},{\"start\":127.08,\"end\":129.01,\"text\":\"Đắm chìm hoà vào vần thơ\"},{\"start\":129.01,\"end\":130.04,\"text\":\"Ngắm nhìn khờ dại mộng mơ\"},{\"start\":130.04,\"end\":131.07,\"text\":\"Đừng bước vội vàng rồi làm ngơ\"},{\"start\":131.07,\"end\":133,\"text\":\"Lạnh lùng đó làm bộ dạng thờ ơ\"},{\"start\":133,\"end\":133.09,\"text\":\"Nhìn anh đi em nha\"},{\"start\":133.09,\"end\":135.01,\"text\":\"Hướng nụ cười cho riêng anh nha\"},{\"start\":135.01,\"end\":135.08,\"text\":\"Đơn giản là yêu\"},{\"start\":135.08,\"end\":137.06,\"text\":\"Con tim anh lên tiếng thôi\"},{\"start\":137.06,\"end\":140.03,\"text\":\"Cầm tay anh dựa vai anh\"},{\"start\":140.03,\"end\":142.06,\"text\":\"Kề bên anh nơi này có anh\"},{\"start\":142.06,\"end\":144,\"text\":\"Gió mang câu tình ca\"},{\"start\":144,\"end\":145.01,\"text\":\"Ngàn ánh sao vụt qua\"},{\"start\":145.01,\"end\":148,\"text\":\"Nhẹ ôm lấy em\"},{\"start\":148,\"end\":150.07,\"text\":\"Cầm tay anh dựa vai anh\"},{\"start\":150.07,\"end\":152.09,\"text\":\"Kề bên anh nơi này có anh\"},{\"start\":152.09,\"end\":154.05,\"text\":\"Khép đôi mi thật lâu\"},{\"start\":154.05,\"end\":155.06,\"text\":\"Nguyện mãi bên cạnh nhau\"},{\"start\":155.06,\"end\":158.03,\"text\":\"Yêu say đắm như ngày đầu\"},{\"start\":158.03,\"end\":161.04,\"text\":\"Mùa xuân đến bình yên\"},{\"start\":161.04,\"end\":163.04,\"text\":\"Cho anh những giấc mơ\"},{\"start\":163.04,\"end\":166.07,\"text\":\"Hạ lưu giữ ngày mưa\"},{\"start\":166.07,\"end\":168.08,\"text\":\"Ngọt ngào nên thơ\"},{\"start\":168.08,\"end\":171.09,\"text\":\"Mùa thu lá vàng rơi\"},{\"start\":171.09,\"end\":173.08,\"text\":\"Đông sang anh nhớ em\"},{\"start\":173.08,\"end\":177,\"text\":\"Tình yêu bé nhỏ xin\"},{\"start\":177,\"end\":182.06,\"text\":\"Dành tặng riêng em\"},{\"start\":182.06,\"end\":187.07,\"text\":\"Nhớ thương em\"},{\"start\":187.07,\"end\":192.03,\"text\":\"Nhớ thương em lắm\"},{\"start\":192.03,\"end\":194.07,\"text\":\"Phía sau chân trời\"},{\"start\":194.07,\"end\":196.08,\"text\":\"Có ai băng qua lối về\"},{\"start\":196.08,\"end\":200.02,\"text\":\"Cùng em đi trên đoạn đường dài\"},{\"start\":200.02,\"end\":202.09,\"text\":\"Cầm tay anh dựa vai anh\"},{\"start\":202.09,\"end\":205.01,\"text\":\"Kề bên anh nơi này có anh\"},{\"start\":205.01,\"end\":206.06,\"text\":\"Gió mang câu tình ca\"},{\"start\":206.06,\"end\":207.06,\"text\":\"Ngàn ánh sao vụt qua\"},{\"start\":207.06,\"end\":210.06,\"text\":\"Nhẹ ôm lấy em\"},{\"start\":210.06,\"end\":213.03,\"text\":\"Cầm tay anh dựa vai anh\"},{\"start\":213.03,\"end\":215.06,\"text\":\"Kề bên anh nơi này có anh\"},{\"start\":215.06,\"end\":217,\"text\":\"Khép đôi mi thật lâu\"},{\"start\":217,\"end\":218.01,\"text\":\"Nguyện mãi bên cạnh nhau\"},{\"start\":218.01,\"end\":220.09,\"text\":\"Yêu say đắm như ngày đầu\"},{\"start\":220.09,\"end\":224,\"text\":\"Mùa xuân đến bình yên\"},{\"start\":224,\"end\":225.1,\"text\":\"Cho anh những giấc mơ\"},{\"start\":225.1,\"end\":229.03,\"text\":\"Hạ lưu giữ ngày mưa\"},{\"start\":229.03,\"end\":231.03,\"text\":\"Ngọt ngào nên thơ\"},{\"start\":231.03,\"end\":234.03,\"text\":\"Mùa thu lá vàng rơi\"},{\"start\":234.03,\"end\":236.05,\"text\":\"Đông sang anh nhớ em\"},{\"start\":236.05,\"end\":239.07,\"text\":\"Tình yêu bé nhỏ xin\"},{\"start\":239.07,\"end\":0,\"text\":\"Dành tặng riêng em\"}]', 'completed', '2026-04-03 22:21:27', NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/video/upload/v1775279956/songs/audio/35/gksyq6uohwrgf1tof8hm.mp3', 'songs/audio/35/gksyq6uohwrgf1tof8hm', NULL, NULL, NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/image/upload/v1775277982/songs/partners/0_2_h5ntkq.jpg', NULL, 4163313, 320, 'high', NULL, 0, 0, 1, 1, 24, 1, 0, 0, 0, 15, 'Sơn Tùng M-TP', NULL, 'verified', 'published', '2026-04-03 22:19:04', '2026-05-26 13:32:24', NULL);
INSERT INTO `songs` (`id`, `title`, `slug`, `artist_id`, `album_id`, `genre_id`, `duration`, `track_number`, `disc_number`, `year`, `lyrics`, `lyrics_status`, `lyrics_processed_at`, `lyrics_error`, `lyrics_debug_info`, `song_url`, `audio_public_id`, `audio_processed_at`, `audio_processing_error`, `song_url_hq`, `song_url_lossless`, `cover_url`, `waveform_data`, `file_size`, `bitrate`, `quality`, `isrc`, `is_premium`, `is_explicit`, `is_featured`, `allow_download`, `total_plays`, `total_likes`, `total_comments`, `total_shares`, `total_downloads`, `partner_id`, `copyright_owner`, `license_type`, `copyright_status`, `status`, `created_at`, `updated_at`, `Descriptions`) VALUES
(36, 'Hồng Nhan', 'hong-nhan', 23, 3, 8, 228, NULL, 1, 2019, '[{\"start\":3.31,\"end\":7.92,\"text\":\"Ah-ah-ah-ah, ah-ah-ah\"},{\"start\":7.92,\"end\":11.06,\"text\":\"Hah-hah-hah, hah-hah-hah, hah-hah\"},{\"start\":11.06,\"end\":20.63,\"text\":\"Hah-hah-hah, hah-hah-hah-ah-ah-ah-ah, ah-ah\"},{\"start\":20.63,\"end\":21.95,\"text\":\"Hah-hah-hah\"},{\"start\":21.95,\"end\":24.06,\"text\":\"Và dòng thư tay em gửi trao anh ngày nào\"},{\"start\":24.06,\"end\":27.52,\"text\":\"Giờ còn lại hư vô, em gửi anh đây lời chào\"},{\"start\":27.52,\"end\":30.42,\"text\":\"Mà nhìn người đi vội, mình làm gì nên tội?\"},{\"start\":30.42,\"end\":33.05,\"text\":\"Tại sao lại cách xa, còn yêu như thế mà?\"},{\"start\":33.05,\"end\":35.92,\"text\":\"Để lệ hoen mi khi mùa xuân đang thầm thì\"},{\"start\":35.92,\"end\":38.86,\"text\":\"Nhìn người mà ra đi, anh chẳng níu kéo điều gì\"},{\"start\":38.86,\"end\":41.05,\"text\":\"Mà nghe sao đáng thương, nhìn nhau như cố hương\"},{\"start\":41.05,\"end\":44.79,\"text\":\"Tìm em ở bốn phương, vì say nên vấn vương\"},{\"start\":44.79,\"end\":47.75,\"text\":\"Em ơi vô tình, chuyện tình mình gặp không may\"},{\"start\":47.75,\"end\":50.08,\"text\":\"Em xa nơi này để giọt lệ ở bên đây\"},{\"start\":50.08,\"end\":52.99,\"text\":\"Bầu trời giờ hắt hiu, nhìn về nơi đó đây\"},{\"start\":52.99,\"end\":56.25,\"text\":\"Ngoài trời thì có mây, chỉ còn lại là đắng cay\"},{\"start\":56.25,\"end\":59.14,\"text\":\"Thương cha thương mẹ để đành lòng mà quay lưng\"},{\"start\":59.14,\"end\":61.54,\"text\":\"25 âm lịch, nhìn người cười mà rưng rưng\"},{\"start\":61.54,\"end\":64.14,\"text\":\"Kia kia là pháo hoa, rộn ràng người đến xem\"},{\"start\":64.14,\"end\":67.05,\"text\":\"Họ hàng mừng kết duyên, còn phần mình là hết duyên\"},{\"start\":67.05,\"end\":69.78,\"text\":\"Ah, anh như trẻ lạc còn tăm tối giữa rừng thông\"},{\"start\":69.78,\"end\":72.64,\"text\":\"Nơi cánh chim nhỏ lạc đàn tìm bến đỗ để ngừng trông\"},{\"start\":72.64,\"end\":75.21,\"text\":\"Anh là một con đom đóm mất ánh sáng nên xoay vòng\"},{\"start\":75.21,\"end\":78.57,\"text\":\"Gieo cho anh cả một mầm sống nhưng chẳng chịu khó vun trồng\"},{\"start\":78.57,\"end\":81.12,\"text\":\"Vì lúc ấy ta còn trẻ nên đời bạc và mưu sinh\"},{\"start\":81.12,\"end\":84.02,\"text\":\"Anh chưa học hết lớp mười, người ta gọi là lưu linh\"},{\"start\":84.02,\"end\":86.74,\"text\":\"Anh gắn bó với sông nước và cảnh vật này hữu tình\"},{\"start\":86.74,\"end\":90.16,\"text\":\"Còn người ta cho em áo lụa, hỏi tại sao chẳng phụ mình?\"},{\"start\":90.16,\"end\":94.47,\"text\":\"Tình yêu ơi, bình yên ơi, về đây đi\"},{\"start\":94.47,\"end\":98.39,\"text\":\"Để anh ôm, để gió cuốn đêm nay ai đưa về nhà\"},{\"start\":98.39,\"end\":101.08,\"text\":\"Để gió hát vang lên câu tình ca\"},{\"start\":101.08,\"end\":103.72,\"text\":\"Để lệ hoen mi khi mùa xuân đang thầm thì\"},{\"start\":103.72,\"end\":106.62,\"text\":\"Nhìn người mà ra đi, anh chẳng níu kéo điều gì\"},{\"start\":106.62,\"end\":109.28,\"text\":\"Mà nghe sao đáng thương, nhìn nhau như cố hương\"},{\"start\":109.28,\"end\":113.08,\"text\":\"Tìm em ở bốn phương, vì say nên vấn vương\"},{\"start\":113.08,\"end\":115.9,\"text\":\"Hết rồi, cuối cùng nắng thì cũng đã ngả vàng\"},{\"start\":115.9,\"end\":118.8,\"text\":\"Bên người nhân tình, em phải thương bản thân mình\"},{\"start\":118.8,\"end\":121.56,\"text\":\"Buồn lắm phải không? Giã tràng lấp biển Đông\"},{\"start\":121.56,\"end\":123.93,\"text\":\"Biết người cũng chả trông nên thôi câu chuyện thảy ra sông\"},{\"start\":123.93,\"end\":126.26,\"text\":\"Nhưng nếu anh say như thế này thì ai xem?\"},{\"start\":126.26,\"end\":129.12,\"text\":\"Người ta sẽ nói anh tệ với những thứ mà em đem\"},{\"start\":129.12,\"end\":131.85,\"text\":\"Vì thế nên anh phải sống như cái cách anh từng mơ\"},{\"start\":131.85,\"end\":134.76,\"text\":\"Dù cho bản thân này hóa đá nhưng trái tim chẳng ngừng thở\"},{\"start\":134.76,\"end\":137.78,\"text\":\"Và ba của anh là lính, má anh từng làm cán bộ\"},{\"start\":137.78,\"end\":140.58,\"text\":\"Anh không cho phép mình khóc, xe có hư cũng ráng độ\"},{\"start\":140.58,\"end\":143.06,\"text\":\"Đời người là kiếp lãng du, anh chẳng may làm lữ khách\"},{\"start\":143.06,\"end\":146.27,\"text\":\"Đi với nhau cả một hành trình, giờ có xa chẳng nỡ trách\"},{\"start\":146.27,\"end\":149.66,\"text\":\"Em ước là đời của em bình yên, chẳng buồn phiền như người ta\"},{\"start\":149.66,\"end\":152.12,\"text\":\"Mà giờ ra đây mà xem, có người đang lên kiệu hoa\"},{\"start\":152.12,\"end\":154.91,\"text\":\"Và rồi sẽ tốt nhưng mà ở nơi khác chẳng còn bận lòng như ở đây\"},{\"start\":154.91,\"end\":157.95,\"text\":\"Tình yêu của anh thì có đủ mùi vị nhưng mà chẳng ngọt như ở Tây\"},{\"start\":157.95,\"end\":160.34,\"text\":\"Na-na-na, na-na-na-na-na-na\"},{\"start\":160.34,\"end\":163.08,\"text\":\"Na-na-na-na-na-na-na-na-na-na-na\"},{\"start\":163.08,\"end\":165.75,\"text\":\"Na-na-na-na-na, na-na-na-na-na\"},{\"start\":165.75,\"end\":168.69,\"text\":\"Na-na-na-na-na-na-na-na-na-na\"},{\"start\":168.69,\"end\":171.52,\"text\":\"Để lệ hoen mi khi mùa xuân đang thầm thì\"},{\"start\":171.52,\"end\":174.28,\"text\":\"Nhìn người mà ra đi, anh chẳng níu kéo điều gì\"},{\"start\":174.28,\"end\":177.13,\"text\":\"Mà nghe sao đáng thương, nhìn nhau như cố hương\"},{\"start\":177.13,\"end\":179.98,\"text\":\"Tìm em ở bốn phương, vì say nên vấn vương\"},{\"start\":179.98,\"end\":0,\"text\":\"Ah-hah-hah-hah\"}]', 'completed', '2026-04-05 00:53:51', NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/video/upload/v1775294445/songs/audio/36/sebrufx5cpvoa6lcsfog.mp3', 'songs/audio/36/sebrufx5cpvoa6lcsfog', NULL, NULL, NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/image/upload/v1775294888/songs/partners/t%E1%BA%A3i_xu%E1%BB%91ng_3_ziqdfx.jpg', NULL, 3746819, 320, 'high', NULL, 0, 0, 1, 1, 23, 1, 0, 2, 0, 16, 'jack', NULL, 'unverified', 'published', '2026-04-04 02:20:36', '2026-05-26 13:32:24', NULL),
(37, 'Đom Đóm', 'om-om', 23, 3, 8, 327, NULL, 1, 2021, '[{\"start\":17.24,\"end\":21.49,\"text\":\"Hah-ah, ah-ah-ah, ah\"},{\"start\":21.49,\"end\":25.97,\"text\":\"Em đi mất rồi, còn anh ở lại\"},{\"start\":25.97,\"end\":35.37,\"text\":\"Hah-ah-hah-ah-ah, ah-ah-ah\"},{\"start\":35.37,\"end\":39.59,\"text\":\"Người giờ còn đây không, thuyền này liệu còn sang sông?\"},{\"start\":39.59,\"end\":43.57,\"text\":\"Buổi chiều dài mênh mông, lòng người giờ hòa hay đông?\"},{\"start\":43.57,\"end\":48.14,\"text\":\"Hồng mắt em cả bầu trời đỏ hoen\"},{\"start\":48.14,\"end\":52.72,\"text\":\"Ta như đứa trẻ ngây thơ, quên đi tháng ngày ngu ngơ\"},{\"start\":52.72,\"end\":57.16,\"text\":\"Người là ngàn mây bay, mình là giọt sầu chia tay\"},{\"start\":57.16,\"end\":61.06,\"text\":\"Người cạn bầu không say, còn mình giải bày trong đây\"},{\"start\":61.06,\"end\":69.6,\"text\":\"Này gió ơi, đừng vội vàng, lắng nghe được không?\"},{\"start\":69.6,\"end\":74.06,\"text\":\"Gió ơi, xin đừng lấy em đi\"},{\"start\":74.06,\"end\":78.45,\"text\":\"Hãy mang em về chốn xuân thì\"},{\"start\":78.45,\"end\":80.64,\"text\":\"Ngày nào còn bồi hồi tóc xanh\"},{\"start\":80.64,\"end\":82.64,\"text\":\"Ngày nào còn trò chuyện với anh\"},{\"start\":82.64,\"end\":85.03,\"text\":\"Em nói em thương anh mà\"},{\"start\":85.03,\"end\":87.23,\"text\":\"Nói em yêu anh mà\"},{\"start\":87.23,\"end\":91.46,\"text\":\"Cớ sao ta lại hoá chia xa?\"},{\"start\":91.46,\"end\":95.93,\"text\":\"Đoá phong lan lặng lẽ mơ màng\"},{\"start\":95.93,\"end\":98.05,\"text\":\"Nàng dịu dàng tựa đèn phố Vinh\"},{\"start\":98.05,\"end\":107.94,\"text\":\"Đẹp rạng ngời, chẳng cần cố xinh\"},{\"start\":107.94,\"end\":122.05,\"text\":\"Hạt ngọc rơi rắc trên mái nhà, sau luống cà, như thế là\"},{\"start\":122.05,\"end\":131.04,\"text\":\"Hah-hah-hah-hah-hah,  hah-ah\"},{\"start\":131.04,\"end\":135.46,\"text\":\"Xa nhau, xa nhau, thôi thì nỗi nhớ hà cớ gì người mang?\"},{\"start\":135.46,\"end\":139.05,\"text\":\"Bên nhau không lâu, như là tờ giấy người thấy này nghìn trang\"},{\"start\":139.05,\"end\":141.45,\"text\":\"Vậy hãy để màu nắng phiêu du, phiêu du trên đỉnh đầu\"},{\"start\":141.45,\"end\":144.13,\"text\":\"Và sẽ nói em nghe, em nghe câu chuyện này là\"},{\"start\":144.13,\"end\":146.41,\"text\":\"Cả bầu trời vàng, đỏ, tím, xanh xanh\"},{\"start\":146.41,\"end\":148.85,\"text\":\"Em luôn tồn tại ở trong tim anh\"},{\"start\":148.85,\"end\":153.19,\"text\":\"Thuở mới niên thời, tay nắm tay\"},{\"start\":153.19,\"end\":157.05,\"text\":\"Cành lá me vàng ôm đắm say\"},{\"start\":157.05,\"end\":165.63,\"text\":\"Nhẹ nhàng lá rơi, đọng lại vấn vương ven đường\"},{\"start\":165.63,\"end\":170,\"text\":\"Gió ơi, xin đừng lấy em đi\"},{\"start\":170,\"end\":174.47,\"text\":\"Hãy mang em về chốn xuân thì\"},{\"start\":174.47,\"end\":176.62,\"text\":\"Ngày nào còn bồi hồi tóc xanh\"},{\"start\":176.62,\"end\":178.54,\"text\":\"Ngày nào còn trò chuyện với anh\"},{\"start\":178.54,\"end\":181.02,\"text\":\"Em nói em thương anh mà\"},{\"start\":181.02,\"end\":183.16,\"text\":\"Nói em yêu anh mà\"},{\"start\":183.16,\"end\":187.47,\"text\":\"Cớ sao ta lại hoá chia xa?\"},{\"start\":187.47,\"end\":191.89,\"text\":\"Đoá phong lan lặng lẽ mơ màng\"},{\"start\":191.89,\"end\":194.11,\"text\":\"Nàng dịu dàng tựa đèn phố Vinh\"},{\"start\":194.11,\"end\":199.51,\"text\":\"Đẹp rạng ngời, chẳng cần cố xinh\"},{\"start\":199.51,\"end\":203.91,\"text\":\"Yêu em nhiều, lòng này nhói đau\"},{\"start\":203.91,\"end\":207.66,\"text\":\"Thương em nhiều, cạn tình biển sâu\"},{\"start\":207.66,\"end\":209.61,\"text\":\"Biển sâu anh hát\"},{\"start\":209.61,\"end\":211.8,\"text\":\"Nếu có ước muốn ngược thời gian\"},{\"start\":211.8,\"end\":217.04,\"text\":\"Nhắm mắt cố xoá dòng đời này, ái phong trần vỡ tan\"},{\"start\":217.04,\"end\":221.3,\"text\":\"Đành lòng sao em xé nát tâm can\"},{\"start\":221.3,\"end\":226.73,\"text\":\"Hoạ kì thư theo bóng trăng vàng\"},{\"start\":226.73,\"end\":231.11,\"text\":\"Giá như bây giờ, giá như em ở đây\"},{\"start\":231.11,\"end\":235.5,\"text\":\"(Giá như em ở đây)\"},{\"start\":235.5,\"end\":239.83,\"text\":\"Gió ơi, xin đừng lấy em đi\"},{\"start\":239.83,\"end\":244.31,\"text\":\"Hãy mang em về, về chốn xuân thì, ah-hah\"},{\"start\":244.31,\"end\":246.38,\"text\":\"(Ngày nào còn bồi hồi tóc xanh)\"},{\"start\":246.38,\"end\":246.63,\"text\":\"(Ngày nào còn trò chuyện với anh)\"},{\"start\":246.63,\"end\":248.34,\"text\":\"Hoh, oh-oh-oh, oh\"},{\"start\":248.34,\"end\":250.81,\"text\":\"(Em nói em thương anh mà)\"},{\"start\":250.81,\"end\":252.98,\"text\":\"No, no, no, no, no\"},{\"start\":252.98,\"end\":257.23,\"text\":\"Cớ sao ta lại hoá chia xa?\"},{\"start\":257.23,\"end\":261.64,\"text\":\"Đoá phong lan lặng lẽ mơ màng\"},{\"start\":261.64,\"end\":263.92,\"text\":\"Nàng dịu dàng tựa đèn phố Vinh\"},{\"start\":263.92,\"end\":273.09,\"text\":\"Đẹp rạng ngời, chẳng cần cố xinh\"},{\"start\":273.09,\"end\":277,\"text\":\"Là là la la lá la\"},{\"start\":277,\"end\":281.34,\"text\":\"La, lá la la là la\"},{\"start\":281.34,\"end\":285.43,\"text\":\"La, lá la la là la\"},{\"start\":285.43,\"end\":290.6,\"text\":\"La là la la lá la\"},{\"start\":290.6,\"end\":294.43,\"text\":\"Là là la la lá la\"},{\"start\":294.43,\"end\":298.81,\"text\":\"La, lá la la là la\"},{\"start\":298.81,\"end\":302.93,\"text\":\"La, lá la la là la\"},{\"start\":302.93,\"end\":0,\"text\":\"La là la la lá la\"}]', 'completed', '2026-04-04 03:06:06', NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/video/upload/v1775297045/songs/audio/37/kviowdakcuy3iwqcnhpu.mp3', 'songs/audio/37/kviowdakcuy3iwqcnhpu', NULL, NULL, NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/image/upload/v1775297003/songs/partners/0_3_jbgsve.jpg', NULL, 8914415, 320, 'high', NULL, 0, 0, 1, 1, 27, 2, 0, 11, 0, 16, 'Jack', NULL, 'unverified', 'published', '2026-04-04 03:03:49', '2026-05-26 13:32:24', NULL),
(38, 'Bạc Phận', 'bac-phan', 23, 3, 9, 249, NULL, 1, 2019, '[]', 'completed', '2026-04-16 03:20:32', NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/video/upload/v1776255488/songs/audio/38/n2c6eoymv1txrdc0uh6y.mp3', 'songs/audio/38/n2c6eoymv1txrdc0uh6y', NULL, NULL, NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/image/upload/v1776250851/songs/partners/1742666254013_300_frfoq5.jpg', NULL, 4227550, 320, 'high', NULL, 0, 0, 1, 1, 11, 2, 0, 1, 0, 16, 'Jack', NULL, 'unverified', 'published', '2026-04-15 04:58:15', '2026-05-26 13:32:24', NULL),
(39, 'NOLOVENOLIFE', 'nolovenolife', 26, 5, 9, 171, NULL, 1, 2024, '[{\"start\":0.1,\"end\":4,\"text\":\"Mình hãy cứ sống thế đi, ta cứ mãi ước mơ\"},{\"start\":4,\"end\":7.06,\"text\":\"Ta cứ luôn mong chờ điều tuyệt vời nhé em\"},{\"start\":7.06,\"end\":10.94,\"text\":\"Cầm tay nhau mãi bước đi, sẽ cứ thế mỉm cười\"},{\"start\":10.94,\"end\":15.8,\"text\":\"Ta sẽ quên đi bao nhiêu tình yêu tan vỡ như là giấc mơ\"},{\"start\":15.8,\"end\":19.66,\"text\":\"No love, no life, no love, no life\"},{\"start\":19.66,\"end\":22.7,\"text\":\"Anh chẳng còn muốn quay về nơi ấy\"},{\"start\":22.7,\"end\":25.59,\"text\":\"No love, no life, no love, no life\"},{\"start\":25.59,\"end\":26.53,\"text\":\"Hey, Kewtiie\"},{\"start\":26.53,\"end\":28.33,\"text\":\"Sẽ mãi thuộc về nơi đây với em\"},{\"start\":28.33,\"end\":31.32,\"text\":\"Em biết anh là một thằng rapper rót mật vào tai bằng dây thanh\"},{\"start\":31.32,\"end\":33.05,\"text\":\"Chỉ xuất hiện là họ đã say nhanh\"},{\"start\":33.05,\"end\":36.67,\"text\":\"Mang tiếng trap và trăm cái red flag là bởi vì luôn luôn có phụ nữ vây quanh\"},{\"start\":36.67,\"end\":39.1,\"text\":\"Có một ngàn lý do để phải ghen nhưng em không\"},{\"start\":39.1,\"end\":42.58,\"text\":\"Em up hình, biết chắc anh phải xem và đặc biệt phải khen sau mỗi lần xem xong\"},{\"start\":42.58,\"end\":45.86,\"text\":\"Anh luôn muốn cài cho em thêm cúc khi có thằng con trai nào đi qua\"},{\"start\":45.86,\"end\":49.52,\"text\":\"Vì em và anh luôn muốn chuyện mình nghiêm túc, không phải just a game như FIFA\"},{\"start\":49.52,\"end\":52.97,\"text\":\"Em làm cho mọi bài nhạc chia tay mà anh đã từng viết nó trở nên vô nghĩa\"},{\"start\":52.97,\"end\":57.61,\"text\":\"Hai bờ môi chạm nhau vào khuya nay, mình ăn cho thật bốc nên chẳng cần tô nĩa, yeah, ah\"},{\"start\":57.61,\"end\":60.78,\"text\":\"Em luôn tự tin, thu hút, điểm số luôn nằm ở top đầu\"},{\"start\":60.78,\"end\":64.39,\"text\":\"Lần đầu gặp thì anh đã nhìn thấu và cũng chẳng cần giấu là hai ta khớp màu\"},{\"start\":64.39,\"end\":68.28,\"text\":\"Em vẫn hay còn giận anh khi mà xem qua về những gì mà anh nói ở trên camera\"},{\"start\":68.28,\"end\":72.68,\"text\":\"Hứa là với em, anh có thể đảm bảo tất cả thứ có thể ghen đều trên camera\"},{\"start\":72.68,\"end\":75.59,\"text\":\"Bên nhau, ta còn không một giây do dự nào, ay\"},{\"start\":75.59,\"end\":78.74,\"text\":\"Bởi vì là, yeah, girl, em vẫn luôn làm cho anh tự hào, hah\"},{\"start\":78.74,\"end\":82.06,\"text\":\"Anh ghét nhất mỗi lần đi phỏng vấn, họ lại hỏi câu hỏi đó mà xem\"},{\"start\":82.06,\"end\":86.92,\"text\":\"Họ hỏi anh về hình mẫu lý tưởng nhưng không thể trả lời đó là em\"},{\"start\":86.92,\"end\":95.3,\"text\":\"Và đó là lý do mà anh hay trả lời là gu của anh là thông minh và tinh tế\"},{\"start\":95.3,\"end\":98.17,\"text\":\"Bởi vì à\"},{\"start\":98.17,\"end\":101.39,\"text\":\"Bởi vì em tinh tế và em thông minh, đặt niềm tin hết vào anh khi anh không tin\"},{\"start\":101.39,\"end\":104.85,\"text\":\"Và tặng cho em cả rừng hoa thật là lung linh, là vì em với đẹp luôn là cặp song sinh\"},{\"start\":104.85,\"end\":108.54,\"text\":\"Làm anh thốt lên là \\\"Damn\\\" như là KDOT, là lý do mà đàn ông ngoài kia hay khóc\"},{\"start\":108.54,\"end\":111.9,\"text\":\"Là lý do anh không sợ fan nữ unfan, và phải là nói mình độc thân như idol K-Pop\"},{\"start\":111.9,\"end\":113.09,\"text\":\"And it pays off\"},{\"start\":113.09,\"end\":116.47,\"text\":\"Và cuộc sống, sự nổi tiếng anh đã quen rồi, cũng không hay ra ngoài nên là I don\'t mind\"},{\"start\":116.47,\"end\":120,\"text\":\"Em thì rất ghét là phải tránh mấy nơi đông người, cố luôn phải che mặt dù ta không sai\"},{\"start\":120,\"end\":123.49,\"text\":\"Anh biết là em vẫn hay hình dung ngày đứng chung một khung hình và ta công khai\"},{\"start\":123.49,\"end\":125.43,\"text\":\"Vì mình luôn hiểu ý nhau, vì có chung chữ cái đầu, ngoài mình ra thì không ai\"},{\"start\":125.43,\"end\":129,\"text\":\"Mình hãy cứ sống thế đi, ta cứ mãi ước mơ\"},{\"start\":129,\"end\":132.31,\"text\":\"Ta cứ luôn mong chờ điều tuyệt vời nhé em\"},{\"start\":132.31,\"end\":135.98,\"text\":\"Cầm tay nhau mãi bước đi, sẽ cứ thế mỉm cười\"},{\"start\":135.98,\"end\":140.97,\"text\":\"Ta sẽ quên đi bao nhiêu tình yêu tan vỡ như là giấc mơ\"},{\"start\":140.97,\"end\":144.79,\"text\":\"No love, no life, no love, no life\"},{\"start\":144.79,\"end\":147.96,\"text\":\"Anh chẳng còn muốn quay về nơi ấy\"},{\"start\":147.96,\"end\":151.76,\"text\":\"No love, no life, no love, no life\"},{\"start\":151.76,\"end\":154.87,\"text\":\"Sẽ mãi thuộc về nơi đây với em\"},{\"start\":154.87,\"end\":158.94,\"text\":\"No love, no life, no love, no life\"},{\"start\":158.94,\"end\":161.92,\"text\":\"Anh chẳng còn muốn quay về nơi ấy\"},{\"start\":161.92,\"end\":165.74,\"text\":\"No love, no life, no love, no life\"},{\"start\":165.74,\"end\":0,\"text\":\"Sẽ mãi thuộc về nơi đây với em\"}]', 'completed', '2026-04-17 01:59:43', NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/video/upload/v1776415990/songs/audio/39/ir4fsu25ehcftrq3g8fu.mp3', 'songs/audio/39/ir4fsu25ehcftrq3g8fu', NULL, NULL, NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/image/upload/v1776415957/songs/partners/1697426279033_300_owjyw7.jpg', NULL, 2977414, 320, 'high', NULL, 0, 0, 1, 1, 10, 0, 0, 0, 0, 17, 'Hiếu Thứ 2', NULL, 'unverified', 'published', '2026-04-17 01:52:52', '2026-05-26 13:32:24', NULL),
(40, 'Ngáo Ngơ', 'ngao-ngo', 26, 5, 9, 252, NULL, 1, 2024, '[]', 'completed', '2026-05-11 07:49:33', NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/video/upload/v1776416262/songs/audio/40/mlbgywjp3asuth65oh4c.mp3', 'songs/audio/40/mlbgywjp3asuth65oh4c', NULL, NULL, NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/image/upload/v1776416181/songs/partners/1722607585053_300_dccyn1.jpg', NULL, 4282110, 320, 'high', NULL, 1, 0, 1, 1, 16, 1, 0, 0, 0, 17, 'Hiếu Thứ 2 , ANH TRAI \"SAY HI\" , Erik', NULL, 'unverified', 'published', '2026-04-17 01:57:34', '2026-05-26 13:32:24', NULL),
(42, '50 Năm Về Sau', '50-nam-ve-sau', 28, NULL, 11, 299, NULL, 1, 2026, '[]', 'completed', '2026-04-19 20:56:37', NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/video/upload/v1776492018/songs/audio/42/iofqhqkoct59wr4mv9cs.mp3', 'songs/audio/42/iofqhqkoct59wr4mv9cs', NULL, NULL, NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/image/upload/v1776491848/songs/partners/1765797169064_300_diegl2.png', NULL, 5027578, 320, 'high', NULL, 0, 0, 1, 1, 18, 0, 0, 0, 0, NULL, 'F47 ,  meChill ,  Đặng Thanh Tuyền', NULL, 'unverified', 'published', '2026-04-17 23:00:09', '2026-05-26 13:32:24', NULL),
(43, 'Thiệp Hồng Sai Tên', 'thiep-hong-sai-ten', 29, 9, 11, 293, NULL, 1, 2025, '[{\"start\":0,\"end\":29.98,\"text\":\"Giữ nguyên dấu tiếng Việt đủ. Giữ nguyên dấu tiếng Việt đủ.\"},{\"start\":30,\"end\":59.98,\"text\":\"Hãy subscribe cho kênh Ghiền Mì Gõ Để không bỏ lỡ những video hấp dẫn\"},{\"start\":60,\"end\":98.14897,\"text\":\"Anh hay em mu n sang d t v chu ph hoa b anh v kh b l nh video h d\"},{\"start\":98.168976,\"end\":128.14897,\"text\":\"Giữ nguyên dấu tiếng Việt đầy đủ.\"},{\"start\":128.16898,\"end\":171.31795,\"text\":\"H subscribe cho k Ghi M G kh b l nh video h d\"},{\"start\":171.33795,\"end\":201.31795,\"text\":\"Giữ nguyên dấu tiếng Việt đầy đủ.\"},{\"start\":201.33795,\"end\":244.48694,\"text\":\"H subscribe cho k Ghi M G kh b l nh video h d\"},{\"start\":244.50694,\"end\":274.48694,\"text\":\"Hãy subscribe cho kênh Ghiền Mì Gõ Để không bỏ lỡ những video hấp dẫn\"},{\"start\":274.50696,\"end\":276.86694,\"text\":\"Buông tay.\"}]', 'processing', '2026-04-21 07:06:38', NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/video/upload/v1776780389/songs/audio/43/ipqee0hnickrk2prbtmg.mp3', 'songs/audio/43/ipqee0hnickrk2prbtmg', NULL, NULL, NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/image/upload/v1776780363/songs/partners/1769672183561_300_yiyhru.jpg', NULL, 4925160, 320, 'high', NULL, 0, 0, 1, 1, 9, 0, 0, 0, 0, 21, 'Ca Sĩ Giấu Mặt', NULL, 'unverified', 'published', '2026-04-21 07:06:18', '2026-05-26 13:32:24', NULL),
(44, 'Cỏ Dại Và Hoa Dành Dành', 'co-dai-va-hoa-danh-danh', 29, 9, 11, 201, NULL, 1, 2026, '[{\"start\":0,\"end\":29.98,\"text\":\"Hãy subscribe cho kênh Ghiền Mì Gõ Để không bỏ lỡ những video hấp dẫn\"},{\"start\":30,\"end\":34.46,\"text\":\"Mà em không thể quên vâng bóng hình anh.\"},{\"start\":35.98,\"end\":41.72,\"text\":\"Ngày sau em nghĩ có lẽ em chẳng yêu một người nào nữa.\"},{\"start\":42.36,\"end\":46.18,\"text\":\"Nhưng nỗi cô đơn biết làm sao giờ.\"},{\"start\":47.06,\"end\":51.94,\"text\":\"Có dại khô dưới chân sao xứng với hoa danh danh đây.\"},{\"start\":52.96,\"end\":57.78,\"text\":\"Mùa hạ với mùa đông sao có thể bên nhau phải không.\"},{\"start\":57.78,\"end\":65.36,\"text\":\"Và khi anh rời đi, em trở thành một người là từng quên biết.\"},{\"start\":65.74,\"end\":69.98,\"text\":\"Em chúc cho anh được hạnh phúc mãi sau này.\"},{\"start\":70.48,\"end\":75.26,\"text\":\"Cò dại khô dưới chân sao xứng với hoa danh danh đây.\"},{\"start\":76.34,\"end\":81.16,\"text\":\"Chẳng đủ tốt để có thể níu giữ anh trong vòng tay.\"},{\"start\":81.16,\"end\":125.355515,\"text\":\"Gi nguy d ti Vi\"},{\"start\":125.37551,\"end\":155.35551,\"text\":\"Hãy subscribe cho kênh Ghiền Mì Gõ Để không bỏ lỡ những video hấp dẫn\"},{\"start\":155.37552,\"end\":185.35551,\"text\":\"Hãy subscribe cho kênh Ghiền Mì Gõ Để không bỏ lỡ những video hấp dẫn\"},{\"start\":185.37552,\"end\":200.5755,\"text\":\"Hãy subscribe cho kênh Ghiền Mì Gõ Để không bỏ lỡ những video hấp dẫn\"}]', 'processing', '2026-04-21 07:10:16', NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/video/upload/v1776780609/songs/audio/44/kgch3xewnyvt56ukm9h6.mp3', 'songs/audio/44/kgch3xewnyvt56ukm9h6', NULL, NULL, NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/image/upload/v1776780582/songs/partners/1772123876890_300_jnv4dr.jpg', NULL, 3454372, 320, 'high', NULL, 0, 0, 1, 1, 11, 0, 0, 0, 0, 21, 'Ca Sĩ Giấu Mặt', NULL, 'unverified', 'published', '2026-04-21 07:09:50', '2026-05-26 13:32:24', NULL),
(45, 'Xem Như Tôi Từng Cưới Được Cô Ấy (Ballad)', 'xem-nhu-toi-tung-cuoi-uoc-co-ay-ballad', 29, 9, 11, 213, NULL, 1, 2026, '[{\"start\":0,\"end\":23.72,\"text\":\"Cơn gió khe thổi nhanh hoa rơi, ngồi nơi đây nhớ một người.\"},{\"start\":23.72,\"end\":53.7,\"text\":\"Hãy subscribe cho kênh Ghiền Mì Gõ Để không bỏ lỡ những video hấp dẫn\"},{\"start\":53.72,\"end\":56.96,\"text\":\"Những lúc mù dậy thấy em dễ thương muôn phần.\"},{\"start\":57.24,\"end\":60.86,\"text\":\"Từng ngắm nhìn em cười hạnh phúc lao nước mắt em rơi.\"},{\"start\":61.24,\"end\":64.96,\"text\":\"Cũng coi là cuộc đời này đã cưới em được rồi.\"},{\"start\":65.28,\"end\":69,\"text\":\"Dù biết trước tháng ngày dài sẽ không còn em bên mình.\"},{\"start\":69.54,\"end\":73.18,\"text\":\"Trong cơn mơ chật nhận ra vẫn luôn khắc sâu bóng hình.\"},{\"start\":73.64,\"end\":76.96,\"text\":\"Thời gian trôi qua sao chúng ta cứ mãi lặng thính.\"},{\"start\":77.22,\"end\":80.7,\"text\":\"Yêu nhưng không nói ra thế là xa.\"},{\"start\":83.72,\"end\":131.5204,\"text\":\"C gi kh g n m ng ta ph chia xa B tay sao c n th ch mu bu nh l ch th H subscribe cho k Ghi M G kh b l nh video h d\"},{\"start\":131.5404,\"end\":161.5204,\"text\":\"Hãy subscribe cho kênh Ghiền Mì Gõ Để không bỏ lỡ những video hấp dẫn\"},{\"start\":161.5404,\"end\":191.52042,\"text\":\"Hãy subscribe cho kênh Ghiền Mì Gõ Để không bỏ lỡ những video hấp dẫn\"},{\"start\":191.5404,\"end\":212.84041,\"text\":\"Hãy subscribe cho kênh Ghiền Mì Gõ Để không bỏ lỡ những video hấp dẫn\"}]', 'processing', '2026-04-21 07:11:45', NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/video/upload/v1776780697/songs/audio/45/p19orszpmezi5myrbmhd.mp3', 'songs/audio/45/p19orszpmezi5myrbmhd', NULL, NULL, NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/image/upload/v1776780675/songs/partners/1768429086633_300_s56oqn.jpg', NULL, 3651656, 320, 'high', NULL, 0, 0, 1, 1, 13, 0, 0, 0, 0, 21, 'Ca Sĩ Giấu Mặt', NULL, 'unverified', 'published', '2026-04-21 07:11:26', '2026-05-26 13:32:24', NULL),
(46, 'Em Thua Cô Ta', 'em-thua-co-ta', 29, 9, 11, 272, NULL, 1, 2026, '[{\"start\":0,\"end\":29.32,\"text\":\"Em thấy anh bên cô ta\"},{\"start\":30,\"end\":35.32,\"text\":\"Rồi bỏ mặc em cùng những nỗi xót xa\"},{\"start\":35.32,\"end\":40.56,\"text\":\"Cô ấy có hoa, có quà\"},{\"start\":40.56,\"end\":47.2,\"text\":\"Trên lối em về có cô đơn lệ nhòa\"},{\"start\":47.2,\"end\":54.84,\"text\":\"Vội vàng lâu đi vết son trên vành môi\"},{\"start\":54.84,\"end\":77.901634,\"text\":\"Gi nguy d ti Vi Em v ch tin anh thay Qua nu chi m m t y C t h em m c ta c th anh\"},{\"start\":77.901634,\"end\":83.00163,\"text\":\"Bao lâu dựng say nay phải thua một người thứ ba.\"},{\"start\":83.82163,\"end\":89.04163,\"text\":\"Cô ấy như em vậy à, hy sinh cho anh tất cả.\"},{\"start\":89.04163,\"end\":119.02164,\"text\":\"Giữ nguyên dấu tiếng Việt đầy đủ.\"},{\"start\":119.04163,\"end\":161.14326,\"text\":\"H subscribe cho k Ghi M G kh b l nh video h d\"},{\"start\":161.16327,\"end\":191.14326,\"text\":\"Giữ nguyên dấu tiếng Việt đầy đủ.\"},{\"start\":191.16327,\"end\":229.2249,\"text\":\"H subscribe cho k Ghi M G kh b l nh video h d\"},{\"start\":229.2449,\"end\":259.2249,\"text\":\"Hãy subscribe cho kênh Ghiền Mì Gõ Để không bỏ lỡ những video hấp dẫn\"},{\"start\":259.2449,\"end\":272.1249,\"text\":\"Hạnh Phúc Máu\"}]', 'processing', '2026-04-21 07:12:41', NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/video/upload/v1776780754/songs/audio/46/oalkpdq8ab4ls3wxm3d1.mp3', 'songs/audio/46/oalkpdq8ab4ls3wxm3d1', NULL, NULL, NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/image/upload/v1776780738/songs/partners/1761556768331_300_uursxw.jpg', NULL, 4599554, 320, 'high', NULL, 0, 0, 1, 1, 18, 1, 0, 0, 0, 21, 'Ca Sĩ Giấu Mặt', NULL, 'unverified', 'published', '2026-04-21 07:12:26', '2026-05-26 13:32:24', NULL),
(47, 'Lập Đông', 'lap-ong', 29, 9, 11, 323, NULL, 1, 2026, '[{\"start\":0,\"end\":29.98,\"text\":\"Giữ nguyên dấu tiếng Việt đủ. Giữ nguyên dấu tiếng Việt đủ.\"},{\"start\":30,\"end\":59.98,\"text\":\"Hãy subscribe cho kênh Ghiền Mì Gõ Để không bỏ lỡ những video hấp dẫn\"},{\"start\":60,\"end\":63.64,\"text\":\"Những chân thành âm em\"},{\"start\":63.64,\"end\":67.36,\"text\":\"Nghiên trung vạn lý\"},{\"start\":67.36,\"end\":71,\"text\":\"Người đi có vui hay buồn\"},{\"start\":71.64,\"end\":74.76,\"text\":\"Lạnh lòng lạnh tâm\"},{\"start\":74.76,\"end\":105.71796,\"text\":\"L hay l n m T duy Tr ban qua t ba v H subscribe cho k Ghi M G kh b l nh video h d\"},{\"start\":105.73796,\"end\":135.71796,\"text\":\"Hãy subscribe cho kênh Ghiền Mì Gõ Để không bỏ lỡ những video hấp dẫn\"},{\"start\":135.73796,\"end\":186.45592,\"text\":\"H subscribe cho k Ghi M G kh b l nh video h d H subscribe cho k La La La School kh b l nh video h d\"},{\"start\":186.47592,\"end\":216.45592,\"text\":\"Hãy subscribe cho kênh Ghiền Mì Gõ Để không bỏ lỡ những video hấp dẫn\"},{\"start\":216.47592,\"end\":252.21388,\"text\":\"H subscribe cho k Ghi M G kh b l nh video h d H subscribe cho k Ghi M G kh b chung nh ng h Nh chung v l ng c vui hay bu\"},{\"start\":252.21388,\"end\":259.71387,\"text\":\"Lạnh lòng, lạnh tâm, lạnh đông hay lạnh nước mắt.\"},{\"start\":259.71387,\"end\":266.71387,\"text\":\"Tìm được duyên đi trời ban qua tam ba bần.\"},{\"start\":266.71387,\"end\":296.69388,\"text\":\"Hãy subscribe cho kênh Ghiền Mì Gõ Để không bỏ lỡ những video hấp dẫn\"},{\"start\":296.71387,\"end\":322.79388,\"text\":\"Hãy subscribe cho kênh Ghiền Mì Gõ Để không bỏ lỡ những video hấp dẫn\"}]', 'processing', '2026-04-21 07:14:58', NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/video/upload/v1776780890/songs/audio/47/nm0rvzxhmszhxgapdwwa.mp3', 'songs/audio/47/nm0rvzxhmszhxgapdwwa', NULL, NULL, NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/image/upload/v1776780870/songs/partners/1767868755398_300_wgul77.jpg', NULL, 5409544, 320, 'high', NULL, 0, 0, 1, 1, 16, 1, 0, 0, 0, 21, 'Ca Sĩ Giấu Mặt', NULL, 'unverified', 'published', '2026-04-21 07:14:41', '2026-05-26 13:32:24', NULL),
(48, 'Theo Bóng Ai Hững Hờ', 'theo-bong-ai-hung-ho', 30, 10, 4, 248, NULL, 1, 2025, '[{\"start\":0,\"end\":29.98,\"text\":\"Hãy subscribe cho kênh Ghiền Mì Gõ Để không bỏ lỡ những video hấp dẫn\"},{\"start\":30,\"end\":35.66,\"text\":\"Tựa em nhớ mong anh đến từng phút giây trôi qua vô tình.\"},{\"start\":38.16,\"end\":43.3,\"text\":\"Anh đang ở một nơi xa, em nhớ mong anh vô cùng.\"},{\"start\":44.22,\"end\":47.4,\"text\":\"Ước sao mình đột bên nhau đêm nay.\"},{\"start\":48.34,\"end\":51.3,\"text\":\"Giấc mơ chỉ là giấc mơ.\"},{\"start\":51.3,\"end\":73.08735,\"text\":\"H subscribe cho k Ghi M G kh b l nh video h d Em m v ng xa x ta s b nhau Kh c c xa kh c mong ch Em m ng b anh ta n v nhau\"},{\"start\":73.08735,\"end\":78.26735,\"text\":\"Bao điều, những vui buồn ta cùng trong tay nhau\"},{\"start\":78.26735,\"end\":82.36735,\"text\":\"Giấc mơ, chỉ là giấc mơ\"},{\"start\":82.36735,\"end\":112.34735,\"text\":\"Giữ nguyên dấu tiếng Việt đầy đủ.\"},{\"start\":112.36735,\"end\":137.0947,\"text\":\"H subscribe cho k Ghi M v theo b ai kia h h\"},{\"start\":138.7947,\"end\":146.77469,\"text\":\"Em mơ về ngày xa xăm ta sống bên nhau không còn cách xa không còn mong chờ\"},{\"start\":146.77469,\"end\":154.85469,\"text\":\"Em mơ được ngồi bên anh ta nói với nhau bao điều.\"},{\"start\":154.85469,\"end\":159.0347,\"text\":\"Những vui buồn ta cùng trong tay nhau.\"},{\"start\":159.4747,\"end\":162.85469,\"text\":\"Giấc mơ chỉ là giấc mơ.\"},{\"start\":164.4147,\"end\":169.0147,\"text\":\"Rồi anh cứ đi để ngồi đây em vẫn mong chờ.\"},{\"start\":171.1547,\"end\":175.99469,\"text\":\"Vẫn thầm mong anh yêu nơi xa sống vui bình yên.\"},{\"start\":176.77469,\"end\":211.12204,\"text\":\"H subscribe cho k Ghi M G kh b l nh video h d\"},{\"start\":211.14204,\"end\":241.12204,\"text\":\"Hãy subscribe cho kênh Ghiền Mì Gõ Để không bỏ lỡ những video hấp dẫn\"},{\"start\":241.14204,\"end\":247.98204,\"text\":\"Hãy subscribe cho kênh La La La School Để không bỏ lỡ những video hấp dẫn\"}]', 'processing', '2026-04-24 23:47:41', NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/video/upload/v1777099646/songs/audio/48/blmsywpighvlvjzphlzt.mp3', 'songs/audio/48/blmsywpighvlvjzphlzt', NULL, NULL, NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/image/upload/v1777099599/songs/partners/img0_frsdxo.jpg', NULL, 4530764, 320, 'high', NULL, 0, 0, 1, 1, 17, 1, 0, 0, 0, 22, 'Inspired by the original work • non-commercial.', NULL, 'unverified', 'published', '2026-04-24 23:47:14', '2026-05-26 13:32:24', NULL),
(49, 'Đắm Trong Tiếng Mưa Đang Rơi', 'am-trong-tieng-mua-ang-roi', 30, 10, 4, 247, NULL, 1, 2025, '[]', 'completed', '2026-04-24 23:52:46', NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/video/upload/v1777099774/songs/audio/49/izdz8bgbdkxntyehftpe.mp3', 'songs/audio/49/izdz8bgbdkxntyehftpe', NULL, NULL, NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/image/upload/v1777099745/songs/partners/0_4_dxrr7w.jpg', NULL, 4604195, 320, 'high', NULL, 0, 0, 1, 1, 25, 2, 0, 1, 0, 22, 'Inspired by the original work • non-commercial.', NULL, 'unverified', 'published', '2026-04-24 23:49:21', '2026-05-26 13:32:24', NULL),
(50, 'Thủy Triều', 'thuy-trieu', 28, NULL, 9, 186, NULL, 1, 2024, '[{\"start\":0,\"end\":29.98,\"text\":\"Hãy subscribe cho kênh Ghiền Mì Gõ Để không bỏ lỡ những video hấp dẫn\"},{\"start\":30,\"end\":59.98,\"text\":\"Hãy subscribe cho kênh Ghiền Mì Gõ Để không bỏ lỡ những video hấp dẫn\"},{\"start\":60,\"end\":64.48,\"text\":\"Nhớ em dù cho cần bên, anh lại càng yêu thêm.\"},{\"start\":80.6,\"end\":83,\"text\":\"Màu mắt môi em, anh chìm sâu.\"},{\"start\":83.2,\"end\":84.88,\"text\":\"Lắng nghe đêm khi ta chẳng nhau.\"},{\"start\":84.98,\"end\":86.92,\"text\":\"Vâng chẳng ghé thăm, thì chiều đêm.\"},{\"start\":86.92,\"end\":118.093475,\"text\":\"Hai ta nay kh qu H subscribe cho k Ghi M G kh b l nh video h d\"},{\"start\":118.11347,\"end\":148.09348,\"text\":\"Hãy subscribe cho kênh Ghiền Mì Gõ Để không bỏ lỡ những video hấp dẫn\"},{\"start\":148.11346,\"end\":178.09348,\"text\":\"Giữ nguyên dấu tiếng Việt đủ. Giữ nguyên dấu tiếng Việt đủ. Giữ nguyên dấu tiếng Việt đủ.\"},{\"start\":178.11346,\"end\":208.09348,\"text\":\"Hãy subscribe cho kênh La La La School Để không bỏ lỡ những video hấp dẫn\"}]', 'processing', '2026-04-26 02:45:52', NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/video/upload/v1777196745/songs/audio/50/ddzemxpftlj6cjurnqlz.mp3', 'songs/audio/50/ddzemxpftlj6cjurnqlz', NULL, NULL, NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/image/upload/v1777196723/songs/partners/0_5_yuskhv.jpg', NULL, 3756250, 320, 'high', NULL, 0, 0, 1, 1, 20, 0, 0, 0, 0, NULL, 'Quang Hùng MasterD', NULL, 'unverified', 'published', '2026-04-26 02:45:33', '2026-05-26 13:32:24', NULL),
(51, 'Thời Ngây Thơ Thiếu Nữ', 'thoi-ngay-tho-thieu-nu', 30, NULL, 4, 252, NULL, 1, 2026, '[{\"start\":0,\"end\":29.98,\"text\":\"Hãy subscribe cho kênh La La La School Để không bỏ lỡ những video hấp dẫn\"},{\"start\":30,\"end\":87.86,\"text\":\"H subscribe cho k Ghi M G kh b l nh video h d H subscribe cho k Ghi M G kh b l nh video h d\"},{\"start\":87.880005,\"end\":117.86,\"text\":\"Giữ nguyên dấu tiếng Việt đầy đủ. Giữ nguyên dấu tiếng Việt đầy đủ.\"},{\"start\":117.880005,\"end\":150.74,\"text\":\"H subscribe cho k Ghi M G kh b l nh video h d\"},{\"start\":150.76001,\"end\":180.74,\"text\":\"Hãy subscribe cho kênh Ghiền Mì Gõ Để không bỏ lỡ những video hấp dẫn\"},{\"start\":180.76001,\"end\":193.98,\"text\":\"H subscribe cho k Ghi M G kh b l nh video h d N m c u c t m l do S qu kh d qu h h t ta nh hoa tuy say trong tr khuya\"},{\"start\":193.98,\"end\":223.95999,\"text\":\"Hãy subscribe cho kênh Ghiền Mì Gõ Để không bỏ lỡ những video hấp dẫn\"},{\"start\":223.98,\"end\":253.95999,\"text\":\"Hãy subscribe cho kênh Ghiền Mì Gõ Để không bỏ lỡ những video hấp dẫn\"}]', 'processing', '2026-04-27 07:33:37', NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/video/upload/v1777300407/songs/audio/51/rjw48ssiepwukinohhej.mp3', 'songs/audio/51/rjw48ssiepwukinohhej', NULL, NULL, NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/image/upload/v1777300389/songs/partners/hq720_vhislc.webp', NULL, 10060918, 320, 'high', NULL, 0, 0, 1, 1, 14, 1, 0, 0, 0, 22, 'Inspired by the original work • non-commercial.', NULL, 'unverified', 'published', '2026-04-27 07:33:17', '2026-05-26 13:32:24', NULL),
(52, 'vì đã ướt lòng rồi', 'vi-a-uot-long-roi', 30, NULL, 4, 259, NULL, 1, 2026, '[{\"start\":0,\"end\":29.98,\"text\":\"Hãy subscribe cho kênh Ghiền Mì Gõ Để không bỏ lỡ những video hấp dẫn\"},{\"start\":30,\"end\":78.38939,\"text\":\"H subscribe cho k Ghi M G kh b l nh video h d H subscribe cho k Ghi M G kh b l nh video h d Ng gi v l r N ch ng khi ch h r\"},{\"start\":78.38939,\"end\":81.26939,\"text\":\"Thôi cho em xin quên đi cơn mê này\"},{\"start\":81.26939,\"end\":83.509384,\"text\":\"Tình yêu nào đau đớn như vậy\"},{\"start\":83.509384,\"end\":86.06939,\"text\":\"Bên nhau bao lâu anh cũng chẳng nhớ được\"},{\"start\":86.06939,\"end\":116.04939,\"text\":\"Hãy subscribe cho kênh Ghiền Mì Gõ Để không bỏ lỡ những video hấp dẫn\"},{\"start\":116.06939,\"end\":136.69878,\"text\":\"H subscribe cho k Ghi M G kh b l nh video h d Gi l t th nhau Ta xa l nhau t l n Hai ta ch bi l th n m m s c g b gi c ch c c may m\"},{\"start\":138.15878,\"end\":142.13878,\"text\":\"Nhớ ngày xưa em thường đừng chờ anh ở giữa phía trường.\"},{\"start\":143.03877,\"end\":147.21878,\"text\":\"Đón anh về tô ấm, phía sau hoa quang em vẫn ấm thầm.\"},{\"start\":147.21878,\"end\":153.21878,\"text\":\"Ta cùng hay nghe nhạc, em thường khen để mô anh hát.\"},{\"start\":154.65878,\"end\":184.63878,\"text\":\"Hãy subscribe cho kênh Ghiền Mì Gõ Để không bỏ lỡ những video hấp dẫn\"},{\"start\":184.65878,\"end\":219.46815,\"text\":\"H subscribe cho k Ghi M G kh b l nh video h d Gi nguy d ti Vi\"},{\"start\":219.48816,\"end\":249.46815,\"text\":\"Hãy subscribe cho kênh Ghiền Mì Gõ Để không bỏ lỡ những video hấp dẫn\"},{\"start\":249.48816,\"end\":259.12817,\"text\":\"Hãy subscribe cho kênh La La La School Để không bỏ lỡ những video hấp dẫn\"}]', 'processing', '2026-04-27 07:38:06', NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/video/upload/v1777300677/songs/audio/52/rornszgo2qirsns7bamf.mp3', 'songs/audio/52/rornszgo2qirsns7bamf', NULL, NULL, NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/image/upload/v1777300610/songs/partners/0_c2eahc.jpg', NULL, 4767252, 320, 'high', NULL, 0, 0, 1, 1, 13, 1, 0, 0, 0, 22, 'Inspired by the original work • non-commercial.', NULL, 'unverified', 'published', '2026-04-27 07:37:01', '2026-05-26 13:32:24', NULL),
(53, 'Vạn Sự Như Ý', 'van-su-nhu-y', 6, 11, 1, 246, NULL, 1, 2026, '[{\"start\":0,\"end\":29.98,\"text\":\"Hãy subscribe cho kênh Ghiền Mì Gõ Để không bỏ lỡ những video hấp dẫn\"},{\"start\":30,\"end\":44.84,\"text\":\"Hân hoan khắp nơi tiếng pháo hoa. Lại một năm cũ đi qua. Xuân đến đây gieo khúc ca. Vạn sự như ý quanh năm tươi cười. Cầu mong chúc cho muôn người. Dù cách xa cuối năm lại về nhà.\"},{\"start\":44.84,\"end\":86.42653,\"text\":\"H subscribe cho k Ghi M G kh b l nh video h d\"},{\"start\":86.44653,\"end\":116.42653,\"text\":\"Hãy subscribe cho kênh Ghiền Mì Gõ Để không bỏ lỡ những video hấp dẫn\"},{\"start\":116.44653,\"end\":147.87306,\"text\":\"H subscribe cho k Ghi M G kh b l nh video h d\"},{\"start\":147.89307,\"end\":177.87306,\"text\":\"Hãy subscribe cho kênh Ghiền Mì Gõ Để không bỏ lỡ những video hấp dẫn\"},{\"start\":177.89307,\"end\":209.31958,\"text\":\"T t t l c t v H subscribe cho k Ghi M G kh b l nh video h d\"},{\"start\":209.33958,\"end\":213.17958,\"text\":\"Hát câu tâm tình, nắng mịn cười lung linh.\"},{\"start\":213.47958,\"end\":215.87958,\"text\":\"Vạn sự như ý môi cười đẹp xinh.\"},{\"start\":239.33958,\"end\":269.31958,\"text\":\"Hãy subscribe cho kênh La La La School Để không bỏ lỡ những video hấp dẫn\"}]', 'processing', '2026-04-30 04:46:40', NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/video/upload/v1777549592/songs/audio/53/je8jfesv1edtwes9beip.mp3', 'songs/audio/53/je8jfesv1edtwes9beip', NULL, NULL, NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/image/upload/v1777549525/songs/partners/1767850205549_300_rxlnlx.jpg', NULL, 4174893, 320, 'high', NULL, 0, 0, 1, 1, 7, 0, 0, 0, 0, 23, 'Trúc Nhân', NULL, 'unverified', 'published', '2026-04-30 04:46:19', '2026-05-26 13:32:24', NULL),
(54, 'Lớn Rồi Còn Khóc Nhè', 'lon-roi-con-khoc-nhe', 6, 11, 1, 211, NULL, 1, 2026, '[{\"start\":0,\"end\":29.98,\"text\":\"Hãy subscribe cho kênh Ghiền Mì Gõ Để không bỏ lỡ những video hấp dẫn\"},{\"start\":30,\"end\":59.98,\"text\":\"Hãy subscribe cho kênh Ghiền Mì Gõ Để không bỏ lỡ những video hấp dẫn\"},{\"start\":60,\"end\":89.98,\"text\":\"Hãy subscribe cho kênh Ghiền Mì Gõ Để không bỏ lỡ những video hấp dẫn\"},{\"start\":90,\"end\":130.54082,\"text\":\"H subscribe cho k Ghi M G kh b l nh video h d\"},{\"start\":130.56082,\"end\":160.54082,\"text\":\"Hãy subscribe cho kênh Ghiền Mì Gõ Để không bỏ lỡ những video hấp dẫn\"},{\"start\":160.56082,\"end\":190.54082,\"text\":\"Hãy subscribe cho kênh Ghiền Mì Gõ Để không bỏ lỡ những video hấp dẫn\"},{\"start\":190.56082,\"end\":220.54082,\"text\":\"Giữ nguyên dấu tiếng Việt đầy đủ.\"}]', 'processing', '2026-04-30 04:48:10', NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/video/upload/v1777549683/songs/audio/54/wxii40d2ifs9wzspsynl.mp3', 'songs/audio/54/wxii40d2ifs9wzspsynl', NULL, NULL, NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/image/upload/v1777549666/songs/partners/1556164728928_300_ljzzfy.jpg', NULL, 3464953, 320, 'high', NULL, 0, 0, 1, 1, 6, 1, 0, 0, 0, 23, 'Trúc Nhân', NULL, 'unverified', 'published', '2026-04-30 04:47:54', '2026-05-26 13:32:24', NULL),
(55, 'Đôi Bờ (XHTDRLX2)', 'oi-bo-xhtdrlx2', 6, 11, 2, 388, NULL, 1, 2026, '[{\"start\":0,\"end\":29.98,\"text\":\"Giữ nguyên dấu tiếng Việt đủ. Giữ nguyên dấu tiếng Việt đủ.\"},{\"start\":29.98,\"end\":35.1,\"text\":\"Đêm qua anh mơ thấy em yêu đến trong mộng buồn.\"},{\"start\":37.44,\"end\":42.04,\"text\":\"Dĩ vang thoang tới đốt cháy trái tim thương em.\"},{\"start\":44.4,\"end\":51.32,\"text\":\"Khóe mắt đẫm ướt mây tóc xóa tới trăm ngàn vai cho anh thương em ngàn đời.\"},{\"start\":52.5,\"end\":57.04,\"text\":\"Anh kêu tên em qua vùng biển sáng chân trời.\"},{\"start\":57.04,\"end\":87.02,\"text\":\"Giữ nguyên dấu tiếng Việt đầy đủ.\"},{\"start\":87.04,\"end\":122.00531,\"text\":\"Gi nguy d ti Vi H subscribe cho k Ghi M G kh b l nh video h d\"},{\"start\":122.02531,\"end\":152.00531,\"text\":\"Hãy subscribe cho kênh Ghiền Mì Gõ Để không bỏ lỡ những video hấp dẫn\"},{\"start\":152.0253,\"end\":182.00531,\"text\":\"Giữ nguyên dấu tiếng Việt đầy đủ.\"},{\"start\":182.00531,\"end\":199.85062,\"text\":\"H subscribe cho k Ghi M G kh b l nh video h d Tuy m say gi t cu l thu b vay Ch m tan g vang b em tho\"},{\"start\":199.85062,\"end\":202.69061,\"text\":\"Chút hiên nghe, mưa rơi u hoài\"},{\"start\":202.69061,\"end\":206.23062,\"text\":\"Buồn thương thân, lang thang quê người\"},{\"start\":206.23062,\"end\":209.17061,\"text\":\"Chọn kiếp lâu đầy\"},{\"start\":209.17061,\"end\":215.93062,\"text\":\"Trong đêm đơn côi, gió mưa nhớ em vời vời\"},{\"start\":215.93062,\"end\":245.91061,\"text\":\"Giữ nguyên dấu tiếng Việt đầy đủ.\"},{\"start\":245.93062,\"end\":252.85062,\"text\":\"Còn yêu anh như khi chúng ta mới yêu thương nhau.\"},{\"start\":254.17062,\"end\":260.9106,\"text\":\"Ngại đôi khi bão táp đã khiến núi sông cách ngăn cho em thay lòng.\"},{\"start\":262.4106,\"end\":267.6506,\"text\":\"Tình ly tan cho ước thề mong cũ phai tàn.\"},{\"start\":267.6506,\"end\":277.6506,\"text\":\"Hỡi non cao ơi sông sâu đời bể dấu.\"},{\"start\":277.6506,\"end\":285.6506,\"text\":\"Kể từ đây mãi mãi mất nhau mãi mang thương đau.\"},{\"start\":285.6506,\"end\":300.07593,\"text\":\"L anh k tan theo gi d gi reo vang bao la xa m cho ta duy ng b t m mong ch\"},{\"start\":305.07593,\"end\":311.07593,\"text\":\"Hỡi non cao ơi sông sâu, đời bể dấu.\"},{\"start\":311.07593,\"end\":341.05594,\"text\":\"Hãy subscribe cho kênh Ghiền Mì Gõ Để không bỏ lỡ những video hấp dẫn\"},{\"start\":341.07593,\"end\":371.05594,\"text\":\"Giữ nguyên dấu tiếng Việt đầy đủ.\"},{\"start\":371.07593,\"end\":379.63593,\"text\":\"Đêm qua anh mơ thấy em yêu đến trong mộng buồn.\"}]', 'processing', '2026-04-30 04:49:40', NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/video/upload/v1777549771/songs/audio/55/dsfss06najtemh1qbpyt.mp3', 'songs/audio/55/dsfss06najtemh1qbpyt', NULL, NULL, NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/image/upload/v1777549739/songs/partners/1667894608481_300_buwc6y.jpg', NULL, 6451928, 320, 'high', NULL, 0, 0, 1, 1, 10, 1, 0, 0, 0, 23, 'Trúc Nhân', NULL, 'unverified', 'published', '2026-04-30 04:49:05', '2026-05-26 13:32:24', NULL),
(56, 'Bốn Chữ Lắm', 'bon-chu-lam', 6, 11, 9, 261, NULL, 1, 2026, '[{\"start\":0,\"end\":29.98,\"text\":\"Hãy subscribe cho kênh Ghiền Mì Gõ Để không bỏ lỡ những video hấp dẫn\"},{\"start\":30,\"end\":59.98,\"text\":\"Hãy subscribe cho kênh Ghiền Mì Gõ Để không bỏ lỡ những video hấp dẫn\"},{\"start\":60,\"end\":71.328575,\"text\":\"Gi nguy d ti Vi M m anh n v thao th Y l th l m xa l l Ai bu ai bu em bu v ai\"},{\"start\":71.88857,\"end\":75.968575,\"text\":\"Yêu lắm, thương lắm mà xa lắm, đau lắm.\"},{\"start\":76.30857,\"end\":79.94857,\"text\":\"Ai chờ, mong chờ, em chờ đợi anh.\"},{\"start\":90.18857,\"end\":120.16857,\"text\":\"Giữ nguyên dấu tiếng Việt đầy đủ.\"},{\"start\":120.18857,\"end\":138.81714,\"text\":\"H subscribe cho k Ghi M G kh b l nh video h d Th l th sao ch mong ng mai ai bi ra sao Ng c xa t ph tr n tr m t nhau Ch m ng y th l l n cho nhau m c\"},{\"start\":139.07715,\"end\":143.21715,\"text\":\"Để từng ngày ta thôi còn trong ngóng, trái tim thôi ngủ yên.\"},{\"start\":143.41714,\"end\":147.57715,\"text\":\"Để từng đêm ta say trên miên, để đêm nành trôi.\"},{\"start\":147.77715,\"end\":150.13715,\"text\":\"Một mình anh nơi đây vẫn thao thức.\"},{\"start\":150.49715,\"end\":154.51715,\"text\":\"Yêu lắm, thương lắm, xa lắm, đau lắm.\"},{\"start\":154.51715,\"end\":158.73715,\"text\":\"Ai buồn, ai buồn, em buồn vì ai?\"},{\"start\":159.11714,\"end\":163.25714,\"text\":\"Yêu lắm, thương lắm, xa lắm, chơi đau lắm.\"},{\"start\":163.59714,\"end\":167.17714,\"text\":\"Ai chờ, mong chờ, em chờ đợi anh.\"},{\"start\":184.51715,\"end\":220.54572,\"text\":\"H subscribe cho k Ghi M G kh b l nh video h d\"},{\"start\":220.56572,\"end\":250.54572,\"text\":\"Giữ nguyên dấu tiếng Việt đầy đủ. Giữ nguyên dấu tiếng Việt đầy đủ.\"},{\"start\":250.56572,\"end\":280.54572,\"text\":\"Hãy subscribe cho kênh Ghiền Mì Gõ Để không bỏ lỡ những video hấp dẫn\"}]', 'processing', '2026-04-30 04:50:15', NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/video/upload/v1777549808/songs/audio/56/v8fthsw4lfv3ioxcxgpm.mp3', 'songs/audio/56/v8fthsw4lfv3ioxcxgpm', NULL, NULL, NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/image/upload/v1777549786/songs/partners/1417502922407_300_dswwwy.jpg', NULL, 4172860, 320, 'high', NULL, 0, 0, 1, 1, 9, 1, 0, 0, 0, 23, 'Trúc Nhân', NULL, 'unverified', 'published', '2026-04-30 04:49:57', '2026-05-26 13:32:24', NULL),
(57, 'Made In Vietnam', 'made-in-vietnam', 6, 11, 9, 281, NULL, 1, 2026, '[{\"start\":0,\"end\":29.98,\"text\":\"Giữ nguyên dấu tiếng Việt đầy đủ. Giữ nguyên dấu tiếng Việt đầy đủ.\"},{\"start\":30,\"end\":59.98,\"text\":\"Giữ nguyên dấu tiếng Việt đầy đủ.\"},{\"start\":60,\"end\":95.26898,\"text\":\"H subscribe cho k Ghi M G kh b l nh video h d\"},{\"start\":95.28898,\"end\":125.26898,\"text\":\"Hãy subscribe cho kênh Ghiền Mì Gõ Để không bỏ lỡ những video hấp dẫn\"},{\"start\":125.28898,\"end\":165.55795,\"text\":\"H subscribe cho k Ghi M G kh b l nh video h d\"},{\"start\":165.57796,\"end\":170.91795,\"text\":\"Từ nơi xa, biển dòng bao la, còn rèn vắng năm quốc sản hạ.\"},{\"start\":171.29796,\"end\":176.45796,\"text\":\"Vì trong tôi, từ hào vọng tôi, nhìn tựa tông mây trên khắp Việt Nam.\"},{\"start\":179.09796,\"end\":184.43796,\"text\":\"Ở nơi này bao năm vẫn thế, những con người trong tay giữ lấy.\"},{\"start\":184.79796,\"end\":188.69795,\"text\":\"Vật lưu truyền ngàn năm gấp hoa huyết bếp đến Việt Nam.\"},{\"start\":188.69795,\"end\":195.55795,\"text\":\"Những con người thân thương nhỏ bé vẫn ngoan cường trên đời Việt Nam.\"},{\"start\":195.81796,\"end\":199.99796,\"text\":\"Bốn phương trời tự hào đế chúng tôi người Việt Nam.\"},{\"start\":205.86694,\"end\":235.84694,\"text\":\"Hãy subscribe cho kênh Ghiền Mì Gõ Để không bỏ lỡ những video hấp dẫn\"},{\"start\":235.86694,\"end\":265.84695,\"text\":\"Hãy subscribe cho kênh Ghiền Mì Gõ Để không bỏ lỡ những video hấp dẫn\"},{\"start\":265.86694,\"end\":279.42694,\"text\":\"Hạnh Phúc Máu\"}]', 'processing', '2026-04-30 04:51:35', NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/video/upload/v1777549886/songs/audio/57/jtevzjnywk5o8ojs1nnj.mp3', 'songs/audio/57/jtevzjnywk5o8ojs1nnj', NULL, NULL, NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/image/upload/v1777549848/songs/partners/1755576464803_300_t28ajj.jpg', NULL, 4740872, 320, 'high', NULL, 0, 0, 1, 1, 7, 1, 0, 0, 0, 23, 'DTAP , Thanh Hoa (NSND) , Trúc Nhân và nhiều hơn', NULL, 'unverified', 'published', '2026-04-30 04:50:54', '2026-05-26 13:32:24', NULL);
INSERT INTO `songs` (`id`, `title`, `slug`, `artist_id`, `album_id`, `genre_id`, `duration`, `track_number`, `disc_number`, `year`, `lyrics`, `lyrics_status`, `lyrics_processed_at`, `lyrics_error`, `lyrics_debug_info`, `song_url`, `audio_public_id`, `audio_processed_at`, `audio_processing_error`, `song_url_hq`, `song_url_lossless`, `cover_url`, `waveform_data`, `file_size`, `bitrate`, `quality`, `isrc`, `is_premium`, `is_explicit`, `is_featured`, `allow_download`, `total_plays`, `total_likes`, `total_comments`, `total_shares`, `total_downloads`, `partner_id`, `copyright_owner`, `license_type`, `copyright_status`, `status`, `created_at`, `updated_at`, `Descriptions`) VALUES
(58, 'Máu Đỏ Da Vàng', 'mau-o-da-vang', 6, 11, 9, 245, NULL, 1, 2026, '[{\"start\":0,\"end\":29.98,\"text\":\"Hãy subscribe cho kênh La La La School Để không bỏ lỡ những video hấp dẫn\"},{\"start\":30,\"end\":86.324005,\"text\":\"H subscribe cho k Ghi M G kh b l nh video h d H subscribe cho k Ghi M G kh b l nh video h d\"},{\"start\":86.344,\"end\":116.324005,\"text\":\"Hãy subscribe cho kênh Ghiền Mì Gõ Để không bỏ lỡ những video hấp dẫn\"},{\"start\":116.344,\"end\":134.688,\"text\":\"H subscribe cho k Ghi M G kh b l nh video h d Hello I from Vietnam Sinh ra m trong tim ta trong t h th m xu Con ng qua gian kh v lu ki c c n hoa\"},{\"start\":134.688,\"end\":138.688,\"text\":\"Ta luôn đi bên nhau, từ sông sâu bao nhiêu cũng đường đầu.\"},{\"start\":138.688,\"end\":141.688,\"text\":\"Đi qua bao nhiêu chông gai, ngày mai đây thêm thời gian cùng nhau.\"},{\"start\":141.688,\"end\":145.688,\"text\":\"Ta luôn đi bên nhau, từ sông sâu bao nhiêu cũng đường đầu.\"},{\"start\":145.688,\"end\":175.668,\"text\":\"Hãy subscribe cho kênh Ghiền Mì Gõ Để không bỏ lỡ những video hấp dẫn\"},{\"start\":175.688,\"end\":209.012,\"text\":\"H subscribe cho k Ghi M G kh b l nh video h d\"},{\"start\":209.032,\"end\":216.032,\"text\":\"Nơi đây có những con người Việt Nam rơi dùm bao la.\"},{\"start\":216.032,\"end\":219.032,\"text\":\"Những mắt của họ đã mang những lòng sạch ra.\"},{\"start\":219.032,\"end\":224.032,\"text\":\"Vì bao nhiêu khó khăn cũng đã vượt qua.\"},{\"start\":225.032,\"end\":230.032,\"text\":\"Đây chúng tôi, con người Việt Nam.\"},{\"start\":239.032,\"end\":269.012,\"text\":\"Hãy subscribe cho kênh La La La School Để không bỏ lỡ những video hấp dẫn\"}]', 'processing', '2026-04-30 04:52:47', NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/video/upload/v1777549959/songs/audio/58/fihk2s2c3ezwqplwauga.mp3', 'songs/audio/58/fihk2s2c3ezwqplwauga', NULL, NULL, NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/image/upload/v1777549932/songs/partners/1637812359691_300_nts6ax.jpg', NULL, 4063537, 320, 'high', NULL, 0, 0, 1, 1, 10, 2, 0, 0, 2, 23, 'Trúc Nhân', NULL, 'unverified', 'published', '2026-04-30 04:52:22', '2026-05-26 13:32:24', NULL),
(59, 'LIÊN VÀ ĐẠT', 'lien-va-at', 31, NULL, 9, 216, NULL, 1, 2026, '[{\"start\":0,\"end\":29.98,\"text\":\"Giữ nguyên dấu tiếng Việt đầy đủ. Giữ nguyên dấu tiếng Việt đầy đủ.\"},{\"start\":30,\"end\":32,\"text\":\"Liên Phạt Đạt\"},{\"start\":32,\"end\":34,\"text\":\"Họ giống như Lan Phạt Điệp\"},{\"start\":34,\"end\":36,\"text\":\"Ư biết sinh ra là họ dành cho nhau\"},{\"start\":36,\"end\":38,\"text\":\"Nhưng mà là mối duyên chời phạt\"},{\"start\":38,\"end\":40,\"text\":\"Chuỗi ngày bình yên nên đi xuyên đời đạt\"},{\"start\":40,\"end\":42,\"text\":\"Sau cái lời đạt biên hôm đó liền rời rạc\"},{\"start\":42,\"end\":44,\"text\":\"Hôm đó trạt tối đạt rối đạt khóc\"},{\"start\":44,\"end\":46,\"text\":\"Rồi đạt nói câu cái khác có thai phải đạt rồi\"},{\"start\":46,\"end\":48,\"text\":\"5 năm kết thúc trong vụn vỡ\"},{\"start\":48,\"end\":50,\"text\":\"Với bao nhiêu dự định nơi chỉ còn trong thâm tâm\"},{\"start\":50,\"end\":52,\"text\":\"Xây một ngôi nhà nhỏ làm đám cưới thật to\"},{\"start\":52,\"end\":54,\"text\":\"Cách mời quảng trăm mâm\"},{\"start\":54,\"end\":56,\"text\":\"Tất thảy lời hứa nó còn đang gian dở\"},{\"start\":56,\"end\":58,\"text\":\"Liên chọn bỏ nơi mình đang ở\"},{\"start\":58,\"end\":87.98,\"text\":\"Hãy subscribe cho kênh Ghiền Mì Gõ Để không bỏ lỡ những video hấp dẫn\"},{\"start\":88,\"end\":132.905,\"text\":\"H subscribe cho k Ghi M G kh b l nh video h d\"},{\"start\":132.925,\"end\":138.985,\"text\":\"Em đã đợi 5 năm rồi đó đẹp.\"},{\"start\":139.985,\"end\":142.845,\"text\":\"Em đã mơ cái trăm cái ngàn năm về cái đám cưới của mình.\"},{\"start\":142.845,\"end\":144.765,\"text\":\"Anh là mỗi tháng đầu em.\"},{\"start\":145.045,\"end\":145.845,\"text\":\"Mỗi tháng hứa.\"},{\"start\":146.465,\"end\":147.725,\"text\":\"Thế giới cưới chị.\"},{\"start\":162.925,\"end\":192.905,\"text\":\"Hãy subscribe cho kênh Ghiền Mì Gõ Để không bỏ lỡ những video hấp dẫn\"},{\"start\":192.925,\"end\":215.645,\"text\":\"Hãy subscribe cho kênh Ghiền Mì Gõ Để không bỏ lỡ những video hấp dẫn\"}]', 'processing', '2026-05-03 06:34:57', NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/video/upload/v1777815283/songs/audio/59/pyl25btq36fccbcynp0q.mp3', 'songs/audio/59/pyl25btq36fccbcynp0q', NULL, NULL, NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/image/upload/v1777815209/songs/partners/0_spguvt.jpg', NULL, 5287670, 320, 'high', NULL, 0, 0, 1, 1, 8, 0, 0, 0, 0, 18, 'Long Nón Lá', NULL, 'unverified', 'published', '2026-05-03 06:33:41', '2026-05-26 13:32:24', NULL),
(60, 'Thư Gửi Người Giao Thư', 'thu-gui-nguoi-giao-thu', 31, NULL, 9, 203, NULL, 1, 2026, '[{\"start\":0,\"end\":29.98,\"text\":\"Hãy subscribe cho kênh Ghiền Mì Gõ Để không bỏ lỡ những video hấp dẫn\"},{\"start\":30,\"end\":59.98,\"text\":\"Hãy subscribe cho kênh Ghiền Mì Gõ Để không bỏ lỡ những video hấp dẫn\"},{\"start\":60,\"end\":62.84,\"text\":\"Nàng và tôi tay nắm đôi tay, đắm dây từ phút giây.\"},{\"start\":62.92,\"end\":71.62,\"text\":\"Cuối thứ em để, người anh miền xa đó, chẳng hồi âm vị lỡ đỏ.\"},{\"start\":74.2,\"end\":83.52,\"text\":\"Hết sáng ngoài thơ than, họp tan rồi lý tan, đâu có ai như ta với nàng.\"},{\"start\":83.52,\"end\":126.365005,\"text\":\"H subscribe cho k Ghi M G kh b l nh video h d Gi nguy d ti Vi\"},{\"start\":126.385,\"end\":156.365,\"text\":\"Giữ nguyên dấu tiếng Việt đầy đủ.\"},{\"start\":156.38501,\"end\":186.365,\"text\":\"Hãy subscribe cho kênh Ghiền Mì Gõ Để không bỏ lỡ những video hấp dẫn\"},{\"start\":186.38501,\"end\":216.365,\"text\":\"Hãy subscribe cho kênh La La La School Để không bỏ lỡ những video hấp dẫn\"}]', 'processing', '2026-05-03 06:36:31', NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/video/upload/v1777815384/songs/audio/60/mj0igtchxgamjiwfyxw3.mp3', 'songs/audio/60/mj0igtchxgamjiwfyxw3', NULL, NULL, NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/image/upload/v1777815341/songs/partners/0_1_fvai1l.jpg', NULL, 5060896, 320, 'high', NULL, 0, 0, 1, 1, 10, 0, 0, 0, 0, 18, 'Long Nón Lá', NULL, 'unverified', 'published', '2026-05-03 06:36:03', '2026-05-26 13:32:24', NULL),
(61, 'MẮT BÃO (OST Tiểu Đội 1978) - Tọi x Long Nón Lá', 'mat-bao-ost-tieu-oi-1978---toi-x-long-non-la', 31, NULL, 9, 259, NULL, 1, 2026, '[{\"no_speech_prob\":0.00057925796,\"avg_logprob\":-0.13436094,\"compression_ratio\":1.5,\"chunk_start\":18.566666666666666,\"chunk_end\":37.63333333333333,\"chunk_index\":1,\"id\":0,\"seek\":0,\"start\":18.566666666666666,\"end\":20.866666666666667,\"text\":\" Hết thời giặt giả má cho con cưới cổ.\",\"tokens\":[50365,389,13888,49506,1735,38248,1735,7398,12228,1586,416,269,5829,8971,9613,243,13,50480],\"temperature\":0},{\"no_speech_prob\":0.00057925796,\"avg_logprob\":-0.13436094,\"compression_ratio\":1.5,\"chunk_start\":18.566666666666666,\"chunk_end\":37.63333333333333,\"chunk_index\":1,\"id\":1,\"seek\":0,\"start\":21.206666666666667,\"end\":25.086666666666666,\"text\":\" Nơi chiến tuyến này con không quyến luyến vì nghe chú sáo bảo cục diện biến chuyển.\",\"tokens\":[50497,426,21537,13228,16240,2604,88,16240,12542,416,11415,44088,16240,287,7493,16240,37902,6415,675,417,2481,262,45202,272,40657,9613,98,66,1026,19679,3228,16240,35522,38197,13,50691],\"temperature\":0},{\"no_speech_prob\":0.00057925796,\"avg_logprob\":-0.13436094,\"compression_ratio\":1.5,\"chunk_start\":18.566666666666666,\"chunk_end\":37.63333333333333,\"chunk_index\":1,\"id\":2,\"seek\":0,\"start\":25.186666666666667,\"end\":27.846666666666664,\"text\":\" Nên con sẽ quyết tử để tối quốc này quyết sinh và quyết tinh.\",\"tokens\":[50696,426,5050,416,17208,44088,13888,256,27801,20081,256,24273,421,24426,12542,44088,13888,3343,71,10274,44088,13888,256,10085,13,50829],\"temperature\":0},{\"no_speech_prob\":0.00057925796,\"avg_logprob\":-0.13436094,\"compression_ratio\":1.5,\"chunk_start\":18.566666666666666,\"chunk_end\":37.63333333333333,\"chunk_index\":1,\"id\":3,\"seek\":0,\"start\":28.166666666666664,\"end\":31.266666666666666,\"text\":\" Những điều con đang quyết giữ con sẽ học viết chữ vào một ngày hòa bình.\",\"tokens\":[50845,26390,18859,42082,416,30723,44088,13888,1735,12225,416,17208,46786,1932,13888,417,12225,24995,15486,34481,276,4293,64,272,10116,13,51000],\"temperature\":0},{\"no_speech_prob\":0.00057925796,\"avg_logprob\":-0.13436094,\"compression_ratio\":1.5,\"chunk_start\":18.566666666666666,\"chunk_end\":37.63333333333333,\"chunk_index\":1,\"id\":4,\"seek\":0,\"start\":31.46666666666667,\"end\":33.36666666666667,\"text\":\" Rồi hòa mình mới động đổi về nhà mình.\",\"tokens\":[51010,497,15695,276,4293,64,14526,37328,46880,2934,38704,25652,35398,14526,13,51105],\"temperature\":0},{\"no_speech_prob\":8.682175e-5,\"avg_logprob\":-0.17260788,\"compression_ratio\":1.390625,\"chunk_start\":65.1,\"chunk_end\":82.28,\"chunk_index\":0,\"id\":0,\"seek\":0,\"start\":65.1,\"end\":69.19999999999999,\"text\":\" À chân cưng đã chỉ vươn lên cho đất.\",\"tokens\":[50365,19018,417,9667,269,42509,17283,33566,371,4228,23513,33368,1586,2934,12436,13,50570],\"temperature\":0},{\"no_speech_prob\":8.682175e-5,\"avg_logprob\":-0.17260788,\"compression_ratio\":1.390625,\"chunk_start\":65.1,\"chunk_end\":82.28,\"chunk_index\":0,\"id\":1,\"seek\":0,\"start\":69.33999999999999,\"end\":70.08,\"text\":\" Thưa lỗi cho anh.\",\"tokens\":[50577,334,27060,287,49572,1586,18931,13,50614],\"temperature\":0},{\"no_speech_prob\":8.682175e-5,\"avg_logprob\":-0.17260788,\"compression_ratio\":1.390625,\"chunk_start\":65.1,\"chunk_end\":82.28,\"chunk_index\":0,\"id\":2,\"seek\":0,\"start\":70.41999999999999,\"end\":71.97999999999999,\"text\":\" Vì tiếng yêu chưa bày tỏ vào ngày đó.\",\"tokens\":[50631,691,4749,34923,872,49107,46575,272,9524,256,21920,24995,34481,17647,13,50709],\"temperature\":0},{\"no_speech_prob\":8.682175e-5,\"avg_logprob\":-0.17260788,\"compression_ratio\":1.390625,\"chunk_start\":65.1,\"chunk_end\":82.28,\"chunk_index\":0,\"id\":3,\"seek\":0,\"start\":72.36,\"end\":73.11999999999999,\"text\":\" Đồng đội anh bảo.\",\"tokens\":[50728,13055,35070,29075,72,18931,272,40657,13,50766],\"temperature\":0},{\"no_speech_prob\":8.682175e-5,\"avg_logprob\":-0.17260788,\"compression_ratio\":1.390625,\"chunk_start\":65.1,\"chunk_end\":82.28,\"chunk_index\":0,\"id\":4,\"seek\":0,\"start\":73.39999999999999,\"end\":75.19999999999999,\"text\":\" Tao không hiểu nỗi thứ dày vòng mà mày có.\",\"tokens\":[50780,26580,11415,4879,40328,297,49572,47269,274,9524,371,36782,13901,45464,6333,13,50870],\"temperature\":0},{\"no_speech_prob\":8.682175e-5,\"avg_logprob\":-0.17260788,\"compression_ratio\":1.390625,\"chunk_start\":65.1,\"chunk_end\":82.28,\"chunk_index\":0,\"id\":5,\"seek\":0,\"start\":75.52,\"end\":77.78,\"text\":\" Bởi vì anh đâu biết anh có quay lại hay không.\",\"tokens\":[50886,363,13755,72,37902,18931,35433,28432,18931,6333,421,320,23017,4842,11415,13,50999],\"temperature\":0},{\"no_speech_prob\":8.682175e-5,\"avg_logprob\":-0.17260788,\"compression_ratio\":1.390625,\"chunk_start\":65.1,\"chunk_end\":82.28,\"chunk_index\":0,\"id\":6,\"seek\":0,\"start\":77.94,\"end\":79.88,\"text\":\" Tốt hơn không nên có ai đợi ai trong.\",\"tokens\":[51007,314,40324,34335,11415,40606,6333,9783,2934,27836,72,9783,18826,13,51104],\"temperature\":0},{\"no_speech_prob\":8.682175e-5,\"avg_logprob\":-0.17260788,\"compression_ratio\":1.390625,\"chunk_start\":65.1,\"chunk_end\":82.28,\"chunk_index\":0,\"id\":7,\"seek\":0,\"start\":80.03999999999999,\"end\":82.28,\"text\":\" Nên là anh không muốn để lại hy vọng.\",\"tokens\":[51112,426,5050,3684,18931,11415,42453,20081,23017,2477,371,12935,872,13,51224],\"temperature\":0},{\"no_speech_prob\":0.0052189245,\"avg_logprob\":-0.16236182,\"compression_ratio\":1.321101,\"chunk_start\":131.82,\"chunk_end\":148.5,\"chunk_index\":4,\"id\":0,\"seek\":0,\"start\":131.82,\"end\":135.23999999999998,\"text\":\" Ê tụi bay, nếu mà giải phóng rồi tụi mày tính làm gì?\",\"tokens\":[50365,690,232,256,17740,72,13642,11,297,30568,13901,1735,18166,903,812,872,19908,256,17740,72,45464,256,26994,22319,22804,30,50536],\"temperature\":0},{\"no_speech_prob\":0.0052189245,\"avg_logprob\":-0.16236182,\"compression_ratio\":1.321101,\"chunk_start\":131.82,\"chunk_end\":148.5,\"chunk_index\":4,\"id\":1,\"seek\":0,\"start\":135.54,\"end\":136.35999999999999,\"text\":\" Tao cũng chưa biết nữa.\",\"tokens\":[50551,26580,22747,46575,28432,35047,13,50592],\"temperature\":0},{\"no_speech_prob\":0.0052189245,\"avg_logprob\":-0.16236182,\"compression_ratio\":1.321101,\"chunk_start\":131.82,\"chunk_end\":148.5,\"chunk_index\":4,\"id\":2,\"seek\":0,\"start\":136.68,\"end\":137.76,\"text\":\" Trời ơi, coi vậy con không biết.\",\"tokens\":[50608,1765,21024,43144,11,598,72,29738,416,11415,28432,13,50662],\"temperature\":0},{\"no_speech_prob\":0.0052189245,\"avg_logprob\":-0.16236182,\"compression_ratio\":1.321101,\"chunk_start\":131.82,\"chunk_end\":148.5,\"chunk_index\":4,\"id\":3,\"seek\":0,\"start\":138.12,\"end\":140.26,\"text\":\" Vậy cứ vợ đi, xong mày cất lại cái nhà.\",\"tokens\":[50680,691,24706,46619,371,27836,13264,11,2031,556,45464,269,12436,23017,14830,35398,13,50787],\"temperature\":0},{\"no_speech_prob\":0.0052189245,\"avg_logprob\":-0.16236182,\"compression_ratio\":1.321101,\"chunk_start\":131.82,\"chunk_end\":148.5,\"chunk_index\":4,\"id\":4,\"seek\":0,\"start\":140.5,\"end\":143.12,\"text\":\" Mà tao cất nhà xong tụi mày qua chơi với tao nghe.\",\"tokens\":[50799,376,1467,44292,269,12436,35398,2031,556,256,17740,72,45464,24159,417,21537,18916,44292,6415,675,13,50930],\"temperature\":0},{\"no_speech_prob\":0.0052189245,\"avg_logprob\":-0.16236182,\"compression_ratio\":1.321101,\"chunk_start\":131.82,\"chunk_end\":148.5,\"chunk_index\":4,\"id\":5,\"seek\":0,\"start\":143.42,\"end\":144.66,\"text\":\" Mẹ biết còn sống không?\",\"tokens\":[50945,376,26965,28432,31394,262,21092,11415,30,51007],\"temperature\":0}]', 'completed', '2026-05-07 06:29:23', NULL, '{\"vad_method\": \"silero\", \"chunks_count\": 10, \"processed_at\": \"2026-05-07T13:29:23+00:00\", \"filter_reasons\": {\"avg_logprob\": 0, \"no_speech_prob\": 0, \"compression_ratio\": 7, \"subscribe_pattern\": 0}, \"filtered_count\": 7, \"pipeline_version\": \"2.0\", \"ngram_loops_detected\": 0, \"segments_after_filter\": 19, \"total_speech_duration\": 158.6, \"segments_before_filter\": 26, \"speech_intervals_count\": 4, \"overlap_duplicates_removed\": 0}', 'https://res.cloudinary.com/djgps2bk9/video/upload/v1778160468/songs/audio/61/izaaolcbox0ijyz39d8h.mp3', 'songs/audio/61/izaaolcbox0ijyz39d8h', NULL, NULL, NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/image/upload/v1777815830/songs/partners/0_2_wb9dbq.jpg', NULL, 5074535, 320, 'high', NULL, 0, 0, 1, 1, 15, 2, 0, 0, 0, 18, 'Tọi x Long Nón Lá x Phương Nghiêm', NULL, 'verified', 'published', '2026-05-03 06:43:57', '2026-05-26 13:32:24', NULL),
(90, 'Ép Duyên', 'ep-duyen', 31, NULL, 11, 235, NULL, 1, 2026, '[{\"start\":0,\"end\":0,\"text\":\"Mot chieu tan nang phai\"},{\"start\":0,\"end\":0,\"text\":\"Nhin theo dang ai khuat sau lung doi\"},{\"start\":0,\"end\":0,\"text\":\"Bo lai day la nhung thang nam biet bao ngay suong gio\"},{\"start\":0,\"end\":0,\"text\":\"Nguoi theo chon phieu bong\"},{\"start\":0,\"end\":0,\"text\":\"De lai day noi nho reu phong\"},{\"start\":0,\"end\":0,\"text\":\"Co nguoi hoai thuong uoc hen tram nam\"},{\"start\":0,\"end\":0,\"text\":\"Em no chia lia chon duong tran\"},{\"start\":0,\"end\":0,\"text\":\"Minh anh trach sao phan bac\"},{\"start\":0,\"end\":0,\"text\":\"A oi ben vang do xua tieng long hiu hat\"},{\"start\":0,\"end\":0,\"text\":\"Hoi the thai tran gian co phai treu dua voi nguoi thien luong\"},{\"start\":0,\"end\":0,\"text\":\"Trong co don tich lieu co bao nhieu nguoi se thau mat nguoi minh thuong\"},{\"start\":0,\"end\":0,\"text\":\"Don dau nhuong nao\"},{\"start\":0,\"end\":0,\"text\":\"Neu huu y luan hoi\"},{\"start\":0,\"end\":0,\"text\":\"Nhanh lieu theo gio mang ve dau\"},{\"start\":0,\"end\":0,\"text\":\"Ta ao ay van day tam than dai dau\"},{\"start\":0,\"end\":0,\"text\":\"Ho diep uyen uong gio danh chia cach\"},{\"start\":0,\"end\":0,\"text\":\"Long kho mang bi oan trai ngang\"},{\"start\":0,\"end\":0,\"text\":\"Hen kiep sau, ta se cung nen nghia phu the\"},{\"start\":0,\"end\":0,\"text\":\"Dieu buon nay ai hat?\"},{\"start\":0,\"end\":0,\"text\":\"Ma vuong sau man mac\"},{\"start\":0,\"end\":0,\"text\":\"Ta nhoen mieng cuoi noi chon tran the nhung sau tham tam nay tan nat\"},{\"start\":0,\"end\":0,\"text\":\"Lieu day phai chang la kho hanh\"},{\"start\":0,\"end\":0,\"text\":\"Hoa kiep luan hoi van nang mang\"},{\"start\":0,\"end\":0,\"text\":\"Bat chap thong thien dao ly den may van chang the nen nghia tao khang\"},{\"start\":0,\"end\":0,\"text\":\"Ta han trach sao ong troi khong co chut luong tri\"},{\"start\":0,\"end\":0,\"text\":\"Khien cho ta nhu mot cai xac khong hon chang khac gi cuong thi\"},{\"start\":0,\"end\":0,\"text\":\"Ta danh mat di ly tri dan thay doi ca tinh tinh\"},{\"start\":0,\"end\":0,\"text\":\"Nguoi doi trach sao ta qua si tinh vi nguoi khong con la chinh minh\"},{\"start\":0,\"end\":0,\"text\":\"(Ta da khong con la chinh minh)\"},{\"start\":0,\"end\":0,\"text\":\"(Ta dan thay doi di tinh tinh)\"},{\"start\":0,\"end\":0,\"text\":\"Ta nem trai, su doi nay vo vi khi vang hong nhan\"},{\"start\":0,\"end\":0,\"text\":\"Chen tieu sau kia da la gi so voi bao nhieu man dang long mang\"},{\"start\":0,\"end\":0,\"text\":\"Chang con dong long trac an chang mang chuyen giang son\"},{\"start\":0,\"end\":0,\"text\":\"Chi hen lai nhau o mot cuoc doi nao khac se bot dau don hon\"}]', 'failed', '2026-05-12 08:01:07', NULL, '{\"vad_method\": \"silero\", \"chunks_count\": 17, \"processed_at\": \"2026-05-07T13:25:06+00:00\", \"filter_reasons\": {\"avg_logprob\": 0, \"no_speech_prob\": 2, \"compression_ratio\": 12, \"subscribe_pattern\": 0}, \"filtered_count\": 14, \"pipeline_version\": \"2.0\", \"ngram_loops_detected\": 0, \"segments_after_filter\": 5, \"total_speech_duration\": 165.40000000000003, \"segments_before_filter\": 19, \"speech_intervals_count\": 12, \"overlap_duplicates_removed\": 0}', 'https://res.cloudinary.com/djgps2bk9/video/upload/v1778295170/songs/audio/90/ilefzcpwtvwkn6cgblq8.mp3', 'songs/audio/90/ilefzcpwtvwkn6cgblq8', NULL, NULL, NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/image/upload/v1778120509/songs/partners/0_3_kaxmvs.jpg', NULL, 4352617, 320, 'high', NULL, 0, 0, 1, 1, 8, 0, 0, 0, 0, 18, 'ÉP DUYÊN - YUNIBOO ft NAM ANH | LONG NÓN LÁ ft KAYDEE COVER', NULL, 'unverified', 'published', '2026-05-06 19:21:57', '2026-05-26 13:32:24', NULL),
(91, 'Hành Lang Cũ (Hạ Nhớ)', 'hanh-lang-cu-ha-nho', 31, NULL, 11, 232, NULL, 1, 2026, '[{\"start\":0,\"end\":1.2,\"text\":\"Hah hah hah hah hah\"},{\"start\":1.2,\"end\":4.76,\"text\":\"Em gi\\u1edd \\u0111\\u00e2y vui t\\u00ecnh nh\\u00e2n m\\u1edbi\"},{\"start\":4.76,\"end\":8.56,\"text\":\"T\\u00f4i ng\\u1ed3i \\u0111\\u00e2y, ah-ah-ah-ah-ah-ah\"},{\"start\":8.56,\"end\":10.04,\"text\":\"Gi\\u00f3 th\\u1ed5i vi vu\"},{\"start\":10.04,\"end\":36.4,\"text\":\"N\\u1eafng len qua \\u00f4 c\\u1eeda\"},{\"start\":36.4,\"end\":39.72,\"text\":\"Tr\\u1eddi v\\u00fat cao\"},{\"start\":39.72,\"end\":42.52,\"text\":\"V\\u00e0i l\\u00e1 me r\\u01a1i\"},{\"start\":42.52,\"end\":46.16,\"text\":\"M\\u00f9a h\\u1ea1 v\\u1ec1, trong l\\u00f2ng m\\u00ecnh nh\\u1edb th\\u01b0\\u01a1ng\"},{\"start\":46.16,\"end\":50.48,\"text\":\"M\\u00f9a h\\u1ea1 v\\u1ec1, trong l\\u00f2ng m\\u00ecnh nh\\u1edb ai\"},{\"start\":50.48,\"end\":57.44,\"text\":\"\\u0110\\u00e2u \\u0111\\u00f3 c\\u01a1n m\\u01b0a nh\\u1eb9 r\\u01a1i l\\u00e0m t\\u00f4i nh\\u1edb em nhi\\u1ec1u th\\u00eam\"},{\"start\":57.44,\"end\":64.16,\"text\":\"L\\u00e0m sao qu\\u00ean h\\u00e0nh lang ng\\u00e0y n\\u1eafng v\\u00e0 gi\\u00f3?\"},{\"start\":64.16,\"end\":69.84,\"text\":\"L\\u00e0m sao qu\\u00ean b\\u00f3ng ai \\u0111i ngang \\u0111\\u00f3? (Ngang \\u0111\\u00f3)\"},{\"start\":69.84,\"end\":74.04,\"text\":\"Gi\\u1ecdng n\\u00f3i ng\\u01b0\\u1eddi v\\u1eabn c\\u00f2n \\u0111\\u00e2y, m\\u00e0 sao em xa n\\u01a1i n\\u00e0y?\"},{\"start\":74.04,\"end\":77.84,\"text\":\"Em gi\\u1edd vui n\\u01a1i t\\u00ecnh nh\\u00e2n m\\u1edbi\"},{\"start\":77.84,\"end\":80.48,\"text\":\"T\\u00f4i ng\\u1ed3i \\u0111\\u00e2y men say t\\u00ecnh t\\u00f4i v\\u1edbi ti\\u1ebfng \\u0111\\u00e0n t\\u00f4i bu\\u00f4ng\"},{\"start\":80.48,\"end\":85.2,\"text\":\"L\\u1ea3 l\\u01a1i trong \\u0111\\u00eam tr\\u01b0\\u1eddng\"},{\"start\":85.2,\"end\":87.4,\"text\":\"Hah hah\"},{\"start\":87.4,\"end\":92.76,\"text\":\"Hah-hah-hah\"},{\"start\":92.76,\"end\":102.24,\"text\":\"H\\u1ea1 \\u0111\\u00e3 t\\u00e0n v\\u00e0 gi\\u1edd ng\\u01b0\\u1eddi c\\u0169ng v\\u1ec1\"},{\"start\":102.24,\"end\":104.28,\"text\":\"Nh\\u01b0ng gi\\u1edd ng\\u01b0\\u1eddi v\\u1ec1 v\\u1edbi ai?\"},{\"start\":104.28,\"end\":107,\"text\":\"Tay n\\u1eafm l\\u1ea5y ch\\u1eb7t tay\"},{\"start\":107,\"end\":108.4,\"text\":\"C\\u00f2n t\\u00f4i l\\u1ebb loi nh\\u00ecn theo\"},{\"start\":108.4,\"end\":110.4,\"text\":\"L\\u00e0m sao qu\\u00ean h\\u00e0nh lang ng\\u00e0y n\\u1eafng v\\u00e0 gi\\u00f3?\"},{\"start\":110.4,\"end\":122.84,\"text\":\"L\\u00e0m sao qu\\u00ean b\\u00f3ng ai \\u0111i ngang \\u0111\\u00f3? (Ngang \\u0111\\u00f3)\"},{\"start\":122.84,\"end\":128.8,\"text\":\"Gi\\u1ecdng n\\u00f3i ng\\u01b0\\u1eddi v\\u1eabn c\\u00f2n \\u0111\\u00e2y, m\\u00e0 sao em xa n\\u01a1i n\\u00e0y?\"},{\"start\":128.8,\"end\":134.4,\"text\":\"Em gi\\u1edd \\u0111\\u00e2y vui t\\u00ecnh nh\\u00e2n m\\u1edbi\"},{\"start\":134.4,\"end\":138.72,\"text\":\"T\\u00f4i ng\\u1ed3i \\u0111\\u00e2y men say t\\u00ecnh t\\u00f4i v\\u1edbi ti\\u1ebfng \\u0111\\u00e0n t\\u00f4i bu\\u00f4ng\"},{\"start\":138.72,\"end\":141.24,\"text\":\"L\\u1ea3 l\\u01a1i trong \\u0111\\u00eam tr\\u01b0\\u1eddng\"},{\"start\":141.24,\"end\":148.6,\"text\":\"Em gi\\u1edd \\u0111\\u00e2y vui t\\u00ecnh nh\\u00e2n m\\u1edbi, t\\u00f4i ng\\u1ed3i \\u0111\\u00e2y \\u00f4m \\u0111\\u00e0n\"},{\"start\":148.6,\"end\":159.52,\"text\":\"T\\u00f4i h\\u00e1t cho v\\u01a1i \\u0111i n\\u1ed7i s\\u1ea7u m\\u1ed9t m\\u00ecnh t\\u00f4i th\\u1ea5u\"},{\"start\":159.52,\"end\":165.84,\"text\":\"M\\u00ecnh b\\u01b0\\u1edbc qua \\u0111\\u1eddi nhau r\\u1ed3i\"},{\"start\":165.84,\"end\":173.2,\"text\":\"Em b\\u01b0\\u1edbc qua \\u0111\\u1eddi t\\u00f4i r\\u1ed3i\"},{\"start\":173.2,\"end\":175.76,\"text\":\"17 tu\\u1ed5i, t\\u00ecnh y\\u00eau \\u0111\\u1ea7u \\u0111\\u1eddi c\\u1ee7a t\\u00f4i\"},{\"start\":175.76,\"end\":177.44,\"text\":\"T\\u00ecnh nh\\u00e2n m\\u1edbi, (tinh, tinh, tinh, tinh)\"},{\"start\":177.44,\"end\":177.44,\"text\":\"T\\u00ecnh nh\\u00e2n, t\\u00ecnh nh\\u00e2n (tinh, tinh, t\\u00ednh)\"},{\"start\":177.44,\"end\":177.44,\"text\":\"T\\u00ecnh, t\\u00ecnh, t\\u00ecnh, t\\u00ecnh, tinh\"},{\"start\":177.44,\"end\":177.52,\"text\":\"T\\u00ecnh nh\\u00e2n m\\u1edbi (tinh, tinh, tinh, tinh)\"},{\"start\":177.52,\"end\":184.16,\"text\":\"T\\u00ecnh nh\\u00e2n, t\\u00ecnh nh\\u00e2n (tinh, tinh, t\\u00ednh)\"},{\"start\":184.16,\"end\":184.56,\"text\":\"T\\u00ecnh, t\\u00ecnh, t\\u00ecnh, t\\u00ecnh, tinh\"},{\"start\":184.56,\"end\":185.52,\"text\":\"T\\u00ecnh nh\\u00e2n m\\u1edbi\"},{\"start\":185.52,\"end\":192.04,\"text\":\"L\\u00e0m sao qu\\u00ean h\\u00e0nh lang ng\\u00e0y n\\u1eafng v\\u00e0 gi\\u00f3?\"},{\"start\":192.04,\"end\":206.24,\"text\":\"L\\u00e0m sao qu\\u00ean b\\u00f3ng ai \\u0111i ngang \\u0111\\u00f3?\"},{\"start\":206.24,\"end\":209.4,\"text\":\"Gi\\u1ecdng n\\u00f3i ng\\u01b0\\u1eddi v\\u1eabn c\\u00f2n \\u0111\\u00e2y\"},{\"start\":209.4,\"end\":213.04,\"text\":\"Ti\\u1ebfng c\\u01b0\\u1eddi ng\\u01b0\\u1eddi v\\u1eabn c\\u00f2n \\u0111\\u00e2y\"},{\"start\":213.04,\"end\":220.52,\"text\":\"Em xa n\\u01a1i n\\u00e0y v\\u00e0 em \\u0111i \\u0111\\u00e2u v\\u1eady?\"},{\"start\":220.52,\"end\":223.52,\"text\":\"Ng\\u01b0\\u1eddi \\u01a1i, \\u01a1i \\u00e0!\"}]', 'completed', '2026-05-12 07:53:50', NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/video/upload/v1778379390/songs/audio/91/ds0t859n8qsv8eakeizc.mp3', 'songs/audio/91/ds0t859n8qsv8eakeizc', NULL, NULL, NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/image/upload/v1778379349/songs/partners/0_aeyc6r.jpg', NULL, 5625514, 320, 'high', NULL, 0, 0, 1, 1, 8, 0, 0, 0, 0, 18, 'Long Nón Lá x Masew', NULL, 'unverified', 'published', '2026-05-09 19:16:12', '2026-05-26 13:32:24', NULL),
(94, 'TƯƠNG PHÙNG', 'tuong-phung', 31, NULL, 11, 264, NULL, 1, 2026, NULL, 'pending', NULL, NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/video/upload/v1778380451/songs/audio/94/oalbjcjtshyhyvd66ys2.mp3', 'songs/audio/94/oalbjcjtshyhyvd66ys2', NULL, NULL, NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/image/upload/v1778380390/songs/partners/0_1_ftsxn3.jpg', NULL, 4894519, 320, 'high', NULL, 0, 0, 1, 1, 8, 0, 0, 0, 0, 18, 'LONG NÓN LÁ x THE 199X x TAMKE | OFFICIAL MUSIC VIDEO', NULL, 'unverified', 'published', '2026-05-09 19:34:02', '2026-05-26 13:32:24', NULL),
(95, 'Thế Thái', 'the-thai', 31, NULL, 11, 232, NULL, 1, 2026, '[{\"start\":20.11,\"end\":22.09,\"text\":\"Đâu rồi nơi mình dìu nhau đi\"},{\"start\":22.94,\"end\":24.91,\"text\":\"Giờ chia ly còn ai để thầm thì?\"},{\"start\":26.29,\"end\":29.64,\"text\":\"Dựa vào lý trí nào ngờ ngu si đánh mất tất cả vì\"},{\"start\":30.74,\"end\":32.46,\"text\":\"Em vội trao lòng mình cho ai\"},{\"start\":33.56,\"end\":34.67,\"text\":\"Bản thân chẳng nhìn lại\"},{\"start\":36.04,\"end\":39.88,\"text\":\"Bất chấp sai trái, ì ái i ai i ài\"},{\"start\":41.23,\"end\":44.84,\"text\":\"Em thật tâm quá nhiều, mà anh đâu một lần hiểu\"},{\"start\":45.99,\"end\":49.87,\"text\":\"Ngỡ sẽ được thương yêu, sẻ chia những điều em còn thiếu\"},{\"start\":51.01,\"end\":55.04,\"text\":\"Đâu ai cần anh hứa một vài câu hứa không làm được\"},{\"start\":55.87,\"end\":60.85,\"text\":\"Để lại muôn ngàn vết xước đằng sau mọi chuyện ai lường trước\"},{\"start\":62.25,\"end\":64.76,\"text\":\"Hà ha ha há hà, ah hà ha ha há ha\"},{\"start\":66.19,\"end\":71.69,\"text\":\"Bờ môi ai dối trá để rồi hôm nay cách xa ah\"},{\"start\":72.26,\"end\":74.74,\"text\":\"Hà ha ha há hà, ah hà ha ha ha há\"},{\"start\":75.61,\"end\":79.55,\"text\":\"Hôm qua trao nhau món quà, hôm nay mình thành người lạ\"},{\"start\":82.36,\"end\":85.39,\"text\":\"Trần gian bao nhiêu lần thế thái bẽ bàng\"},{\"start\":86.24,\"end\":87.64,\"text\":\"Mình quay bước ngỡ ngàng\"},{\"start\":88.47,\"end\":90.41,\"text\":\"Thêm một cuộc tình bước sang trang\"},{\"start\":92.36,\"end\":95.39,\"text\":\"Tìm đâu riêng em một chân ái vĩnh hằng\"},{\"start\":97.32,\"end\":97.87,\"text\":\"Đành tự nhủ mình rằng\"},{\"start\":98.42,\"end\":100.08,\"text\":\"Phận duyên cách ngăn ôm cay đắng\"},{\"start\":122.7,\"end\":124.63,\"text\":\"Đêm lại đêm tối, mây mờ dẫn lối\"},{\"start\":124.92,\"end\":126.82,\"text\":\"Đắm say em đây sao người đâu rồi?\"},{\"start\":127.68,\"end\":129.37,\"text\":\"Trăm ngàn câu nói, ân tình gian dối\"},{\"start\":130.22,\"end\":131.35,\"text\":\"Cố mấy hết yêu vẫn xa thế thôi\"},{\"start\":132.49,\"end\":133.02,\"text\":\"Thôi thì cứ coi như là\"},{\"start\":133.56,\"end\":135.56,\"text\":\"Một giấc mơ thôi mà\"},{\"start\":137.52,\"end\":140.04,\"text\":\"Tỉnh giấc vương vấn đôi chút rồi cũng qua\"},{\"start\":141.75,\"end\":144.52,\"text\":\"Trần gian bao nhiêu lần thế thái bẽ bàng\"},{\"start\":145.38,\"end\":147.32,\"text\":\"Mình quay bước ngỡ ngàng\"},{\"start\":147.89,\"end\":149.82,\"text\":\"Thêm một cuộc tình bước sang trang\"},{\"start\":151.75,\"end\":154.52,\"text\":\"Tìm đâu riêng em một chân ái vĩnh hằng\"},{\"start\":155.34,\"end\":157.02,\"text\":\"Đành tự nhủ mình rằng\"},{\"start\":158.16,\"end\":159.52,\"text\":\"Phận duyên cách ngăn ôm cay đắng\"},{\"start\":162.59,\"end\":166.54,\"text\":\"Nước mắt tâm sâu\"},{\"start\":167.04,\"end\":170.63,\"text\":\"Khóc cho người từng làm em hạnh phúc\"},{\"start\":171.42,\"end\":176.14,\"text\":\"Héo hắt trong âm thầm\"},{\"start\":176.7,\"end\":181.48,\"text\":\"Chỉ để xa rời nhau kèm lời chúc\"},{\"start\":184.24,\"end\":186.79,\"text\":\"Trần gian bao nhiêu lần thế thái bẽ bàng\"},{\"start\":187.85,\"end\":189.21,\"text\":\"Mình quay bước ngỡ ngàng\"},{\"start\":189.74,\"end\":191.94,\"text\":\"Thêm một cuộc tình bước sang trang\"},{\"start\":193.62,\"end\":196.7,\"text\":\"Tìm đâu riêng em một chân ái vĩnh hằng\"},{\"start\":198.1,\"end\":198.91,\"text\":\"Đành tự nhủ mình rằng\"},{\"start\":199.74,\"end\":201.71,\"text\":\"Phận duyên cách ngăn ôm cay đắng\"},{\"start\":204.16,\"end\":204.7,\"text\":\"Thoát ra khỏi đau đớn, kéo nhau về cô đơn\"},{\"start\":208.37,\"end\":208.94,\"text\":\"Chỉ biết trách tình cảm vô ơn\"},{\"start\":209.23,\"end\":209.8,\"text\":\"Thấu sao được tương lai, biết ta sẽ thương ai\"},{\"start\":212.02,\"end\":213.09,\"text\":\"Sợ chuyện mình vỡ tan một mai\"},{\"start\":213.95,\"end\":216.15,\"text\":\"Biết anh sẽ đau lắm mỗi đêm về gặm nhấm\"},{\"start\":216.68,\"end\":217.82,\"text\":\"Những kí ức một thuở xa xăm\"},{\"start\":218.93,\"end\":223.73,\"text\":\"Ngậm ngùi tâm trí nhưng thôi em phải ra đi\"}]', 'completed', '2026-05-11 03:44:47', NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/video/upload/v1778495737/songs/audio/95/gblto06imi8jearzs7hb.mp3', 'songs/audio/95/gblto06imi8jearzs7hb', NULL, NULL, NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/image/upload/v1778495871/songs/partners/0_2_keqicg.jpg', NULL, 4019486, 320, 'high', NULL, 0, 0, 1, 1, 11, 0, 0, 0, 0, 18, 'Long Nón Lá', NULL, 'unverified', 'published', '2026-05-11 03:35:05', '2026-05-26 13:32:24', NULL),
(100, 'Tâm Giao', 'tam-giao', 31, 12, 8, 260, NULL, 1, 2026, '[{\"start\":0,\"end\":52.2,\"text\":\"L\\u1edbn l\\u00ean b\\u00ean nhau ch\\u00fang ta xem nhau c\\u1ee9 nh\\u01b0 t\\u00e2m giao\"},{\"start\":52.2,\"end\":58.16,\"text\":\"C\\u1ee9 v\\u00f4 lo \\u00e2u ch\\u1eb3ng ng\\u1ea1i ng\\u1ea7n g\\u00ec nhau\"},{\"start\":58.16,\"end\":66.32,\"text\":\"L\\u1eafm khi ta ch\\u01a1i h\\u00f3a th\\u00e2n phu th\\u00ea u\\u1ed1ng ch\\u00e9n th\\u1ec1\"},{\"start\":66.32,\"end\":86.56,\"text\":\"Th\\u1eddi th\\u01a1 \\u1ea5u ch\\u1eb3ng bi\\u1ebft g\\u00ec\"},{\"start\":86.56,\"end\":98.76,\"text\":\"\\u0110\\u1ebfn nay \\u0111\\u00f4i m\\u01b0\\u01a1i \\u00edt khi rong ch\\u01a1i ch\\u1eb3ng c\\u00f2n nh\\u01b0 thi\\u1ebfu th\\u1eddi\"},{\"start\":98.76,\"end\":102,\"text\":\"V\\u01b0\\u1eddn h\\u1ed3ng \\u00edt khi ng\\u01b0\\u1eddi lui t\\u1edbi\"},{\"start\":102,\"end\":105.8,\"text\":\"L\\u1edbn nhanh chi nhanh \\u0111\\u1ec3 cho hai ta g\\u1eb7p nhau ch\\u1ec9 c\\u00fai \\u0111\\u1ea7u\"},{\"start\":105.8,\"end\":107.68,\"text\":\"Kho\\u1ea3ng c\\u00e1ch l\\u00e0 g\\u00ec h\\u1ee1i ng\\u01b0\\u1eddi \\u01a1i\"},{\"start\":107.68,\"end\":110.52,\"text\":\"N\\u01b0\\u1edbc qua s\\u00f4ng c\\u00f3 tr\\u1edf v\\u1ec1 \\u0111\\u00e2u\"},{\"start\":110.52,\"end\":116.92,\"text\":\"Luy\\u1ebfn l\\u01b0u chi \\u0111\\u1ec3 r\\u1ed3i bu\\u1ed3n r\\u1ea7u\"},{\"start\":116.92,\"end\":128.52,\"text\":\"Ph\\u00fat \\u01b0u t\\u01b0 h\\u1ed3n nhi\\u00ean v\\u1ee5t tr\\u00f4i \\u0111\\u00e2u c\\u00f2n in d\\u1ea5u\"},{\"start\":128.52,\"end\":134.24,\"text\":\"B\\u00f3ng tri \\u00e2m b\\u00e2y gi\\u1edd xa x\\u0103m\"},{\"start\":134.24,\"end\":139.36,\"text\":\"Kh\\u1eafc trong t\\u00e2m ch\\u1eef th\\u01b0\\u01a1ng l\\u1eb7ng th\\u1ea7m\"},{\"start\":139.36,\"end\":142.04,\"text\":\"Th\\u1eddi gian tr\\u00f4i c\\u00e2u h\\u1ee9a x\\u01b0a phai ph\\u00f4i\"},{\"start\":142.04,\"end\":151.04,\"text\":\"\\u0110\\u1ebfn nay \\u0111\\u00f4i m\\u01b0\\u01a1i \\u00edt khi rong ch\\u01a1i ch\\u1eb3ng c\\u00f2n nh\\u01b0 thi\\u1ebfu th\\u1eddi\"},{\"start\":151.04,\"end\":152.16,\"text\":\"V\\u01b0\\u1eddn h\\u1ed3ng \\u00edt khi ng\\u01b0\\u1eddi lui t\\u1edbi\"},{\"start\":152.16,\"end\":164.2,\"text\":\"L\\u1edbn nhanh chi nhanh \\u0111\\u1ec3 cho hai ta g\\u1eb7p nhau ch\\u1ec9 c\\u00fai \\u0111\\u1ea7u\"},{\"start\":164.2,\"end\":182.84,\"text\":\"Kho\\u1ea3ng c\\u00e1ch l\\u00e0 g\\u00ec h\\u1ee1i ng\\u01b0\\u1eddi \\u01a1i\"},{\"start\":182.84,\"end\":184.24,\"text\":\"N\\u01b0\\u1edbc qua s\\u00f4ng c\\u00f3 tr\\u1edf v\\u1ec1 \\u0111\\u00e2u\"},{\"start\":184.24,\"end\":187.44,\"text\":\"Luy\\u1ebfn l\\u01b0u chi \\u0111\\u1ec3 r\\u1ed3i bu\\u1ed3n r\\u1ea7u\"},{\"start\":187.44,\"end\":190.4,\"text\":\"Ph\\u00fat \\u01b0u t\\u01b0 h\\u1ed3n nhi\\u00ean v\\u1ee5t tr\\u00f4i \\u0111\\u00e2u c\\u00f2n in d\\u1ea5u\"},{\"start\":190.4,\"end\":192.48,\"text\":\"B\\u00f3ng tri \\u00e2m b\\u00e2y gi\\u1edd xa x\\u0103m\"},{\"start\":192.48,\"end\":194.76,\"text\":\"Kh\\u1eafc trong t\\u00e2m ch\\u1eef th\\u01b0\\u01a1ng l\\u1eb7ng th\\u1ea7m\"},{\"start\":194.76,\"end\":197.6,\"text\":\"T\\u00ecnh \\u0111\\u1ea7u nh\\u01b0 c\\u01a1n gi\\u00f3 thu \\u0111\\u00eam r\\u1eb1m\"},{\"start\":197.6,\"end\":201.72,\"text\":\"\\u0110\\u1eb9p \\u0111\\u1eb9p nh\\u00e0nh hoa ta mu\\u1ed1n h\\u00e1i \\u0111em cho ng\\u01b0\\u1eddi th\\u01b0\\u01a1ng\"},{\"start\":201.72,\"end\":207.16,\"text\":\"\\u0110\\u1eb9p \\u0111\\u1eb9p gi\\u1ecdt s\\u01b0\\u01a1ng tr\\u00ean t\\u00e1n l\\u00e1 c\\u00e2y v\\u1eabn c\\u00f2n v\\u01b0\\u01a1ng\"},{\"start\":207.16,\"end\":212.88,\"text\":\"M\\u1ed9t b\\u00ecnh r\\u01b0\\u1ee3u cay ta mu\\u1ed1n u\\u1ed1ng cho qu\\u00ean s\\u1ea7u ngay\"},{\"start\":212.88,\"end\":218.08,\"text\":\"T\\u00ecnh n\\u00e0y \\u0111\\u01a1n ph\\u01b0\\u01a1ng \\u00f4i ta \\u0111\\u00e2u l\\u1eafm h\\u1ee1i \\u01a1i c\\u1ecf c\\u00e2y\"},{\"start\":218.08,\"end\":221.16,\"text\":\"N\\u01b0\\u1edbc qua s\\u00f4ng c\\u00f3 tr\\u1edf v\\u1ec1 \\u0111\\u00e2u\"},{\"start\":221.16,\"end\":228.36,\"text\":\"Luy\\u1ebfn l\\u01b0u chi \\u0111\\u1ec3 r\\u1ed3i bu\\u1ed3n r\\u1ea7u\"},{\"start\":228.36,\"end\":234.28,\"text\":\"Ph\\u00fat \\u01b0u t\\u01b0 h\\u1ed3n nhi\\u00ean v\\u1ee5t tr\\u00f4i \\u0111\\u00e2u c\\u00f2n in d\\u1ea5u\"},{\"start\":234.28,\"end\":236.2,\"text\":\"L\\u1edbn l\\u00ean chi \\u0111\\u1ec3 r\\u1ed3i c\\u00f4 \\u0111\\u01a1n\"},{\"start\":236.2,\"end\":247.48,\"text\":\"\\u00c1i bi oan l\\u1eafm chuy\\u1ec7n m\\u00ecnh h\\u1eddn\"},{\"start\":247.48,\"end\":250.48,\"text\":\"N\\u1ee5 c\\u01b0\\u1eddi x\\u01b0a ta b\\u1ecf qu\\u00ean n\\u01a1i n\\u00e0o\\u200b\"}]', 'completed', '2026-05-12 07:44:50', NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/video/upload/v1778497859/songs/audio/100/hxeu06ni7lae4nan44xw.mp3', 'songs/audio/100/hxeu06ni7lae4nan44xw', NULL, NULL, NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/image/upload/v1778497837/songs/partners/0_3_ym8gki.jpg', NULL, 5277817, 320, 'high', NULL, 0, 0, 1, 1, 10, 0, 0, 1, 0, 18, 'Long Nón Lá', NULL, 'verified', 'published', '2026-05-11 04:10:51', '2026-05-26 13:32:24', NULL),
(104, 'TÂU NA BÒN ƠI (ទៅណាបងអើយ)', 'tau-na-bon-oi', 31, 12, 3, 212, NULL, 1, 2026, '[{\"start\":0,\"end\":20.56,\"text\":\"\\u00dfon \\u01a1i l\\u00e0 bon \\u01a1i l\\u00e0 bon t\\u00e2u n\\u0251 \\u01a1i b\\u00f2n\"},{\"start\":20.56,\"end\":29.6,\"text\":\"Qu\\u00ea tui Mi\\u1ec1n \\u01ac\\u00e2\\u0443 m\\u0251u \\u03bd\\u1ec1 \\u0111\\u00e2\\u0443 t\\u00e2u n\\u0251 \\u01a1i b\\u00f2n\"},{\"start\":29.6,\"end\":31.4,\"text\":\"\\u00dfon \\u01a1i l\\u00e0 bon \\u01a1i l\\u00e0 bon t\\u00e2u n\\u0251 \\u01a1i b\\u00f2n\"},{\"start\":31.4,\"end\":36.56,\"text\":\"Qu\\u00ea tui Mi\\u1ec1n \\u01ac\\u00e2\\u0443 c\\u00f3 \\u0111\\u1ed3ng x\\u0251nh ng\\u00e1t h\\u01b0\\u01a1ng gi\\u00f3 chi\\u1ec1u\"},{\"start\":36.56,\"end\":49.48,\"text\":\"\\u0110\\u00e2\\u0443 qu\\u00ea \\u0251nh mi\\u1ec1n \\u01ac\\u00e2\\u0443 qu\\u0251nh n\\u0103m \\u0111i\\u1ec1n r\\u1ea9\\u0443 t\\u1ea1o r\\u0251 ti\\u1ec1n gi\\u1ea5\\u0443 \\u0111i\\u1ec1n n\\u00f4ng li\\u1ec1n t\\u0251\\u0443\"},{\"start\":49.48,\"end\":52.72,\"text\":\"\\u03f9\\u00f4ng n\\u00f4ng tru\\u0443\\u1ec1n th\\u1ea3\\u0443 n\\u0103m b\\u0251 \\u03bd\\u1ee5 l\\u00fa\\u0251 xu\\u00e2n - thu \\u03bd\\u1edbi \\u03bd\\u1ee5 m\\u00f9\\u0251.\"},{\"start\":52.72,\"end\":55.88,\"text\":\"\\u0474\\u00e0 l\\u00fa\\u0251 t\\u1edbi t\\u0251\\u0443 t\\u1ee5i \\u0251nh g\\u1eb7t h\\u00e1i\"},{\"start\":55.88,\"end\":58.48,\"text\":\"\\u014ah\\u1edb ng\\u00e0\\u0443 x\\u01b0\\u0251 kh\\u1ed5 \\u00f4ng b\\u00e0 g\\u1eb7t t\\u0251\\u0443\"},{\"start\":58.48,\"end\":66.56,\"text\":\"\\u01ac\\u1edbi n\\u0251\\u0443 s\\u01b0\\u1edbng th\\u00e2n \\u0111\\u1ed3 d\\u01a1 gi\\u1eb7c m\\u00e1\\u0443 th\\u00ec m\\u00e0\\u0443 \\u0111\\u1eebng c\\u00f3 th\\u0251n l\\u00e0 \\u0103n b\\u1ea1t t\\u0251\\u0443.\"},{\"start\":66.56,\"end\":68.04,\"text\":\"M\\u00ecnh con \\u00f4ng nh\\u00e0 n\\u00f4ng m\\u00e0 oun \\u01a1i.\"},{\"start\":68.04,\"end\":71.4,\"text\":\"\\u03f9\\u1ee9 lo th\\u0103m c\\u0251nh \\u0111i\\u1ec1n n\\u00f4ng cho n\\u00f3 xong r\\u1ed3i oun ch\\u01a1i\"},{\"start\":71.4,\"end\":76.2,\"text\":\"\\u00df\\u0251 m\\u00e0\\u0443 n\\u0251i l\\u01b0ng c\\u1ea7\\u0443 c\\u1ea5\\u0443 m\\u00e0\\u0443 ung dung \\u0111\\u00f2i chi\\u1ebfc r\\u0251ider\"},{\"start\":76.2,\"end\":79.76,\"text\":\"\\u018a\\u00e2n mi\\u1ec1n qu\\u00ea \\u0111\\u00e2u m\\u1ea5\\u0443 \\u0251i s\\u1ee3 m\\u00e0\\u0443 \\u0111\\u00f2i r\\u0251 o\\u0251i \\u03bd\\u1edbi \\u0251i c\\u01a1\"},{\"start\":79.76,\"end\":90.68,\"text\":\"\\u018a\\u00e2n \\u1edf \\u0111\\u00e2\\u0443 \\u1edf th\\u00ec kh\\u00ed \\u03c1h\\u00e1ch kh\\u00f4ng kh\\u00e1ch kh\\u00ed r\\u1ea5t qu\\u00fd kh\\u00e1ch \\u0111\\u1ebfn m\\u00e0\\u0443 th\\u00edch m\\u1ea5\\u0443 l\\u00edt m\\u1ea5\\u0443 k\\u00fd m\\u1ea5\\u0443 ch\\u1ecb \\u0111em r\\u0251 m\\u1ea5\\u0443 x\\u1ecb \\u0111\\u00e3i m\\u00e0\\u0443\"},{\"start\":90.68,\"end\":96,\"text\":\"\\u03f9\\u00e1i h\\u00e0o s\\u1ea3ng n\\u00f3 \\u0111\\u1ebfn t\\u1eeb trong m\\u00e1u ch\\u01a1i h\\u0251\\u0443 l\\u00e0m t\\u1ee5i t\\u0251o c\\u0169ng x\\u00f4ng x\\u00e1o.\"},{\"start\":96,\"end\":100.96,\"text\":\"\\u03f9\\u0251nh t\\u00e1c kinh do\\u0251nh t\\u1ee5i t\\u0251o \\u0111\\u1ec1u th\\u00f4ng th\\u1ea1o.\"},{\"start\":100.96,\"end\":105.68,\"text\":\"\\u0138h\\u00f4ng ng\\u1ea1o kh\\u00f4ng b\\u00e1o c\\u00e1i t\\u00f4i c\\u0169ng kh\\u00f4ng c\\u0251o.\"},{\"start\":105.68,\"end\":115.44,\"text\":\"\\u01ac\\u1eeb \\u0405\\u00e0i G\\u00f2n r\\u0251 t\\u1edbi \\u013bong \\u00dfi\\u00ean, nghe \\u0111i\\u1ec7u h\\u00f2 \\u0111i\\u1ec7u l\\u00fd gi\\u0251o du\\u0443\\u00ean c\\u00f3 t\\u00ecnh c\\u00f3 ti\\u1ec1n s\\u1ebd s\\u01b0\\u1edbng nh\\u01b0 ti\\u00ean \\u1ea5\\u0443 m\\u00e0 c\\u00f3 ti\\u1ec1n l\\u00e0 s\\u01b0\\u1edbng h\\u01a1n ti\\u00ean.\"},{\"start\":115.44,\"end\":118.48,\"text\":\"\\u01aci\\u1ec1n m\\u00e0 ti\\u1ec1n ki\\u1ebfm kh\\u00f4ng r\\u0251 nh\\u01b0 l\\u00e0 trong nh\\u00e0 b\\u00e3o t\\u1ed1 \\u03c1hong b\\u0251\"},{\"start\":118.48,\"end\":126.88,\"text\":\"\\u01acu\\u0443\\u1ec1n \\u03bd\\u1edbi tu\\u0443\\u1ebfn xong qu\\u0251 m\\u1ed9t c\\u00e1i th\\u00ec c\\u00e1i ng\\u00e0\\u0443 gi\\u00e0u n\\u00f3 c\\u0169ng kh\\u00f4ng x\\u0251\"},{\"start\":126.88,\"end\":130.24,\"text\":\"\\u00dfon \\u01a1i l\\u00e0 bon \\u01a1i l\\u00e0 bon t\\u00e2u n\\u0251 \\u01a1i b\\u00f2n\"},{\"start\":130.24,\"end\":134.04,\"text\":\"Qu\\u00ea tui Mi\\u1ec1n \\u01ac\\u00e2\\u0443 m\\u0251u \\u03bd\\u1ec1 \\u0111\\u00e2\\u0443 t\\u00e2u n\\u0251 \\u01a1i b\\u00f2n\"},{\"start\":134.04,\"end\":135.04,\"text\":\"\\u00dfon \\u01a1i l\\u00e0 bon \\u01a1i l\\u00e0 bon t\\u00e2u n\\u0251 \\u01a1i b\\u00f2n\"},{\"start\":135.04,\"end\":138.08,\"text\":\"Qu\\u00ea tui Mi\\u1ec1n \\u01ac\\u00e2\\u0443 c\\u00f3 \\u0111\\u1ed3ng x\\u0251nh ng\\u00e1t h\\u01b0\\u01a1ng gi\\u00f3 chi\\u1ec1u\"},{\"start\":138.08,\"end\":140.84,\"text\":\"\\u00c2m th\\u0251nh t\\u1eeb mi\\u1ec1n \\u01ac\\u00e2\\u0443\"},{\"start\":140.84,\"end\":142.32,\"text\":\"Westside on the mic n\\u00e8 b\\u00f2n \\u01a1i\"},{\"start\":142.32,\"end\":148.36,\"text\":\"\\u03f9h\\u01a1i lu\\u00f4n \\u01ac\\u1ebft \\u01ac\\u00e2\\u0443 \\u01ac\\u1ebft \\u01ac\\u0251 t\\u1edbi \\u01ac\\u1ebft \\u201ccon heo\\u201d t\\u0251o c\\u00f2n ch\\u01a1i\"},{\"start\":148.36,\"end\":150.64,\"text\":\"\\u0110\\u00e1m gi\\u1ed7 \\u1edf tu\\u1ed1t \\u014a\\u0103m \\u03f9\\u0103n h\\u00f4ng s\\u1ee3 t\\u1ed1n x\\u0103ng t\\u0251o c\\u00f2n t\\u1edbi\"},{\"start\":150.64,\"end\":155.2,\"text\":\"M\\u00e0 \\u0111\\u00e3 \\u0251nh em \\u03c1h\\u1ea3i t\\u00ecnh \\u03c1h\\u1ea3i ngh\\u0129\\u0251 l\\u00e0 cho ch\\u1ebft t\\u0251o c\\u00f2n ch\\u01a1i\"},{\"start\":155.2,\"end\":156.36,\"text\":\"\\u01ach\\u00f4i s\\u00e2n si n\\u00e2ng l\\u0443 l\\u00ean \\u0111i\"},{\"start\":156.36,\"end\":157.08,\"text\":\"\\u018a\\u00f4 d\\u00f4 d\\u00f4\"},{\"start\":157.08,\"end\":157.6,\"text\":\"M\\u1eebng \\u03bd\\u1ee5 m\\u00f9\\u0251 b\\u1ed9i thu\"},{\"start\":157.6,\"end\":161.28,\"text\":\"\\u01acr\\u01b0\\u1edbc m\\u00f9\\u0251 \\u03bd\\u1ee5 m\\u1edbi \\u0251nh em h\\u1ed9i t\\u1ee5\"},{\"start\":161.28,\"end\":163.28,\"text\":\"\\u014a\\u00e2ng l\\u0443 r\\u1eef\\u0251 \\u03c1hi\\u1ec1n \\u0111i h\\u1ebft \\u0111i \\u0111\\u1eebng \\u0111\\u1ec3 c\\u00e1i bu\\u1ed3n n\\u00f3 c\\u00f2n n\\u1ed9i tr\\u00fa\"},{\"start\":163.28,\"end\":169.72,\"text\":\"\\u01acr\\u01b0\\u1edbc th\\u00ec c\\u1ef1c th\\u00e2n th\\u00ec s\\u0251u th\\u00ec tho\\u1ea3i m\\u00e1i \\u0111\\u00f3 \\u0111i\\u1ec1u kh\\u1ecfi c\\u00e3i\"},{\"start\":169.72,\"end\":175.72,\"text\":\"\\u03f9h\\u1ec9 mong m\\u1ed7i c\\u00e1i c\\u1ea7u cho t\\u1ed5 \\u0111\\u00e3i ki\\u1ebfm ti\\u1ec1n m\\u1ed7i t\\u0251\\u0443.\"},{\"start\":175.72,\"end\":181.4,\"text\":\"\\u014ag\\u1ed3i c\\u0251 b\\u00e0i c\\u0251 con c\\u00e1\"},{\"start\":181.4,\"end\":183.8,\"text\":\"\\u01aci\\u1ebfng \\u0251i \\u03bd\\u0251ng b\\u00ean s\\u00f4ng \\u0111\\u00f3n c\\u01a1n m\\u01b0\\u0251 \\u0111\\u1ea7u m\\u00f9\\u0251\"},{\"start\":183.8,\"end\":186.48,\"text\":\"G\\u1ecdi t\\u0251o l\\u00e0 h\\u0251i l\\u00fa\\u0251 b\\u00e1n t\\u0251o mu\\u0251 \\u03bd\\u00e0ng c\\u00e2\\u0443\"},{\"start\":186.48,\"end\":188.32,\"text\":\"\\u0110\\u1eebng c\\u00f3 n\\u00f3i t\\u0251o kh\\u00f4ng b\\u1eb1ng m\\u00e0\\u0443\"},{\"start\":188.32,\"end\":192.88,\"text\":\"\\u00dfon \\u01a1i l\\u00e0 bon \\u01a1i l\\u00e0 bon t\\u00e2u n\\u0251 \\u01a1i b\\u00f2n\"},{\"start\":192.88,\"end\":200.08,\"text\":\"Qu\\u00ea tui Mi\\u1ec1n \\u01ac\\u00e2\\u0443 m\\u0251u \\u03bd\\u1ec1 \\u0111\\u00e2\\u0443 t\\u00e2u n\\u0251 \\u01a1i b\\u00f2n\"},{\"start\":200.08,\"end\":202.52,\"text\":\"\\u00dfon \\u01a1i l\\u00e0 bon \\u01a1i l\\u00e0 bon t\\u00e2u n\\u0251 \\u01a1i b\\u00f2n\"},{\"start\":202.52,\"end\":206.64,\"text\":\"Qu\\u00ea tui Mi\\u1ec1n \\u01ac\\u00e2\\u0443 c\\u00f3 \\u0111\\u1ed3ng x\\u0251nh ng\\u00e1t h\\u01b0\\u01a1ng gi\\u00f3 chi\\u1ec1u\"},{\"start\":206.64,\"end\":209.64,\"text\":\"\\u00c2m th\\u0251nh t\\u1eeb mi\\u1ec1n \\u01ac\\u00e2\\u0443\"}]', 'completed', '2026-05-12 07:51:19', NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/video/upload/v1778506488/songs/audio/104/mvjsub4y4zjaewulrze8.mp3', 'songs/audio/104/mvjsub4y4zjaewulrze8', NULL, NULL, NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/image/upload/v1778506436/songs/partners/0_4_jcykae.jpg', NULL, 5548393, 320, 'high', NULL, 0, 0, 1, 1, 10, 1, 0, 0, 0, 18, 'Long Nón Lá', NULL, 'unverified', 'published', '2026-05-11 06:34:16', '2026-05-26 13:32:24', NULL),
(105, 'NỮ TÀI NHÂN', 'nu-tai-nhan', 31, NULL, 1, 249, NULL, 1, 2026, NULL, 'pending', NULL, NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/video/upload/v1778599142/songs/audio/105/tvpmydhlcxg8aato5xu6.mp3', 'songs/audio/105/tvpmydhlcxg8aato5xu6', NULL, NULL, NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/image/upload/v1778599114/songs/partners/0_5_mmpxfh.jpg', NULL, 4487661, 320, 'high', NULL, 0, 0, 1, 1, 7, 0, 0, 0, 0, 18, 'LONG NÓN LÁ ft KAYBO | NỮ TÀI NHÂN | Official Music Video', NULL, 'verified', 'published', '2026-05-12 08:18:54', '2026-05-26 13:32:24', NULL),
(106, 'TÂM GIAO x QUAN SƠN TỬU REMIX', 'tam-giao-x-quan-son-tuu-remix', 29, 9, 11, 197, NULL, 1, 2026, '[]', 'completed', '2026-05-18 22:50:57', NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/video/upload/v1779168849/songs/audio/106/kr2kdfmzx2wgipx5o3uz.mp3', 'songs/audio/106/kr2kdfmzx2wgipx5o3uz', NULL, NULL, NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/image/upload/v1779168800/songs/partners/0_6_ciakig.jpg', NULL, 3928744, 320, 'high', NULL, 0, 0, 1, 1, 6, 1, 0, 2, 0, 21, 'Long Nón Lá', NULL, 'unverified', 'published', '2026-05-18 22:33:50', '2026-05-26 13:32:24', NULL),
(107, 'Tâm Giao chill lofi', 'tam-giao-chill-lofi', 29, NULL, 11, 258, NULL, 1, 2026, '[]', 'completed', '2026-05-20 03:34:48', NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/video/upload/v1779272672/songs/audio/107/xgtibkl24a4zglupj08u.mp3', 'songs/audio/107/xgtibkl24a4zglupj08u', NULL, NULL, NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/image/upload/v1779272635/songs/partners/t%E1%BA%A3i_xu%E1%BB%91ng_a7up8x.jpg', NULL, 4371357, 320, 'high', NULL, 0, 0, 1, 1, 0, 0, 0, 0, 0, 21, 'Long Nón Lá', NULL, 'unverified', 'blocked', '2026-05-20 03:24:06', '2026-05-20 03:46:50', NULL),
(108, 'Chúng Ta Của Hiện Tại', 'chung-ta-cua-hien-tai', 1, NULL, 9, 302, NULL, 1, 2026, NULL, 'processing', NULL, NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/video/upload/v1779280375/songs/audio/108/syxfppr4o4h1ykyeiiyt.mp3', 'songs/audio/108/syxfppr4o4h1ykyeiiyt', NULL, NULL, NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/image/upload/v1779280348/songs/partners/1710493302970_300_nq9yrd.jpg', NULL, 4859199, 320, 'high', NULL, 0, 0, 1, 1, 3, 0, 0, 0, 0, 15, 'Sơn Tùng MTP', NULL, 'unverified', 'published', '2026-05-20 05:32:44', '2026-05-26 13:32:24', NULL),
(109, 'Chạy Ngay Đi', 'chay-ngay-i', 1, NULL, 9, 248, NULL, 1, 2026, NULL, 'processing', NULL, NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/video/upload/v1779280448/songs/audio/109/ivf1ltecvkhvqd1pgjju.mp3', 'songs/audio/109/ivf1ltecvkhvqd1pgjju', NULL, NULL, NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/image/upload/v1779280433/songs/partners/1526059033533_300_hbtgci.jpg', NULL, 4039419, 320, 'high', NULL, 0, 0, 1, 1, 3, 0, 0, 0, 0, 15, 'Sơn Tùng MTP', NULL, 'unverified', 'published', '2026-05-20 05:34:01', '2026-05-26 13:32:24', NULL),
(110, 'Chúng Ta Không Thuộc Về Nhau', 'chung-ta-khong-thuoc-ve-nhau', 1, NULL, 9, 233, NULL, 1, 2026, NULL, 'processing', NULL, NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/video/upload/v1779280547/songs/audio/110/nwql2g6tihgawst9sdgf.mp3', 'songs/audio/110/nwql2g6tihgawst9sdgf', NULL, NULL, NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/image/upload/v1779280530/songs/partners/t%E1%BA%A3i_xu%E1%BB%91ng_1_sbkmud.jpg', NULL, 3729401, 320, 'high', NULL, 0, 0, 1, 1, 2, 0, 0, 0, 0, 15, 'Sơn Tùng MTP', NULL, 'unverified', 'published', '2026-05-20 05:35:40', '2026-05-26 13:32:24', NULL),
(111, 'Em Của Ngày Hôm Qua', 'em-cua-ngay-hom-qua', 1, NULL, 9, 264, NULL, 1, 2026, NULL, 'processing', NULL, NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/video/upload/v1779280617/songs/audio/111/bbvdo4zo9zy4spw0m5x3.mp3', 'songs/audio/111/bbvdo4zo9zy4spw0m5x3', NULL, NULL, NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/image/upload/v1779280603/songs/partners/t%E1%BA%A3i_xu%E1%BB%91ng_2_wrlpt3.jpg', NULL, 4279912, 320, 'high', NULL, 0, 0, 1, 1, 2, 1, 0, 0, 0, 15, 'Sơn Tùng MTP', NULL, 'unverified', 'published', '2026-05-20 05:36:51', '2026-05-26 13:32:24', NULL),
(112, 'Muộn Rồi Mà Sao Còn', 'muon-roi-ma-sao-con', 1, NULL, 9, 276, NULL, 1, 2026, NULL, 'processing', NULL, NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/video/upload/v1779280678/songs/audio/112/oqw4nsbcmbh2aui493ne.mp3', 'songs/audio/112/oqw4nsbcmbh2aui493ne', NULL, NULL, NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/image/upload/v1779280665/songs/partners/1619691182261_300_ohltre.jpg', NULL, 4657580, 320, 'high', NULL, 0, 0, 1, 1, 2, 1, 0, 0, 0, 15, 'Sơn Tùng MTP', NULL, 'unverified', 'published', '2026-05-20 05:37:52', '2026-05-26 13:32:24', NULL),
(113, 'Buông Đối Tay Nhau Ra', 'buong-oi-tay-nhau-ra', 1, NULL, 9, 226, NULL, 1, 2026, NULL, 'processing', NULL, NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/video/upload/v1779280830/songs/audio/113/iq02h6zub0ie9lhf0mpf.mp3', 'songs/audio/113/iq02h6zub0ie9lhf0mpf', NULL, NULL, NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/image/upload/v1779280815/songs/partners/t%E1%BA%A3i_xu%E1%BB%91ng_3_fdoz1r.jpg', NULL, 3617802, 320, 'high', NULL, 0, 0, 1, 1, 2, 1, 0, 0, 0, 15, 'Sơn Tùng MTP', NULL, 'unverified', 'published', '2026-05-20 05:40:22', '2026-05-26 13:32:24', NULL),
(114, 'Nắng Ấm Xa Dần', 'nang-am-xa-dan', 1, NULL, 9, 188, NULL, 1, 2026, NULL, 'processing', NULL, NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/video/upload/v1779280972/songs/audio/114/hovht98p1yx34uooqohm.mp3', 'songs/audio/114/hovht98p1yx34uooqohm', NULL, NULL, NULL, NULL, 'https://res.cloudinary.com/djgps2bk9/image/upload/v1779280957/songs/partners/t%E1%BA%A3i_xu%E1%BB%91ng_4_nqdoff.jpg', NULL, 3047194, 320, 'high', NULL, 0, 0, 1, 1, 2, 1, 0, 1, 0, 15, 'Sơn Tùng MTP', NULL, 'unverified', 'published', '2026-05-20 05:42:44', '2026-05-26 13:32:24', NULL);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `song_artists`
--

CREATE TABLE `song_artists` (
  `id` bigint UNSIGNED NOT NULL,
  `song_id` bigint UNSIGNED NOT NULL,
  `artist_id` bigint UNSIGNED NOT NULL,
  `role` enum('main','featuring','composer','lyricist','producer','remixer') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'main',
  `order` int NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `song_downloads`
--

CREATE TABLE `song_downloads` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `song_id` bigint UNSIGNED NOT NULL,
  `quality` enum('standard','high','lossless') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `file_size` bigint DEFAULT NULL,
  `downloaded_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ip_address` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `device_info` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `song_downloads`
--

INSERT INTO `song_downloads` (`id`, `user_id`, `song_id`, `quality`, `file_size`, `downloaded_at`, `ip_address`, `device_info`) VALUES
(1, 2, 58, 'lossless', 4063537, '2026-04-30 22:15:01', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36');

--
-- Bẫy `song_downloads`
--
DELIMITER $$
CREATE TRIGGER `update_partner_revenue_on_download` AFTER INSERT ON `song_downloads` FOR EACH ROW BEGIN
    DECLARE v_partner_id BIGINT;
    DECLARE v_partner_share DECIMAL(5,2);
    DECLARE v_revenue DECIMAL(15,2);
    DECLARE v_partner_share_amount DECIMAL(15,2);
    DECLARE v_platform_share DECIMAL(15,2);
    DECLARE v_tax_amount DECIMAL(15,2);
    DECLARE v_net_payout DECIMAL(15,2);
    
    SELECT partner_id INTO v_partner_id
    FROM songs 
    WHERE id = NEW.song_id;
    
    IF v_partner_id IS NOT NULL THEN
        SET v_revenue = 500;
        
        SELECT COALESCE(revenue_share_percentage, 70) INTO v_partner_share
        FROM partners 
        WHERE id = v_partner_id;
        
        SET v_partner_share_amount = v_revenue * (v_partner_share / 100);
        SET v_platform_share = v_revenue - v_partner_share_amount;
        SET v_tax_amount = v_partner_share_amount * 0.1;
        SET v_net_payout = v_partner_share_amount - v_tax_amount;
        
        INSERT INTO partner_revenues (
            partner_id, song_id, period_type, period_start, period_end,
            total_downloads, subscription_revenue, total_revenue,
            partner_share_percentage, partner_share_amount,
            platform_share_amount, tax_amount, net_payout,
            status, calculated_at, updated_at
        )
        VALUES (
            v_partner_id, NEW.song_id, 'monthly',
            DATE_FORMAT(NEW.downloaded_at, '%Y-%m-01'),
            LAST_DAY(NEW.downloaded_at),
            1, v_revenue, v_revenue,
            v_partner_share, v_partner_share_amount,
            v_platform_share, v_tax_amount, v_net_payout,
            'calculated', NOW(), NOW()
        )
        ON DUPLICATE KEY UPDATE
            total_downloads = total_downloads + 1,
            subscription_revenue = subscription_revenue + v_revenue,
            total_revenue = total_revenue + v_revenue,
            partner_share_amount = partner_share_amount + v_partner_share_amount,
            platform_share_amount = platform_share_amount + v_platform_share,
            tax_amount = tax_amount + v_tax_amount,
            net_payout = net_payout + v_net_payout,
            updated_at = NOW();
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_song_downloads_count` AFTER INSERT ON `song_downloads` FOR EACH ROW BEGIN
    UPDATE songs 
    SET total_downloads = total_downloads + 1
    WHERE id = NEW.song_id;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `song_fingerprints`
--

CREATE TABLE `song_fingerprints` (
  `id` bigint UNSIGNED NOT NULL,
  `song_id` bigint UNSIGNED NOT NULL,
  `fingerprint_hash` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'fpcalc output hash',
  `fpcalc_raw_output` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'Raw output from fpcalc',
  `duration` int NOT NULL COMMENT 'Duration in seconds',
  `fpcalc_version` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `generated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Cache Chromaprint fingerprints for fast comparison';

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `song_likes`
--

CREATE TABLE `song_likes` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `song_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `song_likes`
--

INSERT INTO `song_likes` (`id`, `user_id`, `song_id`, `created_at`) VALUES
(16, 1, 49, '2026-04-28 15:58:25'),
(18, 1, 48, '2026-04-28 16:06:12'),
(19, 1, 52, '2026-04-28 16:06:30'),
(20, 1, 51, '2026-04-28 16:26:48'),
(21, 1, 40, '2026-04-28 16:36:29'),
(23, 1, 36, '2026-04-28 16:36:45'),
(24, 1, 38, '2026-04-28 16:38:25'),
(26, 1, 22, '2026-04-28 16:48:47'),
(27, 1, 47, '2026-04-29 08:33:33'),
(28, 5, 58, '2026-04-30 12:06:42'),
(29, 5, 57, '2026-04-30 12:06:59'),
(30, 5, 56, '2026-04-30 12:07:04'),
(31, 5, 55, '2026-04-30 12:07:17'),
(32, 1, 58, '2026-04-30 12:10:38'),
(33, 1, 37, '2026-05-01 05:49:12'),
(34, 2, 38, '2026-05-01 08:24:39'),
(35, 2, 37, '2026-05-01 08:30:48'),
(36, 2, 46, '2026-05-01 09:00:09'),
(37, 1, 25, '2026-05-03 06:46:02'),
(38, 1, 54, '2026-05-03 15:30:53'),
(39, 1, 104, '2026-05-11 13:41:56'),
(40, 2, 61, '2026-05-18 16:41:39'),
(41, 2, 114, '2026-05-20 14:24:52'),
(42, 2, 113, '2026-05-20 14:25:05'),
(43, 2, 112, '2026-05-20 16:00:18'),
(44, 2, 111, '2026-05-20 16:17:10'),
(45, 2, 49, '2026-05-21 05:48:58'),
(46, 1, 106, '2026-05-21 12:34:26'),
(47, 1, 35, '2026-05-21 12:40:24'),
(48, 1, 61, '2026-05-21 12:42:53');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `song_plays`
--

CREATE TABLE `song_plays` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED DEFAULT NULL,
  `song_id` bigint UNSIGNED NOT NULL,
  `playlist_id` bigint UNSIGNED DEFAULT NULL,
  `played_duration` int DEFAULT '0' COMMENT 'Seconds played',
  `play_percentage` decimal(5,2) DEFAULT '0.00' COMMENT 'Percentage of song played',
  `is_completed` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Played > 80%',
  `played_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `device_type` enum('web','mobile','desktop','tablet','smart_speaker','car') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `device_info` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ip_address` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `country` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `city` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `song_plays`
--

INSERT INTO `song_plays` (`id`, `user_id`, `song_id`, `playlist_id`, `played_duration`, `play_percentage`, `is_completed`, `played_at`, `device_type`, `device_info`, `ip_address`, `country`, `city`) VALUES
(1, NULL, 37, NULL, 30, 9.24, 0, '2026-04-06 01:15:26', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(2, NULL, 34, NULL, 30, 7.51, 0, '2026-04-06 01:17:27', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(3, NULL, 37, NULL, 30, 9.21, 0, '2026-04-06 01:23:06', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(4, NULL, 34, NULL, 30, 7.51, 0, '2026-04-06 01:27:24', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(5, NULL, 37, NULL, 30, 9.20, 0, '2026-04-06 01:41:06', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(6, NULL, 36, NULL, 30, 13.17, 0, '2026-04-06 01:46:35', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(7, NULL, 35, NULL, 30, 11.62, 0, '2026-04-06 01:50:23', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(8, NULL, 34, NULL, 30, 7.51, 0, '2026-04-06 01:54:44', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(9, NULL, 29, NULL, 30, 12.32, 0, '2026-04-06 02:01:25', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(10, NULL, 34, NULL, 30, 7.54, 0, '2026-04-06 02:10:59', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(11, NULL, 34, NULL, 30, 7.50, 0, '2026-04-06 07:38:56', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(12, NULL, 34, NULL, 30, 7.54, 0, '2026-04-06 07:51:08', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(13, NULL, 37, NULL, 30, 9.18, 0, '2026-04-06 07:57:49', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(14, NULL, 34, NULL, 30, 7.52, 0, '2026-04-06 08:02:06', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(15, NULL, 35, NULL, 30, 11.59, 0, '2026-04-06 08:06:01', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(16, NULL, 36, NULL, 30, 13.24, 0, '2026-04-06 08:10:22', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(17, NULL, 29, NULL, 30, 12.25, 0, '2026-04-06 08:14:11', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(18, NULL, 28, NULL, 30, 12.92, 0, '2026-04-06 08:18:16', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(19, NULL, 21, NULL, 30, 14.60, 0, '2026-04-06 08:22:09', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(20, NULL, 20, NULL, 30, 10.12, 0, '2026-04-06 08:25:36', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(21, NULL, 37, NULL, 30, 9.21, 0, '2026-04-06 08:30:32', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(22, NULL, 26, NULL, 30, 11.51, 0, '2026-04-06 08:38:14', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(23, NULL, 34, NULL, 30, 7.50, 0, '2026-04-06 08:42:34', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(24, NULL, 35, NULL, 30, 11.59, 0, '2026-04-06 08:44:22', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(25, NULL, 36, NULL, 30, 13.14, 0, '2026-04-06 08:50:41', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(26, NULL, 29, NULL, 30, 12.23, 0, '2026-04-06 08:54:29', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(27, NULL, 28, NULL, 30, 12.94, 0, '2026-04-06 08:58:35', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(28, NULL, 21, NULL, 30, 14.69, 0, '2026-04-06 09:02:28', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(29, NULL, 20, NULL, 30, 10.12, 0, '2026-04-06 09:05:54', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(30, NULL, 37, NULL, 30, 9.21, 0, '2026-04-06 09:10:52', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(31, NULL, 37, NULL, 30, 9.25, 0, '2026-04-06 09:24:12', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(32, NULL, 37, NULL, 30, 9.20, 0, '2026-04-06 09:33:54', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(33, NULL, 37, NULL, 30, 9.19, 0, '2026-04-06 22:23:13', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(34, NULL, 37, NULL, 30, 9.23, 0, '2026-04-06 22:47:17', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(35, NULL, 36, NULL, 30, 13.15, 0, '2026-04-06 22:52:45', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(36, NULL, 35, NULL, 30, 11.62, 0, '2026-04-06 22:56:10', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(37, NULL, 29, NULL, 30, 12.30, 0, '2026-04-06 23:02:37', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(38, NULL, 34, NULL, 30, 7.53, 0, '2026-04-06 23:16:50', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(39, NULL, 37, NULL, 31, 9.57, 0, '2026-04-09 01:49:14', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(40, NULL, 36, NULL, 30, 13.15, 0, '2026-04-09 01:57:19', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(41, NULL, 25, NULL, 30, 12.41, 0, '2026-04-09 02:06:22', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(42, NULL, 34, NULL, 30, 7.52, 0, '2026-04-09 02:08:44', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(43, NULL, 29, NULL, 30, 12.21, 0, '2026-04-09 02:15:25', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(44, NULL, 37, NULL, 30, 9.22, 0, '2026-04-11 20:54:43', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(45, NULL, 37, NULL, 30, 9.21, 0, '2026-04-12 00:47:27', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(46, NULL, 37, NULL, 30, 9.24, 0, '2026-04-12 04:35:13', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(47, NULL, 36, NULL, 30, 13.25, 0, '2026-04-12 04:40:40', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(48, NULL, 37, NULL, 30, 9.25, 0, '2026-04-13 00:27:19', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(49, NULL, 36, NULL, 30, 13.22, 0, '2026-04-13 00:32:51', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(50, NULL, 35, NULL, 30, 11.61, 0, '2026-04-13 00:36:39', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(51, NULL, 34, NULL, 30, 7.53, 0, '2026-04-13 00:40:59', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(52, NULL, 35, NULL, 30, 11.57, 0, '2026-04-13 01:25:40', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(53, NULL, 37, NULL, 30, 9.24, 0, '2026-04-13 01:53:57', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(54, NULL, 36, NULL, 30, 13.20, 0, '2026-04-13 01:56:48', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(55, NULL, 35, NULL, 30, 11.62, 0, '2026-04-13 01:59:52', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(56, NULL, 35, NULL, 30, 11.58, 0, '2026-04-13 02:17:51', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(57, NULL, 35, NULL, 30, 11.58, 0, '2026-04-13 02:31:35', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(58, NULL, 36, NULL, 30, 13.22, 0, '2026-04-13 02:35:55', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(59, NULL, 37, NULL, 30, 9.23, 0, '2026-04-13 02:47:11', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(60, NULL, 35, NULL, 30, 11.60, 0, '2026-04-13 03:13:35', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(61, NULL, 36, NULL, 30, 13.23, 0, '2026-04-13 03:17:46', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(62, NULL, 22, NULL, 30, 9.60, 0, '2026-04-13 03:41:20', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(63, NULL, 28, NULL, 30, 12.95, 0, '2026-04-13 03:46:37', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(64, NULL, 36, NULL, 30, 13.23, 0, '2026-04-13 03:50:30', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(65, NULL, 21, NULL, 30, 14.66, 0, '2026-04-13 03:54:20', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(66, NULL, 34, NULL, 30, 7.51, 0, '2026-04-13 03:57:46', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(67, NULL, 25, NULL, 30, 12.45, 0, '2026-04-13 04:04:29', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(68, NULL, 26, NULL, 30, 11.52, 0, '2026-04-13 04:08:31', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(69, NULL, 34, NULL, 30, 7.53, 0, '2026-04-13 06:28:19', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(70, NULL, 29, NULL, 30, 12.23, 0, '2026-04-13 06:33:29', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(71, NULL, 35, NULL, 30, 11.59, 0, '2026-04-13 06:34:22', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(72, NULL, 36, NULL, 30, 13.19, 0, '2026-04-13 06:38:39', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(73, NULL, 29, NULL, 30, 12.24, 0, '2026-04-13 06:42:27', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(74, NULL, 28, NULL, 30, 12.97, 0, '2026-04-13 06:46:34', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(75, NULL, 29, NULL, 30, 12.25, 0, '2026-04-13 06:51:19', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(76, NULL, 37, NULL, 30, 9.25, 0, '2026-04-13 06:52:34', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(77, NULL, 36, NULL, 30, 13.18, 0, '2026-04-13 06:58:02', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(78, NULL, 21, NULL, 30, 14.64, 0, '2026-04-13 07:02:01', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(79, NULL, 20, NULL, 30, 10.16, 0, '2026-04-13 07:05:28', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(80, NULL, 37, NULL, 30, 9.18, 0, '2026-04-13 07:10:25', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(81, NULL, 26, NULL, 30, 11.50, 0, '2026-04-13 07:15:53', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(82, NULL, 34, NULL, 30, 7.52, 0, '2026-04-14 22:31:30', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(83, NULL, 26, NULL, 30, 11.58, 0, '2026-04-14 23:06:04', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(84, NULL, 29, NULL, 30, 12.25, 0, '2026-04-14 23:09:06', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(85, NULL, 28, NULL, 30, 12.96, 0, '2026-04-14 23:13:12', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(86, NULL, 26, NULL, 30, 11.54, 0, '2026-04-14 23:17:06', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(87, NULL, 25, NULL, 30, 12.41, 0, '2026-04-14 23:21:28', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(88, NULL, 35, NULL, 30, 11.59, 0, '2026-04-14 23:25:00', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(89, NULL, 25, NULL, 30, 12.51, 0, '2026-04-14 23:27:16', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(90, NULL, 20, NULL, 30, 10.19, 0, '2026-04-14 23:28:26', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(91, NULL, 35, NULL, 30, 11.61, 0, '2026-04-14 23:35:01', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(92, NULL, 34, NULL, 30, 7.51, 0, '2026-04-14 23:39:21', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(93, NULL, 29, NULL, 30, 12.31, 0, '2026-04-14 23:46:04', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(94, NULL, 28, NULL, 30, 12.90, 0, '2026-04-14 23:50:10', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(95, NULL, 26, NULL, 30, 11.56, 0, '2026-04-14 23:54:04', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(96, NULL, 25, NULL, 30, 12.49, 0, '2026-04-14 23:58:25', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(97, NULL, 35, NULL, 30, 11.57, 0, '2026-04-14 23:59:10', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(98, NULL, 29, NULL, 30, 12.24, 0, '2026-04-15 00:03:29', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(99, NULL, 28, NULL, 30, 12.94, 0, '2026-04-15 00:07:35', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(100, NULL, 35, NULL, 30, 11.58, 0, '2026-04-15 01:15:45', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(101, NULL, 29, NULL, 30, 12.26, 0, '2026-04-15 01:19:51', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(102, NULL, 28, NULL, 30, 12.90, 0, '2026-04-15 01:23:55', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(103, NULL, 36, NULL, 30, 13.23, 0, '2026-04-15 02:45:43', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(104, NULL, 35, NULL, 30, 11.59, 0, '2026-04-16 03:12:23', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(105, NULL, 29, NULL, 30, 12.30, 0, '2026-04-16 03:16:44', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(106, NULL, 38, NULL, 30, 12.06, 0, '2026-04-16 03:21:13', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(107, NULL, 37, NULL, 30, 9.18, 0, '2026-04-16 03:25:22', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(108, NULL, 36, NULL, 30, 13.24, 0, '2026-04-16 03:30:50', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(109, NULL, 35, NULL, 30, 11.55, 0, '2026-04-16 03:34:38', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(110, NULL, 34, NULL, 30, 7.49, 0, '2026-04-16 03:38:59', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(111, NULL, 29, NULL, 30, 12.29, 0, '2026-04-16 03:42:28', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(112, NULL, 35, NULL, 30, 11.59, 0, '2026-04-17 00:32:41', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(113, NULL, 38, NULL, 30, 12.14, 0, '2026-04-17 02:27:23', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(114, NULL, 40, NULL, 30, 11.90, 0, '2026-04-17 02:31:08', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(115, NULL, 39, NULL, 30, 17.69, 0, '2026-04-17 19:33:18', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(117, NULL, 42, NULL, 30, 10.15, 0, '2026-04-17 23:01:56', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(118, NULL, 40, NULL, 30, 11.98, 0, '2026-04-17 23:06:55', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(119, NULL, 39, NULL, 30, 17.58, 0, '2026-04-17 23:12:21', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(120, NULL, 38, NULL, 30, 12.13, 0, '2026-04-17 23:15:13', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(121, NULL, 42, NULL, 30, 10.12, 0, '2026-04-18 01:38:26', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(122, NULL, 40, NULL, 30, 11.93, 0, '2026-04-18 01:43:26', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(123, NULL, 36, NULL, 30, 13.18, 0, '2026-04-18 01:46:04', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(124, NULL, 40, NULL, 30, 11.93, 0, '2026-04-18 06:36:17', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(125, NULL, 39, NULL, 30, 17.69, 0, '2026-04-18 06:39:57', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(126, NULL, 38, NULL, 30, 12.07, 0, '2026-04-18 06:42:59', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(127, NULL, 42, NULL, 30, 10.12, 0, '2026-04-18 06:44:09', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(128, NULL, 40, NULL, 30, 11.95, 0, '2026-04-18 06:49:08', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(129, NULL, 39, NULL, 30, 17.59, 0, '2026-04-18 06:53:21', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(130, NULL, 38, NULL, 30, 12.09, 0, '2026-04-18 06:56:12', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(131, NULL, 40, NULL, 30, 11.98, 0, '2026-04-18 08:30:13', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(132, NULL, 42, NULL, 30, 10.11, 0, '2026-04-19 20:52:51', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(133, NULL, 40, NULL, 30, 11.96, 0, '2026-04-19 21:02:10', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(134, NULL, 39, NULL, 30, 17.66, 0, '2026-04-19 21:06:23', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(135, NULL, 37, NULL, 30, 9.17, 0, '2026-04-19 21:07:50', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(136, NULL, 36, NULL, 30, 13.18, 0, '2026-04-19 21:12:21', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(137, NULL, 35, NULL, 30, 11.57, 0, '2026-04-19 21:14:05', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(138, NULL, 34, NULL, 30, 7.50, 0, '2026-04-19 21:18:26', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(139, NULL, 29, NULL, 30, 12.25, 0, '2026-04-19 21:25:07', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(140, NULL, 28, NULL, 30, 12.90, 0, '2026-04-19 21:29:13', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(141, NULL, 42, NULL, 30, 10.06, 0, '2026-04-20 00:09:08', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(142, NULL, 42, NULL, 30, 10.11, 0, '2026-04-20 20:14:10', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(143, NULL, 42, NULL, 30, 10.12, 0, '2026-04-20 23:20:26', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(144, NULL, 40, NULL, 30, 11.96, 0, '2026-04-20 23:25:24', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(145, NULL, 39, NULL, 30, 17.65, 0, '2026-04-20 23:29:36', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(146, NULL, 42, NULL, 30, 10.07, 0, '2026-04-21 03:00:43', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(147, NULL, 43, NULL, 30, 10.26, 0, '2026-04-21 07:07:09', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(148, NULL, 44, NULL, 30, 15.01, 0, '2026-04-21 07:13:11', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(149, NULL, 47, NULL, 30, 9.38, 0, '2026-04-21 07:18:18', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(150, NULL, 46, NULL, 30, 11.05, 0, '2026-04-21 07:23:40', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(151, NULL, 45, NULL, 30, 14.10, 0, '2026-04-21 07:28:13', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(152, NULL, 47, NULL, 30, 9.37, 0, '2026-04-21 07:48:56', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(153, NULL, 46, NULL, 30, 11.12, 0, '2026-04-21 07:57:16', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0', '127.0.0.1', NULL, NULL),
(154, NULL, 47, NULL, 30, 9.33, 0, '2026-04-24 23:15:16', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(155, NULL, 46, NULL, 30, 11.09, 0, '2026-04-24 23:21:35', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(156, NULL, 42, NULL, 30, 10.10, 0, '2026-04-24 23:25:36', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(157, NULL, 48, NULL, 30, 12.16, 0, '2026-04-24 23:50:14', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(158, NULL, 49, NULL, 30, 12.23, 0, '2026-04-24 23:54:52', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(159, NULL, 48, NULL, 30, 12.15, 0, '2026-04-24 23:59:00', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(160, NULL, 49, NULL, 30, 12.20, 0, '2026-04-25 00:04:06', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(161, NULL, 48, NULL, 30, 12.14, 0, '2026-04-25 00:08:13', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(162, NULL, 46, NULL, 30, 11.10, 0, '2026-04-25 00:12:45', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(163, NULL, 49, NULL, 30, 12.33, 0, '2026-04-25 01:26:28', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(164, 1, 49, NULL, 30, 12.18, 0, '2026-04-26 00:37:59', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(165, 1, 48, NULL, 30, 12.11, 0, '2026-04-26 00:42:07', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(166, 1, 47, NULL, 30, 9.29, 0, '2026-04-26 00:46:16', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(167, 1, 46, NULL, 30, 11.05, 0, '2026-04-26 00:51:39', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(168, 1, 45, NULL, 30, 14.16, 0, '2026-04-26 00:56:12', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(169, 1, 44, NULL, 30, 14.95, 0, '2026-04-26 00:59:45', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(170, 1, 43, NULL, 30, 10.26, 0, '2026-04-26 01:03:05', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(171, 1, 42, NULL, 30, 10.04, 0, '2026-04-26 01:07:58', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(172, 1, 40, NULL, 30, 11.97, 0, '2026-04-26 01:12:58', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(173, 1, 39, NULL, 30, 17.55, 0, '2026-04-26 01:17:10', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(174, 1, 38, NULL, 30, 12.10, 0, '2026-04-26 01:20:01', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(175, 1, 37, NULL, 30, 9.23, 0, '2026-04-26 01:24:11', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(176, 1, 36, NULL, 30, 13.16, 0, '2026-04-26 01:29:39', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(177, 1, 35, NULL, 30, 11.61, 0, '2026-04-26 01:33:29', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(178, 1, 49, NULL, 30, 12.16, 0, '2026-04-26 01:37:11', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(179, 1, 50, NULL, 30, 16.12, 0, '2026-04-26 02:46:29', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(180, 1, 49, NULL, 30, 12.18, 0, '2026-04-26 02:49:37', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(181, 1, 48, NULL, 30, 12.13, 0, '2026-04-26 02:53:44', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(182, 1, 47, NULL, 30, 9.31, 0, '2026-04-26 02:57:53', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(183, 1, 46, NULL, 30, 11.12, 0, '2026-04-26 03:03:16', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(184, 19, 50, NULL, 30, 16.25, 0, '2026-04-26 03:24:01', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(185, 19, 49, NULL, 30, 12.21, 0, '2026-04-26 03:27:09', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(186, 19, 48, NULL, 30, 12.12, 0, '2026-04-26 03:31:16', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(187, 2, 50, NULL, 30, 16.14, 0, '2026-04-26 21:59:36', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(188, 2, 49, NULL, 30, 12.24, 0, '2026-04-26 22:02:23', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(189, 2, 48, NULL, 30, 12.19, 0, '2026-04-26 22:06:55', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(190, 2, 47, NULL, 30, 9.32, 0, '2026-04-26 22:11:03', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(191, 2, 46, NULL, 30, 11.10, 0, '2026-04-26 22:16:27', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(192, 2, 45, NULL, 30, 14.15, 0, '2026-04-26 22:21:01', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(193, 2, 44, NULL, 30, 14.97, 0, '2026-04-26 22:24:35', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(194, 2, 43, NULL, 30, 10.31, 0, '2026-04-26 22:27:56', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(195, 2, 42, NULL, 30, 10.06, 0, '2026-04-26 22:32:50', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(196, 2, 40, NULL, 30, 11.93, 0, '2026-04-26 22:37:50', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(197, 1, 49, NULL, 30, 12.20, 0, '2026-04-27 01:45:55', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(198, 1, 48, NULL, 30, 12.19, 0, '2026-04-27 01:50:28', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(199, 1, 47, NULL, 30, 9.32, 0, '2026-04-27 01:54:37', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(200, 1, 46, NULL, 30, 11.03, 0, '2026-04-27 02:00:00', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(201, 1, 45, NULL, 30, 14.12, 0, '2026-04-27 02:04:32', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(202, 1, 44, NULL, 30, 14.99, 0, '2026-04-27 02:08:05', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(203, 1, 49, NULL, 30, 12.18, 0, '2026-04-27 07:25:02', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(204, 19, 52, NULL, 30, 11.64, 0, '2026-04-27 07:40:38', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(205, 19, 51, NULL, 30, 11.95, 0, '2026-04-27 07:44:59', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(206, 19, 49, NULL, 30, 12.18, 0, '2026-04-27 07:49:11', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(207, 19, 48, NULL, 30, 12.13, 0, '2026-04-27 07:53:19', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(208, 1, 52, NULL, 30, 11.61, 0, '2026-04-27 08:05:37', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(209, 1, 51, NULL, 30, 12.03, 0, '2026-04-27 08:09:57', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(210, 1, 50, NULL, 30, 16.14, 0, '2026-04-27 08:14:09', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(211, 1, 49, NULL, 30, 12.18, 0, '2026-04-27 08:17:16', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(212, 1, 52, NULL, 30, 11.63, 0, '2026-04-27 08:20:35', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(213, 1, 51, NULL, 30, 11.94, 0, '2026-04-27 08:28:52', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(214, 1, 50, NULL, 30, 16.14, 0, '2026-04-27 08:33:04', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(215, 1, 51, NULL, 30, 12.01, 0, '2026-04-27 08:34:59', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(216, 1, 50, NULL, 30, 16.16, 0, '2026-04-27 08:39:11', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(217, 1, 49, NULL, 30, 12.22, 0, '2026-04-27 08:42:17', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(218, 1, 47, NULL, 30, 9.37, 0, '2026-04-27 09:00:34', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(219, 1, 49, NULL, 30, 12.15, 0, '2026-04-28 08:51:02', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(220, 1, 49, NULL, 30, 12.21, 0, '2026-04-28 08:58:02', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(221, 1, 52, NULL, 30, 11.59, 0, '2026-04-28 09:06:55', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(222, 1, 52, NULL, 30, 11.58, 0, '2026-04-28 09:12:05', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(223, 1, 51, NULL, 30, 11.96, 0, '2026-04-28 09:16:26', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(224, 1, 52, NULL, 30, 11.67, 0, '2026-04-28 09:17:06', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(225, 1, 51, NULL, 30, 11.96, 0, '2026-04-28 09:26:01', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(226, 1, 50, NULL, 30, 16.17, 0, '2026-04-28 09:28:20', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(227, 1, 49, NULL, 30, 12.15, 0, '2026-04-28 09:31:26', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(228, 1, 40, NULL, 30, 11.97, 0, '2026-04-28 09:35:53', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(229, 1, 36, NULL, 30, 13.22, 0, '2026-04-28 09:37:15', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(230, 1, 50, NULL, 30, 16.15, 0, '2026-04-28 09:40:29', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(231, 1, 20, NULL, 30, 10.17, 0, '2026-04-28 09:42:59', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(232, 1, 22, NULL, 30, 9.57, 0, '2026-04-28 22:16:32', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(233, 1, 46, NULL, 30, 11.08, 0, '2026-04-28 22:21:55', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(234, 1, 45, NULL, 30, 14.12, 0, '2026-04-28 22:26:27', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(235, 1, 52, NULL, 30, 11.65, 0, '2026-04-29 01:18:07', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(236, 1, 51, NULL, 30, 11.93, 0, '2026-04-29 01:22:26', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(237, 1, 50, NULL, 30, 16.26, 0, '2026-04-29 01:26:38', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(238, 1, 49, NULL, 30, 12.14, 0, '2026-04-29 01:29:44', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(239, 1, 47, NULL, 30, 9.34, 0, '2026-04-29 01:33:53', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(240, 1, 45, NULL, 30, 14.19, 0, '2026-04-29 01:38:54', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(241, 1, 44, NULL, 30, 14.97, 0, '2026-04-29 01:42:29', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(242, 1, 43, NULL, 30, 10.30, 0, '2026-04-29 01:45:50', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(243, 1, 42, NULL, 30, 10.07, 0, '2026-04-29 01:54:34', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(244, 1, 50, 1, 30, 16.26, 0, '2026-04-29 03:04:06', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(245, 1, 51, NULL, 30, 11.99, 0, '2026-04-29 03:07:11', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(246, 1, 50, 1, 30, 16.19, 0, '2026-04-29 03:09:34', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(247, 1, 46, NULL, 30, 11.08, 0, '2026-04-29 03:12:40', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(248, 1, 51, NULL, 30, 11.95, 0, '2026-04-29 03:17:12', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(249, 1, 50, NULL, 30, 16.23, 0, '2026-04-29 06:39:12', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(250, 1, 49, NULL, 30, 12.24, 0, '2026-04-29 06:42:19', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(251, 1, 48, NULL, 30, 12.17, 0, '2026-04-29 06:46:29', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(252, 1, 47, NULL, 30, 9.36, 0, '2026-04-29 06:50:41', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(253, 5, 52, NULL, 30, 11.60, 0, '2026-04-29 08:54:20', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(254, 5, 53, NULL, 30, 12.30, 0, '2026-04-30 04:47:30', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(255, 5, 57, NULL, 30, 10.75, 0, '2026-04-30 04:52:08', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(256, 5, 56, NULL, 30, 11.54, 0, '2026-04-30 04:53:04', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(257, 5, 55, NULL, 30, 7.80, 0, '2026-04-30 04:57:25', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(258, 1, 58, NULL, 30, 12.24, 0, '2026-04-30 05:04:48', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(259, 5, 55, NULL, 30, 7.75, 0, '2026-04-30 05:07:55', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(260, 5, 54, NULL, 30, 14.30, 0, '2026-04-30 05:14:23', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(261, 5, 53, NULL, 30, 12.25, 0, '2026-04-30 05:17:55', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(262, 5, 52, NULL, 30, 11.62, 0, '2026-04-30 05:22:01', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(263, 5, 58, NULL, 30, 12.27, 0, '2026-04-30 05:54:13', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(264, 5, 53, NULL, 30, 12.25, 0, '2026-04-30 06:44:22', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(265, 5, 56, NULL, 30, 11.60, 0, '2026-04-30 06:48:29', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(266, 1, 55, NULL, 30, 7.78, 0, '2026-04-30 06:53:21', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(267, 1, 55, NULL, 30, 7.77, 0, '2026-04-30 07:19:47', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(268, 1, 54, NULL, 30, 14.35, 0, '2026-04-30 07:26:15', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(269, 1, 53, NULL, 30, 12.28, 0, '2026-04-30 07:29:47', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(270, 1, 52, NULL, 30, 11.67, 0, '2026-04-30 07:33:53', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(271, 1, 37, NULL, 30, 9.26, 0, '2026-04-30 22:49:00', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(272, 1, 58, NULL, 30, 12.30, 0, '2026-04-30 22:59:06', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(273, 2, 56, NULL, 30, 11.58, 0, '2026-05-01 00:59:23', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(274, 2, 55, NULL, 30, 7.79, 0, '2026-05-01 01:03:24', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(275, 2, 38, NULL, 30, 12.14, 0, '2026-05-01 01:24:59', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(276, 2, 37, NULL, 30, 9.25, 0, '2026-05-01 01:29:09', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(277, 2, 36, NULL, 30, 13.21, 0, '2026-05-01 01:34:37', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(278, 2, 50, NULL, 30, 16.18, 0, '2026-05-01 01:42:04', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(279, 2, 49, NULL, 30, 12.14, 0, '2026-05-01 01:45:12', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL);
INSERT INTO `song_plays` (`id`, `user_id`, `song_id`, `playlist_id`, `played_duration`, `play_percentage`, `is_completed`, `played_at`, `device_type`, `device_info`, `ip_address`, `country`, `city`) VALUES
(280, 2, 48, NULL, 30, 12.11, 0, '2026-05-01 01:49:19', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(281, 2, 47, NULL, 30, 9.33, 0, '2026-05-01 01:53:28', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(282, 2, 46, NULL, 30, 11.09, 0, '2026-05-01 01:58:52', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(283, 2, 45, NULL, 30, 14.13, 0, '2026-05-01 02:03:25', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(284, 2, 44, NULL, 30, 14.95, 0, '2026-05-01 02:07:01', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(285, 2, 43, NULL, 30, 10.33, 0, '2026-05-01 02:10:21', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(286, 2, 42, NULL, 30, 10.04, 0, '2026-05-01 02:15:14', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(287, 2, 40, NULL, 30, 11.90, 0, '2026-05-01 02:20:13', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(288, 2, 58, NULL, 30, 12.30, 0, '2026-05-01 07:26:00', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(289, 2, 57, NULL, 30, 10.75, 0, '2026-05-01 07:30:06', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(290, 2, 56, NULL, 30, 11.53, 0, '2026-05-01 07:34:48', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(291, 2, 55, NULL, 30, 7.75, 0, '2026-05-01 07:39:10', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(292, 2, 54, NULL, 30, 14.32, 0, '2026-05-01 07:45:41', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(293, 2, 53, NULL, 30, 12.30, 0, '2026-05-01 07:49:10', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(294, 2, 52, NULL, 30, 11.59, 0, '2026-05-01 07:53:19', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(295, 1, 50, 1, 30, 16.12, 0, '2026-05-01 10:04:44', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(296, 1, 51, NULL, 30, 12.04, 0, '2026-05-01 10:07:51', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(297, 1, 46, NULL, 30, 11.06, 0, '2026-05-01 10:12:01', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(298, 2, 29, NULL, 30, 12.24, 0, '2026-05-02 07:36:47', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(299, 1, 25, NULL, 30, 12.47, 0, '2026-05-02 23:46:10', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(300, 1, 44, NULL, 30, 14.96, 0, '2026-05-02 23:50:13', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(301, 1, 48, NULL, 30, 12.12, 0, '2026-05-02 23:53:34', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(302, 1, 56, NULL, 30, 11.53, 0, '2026-05-02 23:57:43', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(303, 1, 58, NULL, 30, 12.31, 0, '2026-05-03 00:02:04', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(304, 1, 20, NULL, 30, 10.14, 0, '2026-05-03 00:06:10', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(305, 1, 28, NULL, 30, 12.98, 0, '2026-05-03 00:11:08', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(306, 1, 51, NULL, 30, 11.94, 0, '2026-05-03 00:15:01', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(307, 1, 39, NULL, 30, 17.64, 0, '2026-05-03 00:19:13', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(308, 1, 50, NULL, 30, 16.25, 0, '2026-05-03 00:24:31', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(309, 1, 49, NULL, 30, 12.25, 0, '2026-05-03 00:27:37', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(310, 1, 48, NULL, 30, 12.17, 0, '2026-05-03 00:31:44', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(311, 1, 47, NULL, 30, 9.34, 0, '2026-05-03 00:35:52', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(312, 1, 46, NULL, 30, 11.09, 0, '2026-05-03 00:41:16', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(313, 1, 45, NULL, 30, 14.10, 0, '2026-05-03 00:45:48', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(314, 1, 44, NULL, 30, 15.00, 0, '2026-05-03 00:49:22', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(315, 1, 43, NULL, 30, 10.26, 0, '2026-05-03 00:52:43', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(316, 1, 42, NULL, 30, 10.06, 0, '2026-05-03 00:57:37', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(317, 1, 40, NULL, 30, 11.90, 0, '2026-05-03 01:02:36', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(318, 1, 39, NULL, 30, 17.84, 0, '2026-05-03 01:06:50', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(319, 1, 38, NULL, 30, 12.08, 0, '2026-05-03 01:09:41', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(320, 1, 37, NULL, 30, 9.17, 0, '2026-05-03 01:13:53', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(321, 1, 49, NULL, 30, 12.21, 0, '2026-05-03 06:27:26', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(322, 1, 60, NULL, 30, 14.81, 0, '2026-05-03 06:38:29', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(323, 1, 59, NULL, 30, 14.00, 0, '2026-05-03 06:41:53', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(324, 1, 26, NULL, 30, 11.49, 0, '2026-05-03 06:46:51', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(325, 1, 61, 1, 30, 11.67, 0, '2026-05-03 06:47:24', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(326, 1, 42, NULL, 30, 10.12, 0, '2026-05-03 06:51:44', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(327, 1, 40, NULL, 30, 11.97, 0, '2026-05-03 06:56:43', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(328, 1, 38, NULL, 30, 12.14, 0, '2026-05-03 07:00:56', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(329, 1, 50, 1, 30, 16.22, 0, '2026-05-03 07:18:55', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(330, 1, 51, NULL, 30, 12.02, 0, '2026-05-03 07:22:02', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(331, 2, 46, 1, 30, 11.03, 0, '2026-05-03 07:26:49', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(332, 2, 56, NULL, 30, 11.56, 0, '2026-05-03 07:31:23', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(333, 2, 55, NULL, 30, 7.73, 0, '2026-05-03 08:27:37', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(334, 1, 54, NULL, 30, 14.23, 0, '2026-05-03 08:28:13', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(335, 1, 53, NULL, 30, 12.30, 0, '2026-05-03 08:31:44', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(336, 1, 42, 1, 30, 10.10, 0, '2026-05-03 08:34:10', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(337, 1, 50, 1, 30, 16.22, 0, '2026-05-04 07:40:22', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(338, 1, 61, NULL, 30, 11.59, 0, '2026-05-05 06:29:29', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(339, 1, 60, NULL, 30, 14.85, 0, '2026-05-05 06:33:46', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(340, 1, 61, NULL, 30, 11.61, 0, '2026-05-05 06:36:54', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(341, 1, 60, NULL, 30, 14.81, 0, '2026-05-05 06:41:10', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(342, 1, 59, NULL, 30, 13.97, 0, '2026-05-05 06:44:32', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(343, 1, 58, NULL, 30, 12.25, 0, '2026-05-05 06:48:08', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(344, 1, 57, NULL, 30, 10.72, 0, '2026-05-05 06:52:14', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(345, 1, 56, NULL, 30, 11.60, 0, '2026-05-05 06:56:55', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(346, 1, 55, NULL, 30, 7.76, 0, '2026-05-05 07:01:16', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(347, 1, 47, NULL, 30, 9.44, 0, '2026-05-05 07:08:41', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(348, 1, 46, NULL, 30, 11.10, 0, '2026-05-05 07:14:04', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(349, 1, 45, NULL, 30, 14.13, 0, '2026-05-05 07:18:38', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(350, 1, 44, NULL, 30, 15.00, 0, '2026-05-05 07:22:10', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(351, 1, 43, NULL, 30, 10.31, 0, '2026-05-05 07:25:31', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(352, 1, 42, NULL, 30, 10.09, 0, '2026-05-05 07:30:23', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(353, 1, 61, NULL, 30, 11.58, 0, '2026-05-05 19:12:50', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(354, 1, 61, NULL, 30, 11.59, 0, '2026-05-05 19:37:25', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(355, 1, 60, NULL, 30, 14.85, 0, '2026-05-05 19:39:11', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(356, 1, 59, NULL, 30, 13.91, 0, '2026-05-05 19:42:34', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(357, 1, 58, NULL, 30, 12.32, 0, '2026-05-05 19:58:21', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(358, 1, 57, NULL, 30, 10.75, 0, '2026-05-05 20:01:52', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(359, 1, 56, NULL, 30, 11.53, 0, '2026-05-05 20:06:33', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(360, 1, 55, NULL, 30, 7.73, 0, '2026-05-05 20:10:54', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(361, 1, 54, NULL, 30, 14.34, 0, '2026-05-05 20:17:22', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(368, 1, 61, NULL, 30, 11.59, 0, '2026-05-06 03:02:24', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(369, 1, 60, NULL, 30, 14.81, 0, '2026-05-06 03:06:44', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(370, 1, 61, NULL, 30, 11.65, 0, '2026-05-06 04:00:15', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(371, 1, 60, NULL, 30, 14.90, 0, '2026-05-06 04:04:36', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(372, 1, 59, NULL, 30, 13.93, 0, '2026-05-06 04:07:59', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(373, 1, 61, NULL, 30, 11.67, 0, '2026-05-06 06:52:43', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(375, 1, 61, NULL, 30, 11.59, 0, '2026-05-06 07:01:30', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(376, 1, 60, NULL, 30, 14.81, 0, '2026-05-06 07:04:38', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(377, 1, 59, NULL, 69, 32.13, 0, '2026-05-06 07:08:46', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(378, 1, 48, NULL, 30, 12.19, 0, '2026-05-06 07:20:36', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(379, 1, 90, NULL, 30, 12.76, 0, '2026-05-06 19:23:32', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(380, 1, 90, NULL, 30, 12.77, 0, '2026-05-06 19:56:15', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(381, 1, 90, NULL, 30, 12.82, 0, '2026-05-06 20:04:38', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(382, 1, 90, NULL, 30, 12.85, 0, '2026-05-07 06:19:13', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(383, 1, 90, NULL, 30, 12.87, 0, '2026-05-07 06:24:32', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(384, 1, 61, NULL, 30, 11.62, 0, '2026-05-07 06:30:13', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(386, 1, 94, NULL, 30, 11.45, 0, '2026-05-09 19:35:31', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(387, 1, 95, NULL, 30, 12.99, 0, '2026-05-11 03:45:37', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(388, 1, 94, NULL, 30, 11.42, 0, '2026-05-11 03:49:17', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(390, 1, 100, NULL, 30, 11.56, 0, '2026-05-11 04:59:19', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(391, 1, 95, NULL, 30, 12.94, 0, '2026-05-11 05:05:39', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(392, 1, 104, NULL, 30, 14.29, 0, '2026-05-11 06:37:33', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(393, 1, 100, NULL, 30, 11.56, 0, '2026-05-11 06:43:08', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(394, 1, 95, NULL, 30, 12.96, 0, '2026-05-11 06:47:29', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(395, 2, 35, NULL, 30, 11.62, 0, '2026-05-11 08:09:46', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(396, 2, 29, NULL, 30, 12.29, 0, '2026-05-11 08:13:46', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(397, 1, 104, NULL, 30, 14.16, 0, '2026-05-12 07:06:49', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(398, 1, 104, NULL, 30, 14.21, 0, '2026-05-12 07:34:10', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(399, 1, 100, NULL, 30, 11.62, 0, '2026-05-12 07:37:43', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(400, 1, 95, NULL, 30, 12.97, 0, '2026-05-12 07:42:04', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(401, 1, 104, NULL, 30, 14.23, 0, '2026-05-12 07:42:49', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(402, 1, 91, NULL, 30, 13.00, 0, '2026-05-12 07:44:02', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(403, 1, 100, NULL, 30, 11.59, 0, '2026-05-12 07:45:48', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(404, 1, 95, NULL, 30, 13.01, 0, '2026-05-12 07:49:09', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(405, 1, 104, NULL, 30, 14.24, 0, '2026-05-12 07:52:15', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(406, 1, 91, NULL, 30, 12.97, 0, '2026-05-12 07:53:51', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(407, 1, 90, NULL, 30, 12.78, 0, '2026-05-12 07:58:51', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(408, 1, 105, NULL, 30, 12.13, 0, '2026-05-12 08:19:48', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(409, 1, 104, NULL, 30, 14.23, 0, '2026-05-12 08:23:58', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(410, 1, 100, NULL, 30, 11.56, 0, '2026-05-12 08:27:38', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(411, 1, 95, NULL, 30, 13.01, 0, '2026-05-12 08:31:56', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(412, 1, 94, NULL, 30, 11.40, 0, '2026-05-12 08:35:50', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(413, 1, 105, NULL, 30, 12.13, 0, '2026-05-12 21:02:01', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(414, 1, 91, NULL, 30, 13.02, 0, '2026-05-12 21:04:22', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(415, 1, 61, NULL, 30, 11.68, 0, '2026-05-12 21:07:10', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(416, 1, 60, NULL, 30, 14.80, 0, '2026-05-12 21:11:30', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(417, 1, 59, NULL, 30, 13.91, 0, '2026-05-12 21:14:54', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(418, 1, 58, NULL, 30, 12.30, 0, '2026-05-12 21:18:44', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(419, 1, 57, NULL, 30, 10.70, 0, '2026-05-12 21:23:40', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(420, 1, 56, NULL, 30, 11.51, 0, '2026-05-12 21:28:22', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(421, 1, 55, NULL, 30, 7.79, 0, '2026-05-12 21:32:44', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(422, 1, 54, NULL, 30, 14.34, 0, '2026-05-12 21:39:13', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(423, 1, 53, NULL, 30, 12.30, 0, '2026-05-12 21:42:43', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(424, 1, 52, NULL, 30, 11.68, 0, '2026-05-12 21:46:52', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(425, 1, 51, NULL, 30, 11.95, 0, '2026-05-12 21:51:12', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(426, 1, 50, NULL, 30, 16.17, 0, '2026-05-12 21:55:24', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(427, 1, 49, NULL, 30, 12.17, 0, '2026-05-12 21:58:31', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(428, 1, 48, NULL, 30, 12.11, 0, '2026-05-12 22:02:39', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(429, 1, 47, NULL, 30, 9.29, 0, '2026-05-12 22:06:48', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(430, 1, 46, NULL, 30, 11.03, 0, '2026-05-12 22:12:12', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(431, 1, 45, NULL, 30, 14.18, 0, '2026-05-12 22:16:45', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(432, 1, 44, NULL, 30, 15.02, 0, '2026-05-12 22:20:20', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(433, 1, 50, NULL, 30, 16.19, 0, '2026-05-13 00:55:35', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(434, 1, 49, NULL, 30, 12.14, 0, '2026-05-13 00:58:42', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(435, 1, 48, NULL, 30, 12.16, 0, '2026-05-13 01:02:50', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(436, 1, 47, NULL, 30, 9.36, 0, '2026-05-13 01:07:00', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(437, 1, 46, NULL, 30, 11.03, 0, '2026-05-13 01:12:23', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(438, 1, 45, NULL, 30, 14.13, 0, '2026-05-13 01:16:57', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(439, 1, 44, NULL, 30, 15.14, 0, '2026-05-13 01:20:31', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(440, 1, 43, NULL, 30, 10.27, 0, '2026-05-13 01:23:52', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(441, 1, 42, NULL, 30, 10.03, 0, '2026-05-13 01:28:46', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(442, 1, 40, NULL, 30, 11.94, 0, '2026-05-13 01:33:46', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(443, 1, 39, NULL, 30, 17.60, 0, '2026-05-13 01:38:00', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(444, 1, 38, NULL, 30, 12.16, 0, '2026-05-13 01:40:52', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(445, 1, 100, NULL, 30, 11.56, 0, '2026-05-13 04:37:45', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(446, 1, 95, NULL, 30, 12.99, 0, '2026-05-13 04:42:06', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(447, 1, 94, NULL, 30, 11.45, 0, '2026-05-13 04:45:59', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(448, 1, 91, NULL, 30, 12.95, 0, '2026-05-13 04:50:24', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(449, 1, 26, NULL, 30, 11.56, 0, '2026-05-14 01:08:37', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(450, 1, 49, NULL, 30, 12.16, 0, '2026-05-14 01:15:23', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(451, 1, 43, NULL, 30, 10.27, 0, '2026-05-14 01:19:33', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(452, 1, 38, NULL, 30, 12.07, 0, '2026-05-14 01:24:27', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(453, 1, 22, NULL, 30, 9.58, 0, '2026-05-14 01:28:37', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(454, 2, 35, NULL, 30, 11.60, 0, '2026-05-18 09:40:13', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(455, 2, 61, NULL, 30, 11.65, 0, '2026-05-18 09:41:32', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(456, 2, 105, NULL, 30, 12.08, 0, '2026-05-18 19:40:56', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(457, 2, 104, NULL, 30, 14.16, 0, '2026-05-18 19:45:04', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(458, 2, 100, NULL, 30, 11.64, 0, '2026-05-18 19:48:37', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(459, 2, 95, NULL, 30, 13.00, 0, '2026-05-18 19:52:58', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(460, 2, 94, NULL, 30, 11.35, 0, '2026-05-18 19:56:51', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(461, 2, 91, NULL, 30, 13.02, 0, '2026-05-18 20:01:16', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(462, 1, 35, NULL, 30, 11.61, 0, '2026-05-18 20:58:34', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(463, 1, 36, NULL, 30, 13.26, 0, '2026-05-18 21:02:55', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(464, 1, 29, NULL, 30, 12.26, 0, '2026-05-18 21:06:44', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(465, 1, 28, NULL, 30, 12.90, 0, '2026-05-18 21:10:51', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(466, 1, 37, NULL, 30, 9.20, 0, '2026-05-18 21:14:45', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0', '127.0.0.1', NULL, NULL),
(467, 1, 106, NULL, 30, 15.38, 0, '2026-05-18 22:51:46', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '127.0.0.1', NULL, NULL),
(468, 18, 106, NULL, 30, 15.37, 0, '2026-05-18 22:52:23', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(469, 1, 106, NULL, 30, 15.38, 0, '2026-05-19 00:30:01', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '127.0.0.1', NULL, NULL),
(470, 1, 105, NULL, 30, 12.13, 0, '2026-05-19 00:33:17', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '127.0.0.1', NULL, NULL),
(471, 1, 104, NULL, 30, 14.13, 0, '2026-05-19 00:37:26', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '127.0.0.1', NULL, NULL),
(472, 1, 100, NULL, 30, 11.60, 0, '2026-05-19 00:40:59', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '127.0.0.1', NULL, NULL),
(473, 1, 95, NULL, 39, 16.89, 0, '2026-05-19 01:58:43', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '127.0.0.1', NULL, NULL),
(474, 1, 94, NULL, 30, 11.38, 0, '2026-05-19 02:02:28', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '127.0.0.1', NULL, NULL),
(475, 1, 91, NULL, 30, 13.06, 0, '2026-05-19 02:06:59', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '127.0.0.1', NULL, NULL),
(476, 1, 90, NULL, 30, 12.85, 0, '2026-05-19 02:10:47', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '127.0.0.1', NULL, NULL),
(477, 1, 61, NULL, 30, 11.63, 0, '2026-05-19 02:14:43', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '127.0.0.1', NULL, NULL),
(478, 1, 60, NULL, 30, 14.85, 0, '2026-05-19 02:19:03', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '127.0.0.1', NULL, NULL),
(479, 1, 59, NULL, 30, 14.02, 0, '2026-05-19 02:25:02', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '127.0.0.1', NULL, NULL),
(480, 2, 114, NULL, 30, 16.03, 0, '2026-05-20 07:22:38', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(481, 2, 113, NULL, 30, 13.34, 0, '2026-05-20 07:25:30', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(482, 2, 112, NULL, 30, 10.90, 0, '2026-05-20 08:59:48', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(483, 2, 111, NULL, 30, 11.43, 0, '2026-05-20 09:04:36', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(484, 2, 110, NULL, 30, 12.88, 0, '2026-05-20 09:20:19', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(485, 2, 109, NULL, 30, 12.15, 0, '2026-05-20 09:24:13', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(486, 2, 108, NULL, 30, 10.02, 0, '2026-05-20 09:28:23', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(487, 2, 50, NULL, 30, 16.20, 0, '2026-05-20 21:33:22', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(488, 2, 49, NULL, 30, 12.21, 0, '2026-05-20 22:47:44', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(489, 2, 48, NULL, 30, 12.14, 0, '2026-05-20 22:51:51', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(490, 2, 47, NULL, 30, 9.30, 0, '2026-05-20 22:56:00', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(491, 2, 46, NULL, 30, 11.02, 0, '2026-05-20 23:01:24', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(492, 2, 45, NULL, 30, 14.10, 0, '2026-05-20 23:05:58', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(493, 1, 114, NULL, 30, 15.96, 0, '2026-05-21 05:02:47', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '127.0.0.1', NULL, NULL),
(494, 1, 113, NULL, 30, 13.28, 0, '2026-05-21 05:05:55', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '127.0.0.1', NULL, NULL),
(495, 1, 112, NULL, 30, 10.95, 0, '2026-05-21 05:09:39', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '127.0.0.1', NULL, NULL),
(496, 1, 111, NULL, 30, 11.37, 0, '2026-05-21 05:14:18', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '127.0.0.1', NULL, NULL),
(497, 1, 110, NULL, 30, 12.97, 0, '2026-05-21 05:18:41', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '127.0.0.1', NULL, NULL),
(498, 1, 109, NULL, 30, 12.13, 0, '2026-05-21 05:22:37', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '127.0.0.1', NULL, NULL),
(499, 1, 108, NULL, 30, 10.02, 0, '2026-05-21 05:26:46', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '127.0.0.1', NULL, NULL),
(500, 1, 106, NULL, 30, 15.34, 0, '2026-05-21 05:31:48', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '127.0.0.1', NULL, NULL),
(501, 1, 105, NULL, 30, 12.11, 0, '2026-05-21 05:35:15', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '127.0.0.1', NULL, NULL),
(502, 1, 36, NULL, 30, 13.22, 0, '2026-05-21 05:36:53', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '127.0.0.1', NULL, NULL),
(503, 1, 35, NULL, 30, 11.54, 0, '2026-05-21 05:40:43', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '127.0.0.1', NULL, NULL),
(504, 1, 61, NULL, 30, 11.67, 0, '2026-05-21 05:41:31', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '127.0.0.1', NULL, NULL),
(505, 1, 36, NULL, 30, 13.20, 0, '2026-05-21 05:46:02', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '127.0.0.1', NULL, NULL),
(506, 1, 37, NULL, 30, 9.18, 0, '2026-05-21 05:46:39', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '127.0.0.1', NULL, NULL),
(507, 1, 51, NULL, 30, 11.98, 0, '2026-05-21 05:51:52', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '127.0.0.1', NULL, NULL),
(508, 1, 52, NULL, 30, 11.60, 0, '2026-05-21 05:56:04', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '127.0.0.1', NULL, NULL),
(509, 1, 45, NULL, 30, 14.16, 0, '2026-05-21 06:00:29', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '127.0.0.1', NULL, NULL),
(510, 1, 40, NULL, 30, 11.93, 0, '2026-05-21 06:04:02', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '127.0.0.1', NULL, NULL),
(511, 1, 58, NULL, 30, 12.28, 0, '2026-05-21 20:30:38', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '127.0.0.1', NULL, NULL),
(512, 1, 57, NULL, 30, 10.69, 0, '2026-05-21 20:34:46', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:151.0) Gecko/20100101 Firefox/151.0', '127.0.0.1', NULL, NULL),
(513, 1, 106, NULL, 30, 15.35, 0, '2026-05-24 01:20:06', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(514, 1, 105, NULL, 30, 12.14, 0, '2026-05-24 01:23:23', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(515, 1, 104, NULL, 30, 14.18, 0, '2026-05-24 01:27:36', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(516, 1, 100, NULL, 30, 11.64, 0, '2026-05-24 01:31:27', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(517, 1, 95, NULL, 30, 12.98, 0, '2026-05-24 01:35:47', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(518, 1, 94, NULL, 30, 11.36, 0, '2026-05-24 01:39:40', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(519, 1, 91, NULL, 30, 12.96, 0, '2026-05-24 01:44:09', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(520, 1, 90, NULL, 30, 12.75, 0, '2026-05-24 01:48:00', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(521, 1, 61, NULL, 30, 11.60, 0, '2026-05-24 02:13:43', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(522, 1, 60, NULL, 30, 14.89, 0, '2026-05-24 02:18:04', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(523, 1, 59, NULL, 30, 13.91, 0, '2026-05-24 02:21:28', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(524, 1, 58, NULL, 30, 12.23, 0, '2026-05-24 02:25:05', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(525, 1, 57, NULL, 30, 10.68, 0, '2026-05-24 02:29:11', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(526, 1, 109, NULL, 30, 12.14, 0, '2026-05-26 00:53:56', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(527, 1, 108, NULL, 30, 9.98, 0, '2026-05-26 05:59:25', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(528, 1, 106, NULL, 30, 15.27, 0, '2026-05-26 06:04:27', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(529, 1, 105, NULL, 30, 12.12, 0, '2026-05-26 06:07:44', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(530, 1, 104, NULL, 30, 14.13, 0, '2026-05-26 06:11:54', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(531, 1, 100, NULL, 30, 11.58, 0, '2026-05-26 06:12:25', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(532, 1, 95, NULL, 30, 12.97, 0, '2026-05-26 06:16:45', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(533, 1, 94, NULL, 30, 11.36, 0, '2026-05-26 06:20:38', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL),
(534, 1, 91, NULL, 30, 12.95, 0, '2026-05-26 06:25:03', 'web', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36', '127.0.0.1', NULL, NULL);

--
-- Bẫy `song_plays`
--
DELIMITER $$
CREATE TRIGGER `after_song_play_insert` AFTER INSERT ON `song_plays` FOR EACH ROW BEGIN
    DECLARE v_partner_id       BIGINT;
    DECLARE v_partner_share    DECIMAL(5,2);
    DECLARE v_revenue          DECIMAL(15,4);
    DECLARE v_partner_share_amount DECIMAL(15,4);
    DECLARE v_platform_share   DECIMAL(15,4);
    DECLARE v_tax_amount       DECIMAL(15,4);
    DECLARE v_net_payout       DECIMAL(15,4);

    SELECT partner_id INTO v_partner_id
    FROM songs WHERE id = NEW.song_id;

    IF v_partner_id IS NOT NULL THEN
        SET v_revenue = 0.05;

        SELECT COALESCE(revenue_share_percentage, 70) INTO v_partner_share
        FROM partners WHERE id = v_partner_id;

        SET v_partner_share_amount = v_revenue * (v_partner_share / 100);
        SET v_platform_share       = v_revenue - v_partner_share_amount;
        SET v_tax_amount           = v_partner_share_amount * 0.1;
        SET v_net_payout           = v_partner_share_amount - v_tax_amount;

        INSERT INTO partner_revenues (
            partner_id, song_id,
            period_type, period_start, period_end,
            total_plays, ad_revenue, total_revenue,
            partner_share_percentage, partner_share_amount,
            platform_share_amount, tax_amount, net_payout,
            status, calculated_at, updated_at
        )
        VALUES (
            v_partner_id, NEW.song_id,
            'monthly',
            DATE_FORMAT(NEW.played_at, '%Y-%m-01'),
            LAST_DAY(NEW.played_at),
            1, v_revenue, v_revenue,
            v_partner_share, v_partner_share_amount,
            v_platform_share, v_tax_amount, v_net_payout,
            'calculated', NOW(), NOW()
        )
        ON DUPLICATE KEY UPDATE
            total_plays           = total_plays + 1,
            ad_revenue            = ad_revenue + v_revenue,
            total_revenue         = total_revenue + v_revenue,
            partner_share_amount  = partner_share_amount + v_partner_share_amount,
            platform_share_amount = platform_share_amount + v_platform_share,
            tax_amount            = tax_amount + v_tax_amount,
            net_payout            = net_payout + v_net_payout,
            updated_at            = NOW();
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_song_plays_count` AFTER INSERT ON `song_plays` FOR EACH ROW BEGIN
    UPDATE songs 
    SET total_plays = total_plays + 1
    WHERE id = NEW.song_id;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `subscription_plans`
--

CREATE TABLE `subscription_plans` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `role_name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `display_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `price` decimal(10,2) NOT NULL DEFAULT '0.00',
  `original_price` decimal(10,2) DEFAULT NULL,
  `currency` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'VND',
  `duration_days` int NOT NULL DEFAULT '0',
  `trial_days` int NOT NULL DEFAULT '0',
  `max_playlists` int DEFAULT NULL,
  `max_songs_per_playlist` int DEFAULT NULL,
  `max_offline_downloads` int DEFAULT NULL,
  `max_devices` int DEFAULT '1',
  `can_download` tinyint(1) NOT NULL DEFAULT '0',
  `audio_quality` enum('standard','high','lossless') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'standard',
  `ads_free` tinyint(1) NOT NULL DEFAULT '0',
  `can_skip_unlimited` tinyint(1) NOT NULL DEFAULT '0',
  `can_create_collaborative_playlist` tinyint(1) NOT NULL DEFAULT '0',
  `priority_support` tinyint(1) NOT NULL DEFAULT '0',
  `early_access` tinyint(1) NOT NULL DEFAULT '0',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `is_featured` tinyint(1) NOT NULL DEFAULT '0',
  `sort_order` int NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `subscription_plans`
--

INSERT INTO `subscription_plans` (`id`, `name`, `role_name`, `display_name`, `description`, `price`, `original_price`, `currency`, `duration_days`, `trial_days`, `max_playlists`, `max_songs_per_playlist`, `max_offline_downloads`, `max_devices`, `can_download`, `audio_quality`, `ads_free`, `can_skip_unlimited`, `can_create_collaborative_playlist`, `priority_support`, `early_access`, `is_active`, `is_featured`, `sort_order`, `created_at`, `updated_at`) VALUES
(1, 'free', 'user_free', 'Free', 'Basic free tier with ads', 0.00, NULL, 'VND', 0, 0, 5, 50, 0, 1, 0, 'standard', 0, 0, 0, 0, 0, 1, 0, 1, '2025-11-11 08:45:04', '2025-11-11 08:45:04'),
(2, 'vip_monthly', 'user_vip_monthly', 'VIP Monthly', 'Premium monthly subscription', 2000.00, 59000.00, 'VND', 30, 7, 50, 500, 100, 3, 1, 'high', 1, 1, 1, 0, 0, 1, 1, 2, '2025-11-11 08:45:04', '2025-11-11 08:45:04'),
(3, 'vip_yearly', 'user_vip_yearly', 'VIP Yearly', 'Premium yearly - Save 30%', 5000.00, 499000.00, 'VND', 365, 14, 999, 9999, 9999, 5, 1, 'lossless', 1, 1, 1, 1, 1, 1, 1, 3, '2025-11-11 08:45:04', '2025-11-11 08:45:04');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `system_settings`
--

CREATE TABLE `system_settings` (
  `id` bigint UNSIGNED NOT NULL,
  `key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `type` enum('string','integer','boolean','json','text') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'string',
  `group` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `is_public` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Can be accessed by frontend',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `system_settings`
--

INSERT INTO `system_settings` (`id`, `key`, `value`, `type`, `group`, `description`, `is_public`, `created_at`, `updated_at`) VALUES
(1, 'site_name', 'MelodyHub', 'string', 'general', 'Website name', 1, '2025-11-11 08:41:53', '2025-11-11 08:41:53'),
(2, 'site_description', 'Stream millions of songs online', 'text', 'general', 'Website description', 1, '2025-11-11 08:41:53', '2025-11-11 08:41:53'),
(3, 'max_upload_size', '50', 'integer', 'upload', 'Max upload size in MB', 0, '2025-11-11 08:41:53', '2025-11-11 08:41:53'),
(4, 'allowed_audio_formats', '[\"mp3\",\"flac\",\"wav\",\"m4a\"]', 'json', 'upload', 'Allowed audio formats', 0, '2025-11-11 08:41:53', '2025-11-11 08:41:53'),
(5, 'free_tier_play_limit_per_day', '100', 'integer', 'limits', 'Free tier daily play limit', 0, '2025-11-11 08:41:53', '2025-11-11 08:41:53'),
(6, 'free_tier_skip_limit_per_hour', '6', 'integer', 'limits', 'Free tier skip limit per hour', 0, '2025-11-11 08:41:53', '2025-11-11 08:41:53'),
(7, 'enable_comments', '1', 'boolean', 'features', 'Enable song comments', 1, '2025-11-11 08:41:53', '2025-11-11 08:41:53'),
(8, 'enable_downloads', '1', 'boolean', 'features', 'Enable downloads for VIP', 1, '2025-11-11 08:41:53', '2025-11-11 08:41:53'),
(9, 'maintenance_mode', '0', 'boolean', 'system', 'Maintenance mode', 1, '2025-11-11 08:41:53', '2025-11-11 08:41:53');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `trending_songs`
--

CREATE TABLE `trending_songs` (
  `id` bigint UNSIGNED NOT NULL,
  `song_id` bigint UNSIGNED NOT NULL,
  `rank` int NOT NULL,
  `score` decimal(10,2) NOT NULL,
  `plays_24h` int NOT NULL DEFAULT '0',
  `plays_7d` int NOT NULL DEFAULT '0',
  `genre_id` bigint UNSIGNED DEFAULT NULL,
  `country` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'global',
  `calculated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `two_factor_auth`
--

CREATE TABLE `two_factor_auth` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `method` enum('sms','email','authenticator') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `secret` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `backup_codes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'JSON array',
  `is_enabled` tinyint(1) NOT NULL DEFAULT '0',
  `enabled_at` timestamp NULL DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `users`
--

CREATE TABLE `users` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `google_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `wallet_balance` decimal(15,2) NOT NULL DEFAULT '0.00',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `username` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `avatar_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `gender` enum('male','female','other','prefer_not_to_say') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `country` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `timezone` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'Asia/Ho_Chi_Minh',
  `bio` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `status` enum('active','inactive','banned','pending') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `published_at` timestamp NULL DEFAULT NULL,
  `play_count_last_24h` int NOT NULL DEFAULT '0',
  `play_count_last_7d` int NOT NULL DEFAULT '0',
  `play_count_last_30d` int NOT NULL DEFAULT '0',
  `trending_score` decimal(10,2) NOT NULL DEFAULT '0.00',
  `seo_title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `seo_description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `users`
--

INSERT INTO `users` (`id`, `name`, `slug`, `email`, `google_id`, `email_verified_at`, `wallet_balance`, `phone`, `username`, `password`, `avatar_url`, `date_of_birth`, `gender`, `country`, `timezone`, `bio`, `status`, `published_at`, `play_count_last_24h`, `play_count_last_7d`, `play_count_last_30d`, `trending_score`, `seo_title`, `seo_description`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'Trung Nguyên Boss', 'boss-owner', 'nguyenbui26102003@gmail.com', '114291174794947849249', '2026-05-21 23:06:39', 5000.00, '0900000001', 'boss', '$2y$12$zZLlLDAeojmcj7DS6Q4IK.dycpyPU/nDFDRiHMEYtwor/vamVZKVy', 'avatars/users/1768386328_hKs4vtfvVo.jpg', '2003-10-26', 'male', 'VN', 'Asia/Ho_Chi_Minh', NULL, 'active', NULL, 0, 0, 0, 0.00, NULL, NULL, '2025-11-28 03:42:39', '2026-05-21 23:06:39', NULL),
(2, 'Bui Trung Nguyen', 'bui-trung-nguyen', 'trnguyen26102k3@gmail.com', '116132130491539057678', '2026-05-21 01:36:52', 0.00, '0234987234', 'trunggnguyen2k31812', '$2y$12$5hYr.RWdBifhHHk5aFYd/uq6BEubxDRdFhPCL5EuFDXZ7WlZs5MRq', 'avatars/users/1770517247_B1J1mMinnc.png', '2003-10-26', 'male', 'VN', 'Asia/Ho_Chi_Minh', NULL, 'pending', NULL, 0, 0, 0, 0.00, NULL, NULL, '2025-11-28 00:57:37', '2026-05-21 01:36:52', NULL),
(3, 'Tran Thi Cam Lai', 'cam-lai', 'ttclai1812@gmail.com', NULL, NULL, 0.00, '09876543321', 'camlai', '$2y$12$iCYNr.1c3Xid/LGaZYxj0efUJ98DNPv2EX2LimriFr1LB9O7LkWui', 'avatars/users/1773413310_pNNcbs02xi.jpg', '2003-12-18', 'female', 'VN', 'Asia/Ho_Chi_Minh', NULL, 'active', NULL, 0, 0, 0, 0.00, NULL, NULL, '2026-01-06 02:13:42', '2026-04-03 22:59:21', NULL),
(4, 'Nguyen Trong Phuc', 'trong-phuc', 'trongphuc@gmail.com', NULL, NULL, 0.00, '0982435234', 'TrongPhucNguyen', '$2y$12$6KgwDTw7/yzBDHgXWE/xVuk0HLg4Y5XNKkIXhljpNpXgGsmgSV5Oy', 'avatars/users/1773413251_3fIjyh8Xyd.jpg', '2003-11-17', 'male', 'VN', 'Asia/Ho_Chi_Minh', NULL, 'active', NULL, 0, 0, 0, 0.00, NULL, NULL, '2026-01-06 05:46:07', '2026-03-13 07:47:31', NULL),
(5, 'Bui Vu Nguyen', 'vu-nguyen', 'buivunguyen07@gmail.com', NULL, NULL, 0.00, '0986214345', 'VuNguyenBui', '$2y$12$LF5C6mq5RwNZo/jHyGRcM.fjEWT8NK45ErBEqebA1ZuYbroRGNJym', 'avatars/users/1773413188_LwN6xxGbtk.jpg', '2008-02-02', 'male', 'UK', 'America/New_York', NULL, 'active', NULL, 0, 0, 0, 0.00, NULL, NULL, '2026-01-06 05:50:19', '2026-04-29 08:50:06', NULL),
(6, 'Van Thanh Phi', 'thanh-phi', 'vanthanhphi@gmail.com', NULL, NULL, 0.00, '097234876452', 'vanphithanh', '$2y$12$RWJpqQvYYWVB8lLyM2noy.3i/jaFA1oHW/2Xxs1nh7utOlHqE.dvy', 'avatars/users/1773413160_q77UJtTnNU.jpg', '2003-01-10', 'male', 'VN', 'Asia/Ho_Chi_Minh', NULL, 'active', NULL, 0, 0, 0, 0.00, NULL, NULL, '2026-01-06 08:22:08', '2026-03-13 07:46:00', NULL),
(7, 'Nguyen Minh Nhat', 'minh-nhat', 'minhNhat@gmail.com', NULL, NULL, 0.00, '093876213', 'minhnhatnguyen', '$2y$12$Sq5h/XjwA.uG.AjnaORm3uQgHj5x2675ifNUY9BmaH/5r7jc.a0tO', 'avatars/users/1773413119_QZhHWfGCvl.jpg', '2003-04-11', 'male', 'VN', 'Asia/Ho_Chi_Minh', NULL, 'active', NULL, 0, 0, 0, 0.00, NULL, NULL, '2026-01-06 08:28:38', '2026-03-13 07:45:19', NULL),
(11, 'Hồng Quốc Huy', 'quoc-huy', 'QuocHuy2K3@gmail.com', NULL, NULL, 0.00, NULL, 'QuocHuyPink', '$2y$12$2mS8ju1FqfD8GBHO22HSWuW67CHPzNj7dxP15d6jARobIZRfTRkbm', 'avatars/users/1772288856_2yS9LBeJwX.jpeg', NULL, NULL, NULL, NULL, NULL, 'active', NULL, 0, 0, 0, 0.00, NULL, NULL, '2026-02-28 07:27:38', '2026-02-28 07:27:38', NULL),
(12, 'Pham Huu Nhan', 'huu-nhan', 'huunhan@gmail.com', NULL, NULL, 0.00, NULL, 'HuuNhan123', '$2y$12$Gc/eP.gpjFAsdwjEQc5Db.4THXyINkKadNGB0RHDAZocjJXev3tJe', 'avatars/users/1773410750_4JtHj2VUiD.jpg', '2002-01-01', 'male', 'VN', 'Asia/Ho_Chi_Minh', NULL, 'pending', NULL, 0, 0, 0, 0.00, NULL, NULL, '2026-03-04 01:07:24', '2026-03-13 07:05:50', NULL),
(13, 'Ngô Minh Khoa ú', 'minh-khoa', 'NgoMinhKhoa@gmail.com', NULL, NULL, 0.00, NULL, 'minhkhoango123', '$2y$12$bedl/GdddztIxLEM8U2qgOWrbgInDmr.uMxeIz/nAccPhRwTZ38ci', 'avatars/users/1773655880_T19A49RxzG.png', '2002-02-02', 'male', 'UK', 'Asia/Ho_Chi_Minh', 'Bé Big Chubby', 'active', NULL, 0, 0, 0, 0.00, NULL, NULL, '2026-03-16 03:11:22', '2026-03-17 18:38:56', NULL),
(14, 'Đen Vâu', 'den-vau', 'denvau@gmail.com', NULL, NULL, 0.00, NULL, 'DenVau1989', '$2y$12$EBStUpftXksIMmqysqYr2ejMnn3fzaOTKTQmTiGXxizb4yFMyRuMK', 'avatars/users/1773800664_Mq5nX7ONx4.png', '1989-05-13', 'male', 'VN', 'Asia/Ho_Chi_Minh', 'Đen Vâu (Nguyễn Đức Cường) sinh ngày 13/05/1989 tại Quảng Ninh. Từng có 7 năm làm công nhân vệ sinh bãi biển trước khi trở thành \"rapper quốc dân\". Anh bùng nổ từ giới Underground với hit \"Đưa nhau đi trốn\" (2014) và hiện là nghệ sĩ hàng đầu sở hữu nhiều liveshow cháy vé. Âm nhạc của Đen nổi bật bởi sự tử tế, lời ca mộc mạc, giàu triết lý tự sự. Anh còn truyền cảm hứng mạnh mẽ qua các hoạt động xã hội, tiêu biểu là dự án \"Nấu ăn cho em\" nuôi dưỡng trẻ em vùng cao.', 'active', NULL, 0, 0, 0, 0.00, 'Đen Vâu là ai? Cuộc đời và sự nghiệp âm nhạc của \"Rapper quốc dân\"', 'Khám phá tiểu sử rapper Đen Vâu (Nguyễn Đức Cường), từ chàng công nhân vệ sinh đến ngôi sao nhạc Rap hàng đầu Việt Nam. Xem ngay ngày sinh, quê quán và các dự án thiện nguyện nổi bật.', '2026-03-17 19:24:26', '2026-03-17 19:24:26', NULL),
(17, 'Hiếu Thứ Hai', 'thu-2', 'hieuthuhai.gerdnang@gmail.com', NULL, NULL, 0.00, NULL, 'hieuthu2offical', '$2y$12$aTlfYBEyP20HC6iEL9FJEOOVmA4BF0mVcammRqMpFfLA59EEenYby', 'avatars/users/1776412257_nCFghyux6d.jpg', NULL, 'male', 'VN', 'Asia/Ho_Chi_Minh', NULL, 'active', NULL, 0, 0, 0, 0.00, 'HieuTHu2', NULL, '2026-04-17 00:50:57', '2026-05-11 07:50:12', NULL),
(18, 'CaSiGiauMat', 'casigiaumat', 'CaSiGiauMat@gmail.com', NULL, NULL, 0.00, NULL, NULL, '$2y$12$YOmKtqEwf.0UDJx2KUhQtOJD3taq9E6XtSswhDbSXtiiNigq6nmVm', NULL, NULL, NULL, NULL, 'Asia/Ho_Chi_Minh', NULL, 'pending', NULL, 0, 0, 0, 0.00, NULL, NULL, '2026-04-21 03:05:22', '2026-04-21 03:05:22', NULL),
(19, 'soulware', 's-o-u-l-w-a-r-e', 'soulware999@gmail.com', NULL, NULL, 0.00, NULL, NULL, '$2y$12$M932SJ70zqlf9gUb5/cJTuZBeuChcgJdQp3GdI81wZHTEScyhyZwG', 'avatars/ymb9O9QWKR3bmbvsz3qNBDu9BMeBXdKjfVqtFfjK.jpg', NULL, NULL, NULL, 'Asia/Ho_Chi_Minh', NULL, 'pending', NULL, 0, 0, 0, 0.00, NULL, NULL, '2026-04-24 23:37:37', '2026-04-27 07:27:24', NULL),
(20, 'Bui Hoang Nguyen', 'bui-hoang-nguyen', 'hoangnguyen@gmail.com', NULL, NULL, 0.00, NULL, NULL, '$2y$12$M8tYZpV0U/7hkyKv/RjomeVtlxwD0yPJziheMtJp4Tu/IKNKE7hn.', NULL, NULL, NULL, NULL, 'Asia/Ho_Chi_Minh', NULL, 'pending', NULL, 0, 0, 0, 0.00, NULL, NULL, '2026-04-30 21:04:35', '2026-04-30 21:04:35', NULL),
(21, 'Nguyên Bùi Trung', 'nguyen-bui-trung', 'btnguyena21157@cusc.ctu.edu.vn', '111247502671056532925', '2026-05-21 01:34:29', 0.00, NULL, 'btnguyena21157', '$2y$12$RVYfe.kFJEL6FApBqZk4VeG4dO5d2Uz/pCXuO1xqwLu4Pyeh5j6NG', 'avatars/h307Y2NT957Gladt9PC3vPAXUnU2ZeKsDT6TyG1s.jpg', NULL, NULL, NULL, 'Asia/Ho_Chi_Minh', NULL, 'active', NULL, 0, 0, 0, 0.00, NULL, NULL, '2026-05-21 01:34:29', '2026-05-21 01:38:09', NULL);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `user_devices`
--

CREATE TABLE `user_devices` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `device_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `device_type` enum('web','mobile','desktop','tablet') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `device_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Unique device identifier',
  `platform` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `browser` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `os` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `app_version` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `push_token` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `last_used_at` timestamp NULL DEFAULT NULL,
  `registered_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `user_engagement_metrics`
--

CREATE TABLE `user_engagement_metrics` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `date` date NOT NULL,
  `total_plays` int NOT NULL DEFAULT '0',
  `total_listening_time` int NOT NULL DEFAULT '0' COMMENT 'minutes',
  `unique_songs_played` int NOT NULL DEFAULT '0',
  `playlists_created` int NOT NULL DEFAULT '0',
  `songs_liked` int NOT NULL DEFAULT '0',
  `comments_posted` int NOT NULL DEFAULT '0',
  `shares` int NOT NULL DEFAULT '0',
  `engagement_score` decimal(10,2) NOT NULL DEFAULT '0.00',
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `user_followers`
--

CREATE TABLE `user_followers` (
  `id` bigint UNSIGNED NOT NULL,
  `follower_id` bigint UNSIGNED NOT NULL,
  `following_id` bigint UNSIGNED NOT NULL,
  `followed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `user_preferences`
--

CREATE TABLE `user_preferences` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `theme` enum('light','dark','auto') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'auto',
  `audio_quality` enum('auto','standard','high','lossless') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'auto',
  `autoplay` tinyint(1) NOT NULL DEFAULT '1',
  `crossfade` tinyint(1) NOT NULL DEFAULT '0',
  `crossfade_duration` int DEFAULT '5',
  `normalize_volume` tinyint(1) NOT NULL DEFAULT '1',
  `show_explicit_content` tinyint(1) NOT NULL DEFAULT '1',
  `language` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'vi',
  `notification_enabled` tinyint(1) NOT NULL DEFAULT '1',
  `email_notification` tinyint(1) NOT NULL DEFAULT '1',
  `push_notification` tinyint(1) NOT NULL DEFAULT '1',
  `private_session` tinyint(1) NOT NULL DEFAULT '0',
  `show_listening_activity` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `user_roles`
--

CREATE TABLE `user_roles` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `role_id` bigint UNSIGNED NOT NULL,
  `assigned_by` bigint UNSIGNED DEFAULT NULL,
  `assigned_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `expires_at` timestamp NULL DEFAULT NULL,
  `is_primary` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `user_roles`
--

INSERT INTO `user_roles` (`id`, `user_id`, `role_id`, `assigned_by`, `assigned_at`, `expires_at`, `is_primary`) VALUES
(1, 1, 1, NULL, '2025-11-28 03:44:30', NULL, 0),
(2, 2, 8, NULL, '2025-11-28 07:57:37', NULL, 0),
(3, 3, 8, 1, '2026-01-07 08:22:49', NULL, 1),
(4, 4, 8, 1, '2026-01-07 08:22:49', NULL, 1),
(5, 5, 8, 1, '2026-01-07 08:22:49', NULL, 0),
(6, 6, 8, 1, '2026-01-07 08:22:49', NULL, 1),
(7, 7, 8, 1, '2026-01-07 08:22:49', NULL, 1),
(18, 2, 6, NULL, '2026-02-01 03:35:32', '2027-02-01 03:35:32', 1),
(21, 11, 8, NULL, '2026-02-28 14:27:38', NULL, 0),
(22, 12, 8, NULL, '2026-03-04 08:07:24', NULL, 0),
(23, 13, 8, NULL, '2026-03-16 10:11:22', NULL, 0),
(24, 14, 8, NULL, '2026-03-18 02:24:26', NULL, 0),
(27, 17, 8, NULL, '2026-04-17 07:50:57', NULL, 0),
(28, 14, 4, NULL, '2026-04-21 09:50:35', NULL, 0),
(29, 2, 4, NULL, '2026-04-21 09:50:35', NULL, 0),
(30, 3, 4, NULL, '2026-04-21 09:50:35', NULL, 0),
(31, 17, 4, NULL, '2026-04-21 09:50:35', NULL, 0),
(32, 1, 4, NULL, '2026-04-21 09:50:35', NULL, 0),
(33, 18, 8, NULL, '2026-04-21 10:05:22', NULL, 0),
(34, 18, 4, 18, '2026-04-21 03:11:35', NULL, 0),
(35, 19, 8, NULL, '2026-04-25 06:37:37', NULL, 0),
(36, 19, 4, 19, '2026-04-24 23:40:40', NULL, 0),
(37, 5, 6, NULL, '2026-04-29 08:53:22', '2027-04-29 08:53:22', 1),
(38, 5, 4, 5, '2026-04-29 09:14:33', NULL, 0),
(39, 20, 8, NULL, '2026-05-01 04:04:35', NULL, 0),
(41, 1, 6, NULL, '2026-05-01 09:37:11', '2027-05-01 09:37:11', 1),
(42, 21, 8, NULL, '2026-05-21 08:34:29', NULL, 0),
(43, 21, 7, NULL, '2026-05-21 01:43:14', '2026-06-20 01:43:14', 1);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `user_subscriptions`
--

CREATE TABLE `user_subscriptions` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `plan_id` bigint UNSIGNED NOT NULL,
  `status` enum('active','expired','cancelled','suspended','trial') NOT NULL DEFAULT 'active',
  `starts_at` datetime DEFAULT NULL,
  `ends_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Đang đổ dữ liệu cho bảng `user_subscriptions`
--

INSERT INTO `user_subscriptions` (`id`, `user_id`, `plan_id`, `status`, `starts_at`, `ends_at`) VALUES
(30, 2, 3, 'active', '2026-02-01 10:35:32', '2027-02-01 10:35:32'),
(32, 5, 3, 'active', '2026-04-29 15:53:22', '2027-04-29 15:53:22'),
(34, 1, 3, 'active', '2026-05-01 16:37:11', '2027-05-01 16:37:11'),
(35, 21, 2, 'active', '2026-05-21 08:43:14', '2026-06-20 08:43:14');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `user_taste_profile`
--

CREATE TABLE `user_taste_profile` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `favorite_genres` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'JSON with weights',
  `favorite_artists` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'JSON with weights',
  `listening_patterns` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'JSON: time of day, duration, etc',
  `mood_preferences` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'JSON',
  `audio_features` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'JSON: tempo, energy, etc',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Chỉ mục cho các bảng đã đổ
--

--
-- Chỉ mục cho bảng `admin_activity_logs`
--
ALTER TABLE `admin_activity_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_admin` (`admin_id`),
  ADD KEY `idx_action` (`action`),
  ADD KEY `idx_target` (`target_type`,`target_id`),
  ADD KEY `idx_created` (`created_at`);

--
-- Chỉ mục cho bảng `advertisements`
--
ALTER TABLE `advertisements`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_dates` (`start_date`,`end_date`),
  ADD KEY `fk_ads_partner` (`partner_id`);

--
-- Chỉ mục cho bảng `ad_priority_tiers`
--
ALTER TABLE `ad_priority_tiers`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `ad_priority_tiers_value_unique` (`value`);

--
-- Chỉ mục cho bảng `ad_tracking`
--
ALTER TABLE `ad_tracking`
  ADD PRIMARY KEY (`id`),
  ADD KEY `ad_tracking_ad_id_index` (`ad_id`),
  ADD KEY `ad_tracking_user_id_index` (`user_id`),
  ADD KEY `ad_tracking_event_type_index` (`event_type`),
  ADD KEY `ad_tracking_tracked_at_index` (`tracked_at`);

--
-- Chỉ mục cho bảng `albums`
--
ALTER TABLE `albums`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_slug` (`slug`),
  ADD KEY `idx_artist` (`artist_id`),
  ADD KEY `idx_partner` (`partner_id`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_release_date` (`release_date`);
ALTER TABLE `albums` ADD FULLTEXT KEY `ft_search` (`name`,`description`);

--
-- Chỉ mục cho bảng `album_likes`
--
ALTER TABLE `album_likes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_user_album` (`user_id`,`album_id`),
  ADD KEY `idx_album` (`album_id`);

--
-- Chỉ mục cho bảng `album_tracks`
--
ALTER TABLE `album_tracks`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_album_track` (`album_id`,`track_id`),
  ADD KEY `idx_album_id` (`album_id`),
  ADD KEY `idx_track_id` (`track_id`);

--
-- Chỉ mục cho bảng `api_logs`
--
ALTER TABLE `api_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user` (`user_id`),
  ADD KEY `idx_endpoint` (`endpoint`(255)),
  ADD KEY `idx_status` (`response_status`),
  ADD KEY `idx_created` (`created_at`);

--
-- Chỉ mục cho bảng `artists`
--
ALTER TABLE `artists`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_slug` (`slug`),
  ADD KEY `idx_partner` (`partner_id`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_verified` (`verified`);
ALTER TABLE `artists` ADD FULLTEXT KEY `ft_search` (`name`,`bio`);

--
-- Chỉ mục cho bảng `artist_followers`
--
ALTER TABLE `artist_followers`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_user_artist` (`user_id`,`artist_id`),
  ADD KEY `idx_artist` (`artist_id`);

--
-- Chỉ mục cho bảng `cache`
--
ALTER TABLE `cache`
  ADD PRIMARY KEY (`key`);

--
-- Chỉ mục cho bảng `cache_locks`
--
ALTER TABLE `cache_locks`
  ADD PRIMARY KEY (`key`);

--
-- Chỉ mục cho bảng `comments`
--
ALTER TABLE `comments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_song` (`song_id`),
  ADD KEY `idx_user` (`user_id`),
  ADD KEY `idx_parent` (`parent_id`),
  ADD KEY `idx_timestamp` (`timestamp`);

--
-- Chỉ mục cho bảng `comment_likes`
--
ALTER TABLE `comment_likes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_user_comment` (`user_id`,`comment_id`),
  ADD KEY `idx_comment` (`comment_id`);

--
-- Chỉ mục cho bảng `copyrights`
--
ALTER TABLE `copyrights`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_song` (`song_id`),
  ADD KEY `idx_partner` (`partner_id`),
  ADD KEY `idx_status` (`status`);

--
-- Chỉ mục cho bảng `copyright_reports`
--
ALTER TABLE `copyright_reports`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_active_report` (`original_song_id`,`infringing_song_id`),
  ADD KEY `idx_original_song` (`original_song_id`),
  ADD KEY `idx_infringing_song` (`infringing_song_id`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `fk_cr_copyright` (`claimant_copyright_id`),
  ADD KEY `fk_cr_partner` (`reporter_partner_id`),
  ADD KEY `idx_similarity_raw` (`similarity_raw`);

--
-- Chỉ mục cho bảng `coupon_codes`
--
ALTER TABLE `coupon_codes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_code` (`code`),
  ADD KEY `idx_active` (`is_active`);

--
-- Chỉ mục cho bảng `coupon_usage`
--
ALTER TABLE `coupon_usage`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_coupon` (`coupon_id`),
  ADD KEY `idx_user` (`user_id`);

--
-- Chỉ mục cho bảng `daily_statistics`
--
ALTER TABLE `daily_statistics`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_date` (`date`),
  ADD KEY `idx_date` (`date`);

--
-- Chỉ mục cho bảng `email_logs`
--
ALTER TABLE `email_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user` (`user_id`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_created` (`created_at`),
  ADD KEY `fk_email_logs_template` (`template_id`);

--
-- Chỉ mục cho bảng `email_templates`
--
ALTER TABLE `email_templates`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_slug` (`slug`);

--
-- Chỉ mục cho bảng `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_uuid` (`uuid`);

--
-- Chỉ mục cho bảng `featured_content`
--
ALTER TABLE `featured_content`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_section` (`section`),
  ADD KEY `idx_active` (`is_active`),
  ADD KEY `idx_dates` (`start_date`,`end_date`);

--
-- Chỉ mục cho bảng `genres`
--
ALTER TABLE `genres`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_slug` (`slug`),
  ADD KEY `idx_parent` (`parent_id`);

--
-- Chỉ mục cho bảng `invoices`
--
ALTER TABLE `invoices`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_invoice_number` (`invoice_number`),
  ADD KEY `idx_user` (`user_id`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `fk_invoices_payment_id` (`payment_id`);

--
-- Chỉ mục cho bảng `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_queue` (`queue`);

--
-- Chỉ mục cho bảng `job_batches`
--
ALTER TABLE `job_batches`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `listening_history`
--
ALTER TABLE `listening_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_played` (`user_id`,`played_at`),
  ADD KEY `idx_song` (`song_id`);

--
-- Chỉ mục cho bảng `login_history`
--
ALTER TABLE `login_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user` (`user_id`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_ip` (`ip_address`);

--
-- Chỉ mục cho bảng `menu`
--
ALTER TABLE `menu`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_parent` (`parent_id`),
  ADD KEY `idx_active` (`is_active`),
  ADD KEY `fk_menu_module` (`module_id`);

--
-- Chỉ mục cho bảng `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `modules`
--
ALTER TABLE `modules`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_parent` (`parent_id`),
  ADD KEY `idx_active` (`is_active`);

--
-- Chỉ mục cho bảng `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `notifications_user_id_is_read_index` (`user_id`,`is_read`),
  ADD KEY `notifications_user_id_created_at_index` (`user_id`,`created_at`);

--
-- Chỉ mục cho bảng `partners`
--
ALTER TABLE `partners`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user` (`user_id`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `fk_partners_type` (`partner_type_id`);

--
-- Chỉ mục cho bảng `partner_payouts`
--
ALTER TABLE `partner_payouts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_partner` (`partner_id`),
  ADD KEY `idx_status` (`status`);

--
-- Chỉ mục cho bảng `partner_revenues`
--
ALTER TABLE `partner_revenues`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_partner_song_period` (`partner_id`,`song_id`,`period_start`),
  ADD KEY `idx_partner` (`partner_id`),
  ADD KEY `idx_period` (`period_start`,`period_end`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `fk_partner_revenues_song` (`song_id`);

--
-- Chỉ mục cho bảng `partner_types`
--
ALTER TABLE `partner_types`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_code` (`code`);

--
-- Chỉ mục cho bảng `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Chỉ mục cho bảng `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user` (`user_id`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_created` (`created_at`),
  ADD KEY `idx_transfer_content` (`transfer_content`),
  ADD KEY `idx_gateway_transaction` (`gateway_transaction_id`),
  ADD KEY `fk_payments_plan` (`subscription_plan_id`);

--
-- Chỉ mục cho bảng `permissions`
--
ALTER TABLE `permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_permission` (`module_id`,`name`);

--
-- Chỉ mục cho bảng `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_token` (`token`),
  ADD KEY `idx_tokenable` (`tokenable_type`,`tokenable_id`);

--
-- Chỉ mục cho bảng `playlists`
--
ALTER TABLE `playlists`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user` (`user_id`),
  ADD KEY `idx_public` (`is_public`),
  ADD KEY `idx_slug` (`slug`);

--
-- Chỉ mục cho bảng `playlist_collaborators`
--
ALTER TABLE `playlist_collaborators`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_playlist_user` (`playlist_id`,`user_id`),
  ADD KEY `idx_user` (`user_id`);

--
-- Chỉ mục cho bảng `playlist_followers`
--
ALTER TABLE `playlist_followers`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_playlist_follower` (`playlist_id`,`user_id`),
  ADD KEY `idx_user` (`user_id`);

--
-- Chỉ mục cho bảng `playlist_songs`
--
ALTER TABLE `playlist_songs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_playlist` (`playlist_id`),
  ADD KEY `idx_song` (`song_id`),
  ADD KEY `idx_position` (`position`),
  ADD KEY `fk_playlist_songs_user` (`added_by`);

--
-- Chỉ mục cho bảng `recommendations`
--
ALTER TABLE `recommendations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_type` (`user_id`,`recommended_type`),
  ADD KEY `idx_score` (`score`);

--
-- Chỉ mục cho bảng `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_role_name` (`name`);

--
-- Chỉ mục cho bảng `role_permissions`
--
ALTER TABLE `role_permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_role_permission` (`role_id`,`permission_id`),
  ADD KEY `idx_role` (`role_id`),
  ADD KEY `fk_role_permissions_permission` (`permission_id`);

--
-- Chỉ mục cho bảng `security_logs`
--
ALTER TABLE `security_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user` (`user_id`),
  ADD KEY `idx_event` (`event_type`),
  ADD KEY `idx_severity` (`severity`),
  ADD KEY `idx_created` (`created_at`);

--
-- Chỉ mục cho bảng `seo_meta`
--
ALTER TABLE `seo_meta`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_entity` (`entity_type`,`entity_id`),
  ADD KEY `idx_url` (`url_path`(255));

--
-- Chỉ mục cho bảng `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user` (`user_id`),
  ADD KEY `idx_last_activity` (`last_activity`);

--
-- Chỉ mục cho bảng `songs`
--
ALTER TABLE `songs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `slug_unique` (`slug`),
  ADD KEY `artist_id_index` (`artist_id`),
  ADD KEY `album_id_index` (`album_id`),
  ADD KEY `partner_id_index` (`partner_id`),
  ADD KEY `genre_id_index` (`genre_id`);

--
-- Chỉ mục cho bảng `song_artists`
--
ALTER TABLE `song_artists`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_song_artist_role` (`song_id`,`artist_id`,`role`),
  ADD KEY `idx_song` (`song_id`),
  ADD KEY `idx_artist` (`artist_id`);

--
-- Chỉ mục cho bảng `song_downloads`
--
ALTER TABLE `song_downloads`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user` (`user_id`),
  ADD KEY `idx_song` (`song_id`),
  ADD KEY `idx_downloaded` (`downloaded_at`);

--
-- Chỉ mục cho bảng `song_fingerprints`
--
ALTER TABLE `song_fingerprints`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_song_fingerprint` (`song_id`),
  ADD KEY `idx_duration` (`duration`);

--
-- Chỉ mục cho bảng `song_likes`
--
ALTER TABLE `song_likes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_user_song` (`user_id`,`song_id`),
  ADD KEY `idx_song` (`song_id`);

--
-- Chỉ mục cho bảng `song_plays`
--
ALTER TABLE `song_plays`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user` (`user_id`),
  ADD KEY `idx_song` (`song_id`),
  ADD KEY `idx_played_at` (`played_at`),
  ADD KEY `idx_completed` (`is_completed`);

--
-- Chỉ mục cho bảng `subscription_plans`
--
ALTER TABLE `subscription_plans`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_plan_name` (`name`);

--
-- Chỉ mục cho bảng `system_settings`
--
ALTER TABLE `system_settings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_key` (`key`);

--
-- Chỉ mục cho bảng `trending_songs`
--
ALTER TABLE `trending_songs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_song_country_genre` (`song_id`,`country`,`genre_id`),
  ADD KEY `idx_rank` (`rank`),
  ADD KEY `idx_genre` (`genre_id`);

--
-- Chỉ mục cho bảng `two_factor_auth`
--
ALTER TABLE `two_factor_auth`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_user` (`user_id`);

--
-- Chỉ mục cho bảng `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_slug` (`slug`),
  ADD UNIQUE KEY `users_google_id_unique` (`google_id`),
  ADD KEY `idx_trending` (`trending_score`),
  ADD KEY `idx_published` (`published_at`);

--
-- Chỉ mục cho bảng `user_devices`
--
ALTER TABLE `user_devices`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_user_device` (`user_id`,`device_id`),
  ADD KEY `idx_active` (`is_active`);

--
-- Chỉ mục cho bảng `user_engagement_metrics`
--
ALTER TABLE `user_engagement_metrics`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_user_date` (`user_id`,`date`),
  ADD KEY `idx_date` (`date`);

--
-- Chỉ mục cho bảng `user_followers`
--
ALTER TABLE `user_followers`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_follower_following` (`follower_id`,`following_id`),
  ADD KEY `idx_following` (`following_id`);

--
-- Chỉ mục cho bảng `user_preferences`
--
ALTER TABLE `user_preferences`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_user` (`user_id`);

--
-- Chỉ mục cho bảng `user_roles`
--
ALTER TABLE `user_roles`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_role_id` (`role_id`);

--
-- Chỉ mục cho bảng `user_subscriptions`
--
ALTER TABLE `user_subscriptions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_user_subscriptions_user` (`user_id`),
  ADD KEY `fk_user_subscriptions_plan` (`plan_id`);

--
-- Chỉ mục cho bảng `user_taste_profile`
--
ALTER TABLE `user_taste_profile`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_user` (`user_id`);

--
-- AUTO_INCREMENT cho các bảng đã đổ
--

--
-- AUTO_INCREMENT cho bảng `admin_activity_logs`
--
ALTER TABLE `admin_activity_logs`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `advertisements`
--
ALTER TABLE `advertisements`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT cho bảng `ad_priority_tiers`
--
ALTER TABLE `ad_priority_tiers`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT cho bảng `ad_tracking`
--
ALTER TABLE `ad_tracking`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=252;

--
-- AUTO_INCREMENT cho bảng `albums`
--
ALTER TABLE `albums`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT cho bảng `album_likes`
--
ALTER TABLE `album_likes`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT cho bảng `album_tracks`
--
ALTER TABLE `album_tracks`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=78;

--
-- AUTO_INCREMENT cho bảng `api_logs`
--
ALTER TABLE `api_logs`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `artists`
--
ALTER TABLE `artists`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- AUTO_INCREMENT cho bảng `artist_followers`
--
ALTER TABLE `artist_followers`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT cho bảng `comments`
--
ALTER TABLE `comments`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `comment_likes`
--
ALTER TABLE `comment_likes`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `copyrights`
--
ALTER TABLE `copyrights`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT cho bảng `copyright_reports`
--
ALTER TABLE `copyright_reports`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT cho bảng `coupon_codes`
--
ALTER TABLE `coupon_codes`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `coupon_usage`
--
ALTER TABLE `coupon_usage`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `daily_statistics`
--
ALTER TABLE `daily_statistics`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `email_logs`
--
ALTER TABLE `email_logs`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `email_templates`
--
ALTER TABLE `email_templates`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=79;

--
-- AUTO_INCREMENT cho bảng `featured_content`
--
ALTER TABLE `featured_content`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `genres`
--
ALTER TABLE `genres`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT cho bảng `invoices`
--
ALTER TABLE `invoices`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=452;

--
-- AUTO_INCREMENT cho bảng `listening_history`
--
ALTER TABLE `listening_history`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `login_history`
--
ALTER TABLE `login_history`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `menu`
--
ALTER TABLE `menu`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=54;

--
-- AUTO_INCREMENT cho bảng `modules`
--
ALTER TABLE `modules`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT cho bảng `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT cho bảng `partners`
--
ALTER TABLE `partners`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT cho bảng `partner_payouts`
--
ALTER TABLE `partner_payouts`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `partner_revenues`
--
ALTER TABLE `partner_revenues`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=766;

--
-- AUTO_INCREMENT cho bảng `partner_types`
--
ALTER TABLE `partner_types`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT cho bảng `payments`
--
ALTER TABLE `payments`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=90;

--
-- AUTO_INCREMENT cho bảng `permissions`
--
ALTER TABLE `permissions`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=258;

--
-- AUTO_INCREMENT cho bảng `playlists`
--
ALTER TABLE `playlists`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT cho bảng `playlist_collaborators`
--
ALTER TABLE `playlist_collaborators`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `playlist_followers`
--
ALTER TABLE `playlist_followers`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `playlist_songs`
--
ALTER TABLE `playlist_songs`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT cho bảng `recommendations`
--
ALTER TABLE `recommendations`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `roles`
--
ALTER TABLE `roles`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT cho bảng `role_permissions`
--
ALTER TABLE `role_permissions`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `security_logs`
--
ALTER TABLE `security_logs`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `seo_meta`
--
ALTER TABLE `seo_meta`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `songs`
--
ALTER TABLE `songs`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=115;

--
-- AUTO_INCREMENT cho bảng `song_artists`
--
ALTER TABLE `song_artists`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `song_downloads`
--
ALTER TABLE `song_downloads`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT cho bảng `song_fingerprints`
--
ALTER TABLE `song_fingerprints`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `song_likes`
--
ALTER TABLE `song_likes`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=49;

--
-- AUTO_INCREMENT cho bảng `song_plays`
--
ALTER TABLE `song_plays`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=535;

--
-- AUTO_INCREMENT cho bảng `subscription_plans`
--
ALTER TABLE `subscription_plans`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT cho bảng `system_settings`
--
ALTER TABLE `system_settings`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT cho bảng `trending_songs`
--
ALTER TABLE `trending_songs`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `two_factor_auth`
--
ALTER TABLE `two_factor_auth`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT cho bảng `user_devices`
--
ALTER TABLE `user_devices`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `user_engagement_metrics`
--
ALTER TABLE `user_engagement_metrics`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `user_followers`
--
ALTER TABLE `user_followers`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `user_preferences`
--
ALTER TABLE `user_preferences`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `user_roles`
--
ALTER TABLE `user_roles`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=44;

--
-- AUTO_INCREMENT cho bảng `user_subscriptions`
--
ALTER TABLE `user_subscriptions`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=36;

--
-- AUTO_INCREMENT cho bảng `user_taste_profile`
--
ALTER TABLE `user_taste_profile`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- Ràng buộc đối với các bảng kết xuất
--

--
-- Ràng buộc cho bảng `admin_activity_logs`
--
ALTER TABLE `admin_activity_logs`
  ADD CONSTRAINT `fk_admin_activity_logs_admin` FOREIGN KEY (`admin_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Ràng buộc cho bảng `advertisements`
--
ALTER TABLE `advertisements`
  ADD CONSTRAINT `fk_ads_partner` FOREIGN KEY (`partner_id`) REFERENCES `partners` (`id`) ON DELETE SET NULL;

--
-- Ràng buộc cho bảng `ad_tracking`
--
ALTER TABLE `ad_tracking`
  ADD CONSTRAINT `ad_tracking_ad_id_foreign` FOREIGN KEY (`ad_id`) REFERENCES `advertisements` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `ad_tracking_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Ràng buộc cho bảng `album_likes`
--
ALTER TABLE `album_likes`
  ADD CONSTRAINT `fk_album_likes_album` FOREIGN KEY (`album_id`) REFERENCES `albums` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_album_likes_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Ràng buộc cho bảng `api_logs`
--
ALTER TABLE `api_logs`
  ADD CONSTRAINT `fk_api_logs_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Ràng buộc cho bảng `artist_followers`
--
ALTER TABLE `artist_followers`
  ADD CONSTRAINT `fk_artist_followers_artist` FOREIGN KEY (`artist_id`) REFERENCES `artists` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_artist_followers_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Ràng buộc cho bảng `comments`
--
ALTER TABLE `comments`
  ADD CONSTRAINT `fk_comments_parent` FOREIGN KEY (`parent_id`) REFERENCES `comments` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_comments_song` FOREIGN KEY (`song_id`) REFERENCES `songs` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_comments_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Ràng buộc cho bảng `comment_likes`
--
ALTER TABLE `comment_likes`
  ADD CONSTRAINT `fk_comment_likes_comment` FOREIGN KEY (`comment_id`) REFERENCES `comments` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_comment_likes_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Ràng buộc cho bảng `copyrights`
--
ALTER TABLE `copyrights`
  ADD CONSTRAINT `fk_copyrights_partner` FOREIGN KEY (`partner_id`) REFERENCES `partners` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_copyrights_song` FOREIGN KEY (`song_id`) REFERENCES `songs` (`id`) ON DELETE CASCADE;

--
-- Ràng buộc cho bảng `copyright_reports`
--
ALTER TABLE `copyright_reports`
  ADD CONSTRAINT `fk_cr_copyright` FOREIGN KEY (`claimant_copyright_id`) REFERENCES `copyrights` (`id`),
  ADD CONSTRAINT `fk_cr_infringing_song` FOREIGN KEY (`infringing_song_id`) REFERENCES `songs` (`id`),
  ADD CONSTRAINT `fk_cr_original_song` FOREIGN KEY (`original_song_id`) REFERENCES `songs` (`id`),
  ADD CONSTRAINT `fk_cr_partner` FOREIGN KEY (`reporter_partner_id`) REFERENCES `partners` (`id`);

--
-- Ràng buộc cho bảng `coupon_usage`
--
ALTER TABLE `coupon_usage`
  ADD CONSTRAINT `fk_coupon_usage_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Ràng buộc cho bảng `email_logs`
--
ALTER TABLE `email_logs`
  ADD CONSTRAINT `fk_email_logs_template` FOREIGN KEY (`template_id`) REFERENCES `email_templates` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_email_logs_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Ràng buộc cho bảng `invoices`
--
ALTER TABLE `invoices`
  ADD CONSTRAINT `fk_invoices_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Ràng buộc cho bảng `listening_history`
--
ALTER TABLE `listening_history`
  ADD CONSTRAINT `fk_listening_history_song` FOREIGN KEY (`song_id`) REFERENCES `songs` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_listening_history_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Ràng buộc cho bảng `login_history`
--
ALTER TABLE `login_history`
  ADD CONSTRAINT `fk_login_history_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Ràng buộc cho bảng `menu`
--
ALTER TABLE `menu`
  ADD CONSTRAINT `fk_menu_module` FOREIGN KEY (`module_id`) REFERENCES `modules` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_menu_parent` FOREIGN KEY (`parent_id`) REFERENCES `menu` (`id`) ON DELETE CASCADE;

--
-- Ràng buộc cho bảng `modules`
--
ALTER TABLE `modules`
  ADD CONSTRAINT `fk_modules_parent` FOREIGN KEY (`parent_id`) REFERENCES `modules` (`id`) ON DELETE CASCADE;

--
-- Ràng buộc cho bảng `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `notifications_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Ràng buộc cho bảng `partners`
--
ALTER TABLE `partners`
  ADD CONSTRAINT `fk_partners_type` FOREIGN KEY (`partner_type_id`) REFERENCES `partner_types` (`id`),
  ADD CONSTRAINT `fk_partners_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Ràng buộc cho bảng `partner_payouts`
--
ALTER TABLE `partner_payouts`
  ADD CONSTRAINT `fk_partner_payouts_partner` FOREIGN KEY (`partner_id`) REFERENCES `partners` (`id`) ON DELETE CASCADE;

--
-- Ràng buộc cho bảng `partner_revenues`
--
ALTER TABLE `partner_revenues`
  ADD CONSTRAINT `fk_partner_revenues_partner` FOREIGN KEY (`partner_id`) REFERENCES `partners` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_partner_revenues_song` FOREIGN KEY (`song_id`) REFERENCES `songs` (`id`) ON DELETE SET NULL;

--
-- Ràng buộc cho bảng `payments`
--
ALTER TABLE `payments`
  ADD CONSTRAINT `fk_payments_plan` FOREIGN KEY (`subscription_plan_id`) REFERENCES `subscription_plans` (`id`) ON DELETE RESTRICT,
  ADD CONSTRAINT `fk_payments_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Ràng buộc cho bảng `permissions`
--
ALTER TABLE `permissions`
  ADD CONSTRAINT `fk_permissions_module` FOREIGN KEY (`module_id`) REFERENCES `modules` (`id`) ON DELETE CASCADE;

--
-- Ràng buộc cho bảng `playlists`
--
ALTER TABLE `playlists`
  ADD CONSTRAINT `fk_playlists_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Ràng buộc cho bảng `playlist_collaborators`
--
ALTER TABLE `playlist_collaborators`
  ADD CONSTRAINT `fk_playlist_collaborators_playlist` FOREIGN KEY (`playlist_id`) REFERENCES `playlists` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_playlist_collaborators_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Ràng buộc cho bảng `playlist_followers`
--
ALTER TABLE `playlist_followers`
  ADD CONSTRAINT `fk_playlist_followers_playlist` FOREIGN KEY (`playlist_id`) REFERENCES `playlists` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_playlist_followers_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Ràng buộc cho bảng `playlist_songs`
--
ALTER TABLE `playlist_songs`
  ADD CONSTRAINT `fk_playlist_songs_playlist` FOREIGN KEY (`playlist_id`) REFERENCES `playlists` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_playlist_songs_song` FOREIGN KEY (`song_id`) REFERENCES `songs` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_playlist_songs_user` FOREIGN KEY (`added_by`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Ràng buộc cho bảng `recommendations`
--
ALTER TABLE `recommendations`
  ADD CONSTRAINT `fk_recommendations_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Ràng buộc cho bảng `role_permissions`
--
ALTER TABLE `role_permissions`
  ADD CONSTRAINT `fk_role_permissions_permission` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_role_permissions_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE;

--
-- Ràng buộc cho bảng `security_logs`
--
ALTER TABLE `security_logs`
  ADD CONSTRAINT `fk_security_logs_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Ràng buộc cho bảng `songs`
--
ALTER TABLE `songs`
  ADD CONSTRAINT `fk_songs_album` FOREIGN KEY (`album_id`) REFERENCES `albums` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_songs_artist` FOREIGN KEY (`artist_id`) REFERENCES `artists` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_songs_genre` FOREIGN KEY (`genre_id`) REFERENCES `genres` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_songs_partner` FOREIGN KEY (`partner_id`) REFERENCES `partners` (`id`) ON DELETE SET NULL;

--
-- Ràng buộc cho bảng `song_artists`
--
ALTER TABLE `song_artists`
  ADD CONSTRAINT `fk_song_artists_artist` FOREIGN KEY (`artist_id`) REFERENCES `artists` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_song_artists_song` FOREIGN KEY (`song_id`) REFERENCES `songs` (`id`) ON DELETE CASCADE;

--
-- Ràng buộc cho bảng `song_downloads`
--
ALTER TABLE `song_downloads`
  ADD CONSTRAINT `fk_song_downloads_song` FOREIGN KEY (`song_id`) REFERENCES `songs` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_song_downloads_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Ràng buộc cho bảng `song_fingerprints`
--
ALTER TABLE `song_fingerprints`
  ADD CONSTRAINT `fk_fingerprint_song` FOREIGN KEY (`song_id`) REFERENCES `songs` (`id`) ON DELETE CASCADE;

--
-- Ràng buộc cho bảng `song_likes`
--
ALTER TABLE `song_likes`
  ADD CONSTRAINT `fk_song_likes_song` FOREIGN KEY (`song_id`) REFERENCES `songs` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_song_likes_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Ràng buộc cho bảng `song_plays`
--
ALTER TABLE `song_plays`
  ADD CONSTRAINT `fk_song_plays_song` FOREIGN KEY (`song_id`) REFERENCES `songs` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_song_plays_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Ràng buộc cho bảng `trending_songs`
--
ALTER TABLE `trending_songs`
  ADD CONSTRAINT `fk_trending_songs_genre` FOREIGN KEY (`genre_id`) REFERENCES `genres` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_trending_songs_song` FOREIGN KEY (`song_id`) REFERENCES `songs` (`id`) ON DELETE CASCADE;

--
-- Ràng buộc cho bảng `two_factor_auth`
--
ALTER TABLE `two_factor_auth`
  ADD CONSTRAINT `fk_two_factor_auth_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Ràng buộc cho bảng `user_devices`
--
ALTER TABLE `user_devices`
  ADD CONSTRAINT `fk_user_devices_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Ràng buộc cho bảng `user_engagement_metrics`
--
ALTER TABLE `user_engagement_metrics`
  ADD CONSTRAINT `fk_user_engagement_metrics_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Ràng buộc cho bảng `user_followers`
--
ALTER TABLE `user_followers`
  ADD CONSTRAINT `fk_user_followers_follower` FOREIGN KEY (`follower_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_user_followers_following` FOREIGN KEY (`following_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Ràng buộc cho bảng `user_preferences`
--
ALTER TABLE `user_preferences`
  ADD CONSTRAINT `fk_user_preferences_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Ràng buộc cho bảng `user_roles`
--
ALTER TABLE `user_roles`
  ADD CONSTRAINT `fk_user_roles_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_user_roles_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Ràng buộc cho bảng `user_subscriptions`
--
ALTER TABLE `user_subscriptions`
  ADD CONSTRAINT `fk_user_subscriptions_plan` FOREIGN KEY (`plan_id`) REFERENCES `subscription_plans` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_user_subscriptions_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Ràng buộc cho bảng `user_taste_profile`
--
ALTER TABLE `user_taste_profile`
  ADD CONSTRAINT `fk_user_taste_profile_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
