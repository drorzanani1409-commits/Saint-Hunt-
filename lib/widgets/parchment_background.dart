import 'package:flutter/material.dart';
import '../utils/constants.dart';

class ParchmentBackground extends StatelessWidget {
  final Widget child;
  final bool showScrollwork;

  const ParchmentBackground({
    Key? key,
    required this.child,
    this.showScrollwork = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppConstants.parchment,
        // For now using solid color, can be replaced with texture image
        image: const DecorationImage(
          image: AssetImage('assets/images/backgrounds/parchment_texture.png'),
          fit: BoxFit.cover,
          opacity: 0.3,
        ),
      ),
      child: Stack(
        children: [
          if (showScrollwork) ...[
            // Top-left scrollwork decoration
            Positioned(
              top: 0,
              left: 0,
              child: CustomPaint(
                size: const Size(80, 80),
                painter: ScrollworkPainter(),
              ),
            ),
            // Top-right scrollwork decoration
            Positioned(
              top: 0,
              right: 0,
              child: Transform.flip(
                flipX: true,
                child: CustomPaint(
                  size: const Size(80, 80),
                  painter: ScrollworkPainter(),
                ),
              ),
            ),
            // Bottom-left scrollwork decoration
            Positioned(
              bottom: 0,
              left: 0,
              child: Transform.flip(
                flipY: true,
                child: CustomPaint(
                  size: const Size(80, 80),
                  painter: ScrollworkPainter(),
                ),
              ),
            ),
            // Bottom-right scrollwork decoration
            Positioned(
              bottom: 0,
              right: 0,
              child: Transform.flip(
                flipX: true,
                flipY: true,
                child: CustomPaint(
                  size: const Size(80, 80),
                  painter: ScrollworkPainter(),
                ),
              ),
            ),
          ],
          child,
        ],
      ),
    );
  }
}

class ScrollworkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppConstants.scrollworkBrown.withOpacity(0.3)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path();
    
    // Draw decorative corner scrollwork
    path.moveTo(0, size.height * 0.3);
    path.quadraticBezierTo(
      size.width * 0.2,
      size.height * 0.2,
      size.width * 0.3,
      0,
    );
    
    path.moveTo(size.width * 0.3, 0);
    path.quadraticBezierTo(
      size.width * 0.2,
      size.height * 0.15,
      0,
      size.height * 0.2,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

