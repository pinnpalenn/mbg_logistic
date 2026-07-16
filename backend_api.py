"""
Backend API - Sistem Rute Distribusi MBG
FastAPI + MySQL (fallback ke data sample jika MySQL tidak tersedia)
Endpoint: /api/dapur, /api/sekolah, /api/optimasi, /api/rute, /api/dashboard, /api/auth
"""

from datetime import date, datetime, timedelta
from itertools import permutations
from math import asin, cos, radians, sin, sqrt
from typing import Any

import mysql.connector
from fastapi import Depends, FastAPI, HTTPException, status
from fastapi.middleware.cors import CORSMiddleware
from fastapi.security import HTTPBasic, HTTPBasicCredentials
import uvicorn
from pydantic import BaseModel, Field

# ─────────────────────────────────────────
#  CONFIG
# ─────────────────────────────────────────
DB_CONFIG = {
    "host": "127.0.0.1",
    "database": "db_distribusi_mbg",
    "user": "root",
    "password": "",
}

# Akun admin awal (dipakai kalau MySQL tidak tersedia)
ADMIN_ACCOUNTS = {
    "admin": "mbg2025",
}

# ─────────────────────────────────────────
#  SAMPLE DATA (dipakai kalau MySQL tidak terhubung)
# ─────────────────────────────────────────
SAMPLE_DAPUR: list[dict[str, Any]] = [
    {"id_dapur": 1, "nama_dapur": "SPPG HULLER MAMA", "latitude": -0.867226, "longitude": 100.647346},
    {"id_dapur": 2, "nama_dapur": "YAYASAN MITRA NUSA BERBAGI", "latitude": -0.879000, "longitude": 100.650000},
    {"id_dapur": 3, "nama_dapur": "MAN AMAL", "latitude": -0.885000, "longitude": 100.640000},
]

SAMPLE_SEKOLAH: list[dict[str, Any]] = [
    # Dapur 1 - Huller Mama
    {"id_sekolah": 1, "id_dapur": 1, "nama_sekolah": "SMA 1 Guntal", "latitude": -0.865500, "longitude": 100.648500, "porsi_mbg": 350},
    {"id_sekolah": 2, "id_dapur": 1, "nama_sekolah": "SMK Talang", "latitude": -0.869000, "longitude": 100.645000, "porsi_mbg": 300},
    {"id_sekolah": 3, "id_dapur": 1, "nama_sekolah": "SMP 2 Guntal", "latitude": -0.864000, "longitude": 100.650000, "porsi_mbg": 250},
    {"id_sekolah": 4, "id_dapur": 1, "nama_sekolah": "SD 08", "latitude": -0.863000, "longitude": 100.646000, "porsi_mbg": 120},
    
    # Dapur 2 - Jalan Baru
    {"id_sekolah": 5, "id_dapur": 2, "nama_sekolah": "SD 04", "latitude": -0.881000, "longitude": 100.640500, "porsi_mbg": 110},
    {"id_sekolah": 6, "id_dapur": 2, "nama_sekolah": "SD 29", "latitude": -0.882000, "longitude": 100.639000, "porsi_mbg": 95},
    {"id_sekolah": 7, "id_dapur": 2, "nama_sekolah": "SD 17", "latitude": -0.879000, "longitude": 100.642500, "porsi_mbg": 105},
    {"id_sekolah": 8, "id_dapur": 2, "nama_sekolah": "SD 05", "latitude": -0.878500, "longitude": 100.643000, "porsi_mbg": 120},
    {"id_sekolah": 9, "id_dapur": 2, "nama_sekolah": "SD 36", "latitude": -0.883000, "longitude": 100.641000, "porsi_mbg": 85},
    {"id_sekolah": 10, "id_dapur": 2, "nama_sekolah": "SD 12", "latitude": -0.880500, "longitude": 100.638500, "porsi_mbg": 90},
    {"id_sekolah": 11, "id_dapur": 2, "nama_sekolah": "SD 39", "latitude": -0.877000, "longitude": 100.644000, "porsi_mbg": 130},
    {"id_sekolah": 12, "id_dapur": 2, "nama_sekolah": "SMA 3 Talang", "latitude": -0.884000, "longitude": 100.645000, "porsi_mbg": 310},
    {"id_sekolah": 13, "id_dapur": 2, "nama_sekolah": "SMA Plus", "latitude": -0.885000, "longitude": 100.646000, "porsi_mbg": 250},
    {"id_sekolah": 14, "id_dapur": 2, "nama_sekolah": "TKN Talang", "latitude": -0.879500, "longitude": 100.641500, "porsi_mbg": 60},
    {"id_sekolah": 15, "id_dapur": 2, "nama_sekolah": "TK Almunawarah", "latitude": -0.878000, "longitude": 100.640000, "porsi_mbg": 55},
    {"id_sekolah": 16, "id_dapur": 2, "nama_sekolah": "SD 39 Talang", "latitude": -0.876000, "longitude": 100.643500, "porsi_mbg": 140},
    {"id_sekolah": 17, "id_dapur": 2, "nama_sekolah": "TK Solo Budi", "latitude": -0.881500, "longitude": 100.642000, "porsi_mbg": 45},
    {"id_sekolah": 18, "id_dapur": 2, "nama_sekolah": "TK Bina Islam", "latitude": -0.882500, "longitude": 100.643000, "porsi_mbg": 50},
    {"id_sekolah": 19, "id_dapur": 2, "nama_sekolah": "PAUD Harapan Bundo", "latitude": -0.880000, "longitude": 100.639500, "porsi_mbg": 40},
    {"id_sekolah": 20, "id_dapur": 2, "nama_sekolah": "TK Aisyah", "latitude": -0.879000, "longitude": 100.638000, "porsi_mbg": 65},

    # Dapur 3 - Pasar Baru
    {"id_sekolah": 21, "id_dapur": 3, "nama_sekolah": "SD 33", "latitude": -0.873000, "longitude": 100.651000, "porsi_mbg": 115},
    {"id_sekolah": 22, "id_dapur": 3, "nama_sekolah": "SD 21", "latitude": -0.874000, "longitude": 100.652000, "porsi_mbg": 125},
    {"id_sekolah": 23, "id_dapur": 3, "nama_sekolah": "SD 03", "latitude": -0.875000, "longitude": 100.653000, "porsi_mbg": 90},
    {"id_sekolah": 24, "id_dapur": 3, "nama_sekolah": "SD 28", "latitude": -0.876000, "longitude": 100.650000, "porsi_mbg": 105},
    {"id_sekolah": 25, "id_dapur": 3, "nama_sekolah": "SD 34", "latitude": -0.877000, "longitude": 100.649000, "porsi_mbg": 135},
    {"id_sekolah": 26, "id_dapur": 3, "nama_sekolah": "SD 27", "latitude": -0.872500, "longitude": 100.648500, "porsi_mbg": 110},
]

ROUTE_HISTORY: list[dict[str, Any]] = []


# ─────────────────────────────────────────
#  REQUEST / RESPONSE MODELS
# ─────────────────────────────────────────
class OptimasiRequest(BaseModel):
    id_dapur: int = Field(..., examples=[1])
    id_sekolah: list[int] | None = Field(default=None, examples=[[1, 2]])
    simpan: bool = True


class DapurRequest(BaseModel):
    nama_dapur: str = Field(..., examples=["Dapur MBG Baru"])
    latitude: float = Field(..., examples=[-1.605])
    longitude: float = Field(..., examples=[101.481])


class SekolahRequest(BaseModel):
    id_dapur: int = Field(..., examples=[1])
    nama_sekolah: str = Field(..., examples=["SDN Baru"])
    latitude: float = Field(..., examples=[-1.602])
    longitude: float = Field(..., examples=[101.477])
    porsi_mbg: int = Field(default=100, examples=[100])


class RegisterRequest(BaseModel):
    username: str = Field(..., examples=["admin2"])
    password: str = Field(..., examples=["password123"])


# ─────────────────────────────────────────
#  APP
# ─────────────────────────────────────────
app = FastAPI(
    title="API Sistem Rute Distribusi MBG",
    description="Backend API untuk Sistem Penjadwalan & Rute Distribusi Makanan Bergizi Gratis (MBG). Digunakan oleh Frontend Web & Mobile Flutter.",
    version="2.0.0",
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

security = HTTPBasic()


# ─────────────────────────────────────────
#  DATABASE HELPERS
# ─────────────────────────────────────────
def get_connection():
    return mysql.connector.connect(**DB_CONFIG)


def rows_from_db(query: str, params: tuple[Any, ...] = ()) -> list[dict[str, Any]]:
    connection = get_connection()
    try:
        cursor = connection.cursor(dictionary=True)
        cursor.execute(query, params)
        rows = cursor.fetchall()
        cursor.close()
        return [normalize_row(row) for row in rows]
    finally:
        connection.close()


def execute_db(query: str, params: tuple[Any, ...] = ()) -> int:
    """Execute INSERT/UPDATE/DELETE, return lastrowid."""
    connection = get_connection()
    try:
        cursor = connection.cursor()
        cursor.execute(query, params)
        connection.commit()
        last_id = cursor.lastrowid
        cursor.close()
        return last_id
    finally:
        connection.close()


def normalize_row(row: dict[str, Any]) -> dict[str, Any]:
    normalized = {}
    for key, value in row.items():
        if hasattr(value, "as_tuple"):
            normalized[key] = float(value)
        elif isinstance(value, (date, datetime)):
            normalized[key] = value.isoformat()
        else:
            normalized[key] = value
    return normalized


def adjust_sekolah_porsi(rows: list[dict[str, Any]]) -> list[dict[str, Any]]:
    # Get current weekday: 0 = Mon, 1 = Tue, 2 = Wed, 3 = Thu, 4 = Fri, 5 = Sat, 6 = Sun
    current_day = datetime.now().weekday()
    adjusted = []
    
    for r in rows:
        new_row = dict(r)
        if r.get("id_dapur") == 3:
            name = r.get("nama_sekolah", "")
            if current_day in [0, 1, 2, 4, 6]:  # Senin-Rabu, Jumat, Minggu (1800 Porsi)
                if "SMA" in name:
                    new_row["porsi_mbg"] = 360
                elif "SD" in name:
                    new_row["porsi_mbg"] = 70
                elif "TK" in name:
                    new_row["porsi_mbg"] = 50
                else:
                    new_row["porsi_mbg"] = 50
            elif current_day == 3:  # Kamis (2026 Porsi)
                if "SMA" in name:
                    new_row["porsi_mbg"] = 346
                elif "SD" in name:
                    new_row["porsi_mbg"] = 85
                elif "TK" in name:
                    new_row["porsi_mbg"] = 55
                else:
                    new_row["porsi_mbg"] = 50
            elif current_day == 5:  # Sabtu (Paket Kering)
                new_row["porsi_mbg"] = "Paket Kering"
        adjusted.append(new_row)
    return adjusted


def load_dapur() -> tuple[list[dict[str, Any]], str]:
    try:
        rows = rows_from_db("SELECT id_dapur, nama_dapur, latitude, longitude FROM dapur ORDER BY id_dapur")
        return rows, "mysql"
    except Exception:
        return SAMPLE_DAPUR, "sample"


def load_sekolah(id_dapur: int | None = None) -> tuple[list[dict[str, Any]], str]:
    try:
        if id_dapur is None:
            rows = rows_from_db("SELECT id_sekolah, id_dapur, nama_sekolah, latitude, longitude, porsi_mbg FROM sekolah ORDER BY id_sekolah")
        else:
            rows = rows_from_db(
                "SELECT id_sekolah, id_dapur, nama_sekolah, latitude, longitude, porsi_mbg FROM sekolah WHERE id_dapur = %s ORDER BY id_sekolah",
                (id_dapur,),
            )
        return adjust_sekolah_porsi(rows), "mysql"
    except Exception:
        data = SAMPLE_SEKOLAH
        if id_dapur is not None:
            data = [row for row in SAMPLE_SEKOLAH if row["id_dapur"] == id_dapur]
        return adjust_sekolah_porsi(data), "sample"


@app.get("/api/dashboard", tags=["Dashboard"])
def get_dashboard():
    """Mengambil statistik untuk dashboard utama."""
    try:
        total_dapur = rows_from_db("SELECT COUNT(*) as count FROM dapur")[0]["count"]
        total_sekolah = rows_from_db("SELECT COUNT(*) as count FROM sekolah")[0]["count"]
        total_jarak = rows_from_db("SELECT COALESCE(SUM(total_jarak_km), 0) as count FROM rute_distribusi")[0]["count"]
        total_porsi = rows_from_db("SELECT COALESCE(SUM(porsi_mbg), 0) as count FROM sekolah")[0]["count"]
        
        return {
            "total_dapur": total_dapur,
            "total_sekolah": total_sekolah,
            "akumulasi_jarak_km": float(total_jarak),
            "total_porsi": int(total_porsi),
            "source": "mysql"
        }
    except Exception:
        return {
            "total_dapur": len(SAMPLE_DAPUR),
            "total_sekolah": len(SAMPLE_SEKOLAH),
            "akumulasi_jarak_km": 0.0,
            "total_porsi": sum(s["porsi_mbg"] for s in SAMPLE_SEKOLAH),
            "source": "memory"
        }


# ─────────────────────────────────────────
#  ALGORITMA
# ─────────────────────────────────────────
def haversine_km(a: dict[str, Any], b: dict[str, Any]) -> float:
    radius_km = 6371.0
    lat1, lon1 = radians(float(a["latitude"])), radians(float(a["longitude"]))
    lat2, lon2 = radians(float(b["latitude"])), radians(float(b["longitude"]))
    dlat, dlon = lat2 - lat1, lon2 - lon1
    val = sin(dlat / 2) ** 2 + cos(lat1) * cos(lat2) * sin(dlon / 2) ** 2
    return 2 * radius_km * asin(sqrt(val))


def exact_tsp(dapur: dict[str, Any], sekolah: list[dict[str, Any]]) -> tuple[list[dict[str, Any]], float]:
    if not sekolah:
        return [dapur], 0.0
    best_route: list[dict[str, Any]] | None = None
    best_distance = float("inf")
    for order in permutations(sekolah):
        route = [dapur, *order, dapur]
        distance = sum(haversine_km(route[i], route[i + 1]) for i in range(len(route) - 1))
        if distance < best_distance:
            best_route = list(route)
            best_distance = distance
    return best_route or [dapur], round(best_distance, 2)


# ─────────────────────────────────────────
#  DB SAVE
# ─────────────────────────────────────────
def save_route_to_db(id_dapur: int, total_jarak_km: float, detail_urutan: str) -> bool:
    try:
        execute_db(
            "INSERT INTO rute_distribusi (id_dapur, tanggal_distribusi, total_jarak_km, detail_urutan) VALUES (%s, %s, %s, %s)",
            (id_dapur, date.today(), total_jarak_km, detail_urutan),
        )
        return True
    except Exception:
        return False


# ─────────────────────────────────────────
#  AUTH
# ─────────────────────────────────────────
def verify_admin(credentials: HTTPBasicCredentials = Depends(security)):
    username = credentials.username
    password = credentials.password

    # Cek di Database dulu
    try:
        users = rows_from_db("SELECT username, password FROM users WHERE username = %s AND password = %s", (username, password))
        if users:
            return username
    except Exception:
        pass

    # Fallback ke dictionary in-memory
    if ADMIN_ACCOUNTS.get(username) == password:
        return username

    raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Username atau password salah", headers={"WWW-Authenticate": "Basic"})


# ─────────────────────────────────────────
#  ENDPOINTS
# ─────────────────────────────────────────
@app.get("/", tags=["Info"])
def root():
    return {
        "message": "API Sistem Rute Distribusi MBG v2.0 aktif",
        "docs": "/docs",
        "endpoints": ["/api/health", "/api/dashboard", "/api/dapur", "/api/sekolah", "/api/optimasi", "/api/rute"],
    }


@app.get("/api/health", tags=["Info"])
def health():
    try:
        conn = get_connection()
        conn.close()
        db_status = "connected"
    except Exception:
        db_status = "sample-fallback"
    return {"status": "ok", "database": db_status, "timestamp": datetime.now().isoformat()}


# ── DASHBOARD ─────────────────────────────
@app.get("/api/dashboard", tags=["Dashboard"])
def get_dashboard():
    """Ringkasan statistik untuk halaman dashboard."""
    dapur_data, source_d = load_dapur()
    sekolah_data, source_s = load_sekolah()
    rute_data: list[dict[str, Any]] = []
    try:
        rute_data = rows_from_db("SELECT * FROM rute_distribusi ORDER BY id_rute DESC LIMIT 10")
        source_r = "mysql"
    except Exception:
        rute_data = ROUTE_HISTORY[-10:]
        source_r = "memory"

    current_day = datetime.now().weekday()
    if current_day == 5:
        total_porsi = "Paket Kering"
    else:
        total_porsi = 0
        for s in sekolah_data:
            p = s.get("porsi_mbg", 0)
            try:
                total_porsi += int(p)
            except ValueError:
                pass
    total_jarak = round(sum(float(r.get("total_jarak_km", 0)) for r in rute_data), 2)

    return {
        "source": source_d,
        "total_dapur": len(dapur_data),
        "total_sekolah": len(sekolah_data),
        "total_porsi_harian": total_porsi,
        "total_distribusi_tercatat": len(rute_data),
        "akumulasi_jarak_km": total_jarak,
        "riwayat_terbaru": rute_data[:5],
    }


# ── DAPUR ─────────────────────────────────
@app.get("/api/dapur", tags=["Dapur"])
def get_dapur():
    data, source = load_dapur()
    return {"source": source, "count": len(data), "data": data}


@app.post("/api/dapur", tags=["Dapur"])
def add_dapur(payload: DapurRequest):
    try:
        new_id = execute_db(
            "INSERT INTO dapur (nama_dapur, latitude, longitude) VALUES (%s, %s, %s)",
            (payload.nama_dapur, payload.latitude, payload.longitude),
        )
        return {"message": "Dapur berhasil ditambahkan", "id_dapur": new_id}
    except Exception as e:
        # Fallback: simpan ke sample data
        new_id = max(d["id_dapur"] for d in SAMPLE_DAPUR) + 1
        SAMPLE_DAPUR.append({"id_dapur": new_id, "nama_dapur": payload.nama_dapur, "latitude": payload.latitude, "longitude": payload.longitude})
        return {"message": "Dapur ditambahkan ke data sementara (MySQL tidak tersedia)", "id_dapur": new_id}


@app.delete("/api/dapur/{id_dapur}", tags=["Dapur"])
def delete_dapur(id_dapur: int):
    try:
        execute_db("DELETE FROM sekolah WHERE id_dapur = %s", (id_dapur,))
        execute_db("DELETE FROM dapur WHERE id_dapur = %s", (id_dapur,))
        return {"message": f"Dapur id={id_dapur} berhasil dihapus"}
    except Exception:
        global SAMPLE_DAPUR
        SAMPLE_DAPUR = [d for d in SAMPLE_DAPUR if d["id_dapur"] != id_dapur]
        return {"message": f"Dapur id={id_dapur} dihapus dari data sementara"}


# ── SEKOLAH ───────────────────────────────
@app.get("/api/sekolah", tags=["Sekolah"])
def get_sekolah(id_dapur: int | None = None):
    data, source = load_sekolah(id_dapur)
    return {"source": source, "count": len(data), "data": data}


@app.post("/api/sekolah", tags=["Sekolah"])
def add_sekolah(payload: SekolahRequest):
    try:
        new_id = execute_db(
            "INSERT INTO sekolah (id_dapur, nama_sekolah, latitude, longitude, porsi_mbg) VALUES (%s, %s, %s, %s, %s)",
            (payload.id_dapur, payload.nama_sekolah, payload.latitude, payload.longitude, payload.porsi_mbg),
        )
        return {"message": "Sekolah berhasil ditambahkan", "id_sekolah": new_id}
    except Exception:
        new_id = max(s["id_sekolah"] for s in SAMPLE_SEKOLAH) + 1
        SAMPLE_SEKOLAH.append({"id_sekolah": new_id, "id_dapur": payload.id_dapur, "nama_sekolah": payload.nama_sekolah, "latitude": payload.latitude, "longitude": payload.longitude, "porsi_mbg": payload.porsi_mbg})
        return {"message": "Sekolah ditambahkan ke data sementara (MySQL tidak tersedia)", "id_sekolah": new_id}


@app.delete("/api/sekolah/{id_sekolah}", tags=["Sekolah"])
def delete_sekolah(id_sekolah: int):
    try:
        execute_db("DELETE FROM sekolah WHERE id_sekolah = %s", (id_sekolah,))
        return {"message": f"Sekolah id={id_sekolah} berhasil dihapus"}
    except Exception:
        global SAMPLE_SEKOLAH
        SAMPLE_SEKOLAH = [s for s in SAMPLE_SEKOLAH if s["id_sekolah"] != id_sekolah]
        return {"message": f"Sekolah id={id_sekolah} dihapus dari data sementara"}


# ── OPTIMASI ──────────────────────────────
@app.post("/api/optimasi", tags=["Optimasi"])
def post_optimasi(payload: OptimasiRequest):
    dapur_data, source_dapur = load_dapur()
    sekolah_data, source_sekolah = load_sekolah(payload.id_dapur)

    dapur = next((item for item in dapur_data if item["id_dapur"] == payload.id_dapur), None)
    if dapur is None:
        raise HTTPException(status_code=404, detail="Dapur tidak ditemukan")

    if payload.id_sekolah:
        sekolah_data = [item for item in sekolah_data if item["id_sekolah"] in payload.id_sekolah]

    if not sekolah_data:
        raise HTTPException(status_code=400, detail="Sekolah tujuan kosong")

    route, total_distance = exact_tsp(dapur, sekolah_data)
    current_day = datetime.now().weekday()
    if current_day == 5:
        total_meals = "Paket Kering"
    else:
        total_meals = 0
        for item in sekolah_data:
            val = item.get("porsi_mbg", 0)
            try:
                total_meals += int(val)
            except ValueError:
                pass
    estimated_minutes = max(10, round(total_distance * 4.5))

    result: dict[str, Any] = {
        "id_dapur": payload.id_dapur,
        "nama_dapur": dapur["nama_dapur"],
        "tanggal_distribusi": date.today().isoformat(),
        "metode": "TSP exact + haversine distance",
        "source": "mysql" if source_dapur == "mysql" and source_sekolah == "mysql" else "sample",
        "total_jarak_km": total_distance,
        "estimasi_waktu_menit": estimated_minutes,
        "total_porsi": total_meals,
        "urutan": [
            {
                "nomor": idx,
                "tipe": "dapur" if idx == 0 or idx == len(route) - 1 else "sekolah",
                "id": item.get("id_dapur") or item.get("id_sekolah"),
                "nama": item.get("nama_dapur") or item.get("nama_sekolah"),
                "latitude": item["latitude"],
                "longitude": item["longitude"],
                "porsi_mbg": item.get("porsi_mbg", 0),
            }
            for idx, item in enumerate(route)
        ],
    }

    if payload.simpan:
        detail = " -> ".join(item["nama"] for item in result["urutan"])
        result["tersimpan_di_mysql"] = save_route_to_db(payload.id_dapur, total_distance, detail)
        # Tambahkan ID buatan untuk memori agar tidak error di mobile
        result["id_rute"] = len(ROUTE_HISTORY) + 1
        ROUTE_HISTORY.append(result)

    return result


# ── RUTE HISTORY ──────────────────────────
@app.get("/api/rute", tags=["Riwayat"])
def get_rute():
    try:
        rows = rows_from_db(
            """
            SELECT r.id_rute, r.id_dapur, d.nama_dapur, r.tanggal_distribusi,
                   r.total_jarak_km, r.detail_urutan
            FROM rute_distribusi r
            JOIN dapur d ON d.id_dapur = r.id_dapur
            ORDER BY r.id_rute DESC
            """
        )
        return {"source": "mysql", "count": len(rows), "data": rows}
    except Exception:
        return {"source": "memory", "count": len(ROUTE_HISTORY), "data": ROUTE_HISTORY}


@app.get("/api/rute/{id_rute}", tags=["Riwayat"])
def get_rute_detail(id_rute: int):
    try:
        rows = rows_from_db(
            """
            SELECT r.id_rute, r.id_dapur, d.nama_dapur, r.tanggal_distribusi,
                   r.total_jarak_km, r.detail_urutan
            FROM rute_distribusi r
            JOIN dapur d ON d.id_dapur = r.id_dapur
            WHERE r.id_rute = %s
            """,
            (id_rute,),
        )
        if not rows:
            raise HTTPException(status_code=404, detail="Rute tidak ditemukan")
        return rows[0]
    except HTTPException:
        raise
    except Exception:
        match = next((r for r in ROUTE_HISTORY if r.get("id_rute") == id_rute), None)
        if not match:
            raise HTTPException(status_code=404, detail="Rute tidak ditemukan")
        return match


@app.delete("/api/rute/{id_rute}", tags=["Riwayat"])
def delete_rute(id_rute: int):
    try:
        execute_db("DELETE FROM rute_distribusi WHERE id_rute = %s", (id_rute,))
        return {"message": f"Rute id={id_rute} berhasil dihapus"}
    except Exception:
        global ROUTE_HISTORY
        ROUTE_HISTORY = [r for r in ROUTE_HISTORY if r.get("id_rute") != id_rute]
        return {"message": f"Rute id={id_rute} dihapus dari data sementara"}


# ── AUTH ──────────────────────────────────
@app.post("/api/auth/login", tags=["Auth"])
def login(credentials: HTTPBasicCredentials = Depends(security)):
    username = credentials.username
    password = credentials.password

    # 1. Cek di Database
    try:
        users = rows_from_db("SELECT username, password FROM users WHERE username = %s AND password = %s", (username, password))
        if users:
            return {
                "message": "Login berhasil",
                "username": username,
                "role": "admin",
            }
    except Exception:
        pass

    # 2. Cek di Memory (Fallback/Registrasi Baru)
    if ADMIN_ACCOUNTS.get(username) == password:
        return {
            "message": "Login berhasil",
            "username": username,
            "role": "admin",
        }

    raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Username atau password salah")


@app.post("/api/auth/register", tags=["Auth"])
def register(payload: RegisterRequest):
    username = payload.username
    password = payload.password

    if not username or not password:
        raise HTTPException(status_code=400, detail="Username and password required")

    try:
        # Cek apakah username sudah ada
        existing = rows_from_db("SELECT id_user FROM users WHERE username = %s", (username,))
        if existing:
            raise HTTPException(status_code=400, detail="Username sudah terdaftar")

        # Simpan ke DB
        execute_db("INSERT INTO users (username, password) VALUES (%s, %s)", (username, password))
        return {"message": "Registrasi berhasil", "username": username}
    except HTTPException:
        raise
    except Exception as e:
        # Fallback in-memory
        if username in ADMIN_ACCOUNTS:
             raise HTTPException(status_code=400, detail="Username sudah terdaftar")
        ADMIN_ACCOUNTS[username] = password
        return {"message": "Registrasi berhasil (Simulasi Memory)", "username": username}

if __name__ == "__main__":
    uvicorn.run("backend_api:app", host="127.0.0.1", port=8000, reload=True)
