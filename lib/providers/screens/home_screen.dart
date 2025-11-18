import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../service/quotes_service.dart';
import '../service/auth_service.dart';
import '../service/favorites_service.dart';
import '../widgets/gradient_background.dart';
import '../widgets/quote_card.dart';
import '../widgets/app_drawer.dart';
import '../utils/app_colors.dart';
import 'login_screen.dart';
import 'quote_detail_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final QuotesService _quotesService = QuotesService();
  final AuthService _authService = AuthService();
  final FavoritesService _favoritesService = FavoritesService();

  bool _isLoading = true;
  List<Map<String, dynamic>> frases = [];
  String _userName = "";
  List<String> _favoriteIds = [];
  late AnimationController _headerAnimationController;
  late AnimationController _fabAnimationController;
  late Animation<double> _headerAnimation;
  late Animation<double> _fabAnimation;

  @override
  void initState() {
    super.initState();
    _headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _headerAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _headerAnimationController, curve: Curves.easeOutBack),
    );
    _fabAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fabAnimationController, curve: Curves.elasticOut),
    );
    _loadFrases();
    _loadUserName();
    _headerAnimationController.forward();
    Future.delayed(const Duration(milliseconds: 500), () {
      _fabAnimationController.forward();
    });
  }

  @override
  void dispose() {
    _headerAnimationController.dispose();
    _fabAnimationController.dispose();
    super.dispose();
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
    final favorites = await _favoritesService.getFavorites();
    setState(() {
      frases = data;
      _favoriteIds = favorites;
      _isLoading = false;
    });
  }

  // ❤️ Toggle favorito
  Future<void> _toggleFavorite(String quoteId) async {
    print('Toggle favorite called for: $quoteId');
    final newState = await _favoritesService.toggleFavorite(quoteId);
    print('New favorite state: $newState');
    setState(() {
      if (newState) {
        _favoriteIds.add(quoteId);
        print('Added to local favorites list');
      } else {
        _favoriteIds.remove(quoteId);
        print('Removed from local favorites list');
      }
    });
    print('Current favorites: $_favoriteIds');
  }

  // Agregar/Editar frase con diseño mejorado
  Future<void> _showQuoteDialog({String? id, String? textoActual, String? autorActual}) async {
    TextEditingController textoController = TextEditingController(text: textoActual ?? '');
    TextEditingController autorController = TextEditingController(text: autorActual ?? '');
    bool isEditing = id != null;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        elevation: 20,
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                Colors.purple.shade50.withOpacity(0.3),
              ],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header con icono
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: AppColors.buttonGradient,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(
                      isEditing ? Icons.edit : Icons.add,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      isEditing ? "Editar frase" : "Nueva frase",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Campo de texto para la frase
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: TextField(
                  controller: textoController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: "Escribe tu frase motivacional",
                    labelStyle: TextStyle(color: Colors.grey.shade600),
                    prefixIcon: Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.lightPurple.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.format_quote, color: AppColors.primaryPurple),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: const BorderSide(color: AppColors.lightPurple, width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Campo de texto para el autor
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: TextField(
                  controller: autorController,
                  decoration: InputDecoration(
                    labelText: "Autor de la frase",
                    labelStyle: TextStyle(color: Colors.grey.shade600),
                    prefixIcon: Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.lightPurple.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.person_outline, color: AppColors.primaryPurple),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: const BorderSide(color: AppColors.lightPurple, width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Botones de acción
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text(
                        "Cancelar",
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: AppColors.buttonGradient,
                        ),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryPurple.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
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
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              isEditing ? Icons.update : Icons.save,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              isEditing ? "Actualizar" : "Guardar",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: AppColors.primaryGradient,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header mejorado con animación
              AnimatedBuilder(
                animation: _headerAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, -50 * (1 - _headerAnimation.value)),
                    child: Opacity(
                      opacity: _headerAnimation.value,
                      child: Container(
                        margin: const EdgeInsets.all(20),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Builder(
                              builder: (context) => _HoverButton(
                                onPressed: () => Scaffold.of(context).openDrawer(),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: const Icon(Icons.menu, color: Colors.white, size: 24),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "¡Hola $_userName! 👋",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    "Frases Motivacionales",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Text(
                                "${frases.length}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 10),

              // Contenido principal mejorado
              Expanded(
                child: _isLoading
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 3,
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              "Cargando frases...",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      )
                    : frases.isEmpty
                        ? Center(
                            child: Container(
                              padding: const EdgeInsets.all(40),
                              margin: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.2),
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.format_quote_rounded,
                                    size: 60,
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    "No hay frases disponibles",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "¡Agrega tu primera frase motivacional!",
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                            itemCount: frases.length,
                            itemBuilder: (context, index) {
                              final frase = frases[index];
                              return TweenAnimationBuilder<double>(
                                duration: Duration(milliseconds: 300 + (index * 100)),
                                tween: Tween(begin: 0.0, end: 1.0),
                                builder: (context, value, child) {
                                  return Transform.translate(
                                    offset: Offset(0, 30 * (1 - value)),
                                    child: Opacity(
                                      opacity: value,
                                      child: QuoteCard(
                                        id: frase["id"],
                                        texto: frase["texto"],
                                        autor: frase["autor"],
                                        isFavorite: _favoriteIds.contains(frase["id"]),
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
                                        onFavorite: () => _toggleFavorite(frase["id"]),
                                        onEdit: () => _showQuoteDialog(
                                          id: frase["id"],
                                          textoActual: frase["texto"],
                                          autorActual: frase["autor"],
                                        ),
                                        onDelete: () async {
                                          final confirm = await showDialog<bool>(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              title: const Text("Confirmar eliminación"),
                                              content: const Text("¿Estás seguro de que deseas eliminar esta frase?"),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Navigator.pop(context, false),
                                                  child: const Text("Cancelar"),
                                                ),
                                                ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.red,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(12),
                                                    ),
                                                  ),
                                                  onPressed: () => Navigator.pop(context, true),
                                                  child: const Text("Eliminar", style: TextStyle(color: Colors.white)),
                                                ),
                                              ],
                                            ),
                                          );
                                          if (confirm == true) {
                                            await _quotesService.deleteQuote(frase["id"]);
                                            _loadFrases();
                                          }
                                        },
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),

      // Botón flotante mejorado con animación
      floatingActionButton: AnimatedBuilder(
        animation: _fabAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _fabAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: const LinearGradient(
                  colors: AppColors.buttonGradient,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryPurple.withOpacity(0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: FloatingActionButton(
                backgroundColor: Colors.transparent,
                elevation: 0,
                onPressed: () => _showQuoteDialog(),
                child: const Icon(Icons.add, color: Colors.white, size: 28),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Widget personalizado para botones con hover effect
class _HoverButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onPressed;

  const _HoverButton({
    required this.child,
    required this.onPressed,
  });

  @override
  State<_HoverButton> createState() => _HoverButtonState();
}

class _HoverButtonState extends State<_HoverButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.identity()..scale(_isHovered ? 1.05 : 1.0),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: _isHovered ? 0.8 : 1.0,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
