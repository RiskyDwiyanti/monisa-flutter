import 'package:get/get.dart';

import '../controllers/class_teacher_controller.dart';

class ClassTeacherBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClassTeacherController>(
      () => ClassTeacherController(),
    );
  }
}
