import 'package:get/get.dart';

import '../controllers/presensi_parent_controller.dart';

class PresensiParentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PresensiParentController>(
      () => PresensiParentController(),
    );
  }
}
