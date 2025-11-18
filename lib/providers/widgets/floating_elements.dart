import 'package:flutter/material.dart';

class FloatingElements extends StatefulWidget {
  const FloatingElements({super.key});

  @override
  State<FloatingElements> createState() => _FloatingElementsState();
}

class _FloatingElementsState extends State<FloatingElements>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(6, (index) {
      return AnimationController(
        duration: Duration(seconds: 3 + index),
        vsync: this,
      )..repeat(reverse: true);
    });

    _animations = _controllers.map((controller) {
      return Tween<double>(begin: -20, end: 20).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOut),
      );
    }).toList();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Elemento flotante 1 - Estrella
        Positioned(
          top: 100,
          left: 30,
          child: AnimatedBuilder(
            animation: _animations[0],
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _animations[0].value),
                child: Icon(
                  Icons.star,
                  color: Colors.white.withOpacity(0.3),
                  size: 25,
                ),
              );
            },
          ),
        ),

        // Elemento flotante 2 - Corazón
        Positioned(
          top: 200,
          right: 40,
          child: AnimatedBuilder(
            animation: _animations[1],
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _animations[1].value),
                child: Icon(
                  Icons.favorite,
                  color: Colors.white.withOpacity(0.2),
                  size: 20,
                ),
              );
            },
          ),
        ),

        // Elemento flotante 3 - Bombilla
        Positioned(
          top: 150,
          right: 80,
          child: AnimatedBuilder(
            animation: _animations[2],
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _animations[2].value),
                child: Icon(
                  Icons.lightbulb_outline,
                  color: Colors.white.withOpacity(0.25),
                  size: 22,
                ),
              );
            },
          ),
        ),

        // Elemento flotante 4 - Diamante
        Positioned(
          bottom: 200,
          left: 50,
          child: AnimatedBuilder(
            animation: _animations[3],
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _animations[3].value),
                child: Icon(
                  Icons.diamond_outlined,
                  color: Colors.white.withOpacity(0.2),
                  size: 18,
                ),
              );
            },
          ),
        ),

        // Elemento flotante 5 - Rayo
        Positioned(
          bottom: 150,
          right: 60,
          child: AnimatedBuilder(
            animation: _animations[4],
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _animations[4].value),
                child: Icon(
                  Icons.flash_on,
                  color: Colors.white.withOpacity(0.3),
                  size: 24,
                ),
              );
            },
          ),
        ),

        // Elemento flotante 6 - Círculo decorativo
        Positioned(
          top: 300,
          left: 20,
          child: AnimatedBuilder(
            animation: _animations[5],
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _animations[5].value),
                child: Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.2),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}