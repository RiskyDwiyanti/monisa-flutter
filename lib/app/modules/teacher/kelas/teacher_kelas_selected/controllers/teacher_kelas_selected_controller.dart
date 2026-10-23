import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:monisa/app/data/services/teacher/teacher_materi_service.dart';
import 'package:monisa/app/routes/app_pages.dart';
import 'package:monisa/app/theme/app_colors.dart';

// ===== MODEL =====
class MateriItem {
  final int id;
  final String type; // 'material' | 'assignment' | 'quiz'
  final String title;
  final String? description;
  final bool isPublished;
  final DateTime? createdAt;

  MateriItem({
    required this.id,
    required this.type,
    required this.title,
    this.description,
    required this.isPublished,
    this.createdAt,
  });

  factory MateriItem.fromJson(Map<String, dynamic> json) {
    return MateriItem(
      id: json['id'] as int,
      type: (json['type'] ?? '-').toString(),
      title: (json['title'] ?? '-').toString(),
      description: json['description'] as String?,
      isPublished: json['is_published'] == true,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
    );
  }

  String get icon {
    switch (type) {
      case 'assignment':
        return 'assets/icons/pen_icon.svg';
      case 'quiz':
        return 'assets/icons/pen_icon.svg';
      case 'material':
      default:
        return 'assets/icons/book_outline_icon.svg';
    }
  }

  // "Diunggah 2 Mei 2026" untuk materi, "10 Mei 2026" untuk tugas/kuis
  String get tanggal {
    if (createdAt == null) return '-';
    final formatted = DateFormat('d MMMM yyyy', 'id_ID').format(createdAt!);
    return type == 'material' ? '$formatted' : formatted;
  }
}

class MateriGroup {
  final int id;
  final String title;
  final List<MateriItem> items;

  MateriGroup({
    required this.id,
    required this.title,
    required this.items,
  });

  factory MateriGroup.fromJson(Map<String, dynamic> json) {
    return MateriGroup(
      id: json['id'] as int,
      title: (json['name'] ?? '-').toString(),
      items: (json['contents'] as List? ?? [])
          .map((e) => MateriItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class TeacherKelasSelectedController extends GetxController {
  final _service = TeacherMateriService();

  // Dikirim dari halaman daftar kelas (TeacherClassView)
  late final int classId;
  late final String mapel;
  late final String kelas;
  late final String tahunAjaran;
  late final Color bgColor;

  final materiGroups = <MateriGroup>[].obs;
  final isLoading = false.obs;
  final errorMessage = RxnString();

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments as Map<String, dynamic>? ?? {};
    classId = args['id'] as int? ?? 0;
    mapel = (args['mapel'] ?? '-').toString();
    kelas = (args['kelas'] ?? '-').toString();
    tahunAjaran = (args['tahunAjaran'] ?? '-').toString();
    bgColor = args['bgColor'] as Color? ?? AppColors.Blush;

    fetchClassContents();
  }

  Future<void> fetchClassContents() async {
    isLoading.value = true;
    errorMessage.value = null;

    final result = await _service.getClassContents(classId);

    if (result['success'] == true) {
      try {
        final data = result['data'] as Map<String, dynamic>;
        final topics = (data['topics'] as List? ?? [])
            .map((e) => MateriGroup.fromJson(e as Map<String, dynamic>))
            .toList();
        materiGroups.assignAll(topics);
      } catch (e) {
        errorMessage.value = 'Format data kelas tidak sesuai.';
        debugPrint('Parse class contents error: $e');
      }
    } else {
      errorMessage.value = result['message']?.toString();
    }

    isLoading.value = false;
  }

  void onMateriTap(MateriItem item) {
    switch (item.type) {
      case 'material':
        Get.toNamed(Routes.MATERIAL_DETAIL, arguments: {
          'classId': classId,
          'materialId': item.id,
        })?.then((result) {
          if (result == true) fetchClassContents(); // refresh list setelah edit/hapus
        });
        break;
      case 'assignment':
        Get.toNamed(Routes.ASSIGNMENT_DETAIL, arguments: {
          'classId': classId,
          'assignmentId': item.id,
        })?.then((result) {
          if (result == true) fetchClassContents();
        });
        break;
      case 'quiz':
        // TODO: halaman detail kuis
        break;
    }
  }

  // Dipanggil dari masing-masing opsi di bottom sheet
  void onPilihMateri() {
    Get.back(); // tutup bottom sheet
    // TODO: navigasi ke form tambah Materi, bawa classId
  }

  void onPilihTugas() {
    Get.back();
    // TODO: navigasi ke form tambah Tugas, bawa classId
  }

  void onPilihKuis() {
    Get.back();
    // TODO: navigasi ke form tambah Kuis, bawa classId
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
