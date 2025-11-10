import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/gradient_background.dart';
import '../service/auth_service.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final AuthService _authService = AuthService();

    return Scaffold(
      body: GradientBackground(
        showOverlay: true,
        overlayOpacity: 0.15,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // 🔙 Botón de regreso
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text(
                      "Perfil de Usuario 👤",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 40),
                  ],
                ),

                const SizedBox(height: 40),

                // 🖼️ Avatar de usuario
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.white.withOpacity(0.9),
                  child: const Icon(
                    Icons.person_rounded,
                    size: 70,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(height: 20),

                // ✉️ Información del usuario
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepPurple.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.email, color: Colors.deepPurple),
                        title: const Text(
                          "Correo electrónico",
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          user?.email ?? "No disponible",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.date_range, color: Colors.deepPurple),
                        title: const Text(
                          "Cuenta creada el",
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          user?.metadata.creationTime
                                  ?.toLocal()
                                  .toString()
                                  .split('.')[0] ??
                              "Desconocido",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),

                // 🚪 Botón de cerrar sesión
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () async {
                    await _authService.signOut();
                    if (context.mounted) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                        (route) => false,
                      );
                    }
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text(
                    "Cerrar sesión",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
