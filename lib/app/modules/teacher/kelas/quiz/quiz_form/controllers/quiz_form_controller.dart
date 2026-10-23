import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'package:monisa/app/modules/teacher/kelas/content_draft/controllers/teacher_student_picker_controller.dart'
    show StudentOption;
import 'package:monisa/app/modules/teacher/kelas/content_draft/controllers/teacher_topic_picker_controller.dart'
    show TopicOption;
import 'package:monisa/app/data/services/teacher/teacher_quiz_service.dart';
import 'package:monisa/app/modules/teacher/kelas/content_draft/views/widget/teacher_student_picker_dialog.dart';
import 'package:monisa/app/modules/teacher/kelas/content_draft/views/widget/teacher_topic_picker_dialog.dart';
import 'package:monisa/app/modules/teacher/kelas/tugas/assignment_form/controllers/assignment_form_controller.dart'
    show AssignTarget, AssignTargetX;
import 'package:monisa/app/routes/app_pages.dart';

// ===== MODEL =====
enum QuestionType { pilihanGanda, pilihanGandaJamak, uraian }

extension QuestionTypeX on QuestionType {
  String get label {
    switch (this) {
      case QuestionType.pilihanGanda:
        return 'Pilihan ganda';
      case QuestionType.pilihanGandaJamak:
        return 'Pilihan ganda (jawaban jamak)';
      case QuestionType.uraian:
        return 'Uraian';
    }
  }

  String get shortLabel {
    switch (this) {
      case QuestionType.pilihanGanda:
        return 'PG';
      case QuestionType.pilihanGandaJamak:
        return 'PG-J';
      case QuestionType.uraian:
        return 'Uraian';
    }
  }

  String get apiValue {
    switch (this) {
      case QuestionType.pilihanGanda:
        return 'multiple_choice';
      case QuestionType.pilihanGandaJamak:
        return 'multiple_choice_complex';
      case QuestionType.uraian:
        return 'essay';
    }
  }

  bool get hasOptions => this != QuestionType.uraian;
  bool get isSingleAnswer => this == QuestionType.pilihanGanda;

  static QuestionType fromApiValue(String value) {
    switch (value) {
      case 'multiple_choice_complex':
        return QuestionType.pilihanGandaJamak;
      case 'essay':
        return QuestionType.uraian;
      case 'multiple_choice':
      default:
        return QuestionType.pilihanGanda;
    }
  }
}

class QuizOptionDraft {
  int? id;
  final optionC = TextEditingController();
  final image = Rxn<PlatformFile>();
  final existingImageUrl = RxnString();
  final removeImage = false.obs;
  final isCorrect = false.obs;

  void dispose() {
    optionC.dispose();
  }
}

class QuizQuestionDraft {
  final int? id;
  final String questionText;
  final QuestionType type;
  final PlatformFile? image;
  final String? existingImageUrl;
  final bool removeImage;
  final List<QuizOptionDraft> options;

  QuizQuestionDraft({
    this.id,
    required this.questionText,
    required this.type,
    this.image,
    this.existingImageUrl,
    this.removeImage = false,
    required this.options,
  });

  // Ringkasan singkat untuk ditampilkan di "Daftar pertanyaan"
  String get preview => questionText.length > 60
      ? '${questionText.substring(0, 60)}...'
      : questionText;
}

class QuizFormController extends GetxController {
  final _service = TeacherQuizService();

  late final int classId;
  int? quizId;

  // ===== Field untuk dialog "Unggah kuis" =====
  final judulC = TextEditingController();
  final deskripsiC = TextEditingController();
  final deadline = Rxn<DateTime>();
  final assignTarget = Rxn<AssignTarget>();
  final selectedStudents = <StudentOption>[].obs;
  final selectedTopic = Rxn<TopicOption>();

  // Soal-soal yang sudah ditambahkan (menunggu di-submit bersamaan)
  final questions = <QuizQuestionDraft>[].obs;
  // int? _editingIndex; // index soal yang sedang diedit, null = soal baru
  final editingQuestionIndex = Rxn<int>();

  // ===== Form pertanyaan yang sedang diisi =====
  final pertanyaanC = TextEditingController();
  final questionImage = Rxn<PlatformFile>();
  final questionExistingImageUrl = RxnString();
  final questionRemoveImage = false.obs;
  final selectedType = QuestionType.pilihanGanda.obs;
  final options = <QuizOptionDraft>[].obs;

  // ===== Pengecekan Gambar =====
  static const int _maxImageSizeBytes =
      2 * 1024 * 1024; // 2MB, sesuai Laravel max:2048

  bool _isImageSizeValid(PlatformFile file) {
    if (file.size > _maxImageSizeBytes) {
      Get.snackbar('Gambar terlalu besar', 'Ukuran gambar maksimal 2MB.');
      return false;
    }
    return true;
  }

  // ===== Search di dialog "Daftar soal" =====
  final questionSearchQuery = ''.obs;

  final isLoadingDetail = false.obs;
  final isSubmittingDraft = false.obs;
  final isSubmittingPublish = false.obs;
  final isDeleting = false.obs;

  bool _exitHandled = false;
  bool get exitHandled => _exitHandled;
  bool get isEditMode => quizId != null;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments as Map<String, dynamic>? ?? {};
    classId = args['classId'] as int? ?? 0;
    quizId = args['quizId'] as int?;

    _resetOptionsForType(selectedType.value);

    // debugPrint('QUIZ FORM onInit -> classId=$classId quizId=$quizId args=$args');

    if (isEditMode) {
      _loadQuizDetail();
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    judulC.dispose();
    deskripsiC.dispose();
    pertanyaanC.dispose();
    for (final o in options) {
      o.dispose();
    }
    super.onClose();
  }

  // ===== Load data kuis existing (mode edit) =====
  Future<void> _loadQuizDetail() async {
    isLoadingDetail.value = true;

    final result = await _service.getQuizDetail(
      classId: classId,
      quizId: quizId!,
    );

    if (result['success'] == true) {
      try {
        final data = result['data'] as Map<String, dynamic>;

        judulC.text = (data['title'] ?? '').toString();
        deskripsiC.text = (data['description'] ?? '').toString();

        if (data['deadline'] != null) {
          deadline.value = DateTime.tryParse(data['deadline'].toString());
        }

        final assignTo = data['assign_to'] as String?;
        if (assignTo == 'selected') {
          assignTarget.value = AssignTarget.pilihSiswa;
        } else if (assignTo == 'all') {
          assignTarget.value = AssignTarget.semua;
        } else {
          assignTarget.value = null; // backend: assign_to masih null
        }

        final topic = data['topic'] as Map<String, dynamic>?;
        if (topic != null) {
          selectedTopic.value = TopicOption(
            id: topic['id'] as int,
            name: (topic['name'] ?? '-').toString(),
          );
        }

        final students = (data['students'] as List? ?? []);
        selectedStudents.assignAll(
          students.map((e) {
            final m = e as Map<String, dynamic>;
            return StudentOption(
              id: m['id'] as int,
              name: (m['name'] ?? '-').toString(),
            );
          }),
        );

        final qList = (data['questions'] as List? ?? []);
        questions.assignAll(
          qList.map((e) => _questionDraftFromJson(e as Map<String, dynamic>)),
        );
      } catch (e) {
        Get.snackbar('Gagal', 'Format data kuis tidak sesuai.');
        debugPrint('Parse quiz detail error: $e');
      }
    } else {
      Get.snackbar(
        'Gagal',
        result['message']?.toString() ?? 'Gagal memuat detail kuis.',
      );
    }

    isLoadingDetail.value = false;
  }

  QuizQuestionDraft _questionDraftFromJson(Map<String, dynamic> json) {
    final type = QuestionTypeX.fromApiValue(json['type'] as String);
    final optList = (json['options'] as List? ?? []);

    return QuizQuestionDraft(
      id: json['id'] as int?,
      questionText: (json['question'] ?? '').toString(),
      type: type,
      existingImageUrl: json['image'] as String?,
      options: optList.map((o) {
        final om = o as Map<String, dynamic>;
        return QuizOptionDraft()
          ..id = om['id'] as int?
          ..optionC.text = (om['option'] ?? '').toString()
          ..existingImageUrl.value = om['image'] as String?
          ..isCorrect.value = om['is_correct'] == true;
      }).toList(),
    );
  }

  void _goToClassPage() {
    Get.until((route) => route.settings.name == Routes.TEACHER_KELAS_SELECTED);
  }

  // ===== Topik, tenggat, tugaskan untuk (dipakai dialog "Unggah kuis") =====
  Future<void> onPickTopic(BuildContext context) async {
    final result = await openTeacherTopicPickerDialog(
      context,
      classId: classId,
      selectedTopicId: selectedTopic.value?.id,
    );
    if (result != null) selectedTopic.value = result;
  }

  Future<void> pickDeadline(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: deadline.value ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
    );
    if (picked != null) deadline.value = picked;
  }

  Future<void> onAssignTargetChanged(
    AssignTarget? value,
    BuildContext context,
  ) async {
    if (value == null) return;

    if (value == AssignTarget.pilihSiswa) {
      final result = await openTeacherStudentPickerDialog(
        context,
        classId: classId,
        initialSelectedIds: selectedStudents.map((e) => e.id).toList(),
      );
      if (result != null) {
        selectedStudents.assignAll(result);
        assignTarget.value = AssignTarget.pilihSiswa;
      }
      return;
    }

    selectedStudents.clear();
    assignTarget.value = value;
  }

  void onTypeChanged(QuestionType? value) {
    if (value == null) return;
    selectedType.value = value;
    _resetOptionsForType(value);
  }

  void _resetOptionsForType(QuestionType type) {
    for (final o in options) {
      o.dispose();
    }
    options.clear();

    if (type.hasOptions) {
      // Default 4 opsi kosong, sesuai contoh desain
      options.addAll(List.generate(4, (_) => QuizOptionDraft()));
    }
  }

  void addOption() {
    options.add(QuizOptionDraft());
  }

  void removeOption(QuizOptionDraft option) {
    if (options.length <= 2) {
      Get.snackbar('Tidak bisa dihapus', 'Minimal 2 opsi jawaban.');
      return;
    }
    option.dispose();
    options.remove(option);
  }

  void onPickCorrect(QuizOptionDraft tapped) {
    if (selectedType.value.isSingleAnswer) {
      // Pilihan ganda biasa -> hanya satu yang benar (radio button)
      for (final o in options) {
        o.isCorrect.value = identical(o, tapped);
      }
    } else {
      // Pilihan ganda jamak -> checkbox, bisa lebih dari satu
      tapped.isCorrect.value = !tapped.isCorrect.value;
    }
  }

  Future<void> pickQuestionImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );
    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;
      if (!_isImageSizeValid(file)) return;

      questionImage.value = file;
      questionRemoveImage.value = false;
    }
  }

  void removeQuestionImage() {
    questionImage.value = null;
    questionExistingImageUrl.value = null;
    questionRemoveImage.value = true;
  }

  Future<void> pickOptionImage(QuizOptionDraft option) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );
    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;
      if (!_isImageSizeValid(file)) return;

      option.image.value = file;
      option.removeImage.value = false;
    }
  }

  void removeOptionImage(QuizOptionDraft option) {
    option.image.value = null;
    option.existingImageUrl.value = null;
    option.removeImage.value = true;
  }

  String? _validateCurrentQuestion() {
    if (pertanyaanC.text.trim().isEmpty) {
      return 'Pertanyaan wajib diisi.';
    }

    if (selectedType.value.hasOptions) {
      if (options.length < 2) return 'Minimal 2 opsi jawaban.';
      for (final o in options) {
        if (o.optionC.text.trim().isEmpty) {
          return 'Semua opsi jawaban wajib diisi.';
        }
      }

      final correctCount = options.where((o) => o.isCorrect.value).length;

      if (selectedType.value == QuestionType.pilihanGanda &&
          correctCount != 1) {
        return 'Pilih tepat satu jawaban benar.';
      }
      if (selectedType.value == QuestionType.pilihanGandaJamak &&
          correctCount < 1) {
        return 'Pilih minimal satu jawaban benar.';
      }
    }

    return null;
  }

  /// Tap item di "Daftar soal" -> muat soal itu ke form aktif untuk diedit.
  void openQuestionForEditing(int index) {
    final q = questions[index];

    pertanyaanC.text = q.questionText;
    questionImage.value = null;
    questionExistingImageUrl.value = q.existingImageUrl;
    questionRemoveImage.value = false;
    selectedType.value = q.type;

    for (final o in options) {
      o.dispose();
    }
    options.clear();
    for (final o in q.options) {
      options.add(
        QuizOptionDraft()
          ..id = o.id
          ..optionC.text = o.optionC.text
          ..existingImageUrl.value = o.existingImageUrl.value
          ..isCorrect.value = o.isCorrect.value,
      );
    }

    editingQuestionIndex.value = index;
  }

  /// Tombol "Tambah pertanyaan": validasi soal saat ini, masukkan ke list, lalu reset form untuk soal berikutnya.
  void addQuestion() {
    final error = _validateCurrentQuestion();
    if (error != null) {
      Get.snackbar('Lengkapi data', error);
      return;
    }

    final editIdx = editingQuestionIndex.value;

    final newDraft = QuizQuestionDraft(
      id: editIdx != null ? questions[editIdx].id : null,
      questionText: pertanyaanC.text.trim(),
      type: selectedType.value,
      image: questionImage.value,
      existingImageUrl: questionRemoveImage.value
          ? null
          : questionExistingImageUrl.value,
      removeImage: questionRemoveImage.value,
      options: options
          .map(
            (o) => QuizOptionDraft()
              ..id = o.id
              ..optionC.text = o.optionC.text
              ..image.value = o.image.value
              ..existingImageUrl.value = o.removeImage.value
                  ? null
                  : o.existingImageUrl.value
              ..removeImage.value = o.removeImage.value
              ..isCorrect.value = o.isCorrect.value,
          )
          .toList(),
    );

    if (editIdx != null) {
      questions[editIdx] = newDraft;
    } else {
      questions.add(newDraft);
    }

    editingQuestionIndex.value = null;
    _resetQuestionForm();

    Get.snackbar('Tersimpan', 'Pertanyaan ditambahkan ke kuis.');
  }

  void removeCurrentlyEditingQuestion() {
    final idx = editingQuestionIndex.value;
    if (idx == null) return;
    questions.removeAt(idx);
    editingQuestionIndex.value = null;
    _resetQuestionForm();
  }

  void _resetQuestionForm() {
    pertanyaanC.clear();
    questionImage.value = null;
    questionExistingImageUrl.value = null;
    questionRemoveImage.value = false;
    selectedType.value = QuestionType.pilihanGanda;
    _resetOptionsForType(QuestionType.pilihanGanda);
  }

  // ===== Search "Daftar soal" =====
  void onQuestionSearchChanged(String value) =>
      questionSearchQuery.value = value;

  List<int> get filteredQuestionIndexes {
    if (questionSearchQuery.value.trim().isEmpty) {
      return List.generate(questions.length, (i) => i);
    }
    final q = questionSearchQuery.value.trim().toLowerCase();
    final result = <int>[];
    for (var i = 0; i < questions.length; i++) {
      if (questions[i].questionText.toLowerCase().contains(q)) {
        result.add(i);
      }
    }
    return result;
  }

  // ===== Payload & persist =====
  List<Map<String, dynamic>> _questionsPayload() {
    return questions
        .map(
          (q) => {
            if (q.id != null) 'id': q.id,
            'question': q.questionText,
            'type': q.type.apiValue,
            'image': q.image,
            'remove_image': q.removeImage,
            'options': q.options
                .map(
                  (o) => {
                    if (o.id != null) 'id': o.id,
                    'option': o.optionC.text,
                    'image': o.image.value,
                    'remove_image': o.removeImage.value,
                    'is_correct': o.isCorrect.value,
                  },
                )
                .toList(),
          },
        )
        .toList();
  }

  Future<bool> _persistDraft() async {
    // Kalau masih ada soal yang sedang diisi tapi belum ditekan
    // "Tambah pertanyaan", coba masukkan dulu kalau sudah valid.
    if (pertanyaanC.text.trim().isNotEmpty) {
      final error = _validateCurrentQuestion();
      if (error == null) addQuestion();
    }

    final payload = _questionsPayload();

    final result = isEditMode
        ? await _service.updateQuiz(
            classId: classId,
            quizId: quizId!,
            topicId: selectedTopic.value?.id,
            title: judulC.text.trim().isEmpty ? null : judulC.text.trim(),
            description: deskripsiC.text.trim().isEmpty
                ? null
                : deskripsiC.text.trim(),
            deadline: deadline.value,
            assignTo: assignTarget.value?.apiValue,
            studentIds: selectedStudents.map((e) => e.id).toList(),
            questions: payload,
          )
        : await _service.createQuiz(
            classId: classId,
            topicId: selectedTopic.value?.id,
            title: judulC.text.trim().isEmpty ? null : judulC.text.trim(),
            description: deskripsiC.text.trim().isEmpty
                ? null
                : deskripsiC.text.trim(),
            deadline: deadline.value,
            assignTo: assignTarget.value?.apiValue,
            studentIds: selectedStudents.map((e) => e.id).toList(),
            questions: payload,
          );

    if (result['success'] == true) {
      if (!isEditMode) {
        final data = result['data'] as Map<String, dynamic>?;
        quizId = data?['id'] as int?; // submit berikutnya pakai update
      }
      return true;
    }

    Get.snackbar(
      'Gagal',
      result['message']?.toString() ?? 'Terjadi kesalahan.',
    );
    return false;
  }

  /// Dipanggil dari dialog "Unggah kuis" -> simpan lalu publish.
  Future<void> publishQuiz() async {
    if (judulC.text.trim().isEmpty) {
      Get.snackbar('Lengkapi data', 'Judul kuis wajib diisi.');
      return;
    }
    if (deskripsiC.text.trim().isEmpty) {
      Get.snackbar('Lengkapi data', 'Deskripsi kuis wajib diisi.');
      return;
    }
    if (deadline.value == null) {
      Get.snackbar('Lengkapi data', 'Tenggat wajib diisi.');
      return;
    }
    if (assignTarget.value == null) {
      Get.snackbar('Lengkapi data', 'Pilih tujuan penugasan.');
      return;
    }
    if (assignTarget.value == AssignTarget.pilihSiswa &&
        selectedStudents.isEmpty) {
      Get.snackbar('Lengkapi data', 'Pilih minimal satu siswa.');
      return;
    }
    if (questions.isEmpty && pertanyaanC.text.trim().isEmpty) {
      Get.snackbar('Lengkapi data', 'Tambahkan minimal satu pertanyaan.');
      return;
    }

    isSubmittingPublish.value = true;

    final saved = await _persistDraft();
    if (!saved) {
      isSubmittingPublish.value = false;
      return;
    }

    final result = await _service.publishQuiz(
      classId: classId,
      quizId: quizId!,
    );

    isSubmittingPublish.value = false;

    if (result['success'] == true) {
      _exitHandled = true;
      Get.back(); // tutup dialog "Unggah kuis"
      Get.back(result: true); // tutup halaman form, kembali ke kelas_selected
      Get.snackbar(
        'Berhasil',
        result['message']?.toString() ?? 'Kuis dipublikasikan.',
      );
    } else {
      Get.snackbar(
        'Gagal',
        result['message']?.toString() ?? 'Terjadi kesalahan.',
      );
    }
  }

  // ===== Keluar halaman: discard / hapus / simpan draft =====
  void discardAndExit() {
    _exitHandled = true;
    Get.back();
  }

  Future<void> deleteAndExit() async {
    _exitHandled = true;

    if (isEditMode) {
      isDeleting.value = true;
      final result = await _service.deleteQuiz(
        classId: classId,
        quizId: quizId!,
      );
      isDeleting.value = false;

      if (result['success'] != true) {
        Get.snackbar(
          'Gagal',
          result['message']?.toString() ?? 'Gagal menghapus kuis.',
        );
        _exitHandled = false;
        return;
      }
    }

    Get.back();
  }

  Future<void> saveDraftAndExit() async {
    _exitHandled = true;
    isSubmittingDraft.value = true;

    final saved = await _persistDraft();

    isSubmittingDraft.value = false;

    if (saved) {
      _goToClassPage();
      Get.snackbar('Tersimpan', 'Kuis disimpan sebagai draf.');
    } else {
      _exitHandled = false;
    }
  }
}
