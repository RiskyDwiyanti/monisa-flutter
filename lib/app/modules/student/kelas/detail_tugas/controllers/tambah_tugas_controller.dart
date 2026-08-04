import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:monisa/app/theme/app_colors.dart';
import 'package:monisa/app/theme/app_text.dart';

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

  void kirim() {
    showDialog(
      context: Get.context!,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (_) => GestureDetector(
        onTap: () => Get.back(),
        child: Material(
          color: Colors.transparent,
          child: Center(
            child: GestureDetector(
              onTap: () {},
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 32),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.black, width: 1),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Kirim jawaban?",
                      style: AppText.SubHeading,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Pastikan kamu sudah yakin dengan jawabanmu.",
                      style: AppText.Body2,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => Get.back(),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.black, width: 1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  "Batal",
                                  style: AppText.SubHeading
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Get.back();
                              // TODO: panggil API delete account
                              // Get.offAllNamed(Routes.SIGNIN);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: AppColors.Tangerine,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.black, width: 1),
                              ),
                              child: Center(
                                child: Text(
                                  "Kirim".tr,
                                  style: AppText.SubHeading.copyWith(
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  
}