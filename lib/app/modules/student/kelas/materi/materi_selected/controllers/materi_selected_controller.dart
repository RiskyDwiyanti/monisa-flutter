import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:monisa/app/data/services/student/student_materi_service.dart';
import 'package:monisa/app/modules/teacher/kelas/class_info/views/widget/info_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

int _toInt(dynamic v) => int.tryParse(v?.toString() ?? '') ?? 0;

// ===== MODEL =====
class MateriFileItem {
  final int id;
  final String originalName;
  final String url;
  final String? mimeType;

  MateriFileItem({
    required this.id,
    required this.originalName,
    required this.url,
    this.mimeType,
  });

  factory MateriFileItem.fromJson(Map<String, dynamic> json) {
    return MateriFileItem(
      id: _toInt(json['id']),
      originalName: (json['original_name'] ?? 'File').toString(),
      url: (json['url'] ?? '').toString(),
      mimeType: json['mime_type']?.toString(),
    );
  }

  /// Ekstensi huruf kecil, diambil dari nama file, fallback ke mime type.
  String get extension {
    final dot = originalName.lastIndexOf('.');
    if (dot != -1 && dot < originalName.length - 1) {
      return originalName.substring(dot + 1).toLowerCase();
    }

    final mime = (mimeType ?? '').toLowerCase();
    if (mime.contains('pdf')) return 'pdf';
    if (mime.contains('wordprocessingml')) return 'docx';
    if (mime.contains('msword')) return 'doc';
    if (mime.contains('spreadsheetml')) return 'xlsx';
    if (mime.contains('ms-excel')) return 'xls';
    if (mime.contains('presentationml')) return 'pptx';
    if (mime.contains('ms-powerpoint')) return 'ppt';
    if (mime.contains('text/plain')) return 'txt';
    return '';
  }

  bool get isImage {
    if ((mimeType ?? '').toLowerCase().startsWith('image/')) return true;
    return const ['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(extension);
  }
}

class MateriDetail {
  final int id;
  final String title;
  final String? description;
  final DateTime? createdAt;
  final String teacherName;
  final String? teacherPhoto;
  final List<MateriFileItem> files;
  final Color avatarColor;

  MateriDetail({
    required this.id,
    required this.title,
    this.description,
    this.createdAt,
    required this.teacherName,
    this.teacherPhoto,
    this.files = const [],
    required this.avatarColor,
  });

  factory MateriDetail.fromJson(Map<String, dynamic> json) {
    final teacher = json['teacher'] is Map
        ? Map<String, dynamic>.from(json['teacher'] as Map)
        : <String, dynamic>{};

    final guruId = _toInt(teacher['id']);

    // Warna avatar guru: konsisten per guru, dan tidak sama dengan warna kartu.
    final palette = kAvatarPalette.toList();
    final avatarColor = palette[guruId % palette.length];

    return MateriDetail(
      id: _toInt(json['id']),
      title: (json['title'] ?? '-').toString().trim(),
      description: json['description']?.toString(),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())?.toLocal()
          : null,
      teacherName: (teacher['name'] ?? '-').toString(),
      teacherPhoto: teacher['photo']?.toString(),
      files: (json['files'] as List? ?? [])
          .whereType<Map>()
          .map((e) => MateriFileItem.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      avatarColor: avatarColor,
    );
  }

  String get uploadedDateLabel {
    if (createdAt == null) return '-';
    return DateFormat('d MMMM yyyy', 'id_ID').format(createdAt!);
  }
}

class MateriSelectedController extends GetxController {
  final _service = StudentMateriService();

  late final int classId;
  late final int materialId;

  final material = Rxn<MateriDetail>();
  final isLoading = false.obs;
  final errorMessage = RxnString();

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    classId = args['classId'] as int? ?? 0;
    materialId = args['materialId'] as int? ?? 0;
    fetchDetail();
  }

  Future<void> fetchDetail() async {
    isLoading.value = true;
    errorMessage.value = null;

    try {
      final result = await _service.getMaterialDetail(materialId);

      if (result['success'] == true) {
        try {
          material.value = MateriDetail.fromJson(
            Map<String, dynamic>.from(result['data'] as Map),
          );
        } catch (e) {
          errorMessage.value = 'Format data materi tidak sesuai.';
        }
      } else {
        errorMessage.value = result['message']?.toString() ?? 'Gagal memuat materi.';
      }
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan saat memuat data.';
    } finally {
      isLoading.value = false;
    }
  }

  /// Buka file (gambar maupun dokumen) di tab/aplikasi baru.
  Future<void> openFile(MateriFileItem file) async {
    if (file.url.isEmpty) return;

    final ok = await launchUrl(
      Uri.parse(file.url),
      mode: LaunchMode.externalApplication,
    );

    if (!ok) {
      Get.snackbar('Gagal', 'File tidak dapat dibuka.');
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
