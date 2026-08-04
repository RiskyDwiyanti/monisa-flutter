import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monisa/app/theme/app_colors.dart';

class KelasModel {
  final String mapel;
  final String kelas;
  final String tahunAjaran;
  final String namaGuru;
  final String fotoGuru;
  final Color bgColor;

  KelasModel({
    required this.mapel,
    required this.kelas,
    required this.tahunAjaran,
    required this.namaGuru,
    required this.fotoGuru,
    required this.bgColor,
  });
}

class ClassController extends GetxController {
  //TODO: Implement ClassController

  final kelasList = <KelasModel>[].obs;

  void _loadKelas() {
    kelasList.assignAll([
      KelasModel(
        mapel: 'Bahasa Indonesia',
        kelas: 'XI IPA A',
        tahunAjaran: '2025/2026',
        namaGuru: 'Budi Setiawan S. Pd',
        fotoGuru: 'assets/images/guru1.png',
        bgColor: AppColors.Blush,
      ),
      KelasModel(
        mapel: 'Matematika',
        kelas: 'XI IPA A',
        tahunAjaran: '2025/2026',
        namaGuru: 'Eka Winarti S. Pd',
        fotoGuru: 'assets/images/guru2.png',
        bgColor: AppColors.Sky,
      ),
      KelasModel(
        mapel: 'Sejarah',
        kelas: 'XI IPA A',
        tahunAjaran: '2025/2026',
        namaGuru: 'Budi Setiawan S. Pd',
        fotoGuru: 'assets/images/guru1.png',
        bgColor: AppColors.Butter,
      ),
      KelasModel(
        mapel: 'Bahasa Indonesia',
        kelas: 'XI IPA A',
        tahunAjaran: '2025/2026',
        namaGuru: 'Budi Setiawan S. Pd',
        fotoGuru: 'assets/images/guru1.png',
        bgColor: AppColors.Blush,
      ),
    ]);
  }

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    _loadKelas();
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
