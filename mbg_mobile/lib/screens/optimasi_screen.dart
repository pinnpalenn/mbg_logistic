// lib/screens/optimasi_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../services/auth_provider.dart';
import '../models/dapur.dart';
import '../models/sekolah.dart';
import '../models/rute.dart';
import '../utils/app_theme.dart';

class OptimasiScreen extends StatefulWidget {
  final int? autoSelectDapurId;
  final VoidCallback? onRouteLoaded;

  const OptimasiScreen({super.key, this.autoSelectDapurId, this.onRouteLoaded});

  @override
  State<OptimasiScreen> createState() => _OptimasiScreenState();
}

class _OptimasiScreenState extends State<OptimasiScreen> {
  List<Dapur> _dapurList = [];
  Dapur? _selectedDapur;
  HasilOptimasi? _hasil;
  bool _loading = false;
  bool _isDeliveryActive = false;
  int _currentStepIndex = 1;

  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _loadDapur();
  }

  @override
  void didUpdateWidget(OptimasiScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.autoSelectDapurId != null && widget.autoSelectDapurId != oldWidget.autoSelectDapurId) {
      _handleAutoSelect();
    }
  }

  void _handleAutoSelect() {
    if (_dapurList.isEmpty) return;
    
    final match = _dapurList.firstWhere(
      (d) => d.idDapur == widget.autoSelectDapurId,
      orElse: () => _dapurList.first,
    );
    
    setState(() {
      _selectedDapur = match;
    });

    _mapController.move(LatLng(match.latitude, match.longitude), 13.0);
    _hitungRute();

    if (widget.onRouteLoaded != null) {
      widget.onRouteLoaded!();
    }
  }

  Future<void> _loadDapur() async {
    if (!mounted) return;
    final api = context.read<AuthProvider>().apiService;
    try {
      final list = await api.getDapur();
      if (mounted) {
        setState(() {
          _dapurList = list;
          if (_dapurList.isNotEmpty) _selectedDapur = _dapurList.first;
        });

        if (widget.autoSelectDapurId != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _handleAutoSelect();
          });
        }
      }
    } catch (e) {
      print('Gagal load dapur: $e');
    }
  }

  Future<void> _hitungRute() async {
    if (_selectedDapur == null) return;
    setState(() => _loading = true);
    final api = context.read<AuthProvider>().apiService;
    try {
      final sekolahList = await api.getSekolah(idDapur: _selectedDapur!.idDapur);
      if (sekolahList.isEmpty) {
        throw Exception('Tidak ada sekolah di dapur ini. Tambahkan sekolah dulu!');
      }
      final res = await api.postOptimasi(
        idDapur: _selectedDapur!.idDapur,
        idSekolah: sekolahList.map((s) => s.idSekolah).toList(),
      );
      setState(() {
        _hasil = res;
        _loading = false;
        _isDeliveryActive = false;
        _currentStepIndex = 1;
      });

      if (res.urutan.isNotEmpty) {
        _mapController.move(LatLng(res.urutan[0].latitude, res.urutan[0].longitude), 13.0);
      }
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          _buildRealMap(),
          
          if (!_isDeliveryActive) 
            Positioned(
              top: 50, 
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: SizedBox(width: MediaQuery.of(context).size.width * 0.9, child: _buildFloatingHeader()),
              ),
            ),

          Positioned(
            bottom: 30,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: _hasil == null 
                  ? _buildInitialCard() 
                  : (_isDeliveryActive ? _buildDeliveryCard() : _buildResultCard()),
              ),
            ),
          ),
          
          if (_loading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }

  Widget _buildRealMap() {
    List<Marker> markers = [];
    List<LatLng> polylinePoints = [];

    if (_hasil != null) {
      for (var i = 0; i < _hasil!.urutan.length; i++) {
        final point = _hasil!.urutan[i];
        final latLng = LatLng(point.latitude, point.longitude);
        polylinePoints.add(latLng);

        markers.add(
          Marker(
            point: latLng,
            width: 40,
            height: 40,
            child: Icon(
              i == 0 ? Icons.kitchen : Icons.school,
              color: i == 0 ? AppTheme.primary : AppTheme.accent,
              size: 30,
            ),
          ),
        );
      }
    } else if (_selectedDapur != null) {
      markers.add(
        Marker(
          point: LatLng(_selectedDapur!.latitude, _selectedDapur!.longitude),
          width: 40,
          height: 40,
          child: const Icon(Icons.kitchen, color: AppTheme.primary, size: 30),
        ),
      );
    }

    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: _selectedDapur != null 
          ? LatLng(_selectedDapur!.latitude, _selectedDapur!.longitude)
          : const LatLng(-0.947, 100.417), 
        initialZoom: 13.0,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.app',
        ),
        if (polylinePoints.isNotEmpty)
          PolylineLayer(
            polylines: [
              Polyline(
                points: polylinePoints,
                strokeWidth: 4,
                color: AppTheme.primary.withOpacity(0.7),
              ),
            ],
          ),
        MarkerLayer(markers: markers),
      ],
    );
  }

  Widget _buildFloatingHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)]),
      child: Row(
        children: [
          const Icon(Icons.location_on, color: AppTheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<Dapur>(
                isExpanded: true, value: _selectedDapur, 
                items: _dapurList.map((d) => DropdownMenuItem(value: d, child: Text(d.namaDapur))).toList(),
                onChanged: (v) {
                  setState(() => _selectedDapur = v);
                  _mapController.move(LatLng(v!.latitude, v.longitude), 13.0);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInitialCard() {
    return Container(
      padding: const EdgeInsets.all(24), decoration: AppTheme.cardDecoration,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.auto_awesome, color: AppTheme.accent, size: 40),
          const SizedBox(height: 16),
          const Text('Kalkulasi Rute Optimal', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const Text('Hitung urutan distribusi terbaik otomatis.', textAlign: TextAlign.center, style: TextStyle(color: AppTheme.textMuted, fontSize: 12)),
          const SizedBox(height: 24),
          SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _hitungRute, child: const Text('Hitung Sekarang'))),
        ],
      ),
    );
  }

  Widget _buildResultCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)))),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text('Urutan Optimal', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppTheme.primary)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: AppTheme.accent.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                child: Text('${_hasil!.urutan.length - 2} Perhentian', style: const TextStyle(color: AppTheme.accent, fontWeight: FontWeight.bold, fontSize: 10)),
              ),
              IconButton(icon: const Icon(Icons.close, size: 18), onPressed: () => setState(() => _hasil = null)),
            ],
          ),
          const SizedBox(height: 16),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 200),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _hasil!.urutan.length,
              itemBuilder: (ctx, i) => _buildFigmaStep(i),
            ),
          ),
          const Divider(height: 24),
          Row(
            children: [
              _buildStats('TOTAL WAKTU', '1j 12m', AppTheme.primary),
              const Spacer(),
              _buildStats('EFISIENSI BBM', '8.2 L/100km', AppTheme.accent),
              const Spacer(),
              ElevatedButton(
                onPressed: () => setState(() => _isDeliveryActive = true),
                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: const Text('Mulai Antar', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFigmaStep(int index) {
    final point = _hasil!.urutan[index];
    final isLast = index == _hasil!.urutan.length - 1;
    final isFirst = index == 0;

    String stepLabel = '';
    if (isFirst) {
      stepLabel = 'Titik Keberangkatan';
    } else if (isLast) {
      stepLabel = 'Kembali ke Dapur';
    } else {
      stepLabel = '${point.porsiMbg} porsi';
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 20, height: 20,
                decoration: BoxDecoration(
                  color: (isFirst || isLast) ? AppTheme.primary : Colors.white, 
                  border: Border.all(color: AppTheme.accent, width: 2), 
                  shape: BoxShape.circle
                ),
                child: Center(
                  child: Text(
                    isLast ? 'F' : '${index + 1}', 
                    style: TextStyle(color: (isFirst || isLast) ? Colors.white : AppTheme.accent, fontSize: 9, fontWeight: FontWeight.bold)
                  )
                ),
              ),
              if (!isLast)
                Expanded(child: Container(width: 2, color: Colors.grey[300])),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(point.nama, style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primary, fontSize: 13)),
                        Text(stepLabel, style: const TextStyle(color: AppTheme.textMuted, fontSize: 11)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 8, color: AppTheme.textMuted, fontWeight: FontWeight.bold)),
        Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: color)),
      ],
    );
  }

  Widget _buildDeliveryCard() {
    final destination = _hasil!.urutan[_currentStepIndex];
    final isLast = _currentStepIndex == _hasil!.urutan.length - 1;

    _mapController.move(LatLng(destination.latitude, destination.longitude), 14.0);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: AppTheme.cardDecoration,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: AppTheme.accent, borderRadius: BorderRadius.circular(8)), child: Text(isLast ? 'Kembali' : 'Tujuan Ke-$_currentStepIndex', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))),
              const Spacer(),
              const Text('ETA 12m', style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              CircleAvatar(backgroundColor: AppTheme.bgBase, child: Icon(isLast ? Icons.kitchen : Icons.school, color: AppTheme.primary)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(destination.nama, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: AppTheme.primary)),
                    Text(isLast ? 'Kembali ke Dapurnya' : '${destination.porsiMbg} Box Makanan', style: const TextStyle(color: AppTheme.textMuted))
                  ]
                )
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.map), label: const Text('Navigasi'))),
              const SizedBox(width: 12),
              Expanded(flex: 2, child: ElevatedButton(onPressed: () { if (isLast) { setState(() { _isDeliveryActive = false; _hasil = null; }); } else { setState(() => _currentStepIndex++); } }, style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accent), child: Text(isLast ? 'Selesai Distribusi' : 'Konfirmasi Terkirim'))),
            ],
          ),
        ],
      ),
    );
  }
}
