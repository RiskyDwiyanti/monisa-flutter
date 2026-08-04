import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

/// Membungkus [child] dan meng-animasikan kemunculannya (tinggi + fade)
/// menggunakan spring simulation asli, mereplikasi parameter "Smart Animate"
/// Figma: { mass, stiffness, damping }.
///
/// Berbeda dari AnimatedSize/AnimatedContainer biasa yang pakai Curve tetap,
/// widget ini menjalankan AnimationController dengan `animateWith(SpringSimulation)`
/// sehingga gerakannya benar-benar fisika pegas (bisa sedikit overshoot lalu
/// menetap), bukan sekadar interpolasi easing.
class SpringExpand extends StatefulWidget {
  const SpringExpand({
    super.key,
    required this.expand,
    required this.child,
    this.mass = 1,
    this.stiffness = 256,
    this.damping = 24,
  });

  final bool expand;
  final Widget child;
  final double mass;
  final double stiffness;
  final double damping;

  @override
  State<SpringExpand> createState() => _SpringExpandState();
}

class _SpringExpandState extends State<SpringExpand>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      value: widget.expand ? 1 : 0,
      // Durasi ini cuma batas atas/safety; kecepatan asli ditentukan oleh
      // spring simulation di animateWith, bukan oleh duration ini.
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void didUpdateWidget(covariant SpringExpand oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.expand != widget.expand) {
      _runSpring(target: widget.expand ? 1 : 0);
    }
  }

  void _runSpring({required double target}) {
    final spring = SpringDescription(
      mass: widget.mass,
      stiffness: widget.stiffness,
      damping: widget.damping,
    );
    final simulation = SpringSimulation(
      spring,
      _controller.value, // posisi awal = posisi sekarang (biar tidak "lompat")
      target,
      0, // kecepatan awal
    );
    _controller.animateWith(simulation);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: _controller,
      axisAlignment: -1,
      child: FadeTransition(
        opacity: _controller,
        child: widget.child,
      ),
    );
  }
}