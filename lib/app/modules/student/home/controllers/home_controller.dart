import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController
  final name = ''.obs;
  final currentTime = '08:00:54'.obs;

  var isLoading = false.obs;

  // kalender
  final focusedMonth = DateTime(2026, 5).obs;
  final Map<DateTime, String> attendanceStatus = {
    // DateTime(2026, 5, 1): 'Libur',
    DateTime(2026, 5, 4): 'hadir',
    DateTime(2026, 5, 5): 'hadir',
    DateTime(2026, 5, 6): 'hadir',
    DateTime(2026, 5, 7): 'hadir',
    DateTime(2026, 5, 8): 'hadir',
    DateTime(2026, 5, 11): 'hadir',
    DateTime(2026, 5, 12): 'hadir',
    DateTime(2026, 5, 13): 'sakit',
    DateTime(2026, 5, 14): 'libur',
    DateTime(2026, 5, 15): 'sakit',
  };

  //greeting
  String getGreeting() {
    final hour = int.parse(currentTime.value.split(':')[0]);
    if (hour < 11) {
      return 'Pagi';
    } else if (hour < 15) {
      return 'Siang';
    } else if (hour < 18) {
      return 'Sore';
    }else {
      return 'Malam';
    }
  }

  // Api
  Future<void> fetchName() async {
    try {
      isLoading.value = true;

      final prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? '';

      print("TOKEN: $token");

      final response = await http.get(
        Uri.parse('http://127.0.0.1:9000/api/auth/profile'),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      ); 

      print(response.body);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final data = jsonData['data'];

        name.value = data['name'] ?? '';
      }
    } catch (e) {
      print("Error fetch profile: $e");
    } finally {
      isLoading.value = false;
    }
  }

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    fetchName();
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
