import 'package:get/get.dart';

import '../controllers/material_detail_controller.dart';

class MaterialDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MaterialDetailController>(
      () => MaterialDetailController(),
    );
  }
}
