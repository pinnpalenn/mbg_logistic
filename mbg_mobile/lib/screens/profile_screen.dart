// lib/screens/profile_screen.dart
import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgBase,
      appBar: AppBar(
        title: const Text('Profil Pengemudi'),
        actions: [
          IconButton(icon: const Icon(Icons.settings_outlined), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 24),
            _buildStatsRow(),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: _buildActionBtn('Edit Profil', Icons.edit, false)),
                const SizedBox(width: 12),
                Expanded(child: _buildActionBtn('Unduh KPI', Icons.download, true)),
              ],
            ),
            const SizedBox(height: 28),
            _buildPerformanceChart(),
            const SizedBox(height: 24),
            _buildEfficiencyScore(),
            const SizedBox(height: 24),
            _buildDocumentStatus(),
            const SizedBox(height: 24),
            _buildRecentHistory(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(color: AppTheme.accent, shape: BoxShape.circle),
              child: const CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=budi'),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(12)),
              child: const Text('AKTIF', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text('Budi Santoso', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppTheme.primary)),
        const Text('ID: MBG-99281 • Mitra Logistik', style: TextStyle(color: AppTheme.textMuted, fontSize: 13)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
          child: const Text('SENIOR', style: TextStyle(color: Colors.blue, fontSize: 10, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        _buildMiniStat('4.92 / 5.0', 'Rating Performa', Icons.star, Colors.orange),
        const SizedBox(width: 16),
        _buildMiniStat('1.284', 'Total Pengiriman', Icons.local_shipping, AppTheme.accent),
      ],
    );
  }

  Widget _buildMiniStat(String val, String label, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: AppTheme.cardDecoration,
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 8),
            Text(val, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(label, style: const TextStyle(fontSize: 10, color: AppTheme.textMuted)),
          ],
        ),
      ),
    );
  }

  Widget _buildActionBtn(String label, IconData icon, bool primary) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: 16),
      label: Text(label, style: const TextStyle(fontSize: 12)),
      style: ElevatedButton.styleFrom(
        backgroundColor: primary ? AppTheme.primary : Colors.white,
        foregroundColor: primary ? Colors.white : AppTheme.primary,
        elevation: 0,
        side: BorderSide(color: AppTheme.primary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildPerformanceChart() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Tren Performa Mingguan', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: ['S','S','R','K','J','S','M'].map((day) => Column(
              children: [
                Container(
                  width: 12,
                  height: (day == 'K' || day == 'J') ? 60 : 40,
                  decoration: BoxDecoration(
                    color: (day == 'K' || day == 'J') ? AppTheme.accent : AppTheme.primary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                Text(day, style: const TextStyle(fontSize: 10, color: AppTheme.textMuted)),
              ],
            )).toList(),
          ),
          const Divider(height: 32),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _InfoText('Efisiensi Rute', '94%'),
              _InfoText('Ketepatan Waktu', '+12%'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEfficiencyScore() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          _buildCircularScore(),
          const SizedBox(width: 20),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Skor Bahan Bakar', style: TextStyle(color: Colors.white70, fontSize: 10)),
              Text('85 - Peringkat A', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              Text('Rata-rata 12,4 km/L', style: TextStyle(color: Colors.white54, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCircularScore() {
    return SizedBox(
      height: 60, width: 60,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(value: 0.85, color: AppTheme.accent, backgroundColor: Colors.white24, strokeWidth: 6),
          const Text('85', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildDocumentStatus() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Status Dokumen', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        _buildDocItem('SIM B1 Umum', 'Aktif', '14 Okt 2026', AppTheme.accent),
        _buildDocItem('STNK B 9012 UI', 'Aktif', '22 Des 2024', AppTheme.accent),
        _buildDocItem('KIR Berkala', 'Perlu Update', '14 Hari lagi', Colors.orange),
      ],
    );
  }

  Widget _buildDocItem(String title, String status, String date, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: AppTheme.cardDecoration,
      child: Row(
        children: [
          Container(width: 4, height: 30, color: color),
          const SizedBox(width: 12),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              Text('Kedaluwarsa: $date', style: const TextStyle(fontSize: 11, color: AppTheme.textMuted)),
            ],
          )),
          Text(status, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildRecentHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Riwayat Terakhir', style: TextStyle(fontWeight: FontWeight.bold)),
            TextButton(onPressed: () {}, child: const Text('Lihat Semua', style: TextStyle(fontSize: 12))),
          ],
        ),
        _buildHistoryItem('SDN 01 Menteng', '08:15 AM', '120 Paket'),
        _buildHistoryItem('SMPN 05 Jakarta', '10:30 AM', '250 Paket'),
      ],
    );
  }

  Widget _buildHistoryItem(String dest, String time, String qty) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.cardDecoration,
      child: Row(
        children: [
          const Icon(Icons.history, color: AppTheme.textMuted),
          const SizedBox(width: 16),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(dest, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text('$time • $qty', style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
            ],
          )),
          const Text('Selesai', style: TextStyle(color: AppTheme.accent, fontWeight: FontWeight.bold, fontSize: 12)),
        ],
      ),
    );
  }
}

class _InfoText extends StatelessWidget {
  final String label, value;
  const _InfoText(this.label, this.value);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: AppTheme.textMuted)),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.primary)),
      ],
    );
  }
}
