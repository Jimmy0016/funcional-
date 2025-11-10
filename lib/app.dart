import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import './providers/screens/splash_screen.dart';
import './providers/screens/login_screen.dart';
import './providers/screens/register_screen.dart';
import './providers/screens/home_screen.dart';
import './providers/screens/profile_screen.dart';
import './providers/screens/quote_detail_screen.dart';

class MotivacionalApp extends StatelessWidget {
  const MotivacionalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Motivacional App',
      debugShowCheckedModeBanner: false,

      // 💜 Tema global
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          secondary: Colors.purpleAccent,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black87),
        ),
      ),

      // 🧭 Rutas centralizadas
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/quoteDetail': (context) => const QuoteDetailScreen(
              texto: '',
              autor: '',
            ),
      },
    );
  }
}

// 🪄 Inicialización de Firebase antes de ejecutar la app
Future<void> startApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MotivacionalApp());
}
