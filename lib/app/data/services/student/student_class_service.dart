import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:monisa/app/config/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentClassService {
  static const String baseUrl = '${ApiConfig.baseUrl}';

  Future<Map<String, String>> _headers() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<Map<String, dynamic>> _get(String path, String fallbackMessage) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$path'),
        headers: await _headers(),
      );
      final data = jsonDecode(response.body);

      return {
        'statusCode': response.statusCode,
        'success': data['success'] == true,
        'message': data['message'] ?? fallbackMessage,
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

  // Daftar kelas yang diikuti siswa
  Future<Map<String, dynamic>> getClasses() => 
      _get('student/classes', 'Gagal memuat daftar kelas.');

  // Isi satu kelas (dipakai halaman isi kelas)
  Future<Map<String, dynamic>> getClassContents(int classId) =>
      _get('student/classes/$classId/contents', 'Gagal memuat isi kelas.');
}