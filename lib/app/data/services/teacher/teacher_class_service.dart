import 'dart:convert';

import 'package:monisa/app/config/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class TeacherClassService {
  static const String baseUrl = '${ApiConfig.baseUrl}';

  /// Ambil token Sanctum dari SharedPreferences
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

  // Index: daftar kelas milik guru
  Future<Map<String, dynamic>> getClasses() async {
    try {
      final headers = await _headers();
      print('GET headers: $headers'); // debug

      final response = await http.get(
        Uri.parse('$baseUrl/teacher/classes'),
        headers: headers,
      );
      final data = jsonDecode(response.body);

      return {
        'statusCode': response.statusCode,
        'success': data['success'] == true,
        'message': data['message'] ?? 'Gagal memuat data presensi.',
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

  // Daftar mapel yang diajar guru
  Future<Map<String, dynamic>> getMapelOptions() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/teacher/classes/mapel_options'),
        headers: await _headers(),
      );

      final data = jsonDecode(response.body);

      return {
        'statusCode': response.statusCode,
        'success': data['success'] == true,
        'message': data['message'] ?? 'Gagal memuat daftar mapel.',
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

  // Option: rombel berdasarkan mapel & tahun ajaran
  Future<Map<String, dynamic>> getOptions({
    required int schoolMapelId,
    required String tahunAjaran,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/teacher/classes/options').replace(
        queryParameters: {
          'school_mapel_id': '$schoolMapelId',
          'tahun_ajaran': tahunAjaran,
        },
      );

      final response = await http.get(uri, headers: await _headers());

      final data = jsonDecode(response.body);

      return {
        'statusCode': response.statusCode,
        'success': data['success'] == true,
        'message': data['message'] ?? 'Gagal memuat daftar mapel.',
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

  // Store: buat kelas digital
  Future<Map<String, dynamic>> createClass({
    required int rombelId,
    required int schoolMapelId,
    required String name,
    required String tahunAjaran,
    String? description,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/teacher/classes'),
        headers: await _headers(),
        body: jsonEncode({
          'rombel_id': rombelId,
          'school_mapel_id': schoolMapelId,
          'name': name,
          'tahun_ajaran': tahunAjaran,
          'description': description,
        }),
      );

      final data = jsonDecode(response.body);

      return {
        'statusCode': response.statusCode,
        'success': data['success'] == true,
        'message': data['message'] ?? 'Gagal memuat daftar mapel.',
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
