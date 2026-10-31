import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:monisa/app/data/services/teacher/teacher_assignment_service.dart';
import 'package:monisa/app/data/services/teacher/teacher_quiz_service.dart';
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
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      studentId: int.tryParse(json['student_id']?.toString() ?? '') ?? 0,
      studentName: (json['student_name'] ?? '-').toString(),
      submittedAt: json['submitted_at'] != null
          ? DateTime.tryParse(json['submitted_at'].toString())
          : null,
      status: (json['status'] ?? '-').toString(),
      score: num.tryParse(json['score']?.toString() ?? ''),
      feedback: json['feedback']?.toString(),
      files: (json['files'] as List? ?? [])
          .whereType<Map>()
          .map((e) => MaterialFileRef.fromJson(
                Map<String, dynamic>.from(e),
              ))
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
  final _quizService = TeacherQuizService();

  final quizDetail = Rxn<Map<String, dynamic>>();

  late final int classId;
  late final int assignmentId;

  final assignment = Rxn<TeacherContentDraft>();
  final submissions = <SubmissionItem>[].obs;

  final isLoading = false.obs;
  final errorMessage = RxnString();
  final isDeleting = false.obs;
  late final String type;

  // Tab: 0 = Selesai, 1 = Belum terkumpul
  final selectedTab = 0.obs;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments as Map<String, dynamic>? ?? {};
    classId = args['classId'] as int? ?? 0;
    assignmentId = args['assignmentId'] as int? ?? 0;
    type = args['type'] as String? ?? 'assignment';
    fetchDetail();
  }

  Future<void> fetchDetail() async {
    isLoading.value = true;
    errorMessage.value = null;

    try {
      if (type == 'quizzes') {
        // Ambil detail kuis
        final detailResult = await _quizService.getQuizDetail(
          classId: classId,
          quizId: assignmentId,
        );

        if (detailResult['success'] == true) {
          final data = detailResult['data'];

          if (data is Map<String, dynamic>) {
            quizDetail.value = data;
          } else if (data is Map) {
            quizDetail.value = Map<String, dynamic>.from(data);
          } else {
            errorMessage.value = 'Format detail kuis tidak sesuai.';
          }
        } else {
          errorMessage.value = detailResult['message']?.toString() ?? 'Gagal memuat detail kuis.';
        }

        // Ambil daftar pengerjaan kuis
        final submissionsResult = await _quizService.getQuizAttempts(
          classId: classId,
          quizId: assignmentId,
        );

        if (submissionsResult['success'] == true) {
          final data = submissionsResult['data'];

          if (data is Map) {
            final rawSubmissions = data['submissions'];

            if (rawSubmissions is List) {
              final list = rawSubmissions
                  .whereType<Map>()
                  .map(
                    (item) => SubmissionItem.fromJson(
                      Map<String, dynamic>.from(item),
                    ),
                  )
                  .toList();

              submissions.assignAll(list);
            }
          }
        }
      } else {
        // Alur tugas biasa tetap seperti sebelumnya
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
              Map<String, dynamic>.from(detailResult['data'] as Map),
            );
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
                .map(
                  (e) => SubmissionItem.fromJson(
                    Map<String, dynamic>.from(e as Map),
                  ),
                )
                .toList();

            submissions.assignAll(list);
          } catch (e) {
            // Pertahankan perilaku sebelumnya jika format daftar tidak sesuai.
          }
        }
      }
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan saat memuat data.';
    } finally {
      isLoading.value = false;
    }
  }

  /// Siswa yang sudah mengumpulkan (punya submission)
  List<SubmissionItem> get completedSubmissions => submissions;

  /// Siswa yang ditugaskan tapi belum punya submission sama sekali
  List<_UnsubmittedStudent> get notSubmittedStudents {
    final submittedIds = submissions.map((s) => s.studentId).toSet();

    if (type == 'quizzes') {
      final quiz = quizDetail.value;
      if (quiz == null) return [];

      final students = quiz['students'] as List? ?? [];

      return students
          .whereType<Map>()
          .map((student) => Map<String, dynamic>.from(student))
          .where((student) {
            final id = int.tryParse(student['id']?.toString() ?? '');
            return id != null && !submittedIds.contains(id);
          })
          .map((student) => _UnsubmittedStudent(
                id: int.parse(student['id'].toString()),
                name: student['name']?.toString() ?? '-',
              ))
          .toList();
    }

    // Alur tugas biasa tetap seperti sebelumnya.
    final a = assignment.value;
    if (a == null) return [];

    return a.students
        .where((s) => !submittedIds.contains(s.id))
        .map((s) => _UnsubmittedStudent(id: s.id, name: s.name))
        .toList();
  }

  void onTabChanged(int index) {
    selectedTab.value = index;
  }

  void onSubmissionTap(SubmissionItem submission) {
    if (type == 'quizzes') {
      Get.toNamed(Routes.QUIZ_SUBMISSION_DETAIL, arguments: {
        'classId': classId,
        'quizId': assignmentId,
        'attemptId': submission.id,
      });
      return;
    }

    Get.toNamed(Routes.ASSIGNMENT_SUBMISSION_DETAIL, arguments: {
      'assignmentTitle': assignment.value?.title ?? '-',
      'maxScore': assignment.value?.maxScore ?? 100,
      'submission': submission,
    });
  }

  Future<void> onEditTap() async {
    if (type == 'quizzes') {
      await _editQuiz();
      return;
    }

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

  Future<void> _editQuiz() async {
    final quiz = quizDetail.value;
    if (quiz == null) return;

    // API menolak edit (422) kalau sudah ada siswa yang mengerjakan,
    // jadi dicegah dari sisi UI supaya guru tidak mengisi form dengan sia-sia.
    if (submissions.isNotEmpty) {
      Get.snackbar(
        'Tidak bisa diedit',
        'Kuis tidak dapat diubah karena sudah ada siswa yang mengerjakan.',
      );
      return;
    }

    final result = await Get.toNamed(Routes.QUIZ_FORM, arguments: {
      'classId': classId,
      'quizId': assignmentId,
      'quiz': quiz, // data detail lengkap (soal, opsi, siswa) untuk mengisi form
    });

    if (result == true) {
      fetchDetail();
    }
  }

  // Delete assignment
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

  // Delete quiz
  Future<void> deleteQuiz() async {
    isDeleting.value = true;

    final result = await _quizService.deleteQuiz(
      classId: classId,
      quizId: assignmentId,
    );

    isDeleting.value = false;

    if (result['success'] == true) {
      Get.back(result: true);
      Get.snackbar(
        'Berhasil',
        result['message']?.toString() ?? 'Kuis dihapus.',
      );
    } else {
      Get.snackbar(
        'Gagal',
        result['message']?.toString() ?? 'Gagal menghapus kuis.',
      );
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