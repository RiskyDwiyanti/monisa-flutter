import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:monisa/app/data/services/student/student_class_service.dart';
import 'package:monisa/app/routes/app_pages.dart';
import 'package:monisa/app/theme/app_colors.dart';

int _toInt(dynamic v) => int.tryParse(v?.toString() ?? '') ?? 0;

DateTime? _parseDate(dynamic v) =>
    v == null ? null : DateTime.tryParse(v.toString())?.toLocal();

String? _fmtDate(DateTime? d) =>
    d == null ? null : DateFormat('d MMMM yyyy', 'id_ID').format(d);

class MateriItem {
  final int id;
  final String type; // 'material' | 'assignment' | 'quiz'
  final String title;
  final String icon;
  final String tanggal;
  final String? status;
  final String? teacherName;
  final String? teacherAvatarUrl;
  final String? description;
  final String? tenggat;

  MateriItem({
    required this.id,
    required this.type,
    required this.title,
    required this.icon,
    required this.tanggal,
    required this.status,
    required this.teacherName,
    required this.teacherAvatarUrl,
    required this.description,
    required this.tenggat,
  });

  factory MateriItem.fromJson(
    Map<String, dynamic> json, {
    String? teacherName,
    String? teacherAvatarUrl,
  }) {
    final type = (json['type'] ?? 'material').toString();
    final isTask = type == 'assignment' || type == 'quiz';

    final created = _parseDate(json['created_at']);
    final deadline = _parseDate(json['deadline']);

    // Materi: "Diunggah 2 Mei 2026". Tugas/kuis: tanggal tenggat (atau tanggal dibuat).
    String tanggal;
    if (isTask) {
      tanggal = _fmtDate(deadline ?? created) ?? '-';
    } else {
      final c = _fmtDate(created);
      tanggal = c == null ? '-' : 'Diunggah $c';
    }

    return MateriItem(
      id: _toInt(json['id']),
      type: type,
      title: (json['title'] ?? '-').toString().trim(),
      icon: isTask
          ? 'assets/icons/pen_icon.svg'
          : 'assets/icons/book_outline_icon.svg',
      tanggal: tanggal,
      status: isTask ? 'Ditugaskan' : null,
      teacherName: teacherName,
      teacherAvatarUrl: teacherAvatarUrl,
      description: json['description']?.toString(),
      tenggat: _fmtDate(deadline),
    );
  }
}

class MateriGroup {
  final int id;
  final String title;
  final List<MateriItem> items;

  MateriGroup({required this.id, required this.title, required this.items});

  factory MateriGroup.fromJson(
    Map<String, dynamic> json, {
    String? teacherName,
    String? teacherAvatarUrl,
  }) {
    return MateriGroup(
      id: _toInt(json['id']),
      title: (json['name'] ?? '-').toString(),
      items: (json['contents'] as List? ?? [])
          .whereType<Map>()
          .map((e) => MateriItem.fromJson(
                Map<String, dynamic>.from(e),
                teacherName: teacherName,
                teacherAvatarUrl: teacherAvatarUrl,
              ))
          .toList(),
    );
  }
}

class KelasSelectedController extends GetxController {
  final _service = StudentClassService();

  // Dikirim dari halaman daftar kelas (ClassView)
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

    fetchContents();
  }

  Future<void> fetchContents() async {
    isLoading.value = true;
    errorMessage.value = null;

    try {
      final result = await _service.getClassContents(classId);

      if (result['success'] == true) {
        try {
          final data = Map<String, dynamic>.from(result['data'] as Map);

          final teacher = data['teacher'] is Map
              ? Map<String, dynamic>.from(data['teacher'] as Map)
              : <String, dynamic>{};

          final groups = (data['topics'] as List? ?? [])
              .whereType<Map>()
              .map((e) => MateriGroup.fromJson(
                    Map<String, dynamic>.from(e),
                    teacherName: teacher['name']?.toString(),
                    teacherAvatarUrl: teacher['photo']?.toString(),
                  ))
              .where((g) => g.items.isNotEmpty) // sembunyikan topik kosong
              .toList();

          materiGroups.assignAll(groups);
        } catch (e) {
          errorMessage.value = 'Format data kelas tidak sesuai.';
          debugPrint('Parse student class contents error: $e');
        }
      } else {
        errorMessage.value = result['message']?.toString() ?? 'Gagal memuat isi kelas.';
      }
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan saat memuat data.';
    } finally {
      isLoading.value = false;
    }
  }
  
  void onInfoTap() {
    // TODO: tampilkan info kelas
  }

  void onMateriTap(MateriItem item) {
    if (item.type == 'material') {
      Get.toNamed(Routes.MATERI_SELECTED, arguments: {
        'classId': classId,
        'materialId': item.id,
      });
      return;
    }

    Get.toNamed(Routes.DETAIL_TUGAS, arguments: {
      'classId': classId,
      'id': item.id,
      'type': item.type,
      'title': item.title,
      'icon': item.icon,
      'tanggal': item.tanggal,
      'status': item.status,
      'teacherName': item.teacherName,
      'teacherAvatarUrl': item.teacherAvatarUrl,
      'description': item.description,
      'tenggat': item.tenggat,
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

  void increment() => count.value++;
}
