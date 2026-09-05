import 'package:get/get.dart';

import '../controllers/presensi_teacher_controller.dart';

class PresensiTeacherBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PresensiTeacherController>(
      () => PresensiTeacherController(),
    );
  }
}
