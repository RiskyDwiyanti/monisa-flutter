import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:monisa/app/routes/app_pages.dart';
import 'package:monisa/app/theme/app_colors.dart';
import 'package:monisa/app/theme/app_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProfileController extends GetxController {
  //TODO: Implement ProfileController
  final RxString name = 'Rika Raiana'.obs;
  final RxString kelas = 'XI IPA A'.obs;
  final RxString tahunAjaran = '2025/2026'.obs;
  final RxString nis = '0081234567'.obs;
  final RxString photoUrl = ''.obs; // isi dengan asset/network image path

  String get kelasInfo => '${kelas.value} • ${tahunAjaran.value}';

  void ubahPassword() {
    
  }
 
  void pusatBantuan() {
    
  }
 
  void umpanBalik() {
    
  }

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
                    Text(
                      "Keluar dari akun anda?",
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
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.black),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  "Batal",
                                  style: AppText.Body_Bold,
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
                              
                              try {
                                // Ambil token
                                final prefs = await SharedPreferences.getInstance();
                                final token = prefs.getString('token');

                                //Panggil API signout
                                await http.post(
                                  Uri.parse('http://127.0.0.1:8000/api/auth/signout'),
                                  headers: {
                                    'Content-Type': 'application/json',
                                    'Authorization': 'Bearer $token',
                                  },
                                );
                              } catch (e) {
                                print('Logout error: $e');
                              } finally {
                                // Hapus dari SharedPreferences
                                final prefs = await SharedPreferences.getInstance();
                                await prefs.clear();

                                // Navigasi ke halaman signin
                                Get.offAllNamed(Routes.SIGNIN);
                              }
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
                                  style: AppText.Body_Bold.copyWith(color: AppColors.white),
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
    super.onClose();
  }

  void increment() => count.value++;
}
