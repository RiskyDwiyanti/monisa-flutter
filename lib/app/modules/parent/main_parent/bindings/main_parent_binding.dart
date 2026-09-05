import 'package:get/get.dart';
import 'package:monisa/app/modules/parent/class_parent/controllers/class_parent_controller.dart';
import 'package:monisa/app/modules/parent/home_parent/controllers/home_parent_controller.dart';
import 'package:monisa/app/modules/parent/presensi_parent/controllers/presensi_parent_controller.dart';
import 'package:monisa/app/modules/parent/profile_parent/controllers/profile_parent_controller.dart';

import '../controllers/main_parent_controller.dart';

class MainParentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainParentController>(
      () => MainParentController(),
    );
    Get.lazyPut<HomeParentController>(
      () => HomeParentController(),
    );
    Get.lazyPut<ClassParentController>(
      () => ClassParentController(),
    );
    Get.lazyPut<PresensiParentController>(
      () => PresensiParentController(),
    );
    Get.lazyPut<ProfileParentController>(
      () => ProfileParentController(),
    );
  }
}
