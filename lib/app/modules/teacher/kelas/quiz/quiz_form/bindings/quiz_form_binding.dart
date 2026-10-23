import 'package:get/get.dart';

import '../controllers/quiz_form_controller.dart';

class QuizFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QuizFormController>(
      () => QuizFormController(),
    );
  }
}
