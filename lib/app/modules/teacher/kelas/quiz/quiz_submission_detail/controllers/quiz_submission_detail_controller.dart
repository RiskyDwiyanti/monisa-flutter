import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:monisa/app/data/services/teacher/teacher_quiz_service.dart';

class QuizOptionResult {
  final int id;
  final String text;
  final String? image;
  final bool isCorrect;
  final bool selected;

  QuizOptionResult({
    required this.id,
    required this.text,
    this.image,
    required this.isCorrect,
    required this.selected,
  });

  factory QuizOptionResult.fromJson(Map<String, dynamic> json) => QuizOptionResult(
        id: json['id'] as int,
        text: (json['option'] ?? '').toString(),
        image: json['image'] as String?,
        isCorrect: json['is_correct'] == true,
        selected: json['selected'] == true,
      );
}

class QuizQuestionResult {
  final int id;
  final String question;
  final String type; // multiple_choice | multiple_choice_complex | essay
  final String? image;
  final num score;
  final num maxScore;
  final String? essayAnswer;
  final List<QuizOptionResult> options;

  QuizQuestionResult({
    required this.id,
    required this.question,
    required this.type,
    this.image,
    required this.score,
    required this.maxScore,
    this.essayAnswer,
    this.options = const [],
  });

  factory QuizQuestionResult.fromJson(Map<String, dynamic> json) => QuizQuestionResult(
        id: json['id'] as int,
        question: (json['question'] ?? '').toString(),
        type: (json['type'] ?? '').toString(),
        image: json['image'] as String?,
        score: json['score'] as num? ?? 0,
        maxScore: json['max_score'] as num? ?? 0,
        essayAnswer: json['essay_answer'] as String?,
        options: (json['options'] as List? ?? [])
            .map((e) => QuizOptionResult.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

String _fmtPoint(num n) => n % 1 == 0 ? n.toInt().toString() : n.toStringAsFixed(1);

class QuizSubmissionDetailController extends GetxController {
  final _service = TeacherQuizService();

  late final int classId;
  late final int quizId;
  late final int attemptId;

  final isLoading = false.obs;
  final errorMessage = RxnString();

  final quizTitle = ''.obs;
  final studentName = ''.obs;
  final submittedAt = Rxn<DateTime>();
  final score = Rxn<num>();
  final maxScore = 100.obs;
  final questions = <QuizQuestionResult>[].obs;
  final currentIndex = 0.obs;

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    classId = args['classId'] as int? ?? 0;
    quizId = args['quizId'] as int? ?? 0;
    attemptId = args['attemptId'] as int? ?? 0;
    fetchDetail();
  }

  Future<void> fetchDetail() async {
    isLoading.value = true;
    errorMessage.value = null;

    final result = await _service.getQuizAttemptDetail(
      classId: classId,
      quizId: quizId,
      attemptId: attemptId,
    );

    if (result['success'] == true) {
      try {
        final data = result['data'] as Map<String, dynamic>;
        final quiz = data['quiz'] as Map<String, dynamic>? ?? {};
        final student = data['student'] as Map<String, dynamic>? ?? {};

        quizTitle.value = (quiz['title'] ?? '-').toString();
        maxScore.value = (quiz['max_score'] as num?)?.toInt() ?? 100;
        studentName.value = (student['name'] ?? '-').toString();
        submittedAt.value = data['submitted_at'] != null
            ? DateTime.tryParse(data['submitted_at'].toString())
            : null;
        score.value = data['score'] as num?;

        questions.assignAll((data['questions'] as List? ?? [])
            .map((e) => QuizQuestionResult.fromJson(e as Map<String, dynamic>))
            .toList());
        currentIndex.value = 0;
      } catch (e) {
        errorMessage.value = 'Format data pengerjaan tidak sesuai.';
      }
    } else {
      errorMessage.value = result['message']?.toString();
    }

    isLoading.value = false;
  }

  QuizQuestionResult? get currentQuestion =>
      questions.isEmpty ? null : questions[currentIndex.value];

  bool get hasPrev => currentIndex.value > 0;
  bool get hasNext => currentIndex.value < questions.length - 1;

  void prev() { if (hasPrev) currentIndex.value--; }
  void next() { if (hasNext) currentIndex.value++; }
  void goTo(int i) => currentIndex.value = i;

  String get submittedDateLabel {
    final d = submittedAt.value;
    if (d == null) return '-';
    return DateFormat('d MMMM yyyy', 'id_ID').format(d);
  }

  String pointLabel(QuizQuestionResult q) =>
      '${_fmtPoint(q.score)}/${_fmtPoint(q.maxScore)} poin';

  // TODO: tinjau ulang skor (sengaja dilewati dulu)
  void onReviewScoreTap() {}

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
