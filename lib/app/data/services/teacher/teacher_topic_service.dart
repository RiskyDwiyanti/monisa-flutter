import 'dart:convert';

import 'package:monisa/app/config/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class TeacherTopicService {
  static const String baseUrl = '${ApiConfig.baseUrl}';

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<Map<String, String>> _headers() async {
    final token = await _getToken();
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // Index: daftar topik dalam kelas
  Future<Map<String, dynamic>> getTopics(int classId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/teacher/classes/$classId/topics'),
        headers: await _headers(),
      );
      final data = jsonDecode(response.body);

      return {
        'statusCode': response.statusCode,
        'success': data['success'] == true,
        'message': data['message'] ?? 'Gagal memuat daftar topik.',
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

  // Store: tambah topik baru
  Future<Map<String, dynamic>> createTopic({
    required int classId,
    required String name,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/teacher/classes/$classId/topics'),
        headers: await _headers(),
        body: jsonEncode({'name': name}),
      );
      final data = jsonDecode(response.body);

      return {
        'statusCode': response.statusCode,
        'success': data['success'] == true,
        'message': data['message'] ?? 'Gagal menambahkan topik.',
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
