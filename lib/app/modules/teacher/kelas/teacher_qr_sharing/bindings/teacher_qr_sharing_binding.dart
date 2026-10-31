import 'package:get/get.dart';

import '../controllers/teacher_qr_sharing_controller.dart';

class TeacherQrSharingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TeacherQrSharingController>(
      () => TeacherQrSharingController(),
    );
  }
}
