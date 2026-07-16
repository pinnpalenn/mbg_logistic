// lib/services/api_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/dapur.dart';
import '../models/sekolah.dart';
import '../models/rute.dart';

class ApiService {
  // Ganti IP ini sesuai komputer yang menjalankan backend FastAPI
  // - Untuk emulator Android: http://10.0.2.2:8000
  // - Untuk Chrome/Web: http://127.0.0.1:8000
  static const String baseUrl = kIsWeb ? 'http://localhost:8000' : 'http://10.0.2.2:8000';

  final String? username;
  final String? password;

  ApiService({this.username, this.password});

  Map<String, String> get _headers {
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (username != null && password != null) {
      final credentials = base64Encode(utf8.encode('$username:$password'));
      headers['Authorization'] = 'Basic $credentials';
    }
    return headers;
  }

  Future<dynamic> _get(String path) async {
    try {
      final uri = Uri.parse('$baseUrl$path');
      final response = await http.get(uri, headers: _headers).timeout(
        const Duration(seconds: 15),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      throw Exception('Error ${response.statusCode}: ${response.body}');
    } on SocketException {
      throw Exception('Tidak dapat terhubung ke server. Pastikan backend berjalan.');
    }
  }

  Future<dynamic> _post(String path, Map<String, dynamic> body) async {
    try {
      final uri = Uri.parse('$baseUrl$path');
      final response = await http
          .post(uri, headers: _headers, body: json.encode(body))
          .timeout(const Duration(seconds: 60));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      final err = json.decode(response.body);
      throw Exception(err['detail'] ?? 'Error ${response.statusCode}');
    } on SocketException {
      throw Exception('Tidak dapat terhubung ke server. Pastikan backend berjalan.');
    }
  }

  Future<dynamic> _delete(String path) async {
    final uri = Uri.parse('$baseUrl$path');
    final response =
        await http.delete(uri, headers: _headers).timeout(const Duration(seconds: 15));
    if (response.statusCode == 200) return json.decode(response.body);
    throw Exception('Error ${response.statusCode}');
  }

  // ── Auth ──────────────────────────────────────
  Future<Map<String, dynamic>> login(String user, String pass) async {
    final credentials = base64Encode(utf8.encode('$user:$pass'));
    final uri = Uri.parse('$baseUrl/api/auth/login');
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Basic $credentials',
      },
    ).timeout(const Duration(seconds: 15));
    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    }
    throw Exception('Username atau password salah');
  }

  Future<Map<String, dynamic>> register(String user, String pass) async {
    final uri = Uri.parse('$baseUrl/api/auth/register');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': user, 'password': pass}),
    ).timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    }
    final err = json.decode(response.body);
    throw Exception(err['detail'] ?? 'Gagal mendaftar');
  }

  Future<Map<String, dynamic>> checkHealth() async {
    return (await _get('/api/health')) as Map<String, dynamic>;
  }

  // ── Dashboard ─────────────────────────────────
  Future<DashboardData> getDashboard() async {
    final data = await _get('/api/dashboard');
    return DashboardData.fromJson(data as Map<String, dynamic>);
  }

  // ── Dapur ─────────────────────────────────────
  Future<List<Dapur>> getDapur() async {
    final data = await _get('/api/dapur');
    final list = (data['data'] as List);
    return list.map((e) => Dapur.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> addDapur(String namaDapur, double lat, double lng) async {
    await _post('/api/dapur', {
      'nama_dapur': namaDapur,
      'latitude': lat,
      'longitude': lng,
    });
  }

  Future<void> deleteDapur(int id) async {
    await _delete('/api/dapur/$id');
  }

  // ── Sekolah ───────────────────────────────────
  Future<List<Sekolah>> getSekolah({int? idDapur}) async {
    final qs = idDapur != null ? '?id_dapur=$idDapur' : '';
    final data = await _get('/api/sekolah$qs');
    final list = (data['data'] as List);
    return list.map((e) => Sekolah.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> addSekolah({
    required int idDapur,
    required String namaSekolah,
    required double lat,
    required double lng,
    int porsi = 100,
  }) async {
    await _post('/api/sekolah', {
      'id_dapur': idDapur,
      'nama_sekolah': namaSekolah,
      'latitude': lat,
      'longitude': lng,
      'porsi_mbg': porsi,
    });
  }

  Future<void> deleteSekolah(int id) async {
    await _delete('/api/sekolah/$id');
  }

  // ── Optimasi ──────────────────────────────────
  Future<HasilOptimasi> postOptimasi({
    required int idDapur,
    required List<int> idSekolah,
    bool simpan = true,
  }) async {
    final data = await _post('/api/optimasi', {
      'id_dapur': idDapur,
      'id_sekolah': idSekolah,
      'simpan': simpan,
    });
    return HasilOptimasi.fromJson(data as Map<String, dynamic>);
  }

  // ── Riwayat ───────────────────────────────────
  Future<List<RiwayatRute>> getRiwayat() async {
    final data = await _get('/api/rute');
    final list = (data['data'] as List);
    return list.map((e) => RiwayatRute.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> deleteRiwayat(int id) async {
    await _delete('/api/rute/$id');
  }
}
