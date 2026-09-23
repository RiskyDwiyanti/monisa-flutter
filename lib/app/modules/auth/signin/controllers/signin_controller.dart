import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monisa/app/data/services/auth_service.dart';
import 'package:monisa/app/routes/app_pages.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SigninController extends GetxController {
  //TODO: Implement SigninController
  final usernameC = TextEditingController();
  final passwordC = TextEditingController();
  final AuthService _authService = AuthService();

  var isLoading = false.obs;
  var obscurePassword = true.obs;

  void togglePassword() {
    obscurePassword.value = !obscurePassword.value;
  }

  Future<void> login() async {
    if (usernameC.text.isEmpty || passwordC.text.isEmpty) {
      Get.snackbar('Error', 'Username and password required');
      return;
    }

    isLoading.value = true;

    try {
      final response = await _authService.signin(
        username: usernameC.text.trim(),
        password: passwordC.text,
      );

      if (response['success'] == true) {
        final token = response['token'];
        final user = response['user'];

        if (token == null || user == null) {
          Get.snackbar(
            'Error',
            'Data login tidak lengkap.',
          );
          return;
        }

        final prefs = await SharedPreferences.getInstance();

        await prefs.setString(
          'token',
          token.toString(),
        );

        await prefs.setString(
          'user',
          jsonEncode(user),
        );

        final role = user['role']
            ?.toString()
            .trim()
            .toLowerCase();

        if (role == 'student') {
          Get.offAllNamed(Routes.MAIN);
        } else if (role == 'teacher') {
          Get.offAllNamed(Routes.MAIN_TEACHER);
        } else if (role == 'parent') {
          Get.offAllNamed(Routes.MAIN_PARENT);
        } else {
          Get.snackbar(
            'Error',
            'Role pengguna tidak dikenali.',
          );
        }
      } else {
        Get.snackbar(
          'Error',
          response['message'] ?? 'Login failed',
        );
      }
    } catch (e) {
      print('EXCEPTION : $e');
      Get.snackbar('Error', 'Server error');
    } finally {
      isLoading.value = false;
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
    usernameC.dispose();
    passwordC.dispose();
    super.onClose();
  }

  void increment() => count.value++;
}
