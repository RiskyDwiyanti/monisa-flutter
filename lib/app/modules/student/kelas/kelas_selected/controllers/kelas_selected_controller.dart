import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monisa/app/routes/app_pages.dart';

class MateriItem {
  final String title;
  final String icon;
  final String tanggal;
  final String? status;
  final String? teacherName;
  final String? teacherAvatarUrl;
  final String? description;
  final String? tenggat;

  MateriItem({
    required this.title,
    required this.icon,
    required this.tanggal,
    required this.status,
    required this.teacherName,
    required this.teacherAvatarUrl,
    required this.description,
    required this.tenggat,
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
            tanggal: '2 Mei 2026',
            status: 'Ditugaskan',
            teacherName: 'Budi Setiawan S. Pd',
            teacherAvatarUrl: 'assets/images/guru1.png',
            description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
            tenggat: '10 Mei 2026',
          ),
          MateriItem(
            title: 'Unsur-Unsur Puisi dan Teknik Menulis Puisi ',
            icon: 'assets/icons/book_outline_icon.svg',
            tanggal: '2 Mei 2026',
            status: 'Ditugaskan',
            teacherName: 'Budi Setiawan S. Pd',
            teacherAvatarUrl: 'assets/images/guru1.png',
            description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
            tenggat: '2 Mei 2026',
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
            status: 'Ditugaskan',
            teacherName: 'Budi Setiawan S. Pd',
            teacherAvatarUrl: 'assets/images/guru1.png',
            description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
            tenggat: '10 Mei 2026',
          ),
          MateriItem(
            title: 'Unsur-Unsur Puisi dan Teknik Menulis Puisi ',
            icon: 'assets/icons/book_outline_icon.svg',
            tanggal: '2 Mei 2026',
            status: 'Ditugaskan',
            teacherName: 'Budi Setiawan S. Pd',
            teacherAvatarUrl: 'assets/images/guru1.png',
            description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
            tenggat: '10 Mei 2026',
          ),
        ],
      ),
    ]);
  }

  void onInfoTap() {
    // TODO: tampilkan info kelas
  }

  void onMateriTap(MateriItem item) {
    Get.toNamed(Routes.DETAIL_TUGAS, arguments: {
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
