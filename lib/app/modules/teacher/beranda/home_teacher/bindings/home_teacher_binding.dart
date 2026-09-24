import 'package:get/get.dart';

import '../controllers/home_teacher_controller.dart';

class HomeTeacherBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeTeacherController>(
      () => HomeTeacherController(),
    );
  }
}
