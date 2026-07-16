CREATE DATABASE IF NOT EXISTS db_distribusi_mbg;
USE db_distribusi_mbg;

-- Hapus tabel lama jika ada agar tidak bentrok
DROP TABLE IF EXISTS rute_distribusi;
DROP TABLE IF EXISTS sekolah;
DROP TABLE IF EXISTS dapur;
DROP TABLE IF EXISTS users;

-- Tabel Users untuk Login
CREATE TABLE IF NOT EXISTS users (
    id_user INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(20) DEFAULT 'admin'
);

-- Tabel Dapur Pusat (Bisa lebih dari 1 dapur di kampung)
CREATE TABLE IF NOT EXISTS dapur (
    id_dapur INT AUTO_INCREMENT PRIMARY KEY,
    nama_dapur VARCHAR(100) NOT NULL,
    latitude DECIMAL(10, 8) NOT NULL,
    longitude DECIMAL(11, 8) NOT NULL
);

-- Tabel Sekolah Tujuan (Sekarang punya kolom id_dapur untuk pemetaan)
CREATE TABLE IF NOT EXISTS sekolah (
    id_sekolah INT AUTO_INCREMENT PRIMARY KEY,
    id_dapur INT NOT NULL, -- Kolom baru: Sekolah ini dilayani oleh dapur yang mana?
    nama_sekolah VARCHAR(100) NOT NULL,
    latitude DECIMAL(10, 8) NOT NULL,
    longitude DECIMAL(11, 8) NOT NULL,
    porsi_mbg INT DEFAULT 0,
    FOREIGN KEY (id_dapur) REFERENCES dapur(id_dapur)
);

-- Tabel Rute Distribusi
CREATE TABLE IF NOT EXISTS rute_distribusi (
    id_rute INT AUTO_INCREMENT PRIMARY KEY,
    id_dapur INT NOT NULL,
    tanggal_distribusi DATE NOT NULL,
    total_jarak_km DECIMAL(10, 2),
    detail_urutan TEXT,
    FOREIGN KEY (id_dapur) REFERENCES dapur(id_dapur)
);

-- ==========================================
-- DATA SAMPEL (GANTI DENGAN DATA KAMPUNG ANDA)
-- ==========================================

-- 1. Insert 3 Dapur Umum MBG di kampung Anda
INSERT INTO dapur (id_dapur, nama_dapur, latitude, longitude) VALUES 
(1, 'SPPG HULLER MAMA', -0.867226, 100.647346),
(2, 'YAYASAN MITRA NUSA BERBAGI', -0.879000, 100.650000),
(3, 'MAN AMAL', -0.885000, 100.640000);

-- 2. Insert Sekolah berdasarkan target pendistribusiannya
-- Sekolah untuk Dapur 1 (id_dapur = 1)
INSERT INTO sekolah (id_dapur, nama_sekolah, latitude, longitude, porsi_mbg) VALUES
(1, 'SMA 1 Guntal', -0.865500, 100.648500, 350),
(1, 'SMK Talang', -0.869000, 100.645000, 300),
(1, 'SMP 2 Guntal', -0.864000, 100.650000, 250),
(1, 'SD 08', -0.863000, 100.646000, 120);

-- Sekolah untuk Dapur 2 (id_dapur = 2)
INSERT INTO sekolah (id_dapur, nama_sekolah, latitude, longitude, porsi_mbg) VALUES
(2, 'SD 04', -0.881000, 100.640500, 110),
(2, 'SD 29', -0.882000, 100.639000, 95),
(2, 'SD 17', -0.879000, 100.642500, 105),
(2, 'SD 05', -0.878500, 100.643000, 120),
(2, 'SD 36', -0.883000, 100.641000, 85),
(2, 'SD 12', -0.880500, 100.638500, 90),
(2, 'SD 39', -0.877000, 100.644000, 130),
(2, 'SMA 3 Talang', -0.884000, 100.645000, 310),
(2, 'SMA Plus', -0.885000, 100.646000, 250),
(2, 'TKN Talang', -0.879500, 100.641500, 60),
(2, 'TK Almunawarah', -0.878000, 100.640000, 55),
(2, 'SD 39 Talang', -0.876000, 100.643500, 140),
(2, 'TK Solo Budi', -0.881500, 100.642000, 45),
(2, 'TK Bina Islam', -0.882500, 100.643000, 50),
(2, 'PAUD Harapan Bundo', -0.880000, 100.639500, 40),
(2, 'TK Aisyah', -0.879000, 100.638000, 65);

-- Sekolah untuk Dapur 3 (id_dapur = 3)
INSERT INTO sekolah (id_dapur, nama_sekolah, latitude, longitude, porsi_mbg) VALUES
(3, 'SD 33', -0.873000, 100.651000, 115),
(3, 'SD 21', -0.874000, 100.652000, 125),
(3, 'SD 03', -0.875000, 100.653000, 90),
(3, 'SD 28', -0.876000, 100.650000, 105),
(3, 'SD 34', -0.877000, 100.649000, 135),
(3, 'SD 27', -0.872500, 100.648500, 110);

-- 3. Default User
INSERT INTO users (username, password, role) VALUES ('admin', 'mbg2025', 'admin');
