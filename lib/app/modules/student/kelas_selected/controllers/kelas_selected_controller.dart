import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MateriItem {
  final String title;
  final String icon;
  final String tanggal;

  MateriItem({
    required this.title,
    required this.icon,
    required this.tanggal,
  });
}

class MateriGroup {
  final String title;
  final List<MateriItem> items;

  MateriGroup({required this.title, required this.items});
}

class KelasSelectedController extends GetxController {
  //TODO: Implement KelasSelectedController
  late final String mapel;
  late final String kelas;
  late final String tahunAjaran;
  late final Color bgColor;

  final materiGroups = <MateriGroup>[].obs;

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    mapel = Get.arguments['mapel'];
    kelas = Get.arguments['kelas'];
    tahunAjaran = Get.arguments['tahunAjaran'];
    bgColor = Get.arguments['bgColor'];

    _loadMateri();
  }

  void _loadMateri() {
    materiGroups.assignAll([
      MateriGroup(
        title: 'Menulis Puisi Inspiratif',
        items: [
          MateriItem(
            title: 'Praktik Menulis Puisi',
            icon: 'assets/icons/pen_icon.svg',
            tanggal: '10 Mei 2026',
          ),
          MateriItem(
            title: 'Unsur-Unsur Puisi dan Teknik Menulis Puisi ',
            icon: 'assets/icons/book_outline_icon.svg',
            tanggal: '2 Mei 2026',
          ),
        ],
      ),
      MateriGroup(
        title: 'Menulis Puisi Inspiratif',
        items: [
          MateriItem(
            title: 'Praktik Menulis Puisi',
            icon: 'assets/icons/pen_icon.svg',
            tanggal: '10 Mei 2026',
          ),
          MateriItem(
            title: 'Unsur-Unsur Puisi dan Teknik Menulis Puisi ',
            icon: 'assets/icons/book_outline_icon.svg',
            tanggal: '2 Mei 2026',
          ),
        ],
      ),
    ]);
  }

  void onInfoTap() {
    // TODO: tampilkan info kelas
  }

  void onMateriTap(MateriItem item) {
    // TODO: navigasi ke detail materi
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
