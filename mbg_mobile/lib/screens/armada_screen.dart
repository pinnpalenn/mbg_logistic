// lib/screens/armada_screen.dart
import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class ArmadaScreen extends StatelessWidget {
  final Function(int) onSelectArmada;
  const ArmadaScreen({super.key, required this.onSelectArmada});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('MBG Logistik', style: TextStyle(fontWeight: FontWeight.w900, color: AppTheme.primary)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(radius: 18, backgroundImage: const NetworkImage('https://i.pravatar.cc/150?u=admin')),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Manajemen Armada', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppTheme.primary)),
            const Text('Pemantauan waktu nyata dan pelacakan pemeliharaan kendaraan pengiriman.', style: TextStyle(fontSize: 12, color: AppTheme.textMuted)),
            const SizedBox(height: 20),
            _buildActionButtons(),
            const SizedBox(height: 24),
            _buildStatSummary(),
            const SizedBox(height: 24),
            _buildVehicleCard(
              dapurId: 1,
              name: 'MITSUBISHI FUSO A-01',
              sub: 'B 1234 MBG • Truk Box',
              capacity: '800 Porsi',
              nextService: '24 Okt 2024',
              fuel: 0.85,
              status: 'Layak',
              statusColor: Colors.green,
              imageUrl: 'https://images.unsplash.com/photo-1620714223084-8fcacc6dfd8d?q=80&w=2071&auto=format&fit=crop',
            ),
            const SizedBox(height: 16),
            _buildVehicleCard(
              dapurId: 2,
              name: 'TOYOTA HIACE V-02',
              sub: 'B 5678 MBG • Van Pengiriman',
              capacity: '450 Porsi',
              nextService: 'Dalam Proses',
              fuel: 0.4,
              status: 'Pemeliharaan',
              statusColor: Colors.orange,
              imageUrl: 'https://images.unsplash.com/photo-1549317661-bd32c860f2b1?q=80&w=2070&auto=format&fit=crop',
            ),
            const SizedBox(height: 16),
            _buildVehicleCard(
              dapurId: 3,
              name: 'ISUZU ELF A-03',
              sub: 'B 9012 MBG • Truk Box',
              capacity: '600 Porsi',
              nextService: '02 Nov 2024',
              fuel: 0.92,
              status: 'Layak',
              statusColor: Colors.green,
              imageUrl: 'https://images.unsplash.com/photo-1601584115197-04ecc0da31d7?q=80&w=2070&auto=format&fit=crop',
            ),
            const SizedBox(height: 24),
            _buildMaintenanceSchedule(),
            const SizedBox(height: 80),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppTheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.filter_list, size: 18),
            label: const Text('Filter'),
            style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Tambah Kendaraan'),
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary, padding: const EdgeInsets.symmetric(vertical: 12)),
          ),
        ),
      ],
    );
  }

  Widget _buildStatSummary() {
    return Column(
      children: [
        _buildMiniStatCard('TOTAL ARMADA', '24', Icons.local_shipping, const Color(0xFFE0E7FF), '+2 hari ini', Colors.green),
        const SizedBox(height: 12),
        _buildMiniStatCard('AKTIF & LAYAK', '21', Icons.check_circle_outline, const Color(0xFFD1FAE5), null, null),
        const SizedBox(height: 12),
        _buildMiniStatCard('PEMELIHARAAN', '3', Icons.build_circle_outlined, const Color(0xFFFEF3C7), null, null),
        const SizedBox(height: 12),
        _buildMiniStatCard('TOTAL KAPASITAS', '12.5rb', Icons.restaurant_menu, const Color(0xFFF3E8FF), 'Porsi harian', AppTheme.textMuted),
      ],
    );
  }

  Widget _buildMiniStatCard(String label, String val, IconData icon, Color bg, String? trend, Color? trendColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey[200]!)),
      child: Row(
        children: [
          Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: AppTheme.primary, size: 20)),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.textMuted)),
              Text(val, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppTheme.primary)),
            ],
          ),
          const Spacer(),
          if (trend != null) Text(trend, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: trendColor)),
        ],
      ),
    );
  }

  Widget _buildVehicleCard({required int dapurId, required String name, required String sub, required String capacity, required String nextService, required double fuel, required String status, required Color statusColor, required String imageUrl}) {
    final isMaintenance = status == 'Pemeliharaan';

    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.grey[200]!)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Image.network(imageUrl, height: 160, width: double.infinity, fit: BoxFit.cover),
              Positioned(
                top: 12, right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: statusColor.withOpacity(0.9), borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    children: [
                      const CircleAvatar(radius: 3, backgroundColor: Colors.white),
                      const SizedBox(width: 6),
                      Text(status, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppTheme.primary)),
                    const Icon(Icons.more_vert, size: 18, color: AppTheme.textMuted),
                  ],
                ),
                Text(sub, style: const TextStyle(fontSize: 11, color: AppTheme.textMuted)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.inventory_2_outlined, size: 14, color: AppTheme.primary),
                    const SizedBox(width: 8),
                    const Text('Kapasitas', style: TextStyle(fontSize: 11)),
                    const Spacer(),
                    Text(capacity, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 14, color: AppTheme.primary),
                    const SizedBox(width: 8),
                    const Text('Servis Berikutnya', style: TextStyle(fontSize: 11)),
                    const Spacer(),
                    Text(nextService, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: nextService == 'Dalam Proses' ? Colors.red : null)),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(isMaintenance ? 'Kemajuan Pemeliharaan' : 'Status Bahan Bakar', style: const TextStyle(fontSize: 10, color: AppTheme.textMuted)),
                    Text('${(fuel * 100).toInt()}%', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(value: fuel, backgroundColor: Colors.grey[100], color: isMaintenance ? Colors.orange : AppTheme.primary, minHeight: 4),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(child: TextButton(onPressed: () {}, child: const Text('Detail', style: TextStyle(fontSize: 12)))),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: isMaintenance ? null : () => onSelectArmada(dapurId),
                        style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary, padding: const EdgeInsets.symmetric(vertical: 8)),
                        child: Text(isMaintenance ? 'Tidak Tersedia' : 'Tentukan Rute', style: const TextStyle(fontSize: 12)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMaintenanceSchedule() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.grey[200]!)),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 18, color: AppTheme.primary),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Jadwal', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    Text('Pemeliharaan Mendatang', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              TextButton.icon(onPressed: () {}, icon: const Text('Lihat Kalender', style: TextStyle(fontSize: 10)), label: const Icon(Icons.arrow_forward, size: 14)),
            ],
          ),
          const SizedBox(height: 20),
          _buildTableHeader(),
          _buildTableRow('B 1234 MBG', 'Truk Box', '24 Mei 2024'),
          _buildTableRow('B 5678 MBG', 'Van Pengiriman', '10 Apr 2024'),
          _buildTableRow('B 9012 MBG', 'Truk Box', '02 Jun 2024'),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: const BoxDecoration(color: Color(0xFFEFF6FF), borderRadius: BorderRadius.vertical(top: Radius.circular(12))),
      child: const Row(
        children: [
          Expanded(child: Text('KENDARAAN', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppTheme.primary))),
          Expanded(child: Text('TIPE', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppTheme.primary))),
          Expanded(child: Text('SERVIS TERAKHIR', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppTheme.primary))),
        ],
      ),
    );
  }

  Widget _buildTableRow(String v, String t, String s) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey[100]!))),
      child: Row(
        children: [
          Expanded(child: Text(v, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.primary))),
          Expanded(child: Text(t, style: const TextStyle(fontSize: 10, color: AppTheme.textMuted))),
          Expanded(child: Text(s, style: const TextStyle(fontSize: 11, color: AppTheme.textMuted))),
        ],
      ),
    );
  }
}
