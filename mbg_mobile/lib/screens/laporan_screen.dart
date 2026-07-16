// lib/screens/laporan_screen.dart
import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class LaporanScreen extends StatelessWidget {
  const LaporanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgBase,
      appBar: AppBar(
        title: const Text('Laporan Analitik'),
        actions: [
          IconButton(icon: const Icon(Icons.download), onPressed: () {}),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildMainStats(),
          const SizedBox(height: 24),
          _buildEfficiencyCard(),
          const SizedBox(height: 24),
          _buildSavingsCard(),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildMainStats() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.cardDecoration,
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('STATUS PENGIRIMAN', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.textMuted)),
              Text('98.4%', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppTheme.accent)),
            ],
          ),
          const SizedBox(height: 20),
          LinearProgressIndicator(value: 0.984, backgroundColor: AppTheme.accent.withOpacity(0.1), color: AppTheme.accent, minHeight: 8),
          const SizedBox(height: 20),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _MiniStat(label: 'TEPAT WAKTU', value: '42 Menit'),
              _MiniStat(label: 'TERKIRIM', value: '1.2k Box'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEfficiencyCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Efisiensi Rute Wilayah', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 20),
          _buildEfficiencyRow('Jakarta Selatan', 0.92),
          _buildEfficiencyRow('Jakarta Timur', 0.85),
          _buildEfficiencyRow('Jakarta Barat', 0.78),
          _buildEfficiencyRow('Jakarta Utara', 0.88),
        ],
      ),
    );
  }

  Widget _buildEfficiencyRow(String label, double val) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
              Text('${(val * 100).toInt()}%', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(value: val, backgroundColor: AppTheme.bgBase, color: AppTheme.primary, minHeight: 4),
        ],
      ),
    );
  }

  Widget _buildSavingsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(16)),
      child: const Row(
        children: [
          Icon(Icons.savings, color: Colors.white, size: 40),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('PENGHEMATAN BBM', style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold)),
              Text('Rp 12.4M', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
              Text('Estimasi biaya operasional yang dihemat', style: TextStyle(color: Colors.white54, fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  const _MiniStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: AppTheme.textMuted)),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
