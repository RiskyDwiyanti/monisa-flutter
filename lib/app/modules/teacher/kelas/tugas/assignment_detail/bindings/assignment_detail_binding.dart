import 'package:get/get.dart';

import '../controllers/assignment_detail_controller.dart';

class AssignmentDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AssignmentDetailController>(
      () => AssignmentDetailController(),
    );
  }
}
