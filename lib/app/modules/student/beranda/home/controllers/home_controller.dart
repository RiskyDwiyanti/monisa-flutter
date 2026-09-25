import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:monisa/app/config/api_config.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController
  final name = ''.obs;
  final currentTime = '08:00:54'.obs;

  var isLoading = false.obs;

  // kalender
  final focusedMonth = DateTime.now().obs;
  final RxMap<DateTime, String> attendanceStatus = <DateTime, String>{}.obs;

  Future<void> fetchHomeData() async {
    try {
      isLoading.value = true;

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final response = await http.get(
        Uri.parse(
          '${ApiConfig.baseUrl}/student/home'
          '?year=${focusedMonth.value.year}'
          '&month=${focusedMonth.value.month}',
        ),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('HOME RESPONSE: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        final data = jsonData['data'];

        // Nama siswa
        name.value = data['siswa']?['nama'] ?? '';

        // Periode dari API
        final periode = data['periode'];

        if (periode != null) {
          focusedMonth.value = DateTime(
            periode['tahun'],
            periode['bulan'],
          );
        }

        // Kalender
        _parseAttendanceCalendar(
          data['kalender_kehadiran'],
        );
      } else {
        print(
          'Gagal mengambil data home: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error fetch home: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _parseAttendanceCalendar(dynamic calendarData) {
    attendanceStatus.clear();

    if (calendarData == null || calendarData is! List) {
      return;
    }

    for (final item in calendarData) {
      try {
        final date = DateTime.parse(item['tanggal']);

        final dateOnly = DateTime(
          date.year,
          date.month,
          date.day,
        );

        attendanceStatus[dateOnly] = item['status'];
      } catch (e) {
        print('Error parse kalender: $e');
      }
    }
  }

  void changeMonth(int offset) {
    focusedMonth.value = DateTime(
      focusedMonth.value.year,
      focusedMonth.value.month + offset,
    );

    fetchHomeData();
  }

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
        Uri.parse('${ApiConfig.baseUrl}/auth/profile'),
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
    fetchHomeData();
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
