// lib/models/rute.dart
class RuteUrutan {
  final int nomor;
  final String tipe;
  final int id;
  final String nama;
  final double latitude;
  final double longitude;
  final dynamic porsiMbg;

  const RuteUrutan({
    required this.nomor,
    required this.tipe,
    required this.id,
    required this.nama,
    required this.latitude,
    required this.longitude,
    required this.porsiMbg,
  });

  factory RuteUrutan.fromJson(Map<String, dynamic> json) {
    return RuteUrutan(
      nomor: json['nomor'] as int,
      tipe: json['tipe'] as String,
      id: json['id'] as int,
      nama: json['nama'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      porsiMbg: json['porsi_mbg'],
    );
  }

  bool get isDapur => tipe == 'dapur';
}

class HasilOptimasi {
  final int idDapur;
  final String tanggalDistribusi;
  final String metode;
  final String source;
  final double totalJarakKm;
  final int estimasiWaktuMenit;
  final dynamic totalPorsi;
  final List<RuteUrutan> urutan;
  final bool? tersimpanDiMysql;

  const HasilOptimasi({
    required this.idDapur,
    required this.tanggalDistribusi,
    required this.metode,
    required this.source,
    required this.totalJarakKm,
    required this.estimasiWaktuMenit,
    required this.totalPorsi,
    required this.urutan,
    this.tersimpanDiMysql,
  });

  factory HasilOptimasi.fromJson(Map<String, dynamic> json) {
    return HasilOptimasi(
      idDapur: json['id_dapur'] as int,
      tanggalDistribusi: json['tanggal_distribusi'] as String,
      metode: json['metode'] as String,
      source: json['source'] as String,
      totalJarakKm: (json['total_jarak_km'] as num).toDouble(),
      estimasiWaktuMenit: json['estimasi_waktu_menit'] as int,
      totalPorsi: json['total_porsi'],
      urutan: (json['urutan'] as List)
          .map((e) => RuteUrutan.fromJson(e as Map<String, dynamic>))
          .toList(),
      tersimpanDiMysql: json['tersimpan_di_mysql'] as bool?,
    );
  }
}

class RiwayatRute {
  final int? idRute;
  final int idDapur;
  final String? namaDapur;
  final String tanggalDistribusi;
  final double totalJarakKm;
  final String? detailUrutan;

  const RiwayatRute({
    this.idRute,
    required this.idDapur,
    this.namaDapur,
    required this.tanggalDistribusi,
    required this.totalJarakKm,
    this.detailUrutan,
  });

  factory RiwayatRute.fromJson(Map<String, dynamic> json) {
    return RiwayatRute(
      idRute: json['id_rute'] as int?,
      idDapur: json['id_dapur'] as int,
      namaDapur: json['nama_dapur'] as String?,
      tanggalDistribusi: (json['tanggal_distribusi'] ?? '').toString(),
      totalJarakKm: (json['total_jarak_km'] as num?)?.toDouble() ?? 0.0,
      detailUrutan: json['detail_urutan'] as String?,
    );
  }
}

class DashboardData {
  final int totalDapur;
  final int totalSekolah;
  final dynamic totalPorsiHarian;
  final int totalDistribusiTercatat;
  final double akumulasiJarakKm;
  final List<dynamic> riwayatTerbaru;

  const DashboardData({
    required this.totalDapur,
    required this.totalSekolah,
    required this.totalPorsiHarian,
    required this.totalDistribusiTercatat,
    required this.akumulasiJarakKm,
    required this.riwayatTerbaru,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      totalDapur: json['total_dapur'] as int? ?? 0,
      totalSekolah: json['total_sekolah'] as int? ?? 0,
      totalPorsiHarian: json['total_porsi_harian'],
      totalDistribusiTercatat: json['total_distribusi_tercatat'] as int? ?? 0,
      akumulasiJarakKm: (json['akumulasi_jarak_km'] as num?)?.toDouble() ?? 0.0,
      riwayatTerbaru: json['riwayat_terbaru'] as List? ?? [],
    );
  }
}
