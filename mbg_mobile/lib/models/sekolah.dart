// lib/models/sekolah.dart
class Sekolah {
  final int idSekolah;
  final int idDapur;
  final String namaSekolah;
  final double latitude;
  final double longitude;
  final dynamic porsiMbg;

  const Sekolah({
    required this.idSekolah,
    required this.idDapur,
    required this.namaSekolah,
    required this.latitude,
    required this.longitude,
    required this.porsiMbg,
  });

  factory Sekolah.fromJson(Map<String, dynamic> json) {
    return Sekolah(
      idSekolah: json['id_sekolah'] as int,
      idDapur: json['id_dapur'] as int,
      namaSekolah: json['nama_sekolah'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      porsiMbg: json['porsi_mbg'],
    );
  }

  @override
  String toString() => namaSekolah;
}
