import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// 📝 Tarjeta visual para mostrar una frase motivacional.
/// Puedes usarla dentro de ListView o GridView.
class QuoteCard extends StatelessWidget {
  final String texto;
  final String autor;
  final String? id;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  final VoidCallback? onTap;

  const QuoteCard({
    super.key,
    required this.texto,
    required this.autor,
    this.id,
    this.onDelete,
    this.onEdit,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        shadowColor: Colors.lightBlue.shade100,
        color: Colors.white.withOpacity(0.98),
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
                  color: Colors.lightBlue,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 12),

              // 👤 Autor y acciones
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "- $autor",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (onEdit != null)
                        IconButton(
                          icon: const Icon(Icons.edit_outlined,
                              color: Colors.lightBlue, size: 20),
                          onPressed: onEdit,
                          tooltip: "Editar",
                        ),
                      if (onDelete != null)
                        IconButton(
                          icon: const Icon(Icons.delete_outline,
                              color: Colors.red, size: 20),
                          onPressed: onDelete,
                          tooltip: "Eliminar",
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      )
          // ✨ Animación de aparición
          .animate()
          .fadeIn(duration: 500.ms)
          .slideX(begin: 0.3, end: 0, duration: 500.ms)
          .scale(begin: const Offset(0.8, 0.8), end: const Offset(1.0, 1.0), duration: 400.ms),
    );
  }
}
