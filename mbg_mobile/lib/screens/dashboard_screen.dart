import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import 'notifikasi_screen.dart';

class DashboardScreen extends StatefulWidget {
  final Function(int) onTabChange;
  const DashboardScreen({super.key, required this.onTabChange});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
        title: const Text('MBG Logistik'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: AppTheme.bgBase,
              backgroundImage: const NetworkImage('https://i.pravatar.cc/150?u=admin'),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Manajemen Armada', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppTheme.primary)),
            const SizedBox(height: 8),
            const Text(
              'Pemantauan waktu nyata dan pelacakan pemeliharaan kendaraan pengiriman.',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.filter_list, size: 18),
                    label: const Text('Filter'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.primary,
                      side: const BorderSide(color: AppTheme.primary),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Tambah Kendaraan'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // STATS GRID
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.local_shipping_outlined,
                    value: '24',
                    label: 'TOTAL ARMADA',
                    badgeText: '+2 hari ini',
                    badgeColor: const Color(0xFFD1FAE5),
                    badgeTextColor: const Color(0xFF059669),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.check_circle_outline,
                    value: '21',
                    label: 'AKTIF & LAYAK',
                    iconColor: const Color(0xFF059669),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.build_outlined,
                    value: '3',
                    label: 'PEMELIHARAAN',
                    iconColor: const Color(0xFFDC2626),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.restaurant_menu,
                    value: '12.5rb',
                    label: 'TOTAL KAPASITAS',
                    subText: 'Porsi harian',
                    iconColor: const Color(0xFFD97706),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // TRUCK LIST
            _buildTruckCard(
              name: 'MITSUBISHI FUSO A-01',
              plate: 'B 1234 MBG • Truk Box',
              capacity: '800 Porsi',
              nextService: '24 Okt 2024',
              fuel: 85,
              imageUrl: 'https://images.unsplash.com/photo-1601584115197-04ecc0da31d7?q=80&w=2070&auto=format&fit=crop',
              isLayak: true,
            ),
            
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    Color iconColor = AppTheme.primary,
    String? badgeText,
    Color? badgeColor,
    Color? badgeTextColor,
    String? subText,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: iconColor, size: 24),
              if (badgeText != null)
                Text(
                  badgeText,
                  style: TextStyle(color: badgeTextColor, fontSize: 10, fontWeight: FontWeight.bold),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(label, style: const TextStyle(fontSize: 10, color: AppTheme.textMuted, fontWeight: FontWeight.bold)),
          Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: AppTheme.primary)),
          if (subText != null)
            Text(subText, style: const TextStyle(fontSize: 10, color: AppTheme.textMuted)),
        ],
      ),
    );
  }

  Widget _buildTruckCard({
    required String name,
    required String plate,
    required String capacity,
    required String nextService,
    required double fuel,
    required String imageUrl,
    required bool isLayak,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Stack(
            children: [
              Image.network(imageUrl, height: 160, width: double.infinity, fit: BoxFit.cover),
              if (isLayak)
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: const Color(0xFF059669), borderRadius: BorderRadius.circular(20)),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(radius: 3, backgroundColor: Colors.white),
                        SizedBox(width: 4),
                        Text('Layak', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
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
                    Text(name, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: AppTheme.primary)),
                    const Icon(Icons.more_vert, color: AppTheme.textMuted),
                  ],
                ),
                Text(plate, style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.kitchen, size: 16, color: AppTheme.primary),
                        SizedBox(width: 8),
                        Text('Kapasitas', style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                      ],
                    ),
                    Text(capacity, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.calendar_month, size: 16, color: AppTheme.primary),
                        SizedBox(width: 8),
                        Text('Servis Berikutnya', style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                      ],
                    ),
                    Text(nextService, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Status Bahan Bakar', style: TextStyle(fontSize: 10, color: AppTheme.textMuted)),
                    Text('${fuel.toInt()}%', style: const TextStyle(fontSize: 10, color: AppTheme.textMuted)),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: fuel / 100,
                  backgroundColor: Colors.grey[200],
                  color: AppTheme.primary,
                  minHeight: 6,
                  borderRadius: BorderRadius.circular(3),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Detail', style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 12)),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                      ),
                      child: const Text('Tentukan Rute', style: TextStyle(fontSize: 12)),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
