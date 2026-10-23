import 'package:get/get.dart';

import '../controllers/material_form_controller.dart';

class MaterialFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MaterialFormController>(
      () => MaterialFormController(),
    );
  }
}
