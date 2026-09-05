import 'package:get/get.dart';

import '../controllers/home_parent_controller.dart';

class HomeParentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeParentController>(
      () => HomeParentController(),
    );
  }
}
