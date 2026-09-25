import 'dart:convert';

import 'package:monisa/app/config/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HomeService {
  static const String baseUrl = '${ApiConfig.baseUrl}';

  // Ambil token Sanctum dari SharedPreferences
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Header untuk request JSON
  Future<Map<String, String>> _headers() async {
    final token = await _getToken();

    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // Cek token
  Future<bool> isLoggedIn() async {
    final token = await _getToken();
    return token != null && token.isNotEmpty;
  }

  // Home Teacher
  Future<Map<String, dynamic>> getTeacherHome() async {
    try {
      final headers = await _headers();

      final response = await http.get(
        Uri.parse('$baseUrl/teacher/home'),
        headers: headers,
      );

      final data = jsonDecode(response.body);

      return {
        'statusCode': response.statusCode,
        'success': data['success'] == true,
        'message': data['message'] ?? 'Gagal memuat data beranda guru.',
        'data': data['data'],
        'errors': data['errors'],
      };
    } catch (e) {
      return {
        'statusCode': 0,
        'success': false,
        'message': 'Tidak dapat terhubung ke server.',
        'error': e.toString(),
      };
    }
  }

  // Home Parent
  Future<Map<String, dynamic>> getParentHome({
    required int year,
    required int month,
  }) async {
    try {
      final headers = await _headers();

      final response = await http.get(
        Uri.parse('$baseUrl/parent/home?year=$year&month=$month'),
        headers: headers,
      );

      final data = jsonDecode(response.body);

      return {
        'statusCode': response.statusCode,
        'success': data['success'] == true,
        'message': data['message'] ?? 'Gagal memuat data beranda.',
        'data': data['data'],
        'errors': data['errors'],
      };
    } catch (e) {
      return {
        'statusCode': 0,
        'success': false,
        'message': 'Tidak dapat terhubung ke server.',
        'error': e.toString(),
      };
    }
  }
}