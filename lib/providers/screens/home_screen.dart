import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../service/quotes_service.dart';
import '../service/auth_service.dart';
import '../widgets/gradient_background.dart';
import '../widgets/quote_card.dart';
import '../widgets/app_drawer.dart';
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
  String _userName = "";

  @override
  void initState() {
    super.initState();
    _loadFrases();
    _loadUserName();
  }

  // 👤 Cargar nombre del usuario
  Future<void> _loadUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userData = await _authService.getUserData(user.uid);
      if (userData != null) {
        setState(() {
          _userName = userData['nombre'] ?? 'Usuario';
        });
      }
    }
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

  // ➕ Agregar/Editar frase
  Future<void> _showQuoteDialog({String? id, String? textoActual, String? autorActual}) async {
    TextEditingController textoController = TextEditingController(text: textoActual ?? '');
    TextEditingController autorController = TextEditingController(text: autorActual ?? '');
    bool isEditing = id != null;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(isEditing ? "Editar frase" : "Agregar nueva frase"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: textoController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Frase",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: autorController,
              decoration: const InputDecoration(
                labelText: "Autor",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (textoController.text.isNotEmpty && autorController.text.isNotEmpty) {
                if (isEditing) {
                  await _quotesService.updateQuote(id!, textoController.text, autorController.text);
                } else {
                  await _quotesService.addQuote(textoController.text, autorController.text);
                }
                if (mounted) Navigator.pop(context);
                _loadFrases();
              } else {
                Fluttertoast.showToast(msg: "Por favor completa todos los campos.");
              }
            },
            child: Text(isEditing ? "Actualizar" : "Guardar"),
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
      drawer: const AppDrawer(),
      // 🌅 Fondo degradado celeste
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
                    Builder(
                      builder: (context) => IconButton(
                        icon: const Icon(Icons.menu, color: Colors.white),
                        onPressed: () => Scaffold.of(context).openDrawer(),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "¡Hola $_userName! 👋",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Text(
                            "Frases Motivacionales ☁️",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 40),
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
                                id: frase["id"],
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
                                onEdit: () => _showQuoteDialog(
                                  id: frase["id"],
                                  textoActual: frase["texto"],
                                  autorActual: frase["autor"],
                                ),
                                onDelete: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text("Confirmar"),
                                      content: const Text("¿Eliminar esta frase?"),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context, false),
                                          child: const Text("Cancelar"),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                          onPressed: () => Navigator.pop(context, true),
                                          child: const Text("Eliminar"),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (confirm == true) {
                                    await _quotesService.deleteQuote(frase["id"]);
                                    _loadFrases();
                                  }
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
        backgroundColor: Colors.lightBlue,
        onPressed: () => _showQuoteDialog(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
