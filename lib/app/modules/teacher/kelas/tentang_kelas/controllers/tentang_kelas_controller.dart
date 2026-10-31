import 'package:get/get.dart';
import 'package:monisa/app/data/services/teacher/teacher_class_service.dart';
import 'package:monisa/app/routes/app_pages.dart';

int _toInt(dynamic v) => int.tryParse(v?.toString() ?? '') ?? 0;

// ===== MODEL =====
class ClassAbout {
  final int id;
  final String name;
  final String? schoolMapel;
  final String teacherName;
  final String? teacherPhoto;
  final String? description;
  final String? rombel;
  final String? tahunAjaran;

  ClassAbout({
    required this.id,
    required this.name,
    this.schoolMapel,
    required this.teacherName,
    this.teacherPhoto,
    this.description,
    this.rombel,
    this.tahunAjaran,
  });

  factory ClassAbout.fromJson(Map<String, dynamic> json) {
    final teacher = json['teacher'] is Map
        ? Map<String, dynamic>.from(json['teacher'] as Map)
        : <String, dynamic>{};

    return ClassAbout(
      id: _toInt(json['id']),
      name: (json['name'] ?? '-').toString(),
      schoolMapel: json['school_mapel']?.toString(),
      teacherName: (teacher['name'] ?? '-').toString(),
      teacherPhoto: teacher['photo']?.toString(),
      description: json['description']?.toString(),
      rombel: json['rombel']?.toString(),
      tahunAjaran: json['tahun_ajaran']?.toString(),
    );
  }

  static final _linkRegExp = RegExp(
    r'(https?:\/\/[^\s]+|(?:www\.|bit\.ly\/|wa\.me\/|chat\.whatsapp\.com\/)[^\s]+)',
    caseSensitive: false,
  );

  /// Tautan yang ditemukan di deskripsi (ditampilkan terpisah di bawah teks).
  List<String> get links => _linkRegExp
      .allMatches(description ?? '')
      .map((m) => m.group(0)!)
      .toList();

  /// Deskripsi tanpa tautan.
  String get descriptionText => (description ?? '')
      .replaceAll(_linkRegExp, '')
      .replaceAll(RegExp(r'\n{3,}'), '\n\n')
      .trim();
}

class ClassStudentItem {
  final int id;
  final String name;
  final String? photo;
  final int completedCount;
  final int totalCount;

  ClassStudentItem({
    required this.id,
    required this.name,
    this.photo,
    this.completedCount = 0,
    this.totalCount = 0,
  });

  factory ClassStudentItem.fromJson(Map<String, dynamic> json) {
    final progress = json['task_progress'] is Map
        ? Map<String, dynamic>.from(json['task_progress'] as Map)
        : <String, dynamic>{};

    return ClassStudentItem(
      id: _toInt(json['id']),
      name: (json['name'] ?? '-').toString(),
      photo: json['photo']?.toString(),
      completedCount: _toInt(progress['completed']),
      totalCount: _toInt(progress['total']),
    );
  }

  /// Contoh: 14/15
  String get progressLabel => '$completedCount/$totalCount';
}

class TentangKelasController extends GetxController {
  final _service = TeacherClassService();

  late final int classId;

  final about = Rxn<ClassAbout>();
  final students = <ClassStudentItem>[].obs;
  final studentsError = RxnString();

  final isLoading = false.obs;
  final errorMessage = RxnString();

  // Tab: 0 = Ikhtisar, 1 = Siswa
  final selectedTab = 0.obs;
  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    classId = args['classId'] as int? ?? 0;
    fetchAll();
  }

  Future<void> fetchAll() async {
    isLoading.value = true;
    errorMessage.value = null;

    try {
      final results = await Future.wait([
        _service.getAbout(classId: classId),
        _service.getStudents(classId: classId),
      ]);

      final aboutResult = results[0];
      final studentsResult = results[1];
      studentsError.value = null;

      if (aboutResult['success'] == true) {
        try {
          about.value = ClassAbout.fromJson(
            Map<String, dynamic>.from(aboutResult['data'] as Map),
          );
        } catch (e) {
          errorMessage.value = 'Format data kelas tidak sesuai.';
        }
      } else {
        errorMessage.value = aboutResult['message']?.toString() ?? 'Gagal memuat kelas.';
      }

      if (studentsResult['success'] == true) {
        try {
          final data = Map<String, dynamic>.from(studentsResult['data'] as Map);
          students.assignAll(
            (data['students'] as List? ?? [])
                .whereType<Map>()
                .map((e) => ClassStudentItem.fromJson(Map<String, dynamic>.from(e)))
                .toList(),
          );
        } catch (e) {
          studentsError.value = 'Format data siswa tidak sesuai.';
          print('Parse students error: $e');
        }
      } else {
        studentsError.value =
            studentsResult['message']?.toString() ?? 'Gagal memuat daftar siswa.';
        print('STUDENTS RESULT: $studentsResult');
      }
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan saat memuat data.';
    } finally {
      isLoading.value = false;
    }
  }

  void onTabChanged(int index) => selectedTab.value = index;

  void onStudentTap(ClassStudentItem student) {
    Get.toNamed(Routes.CLASS_STUDENT_DETAIL, arguments: {
      'classId': classId,
      'studentId': student.id,
    });
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
