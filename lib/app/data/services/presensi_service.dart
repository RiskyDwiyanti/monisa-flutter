import 'dart:convert';
import 'dart:typed_data';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PresensiService {
  static const String baseUrl = 'http://127.0.0.1:8000/api';

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

  // Index
  Future<Map<String, dynamic>> getAttendances({
    required int year,
    required int month,
  }) async {
    try {
      final headers = await _headers();
      print('GET headers: $headers'); // debug

      final response = await http.get(
        Uri.parse('$baseUrl/student/attendances?year=$year&month=$month'),
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

  // Hadir
  Future<Map<String, dynamic>> submitHadir({
    required String qrCode,
  }) async {
    try {
      final headers = await _headers();

      final response = await http.post(
        Uri.parse('$baseUrl/student/attendances'),
        headers: headers,
        body: jsonEncode({
          'qr_code': qrCode,
          'status': 'hadir',
        }),
      );

      final data = jsonDecode(response.body);

      return {
        'statusCode': response.statusCode,
        'success': data['success'] == true,
        'message': data['message'] ?? 'Presensi gagal.',
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

  // Izin / sakit 
  Future<Map<String, dynamic>> submitIzinSakit({
    required String status,
    required Uint8List lampiranBytes,
    required String fileName,
    String? keterangan,
  }) async {
    try {
      final token = await _getToken();

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/student/attendances'),
      );

      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      request.fields['status'] = status;

      if (keterangan != null && keterangan.isNotEmpty) {
        request.fields['keterangan'] = keterangan;
      }

      request.files.add(
        http.MultipartFile.fromBytes(
          'lampiran',
          lampiranBytes,
          filename: fileName,
        ),
      );

      final streamedResponse = await request.send();

      final response = await http.Response.fromStream(
        streamedResponse,
      );

      final data = jsonDecode(response.body);

      return {
        'statusCode': response.statusCode,
        'success': data['success'] == true,
        'message': data['message'] ?? 'Presensi gagal.',
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

  // Presensi siswa untuk guru berdasarkan jadwal
  Future<Map<String, dynamic>> getTeacherAttendances() async {
    try {
      final headers = await _headers();

      final response = await http.get(
        Uri.parse(
          '$baseUrl/teacher/attendances',
        ),
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

  // Presensi siswa untuk orang tua 
  Future<Map<String, dynamic>> getParentAttendances({
    required int year,
    required int month,
  }) async {
    try {
      final headers = await _headers();
      print('GET headers: $headers'); // debug

      final response = await http.get(
        Uri.parse('$baseUrl/parent/attendances?year=$year&month=$month'),
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

  // Presensi terbaru untuk wali
  Future<Map<String, dynamic>> getLatestParentAttendance() async {
    try {
      final headers = await _headers();

      final response = await http.get(
        Uri.parse(
          '$baseUrl/parent/attendances/latest',
        ),
        headers: headers,
      );

      final data = jsonDecode(response.body);

      return {
        'statusCode': response.statusCode,
        'success': data['success'] == true,
        'message': data['message'] ?? 'Gagal memuat presensi terbaru.',
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