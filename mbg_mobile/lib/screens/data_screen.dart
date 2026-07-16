// lib/screens/data_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_provider.dart';
import '../models/dapur.dart';
import '../models/sekolah.dart';
import '../utils/app_theme.dart';

class DataScreen extends StatefulWidget {
  const DataScreen({super.key});

  @override
  State<DataScreen> createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  List<Dapur> _dapurList = [];
  Map<int, List<Sekolah>> _groupedSchools = {};
  bool _loading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  Future<void> _loadAll() async {
    if (!mounted) return;
    setState(() => _loading = true);
    try {
      final api = context.read<AuthProvider>().apiService;
      final results = await Future.wait([api.getDapur(), api.getSekolah()]);
      
      final kitchens = results[0] as List<Dapur>;
      final schools = results[1] as List<Sekolah>;

      Map<int, List<Sekolah>> grouped = {};
      for (var s in schools) {
        if (!grouped.containsKey(s.idDapur)) grouped[s.idDapur] = [];
        grouped[s.idDapur]!.add(s);
      }

      if (mounted) {
        setState(() {
          _dapurList = kitchens;
          _groupedSchools = grouped;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Sekolah Penerima', style: TextStyle(fontWeight: FontWeight.w900, color: AppTheme.primary)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: _loading 
        ? const Center(child: CircularProgressIndicator())
        : ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _buildHeaderInfo(),
              const SizedBox(height: 16),
              _buildSearchBar(),
              const SizedBox(height: 12),
              _buildFilterButton(),
              const SizedBox(height: 20),
              _buildStatusChips(),
              const SizedBox(height: 24),
              ..._buildKitchenCards(),
              const SizedBox(height: 32),
              _buildCakupanWilayah(),
              const SizedBox(height: 16),
              _buildJangkauanCard(),
              const SizedBox(height: 100),
            ],
          ),
    );
  }

  Widget _buildHeaderInfo() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Memantau distribusi MBG untuk 124 institusi mitra.', style: TextStyle(fontSize: 12, color: AppTheme.textMuted)),
      ],
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      onChanged: (v) => setState(() => _searchQuery = v),
      decoration: InputDecoration(
        hintText: 'Cari nama sekolah atau ID...',
        prefixIcon: const Icon(Icons.search, size: 20),
        fillColor: Colors.white,
        filled: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[200]!)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[200]!)),
      ),
    );
  }

  Widget _buildFilterButton() {
    return Container(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.filter_list, size: 18),
        label: const Text('Filter'),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppTheme.primary,
          side: const BorderSide(color: AppTheme.primary),
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _buildStatusChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildChip('Semua Sekolah', true),
          const SizedBox(width: 8),
          _buildChip('Terkirim Hari Ini (86)', false),
          const SizedBox(width: 8),
          _buildChip('Menunggu (38)', false),
        ],
      ),
    );
  }

  Widget _buildChip(String label, bool active) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: active ? AppTheme.primary : const Color(0xFFDBEAFE),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: TextStyle(color: active ? Colors.white : AppTheme.primary, fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }

  List<Widget> _buildKitchenCards() {
    final filtered = _dapurList.where((d) => d.namaDapur.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    
    return filtered.map((d) {
      final schools = _groupedSchools[d.idDapur] ?? [];
      return _buildKitchenCard(d, schools.length);
    }).toList();
  }

  Widget _buildKitchenCard(Dapur dapur, int schoolCount) {
    bool isTerkirim = dapur.namaDapur.contains('Jalan Baru'); // Mock status
    final schools = _groupedSchools[dapur.idDapur] ?? [];
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey[100]!),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.all(20),
          childrenPadding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: const Color(0xFF1E40AF), borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.business, color: Colors.white, size: 20),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: isTerkirim ? const Color(0xFFD1FAE5) : const Color(0xFFFEE2E2), borderRadius: BorderRadius.circular(8)),
                    child: Text(isTerkirim ? 'TERKIRIM' : 'MENUNGGU', style: TextStyle(color: isTerkirim ? const Color(0xFF059669) : const Color(0xFFB91C1C), fontSize: 9, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(dapur.namaDapur, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppTheme.primary)),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.location_on_outlined, size: 14, color: AppTheme.textMuted),
                  const SizedBox(width: 4),
                  Expanded(child: Text('Total ${schools.length} Sekolah', style: const TextStyle(fontSize: 11, color: AppTheme.textMuted))),
                ],
              ),
            ],
          ),
          children: [
            const Divider(),
            const SizedBox(height: 12),
            if (schools.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text("Belum ada sekolah terdaftar.", style: TextStyle(color: AppTheme.textMuted, fontSize: 13)),
              )
            else
              ...schools.map((s) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0E7FF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.school, size: 16, color: AppTheme.primary),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(s.namaSekolah, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.textPrimary)),
                          Text('${s.porsiMbg} Porsi', style: const TextStyle(fontSize: 11, color: AppTheme.textMuted)),
                        ],
                      ),
                    ),
                    const Icon(Icons.check_circle, color: Color(0xFF059669), size: 16),
                  ],
                ),
              )).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildCakupanWilayah() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Text('Cakupan Wilayah', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppTheme.primary)),
            Spacer(),
            Text('● Aktif', style: TextStyle(color: Color(0xFF059669), fontSize: 10, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          height: 250,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFA0AEC0),
            borderRadius: BorderRadius.circular(24),
            image: const DecorationImage(image: NetworkImage('https://www.google.com/maps/about/images/mymaps/mymaps-desktop-16x9.png'), fit: BoxFit.cover, opacity: 0.5),
          ),
          child: Center(
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.explore_outlined, size: 18),
              label: const Text('Melihat Hub Jakarta'),
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildJangkauanCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: const Color(0xFF1E3A8A), borderRadius: BorderRadius.circular(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.trending_up, color: Colors.white, size: 24),
          const SizedBox(height: 16),
          const Text('Jangkauan Hari Ini', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          const Text('Efisiensi distribusi naik 12% dari kemarin.', style: TextStyle(color: Colors.white70, fontSize: 10)),
          const SizedBox(height: 20),
          const Text('94.2%', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900)),
          const Text('Tingkat Pengiriman Tepat Waktu', style: TextStyle(color: Colors.white70, fontSize: 10)),
        ],
      ),
    );
  }
}
