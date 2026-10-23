import 'package:get/get.dart';

import '../controllers/assignment_submission_detail_controller.dart';

class AssignmentSubmissionDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AssignmentSubmissionDetailController>(
      () => AssignmentSubmissionDetailController(),
    );
  }
}
