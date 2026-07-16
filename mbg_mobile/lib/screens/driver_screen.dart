import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class DriverScreen extends StatefulWidget {
  const DriverScreen({super.key});

  @override
  State<DriverScreen> createState() => _DriverScreenState();
}

class _DriverScreenState extends State<DriverScreen> {
  // Data driver dikelompokkan berdasarkan Dapur
  final List<Map<String, dynamic>> _dapurDrivers = [
    {
      'dapur': 'SPPG HULLER MAMA',
      'drivers': [
        {'name': 'Budi', 'id': 'MBG-TX-001', 'speed': '42 km/h', 'location': 'SD Negeri 01 Jakarta', 'status': 'Dalam Perjalanan', 'isActive': true},
        {'name': 'Joko', 'id': 'MBG-TX-002', 'speed': '0 km/h', 'location': 'SMP Pelita Harapan', 'status': 'Di Sekolah', 'isActive': false},
        {'name': 'Agus', 'id': 'MBG-TX-003', 'speed': '50 km/h', 'location': 'SMA 1 Guntal', 'status': 'Dalam Perjalanan', 'isActive': true},
      ]
    },
    {
      'dapur': 'YAYASAN MITRA NUSA BERBAGI',
      'drivers': [
        {'name': 'Pak Yanta', 'id': 'MBG-TX-011', 'speed': '35 km/h', 'location': 'SD 04', 'status': 'Dalam Perjalanan', 'isActive': true},
        {'name': 'Pak Febri', 'id': 'MBG-TX-012', 'speed': '0 km/h', 'location': 'SD 29', 'status': 'Di Sekolah', 'isActive': false},
        {'name': 'Anton', 'id': 'MBG-TX-013', 'speed': '40 km/h', 'location': 'TK Almunawarah', 'status': 'Dalam Perjalanan', 'isActive': true},
        {'name': 'Teteen', 'id': 'MBG-TX-014', 'speed': '45 km/h', 'location': 'SD 39 Talang', 'status': 'Dalam Perjalanan', 'isActive': true},
        {'name': 'Julda', 'id': 'MBG-TX-015', 'speed': '0 km/h', 'location': 'PAUD Harapan Bundo', 'status': 'Berhenti', 'isActive': false},
      ]
    },
    {
      'dapur': 'MAN AMAL',
      'drivers': [
        {'name': 'Pak Firman', 'id': 'MBG-TX-021', 'speed': '55 km/h', 'location': 'SD 33', 'status': 'Dalam Perjalanan', 'isActive': true},
        {'name': 'Pak Sam', 'id': 'MBG-TX-022', 'speed': '0 km/h', 'location': 'SD 21', 'status': 'Peringatan', 'isActive': false, 'isWarning': true},
        {'name': 'Pak Beni', 'id': 'MBG-TX-023', 'speed': '30 km/h', 'location': 'SD 03', 'status': 'Dalam Perjalanan', 'isActive': true},
      ]
    },
  ];

  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    // Filter logic
    final filteredDapur = _dapurDrivers.map((dapur) {
      final filteredList = (dapur['drivers'] as List).where((d) => 
        d['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
        dapur['dapur'].toString().toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
      return {'dapur': dapur['dapur'], 'drivers': filteredList};
    }).where((dapur) => (dapur['drivers'] as List).isNotEmpty).toList();

    int totalDrivers = _dapurDrivers.fold(0, (sum, dapur) => sum + (dapur['drivers'] as List).length);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Driver Aktif', style: TextStyle(fontWeight: FontWeight.w900, color: AppTheme.primary)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFD1FAE5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text('$totalDrivers Total', style: const TextStyle(color: Color(0xFF059669), fontWeight: FontWeight.bold, fontSize: 12)),
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (v) => setState(() => _searchQuery = v),
              decoration: InputDecoration(
                hintText: 'Cari kendaraan atau driver...',
                prefixIcon: const Icon(Icons.search, color: AppTheme.textMuted),
                filled: true,
                fillColor: const Color(0xFFF1F5F9),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredDapur.length,
              itemBuilder: (context, index) {
                final dapur = filteredDapur[index];
                final String dapurName = dapur['dapur'];
                final List drivers = dapur['drivers'];

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.grey[200]!),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      initiallyExpanded: index == 0,
                      tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      title: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(color: const Color(0xFF1E40AF), borderRadius: BorderRadius.circular(10)),
                            child: const Icon(Icons.local_shipping, color: Colors.white, size: 20),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(dapurName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppTheme.primary)),
                                const SizedBox(height: 4),
                                Text('${drivers.length} Driver Tersedia', style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      children: [
                        const Divider(height: 1),
                        ...drivers.map((d) => _buildDriverCard(d)).toList(),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Map Preview di paling bawah layar
          _buildBottomMapPreview(),
        ],
      ),
    );
  }

  Widget _buildDriverCard(Map<String, dynamic> d) {
    Color statusColor = d['isActive'] ? const Color(0xFF059669) : const Color(0xFFD97706);
    Color statusBg = d['isActive'] ? const Color(0xFFD1FAE5) : const Color(0xFFFEF3C7);
    
    if (d['isWarning'] == true) {
      statusColor = const Color(0xFFDC2626);
      statusBg = const Color(0xFFFEE2E2);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9), width: 1)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(d['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.textPrimary)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(8)),
                child: Text(
                  d['status'],
                  style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerLeft,
            child: Text('Kendaraan: ${d['id']}', style: const TextStyle(color: AppTheme.textMuted, fontSize: 12)),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.speed, size: 14, color: AppTheme.textMuted),
                  const SizedBox(width: 4),
                  Text(d['speed'], style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.school, size: 14, color: AppTheme.textMuted),
                  const SizedBox(width: 4),
                  Text(d['location'], style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomMapPreview() {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF64748B),
        image: const DecorationImage(
          image: NetworkImage('https://www.google.com/maps/about/images/mymaps/mymaps-desktop-16x9.png'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black38, BlendMode.darken),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 12, left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: const Row(
                children: [
                  CircleAvatar(radius: 4, backgroundColor: Color(0xFF059669)),
                  SizedBox(width: 6), Text('Aktif', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                  SizedBox(width: 12),
                  CircleAvatar(radius: 4, backgroundColor: Color(0xFFD97706)),
                  SizedBox(width: 6), Text('Berhenti', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                  SizedBox(width: 12),
                  CircleAvatar(radius: 4, backgroundColor: Color(0xFFDC2626)),
                  SizedBox(width: 6), Text('Peringatan', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 12, right: 16,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.fullscreen, color: AppTheme.primary),
            ),
          )
        ],
      ),
    );
  }
}
