import 'package:get/get.dart';
import 'package:monisa/app/modules/teacher/kelas/tugas/assignment_detail/controllers/assignment_detail_controller.dart';

class AssignmentSubmissionDetailController extends GetxController {
  late final String assignmentTitle;
  late final int maxScore;
  late final SubmissionItem submission;

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments as Map<String, dynamic>? ?? {};
    assignmentTitle = (args['assignmentTitle'] ?? '-').toString();
    maxScore = args['maxScore'] as int? ?? 100;
    submission = args['submission'] as SubmissionItem;
  }

  void onGradeTap() {
    // TODO: fitur nilai tugas menyusul
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
