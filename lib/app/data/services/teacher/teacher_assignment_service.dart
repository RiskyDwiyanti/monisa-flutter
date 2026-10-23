import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:monisa/app/config/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class TeacherAssignmentService {
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

  // Index: daftar siswa dalam kelas (untuk dialog "Pilih siswa")
  Future<Map<String, dynamic>> getStudents(int classId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/teacher/classes/$classId/students'),
        headers: await _headers(),
      );
      final data = jsonDecode(response.body);

      return {
        'statusCode': response.statusCode,
        'success': data['success'] == true,
        'message': data['message'] ?? 'Gagal memuat daftar siswa.',
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

  // Store: tambah tugas baru (multipart, karena ada upload file)
  Future<Map<String, dynamic>> createAssignment({
    required int classId,
    required int topicId,
    required String title,
    String? description,
    DateTime? deadline,
    required bool isPublished,
    required String assignTo, // 'all' | 'selected'
    List<int> studentIds = const [],
    int maxScore = 100,
    List<PlatformFile> files = const [],
  }) async {
    try {
      final token = await _getToken();

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/teacher/classes/$classId/assignments'),
      );

      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      request.fields['topic_id'] = '$topicId';
      request.fields['title'] = title;
      request.fields['max_score'] = '$maxScore';
      request.fields['is_published'] = isPublished ? '1' : '0';
      request.fields['assign_to'] = assignTo;

      if (description != null && description.isNotEmpty) {
        request.fields['description'] = description;
      }
      if (deadline != null) {
        request.fields['deadline'] = deadline.toIso8601String();
      }
      if (assignTo == 'selected') {
        for (var i = 0; i < studentIds.length; i++) {
          request.fields['student_ids[$i]'] = '${studentIds[i]}';
        }
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
        'message': data['message'] ?? 'Gagal menyimpan tugas.',
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

  // Update: edit tugas (judul/deskripsi/topik/deadline/assign_to/tambah file),
  Future<Map<String, dynamic>> updateAssignment({
    required int classId,
    required int assignmentId,
    required int topicId,
    required String title,
    String? description,
    DateTime? deadline,
    required bool isPublished,
    required String assignTo,
    List<int> studentIds = const [],
    int maxScore = 100,
    List<PlatformFile> newFiles = const [],
  }) async {
    try {
      final token = await _getToken();

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/teacher/classes/$classId/assignments/$assignmentId'),
      );

      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      request.fields['_method'] = 'PUT';
      request.fields['topic_id'] = '$topicId';
      request.fields['title'] = title;
      request.fields['max_score'] = '$maxScore';
      request.fields['is_published'] = isPublished ? '1' : '0';
      request.fields['assign_to'] = assignTo;

      if (description != null && description.isNotEmpty) {
        request.fields['description'] = description;
      }
      if (deadline != null) {
        request.fields['deadline'] = deadline.toIso8601String();
      }
      if (assignTo == 'selected') {
        for (var i = 0; i < studentIds.length; i++) {
          request.fields['student_ids[$i]'] = '${studentIds[i]}';
        }
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
        'message': data['message'] ?? 'Gagal memperbarui tugas.',
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

  // Hapus satu file tugas yang sudah tersimpan di server
  Future<Map<String, dynamic>> deleteAssignmentFile({
    required int classId,
    required int assignmentId,
    required int fileId,
  }) async {
    try {
      final response = await http.delete(
        Uri.parse(
            '$baseUrl/teacher/classes/$classId/assignments/$assignmentId/files/$fileId'),
        headers: await _headers(),
      );
      final data = jsonDecode(response.body);

      return {
        'statusCode': response.statusCode,
        'success': data['success'] == true,
        'message': data['message'] ?? 'Gagal menghapus file.',
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

  // Show: detail satu tugas
  Future<Map<String, dynamic>> getAssignmentDetail({
    required int classId,
    required int assignmentId,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/teacher/classes/$classId/assignments/$assignmentId'),
        headers: await _headers(),
      );
      final data = jsonDecode(response.body);

      return {
        'statusCode': response.statusCode,
        'success': data['success'] == true,
        'message': data['message'] ?? 'Gagal memuat detail tugas.',
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

  // Index: daftar pengumpulan siswa untuk satu tugas
  Future<Map<String, dynamic>> getSubmissions({
    required int classId,
    required int assignmentId,
  }) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$baseUrl/teacher/classes/$classId/assignments/$assignmentId/submissions'),
        headers: await _headers(),
      );
      final data = jsonDecode(response.body);

      return {
        'statusCode': response.statusCode,
        'success': data['success'] == true,
        'message': data['message'] ?? 'Gagal memuat pengumpulan siswa.',
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

  // Hapus tugas sepenuhnya
  Future<Map<String, dynamic>> deleteAssignment({
    required int classId,
    required int assignmentId,
  }) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/teacher/classes/$classId/assignments/$assignmentId'),
        headers: await _headers(),
      );
      final data = jsonDecode(response.body);

      return {
        'statusCode': response.statusCode,
        'success': data['success'] == true,
        'message': data['message'] ?? 'Gagal menghapus tugas.',
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