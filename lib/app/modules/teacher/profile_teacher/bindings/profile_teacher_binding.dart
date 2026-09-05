import 'package:get/get.dart';

import '../controllers/profile_teacher_controller.dart';

class ProfileTeacherBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileTeacherController>(
      () => ProfileTeacherController(),
    );
  }
}
