import 'package:get/get.dart';
import 'package:monisa/app/modules/student/class/controllers/class_controller.dart';
import 'package:monisa/app/modules/student/home/controllers/home_controller.dart';
import 'package:monisa/app/modules/student/presence/controllers/presence_controller.dart';
import 'package:monisa/app/modules/student/profile/controllers/profile_controller.dart';

import '../controllers/main_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainController>(
      () => MainController(),
    );
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
    Get.lazyPut<ClassController>(
      () => ClassController(),
    );
    Get.lazyPut<PresenceController>(
      () => PresenceController(),
    );
    Get.lazyPut<ProfileController>(
      () => ProfileController(),
    );
  }
}
