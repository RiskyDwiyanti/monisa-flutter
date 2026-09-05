import 'package:get/get.dart';
import 'package:monisa/app/modules/teacher/class_teacher/controllers/class_teacher_controller.dart';
import 'package:monisa/app/modules/teacher/home_teacher/controllers/home_teacher_controller.dart';
import 'package:monisa/app/modules/teacher/presensi_teacher/controllers/presensi_teacher_controller.dart';
import 'package:monisa/app/modules/teacher/profile_teacher/controllers/profile_teacher_controller.dart';

import '../controllers/main_teacher_controller.dart';

class MainTeacherBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainTeacherController>(
      () => MainTeacherController(),
    );
    Get.lazyPut<HomeTeacherController>(
      () => HomeTeacherController(),
    );
    Get.lazyPut<ClassTeacherController>(
      () => ClassTeacherController(),
    );
    Get.lazyPut<PresensiTeacherController>(
      () => PresensiTeacherController(),
    );
    Get.lazyPut<ProfileTeacherController>(
      () => ProfileTeacherController(),
    );
  }
}
