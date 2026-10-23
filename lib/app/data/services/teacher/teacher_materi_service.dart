import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:monisa/app/config/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class TeacherMateriService {
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

  Future<bool> isLoggedIn() async {
    final token = await _getToken();
    return token != null && token.isNotEmpty;
  }

  // Index: isi kelas digital (topics + materi/tugas)
  Future<Map<String, dynamic>> getClassContents(int classId) async {
    try {
      final headers = await _headers();
      print('GET headers: $headers'); // debug

      final response = await http.get(
        Uri.parse('$baseUrl/teacher/classes/$classId/contents'),
        headers: headers,
      );
      final data = jsonDecode(response.body);

      return {
        'statusCode': response.statusCode,
        'success': data['success'] == true,
        'message': data['message'] ?? 'Gagal memuat isi kelas.',
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

  // Index: daftar materi dalam kelas (untuk modal draft materi)
Future<Map<String, dynamic>> getMaterials(int classId) async {
    try {
      final headers = await _headers();

      final response = await http.get(
        Uri.parse('$baseUrl/teacher/classes/$classId/materials'),
        headers: headers,
      );
      final data = jsonDecode(response.body);

      return {
        'statusCode': response.statusCode,
        'success': data['success'] == true,
        'message': data['message'] ?? 'Gagal memuat daftar materi.',
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

  // Index: daftar tugas dalam kelas (untuk modal draft)
  Future<Map<String, dynamic>> getAssignments(int classId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/teacher/classes/$classId/assignments'),
        headers: await _headers(),
      );
      final data = jsonDecode(response.body);

      return {
        'statusCode': response.statusCode,
        'success': data['success'] == true,
        'message': data['message'] ?? 'Gagal memuat daftar tugas.',
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

  // TODO: ganti ke endpoint asli saat API Kuis sudah dibuat
  Future<Map<String, dynamic>> getQuizzes(int classId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/teacher/classes/$classId/quizzes'),
        headers: await _headers(),
      );
      final data = jsonDecode(response.body);

      return {
        'statusCode': response.statusCode,
        'success': data['success'] == true,
        'message': data['message'] ?? 'Gagal memuat daftar kuis.',
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

  // Store: tambah materi baru (multipart, karena ada upload file)
  Future<Map<String, dynamic>> createMaterial({
    required int classId,
    required int topicId,
    required String title,
    String? description,
    required bool isPublished,
    List<PlatformFile> files = const [],
  }) async {
    try {
      final token = await _getToken();

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/teacher/classes/$classId/materials'),
      );

      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      request.fields['topic_id'] = '$topicId';
      request.fields['title'] = title;
      request.fields['is_published'] = isPublished ? '1' : '0';
      if (description != null && description.isNotEmpty) {
        request.fields['description'] = description;
      }

      for (final file in files) {
        if (file.bytes != null) {
          request.files.add(http.MultipartFile.fromBytes(
            'files[]',
            file.bytes!,
            filename: file.name,
          ));
        }
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      final data = jsonDecode(response.body);

      return {
        'statusCode': response.statusCode,
        'success': data['success'] == true,
        'message': data['message'] ?? 'Gagal menyimpan materi.',
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

  // Show: detail satu materi
  Future<Map<String, dynamic>> getMaterialDetail({
    required int classId,
    required int materialId,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/teacher/classes/$classId/materials/$materialId'),
        headers: await _headers(),
      );
      final data = jsonDecode(response.body);

      return {
        'statusCode': response.statusCode,
        'success': data['success'] == true,
        'message': data['message'] ?? 'Gagal memuat detail materi.',
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

  // Update: edit materi (judul/deskripsi/topik/tambah file), multipart + _method override
  Future<Map<String, dynamic>> updateMaterial({
    required int classId,
    required int materialId,
    required int topicId,
    required String title,
    String? description,
    required bool isPublished,
    List<PlatformFile> newFiles = const [],
  }) async {
    try {
      final token = await _getToken();

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/teacher/classes/$classId/materials/$materialId'),
      );

      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      request.fields['_method'] = 'PUT';
      request.fields['topic_id'] = '$topicId';
      request.fields['title'] = title;
      request.fields['is_published'] = isPublished ? '1' : '0';
      if (description != null && description.isNotEmpty) {
        request.fields['description'] = description;
      }

      for (final file in newFiles) {
        if (file.bytes != null) {
          request.files.add(http.MultipartFile.fromBytes(
            'files[]',
            file.bytes!,
            filename: file.name,
          ));
        }
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      final data = jsonDecode(response.body);

      return {
        'statusCode': response.statusCode,
        'success': data['success'] == true,
        'message': data['message'] ?? 'Gagal memperbarui materi.',
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

  // Hapus materi sepenuhnya
  Future<Map<String, dynamic>> deleteMaterial({
    required int classId,
    required int materialId,
  }) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/teacher/classes/$classId/materials/$materialId'),
        headers: await _headers(),
      );
      final data = jsonDecode(response.body);

      return {
        'statusCode': response.statusCode,
        'success': data['success'] == true,
        'message': data['message'] ?? 'Gagal menghapus materi.',
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