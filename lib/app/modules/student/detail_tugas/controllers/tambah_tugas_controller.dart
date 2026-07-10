import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AttachedFile {
  final String name;
  final XFile xFile;

  AttachedFile({required this.name, required this.xFile});
}

class TambahTugasController extends GetxController {
  final attachedFiles = <AttachedFile>[].obs;
  final ImagePicker _picker = ImagePicker();
  final isLoading = false.obs;

  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (image != null) {
        // Ambil nama file tanpa ekstensi
        final rawName = image.name;
        final name = rawName.contains('.')
            ? rawName.substring(0, rawName.lastIndexOf('.'))
            : rawName;

        attachedFiles.add(AttachedFile(name: name, xFile: image));
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memilih gambar',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void removeFile(int index) {
    if (index >= 0 && index < attachedFiles.length) {
      attachedFiles.removeAt(index);
    }
  }

  Future<void> kirimTugas() async {
    if (attachedFiles.isEmpty) {
      Get.snackbar(
        'Perhatian',
        'Tambahkan minimal satu file tugas',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }
    isLoading.value = true;
    // TODO: implement actual upload menggunakan attachedFiles[i].xFile
    await Future.delayed(const Duration(seconds: 2));
    isLoading.value = false;
    Get.back();
    Get.snackbar(
      'Berhasil',
      'Tugas berhasil dikirim',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF4CAF50),
      colorText: Colors.white,
    );
  }
}