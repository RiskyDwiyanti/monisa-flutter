import 'package:get/get.dart';

import '../controllers/class_parent_controller.dart';

class ClassParentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClassParentController>(
      () => ClassParentController(),
    );
  }
}
