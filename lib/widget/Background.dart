import 'dart:math';
import 'package:flutter/material.dart';

class AnimatedBackground extends StatefulWidget {
  final Widget child; // Konten utama (form, text, dll) akan ditaruh di sini

  const AnimatedBackground({super.key, required this.child});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground> with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Lapisan Gradasi Dasar
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF8BA2E0), Color(0xFF2E4C9B)],
            ),
          ),
        ),

        // Efek Partikel Bergerak
        ..._generateParticles(15),

        // Konten Utama
        SafeArea(child: widget.child),
      ],
    );
  }

  List<Widget> _generateParticles(int count) {
    List<Widget> particles = [];
    Random random = Random();
    for (int i = 0; i < count; i++) {
      particles.add(
        _buildFloatingCircle(
          top: random.nextDouble() * MediaQuery.of(context).size.height,
          left: random.nextDouble() * MediaQuery.of(context).size.width,
          size: random.nextDouble() * 150 + 50,
          opacity: random.nextDouble() * 0.15,
          offset: random.nextDouble() * 40 + 20,
          durationModifier: random.nextDouble() * 0.5 + 0.5,
        ),
      );
    }
    return particles;
  }

  Widget _buildFloatingCircle({
    double? top, double? left, required double size,
    required double opacity, required double offset, double durationModifier = 1.0,
  }) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        double animationValue = sin(_controller.value * pi * durationModifier);
        return Positioned(
          top: top != null ? top + (animationValue * offset) : null,
          left: left != null ? left + (animationValue * offset) : null,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(opacity),
            ),
          ),
        );
      },
    );
  }
}