import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'home_screen.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';
import '../widgets/animated_background.dart';
import '../utils/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // 🔐 Método de inicio de sesión con Firebase
  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      Fluttertoast.showToast(
        msg: "Inicio de sesión exitoso 🎉",
        gravity: ToastGravity.BOTTOM,
      );

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(
        msg: e.message ?? "Error al iniciar sesión",
        gravity: ToastGravity.BOTTOM,
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    children: [
                      // Logo/Imagen superior con efecto hero
                      Hero(
                        tag: 'login_logo',
                        child: Container(
                          height: 180,
                          width: 180,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(90),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 25,
                                offset: const Offset(0, 15),
                              ),
                              BoxShadow(
                                color: Colors.white.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, -5),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(90),
                            child: Stack(
                              children: [
                                Image.asset(
                                  'assets/images/login.jpg',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(90),
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [Colors.purple.shade300, Colors.blue.shade300],
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.format_quote_rounded,
                                        size: 70,
                                        color: Colors.white,
                                      ),
                                    );
                                  },
                                ),
                                // Overlay con gradiente sutil
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(90),
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withOpacity(0.1),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      
                      // Título
                      const Text(
                        "Frases Motivacionales",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black26,
                              offset: Offset(2, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Inspírate cada día 💫",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 40),
                      
                      // Contenedor del formulario con efecto glassmorphism
                      Container(
                        padding: const EdgeInsets.all(28),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 30,
                              offset: const Offset(0, 15),
                            ),
                            BoxShadow(
                              color: Colors.white.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, -5),
                            ),
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [

                              // Campo Email con animación
                              TweenAnimationBuilder<double>(
                                duration: const Duration(milliseconds: 800),
                                tween: Tween(begin: 0.0, end: 1.0),
                                builder: (context, value, child) {
                                  return Transform.translate(
                                    offset: Offset(0, 20 * (1 - value)),
                                    child: Opacity(
                                      opacity: value,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(18),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(0.15),
                                              blurRadius: 15,
                                              offset: const Offset(0, 8),
                                            ),
                                          ],
                                        ),
                                        child: TextFormField(
                                          controller: _emailController,
                                          keyboardType: TextInputType.emailAddress,
                                          decoration: InputDecoration(
                                            labelText: "Correo electrónico",
                                            labelStyle: TextStyle(color: Colors.grey.shade600),
                                            prefixIcon: Container(
                                              margin: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: Colors.purple.shade50,
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Icon(Icons.email_outlined, color: Colors.purple.shade400),
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(18),
                                              borderSide: BorderSide.none,
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(18),
                                              borderSide: BorderSide(color: Colors.purple.shade300, width: 2),
                                            ),
                                            filled: true,
                                            fillColor: Colors.grey.shade50,
                                            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                                          ),
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return "Por favor, ingresa tu correo";
                                            }
                                            if (!value.contains('@')) {
                                              return "Correo inválido";
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 20),

                              // Campo Contraseña con animación
                              TweenAnimationBuilder<double>(
                                duration: const Duration(milliseconds: 1000),
                                tween: Tween(begin: 0.0, end: 1.0),
                                builder: (context, value, child) {
                                  return Transform.translate(
                                    offset: Offset(0, 20 * (1 - value)),
                                    child: Opacity(
                                      opacity: value,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(18),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(0.15),
                                              blurRadius: 15,
                                              offset: const Offset(0, 8),
                                            ),
                                          ],
                                        ),
                                        child: TextFormField(
                                          controller: _passwordController,
                                          obscureText: _obscurePassword,
                                          decoration: InputDecoration(
                                            labelText: "Contraseña",
                                            labelStyle: TextStyle(color: Colors.grey.shade600),
                                            prefixIcon: Container(
                                              margin: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: Colors.purple.shade50,
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Icon(Icons.lock_outline, color: Colors.purple.shade400),
                                            ),
                                            suffixIcon: IconButton(
                                              icon: Icon(
                                                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                                color: Colors.purple.shade400,
                                              ),
                                              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(18),
                                              borderSide: BorderSide.none,
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(18),
                                              borderSide: BorderSide(color: Colors.purple.shade300, width: 2),
                                            ),
                                            filled: true,
                                            fillColor: Colors.grey.shade50,
                                            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                                          ),
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return "Ingresa tu contraseña";
                                            }
                                            if (value.length < 6) {
                                              return "Debe tener al menos 6 caracteres";
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 20),

                              // Enlace "¿Olvidaste tu contraseña?"
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
                                    );
                                  },
                                  child: Text(
                                    "¿Olvidaste tu contraseña?",
                                    style: TextStyle(
                                      color: Colors.purple.shade600,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30),

                              // Botón de inicio de sesión con animación
                              TweenAnimationBuilder<double>(
                                duration: const Duration(milliseconds: 1200),
                                tween: Tween(begin: 0.0, end: 1.0),
                                builder: (context, value, child) {
                                  return Transform.scale(
                                    scale: 0.8 + (0.2 * value),
                                    child: Opacity(
                                      opacity: value,
                                      child: _isLoading
                                          ? Container(
                                              height: 58,
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [Colors.purple.shade400, Colors.blue.shade400],
                                                ),
                                                borderRadius: BorderRadius.circular(29),
                                              ),
                                              child: const Center(
                                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                                              ),
                                            )
                                          : Container(
                                              width: double.infinity,
                                              height: 58,
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  begin: Alignment.centerLeft,
                                                  end: Alignment.centerRight,
                                                  colors: [Colors.purple.shade400, Colors.blue.shade400, Colors.purple.shade300],
                                                ),
                                                borderRadius: BorderRadius.circular(29),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.purple.withOpacity(0.4),
                                                    blurRadius: 20,
                                                    offset: const Offset(0, 10),
                                                  ),
                                                  BoxShadow(
                                                    color: Colors.white.withOpacity(0.1),
                                                    blurRadius: 5,
                                                    offset: const Offset(0, -2),
                                                  ),
                                                ],
                                              ),
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.transparent,
                                                  shadowColor: Colors.transparent,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(29),
                                                  ),
                                                ),
                                                onPressed: _login,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    const Icon(Icons.login, color: Colors.white, size: 22),
                                                    const SizedBox(width: 8),
                                                    const Text(
                                                      "Iniciar sesión",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.bold,
                                                        letterSpacing: 0.5,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Ir al registro
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "¿No tienes cuenta? ",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 16,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const RegisterScreen()),
                              );
                            },
                            child: const Text(
                              "Regístrate",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
