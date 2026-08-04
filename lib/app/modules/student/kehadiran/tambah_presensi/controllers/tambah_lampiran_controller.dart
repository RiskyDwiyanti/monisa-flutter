import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:monisa/app/modules/student/kehadiran/tambah_presensi/controllers/tambah_presensi_controller.dart';
import 'package:monisa/app/theme/app_colors.dart';
import 'package:monisa/app/theme/app_text.dart';

class TambahLampiranController extends GetxController {
  final TambahPresensiController _keterangan = Get.find<TambahPresensiController>();

  // PENTING: pakai XFile + bytes cache, BUKAN dart:io File.
  // dart:io File/FileImage tidak didukung di Flutter Web (akan throw
  // "Unsupported operation: _Namespace"). XFile + Image.memory jalan
  // di semua platform (web, mobile, desktop).
  final RxList<XFile> attachedFiles = <XFile>[].obs;
  final Map<String, Uint8List> _bytesCache = {};

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    // Auto-clear lampiran begitu user pindah balik ke "Hadir".
    ever(_keterangan.selectedKeterangan, (_) {
      if (!_keterangan.requiresAttachment) {
        clear();
      }
    });
  }

  String get primaryActionLabel =>
      _keterangan.requiresAttachment ? 'Kirim' : 'Scan QR';

  /// Bytes gambar untuk ditampilkan via Image.memory. Sudah pasti ada
  /// begitu file masuk ke attachedFiles, karena dibaca sekali saat dipilih.
  Uint8List? bytesFor(XFile file) => _bytesCache[file.path];

  Future<void> pickImage() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final bytes = await picked.readAsBytes();
      _bytesCache[picked.path] = bytes;
      attachedFiles.add(picked);
    }
  }

  void removeImage(int index) {
    final removed = attachedFiles.removeAt(index);
    _bytesCache.remove(removed.path);
  }

  void clear() {
    attachedFiles.clear();
    _bytesCache.clear();
  }

  void scanQR() {
    // TODO: sambungkan ke logic scan QR yang sudah ada di project kamu
  }

  void submitIzinSakit() {
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

  void onPrimaryActionTap() {
    if (_keterangan.requiresAttachment) {
      submitIzinSakit();
    } else {
      scanQR();
    }
  }
}