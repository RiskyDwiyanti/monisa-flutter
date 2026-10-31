import 'package:get/get.dart';

import '../controllers/class_student_detail_controller.dart';

class ClassStudentDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClassStudentDetailController>(
      () => ClassStudentDetailController(),
    );
  }
}
