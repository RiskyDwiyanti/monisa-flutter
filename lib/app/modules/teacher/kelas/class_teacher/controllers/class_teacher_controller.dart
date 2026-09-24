import 'dart:ui';

import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:monisa/app/data/services/teacher_class_service.dart';
import 'package:monisa/app/theme/app_colors.dart';

class StudentPreview {
  final String name;
  final String? photoUrl;

  StudentPreview({required this.name, this.photoUrl});

  // factory StudentPreview.fromJson(Map<String, dynamic> json) {
  //   final user = json['user'] as Map<String, dynamic>?;
  //   return StudentPreview(
  //     name: (json['name'] ?? user?['name'] ?? '-').toString(),
  //     photoUrl: (json['photo'] ?? user?['photo']) as String?,
  //   );
  // }
}

class TeacherClassModel {
  final int id;
  final String name;
  final String? description;
  final String joinCode;
  final String tahunAjaran;
  final bool isActive;
  final String mapel;
  final String rombelName; // contoh: "XI IPA A"
  final int studentsCount;
  final List<StudentPreview> studentPreviews;

  TeacherClassModel({
    required this.id,
    required this.name,
    this.description,
    required this.joinCode,
    required this.tahunAjaran,
    required this.isActive,
    required this.mapel,
    required this.rombelName,
    this.studentsCount = 0,
    this.studentPreviews = const [],
  });

  factory TeacherClassModel.fromJson(Map<String, dynamic> json) {
    final rombel = json['rombel'] as Map<String, dynamic>?;
    final schoolMapel = json['school_mapel'] as Map<String, dynamic>?;
    final masterMapel = schoolMapel?['master_mapel'] as Map<String, dynamic>?;

    return TeacherClassModel(
      id: json['id'] as int,
      name: (json['name'] ?? '').toString(),
      description: json['description'] as String?,
      joinCode: (json['join_code'] ?? '').toString(),
      tahunAjaran: (json['tahun_ajaran'] ?? '').toString(),
      isActive: json['is_active'] == true || json['is_active'] == 1,
      mapel: (masterMapel?['name'] ??
              schoolMapel?['name'] ??
              json['name'] ??
              '-')
          .toString(),
      rombelName: (rombel?['name'] ?? '-').toString(),

      // TODO: ganti dengan data dari API saat backend sudah mengirim siswa
      studentsCount: ClassTeacherController.dummyStudentsCount,
      studentPreviews: ClassTeacherController.dummyStudents,
    );
  }
}

class ClassTeacherController extends GetxController {
  //TODO: Implement ClassTeacherController
  final _service = TeacherClassService();

  // ===== Data siswa statis sementara =====
  static const int dummyStudentsCount = 32; // "Aditya S. dan 31 lainnya"
  static final List<StudentPreview> dummyStudents = [
    StudentPreview(name: 'Aditya S.'),
    StudentPreview(name: 'Bima P.'),
    StudentPreview(name: 'Tania R.'),
  ];

  final classes = <TeacherClassModel>[].obs;
  final isLoading = false.obs;
  final errorMessage = RxnString();

  // Urutan warna kartu: Blush -> Sky -> Butter -> ulang
  static final List<Color> _palette = [
    AppColors.Blush,
    AppColors.Sky,
    AppColors.Butter,
  ];

  Color colorFor(int index) => _palette[index % _palette.length];

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    fetchClasses();
  }

  Future<void> fetchClasses() async {
    isLoading.value = true;
    errorMessage.value = null;

    final result = await _service.getClasses();

    if (result['success'] == true) {
      try {
        final list = (result['data'] as List? ?? [])
            .map((e) => TeacherClassModel.fromJson(e as Map<String, dynamic>))
            .toList();
        classes.assignAll(list);
      } catch (e) {
        errorMessage.value = 'Format data kelas tidak sesuai.';
        debugPrint('Parse kelas error: $e');
      }
    } else {
      errorMessage.value = result['message']?.toString();
    }

    isLoading.value = false;
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
