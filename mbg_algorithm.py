import mysql.connector
import networkx as nx
import osmnx as ox
from itertools import permutations
import warnings

warnings.filterwarnings("ignore")

def get_db_connection():
    try:
        connection = mysql.connector.connect(
            host='127.0.0.1',
            database='db_distribusi_mbg',
            user='root',
            password=''
        )
        return connection
    except Exception as e:
        print(f"Error koneksi database: {e}")
        return None

def download_graph_for_nodes(nodes):
    lats = [n['lat'] for n in nodes]
    lngs = [n['lng'] for n in nodes]
    
    margin = 0.015
    north, south = max(lats) + margin, min(lats) - margin
    east, west = max(lngs) + margin, min(lngs) - margin
    
    print(f"Mengunduh graf jalan untuk area ini...")
    try:
        G = ox.graph_from_bbox(bbox=(north, south, east, west), network_type='drive')
    except TypeError:
        G = ox.graph_from_bbox(north, south, east, west, network_type='drive')
        
    return G

def calculate_dijkstra_matrix(G, nodes):
    print("Mencari titik node jalan terdekat & menghitung Matriks Jarak (Dijkstra)...")
    for n in nodes:
        node_idx = ox.distance.nearest_nodes(G, X=n['lng'], Y=n['lat'])
        n['osmid'] = node_idx
    
    matrix = {}
    for i, origin in enumerate(nodes):
        matrix[origin['id']] = {}
        for j, dest in enumerate(nodes):
            if origin['id'] == dest['id']:
                matrix[origin['id']][dest['id']] = 0.0
            else:
                try:
                    length = nx.shortest_path_length(G, origin['osmid'], dest['osmid'], weight='length')
                    matrix[origin['id']][dest['id']] = length / 1000.0 # KM
                except nx.NetworkXNoPath:
                    matrix[origin['id']][dest['id']] = float('inf')
    return matrix

def run_tsp(titik_awal, daftar_sekolah, distance_matrix):
    print("Mengeksekusi TSP untuk mencari urutan rute...")
    semua_titik = [titik_awal] + daftar_sekolah
    id_awal = titik_awal['id']
    id_sekolah = [s['id'] for s in daftar_sekolah]
    
    jarak_minimum = float('inf')
    rute_terbaik = None
    
    for urutan in permutations(id_sekolah):
        rute_sementara = [id_awal] + list(urutan) + [id_awal]
        total_jarak = 0
        valid = True
        
        for i in range(len(rute_sementara) - 1):
            dari = rute_sementara[i]
            tujuan = rute_sementara[i+1]
            jarak = distance_matrix[dari][tujuan]
            
            if jarak == float('inf'):
                valid = False
                break
            total_jarak += jarak
            
        if valid and total_jarak < jarak_minimum:
            jarak_minimum = total_jarak
            rute_terbaik = rute_sementara
            
    if not rute_terbaik:
        return [], 0
        
    id_to_node = {n['id']: n for n in semua_titik}
    rute_objek = [id_to_node[id_node] for id_node in rute_terbaik]
    return rute_objek, round(jarak_minimum, 2)

if __name__ == "__main__":
    print("\n=============================================")
    print("SISTEM PENJADWALAN & RUTE DISTRIBUSI MBG")
    print("Kasus: Multi-Dapur (3 Dapur di Kampung)")
    print("=============================================\n")
    
    conn = get_db_connection()
    if conn:
        cursor = conn.cursor(dictionary=True)
        
        # 1. Ambil semua dapur yang ada
        cursor.execute("SELECT id_dapur as id, nama_dapur as nama, latitude as lat, longitude as lng FROM dapur")
        daftar_dapur = cursor.fetchall()
        
        if not daftar_dapur:
            print("[ERROR] Data dapur kosong. Harap isi database terlebih dahulu.")
        else:
            print(f"Ditemukan {len(daftar_dapur)} Dapur MBG di database.\n")
            
            # Loop untuk setiap Dapur
            for dapur in daftar_dapur:
                dapur['lat'] = float(dapur['lat'])
                dapur['lng'] = float(dapur['lng'])
                dapur_id_asli = dapur['id']
                dapur['id'] = 'D_' + str(dapur_id_asli)
                
                print(f"=============================================")
                print(f"MEMPROSES RUTE UNTUK: {dapur['nama']}")
                print(f"=============================================")
                
                # 2. Ambil sekolah KHUSUS untuk dapur ini saja
                query_sekolah = "SELECT id_sekolah as id, nama_sekolah as nama, latitude as lat, longitude as lng FROM sekolah WHERE id_dapur = %s"
                cursor.execute(query_sekolah, (dapur_id_asli,))
                sekolah_tujuan = cursor.fetchall()
                
                if not sekolah_tujuan:
                    print(f"--> Tidak ada sekolah yang dialokasikan untuk {dapur['nama']}.\n")
                    continue
                    
                print(f"Ditemukan {len(sekolah_tujuan)} sekolah tujuan.")
                
                for s in sekolah_tujuan:
                    s['lat'] = float(s['lat'])
                    s['lng'] = float(s['lng'])
                    s['id'] = 'S_' + str(s['id'])
                
                semua_titik = [dapur] + sekolah_tujuan
                
                try:
                    # Mulai algoritma
                    G = download_graph_for_nodes(semua_titik)
                    matriks_jarak = calculate_dijkstra_matrix(G, semua_titik)
                    rute_optimal, total_jarak = run_tsp(dapur, sekolah_tujuan, matriks_jarak)
                    
                    print(f"\n>> HASIL AKHIR [{dapur['nama']}]:")
                    print(f">> Total Jarak: {total_jarak} KM")
                    
                    urutan = 0
                    for titik in rute_optimal:
                        if urutan == 0:
                            print(f"   [BERANGKAT] {titik['nama']}")
                        elif urutan == len(rute_optimal) - 1:
                            print(f"   [KEMBALI]   {titik['nama']}")
                        else:
                            print(f"   [{urutan}] {titik['nama']}")
                        urutan += 1
                    print("\n")
                    
                except Exception as e:
                    print(f"\n[ERROR] Gagal memproses {dapur['nama']}: {e}\n")
        
        cursor.close()
        conn.close()
    else:
        print("\n[ERROR] Tidak dapat terhubung ke MySQL.")
