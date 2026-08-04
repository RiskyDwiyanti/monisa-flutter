import 'package:get/get.dart';
import 'package:monisa/app/modules/student/beranda/home/controllers/home_controller.dart';
import 'package:monisa/app/modules/student/kelas/class/controllers/class_controller.dart';
import 'package:monisa/app/modules/student/kehadiran/presensi/controllers/presensi_controller.dart';
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
    Get.lazyPut<PresensiController>(
      () => PresensiController(),
    );
    Get.lazyPut<ProfileController>(
      () => ProfileController(),
    );
  }
}
