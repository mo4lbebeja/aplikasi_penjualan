/*
 Navicat Premium Data Transfer

 Source Server         : sijalucom
 Source Server Type    : MariaDB
 Source Server Version : 101106 (10.11.6-MariaDB)
 Source Host           : localhost:3306
 Source Schema         : sjl_penjualan

 Target Server Type    : MariaDB
 Target Server Version : 101106 (10.11.6-MariaDB)
 File Encoding         : 65001

 Date: 18/05/2026 02:52:49
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for cache
-- ----------------------------
DROP TABLE IF EXISTS `cache`;
CREATE TABLE `cache` (
  `key` varchar(255) NOT NULL,
  `value` mediumtext NOT NULL,
  `expiration` bigint(20) NOT NULL,
  PRIMARY KEY (`key`),
  KEY `cache_expiration_index` (`expiration`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of cache
-- ----------------------------
BEGIN;
INSERT INTO `cache` (`key`, `value`, `expiration`) VALUES ('laravel-cache-a410f751e54857a2a1a0845cf341d114', 'i:1;', 1779047214);
INSERT INTO `cache` (`key`, `value`, `expiration`) VALUES ('laravel-cache-a410f751e54857a2a1a0845cf341d114:timer', 'i:1779047214;', 1779047214);
COMMIT;

-- ----------------------------
-- Table structure for cache_locks
-- ----------------------------
DROP TABLE IF EXISTS `cache_locks`;
CREATE TABLE `cache_locks` (
  `key` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `expiration` bigint(20) NOT NULL,
  PRIMARY KEY (`key`),
  KEY `cache_locks_expiration_index` (`expiration`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of cache_locks
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for detail_pembelian
-- ----------------------------
DROP TABLE IF EXISTS `detail_pembelian`;
CREATE TABLE `detail_pembelian` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `id_transaksi_pembelian` bigint(20) unsigned NOT NULL,
  `id_produk` bigint(20) unsigned NOT NULL,
  `nama_produk` varchar(200) NOT NULL,
  `harga_beli` decimal(15,2) NOT NULL,
  `jumlah_pesan` int(11) NOT NULL,
  `jumlah_diterima` int(11) NOT NULL DEFAULT 0,
  `diskon_item` decimal(15,2) NOT NULL DEFAULT 0.00,
  `subtotal` decimal(15,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `detail_pembelian_id_produk_foreign` (`id_produk`),
  KEY `detail_pembelian_id_transaksi_pembelian_index` (`id_transaksi_pembelian`),
  CONSTRAINT `detail_pembelian_id_produk_foreign` FOREIGN KEY (`id_produk`) REFERENCES `produk` (`id`),
  CONSTRAINT `detail_pembelian_id_transaksi_pembelian_foreign` FOREIGN KEY (`id_transaksi_pembelian`) REFERENCES `transaksi_pembelian` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of detail_pembelian
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for detail_return_pembelian
-- ----------------------------
DROP TABLE IF EXISTS `detail_return_pembelian`;
CREATE TABLE `detail_return_pembelian` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `id_return_pembelian` bigint(20) unsigned NOT NULL,
  `id_produk` bigint(20) unsigned NOT NULL,
  `nama_produk` varchar(200) NOT NULL,
  `harga_beli` decimal(15,2) NOT NULL,
  `jumlah` int(11) NOT NULL,
  `subtotal` decimal(15,2) NOT NULL,
  `alasan_item` enum('rusak','kadaluarsa','salah_kirim','kelebihan') NOT NULL DEFAULT 'rusak',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `detail_return_pembelian_id_produk_foreign` (`id_produk`),
  KEY `detail_return_pembelian_id_return_pembelian_index` (`id_return_pembelian`),
  CONSTRAINT `detail_return_pembelian_id_produk_foreign` FOREIGN KEY (`id_produk`) REFERENCES `produk` (`id`),
  CONSTRAINT `detail_return_pembelian_id_return_pembelian_foreign` FOREIGN KEY (`id_return_pembelian`) REFERENCES `return_pembelian` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of detail_return_pembelian
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for detail_return_penjualan
-- ----------------------------
DROP TABLE IF EXISTS `detail_return_penjualan`;
CREATE TABLE `detail_return_penjualan` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `id_return_penjualan` bigint(20) unsigned NOT NULL,
  `id_detail_transaksi` bigint(20) unsigned NOT NULL,
  `id_produk` bigint(20) unsigned NOT NULL,
  `nama_produk` varchar(200) NOT NULL,
  `harga_satuan` decimal(15,2) NOT NULL,
  `jumlah_return` int(11) NOT NULL,
  `kondisi_barang` enum('baik','rusak') NOT NULL DEFAULT 'baik',
  `subtotal_refund` decimal(15,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `detail_return_penjualan_id_detail_transaksi_foreign` (`id_detail_transaksi`),
  KEY `detail_return_penjualan_id_produk_foreign` (`id_produk`),
  KEY `detail_return_penjualan_id_return_penjualan_index` (`id_return_penjualan`),
  CONSTRAINT `detail_return_penjualan_id_detail_transaksi_foreign` FOREIGN KEY (`id_detail_transaksi`) REFERENCES `detail_transaksi` (`id`),
  CONSTRAINT `detail_return_penjualan_id_produk_foreign` FOREIGN KEY (`id_produk`) REFERENCES `produk` (`id`),
  CONSTRAINT `detail_return_penjualan_id_return_penjualan_foreign` FOREIGN KEY (`id_return_penjualan`) REFERENCES `return_penjualan` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of detail_return_penjualan
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for detail_transaksi
-- ----------------------------
DROP TABLE IF EXISTS `detail_transaksi`;
CREATE TABLE `detail_transaksi` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `id_transaksi` bigint(20) unsigned NOT NULL,
  `id_produk` bigint(20) unsigned NOT NULL,
  `nama_produk` varchar(200) NOT NULL,
  `harga_satuan` decimal(15,2) NOT NULL,
  `jumlah` int(11) NOT NULL,
  `diskon_item` decimal(15,2) NOT NULL DEFAULT 0.00,
  `subtotal` decimal(15,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `detail_transaksi_id_produk_foreign` (`id_produk`),
  KEY `detail_transaksi_id_transaksi_index` (`id_transaksi`),
  CONSTRAINT `detail_transaksi_id_produk_foreign` FOREIGN KEY (`id_produk`) REFERENCES `produk` (`id`),
  CONSTRAINT `detail_transaksi_id_transaksi_foreign` FOREIGN KEY (`id_transaksi`) REFERENCES `transaksi_penjualan` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of detail_transaksi
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for failed_jobs
-- ----------------------------
DROP TABLE IF EXISTS `failed_jobs`;
CREATE TABLE `failed_jobs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of failed_jobs
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for job_batches
-- ----------------------------
DROP TABLE IF EXISTS `job_batches`;
CREATE TABLE `job_batches` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `total_jobs` int(11) NOT NULL,
  `pending_jobs` int(11) NOT NULL,
  `failed_jobs` int(11) NOT NULL,
  `failed_job_ids` longtext NOT NULL,
  `options` mediumtext DEFAULT NULL,
  `cancelled_at` int(11) DEFAULT NULL,
  `created_at` int(11) NOT NULL,
  `finished_at` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of job_batches
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for jobs
-- ----------------------------
DROP TABLE IF EXISTS `jobs`;
CREATE TABLE `jobs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `queue` varchar(255) NOT NULL,
  `payload` longtext NOT NULL,
  `attempts` smallint(5) unsigned NOT NULL,
  `reserved_at` int(10) unsigned DEFAULT NULL,
  `available_at` int(10) unsigned NOT NULL,
  `created_at` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `jobs_queue_index` (`queue`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of jobs
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for kategori_produk
-- ----------------------------
DROP TABLE IF EXISTS `kategori_produk`;
CREATE TABLE `kategori_produk` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `nama` varchar(100) NOT NULL,
  `slug` varchar(120) NOT NULL,
  `keterangan` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `kategori_produk_slug_unique` (`slug`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of kategori_produk
-- ----------------------------
BEGIN;
INSERT INTO `kategori_produk` (`id`, `nama`, `slug`, `keterangan`, `created_at`, `updated_at`) VALUES (1, 'Beras & Tepung', 'beras-tepung', 'Beras, tepung terigu, tepung beras, sagu', '2026-05-17 19:28:23', '2026-05-17 19:28:23');
INSERT INTO `kategori_produk` (`id`, `nama`, `slug`, `keterangan`, `created_at`, `updated_at`) VALUES (2, 'Minyak & Lemak', 'minyak-lemak', 'Minyak goreng, margarin, mentega', '2026-05-17 19:28:23', '2026-05-17 19:28:23');
INSERT INTO `kategori_produk` (`id`, `nama`, `slug`, `keterangan`, `created_at`, `updated_at`) VALUES (3, 'Bumbu & Rempah', 'bumbu-rempah', 'Gula, garam, kecap, saus, bumbu dapur', '2026-05-17 19:28:23', '2026-05-17 19:28:23');
INSERT INTO `kategori_produk` (`id`, `nama`, `slug`, `keterangan`, `created_at`, `updated_at`) VALUES (4, 'Mie & Pasta', 'mie-pasta', 'Mie instan, bihun, soun, pasta', '2026-05-17 19:28:23', '2026-05-17 19:28:23');
INSERT INTO `kategori_produk` (`id`, `nama`, `slug`, `keterangan`, `created_at`, `updated_at`) VALUES (5, 'Protein & Lauk', 'protein-lauk', 'Telur, ikan kaleng, kornet, sarden', '2026-05-17 19:28:23', '2026-05-17 19:28:23');
INSERT INTO `kategori_produk` (`id`, `nama`, `slug`, `keterangan`, `created_at`, `updated_at`) VALUES (6, 'Susu & Minuman', 'susu-minuman', 'Susu, kopi, teh, minuman serbuk', '2026-05-17 19:28:23', '2026-05-17 19:28:23');
INSERT INTO `kategori_produk` (`id`, `nama`, `slug`, `keterangan`, `created_at`, `updated_at`) VALUES (7, 'Snack & Camilan', 'snack-camilan', 'Kerupuk, biskuit, wafer, permen', '2026-05-17 19:28:23', '2026-05-17 19:28:23');
INSERT INTO `kategori_produk` (`id`, `nama`, `slug`, `keterangan`, `created_at`, `updated_at`) VALUES (8, 'Kebersihan Rumah', 'kebersihan-rumah', 'Sabun cuci, detergen, pewangi, pel', '2026-05-17 19:28:23', '2026-05-17 19:28:23');
INSERT INTO `kategori_produk` (`id`, `nama`, `slug`, `keterangan`, `created_at`, `updated_at`) VALUES (9, 'Kebersihan Diri', 'kebersihan-diri', 'Sabun mandi, sampo, pasta gigi, sikat gigi', '2026-05-17 19:28:23', '2026-05-17 19:28:23');
INSERT INTO `kategori_produk` (`id`, `nama`, `slug`, `keterangan`, `created_at`, `updated_at`) VALUES (10, 'Rokok', 'rokok', 'Rokok kretek, rokok putih', '2026-05-17 19:28:23', '2026-05-17 19:28:23');
COMMIT;

-- ----------------------------
-- Table structure for migrations
-- ----------------------------
DROP TABLE IF EXISTS `migrations`;
CREATE TABLE `migrations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of migrations
-- ----------------------------
BEGIN;
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (1, '0001_01_01_000000_create_users_table', 1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (2, '0001_01_01_000001_create_cache_table', 1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (3, '0001_01_01_000002_create_jobs_table', 1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (4, '2024_01_01_000001_modify_users_table_tambah_peran', 1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (5, '2024_01_01_000002_create_kategori_produk_table', 1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (6, '2024_01_01_000003_create_satuan_table', 1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (7, '2024_01_01_000004_create_supplier_table', 1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (8, '2024_01_01_000005_create_produk_table', 1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (9, '2024_01_01_000006_create_pelanggan_table', 1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (10, '2024_01_01_000007_create_transaksi_penjualan_table', 1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (11, '2024_01_01_000008_create_detail_transaksi_table', 1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (12, '2024_01_01_000009_create_stok_masuk_table', 1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (13, '2024_01_01_000010_create_transaksi_pembelian_table', 1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (14, '2024_01_01_000011_create_detail_pembelian_table', 1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (15, '2024_01_01_000012_create_return_penjualan_table', 1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (16, '2024_01_01_000013_create_detail_return_penjualan_table', 1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (17, '2024_01_01_000014_create_return_pembelian_table', 1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (18, '2024_01_01_000015_create_detail_return_pembelian_table', 1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (19, '2024_01_01_000016_modify_stok_masuk_tambah_sumber', 1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (20, '2025_08_14_170933_add_two_factor_columns_to_users_table', 1);
COMMIT;

-- ----------------------------
-- Table structure for password_reset_tokens
-- ----------------------------
DROP TABLE IF EXISTS `password_reset_tokens`;
CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of password_reset_tokens
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for pelanggan
-- ----------------------------
DROP TABLE IF EXISTS `pelanggan`;
CREATE TABLE `pelanggan` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `kode_pelanggan` varchar(20) NOT NULL,
  `nama` varchar(150) NOT NULL,
  `telepon` varchar(20) DEFAULT NULL,
  `alamat` text DEFAULT NULL,
  `poin` int(11) NOT NULL DEFAULT 0,
  `total_pembelian` decimal(15,2) NOT NULL DEFAULT 0.00,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `pelanggan_kode_pelanggan_unique` (`kode_pelanggan`),
  UNIQUE KEY `pelanggan_telepon_unique` (`telepon`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of pelanggan
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for produk
-- ----------------------------
DROP TABLE IF EXISTS `produk`;
CREATE TABLE `produk` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `kode_produk` varchar(30) NOT NULL,
  `barcode` varchar(50) DEFAULT NULL,
  `nama` varchar(200) NOT NULL,
  `id_kategori_produk` bigint(20) unsigned NOT NULL,
  `id_satuan` bigint(20) unsigned NOT NULL,
  `harga_beli` decimal(15,2) NOT NULL DEFAULT 0.00,
  `harga_jual` decimal(15,2) NOT NULL,
  `stok` int(11) NOT NULL DEFAULT 0,
  `stok_minimum` int(11) NOT NULL DEFAULT 5,
  `gambar` varchar(255) DEFAULT NULL,
  `keterangan` text DEFAULT NULL,
  `aktif` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `produk_kode_produk_unique` (`kode_produk`),
  UNIQUE KEY `produk_barcode_unique` (`barcode`),
  KEY `produk_id_kategori_produk_foreign` (`id_kategori_produk`),
  KEY `produk_id_satuan_foreign` (`id_satuan`),
  KEY `produk_nama_index` (`nama`),
  KEY `produk_aktif_index` (`aktif`),
  CONSTRAINT `produk_id_kategori_produk_foreign` FOREIGN KEY (`id_kategori_produk`) REFERENCES `kategori_produk` (`id`),
  CONSTRAINT `produk_id_satuan_foreign` FOREIGN KEY (`id_satuan`) REFERENCES `satuan` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of produk
-- ----------------------------
BEGIN;
INSERT INTO `produk` (`id`, `kode_produk`, `barcode`, `nama`, `id_kategori_produk`, `id_satuan`, `harga_beli`, `harga_jual`, `stok`, `stok_minimum`, `gambar`, `keterangan`, `aktif`, `created_at`, `updated_at`, `deleted_at`) VALUES (1, 'PRD-0001', NULL, 'Beras Premium 5kg', 1, 11, 55000.00, 62000.00, 50, 10, NULL, NULL, 1, '2026-05-17 19:28:23', '2026-05-17 19:28:23', NULL);
INSERT INTO `produk` (`id`, `kode_produk`, `barcode`, `nama`, `id_kategori_produk`, `id_satuan`, `harga_beli`, `harga_jual`, `stok`, `stok_minimum`, `gambar`, `keterangan`, `aktif`, `created_at`, `updated_at`, `deleted_at`) VALUES (2, 'PRD-0002', NULL, 'Beras Medium 5kg', 1, 11, 47000.00, 53000.00, 80, 15, NULL, NULL, 1, '2026-05-17 19:28:23', '2026-05-17 19:28:23', NULL);
INSERT INTO `produk` (`id`, `kode_produk`, `barcode`, `nama`, `id_kategori_produk`, `id_satuan`, `harga_beli`, `harga_jual`, `stok`, `stok_minimum`, `gambar`, `keterangan`, `aktif`, `created_at`, `updated_at`, `deleted_at`) VALUES (3, 'PRD-0003', NULL, 'Tepung Terigu Cakra 1kg', 1, 1, 9500.00, 11500.00, 40, 8, NULL, NULL, 1, '2026-05-17 19:28:23', '2026-05-17 19:28:23', NULL);
INSERT INTO `produk` (`id`, `kode_produk`, `barcode`, `nama`, `id_kategori_produk`, `id_satuan`, `harga_beli`, `harga_jual`, `stok`, `stok_minimum`, `gambar`, `keterangan`, `aktif`, `created_at`, `updated_at`, `deleted_at`) VALUES (4, 'PRD-0004', NULL, 'Minyak Goreng 1L', 2, 3, 14500.00, 17000.00, 60, 10, NULL, NULL, 1, '2026-05-17 19:28:23', '2026-05-17 19:28:23', NULL);
INSERT INTO `produk` (`id`, `kode_produk`, `barcode`, `nama`, `id_kategori_produk`, `id_satuan`, `harga_beli`, `harga_jual`, `stok`, `stok_minimum`, `gambar`, `keterangan`, `aktif`, `created_at`, `updated_at`, `deleted_at`) VALUES (5, 'PRD-0005', NULL, 'Minyak Goreng 2L', 2, 3, 28000.00, 32000.00, 40, 10, NULL, NULL, 1, '2026-05-17 19:28:23', '2026-05-17 19:28:23', NULL);
INSERT INTO `produk` (`id`, `kode_produk`, `barcode`, `nama`, `id_kategori_produk`, `id_satuan`, `harga_beli`, `harga_jual`, `stok`, `stok_minimum`, `gambar`, `keterangan`, `aktif`, `created_at`, `updated_at`, `deleted_at`) VALUES (6, 'PRD-0006', NULL, 'Gula Pasir 1kg', 3, 1, 12000.00, 14500.00, 55, 10, NULL, NULL, 1, '2026-05-17 19:28:23', '2026-05-17 19:28:23', NULL);
INSERT INTO `produk` (`id`, `kode_produk`, `barcode`, `nama`, `id_kategori_produk`, `id_satuan`, `harga_beli`, `harga_jual`, `stok`, `stok_minimum`, `gambar`, `keterangan`, `aktif`, `created_at`, `updated_at`, `deleted_at`) VALUES (7, 'PRD-0007', NULL, 'Garam Halus', 3, 6, 1500.00, 2500.00, 80, 15, NULL, NULL, 1, '2026-05-17 19:28:23', '2026-05-17 19:28:23', NULL);
INSERT INTO `produk` (`id`, `kode_produk`, `barcode`, `nama`, `id_kategori_produk`, `id_satuan`, `harga_beli`, `harga_jual`, `stok`, `stok_minimum`, `gambar`, `keterangan`, `aktif`, `created_at`, `updated_at`, `deleted_at`) VALUES (8, 'PRD-0008', NULL, 'Kecap Manis 135ml', 3, 7, 7000.00, 9500.00, 35, 8, NULL, NULL, 1, '2026-05-17 19:28:23', '2026-05-17 19:28:23', NULL);
INSERT INTO `produk` (`id`, `kode_produk`, `barcode`, `nama`, `id_kategori_produk`, `id_satuan`, `harga_beli`, `harga_jual`, `stok`, `stok_minimum`, `gambar`, `keterangan`, `aktif`, `created_at`, `updated_at`, `deleted_at`) VALUES (9, 'PRD-0009', NULL, 'Indomie Goreng', 4, 6, 2800.00, 3500.00, 200, 30, NULL, NULL, 1, '2026-05-17 19:28:23', '2026-05-17 19:28:23', NULL);
INSERT INTO `produk` (`id`, `kode_produk`, `barcode`, `nama`, `id_kategori_produk`, `id_satuan`, `harga_beli`, `harga_jual`, `stok`, `stok_minimum`, `gambar`, `keterangan`, `aktif`, `created_at`, `updated_at`, `deleted_at`) VALUES (10, 'PRD-0010', NULL, 'Indomie Kuah', 4, 6, 2800.00, 3500.00, 150, 30, NULL, NULL, 1, '2026-05-17 19:28:23', '2026-05-17 19:28:23', NULL);
INSERT INTO `produk` (`id`, `kode_produk`, `barcode`, `nama`, `id_kategori_produk`, `id_satuan`, `harga_beli`, `harga_jual`, `stok`, `stok_minimum`, `gambar`, `keterangan`, `aktif`, `created_at`, `updated_at`, `deleted_at`) VALUES (11, 'PRD-0011', NULL, 'Telur Ayam', 5, 5, 2200.00, 2800.00, 150, 20, NULL, NULL, 1, '2026-05-17 19:28:23', '2026-05-17 19:28:23', NULL);
INSERT INTO `produk` (`id`, `kode_produk`, `barcode`, `nama`, `id_kategori_produk`, `id_satuan`, `harga_beli`, `harga_jual`, `stok`, `stok_minimum`, `gambar`, `keterangan`, `aktif`, `created_at`, `updated_at`, `deleted_at`) VALUES (12, 'PRD-0012', NULL, 'Sarden ABC 155gr', 5, 8, 9500.00, 12000.00, 25, 5, NULL, NULL, 1, '2026-05-17 19:28:23', '2026-05-17 19:28:23', NULL);
INSERT INTO `produk` (`id`, `kode_produk`, `barcode`, `nama`, `id_kategori_produk`, `id_satuan`, `harga_beli`, `harga_jual`, `stok`, `stok_minimum`, `gambar`, `keterangan`, `aktif`, `created_at`, `updated_at`, `deleted_at`) VALUES (13, 'PRD-0013', NULL, 'Susu Kental Manis', 6, 8, 10000.00, 13000.00, 30, 8, NULL, NULL, 1, '2026-05-17 19:28:23', '2026-05-17 19:28:23', NULL);
INSERT INTO `produk` (`id`, `kode_produk`, `barcode`, `nama`, `id_kategori_produk`, `id_satuan`, `harga_beli`, `harga_jual`, `stok`, `stok_minimum`, `gambar`, `keterangan`, `aktif`, `created_at`, `updated_at`, `deleted_at`) VALUES (14, 'PRD-0014', NULL, 'Kopi Sachet Good Day', 6, 6, 1500.00, 2000.00, 100, 20, NULL, NULL, 1, '2026-05-17 19:28:23', '2026-05-17 19:28:23', NULL);
INSERT INTO `produk` (`id`, `kode_produk`, `barcode`, `nama`, `id_kategori_produk`, `id_satuan`, `harga_beli`, `harga_jual`, `stok`, `stok_minimum`, `gambar`, `keterangan`, `aktif`, `created_at`, `updated_at`, `deleted_at`) VALUES (15, 'PRD-0015', NULL, 'Teh Celup Sosro 25pc', 6, 6, 7500.00, 10000.00, 40, 8, NULL, NULL, 1, '2026-05-17 19:28:23', '2026-05-17 19:28:23', NULL);
INSERT INTO `produk` (`id`, `kode_produk`, `barcode`, `nama`, `id_kategori_produk`, `id_satuan`, `harga_beli`, `harga_jual`, `stok`, `stok_minimum`, `gambar`, `keterangan`, `aktif`, `created_at`, `updated_at`, `deleted_at`) VALUES (16, 'PRD-0016', NULL, 'Sabun Cuci Rinso 800gr', 8, 6, 14000.00, 18000.00, 30, 6, NULL, NULL, 1, '2026-05-17 19:28:23', '2026-05-17 19:28:23', NULL);
INSERT INTO `produk` (`id`, `kode_produk`, `barcode`, `nama`, `id_kategori_produk`, `id_satuan`, `harga_beli`, `harga_jual`, `stok`, `stok_minimum`, `gambar`, `keterangan`, `aktif`, `created_at`, `updated_at`, `deleted_at`) VALUES (17, 'PRD-0017', NULL, 'Detergen Attack 800gr', 8, 6, 13500.00, 17000.00, 25, 6, NULL, NULL, 1, '2026-05-17 19:28:23', '2026-05-17 19:28:23', NULL);
INSERT INTO `produk` (`id`, `kode_produk`, `barcode`, `nama`, `id_kategori_produk`, `id_satuan`, `harga_beli`, `harga_jual`, `stok`, `stok_minimum`, `gambar`, `keterangan`, `aktif`, `created_at`, `updated_at`, `deleted_at`) VALUES (18, 'PRD-0018', NULL, 'Sabun Mandi Lifebuoy', 9, 6, 3500.00, 5000.00, 45, 10, NULL, NULL, 1, '2026-05-17 19:28:23', '2026-05-17 19:28:23', NULL);
INSERT INTO `produk` (`id`, `kode_produk`, `barcode`, `nama`, `id_kategori_produk`, `id_satuan`, `harga_beli`, `harga_jual`, `stok`, `stok_minimum`, `gambar`, `keterangan`, `aktif`, `created_at`, `updated_at`, `deleted_at`) VALUES (19, 'PRD-0019', NULL, 'Sampo Pantene 170ml', 9, 7, 18000.00, 23000.00, 20, 5, NULL, NULL, 1, '2026-05-17 19:28:23', '2026-05-17 19:28:23', NULL);
INSERT INTO `produk` (`id`, `kode_produk`, `barcode`, `nama`, `id_kategori_produk`, `id_satuan`, `harga_beli`, `harga_jual`, `stok`, `stok_minimum`, `gambar`, `keterangan`, `aktif`, `created_at`, `updated_at`, `deleted_at`) VALUES (20, 'PRD-0020', NULL, 'Pasta Gigi Pepsodent', 9, 6, 9000.00, 12000.00, 35, 8, NULL, NULL, 1, '2026-05-17 19:28:23', '2026-05-17 19:28:23', NULL);
COMMIT;

-- ----------------------------
-- Table structure for return_pembelian
-- ----------------------------
DROP TABLE IF EXISTS `return_pembelian`;
CREATE TABLE `return_pembelian` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `kode_return` varchar(30) NOT NULL,
  `id_transaksi_pembelian` bigint(20) unsigned DEFAULT NULL,
  `id_supplier` bigint(20) unsigned NOT NULL,
  `id_pengguna` bigint(20) unsigned NOT NULL,
  `total_return` decimal(15,2) NOT NULL DEFAULT 0.00,
  `penyelesaian` enum('kredit','ganti_barang','tunai') NOT NULL DEFAULT 'kredit',
  `status` enum('disiapkan','dikirim','diterima_supplier','selesai') NOT NULL DEFAULT 'disiapkan',
  `alasan` text DEFAULT NULL,
  `keterangan` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `return_pembelian_kode_return_unique` (`kode_return`),
  KEY `return_pembelian_id_transaksi_pembelian_foreign` (`id_transaksi_pembelian`),
  KEY `return_pembelian_id_pengguna_foreign` (`id_pengguna`),
  KEY `return_pembelian_id_supplier_status_index` (`id_supplier`,`status`),
  CONSTRAINT `return_pembelian_id_pengguna_foreign` FOREIGN KEY (`id_pengguna`) REFERENCES `users` (`id`),
  CONSTRAINT `return_pembelian_id_supplier_foreign` FOREIGN KEY (`id_supplier`) REFERENCES `supplier` (`id`),
  CONSTRAINT `return_pembelian_id_transaksi_pembelian_foreign` FOREIGN KEY (`id_transaksi_pembelian`) REFERENCES `transaksi_pembelian` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of return_pembelian
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for return_penjualan
-- ----------------------------
DROP TABLE IF EXISTS `return_penjualan`;
CREATE TABLE `return_penjualan` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `kode_return` varchar(30) NOT NULL,
  `id_transaksi_penjualan` bigint(20) unsigned NOT NULL,
  `id_pengguna` bigint(20) unsigned NOT NULL,
  `total_refund` decimal(15,2) NOT NULL DEFAULT 0.00,
  `metode_refund` enum('tunai','poin','kredit_toko') NOT NULL DEFAULT 'tunai',
  `status` enum('diproses','selesai','ditolak') NOT NULL DEFAULT 'diproses',
  `alasan` text DEFAULT NULL,
  `keterangan` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `return_penjualan_kode_return_unique` (`kode_return`),
  KEY `return_penjualan_id_pengguna_foreign` (`id_pengguna`),
  KEY `return_penjualan_id_transaksi_penjualan_index` (`id_transaksi_penjualan`),
  CONSTRAINT `return_penjualan_id_pengguna_foreign` FOREIGN KEY (`id_pengguna`) REFERENCES `users` (`id`),
  CONSTRAINT `return_penjualan_id_transaksi_penjualan_foreign` FOREIGN KEY (`id_transaksi_penjualan`) REFERENCES `transaksi_penjualan` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of return_penjualan
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for satuan
-- ----------------------------
DROP TABLE IF EXISTS `satuan`;
CREATE TABLE `satuan` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `nama` varchar(50) NOT NULL,
  `singkatan` varchar(10) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of satuan
-- ----------------------------
BEGIN;
INSERT INTO `satuan` (`id`, `nama`, `singkatan`, `created_at`, `updated_at`) VALUES (1, 'Kilogram', 'kg', '2026-05-17 19:28:23', '2026-05-17 19:28:23');
INSERT INTO `satuan` (`id`, `nama`, `singkatan`, `created_at`, `updated_at`) VALUES (2, 'Gram', 'gr', '2026-05-17 19:28:23', '2026-05-17 19:28:23');
INSERT INTO `satuan` (`id`, `nama`, `singkatan`, `created_at`, `updated_at`) VALUES (3, 'Liter', 'ltr', '2026-05-17 19:28:23', '2026-05-17 19:28:23');
INSERT INTO `satuan` (`id`, `nama`, `singkatan`, `created_at`, `updated_at`) VALUES (4, 'Mililiter', 'ml', '2026-05-17 19:28:23', '2026-05-17 19:28:23');
INSERT INTO `satuan` (`id`, `nama`, `singkatan`, `created_at`, `updated_at`) VALUES (5, 'Butir', 'btr', '2026-05-17 19:28:23', '2026-05-17 19:28:23');
INSERT INTO `satuan` (`id`, `nama`, `singkatan`, `created_at`, `updated_at`) VALUES (6, 'Bungkus', 'bks', '2026-05-17 19:28:23', '2026-05-17 19:28:23');
INSERT INTO `satuan` (`id`, `nama`, `singkatan`, `created_at`, `updated_at`) VALUES (7, 'Botol', 'btl', '2026-05-17 19:28:23', '2026-05-17 19:28:23');
INSERT INTO `satuan` (`id`, `nama`, `singkatan`, `created_at`, `updated_at`) VALUES (8, 'Kaleng', 'klg', '2026-05-17 19:28:23', '2026-05-17 19:28:23');
INSERT INTO `satuan` (`id`, `nama`, `singkatan`, `created_at`, `updated_at`) VALUES (9, 'Lusin', 'lsn', '2026-05-17 19:28:23', '2026-05-17 19:28:23');
INSERT INTO `satuan` (`id`, `nama`, `singkatan`, `created_at`, `updated_at`) VALUES (10, 'Pcs', 'pcs', '2026-05-17 19:28:23', '2026-05-17 19:28:23');
INSERT INTO `satuan` (`id`, `nama`, `singkatan`, `created_at`, `updated_at`) VALUES (11, 'Karton', 'ktn', '2026-05-17 19:28:23', '2026-05-17 19:28:23');
COMMIT;

-- ----------------------------
-- Table structure for sessions
-- ----------------------------
DROP TABLE IF EXISTS `sessions`;
CREATE TABLE `sessions` (
  `id` varchar(255) NOT NULL,
  `user_id` bigint(20) unsigned DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` longtext NOT NULL,
  `last_activity` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sessions_user_id_index` (`user_id`),
  KEY `sessions_last_activity_index` (`last_activity`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of sessions
-- ----------------------------
BEGIN;
INSERT INTO `sessions` (`id`, `user_id`, `ip_address`, `user_agent`, `payload`, `last_activity`) VALUES ('61lOBytrxDaOxs5vwDkA0rPjiyhHM9QRgyo63SJa', 1, '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', 'eyJfdG9rZW4iOiJGM1dBdWpVcUhvWEpsUnR0M3RmVmhTZWFvMWJHQ09ZdVRrQ29DZ3BQIiwiX3ByZXZpb3VzIjp7InVybCI6Imh0dHA6XC9cL2FwbGlrYXNpLXBlbmp1YWxhbi50ZXN0Iiwicm91dGUiOiJob21lIn0sIl9mbGFzaCI6eyJvbGQiOltdLCJuZXciOltdfSwibG9naW5fd2ViXzU5YmEzNmFkZGMyYjJmOTQwMTU4MGYwMTRjN2Y1OGVhNGUzMDk4OWQiOjF9', 1779047163);
INSERT INTO `sessions` (`id`, `user_id`, `ip_address`, `user_agent`, `payload`, `last_activity`) VALUES ('leSCHKcKfWt1RwMzJOYHRhBcxL6sFeXX3rtPHydI', NULL, '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko)', 'eyJfdG9rZW4iOiJncHRBSnJ5WThyVldoamZ6WmE1NzY1WDlvYU10SXBpdUpVeDJqN01pIiwiX3ByZXZpb3VzIjp7InVybCI6Imh0dHA6XC9cL2FwbGlrYXNpLXBlbmp1YWxhbi50ZXN0XC8/aGVyZD1wcmV2aWV3Iiwicm91dGUiOiJob21lIn0sIl9mbGFzaCI6eyJvbGQiOltdLCJuZXciOltdfX0=', 1779047136);
INSERT INTO `sessions` (`id`, `user_id`, `ip_address`, `user_agent`, `payload`, `last_activity`) VALUES ('Rd7rOMJhbNNhOzCrXHIT4FhmXvtWFsD2exgahLU8', NULL, '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', 'eyJfdG9rZW4iOiIzbEx0ME43QXREem56aVdtc285d2pyNVByOHMwSVdnVHhVRWNFOEx1IiwiX3ByZXZpb3VzIjp7InVybCI6Imh0dHA6XC9cL2FwbGlrYXNpLXBlbmp1YWxhbi50ZXN0XC9sb2dpbiIsInJvdXRlIjoibG9naW4ifSwiX2ZsYXNoIjp7Im9sZCI6W10sIm5ldyI6W119fQ==', 1779046766);
COMMIT;

-- ----------------------------
-- Table structure for stok_masuk
-- ----------------------------
DROP TABLE IF EXISTS `stok_masuk`;
CREATE TABLE `stok_masuk` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `kode_stok` varchar(30) NOT NULL,
  `jenis` enum('pembelian','penyesuaian','retur') NOT NULL DEFAULT 'pembelian',
  `id_transaksi_pembelian` bigint(20) unsigned DEFAULT NULL,
  `id_produk` bigint(20) unsigned NOT NULL,
  `id_supplier` bigint(20) unsigned DEFAULT NULL,
  `id_pengguna` bigint(20) unsigned NOT NULL,
  `jumlah` int(11) NOT NULL,
  `stok_sebelum` int(11) NOT NULL,
  `stok_sesudah` int(11) NOT NULL,
  `harga_beli` decimal(15,2) NOT NULL DEFAULT 0.00,
  `total_harga` decimal(15,2) NOT NULL DEFAULT 0.00,
  `no_faktur` varchar(50) DEFAULT NULL,
  `keterangan` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `stok_masuk_kode_stok_unique` (`kode_stok`),
  KEY `stok_masuk_id_supplier_foreign` (`id_supplier`),
  KEY `stok_masuk_id_pengguna_foreign` (`id_pengguna`),
  KEY `stok_masuk_id_produk_created_at_index` (`id_produk`,`created_at`),
  KEY `stok_masuk_id_transaksi_pembelian_foreign` (`id_transaksi_pembelian`),
  CONSTRAINT `stok_masuk_id_pengguna_foreign` FOREIGN KEY (`id_pengguna`) REFERENCES `users` (`id`),
  CONSTRAINT `stok_masuk_id_produk_foreign` FOREIGN KEY (`id_produk`) REFERENCES `produk` (`id`),
  CONSTRAINT `stok_masuk_id_supplier_foreign` FOREIGN KEY (`id_supplier`) REFERENCES `supplier` (`id`) ON DELETE SET NULL,
  CONSTRAINT `stok_masuk_id_transaksi_pembelian_foreign` FOREIGN KEY (`id_transaksi_pembelian`) REFERENCES `transaksi_pembelian` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of stok_masuk
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for supplier
-- ----------------------------
DROP TABLE IF EXISTS `supplier`;
CREATE TABLE `supplier` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `kode_supplier` varchar(20) NOT NULL,
  `nama` varchar(150) NOT NULL,
  `nama_kontak` varchar(100) DEFAULT NULL,
  `telepon` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `alamat` text DEFAULT NULL,
  `keterangan` text DEFAULT NULL,
  `aktif` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `supplier_kode_supplier_unique` (`kode_supplier`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of supplier
-- ----------------------------
BEGIN;
INSERT INTO `supplier` (`id`, `kode_supplier`, `nama`, `nama_kontak`, `telepon`, `email`, `alamat`, `keterangan`, `aktif`, `created_at`, `updated_at`) VALUES (1, 'SUP-001', 'CV Sumber Makmur', 'Budi Santoso', '081234567890', NULL, 'Jl. Pasar Raya No.12, Bandung', NULL, 1, '2026-05-17 19:28:23', '2026-05-17 19:28:23');
INSERT INTO `supplier` (`id`, `kode_supplier`, `nama`, `nama_kontak`, `telepon`, `email`, `alamat`, `keterangan`, `aktif`, `created_at`, `updated_at`) VALUES (2, 'SUP-002', 'PT Indofood Distributor', 'Dian Pertiwi', '082345678901', NULL, 'Jl. Industri No.45, Jakarta', NULL, 1, '2026-05-17 19:28:23', '2026-05-17 19:28:23');
COMMIT;

-- ----------------------------
-- Table structure for transaksi_pembelian
-- ----------------------------
DROP TABLE IF EXISTS `transaksi_pembelian`;
CREATE TABLE `transaksi_pembelian` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `kode_pembelian` varchar(30) NOT NULL,
  `id_supplier` bigint(20) unsigned NOT NULL,
  `id_pengguna` bigint(20) unsigned NOT NULL,
  `status` enum('draft','dipesan','sebagian','diterima','batal') NOT NULL DEFAULT 'draft',
  `subtotal` decimal(15,2) NOT NULL DEFAULT 0.00,
  `diskon` decimal(15,2) NOT NULL DEFAULT 0.00,
  `biaya_kirim` decimal(15,2) NOT NULL DEFAULT 0.00,
  `total` decimal(15,2) NOT NULL DEFAULT 0.00,
  `total_bayar` decimal(15,2) NOT NULL DEFAULT 0.00,
  `sisa_tagihan` decimal(15,2) NOT NULL DEFAULT 0.00,
  `metode_bayar` enum('tunai','transfer','tempo') NOT NULL DEFAULT 'tunai',
  `jatuh_tempo` date DEFAULT NULL,
  `no_faktur_supplier` varchar(60) DEFAULT NULL,
  `tanggal_faktur` date DEFAULT NULL,
  `keterangan` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `transaksi_pembelian_kode_pembelian_unique` (`kode_pembelian`),
  KEY `transaksi_pembelian_id_pengguna_foreign` (`id_pengguna`),
  KEY `transaksi_pembelian_id_supplier_status_index` (`id_supplier`,`status`),
  KEY `transaksi_pembelian_created_at_status_index` (`created_at`,`status`),
  CONSTRAINT `transaksi_pembelian_id_pengguna_foreign` FOREIGN KEY (`id_pengguna`) REFERENCES `users` (`id`),
  CONSTRAINT `transaksi_pembelian_id_supplier_foreign` FOREIGN KEY (`id_supplier`) REFERENCES `supplier` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of transaksi_pembelian
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for transaksi_penjualan
-- ----------------------------
DROP TABLE IF EXISTS `transaksi_penjualan`;
CREATE TABLE `transaksi_penjualan` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `kode_transaksi` varchar(30) NOT NULL,
  `id_pelanggan` bigint(20) unsigned DEFAULT NULL,
  `id_pengguna` bigint(20) unsigned NOT NULL,
  `subtotal` decimal(15,2) NOT NULL,
  `diskon` decimal(15,2) NOT NULL DEFAULT 0.00,
  `total` decimal(15,2) NOT NULL,
  `total_bayar` decimal(15,2) NOT NULL,
  `kembalian` decimal(15,2) NOT NULL DEFAULT 0.00,
  `metode_bayar` enum('tunai','debit','kredit','qris','transfer') NOT NULL DEFAULT 'tunai',
  `status` enum('selesai','batal','menunggu') NOT NULL DEFAULT 'selesai',
  `keterangan` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `transaksi_penjualan_kode_transaksi_unique` (`kode_transaksi`),
  KEY `transaksi_penjualan_id_pelanggan_foreign` (`id_pelanggan`),
  KEY `transaksi_penjualan_id_pengguna_foreign` (`id_pengguna`),
  KEY `transaksi_penjualan_kode_transaksi_index` (`kode_transaksi`),
  KEY `transaksi_penjualan_created_at_status_index` (`created_at`,`status`),
  CONSTRAINT `transaksi_penjualan_id_pelanggan_foreign` FOREIGN KEY (`id_pelanggan`) REFERENCES `pelanggan` (`id`) ON DELETE SET NULL,
  CONSTRAINT `transaksi_penjualan_id_pengguna_foreign` FOREIGN KEY (`id_pengguna`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of transaksi_penjualan
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `nama` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `peran` enum('admin','kasir') NOT NULL DEFAULT 'kasir',
  `aktif` tinyint(1) NOT NULL DEFAULT 1,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `two_factor_secret` text DEFAULT NULL,
  `two_factor_recovery_codes` text DEFAULT NULL,
  `two_factor_confirmed_at` timestamp NULL DEFAULT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of users
-- ----------------------------
BEGIN;
INSERT INTO `users` (`id`, `nama`, `email`, `peran`, `aktif`, `email_verified_at`, `password`, `two_factor_secret`, `two_factor_recovery_codes`, `two_factor_confirmed_at`, `remember_token`, `created_at`, `updated_at`) VALUES (1, 'Administrator', 'admin@toko.com', 'admin', 1, NULL, '$2y$12$1Pe7PJBpLMaXOCkkBNL3EORHdjmAN6iSMXf95RPLv1O6vACEYaYsS', NULL, NULL, NULL, NULL, '2026-05-17 19:28:23', '2026-05-17 19:28:23');
INSERT INTO `users` (`id`, `nama`, `email`, `peran`, `aktif`, `email_verified_at`, `password`, `two_factor_secret`, `two_factor_recovery_codes`, `two_factor_confirmed_at`, `remember_token`, `created_at`, `updated_at`) VALUES (2, 'Siti Kasir', 'kasir@toko.com', 'kasir', 1, NULL, '$2y$12$8Bz7HxqQ950Aw3y6dY05Xueq6GrvPYTI8F1OwzIkf4CvE/l2H7BTi', NULL, NULL, NULL, NULL, '2026-05-17 19:28:23', '2026-05-17 19:28:23');
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;
