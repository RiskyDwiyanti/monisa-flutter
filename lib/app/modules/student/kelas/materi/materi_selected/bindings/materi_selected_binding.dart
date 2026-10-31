import 'package:get/get.dart';

import '../controllers/materi_selected_controller.dart';

class MateriSelectedBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MateriSelectedController>(
      () => MateriSelectedController(),
    );
  }
}
