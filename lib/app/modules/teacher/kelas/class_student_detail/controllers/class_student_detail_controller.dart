import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:monisa/app/data/services/teacher/teacher_class_service.dart';

int _toInt(dynamic v) => int.tryParse(v?.toString() ?? '') ?? 0;

String formatScore(num? n) {
  if (n == null) return '-';
  return n % 1 == 0 ? n.toInt().toString() : n.toStringAsFixed(1);
}

// ===== MODEL =====
class StudentProfile {
  final int id;
  final String name;
  final String? photo;
  final String? nis;
  final String? nisn;
  final String? rombel;
  final String? tahunAjaran;

  StudentProfile({
    required this.id,
    required this.name,
    this.photo,
    this.nis,
    this.nisn,
    this.rombel,
    this.tahunAjaran,
  });

  factory StudentProfile.fromJson(Map<String, dynamic> json) {
    return StudentProfile(
      id: _toInt(json['id']),
      name: (json['name'] ?? '-').toString(),
      photo: json['photo']?.toString(),
      nis: json['nis']?.toString(),
      nisn: json['nisn']?.toString(),
      rombel: json['rombel']?.toString(),
      tahunAjaran: json['tahun_ajaran']?.toString(),
    );
  }

  /// Baris kedua di header: "XI IPA A • 2025/2026"
  String get classLabel {
    final parts = [rombel, tahunAjaran].where((e) => e != null && e.isNotEmpty);
    return parts.join(' • ');
  }

  /// Baris ketiga: "@0081234567"
  String? get idLabel {
    final id = (nisn != null && nisn!.isNotEmpty) ? nisn : nis;
    return (id == null || id.isEmpty) ? null : '@$id';
  }
}

class StudentTaskItem {
  final int id;
  final String type; // 'assignment' | 'quizzes'
  final String title;
  final DateTime? date; // selesai: waktu kumpul, belum: tenggat
  final num? score;
  final num maxScore;

  StudentTaskItem({
    required this.id,
    required this.type,
    required this.title,
    this.date,
    this.score,
    required this.maxScore,
  });

  factory StudentTaskItem.fromJson(Map<String, dynamic> json) {
    return StudentTaskItem(
      id: _toInt(json['id']),
      type: (json['type'] ?? 'assignment').toString(),
      title: (json['title'] ?? '-').toString(),
      date: json['date'] != null
          ? DateTime.tryParse(json['date'].toString())?.toLocal()
          : null,
      score: num.tryParse(json['score']?.toString() ?? ''),
      maxScore: num.tryParse(json['max_score']?.toString() ?? '') ?? 100,
    );
  }

  String get dateLabel {
    if (date == null) return '-';
    return DateFormat('d MMMM yyyy', 'id_ID').format(date!);
  }

  String get scoreLabel => '${formatScore(score)}/${formatScore(maxScore)}';
}

class ClassStudentDetailController extends GetxController {
  final _service = TeacherClassService();

  late final int classId;
  late final int studentId;

  final student = Rxn<StudentProfile>();
  final completed = <StudentTaskItem>[].obs;
  final notSubmitted = <StudentTaskItem>[].obs;

  final isLoading = false.obs;
  final errorMessage = RxnString();

  // Tab: 0 = Selesai, 1 = Belum terkumpul
  final selectedTab = 0.obs;
  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    classId = args['classId'] as int? ?? 0;
    studentId = args['studentId'] as int? ?? 0;
    fetchDetail();
  }

  Future<void> fetchDetail() async {
    isLoading.value = true;
    errorMessage.value = null;

    try {
      final result = await _service.getStudentDetail(
        classId: classId,
        studentId: studentId,
      );

      if (result['success'] == true) {
        try {
          final data = Map<String, dynamic>.from(result['data'] as Map);

          student.value = StudentProfile.fromJson(
            Map<String, dynamic>.from(data['student'] as Map),
          );

          List<StudentTaskItem> parse(dynamic raw) => (raw as List? ?? [])
              .whereType<Map>()
              .map((e) => StudentTaskItem.fromJson(Map<String, dynamic>.from(e)))
              .toList();

          completed.assignAll(parse(data['completed']));
          notSubmitted.assignAll(parse(data['not_submitted']));
        } catch (e) {
          errorMessage.value = 'Format data siswa tidak sesuai.';
        }
      } else {
        errorMessage.value = result['message']?.toString() ?? 'Gagal memuat siswa.';
      }
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan saat memuat data.';
    } finally {
      isLoading.value = false;
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

  void onTabChanged(int index) => selectedTab.value = index;
}
