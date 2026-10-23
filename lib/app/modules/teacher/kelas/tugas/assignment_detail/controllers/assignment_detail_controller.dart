import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:monisa/app/data/services/teacher/teacher_assignment_service.dart';
import 'package:monisa/app/modules/teacher/kelas/content_draft/controllers/teacher_content_draft_controller.dart' show MaterialFileRef, TeacherContentDraft;
import 'package:monisa/app/routes/app_pages.dart';

// ===== MODEL =====
class SubmissionItem {
  final int id;
  final int studentId;
  final String studentName;
  final DateTime? submittedAt;
  final String status; // 'submitted' | 'graded' | dst.
  final num? score;
  final String? feedback;
  final List<MaterialFileRef> files;

  SubmissionItem({
    required this.id,
    required this.studentId,
    required this.studentName,
    this.submittedAt,
    required this.status,
    this.score,
    this.feedback,
    this.files = const [],
  });

  factory SubmissionItem.fromJson(Map<String, dynamic> json) {
    return SubmissionItem(
      id: json['id'] as int,
      studentId: json['student_id'] as int,
      studentName: (json['student_name'] ?? '-').toString(),
      submittedAt: json['submitted_at'] != null
          ? DateTime.tryParse(json['submitted_at'].toString())
          : null,
      status: (json['status'] ?? '-').toString(),
      score: json['score'] as num?,
      feedback: json['feedback'] as String?,
      files: (json['files'] as List? ?? [])
          .map((e) => MaterialFileRef.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  String get submittedDateLabel {
    if (submittedAt == null) return '-';
    return DateFormat('d MMMM yyyy', 'id_ID').format(submittedAt!);
  }
}

class AssignmentDetailController extends GetxController {
  final _service = TeacherAssignmentService();

  late final int classId;
  late final int assignmentId;

  final assignment = Rxn<TeacherContentDraft>();
  final submissions = <SubmissionItem>[].obs;

  final isLoading = false.obs;
  final errorMessage = RxnString();
  final isDeleting = false.obs;

  // Tab: 0 = Selesai, 1 = Belum terkumpul
  final selectedTab = 0.obs;
  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments as Map<String, dynamic>? ?? {};
    classId = args['classId'] as int? ?? 0;
    assignmentId = args['assignmentId'] as int? ?? 0;

    fetchDetail();
  }

  Future<void> fetchDetail() async {
    isLoading.value = true;
    errorMessage.value = null;

    final detailResult = await _service.getAssignmentDetail(
      classId: classId,
      assignmentId: assignmentId,
    );
    final submissionsResult = await _service.getSubmissions(
      classId: classId,
      assignmentId: assignmentId,
    );

    if (detailResult['success'] == true) {
      try {
        assignment.value = TeacherContentDraft.fromJson(
            detailResult['data'] as Map<String, dynamic>);
      } catch (e) {
        errorMessage.value = 'Format data tugas tidak sesuai.';
      }
    } else {
      errorMessage.value = detailResult['message']?.toString();
    }

    if (submissionsResult['success'] == true) {
      try {
        final data = submissionsResult['data'] as Map<String, dynamic>;
        final list = (data['submissions'] as List? ?? [])
            .map((e) => SubmissionItem.fromJson(e as Map<String, dynamic>))
            .toList();
        submissions.assignAll(list);
      } catch (e) {
        // tidak menimpa errorMessage utama kalau detail sudah berhasil
      }
    }

    isLoading.value = false;
  }

  /// Siswa yang sudah mengumpulkan (punya submission)
  List<SubmissionItem> get completedSubmissions => submissions;

  /// Siswa yang ditugaskan tapi belum punya submission sama sekali
  List<_UnsubmittedStudent> get notSubmittedStudents {
    final a = assignment.value;
    if (a == null) return [];

    final submittedIds = submissions.map((s) => s.studentId).toSet();

    return a.students
        .where((s) => !submittedIds.contains(s.id))
        .map((s) => _UnsubmittedStudent(id: s.id, name: s.name))
        .toList();
  }

  void onTabChanged(int index) {
    selectedTab.value = index;
  }

  void onSubmissionTap(SubmissionItem submission) {
    // Get.toNamed(Routes.ASSIGNMENT_SUBMISSION_DETAIL, arguments: {
    //   'assignmentTitle': assignment.value?.title ?? '-',
    //   'maxScore': assignment.value?.maxScore ?? 100,
    //   'submission': submission,
    // });
  }

  Future<void> onEditTap() async {
    final a = assignment.value;
    if (a == null) return;

    final result = await Get.toNamed(Routes.ASSIGNMENT_FORM, arguments: {
      'classId': classId,
      'assignmentId': a.id,
      'title': a.title,
      'description': a.description,
      'topicId': a.topicId,
      'topicName': a.topicName,
      'files': a.files,
      'deadline': a.deadline,
      'assignTo': a.assignTo,
      'students': a.students,
      'maxScore': a.maxScore,
    });

    if (result == true) {
      fetchDetail();
    }
  }

  Future<void> deleteAssignment() async {
    isDeleting.value = true;

    final result = await _service.deleteAssignment(
      classId: classId,
      assignmentId: assignmentId,
    );

    isDeleting.value = false;

    if (result['success'] == true) {
      Get.back(result: true);
      Get.snackbar('Berhasil', result['message']?.toString() ?? 'Tugas dihapus.');
    } else {
      Get.snackbar(
          'Gagal', result['message']?.toString() ?? 'Gagal menghapus tugas.');
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

}

class _UnsubmittedStudent {
  final int id;
  final String name;

  _UnsubmittedStudent({required this.id, required this.name});
}