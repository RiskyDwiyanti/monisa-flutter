import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monisa/app/data/services/teacher/teacher_assignment_service.dart';

// ===== MODEL =====
class StudentOption {
  final int id;
  final String name;
  final String? nis;
  final String? nisn;

  StudentOption({required this.id, required this.name, this.nis, this.nisn});

  factory StudentOption.fromJson(Map<String, dynamic> json) {
    return StudentOption(
      id: json['id'] as int,
      name: (json['name'] ?? '-').toString(),
      nis: json['nis']?.toString(),
      nisn: json['nisn']?.toString(),
    );
  }
}

// ===== CONTROLLER =====
class TeacherStudentPickerController extends GetxController {
  final _service = TeacherAssignmentService();

  final int classId;
  final List<int> initialSelectedIds;

  TeacherStudentPickerController({
    required this.classId,
    this.initialSelectedIds = const [],
  });

  final students = <StudentOption>[].obs;
  final selectedIds = <int>{}.obs;
  final searchQuery = ''.obs;
  final isLoading = false.obs;
  final errorMessage = RxnString();

  List<StudentOption> get filteredStudents {
    if (searchQuery.value.trim().isEmpty) return students;
    final q = searchQuery.value.trim().toLowerCase();
    return students.where((e) => e.name.toLowerCase().contains(q)).toList();
  }

  @override
  void onInit() {
    super.onInit();
    selectedIds.addAll(initialSelectedIds);
    fetchStudents();
  }

  Future<void> fetchStudents() async {
    isLoading.value = true;
    errorMessage.value = null;

    final result = await _service.getStudents(classId);

    if (result['success'] == true) {
      try {
        final list = (result['data'] as List? ?? [])
            .map((e) => StudentOption.fromJson(e as Map<String, dynamic>))
            .toList();
        students.assignAll(list);
      } catch (e) {
        errorMessage.value = 'Format data siswa tidak sesuai.';
        debugPrint('Parse students error: $e');
      }
    } else {
      errorMessage.value = result['message']?.toString();
    }

    isLoading.value = false;
  }

  void onSearchChanged(String value) => searchQuery.value = value;

  void toggleStudent(int id) {
    if (selectedIds.contains(id)) {
      selectedIds.remove(id);
    } else {
      selectedIds.add(id);
    }
  }

  void selectAll() {
    selectedIds.assignAll(students.map((e) => e.id));
  }

  void clearAll() {
    selectedIds.clear();
  }
}