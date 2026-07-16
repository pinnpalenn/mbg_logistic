# BAB IV
# IMPLEMENTASI DAN PENGUJIAN

## 4.1 Implementasi
Tahap implementasi merupakan tahap penerapan hasil analisis dan perancangan sistem ke dalam bentuk aplikasi web yang dapat digunakan oleh pengguna. Setelah sistem diimplementasikan, dilakukan pengujian untuk memastikan bahwa seluruh fungsi berjalan sesuai dengan kebutuhan yang telah ditentukan.

Pada penelitian ini implementasi dilakukan dengan mengintegrasikan antarmuka aplikasi web responsif menggunakan HTML, CSS, dan JavaScript, backend menggunakan framework FastAPI, algoritma pencarian rute terpendek Dijkstra, serta optimasi urutan rute menggunakan algoritma Travelling Salesperson Problem (TSP). Seluruh komponen tersebut saling berkomunikasi melalui REST API sehingga mampu menghasilkan sistem yang dapat menentukan rute distribusi Makan Bergizi Gratis (MBG) secara otomatis dan optimal.

Implementasi sistem dilakukan secara bertahap mulai dari implementasi algoritma optimasi, pembangunan backend, perancangan basis data, hingga implementasi antarmuka pengguna berbasis web. Setelah seluruh komponen selesai dikembangkan, dilakukan proses integrasi sehingga sistem dapat berjalan sebagai satu kesatuan aplikasi.

### 4.1.1 Implementasi Algoritma Optimasi Rute
Implementasi algoritma optimasi rute merupakan bagian utama dalam penelitian ini karena berfungsi untuk menentukan jalur distribusi makanan yang paling efisien dari Dapur Pusat menuju beberapa titik sekolah penerima. Sistem ini dibangun dengan menggabungkan dua algoritma, yaitu Algoritma Dijkstra dan algoritma Travelling Salesperson Problem (TSP).

**a) Implementasi Algoritma Dijkstra**
Tahap pertama dalam optimasi adalah mengimplementasikan algoritma Dijkstra. Algoritma ini berfungsi untuk mencari jarak terpendek (shortest path) antara dua titik koordinat yang merepresentasikan Dapur Pusat dan lokasi-lokasi Sekolah. Jaringan jalan raya dipetakan sebagai sebuah graf, di mana persimpangan jalan bertindak sebagai *node* dan ruas jalan bertindak sebagai *edge* yang memiliki bobot berupa jarak tempuh.

*Gambar 4.1 Visualisasi Node dan Graph Jalan*
Gambar 4.1 menunjukkan bagaimana sistem memetakan area operasional distribusi ke dalam bentuk graf. Algoritma Dijkstra memproses graf tersebut untuk menghasilkan Matriks Jarak (Distance Matrix) yang berisi jarak terpendek dari setiap titik asal ke setiap titik tujuan.

**b) Implementasi Algoritma TSP**
Setelah Matriks Jarak diperoleh dari algoritma Dijkstra, tahap selanjutnya adalah mengimplementasikan algoritma TSP. Masalah distribusi MBG mengharuskan armada pengiriman berangkat dari Dapur Pusat, mendistribusikan makanan ke beberapa sekolah yang telah ditentukan, lalu kembali lagi ke Dapur Pusat.
Algoritma TSP diterapkan pada backend untuk memproses Matriks Jarak dan menentukan urutan kunjungan ke setiap sekolah yang menghasilkan total jarak tempuh paling minimal. Hasil dari proses ini adalah daftar urutan titik pengiriman (waypoints) yang kemudian divisualisasikan pada peta aplikasi.

### 4.1.2 Implementasi Backend
Backend merupakan komponen utama yang berfungsi sebagai pusat pengolahan data pada sistem distribusi MBG. Pada penelitian ini backend dikembangkan menggunakan framework FastAPI dengan menerapkan konsep RESTful API sebagai media komunikasi antara antarmuka web, algoritma optimasi rute, dan basis data MySQL. Seluruh permintaan dari antarmuka web diproses oleh backend sebelum diteruskan ke algoritma matematis.

Implementasi backend tidak hanya bertugas mengelola data sekolah dan armada, tetapi juga menangani perhitungan rute yang rumit, serta mengelola penyimpanan riwayat pengiriman pada basis data.

**a) Implementasi FastAPI**
Framework FastAPI dipilih karena memiliki performa pemrosesan yang sangat tinggi dan dukungan arsitektur asinkron (asynchronous) yang mempermudah kalkulasi graf algoritma. Pada implementasinya, backend dibagi menjadi beberapa modul utama, yaitu modul pengolahan rute (*route optimization service*), pengolahan data master (sekolah dan armada), serta koneksi basis data. 

*Gambar 4.2 Struktur Proyek Backend FastAPI*
Gambar 4.2 menunjukkan struktur direktori proyek backend FastAPI. Direktori utama berisi folder *Controllers* yang mengatur alur respons HTTP, *Models* sebagai representasi tabel basis data, dan *Services* yang mengatur logika bisnis algoritma rute. Pemisahan arsitektur ini memudahkan pemeliharaan sistem karena setiap komponen memiliki tanggung jawab yang terisolasi.

**b) Implementasi REST API**
REST API merupakan media komunikasi utama antara aplikasi antarmuka web dengan backend FastAPI. Seluruh data yang dikirim maupun diterima menggunakan format JavaScript Object Notation (JSON) sehingga proses pertukaran data menjadi lebih ringan dan mudah diproses oleh aplikasi pemetaan (*Leaflet*).

*Gambar 4.3 Implementasi Endpoint REST API*
Gambar 4.3 menunjukkan implementasi endpoint REST API pada backend FastAPI. Setiap endpoint memiliki fungsi yang berbeda sesuai dengan kebutuhan sistem, seperti pengambilan data sekolah per dapur, atau pemrosesan algoritma rute. Tabel 4.1 menyajikan beberapa endpoint utama pada sistem.

Tabel 4.1 Endpoint Utama Sistem
| No. | Method | Endpoint API | Fungsi | Akses Keamanan |
|---|---|---|---|---|
| 1 | POST | `/api/login` | Memvalidasi kredensial pengguna (admin/dispatcher) dan mengembalikan token. | Publik |
| 2 | GET | `/api/dashboard` | Mengambil data statistik harian (total sekolah, armada aktif). | Terproteksi |
| 3 | GET | `/api/schools` | Mengambil seluruh daftar sekolah yang dikelompokkan per dapur. | Terproteksi |
| 4 | GET | `/api/fleets` | Mengambil status kesiapan dan kelayakan armada (Mobil Box). | Terproteksi |
| 5 | POST | `/api/optimize-route` | Menerima data dapur & sekolah tujuan, menjalankan algoritma Dijkstra & TSP, lalu mengembalikan urutan optimal. | Terproteksi |
| 6 | POST | `/api/dispatch` | Mengubah status armada menjadi "Berangkat" dan memicu pencatatan log riwayat distribusi. | Terproteksi |

**c) Implementasi Basis Data MySQL**
Basis data MySQL digunakan sebagai media penyimpanan seluruh data yang dibutuhkan oleh sistem. Struktur basis data dirancang agar mampu mendukung proses operasional logistik berskala luas.

*Gambar 4.4 Struktur Basis Data MySQL*
Gambar 4.4 menunjukkan struktur basis data yang digunakan pada sistem, yang meliputi tabel *users*, *dapur*, *sekolah*, *armada*, dan *rute_distribusi*. Setiap tabel saling berhubungan melalui relasi tertentu (Foreign Key) sehingga mampu mendukung proses penyimpanan dan pengambilan data secara efisien.

### 4.1.6 Implementasi Antarmuka
Antarmuka aplikasi (user interface) merupakan bagian yang berinteraksi secara langsung dengan pengguna. Pada penelitian ini antarmuka aplikasi dikembangkan dengan desain *Light Mode* yang modern dan bersih. Implementasi antarmuka ini dirancang agar mudah digunakan oleh administrator logistik. Berikut adalah penjabaran dari setiap antarmuka:

**a) Halaman Login**
Halaman Login merupakan gerbang keamanan sistem yang digunakan sebagai proses autentikasi administrator sebelum mengakses fitur utama aplikasi.
*(Tempatkan Gambar Halaman Login di bawah ini)*
**Gambar 4.5 Tampilan Halaman Login**
Gambar 4.5 menunjukkan tampilan antarmuka Login. Pengguna diwajibkan memasukkan kredensial berupa email dan kata sandi yang valid untuk dapat masuk ke dalam sistem.

**b) Halaman Dashboard**
Halaman Dashboard adalah pusat ringkasan statistik yang memuat data visual operasional distribusi logistik secara menyeluruh.
*(Tempatkan Gambar Halaman Dashboard di bawah ini)*
**Gambar 4.6 Tampilan Halaman Dashboard**
Gambar 4.6 menunjukkan visualisasi grafik tren performa mingguan, skor efisiensi operasional, dan statistik kapasitas porsi pengiriman secara ringkas dan menarik.

**c) Halaman Data Dapur**
Halaman Data Dapur berisikan manajemen informasi mengenai Dapur Pusat yang menyuplai paket makan bergizi ke masing-masing target wilayah.
*(Tempatkan Gambar Halaman Data Dapur di bawah ini)*
**Gambar 4.7 Tampilan Halaman Data Dapur**
Gambar 4.7 memperlihatkan detail dari dapur penyuplai (seperti SPPG Huller Mama dan Yayasan Mitra Nusa), lengkap dengan kapasitas masaknya.

**d) Halaman Data Sekolah**
Halaman Data Sekolah menampilkan daftar sekolah yang menjadi penerima manfaat dari program Makan Bergizi Gratis (MBG).
*(Tempatkan Gambar Halaman Data Sekolah di bawah ini)*
**Gambar 4.8 Tampilan Halaman Data Sekolah**
Gambar 4.8 menampilkan pengelompokan (accordion) daftar nama sekolah tujuan distribusi lengkap dengan informasi kuota porsi harian dan status pengiriman.

**e) Halaman Optimasi Rute**
Halaman Optimasi Rute merupakan fitur inti di mana algoritma Dijkstra dan TSP berjalan secara visual di atas peta interaktif.
*(Tempatkan Gambar Halaman Optimasi Rute di bawah ini)*
**Gambar 4.9 Tampilan Halaman Optimasi Rute**
Gambar 4.9 menunjukkan *polyline* atau garis rute terpendek yang digambar pada peta Leaflet yang menghubungkan Dapur Pusat ke beberapa titik Sekolah target.

**f) Halaman Riwayat Distribusi**
Halaman Riwayat Distribusi digunakan untuk melacak riwayat pengiriman dan notifikasi keberangkatan secara waktu nyata (*real-time*).
*(Tempatkan Gambar Halaman Riwayat Distribusi di bawah ini)*
**Gambar 4.10 Tampilan Halaman Riwayat Distribusi**
Gambar 4.10 menunjukkan daftar *log* perjalanan driver lengkap dengan waktu keberangkatan dan status apakah pengiriman sudah selesai atau masih menunggu.

**g) Fitur Logout**
Fitur Logout disediakan bagi administrator untuk mengakhiri sesi dan keluar dari sistem aplikasi dengan aman.
*(Tempatkan Gambar Fitur Logout di bawah ini)*
**Gambar 4.11 Tampilan Fitur Logout**
Gambar 4.11 menunjukkan menu navigasi atau tombol Logout. Setelah ditekan, sistem akan menghapus sesi (session) dan mengembalikan pengguna ke layar Halaman Login.

## 4.2 Pengujian
Pengujian dilakukan dengan metode *Black Box testing* untuk memastikan bahwa seluruh fungsi pada sistem dapat berjalan dengan baik. Pengujian ini berfokus pada fungsionalitas sistem dengan cara mengamati *output* berdasarkan *input* yang dimasukkan tanpa melihat struktur kode di baliknya.

**Tabel 4.2 Skenario dan Hasil Pengujian**
| No | Fitur yang Diuji | Skenario Pengujian | Hasil yang Diharapkan | Hasil Pengujian | Status |
|----|---|---|---|---|---|
| 1 | Login Administrator | Administrator memasukkan email dan password yang valid | Sistem berhasil melakukan autentikasi dan memindahkan sesi ke halaman utama (Dashboard) | Halaman berpindah ke Dashboard dengan sukses | Berhasil |
| 2 | Menampilkan Dashboard | Membuka tab statistik | Sistem merender grafik sirkular progres, jumlah armada, dan sekolah secara akurat | Ringkasan operasional berhasil ditampilkan dengan UI responsif | Berhasil |
| 3 | Pengelompokan Data Sekolah | Menekan tab Sekolah dan membuka menu accordion Dapur | Sistem mengekspansi daftar sekolah sesuai dengan Dapur Pusat yang menaunginya | Data daftar nama sekolah dan kuota porsi muncul dengan benar | Berhasil |
| 4 | Manajemen Armada | Menekan tab Armada | Sistem menampilkan gambar L300 Box dan memuat indikator bar pemeliharaan kendaraan | Profil truk dan kapasitas angkut termuat utuh | Berhasil |
| 5 | Proses Optimasi Rute | Memilih "Dapur" dari menu Rute | Sistem membuat request, menarik koordinat titik, dan menggambar lintasan rute terpendek di peta Leaflet | Peta bergeser halus (flyTo) dan menampilkan *polyline* urutan distribusi | Berhasil |
| 6 | Simulasi Pengiriman | Menekan tombol "Mulai Rute Sekarang" di dasar list urutan pengiriman | Sistem menampilkan Toast "Berangkat!" dan mengaktifkan kedipan lonceng notifikasi | Notifikasi Toast berhasil muncul dan meluncur mulus | Berhasil |
| 7 | Cek Riwayat Notifikasi | Berpindah ke menu Notifikasi setelah simulasi pengiriman dijalankan | Terdapat satu baris notifikasi (log) baru yang berisi status keberangkatan Driver dan Dapur | Pesan otomatis sukses diinjeksi ke daftar riwayat | Berhasil |

Berdasarkan hasil pengujian *Black Box* pada Tabel 4.2, seluruh fitur utama pada aplikasi Optimasi Rute Distribusi MBG berhasil berjalan sesuai dengan kebutuhan fungsional yang telah dirancang. Proses visualisasi antarmuka pemetaan menggunakan Leaflet sukses menangani data urutan pengiriman (waypoints) yang dihasilkan oleh algoritma Dijkstra dan TSP. Transisi antar halaman berjalan tanpa jeda karena menggunakan pendekatan *Single Page Application*, serta fungsi interaktif injeksi notifikasi keberangkatan otomatis dapat berjalan valid dan bebas hambatan.

<br><br><br>

# BAB V
# PENUTUP

## 5.1 Kesimpulan
Berdasarkan hasil analisis, perancangan, implementasi, dan pengujian aplikasi Optimasi Rute Logistik Distribusi Makan Bergizi Gratis (MBG) menggunakan metode algoritma Dijkstra dan Travelling Salesperson Problem (TSP), maka dapat diambil beberapa kesimpulan sebagai berikut:
1. Algoritma Dijkstra dan Travelling Salesperson Problem (TSP) telah berhasil diimplementasikan secara terpadu. Kombinasi ini memiliki performa yang tangguh dalam mengkalkulasi jarak terpendek jalan raya sekaligus mengurutkan titik pengiriman makanan dari Dapur Pusat ke beberapa titik Sekolah secara otomatis.
2. Antarmuka aplikasi berbasis web modern (*Light Theme*) berhasil dikembangkan dan memberikan UX (User Experience) yang luar biasa bagi administrator. Halaman Dashboard, Sekolah, dan Armada L300 Box tampil terstruktur, sedangkan visualisasi pemetaan rute dengan Leaflet.js mempermudah pengambilan keputusan secara spasial.
3. Seluruh fitur utama sistem, baik simulasi rute pada peta, peralihan tab (*Single Page Application*), hingga pencatatan log riwayat (Notifikasi/Peringatan) secara seketika (*real-time*), telah berjalan 100% valid berdasarkan skenario pengujian *Black Box* yang dilakukan.

## 5.2 Saran
Adapun saran yang dapat diberikan untuk pengembangan sistem pada penelitian selanjutnya adalah sebagai berikut:
1. **Penerapan Teknologi IoT (Internet of Things)**: Sangat disarankan untuk mengintegrasikan sistem pusat web ini dengan perangkat keras *GPS Tracker* pada mesin L300 Box. Hal ini agar titik kendaraan di atas peta Leaflet dapat dilacak keberadaannya bergerak secara *real-time* di jalan raya.
2. **Pembuatan Aplikasi Mobile Pendamping (Driver App)**: Mengembangkan antarmuka khusus pengemudi berbasis Android (menggunakan Flutter/Kotlin). Aplikasi pendamping ini memungkinkan pengemudi membaca urutan rute langsung dari ponsel mereka dan menekan konfirmasi *Proof of Delivery* (Bukti Pengiriman) setiap kali porsi makanan berhasil diturunkan di sekolah tujuan.
