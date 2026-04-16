import 'dart:ui';
import 'package:flutter/material.dart';

class Glass extends StatelessWidget {
  const Glass({
    super.key,
    required this.theWidth,
    required this.theHeight,
    required this.theChild,
  });

  final double theWidth;
  final double theHeight;
  final Widget theChild;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: theWidth,
        height: theHeight,
        color: Colors.transparent,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(30), 
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 1.0,
                  sigmaY: 1.0,
                ),
                child: Container(color: Colors.transparent),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: Colors.white.withOpacity(0.13),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.15),
                    Colors.white.withOpacity(0.05),
                  ],
                ),
              ),
            ),
            Center(child: theChild),
          ],
        ),
      ),
    );
  }
}