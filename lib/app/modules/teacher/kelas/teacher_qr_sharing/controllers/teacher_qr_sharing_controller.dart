import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TeacherQrSharingController extends GetxController {
  //TODO: Implement TeacherQrSharingController
  late final String mapel;
  late final String kelas;
  late final String tahunAjaran;
  late final Color bgColor;

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>;
    mapel = args['mapel'];
    kelas = args['kelas'];
    tahunAjaran = args['tahunAjaran'];
    bgColor = args['bgColor'];
  }

  void bagikanTautan() {

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
