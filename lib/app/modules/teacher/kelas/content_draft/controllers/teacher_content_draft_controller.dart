import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:monisa/app/data/services/teacher/teacher_materi_service.dart';

class MaterialFileRef {
  final int id;
  final String originalName;
  final String url;

  MaterialFileRef({required this.id, required this.originalName, required this.url});

  factory MaterialFileRef.fromJson(Map<String, dynamic> json) {
    return MaterialFileRef(
      id: json['id'] as int,
      originalName: (json['original_name'] ?? '-').toString(),
      url: (json['url'] ?? '').toString(),
    );
  }
}

class AssignedStudentRef {
  final int id;
  final String name;

  AssignedStudentRef({required this.id, required this.name});

  factory AssignedStudentRef.fromJson(Map<String, dynamic> json) {
    return AssignedStudentRef(
      id: json['id'] as int,
      name: (json['name'] ?? '-').toString(),
    );
  }
}

class TeacherContentDraft {
  // Materi
  final int id;
  final String title;
  final String? description;
  final bool isPublished;
  final DateTime? updatedAt;
  final int? topicId;
  final String? topicName;
  final List<MaterialFileRef> files;

  // Tugas
  final DateTime? deadline;
  final String? assignTo; // 'all' | 'selected'
  final List<AssignedStudentRef> students;
  final int? maxScore;

  TeacherContentDraft({
    required this.id,
    required this.title,
    this.description,
    required this.isPublished,
    this.updatedAt,
    this.topicId,
    this.topicName,
    this.files = const [],
    this.deadline,
    this.assignTo,
    this.students = const [],
    this.maxScore,
  });

  factory TeacherContentDraft.fromJson(Map<String, dynamic> json) {
    final topic = json['topic'] as Map<String, dynamic>?;

    return TeacherContentDraft(
      id: json['id'] as int,
      title: (json['title'] ?? '-').toString(),
      description: json['description'] as String?,
      isPublished: json['is_published'] == true,
      updatedAt: (json['updated_at'] ?? json['created_at']) != null
          ? DateTime.tryParse(
              (json['updated_at'] ?? json['created_at']).toString())
          : null,
      topicId: topic?['id'] as int?,
      topicName: topic?['name'] as String?,
      files: (json['files'] as List? ?? [])
          .map((e) => MaterialFileRef.fromJson(e as Map<String, dynamic>))
          .toList(),
      deadline: json['deadline'] != null
          ? DateTime.tryParse(json['deadline'].toString())
          : null,
      assignTo: json['assign_to'] as String?,
      students: (json['students'] as List? ?? [])
          .map((e) => AssignedStudentRef.fromJson(e as Map<String, dynamic>))
          .toList(),
      maxScore: json['max_score'] as int?,
    );
  }

  // "19.37" kalau hari ini, "15/05/2026" kalau bukan
  String get lastEditedLabel {
    if (updatedAt == null) return '-';
    final now = DateTime.now();
    final sameDay = now.year == updatedAt!.year &&
        now.month == updatedAt!.month &&
        now.day == updatedAt!.day;

    return sameDay
        ? DateFormat('HH.mm').format(updatedAt!)
        : DateFormat('dd/MM/yyyy').format(updatedAt!);
  }

  // "2 Mei 2026" — untuk ditampilkan di halaman detail
  String get uploadedDateLabel {
    if (updatedAt == null) return '-';
    return DateFormat('d MMMM yyyy', 'id_ID').format(updatedAt!);
  }
}

class TeacherContentDraftController extends GetxController {
  final _service = TeacherMateriService();

  final int classId;
  final String type;

  TeacherContentDraftController({required this.classId, required this.type});

  final allDrafts = <TeacherContentDraft>[].obs;
  final searchQuery = ''.obs;
  final isLoading = false.obs;
  final errorMessage = RxnString();

  List<TeacherContentDraft> get filteredDrafts {
    final drafts = allDrafts.where((e) => !e.isPublished).toList();
    if (searchQuery.value.trim().isEmpty) return drafts;

    final q = searchQuery.value.trim().toLowerCase();
    return drafts.where((e) => e.title.toLowerCase().contains(q)).toList();
  }

  String get title {
    switch (type) {
      case 'assignment':
        return 'Draf tugas';
      case 'quiz':
        return 'Draf kuis';
      case 'material':
      default:
        return 'Draf materi';
    }
  }

  String get addButtonLabel {
    switch (type) {
      case 'assignment':
        return 'Tambah tugas baru';
      case 'quiz':
        return 'Tambah kuis baru';
      case 'material':
      default:
        return 'Tambah materi baru';
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchDrafts();
  }

  Future<void> fetchDrafts() async {
    isLoading.value = true;
    errorMessage.value = null;

    Map<String, dynamic> result;
    switch (type) {
      case 'assignment':
        result = await _service.getAssignments(classId);
        break;
      case 'quiz':
        result = await _service.getQuizzes(classId);
        break;
      case 'material':
      default:
        result = await _service.getMaterials(classId);
    }

    if (result['success'] == true) {
      try {
        final data = result['data'] as Map<String, dynamic>;
        final key = type == 'material'
            ? 'materials'
            : type == 'assignment'
                ? 'assignments'
                : 'quizzes';

        final list = (data[key] as List? ?? [])
            .map((e) =>
                TeacherContentDraft.fromJson(e as Map<String, dynamic>))
            .toList();
        allDrafts.assignAll(list);
      } catch (e) {
        errorMessage.value = 'Format data tidak sesuai.';
        debugPrint('Parse draft error: $e');
      }
    } else {
      allDrafts.clear();
      errorMessage.value = result['message']?.toString();
    }

    isLoading.value = false;
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;
  }
}