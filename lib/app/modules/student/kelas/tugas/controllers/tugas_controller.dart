import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monisa/app/theme/app_colors.dart';

class TugasModel {
  final String title;
  final String subject;
  final String deadline;
  final String status;
  final Color bgColor;

  TugasModel({
    required this.title,
    required this.subject,
    required this.deadline,
    required this.status,
    required this.bgColor,
  });
}

class TugasController extends GetxController {
  //TODO: Implement TugasController
  final searchQuery = ''.obs;
  final sortNewest = true.obs;
  final activeFilterCount = 1.obs;

  final allTugas = <TugasModel>[].obs;
  final filteredTugas = <TugasModel>[].obs;

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    _loadTugas();
    filteredTugas.assignAll(allTugas);
  }

  void _loadTugas() {
    allTugas.assignAll([
      TugasModel(
        title: 'Rangkuman: Silsilah Kerajaan Mataram',
        subject: 'Sejarah',
        deadline: '10 Mei 2026, 23:59',
        status: 'Ditugaskan',
        bgColor: AppColors.Butter,
      ),
      TugasModel(
        title: 'Lembar Kerja SPLTV',
        subject: 'Matematika',
        deadline: '8 Mei 2026, 21:00',
        status: 'Terlambat',
        bgColor: AppColors.Sky,
      ),
    ]);
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;
    _applyFilter();
  }

  void _applyFilter() {
    var result = allTugas.where((tugas) {
      final query = searchQuery.value.toLowerCase();
      return tugas.title.toLowerCase().contains(query) ||
          tugas.subject.toLowerCase().contains(query);
    }).toList();

    if (!sortNewest.value) {
      result = result.reversed.toList();
    }

    filteredTugas.assignAll(result);
  }

  void toggleSort() {
    sortNewest.value = !sortNewest.value;
    _applyFilter();
  }

  void openFilter() {
    // TODO: tampilkan bottom sheet filter
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
