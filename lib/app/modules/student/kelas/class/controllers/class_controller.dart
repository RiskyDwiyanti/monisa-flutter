import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monisa/app/data/services/student/student_class_service.dart';
import 'package:monisa/app/modules/teacher/kelas/class_info/views/widget/info_widgets.dart';
import 'package:monisa/app/theme/app_colors.dart';

int _toInt(dynamic v) => int.tryParse(v?.toString() ?? '') ?? 0;

class KelasModel {
  final int id;
  final String mapel;
  final String kelas;
  final String tahunAjaran;
  final String namaGuru;
  final String? fotoGuru;
  final Color bgColor;
  final int guruId;
  final Color avatarColor;

  KelasModel({
    required this.id,
    required this.mapel,
    required this.kelas,
    required this.tahunAjaran,
    required this.namaGuru,
    this.fotoGuru,
    required this.bgColor,
    required this.guruId,
    required this.avatarColor,
  });

  // Hanya warna yang punya aset spiral di KelasCard.
  static const _colors = [AppColors.Blush, AppColors.Sky, AppColors.Butter];

  factory KelasModel.fromJson(Map<String, dynamic> json) {
    final teacher = json['teacher'] is Map
        ? Map<String, dynamic>.from(json['teacher'] as Map)
        : <String, dynamic>{};
    final id = _toInt(json['id']);
    final guruId = _toInt(teacher['id']);

    final bgColor = _colors[id % _colors.length];

    // Warna avatar guru: konsisten per guru, dan tidak sama dengan warna kartu.
    final palette = kAvatarPalette.where((c) => c != bgColor).toList();
    final avatarColor = palette[guruId % palette.length];

    return KelasModel(
      id: id,
      mapel: (json['school_mapel'] ?? json['name'] ?? '-').toString(),
      kelas: (json['rombel'] ?? '-').toString(),
      tahunAjaran: (json['tahun_ajaran'] ?? '-').toString(),
      namaGuru: (teacher['name'] ?? '-').toString(),
      fotoGuru: teacher['photo']?.toString(),
      bgColor: bgColor,
      guruId: guruId,
      avatarColor: avatarColor,
    );
  }
}

class ClassController extends GetxController {
  final _service = StudentClassService();

  final kelasList = <KelasModel>[].obs;
  final isLoading = false.obs;
  final errorMessage = RxnString();

  @override
  void onInit() {
    super.onInit();
    fetchKelas();
  }

  Future<void> fetchKelas() async {
    isLoading.value = true;
    errorMessage.value = null;

    try {
      final result = await _service.getClasses();

      if (result['success'] == true) {
        try {
          final data = Map<String, dynamic>.from(result['data'] as Map);
          kelasList.assignAll(
            (data['classes'] as List? ?? [])
                .whereType<Map>()
                .map((e) => KelasModel.fromJson(Map<String, dynamic>.from(e)))
                .toList(),
          );
        } catch (e) {
          errorMessage.value = 'Format data kelas tidak sesuai.';
          debugPrint('Parse classes error: $e');
        }
      } else {
        errorMessage.value = result['message']?.toString() ?? 'Gagal memuat kelas.';
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

}
