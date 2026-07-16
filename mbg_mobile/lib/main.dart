// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'services/auth_provider.dart';
import 'utils/app_theme.dart';
import 'screens/login_screen.dart';
import 'screens/main_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/register_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final auth = AuthProvider();
  await auth.loadSession();

  runApp(
    ChangeNotifierProvider.value(
      value: auth,
      child: const MbgApp(),
    ),
  );
}

class MbgApp extends StatelessWidget {
  const MbgApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Distribusi MBG',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      builder: (context, child) {
        if (!kIsWeb) return child!;
        return Container(
          color: const Color(0xFFF1F5F9), // Background luar HP
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 410, maxHeight: 850),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(color: const Color(0xFF1E293B), width: 12),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 30, spreadRadius: 5),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: child!,
              ),
            ),
          ),
        );
      },
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/main': (context) => const MainScreen(),
      },
    );
  }
}
