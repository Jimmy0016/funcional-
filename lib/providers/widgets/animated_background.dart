import 'package:flutter/material.dart';
import 'floating_elements.dart';

class AnimatedBackground extends StatefulWidget {
  final Widget child;
  
  const AnimatedBackground({super.key, required this.child});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with TickerProviderStateMixin {
  late AnimationController _controller1;
  late AnimationController _controller2;
  late Animation<double> _animation1;
  late Animation<double> _animation2;

  @override
  void initState() {
    super.initState();
    
    _controller1 = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();
    
    _controller2 = AnimationController(
      duration: const Duration(seconds: 12),
      vsync: this,
    )..repeat();
    
    _animation1 = Tween<double>(begin: 0, end: 1).animate(_controller1);
    _animation2 = Tween<double>(begin: 0, end: 1).animate(_controller2);
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Fondo base con gradiente
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF667eea),
                Color(0xFF764ba2),
                Color(0xFFf093fb),
              ],
            ),
          ),
        ),
        
        // Círculos animados
        AnimatedBuilder(
          animation: _animation1,
          builder: (context, child) {
            return Positioned(
              top: -100 + (_animation1.value * 50),
              right: -50 + (_animation1.value * 30),
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            );
          },
        ),
        
        AnimatedBuilder(
          animation: _animation2,
          builder: (context, child) {
            return Positioned(
              bottom: -80 + (_animation2.value * 40),
              left: -60 + (_animation2.value * 25),
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.08),
                ),
              ),
            );
          },
        ),
        
        // Elementos flotantes decorativos
        const FloatingElements(),
        
        // Contenido principal
        widget.child,
      ],
    );
  }
}