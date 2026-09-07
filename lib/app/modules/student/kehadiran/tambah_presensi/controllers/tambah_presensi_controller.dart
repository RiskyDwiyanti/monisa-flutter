import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:monisa/app/data/services/presensi_service.dart';
import 'package:monisa/app/modules/student/kehadiran/presensi/controllers/presensi_controller.dart';
import 'package:monisa/app/modules/student/main/controllers/main_controller.dart';
import 'package:monisa/app/routes/app_pages.dart';
import 'package:monisa/app/theme/app_colors.dart';
import 'package:monisa/app/theme/app_text.dart';

class TambahPresensiController extends GetxController {
  //TODO: Implement TambahPresensiController
  final PresensiService _presensiService = PresensiService();
  final RxString selectedKeterangan = 'Hadir'.obs;
 
  /// Izin & Sakit butuh lampiran surat, Hadir tidak.
  bool get requiresAttachment => selectedKeterangan.value != 'Hadir';
 
  void selectKeterangan(String value) {
    selectedKeterangan.value = value;
  }
  
  // ================= LAMPIRAN =================
  final ImagePicker _picker = ImagePicker();

  final RxList<XFile> attachedFiles = <XFile>[].obs;

  final Map<String, Uint8List> _bytesCache = {};

  Uint8List? bytesFor(XFile file) {
    return _bytesCache[file.path];
  }

  Future<void> pickImage() async {
    final XFile? picked = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (picked == null) return;

    final bytes = await picked.readAsBytes();

    _bytesCache[picked.path] = bytes;

    attachedFiles.clear();
    attachedFiles.add(picked);
  }

  void removeImage(int index) {
    final removed = attachedFiles.removeAt(index);

    _bytesCache.remove(removed.path);
  }

  void clearAttachment() {
    attachedFiles.clear();
    _bytesCache.clear();
  }

  // Action Button
  String get primaryActionLabel {
    if (requiresAttachment) {
      return 'Kirim';
    }

    return 'Scan QR';
  }

  void onPrimaryActionTap() {
    if (requiresAttachment) {
      submitIzinSakit();
    } else {
      scanQR();
    }
  }

  Future<void> backToPresensi() async {
    final presensiController = Get.find<PresensiController>();

    // Refresh kalender
    await presensiController.fetchAttendance(
      presensiController.focusedMonth.value.year,
      presensiController.focusedMonth.value.month,
    );

    // Pilih tab Presensi di Main
    final mainController = Get.find<MainController>();
    mainController.changeIndex(2);

    // Kembali ke Main
    Get.until((route) => route.settings.name == Routes.MAIN);
  }

  // Hadir
   Future<void> scanQR() async {
    final result = await Get.toNamed(
      Routes.SQAN_QR_PRESENSI,
    );

    if (result == null) return;

    final qrCode = result.toString();

    print('QR CODE: $qrCode');

    // Nanti panggil service API di sini
    
    await submitHadir(qrCode);
  }

  Future<void> submitHadir(String qrCode) async {
    try {
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(),
        ),
        barrierDismissible: false,
      );

      final result = await _presensiService.submitHadir(
        qrCode: qrCode,
      );

      // Tutup loading
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      if (result['success'] == true) {
        Get.snackbar(
          'Berhasil',
          result['message'] ?? 'Presensi berhasil.',
          snackPosition: SnackPosition.BOTTOM,
        );

        // Kembali dari halaman tambah presensi
        await backToPresensi();
      } else {
        Get.snackbar(
          'Presensi Gagal',
          result['message'] ?? 'Presensi gagal.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }

       } catch (e) {
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      print('SUBMIT HADIR ERROR: $e');

      Get.snackbar(
        'Error',
        'Terjadi kesalahan saat mengirim presensi.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Izin / sakit
  void submitIzinSakit() {
    if (attachedFiles.isEmpty) {
      Get.snackbar(
        'Lampiran',
        'Silakan upload surat izin atau surat dokter terlebih dahulu.',
      );

      return;
    }

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
                            onTap: () async {
                              Get.back();
                              
                              await submitAttendance();
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

  Future<void> submitAttendance() async {
    if (attachedFiles.isEmpty) {
      Get.snackbar(
        'Lampiran',
        'Lampiran wajib diunggah.',
        snackPosition: SnackPosition.BOTTOM,
      );

      return;
    }

    final file = attachedFiles.first;
    final bytes = bytesFor(file);

    if (bytes == null) {
      Get.snackbar(
        'Lampiran',
        'Gagal membaca file lampiran.',
        snackPosition: SnackPosition.BOTTOM,
      );

      return;
    }

    final status = selectedKeterangan.value.toLowerCase();

    try {
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(),
        ),
        barrierDismissible: false,
      );

      final result = await _presensiService.submitIzinSakit(
        status: status,
        lampiranBytes: bytes,
        fileName: file.name,
      );

      // Tutup loading
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      if (result['success'] == true) {
        Get.snackbar(
          'Berhasil',
          result['message'] ?? 'Presensi berhasil dikirim.',
          snackPosition: SnackPosition.BOTTOM,
        );

        // Bersihkan lampiran
        clearAttachment();

        // Kembali ke halaman sebelumnya
        await backToPresensi();
        } else {
        Get.snackbar(
          'Presensi Gagal',
          result['message'] ?? 'Presensi gagal dikirim.',
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      print('SUBMIT IZIN/SAKIT ERROR: $e');

      Get.snackbar(
        'Error',
        'Terjadi kesalahan saat mengirim presensi.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    clearAttachment();
    super.onClose();
  }

  void increment() => count.value++;
}
