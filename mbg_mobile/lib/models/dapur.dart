// lib/models/dapur.dart
class Dapur {
  final int idDapur;
  final String namaDapur;
  final double latitude;
  final double longitude;

  const Dapur({
    required this.idDapur,
    required this.namaDapur,
    required this.latitude,
    required this.longitude,
  });

  factory Dapur.fromJson(Map<String, dynamic> json) {
    return Dapur(
      idDapur: json['id_dapur'] as int,
      namaDapur: json['nama_dapur'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id_dapur': idDapur,
        'nama_dapur': namaDapur,
        'latitude': latitude,
        'longitude': longitude,
      };

  @override
  String toString() => namaDapur;
}
