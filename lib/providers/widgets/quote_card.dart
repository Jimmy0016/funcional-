import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// 📝 Tarjeta visual para mostrar una frase motivacional.
/// Puedes usarla dentro de ListView o GridView.
class QuoteCard extends StatelessWidget {
  final String texto;
  final String autor;
  final VoidCallback? onDelete; // acción para eliminar
  final VoidCallback? onTap;    // acción para abrir detalle

  const QuoteCard({
    super.key,
    required this.texto,
    required this.autor,
    this.onDelete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        shadowColor: Colors.deepPurple.shade100,
        color: Colors.white.withOpacity(0.95),
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🌟 Texto principal
              Text(
                "\"$texto\"",
                style: const TextStyle(
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                  color: Colors.deepPurple,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 12),

              // 👤 Autor y acciones
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "- $autor",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (onDelete != null)
                    IconButton(
                      icon: const Icon(Icons.delete_outline,
                          color: Colors.deepPurple),
                      onPressed: onDelete,
                    ),
                ],
              ),
            ],
          ),
        ),
      )
          // ✨ Animación de aparición
          .animate()
          .fadeIn(duration: 400.ms)
          .slideY(begin: 0.2, end: 0, duration: 400.ms),
    );
  }
}
