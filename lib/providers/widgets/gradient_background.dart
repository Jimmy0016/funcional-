import 'package:flutter/material.dart';
import '../utils/theme.dart';

/// 🌅 Widget reutilizable con fondo degradado morado.
/// Envuelve el contenido de tus pantallas dentro de este widget para darles estilo.
class GradientBackground extends StatelessWidget {
  final Widget child;
  final bool showOverlay;
  final double overlayOpacity;

  const GradientBackground({
    super.key,
    required this.child,
    this.showOverlay = false,
    this.overlayOpacity = 0.3,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppTheme.backgroundGradient,
      ),
      child: Stack(
        children: [
          // 🟣 Capa de fondo degradado
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: AppTheme.backgroundGradient,
              ),
            ),
          ),

          // 🩶 Opcional: capa semitransparente para oscurecer un poco el fondo
          if (showOverlay)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(overlayOpacity),
              ),
            ),

          // 🌟 Contenido principal
          Positioned.fill(
            child: SafeArea(child: child),
          ),
        ],
      ),
    );
  }
}
