import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final maxRadius = size.longestSide * 1.2;

    return Scaffold(
      backgroundColor: const Color(0xFFF08C21),
      body: Stack(
        alignment: Alignment.center,
        children: [
          // ── Layer 1: SVG putih sudah ada dari awal bersama background ──
          Center(
            child: _MonisaText(color: Colors.white),
          ),

          // ── Layer 2: Lingkaran putih mengembang (muncul setelah delay) ──
          AnimatedBuilder(
            animation: controller.animationController,
            builder: (context, child) {
              final circleRadius = controller.circleAnimation.value * maxRadius;

              return ClipPath(
                clipper: _CircleClipper(
                  radius: circleRadius,
                  center: Offset(size.width / 2, size.height / 2),
                ),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.white,
                  child: Center(
                    child: _MonisaText(color: const Color(0xFFF08C21)),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Widget logo Monisa menggunakan SVG
class _MonisaText extends StatelessWidget {
  final Color color;

  const _MonisaText({required this.color});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Text(
          'Monisa',
          style: GoogleFonts.climateCrisis(
            fontSize: 48,
            fontWeight: FontWeight.w400,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 1.5
              ..strokeJoin = StrokeJoin.round
              ..color = Colors.black
          ),
        ),
        // Fill layer
        Text(
          'Monisa',
          style: GoogleFonts.climateCrisis(
            fontSize: 48,
            fontWeight: FontWeight.w400,
            color: color,
          ),
        ),
      ],
    );
  }
}

/// Clipper lingkaran yang mengembang dari titik tengah
class _CircleClipper extends CustomClipper<Path> {
  final double radius;
  final Offset center;

  const _CircleClipper({required this.radius, required this.center});

  @override
  Path getClip(Size size) {
    return Path()
      ..addOval(Rect.fromCircle(center: center, radius: radius));
  }

  @override
  bool shouldReclip(_CircleClipper old) =>
      old.radius != radius || old.center != center;
}