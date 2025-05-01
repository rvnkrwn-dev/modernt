import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moderent/layouts/default.dart';
import 'package:moderent/screens/login_screen.dart';
import 'package:moderent/services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _storage = FlutterSecureStorage();
  final _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _startApp();
  }

  Future<void> _startApp() async {
    await Future.delayed(const Duration(seconds: 2)); // Delay splash 2 detik

    final refreshToken = await _storage.read(key: 'refresh_token');

    if (refreshToken != null) {
      // Kalau ada refresh token ➔ coba refresh dan ambil user
      final result = await _authService.initAuth();

      if (!mounted) return;

      if (result?['success'] == true) {
        // Jika sukses, lanjut ke DefaultLayout
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const DefaultLayout()),
        );
      } else {
        // Jika gagal (expired, error), ke LoginScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    } else {
      // Kalau tidak ada refresh token, ke LoginScreen
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Image.asset("assets/images/logo-dark.png", height: 100),
        ),
      ),
    );
  }
}
