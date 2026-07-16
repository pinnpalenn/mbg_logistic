// lib/screens/main_screen.dart
import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'data_screen.dart';
import 'armada_screen.dart';
import 'driver_screen.dart';
import 'optimasi_screen.dart';
import '../utils/app_theme.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  int? _autoSelectDapurId; // Menyimpan id dapur yang dipilih dari tab Armada

  void _jumpToTab(int index) {
    setState(() => _currentIndex = index);
  }

  void _selectArmadaAndGo(int dapurId) {
    setState(() {
      _autoSelectDapurId = dapurId;
      _currentIndex = 1; // Pindah ke tab Rute (OptimasiScreen)
    });
  }

  void _clearAutoSelect() {
    _autoSelectDapurId = null;
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      DashboardScreen(onTabChange: _jumpToTab),
      OptimasiScreen(
        autoSelectDapurId: _autoSelectDapurId,
        onRouteLoaded: _clearAutoSelect, // Reset setelah berhasil termuat
      ),
      const DataScreen(),
      const DriverScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _jumpToTab,
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFF6EE7B7).withOpacity(0.5),
        height: 70,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.grid_view_outlined),
            selectedIcon: Icon(Icons.grid_view, color: AppTheme.primary),
            label: 'Statistik',
          ),
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map, color: AppTheme.primary),
            label: 'Rute',
          ),
          NavigationDestination(
            icon: Icon(Icons.business_outlined),
            selectedIcon: Icon(Icons.business, color: AppTheme.primary),
            label: 'Sekolah',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people, color: AppTheme.primary),
            label: 'Driver',
          ),
        ],
      ),
    );
  }
}
