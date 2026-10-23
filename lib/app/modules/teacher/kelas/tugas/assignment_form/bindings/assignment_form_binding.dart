import 'package:get/get.dart';

import '../controllers/assignment_form_controller.dart';

class AssignmentFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AssignmentFormController>(
      () => AssignmentFormController(),
    );
  }
}
