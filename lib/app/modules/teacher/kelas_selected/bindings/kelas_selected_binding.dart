import 'package:get/get.dart';

import '../controllers/kelas_selected_controller.dart';

class KelasSelectedBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<KelasSelectedController>(
      () => KelasSelectedController(),
    );
  }
}
