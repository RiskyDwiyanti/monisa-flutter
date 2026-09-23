import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:monisa/app/data/services/auth_service.dart';
import 'package:monisa/app/routes/app_pages.dart';
import 'package:monisa/app/theme/app_colors.dart';
import 'package:monisa/app/theme/app_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController {
  final AuthService _authService = AuthService();

  final RxString name = ''.obs;
  final RxString kelas = ''.obs;
  final RxString tahunAjaran = ''.obs;
  final RxString nis = ''.obs;
  final RxString photoUrl = ''.obs; // isi dengan asset/network image path
  final RxBool isLoading = false.obs;

  String get kelasInfo {
    if (kelas.value.isEmpty && tahunAjaran.value.isEmpty) {
      return '';
    }

    return '${kelas.value} • ${tahunAjaran.value}';
  }

  void ubahPassword() {}

  void pusatBantuan() {}

  void umpanBalik() {}

  void logout() {
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
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.black),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Keluar dari akun anda?", style: AppText.SubHeading),
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
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.black),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text("Batal", style: AppText.Body_Bold),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              Get.back();

                              await _logout();
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: AppColors.Tangerine,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppColors.black),
                              ),
                              child: Center(
                                child: Text(
                                  "Keluar",
                                  style: AppText.Body_Bold.copyWith(
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

  // LOGOUT
  Future<void> _logout() async {
    try {
      final response = await _authService.signout();

      print('LOGOUT RESPONSE: $response');
    } catch (e) {
      print('Logout error: $e');
    } finally {
      final prefs =
          await SharedPreferences.getInstance();

      await prefs.clear();

      Get.offAllNamed(Routes.SIGNIN);
    }
  }

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      isLoading.value = true;

      final response = await _authService.getProfile();

      if (response['success'] == true) {
        final data = response['data'];

        if (data == null) {
          Get.snackbar('Error', 'Data profile tidak ditemukan.');
          return;
        }

        name.value = data['name']?.toString() ?? '';

        final student = data['student'];

        if (student != null) {
          nis.value = student['nis']?.toString() ?? '';
          photoUrl.value = student['photo']?.toString() ?? '';

          final rombel = student['rombel'];
          
          if (rombel != null) {
            kelas.value = rombel['nama_kelas']?.toString() ?? '';
            tahunAjaran.value = rombel['tahun_ajaran']?.toString() ?? '';
          }
        }
      } else {
        Get.snackbar(
          'Gagal',
          response['message'] ?? 'Gagal mengambil data profile.',
        );
      }
    } catch (e) {
      print('EXCEPTION: $e');

      Get.snackbar('Error', 'Terjadi kesalahan saat mengambil profile.');
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

  void increment() => count.value++;
}
