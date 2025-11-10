import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../service/quotes_service.dart';
import '../service/auth_service.dart';
import '../widgets/gradient_background.dart';
import '../widgets/quote_card.dart';
import 'login_screen.dart';
import 'quote_detail_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final QuotesService _quotesService = QuotesService();
  final AuthService _authService = AuthService();

  bool _isLoading = true;
  List<Map<String, dynamic>> frases = [];

  @override
  void initState() {
    super.initState();
    _loadFrases();
  }

  // 🔥 Cargar frases desde Firestore
  Future<void> _loadFrases() async {
    setState(() => _isLoading = true);
    final data = await _quotesService.getQuotes();
    setState(() {
      frases = data;
      _isLoading = false;
    });
  }

  // ➕ Agregar nueva frase
  Future<void> _agregarFrase() async {
    TextEditingController textoController = TextEditingController();
    TextEditingController autorController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Agregar nueva frase"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: textoController,
              decoration: const InputDecoration(labelText: "Frase"),
            ),
            TextField(
              controller: autorController,
              decoration: const InputDecoration(labelText: "Autor"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
            ),
            onPressed: () async {
              if (textoController.text.isNotEmpty &&
                  autorController.text.isNotEmpty) {
                await _quotesService.addQuote(
                  textoController.text,
                  autorController.text,
                );
                if (mounted) Navigator.pop(context);
                _loadFrases();
              } else {
                Fluttertoast.showToast(
                    msg: "Por favor completa todos los campos.");
              }
            },
            child: const Text("Guardar"),
          ),
        ],
      ),
    );
  }

  // 🚪 Cerrar sesión
  Future<void> _logout() async {
    await _authService.signOut();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 🌅 Fondo degradado morado
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              // 🧭 AppBar personalizada
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Frases Motivacionales 💫",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon:
                              const Icon(Icons.person, color: Colors.white),
                          tooltip: "Perfil",
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const ProfileScreen()),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.refresh, color: Colors.white),
                          tooltip: "Actualizar",
                          onPressed: _loadFrases,
                        ),
                        IconButton(
                          icon: const Icon(Icons.logout, color: Colors.white),
                          tooltip: "Cerrar sesión",
                          onPressed: _logout,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // 📝 Contenido principal
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : frases.isEmpty
                        ? const Center(
                            child: Text(
                              "No hay frases disponibles 🕊️",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: frases.length,
                            itemBuilder: (context, index) {
                              final frase = frases[index];
                              return QuoteCard(
                                texto: frase["texto"],
                                autor: frase["autor"],
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => QuoteDetailScreen(
                                        texto: frase["texto"],
                                        autor: frase["autor"],
                                      ),
                                    ),
                                  );
                                },
                                onDelete: () async {
                                  await _quotesService
                                      .deleteQuote(frase["id"]);
                                  _loadFrases();
                                },
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),

      // ➕ Botón flotante para agregar nueva frase
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: _agregarFrase,
        child: const Icon(Icons.add, color: Colors.deepPurple),
      ),
    );
  }
}
