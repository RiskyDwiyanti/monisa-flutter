import 'package:get/get.dart';

import '../controllers/quiz_submission_detail_controller.dart';

class QuizSubmissionDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QuizSubmissionDetailController>(
      () => QuizSubmissionDetailController(),
    );
  }
}
