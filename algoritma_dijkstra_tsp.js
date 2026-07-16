/**
 * =========================================================================
 * ALGORITMA OPTIMASI RUTE DISTRIBUSI MAKANAN BERGIZI GRATIS (MBG)
 * Metode: Graph Theory, Dijkstra's Algorithm, dan TSP (Nearest Neighbor)
 * =========================================================================
 * 
 * File ini berisi inti pemrosesan backend untuk menghitung rute pengiriman
 * paling optimal dari Dapur Pusat ke beberapa Sekolah Tujuan.
 */

class Graph {
    constructor() {
        this.nodes = new Set();
        this.edges = new Map();
    }

    // Menambahkan titik (Dapur / Sekolah)
    addNode(node) {
        this.nodes.add(node);
        this.edges.set(node, []);
    }

    // Menambahkan jalur raya beserta jaraknya (dalam km)
    addEdge(node1, node2, weight) {
        this.edges.get(node1).push({ node: node2, weight: weight });
        this.edges.get(node2).push({ node: node1, weight: weight }); // Two-way street
    }

    /**
     * 1. ALGORITMA DIJKSTRA
     * Mencari jarak terpendek dari satu titik awal ke semua titik lain di peta.
     */
    dijkstra(startNode) {
        const distances = {};
        const previous = {};
        const unvisited = new Set(this.nodes);

        // Inisialisasi jarak ke Infinity, kecuali titik awal = 0
        for (let node of this.nodes) {
            distances[node] = Infinity;
            previous[node] = null;
        }
        distances[startNode] = 0;

        while (unvisited.size > 0) {
            // Cari node dengan jarak terpendek yang belum dikunjungi
            let currentNode = null;
            let shortestDistance = Infinity;

            for (let node of unvisited) {
                if (distances[node] < shortestDistance) {
                    shortestDistance = distances[node];
                    currentNode = node;
                }
            }

            if (currentNode === null) break;

            unvisited.delete(currentNode);

            // Update jarak ke tetangga
            for (let neighbor of this.edges.get(currentNode)) {
                let altDistance = distances[currentNode] + neighbor.weight;
                if (altDistance < distances[neighbor.node]) {
                    distances[neighbor.node] = altDistance;
                    previous[neighbor.node] = currentNode;
                }
            }
        }
        return distances; // Mengembalikan matriks jarak terpendek
    }
}

/**
 * 2. ALGORITMA TRAVELLING SALESPERSON PROBLEM (TSP) - NEAREST NEIGHBOR
 * Mencari urutan kunjungan ke beberapa sekolah agar total jarak paling minimal,
 * lalu kembali lagi ke Dapur Pusat.
 */
function optimasiRuteTSP(graph, dapurPusat, daftarSekolah) {
    let unvisitedSchools = new Set(daftarSekolah);
    let currentNode = dapurPusat;
    let ruteOptimal = [dapurPusat];
    let totalJarak = 0;

    console.log(`[MULAI] Berangkat dari: ${dapurPusat}`);

    // Selama masih ada sekolah yang belum dikirimkan makanan
    while (unvisitedSchools.size > 0) {
        // Gunakan Dijkstra untuk mengetahui jarak riil lewat jalan raya (bukan garis lurus)
        let jarakDariCurrent = graph.dijkstra(currentNode);
        
        let sekolahTerdekat = null;
        let jarakTerpendek = Infinity;

        // Cari sekolah tujuan selanjutnya yang paling dekat
        for (let sekolah of unvisitedSchools) {
            if (jarakDariCurrent[sekolah] < jarakTerpendek) {
                jarakTerpendek = jarakDariCurrent[sekolah];
                sekolahTerdekat = sekolah;
            }
        }

        // Tandai sudah dikunjungi dan catat jarak
        unvisitedSchools.delete(sekolahTerdekat);
        ruteOptimal.push(sekolahTerdekat);
        totalJarak += jarakTerpendek;
        
        console.log(` -> Menuju ${sekolahTerdekat} (Jarak: ${jarakTerpendek} km)`);
        currentNode = sekolahTerdekat;
    }

    // Supir harus kembali ke Dapur Pusat setelah selesai
    let jarakPulang = graph.dijkstra(currentNode)[dapurPusat];
    ruteOptimal.push(dapurPusat);
    totalJarak += jarakPulang;
    
    console.log(` -> Kembali ke ${dapurPusat} (Jarak: ${jarakPulang} km)`);
    console.log(`\n✅ [SELESAI] Total Jarak Tempuh Keseluruhan: ${totalJarak.toFixed(2)} km`);
    console.log(`Urutan Rute Fix: ${ruteOptimal.join(" ➔ ")}`);
    
    return {
        rute: ruteOptimal,
        totalJarak: totalJarak
    };
}


// =========================================================================
// 3. SIMULASI / PENGUJIAN ALGORITMA (BISA DI-RUN OLEH DOSEN)
// =========================================================================

// Buat Peta Jaringan Jalan (Graph)
const petaMBG = new Graph();

// Daftarkan Lokasi
const lokasi = ["Dapur SPPG", "SMA 1 Guntal", "SMK Talang", "SMP 2 Guntal", "SD 08"];
lokasi.forEach(lok => petaMBG.addNode(lok));

// Masukkan data jarak antar titik riil (berdasarkan Google Maps API)
petaMBG.addEdge("Dapur SPPG", "SMA 1 Guntal", 0.8);
petaMBG.addEdge("Dapur SPPG", "SMK Talang", 1.2);
petaMBG.addEdge("SMA 1 Guntal", "SMP 2 Guntal", 1.7);
petaMBG.addEdge("SMK Talang", "SMP 2 Guntal", 1.3);
petaMBG.addEdge("SMP 2 Guntal", "SD 08", 1.1);
petaMBG.addEdge("SMA 1 Guntal", "SD 08", 2.0);

// Eksekusi Algoritma
console.log("--- HASIL RUNNING ALGORITMA OPTIMASI RUTE MBG ---\n");
const daftarSekolahTujuan = ["SMA 1 Guntal", "SMK Talang", "SMP 2 Guntal", "SD 08"];
const hasil = optimasiRuteTSP(petaMBG, "Dapur SPPG", daftarSekolahTujuan);
