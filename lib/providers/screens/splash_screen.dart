import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/gradient_background.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    // Espera 3 segundos antes de redirigir
    await Future.delayed(const Duration(seconds: 3));

    final user = _auth.currentUser;
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => user != null ? const HomeScreen() : const LoginScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        showOverlay: true,
        overlayOpacity: 0.1,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 💜 Ícono principal animado
              const Icon(
                Icons.format_quote_rounded,
                size: 100,
                color: Colors.white,
              )
                  .animate()
                  .scale(duration: 800.ms, begin: const Offset(0.6, 0.6), end: const Offset(1, 1))
                  .fadeIn(duration: 800.ms),

              const SizedBox(height: 20),

              // ✨ Texto principal
              const Text(
                "Motivacional App",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              )
                  .animate()
                  .fadeIn(duration: 1000.ms, delay: 400.ms)
                  .moveY(begin: 20, end: 0, duration: 700.ms),

              const SizedBox(height: 10),

              // 🌈 Subtítulo inspirador
              const Text(
                "Inspírate cada día ✨",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                ),
              )
                  .animate()
                  .fadeIn(duration: 1000.ms, delay: 700.ms)
                  .moveY(begin: 10, end: 0, duration: 700.ms),

              const SizedBox(height: 40),

              // 🔄 Indicador de carga animado
              const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              )
                  .animate()
                  .fadeIn(duration: 1200.ms, delay: 900.ms)
                  .scale(
                    duration: 700.ms,
                    begin: const Offset(0.8, 0.8),
                    end: const Offset(1.0, 1.0),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
