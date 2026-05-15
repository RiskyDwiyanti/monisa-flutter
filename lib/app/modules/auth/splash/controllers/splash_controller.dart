import 'package:flutter/physics.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:monisa/app/routes/app_pages.dart';

class SplashController extends GetxController with GetSingleTickerProviderStateMixin{
  //TODO: Implement SplashController
  late AnimationController animationController;
  late Animation<double> circleAnimation;

  // Spring physics
  static const SpringDescription splashSpring = SpringDescription(
    mass: 1.0,
    stiffness: 28.44,
    damping: 8,
  );

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500), 
    );

    final springSimulation = SpringSimulation(splashSpring, 0, 1, 0);

    circleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        // Menggunakan spring physics langsung
        curve: _SpringCurve(springSimulation),
      ),
    );

    // Delay 800ms sebelum mulai animasi lingkaran
    Future.delayed(const Duration(milliseconds: 1200), () {
      animationController.forward().then((_) {
        // Setelah animasi selesai, navigate ke Splash 2
        Get.offNamed(Routes.SIGNIN);
      });
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }

  void increment() => count.value++;
}

/// Custom Curve yang menggunakan SpringSimulation Flutter
class _SpringCurve extends Curve {
  final SpringSimulation simulation;
 
  const _SpringCurve(this.simulation);
 
  @override
  double transform(double t) {
    // Clamp agar tidak melewati 1.0 (spring bisa overshoot sedikit)
    return simulation.x(t).clamp(0.0, 1.0);
  }
}
