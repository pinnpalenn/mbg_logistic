# setup_demo_data.py
import mysql.connector

DB_CONFIG = {
    "host": "127.0.0.1",
    "database": "db_distribusi_mbg",
    "user": "root",
    "password": "",
}

def setup_demo_data():
    try:
        conn = mysql.connector.connect(**DB_CONFIG)
        cursor = conn.cursor()
        
        print("Memastikan skema tabel MySQL...")
        cursor.execute("DESCRIBE sekolah")
        cols = [r[0] for r in cursor.fetchall()]
        if 'id_dapur' not in cols:
            cursor.execute("ALTER TABLE sekolah ADD COLUMN id_dapur INT NOT NULL AFTER id_sekolah")

        print("Membersihkan data lama...")
        cursor.execute("SET FOREIGN_KEY_CHECKS = 0")
        cursor.execute("TRUNCATE TABLE rute_distribusi")
        cursor.execute("TRUNCATE TABLE sekolah")
        cursor.execute("TRUNCATE TABLE dapur")
        cursor.execute("SET FOREIGN_KEY_CHECKS = 1")
        
        print("Memasukkan 3 Dapur sesuai permintaan...")
        dapurs = [
            (1, 'SPPG HULLER MAMA (Utama)', -0.867226, 100.647346),
            (2, 'Dapur Jalan Baru', -0.879842, 100.641885),
            (3, 'Yayasan Mitra Nusa Berbagi', -0.875491, 100.650315),
        ]
        cursor.executemany("INSERT INTO dapur (id_dapur, nama_dapur, latitude, longitude) VALUES (%s, %s, %s, %s)", dapurs)
        
        print("Memasukkan sekolah untuk Dapur 1 & 2...")
        sekolahs = [
            ('SDN 01 Kamal (Mama)', 1, -0.865500, 100.648500, 120),
            ('SDN 02 Kamal (Mama)', 1, -0.869000, 100.645000, 145),
            ('SMPN 1 Baru (Jalan Baru)', 2, -0.881000, 100.640500, 210),
            ('SDN 03 Baru (Jalan Baru)', 2, -0.874000, 100.635000, 95),
        ]
        
        print("Memasukkan 25 Sekolah Mitra di bawah Yayasan Mitra Nusa Berbagi (Dapur 3)...")
        # 1 SMA
        sekolahs.append(('SMA Negeri 1 Nusa Berbagi', 3, -0.872100, 100.651100, 360))
        
        # 12 SD (menyebar di radius dekat dapur 3)
        for i in range(1, 13):
            lat_offset = -0.005 + (i * 0.0008)
            lng_offset = -0.005 + ((i % 3) * 0.0015)
            sekolahs.append((
                f'SD Negeri {i:02d} Nusa Berbagi',
                3,
                -0.875491 + lat_offset,
                100.650315 + lng_offset,
                70 # Porsi default
            ))
            
        # 12 TK (menyebar di radius dekat dapur 3)
        for i in range(1, 13):
            lat_offset = -0.004 - (i * 0.0007)
            lng_offset = 0.002 + ((i % 4) * 0.0012)
            sekolahs.append((
                f'TK Swasta {i:02d} Nusa Berbagi',
                3,
                -0.875491 + lat_offset,
                100.650315 + lng_offset,
                50 # Porsi default
            ))
            
        cursor.executemany("INSERT INTO sekolah (nama_sekolah, id_dapur, latitude, longitude, porsi_mbg) VALUES (%s, %s, %s, %s, %s)", sekolahs)
        
        conn.commit()
        print("SUCCESS: Data presentasi Senin sudah siap dimuat!")
        cursor.close()
        conn.close()
    except Exception as e:
        print(f"ERROR: Gagal menulis ke MySQL: {e}")

if __name__ == "__main__":
    setup_demo_data()
