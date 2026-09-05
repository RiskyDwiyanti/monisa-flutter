import 'package:get/get.dart';

import '../controllers/profile_parent_controller.dart';

class ProfileParentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileParentController>(
      () => ProfileParentController(),
    );
  }
}
