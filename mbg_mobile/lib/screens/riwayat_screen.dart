// lib/screens/riwayat_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_provider.dart';
import '../models/rute.dart';
import '../utils/app_theme.dart';

class RiwayatScreen extends StatefulWidget {
  const RiwayatScreen({super.key});

  @override
  State<RiwayatScreen> createState() => _RiwayatScreenState();
}

class _RiwayatScreenState extends State<RiwayatScreen> {
  List<RiwayatRute> _riwayat = [];
  bool _loading = true;
  String? _error;
  String _search = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final api = context.read<AuthProvider>().apiService;
      final list = await api.getRiwayat();
      if (mounted) setState(() { _riwayat = list; _loading = false; });
    } catch (e) {
      if (mounted) setState(() { _error = e.toString().replaceAll('Exception: ', ''); _loading = false; });
    }
  }

  Future<void> _delete(int id, BuildContext ctx) async {
    final confirm = await showDialog<bool>(
      context: ctx,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.bgCard,
        title: const Text('Hapus Riwayat?', style: TextStyle(color: AppTheme.textPrimary)),
        content: Text('Riwayat #$id akan dihapus permanen.', style: const TextStyle(color: AppTheme.textSecondary)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.danger),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    try {
      await context.read<AuthProvider>().apiService.deleteRiwayat(id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Riwayat dihapus'), backgroundColor: AppTheme.primary),
        );
        await _load();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: AppTheme.danger),
        );
      }
    }
  }

  List<RiwayatRute> get _filtered {
    if (_search.isEmpty) return _riwayat;
    final q = _search.toLowerCase();
    return _riwayat.where((r) =>
      (r.namaDapur ?? '').toLowerCase().contains(q) ||
      (r.detailUrutan ?? '').toLowerCase().contains(q)
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Distribusi'),
        actions: [
          IconButton(onPressed: _load, icon: const Icon(Icons.refresh_outlined), tooltip: 'Refresh'),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            color: AppTheme.bgCard,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: TextField(
              onChanged: (v) => setState(() => _search = v),
              decoration: InputDecoration(
                hintText: 'Cari dapur atau urutan...',
                prefixIcon: const Icon(Icons.search, color: AppTheme.textMuted),
                suffixIcon: _search.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: AppTheme.textMuted),
                        onPressed: () => setState(() => _search = ''),
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
            ),
          ),

          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator(color: AppTheme.primary))
                : _error != null
                    ? _buildError()
                    : _filtered.isEmpty
                        ? _buildEmpty()
                        : RefreshIndicator(
                            color: AppTheme.primary,
                            onRefresh: _load,
                            child: ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: _filtered.length,
                              itemBuilder: (ctx, i) => _RiwayatCard(
                                rute: _filtered[i],
                                onDelete: (id) => _delete(id, ctx),
                              ),
                            ),
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 48, color: AppTheme.danger),
          const SizedBox(height: 12),
          Text(_error!, textAlign: TextAlign.center, style: const TextStyle(color: AppTheme.textMuted)),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: _load, child: const Text('Coba Lagi')),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.bgCard2.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: const Text('📭', style: TextStyle(fontSize: 64)),
            ),
            const SizedBox(height: 24),
            Text(
              _search.isNotEmpty ? 'Tidak ada hasil untuk "$_search"' : 'Belum ada riwayat distribusi',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppTheme.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _search.isNotEmpty 
                ? 'Coba gunakan kata kunci lain seperti nama dapur' 
                : 'Silakan lakukan optimasi rute terlebih dahulu di tab Optimasi untuk melihat riwayat di sini.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppTheme.textMuted, fontSize: 13, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}

class _RiwayatCard extends StatelessWidget {
  final RiwayatRute rute;
  final void Function(int) onDelete;

  const _RiwayatCard({required this.rute, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppTheme.bgCard2,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '#${rute.idRute ?? '—'}',
                    style: const TextStyle(fontSize: 12, color: AppTheme.textMuted, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    rute.namaDapur ?? 'Dapur #${rute.idDapur}',
                    style: const TextStyle(fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (rute.idRute != null)
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: AppTheme.danger, size: 20),
                    onPressed: () => onDelete(rute.idRute!),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _InfoChip(icon: Icons.calendar_today_outlined, label: rute.tanggalDistribusi),
                const SizedBox(width: 8),
                _InfoChip(
                  icon: Icons.route_outlined,
                  label: '${rute.totalJarakKm.toStringAsFixed(2)} km',
                  color: AppTheme.primary,
                ),
              ],
            ),
            if (rute.detailUrutan != null && rute.detailUrutan!.isNotEmpty) ...[
              const SizedBox(height: 10),
              const Divider(height: 1),
              const SizedBox(height: 10),
              Text(
                rute.detailUrutan!,
                style: const TextStyle(fontSize: 11, color: AppTheme.textMuted, height: 1.5),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoChip({required this.icon, required this.label, this.color = AppTheme.textMuted});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 5),
          Text(label, style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
