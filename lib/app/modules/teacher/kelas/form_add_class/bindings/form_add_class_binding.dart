import 'package:get/get.dart';

import '../controllers/form_add_class_controller.dart';

class FormAddClassBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FormAddClassController>(
      () => FormAddClassController(),
    );
  }
}
