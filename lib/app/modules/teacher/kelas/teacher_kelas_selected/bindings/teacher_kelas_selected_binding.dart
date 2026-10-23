import 'package:get/get.dart';

import '../controllers/teacher_kelas_selected_controller.dart';

class TeacherKelasSelectedBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TeacherKelasSelectedController>(
      () => TeacherKelasSelectedController(),
    );
  }
}
