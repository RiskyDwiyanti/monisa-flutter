import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:monisa/app/routes/app_pages.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SigninController extends GetxController {
  //TODO: Implement SigninController
  final usernameC = TextEditingController();
  final passwordC = TextEditingController();

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

    isLoading.value =true;

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:9000/api/auth/signin'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': usernameC.text.trim(),
          'password': passwordC.text,
        }),
      );

      print('STATUS CODE : ${response.statusCode}');
      print('RESPONSE    : ${response.body}');

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        final prefs = await SharedPreferences.getInstance();

        await prefs.setString('token', data['token']);
        await prefs.setString('user', jsonEncode(data['user']));

        final user = data['user'];
        if (user == null) {
          Get.snackbar('Error', 'User data is null');
          return;
        }

        final role = user['role']?.toString().trim().toLowerCase();

        if (role == 'student') {
          Get.offAllNamed(Routes.MAIN);
        }
      } else {
        Get.snackbar(
          'Error',
          data['message'] ?? 'Login failed',
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
