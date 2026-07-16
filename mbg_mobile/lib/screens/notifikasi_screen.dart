import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class NotifikasiScreen extends StatelessWidget {
  const NotifikasiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
        title: const Text('MBG Logistik'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Notifikasi &\nPeringatan', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppTheme.primary, height: 1.2)),
            const SizedBox(height: 8),
            const Text(
              'Status real-time dan peringatan sistem.',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 20),
            
            Row(
              children: [
                _buildBadge(Icons.info_outline, '12 Info Baru', const Color(0xFF1E3A8A), const Color(0xFFDBEAFE)),
                const SizedBox(width: 12),
                _buildBadge(Icons.error_outline, '2 Mendesak', const Color(0xFFDC2626), const Color(0xFFFEE2E2)),
              ],
            ),
            
            const SizedBox(height: 24),
            
            _buildAlertCard(
              icon: Icons.warning_amber_rounded,
              iconColor: const Color(0xFFDC2626),
              bgColor: const Color(0xFFFEE2E2),
              title: 'Kendaraan MBG-TX-088 butuh servis segera',
              description: 'Sensor mesin menunjukkan performa rendah. Segera jadwalkan di bengkel rekanan terdekat.',
              actionText: 'Cari Bengkel',
            ),
            
            const SizedBox(height: 16),
            
            _buildAlertCard(
              icon: Icons.schedule,
              iconColor: const Color(0xFFD97706),
              bgColor: const Color(0xFFFEF3C7),
              title: 'Rute #A-102 mengalami keterlambatan',
              description: 'Kepadatan lalu lintas di Jl. Jend. Sudirman. Estimasi waktu tiba mundur 20 menit.',
              actionText: 'Lihat Jalur Alternatif',
              actionIcon: Icons.map,
            ),
            
            const SizedBox(height: 16),
            
            _buildAlertCard(
              icon: Icons.check_circle,
              iconColor: const Color(0xFF059669),
              bgColor: const Color(0xFFD1FAE5),
              title: 'Sekolah SMPN 2 telah menerima paket',
              description: 'Konfirmasi penerimaan 350 box makanan telah ditandatangani Kepala Sekolah. Status: Selesai.',
              showImage: true,
            ),
            
            const SizedBox(height: 16),
            
            _buildAlertCard(
              icon: Icons.local_shipping,
              iconColor: const Color(0xFF2563EB),
              bgColor: const Color(0xFFDBEAFE),
              title: 'Driver Budi Santoso memulai perjalanan',
              description: 'Kendaraan MBG-TX-001 meninggalkan Gudang Pusat menuju rute pertama.',
              isPlain: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(IconData icon, String text, Color color, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 6),
          Text(text, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildAlertCard({
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String title,
    required String description,
    String? actionText,
    IconData? actionIcon,
    bool showImage = false,
    bool isPlain = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.primary)),
                const SizedBox(height: 4),
                Text(description, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary, height: 1.4)),
                
                if (actionText != null) ...[
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: Icon(actionIcon ?? Icons.build, size: 14),
                    label: Text(actionText, style: const TextStyle(fontSize: 11)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                      minimumSize: const Size(0, 36),
                    ),
                  ),
                ],
                
                if (showImage) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        width: 32, height: 32,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: const DecorationImage(image: NetworkImage('https://images.unsplash.com/photo-1560250097-0b93528c311a?q=80&w=200&auto=format&fit=crop'), fit: BoxFit.cover),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text('Bukti Penerimaan', style: TextStyle(fontSize: 10, color: AppTheme.textMuted, fontStyle: FontStyle.italic)),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
