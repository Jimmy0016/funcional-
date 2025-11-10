import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

// 🧭 Importar pantallas
import './providers/screens/splash_screen.dart';
import './providers/screens/home_screen.dart';
import './providers/screens/login_screen.dart';
import './providers/screens/register_screen.dart';
import './providers/screens/profile_screen.dart';
import './providers/screens/quote_detail_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔥 Inicializar Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MotivacionalApp());
}

class MotivacionalApp extends StatelessWidget {
  const MotivacionalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Motivacional App',
      debugShowCheckedModeBanner: false,

      // 💜 Tema global de la app
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

      // 🧭 Rutas principales
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

      // 🚀 Pantalla inicial
      home: const SplashScreen(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    // 🔐 Escucha los cambios de sesión de Firebase
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // ⏳ Esperando respuesta de Firebase
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: Colors.deepPurple),
            ),
          );
        }

        // ✅ Usuario autenticado → Home
        if (snapshot.hasData) {
          return const HomeScreen();
        }

        // ❌ No autenticado → Login
        return const LoginScreen();
      },
    );
  }
}
