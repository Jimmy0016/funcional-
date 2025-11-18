import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../utils/app_colors.dart';

/// 📝 Tarjeta visual para mostrar una frase motivacional.
/// Puedes usarla dentro de ListView o GridView.
class QuoteCard extends StatefulWidget {
  final String texto;
  final String autor;
  final String? id;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  final VoidCallback? onTap;
  final VoidCallback? onFavorite;
  final bool isFavorite;

  const QuoteCard({
    super.key,
    required this.texto,
    required this.autor,
    this.id,
    this.onDelete,
    this.onEdit,
    this.onTap,
    this.onFavorite,
    this.isFavorite = false,
  });

  @override
  State<QuoteCard> createState() => _QuoteCardState();
}

class _QuoteCardState extends State<QuoteCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          transform: Matrix4.identity()
            ..scale(_isHovered ? 1.02 : 1.0)
            ..translate(0.0, _isHovered ? -5.0 : 0.0),
          margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: _isHovered
                  ? [
                      Colors.white,
                      Colors.purple.shade50,
                      Colors.blue.shade50,
                    ]
                  : [
                      Colors.white.withOpacity(0.95),
                      Colors.white.withOpacity(0.9),
                    ],
            ),
            border: Border.all(
              color: _isHovered
                  ? AppColors.lightPurple.withOpacity(0.3)
                  : Colors.white.withOpacity(0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: _isHovered
                    ? AppColors.primaryPurple.withOpacity(0.15)
                    : Colors.black.withOpacity(0.08),
                blurRadius: _isHovered ? 25 : 15,
                offset: Offset(0, _isHovered ? 12 : 8),
              ),
              if (_isHovered)
                BoxShadow(
                  color: Colors.white.withOpacity(0.8),
                  blurRadius: 5,
                  offset: const Offset(0, -2),
                ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icono de comillas decorativo
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: _isHovered
                              ? AppColors.buttonGradient
                              : [AppColors.lightPurple.withOpacity(0.3), AppColors.primaryBlue.withOpacity(0.3)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.format_quote,
                        color: _isHovered ? Colors.white : AppColors.primaryPurple,
                        size: 20,
                      ),
                    ),
                    const Spacer(),
                    if (_isHovered)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.lightPurple.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          "Toca para ver",
                          style: TextStyle(
                            color: AppColors.primaryPurple,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),

                // Texto principal
                Text(
                  widget.texto,
                  style: TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    color: _isHovered ? AppColors.primaryPurple : AppColors.textPrimary,
                    height: 1.5,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 20),

                // Línea divisoria sutil
                Container(
                  height: 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        _isHovered
                            ? AppColors.lightPurple.withOpacity(0.3)
                            : Colors.grey.withOpacity(0.2),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Autor y acciones
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Icon(
                            Icons.person_outline,
                            size: 16,
                            color: _isHovered ? AppColors.primaryPurple : Colors.grey.shade600,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              widget.autor,
                              style: TextStyle(
                                fontSize: 15,
                                color: _isHovered ? AppColors.primaryPurple : AppColors.textSecondary,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.onFavorite != null)
                          _ActionButton(
                            icon: widget.isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: widget.isFavorite ? Colors.red.shade400 : AppColors.textSecondary,
                            onPressed: widget.onFavorite!,
                            tooltip: widget.isFavorite ? "Quitar de favoritos" : "Agregar a favoritos",
                            isHovered: _isHovered,
                          ),
                        if (widget.onEdit != null)
                          _ActionButton(
                            icon: Icons.edit_outlined,
                            color: AppColors.primaryBlue,
                            onPressed: widget.onEdit!,
                            tooltip: "Editar",
                            isHovered: _isHovered,
                          ),
                        if (widget.onDelete != null)
                          _ActionButton(
                            icon: Icons.delete_outline,
                            color: AppColors.error,
                            onPressed: widget.onDelete!,
                            tooltip: "Eliminar",
                            isHovered: _isHovered,
                          ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 600.ms)
        .slideY(begin: 0.3, end: 0, duration: 500.ms, curve: Curves.easeOutBack);
  }
}

// Widget para botones de acción con hover effect
class _ActionButton extends StatefulWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;
  final String tooltip;
  final bool isHovered;

  const _ActionButton({
    required this.icon,
    required this.color,
    required this.onPressed,
    required this.tooltip,
    required this.isHovered,
  });

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
  bool _isButtonHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isButtonHovered = true),
      onExit: (_) => setState(() => _isButtonHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(left: 8),
        decoration: BoxDecoration(
          color: _isButtonHovered
              ? widget.color.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: IconButton(
          icon: Icon(
            widget.icon,
            color: _isButtonHovered || widget.isHovered
                ? widget.color
                : widget.color.withOpacity(0.6),
            size: 20,
          ),
          onPressed: widget.onPressed,
          tooltip: widget.tooltip,
        ),
      ),
    );
  }
}
