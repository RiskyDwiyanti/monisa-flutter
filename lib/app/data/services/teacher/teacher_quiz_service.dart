import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:monisa/app/config/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TeacherQuizService {
  static const String baseUrl = '${ApiConfig.baseUrl}';

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<Map<String, String>> _headers() async {
    final token = await _getToken();
    return {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // Index: daftar kuis dalam kelas (untuk dialog draft)
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

  // Show: detail kuis (untuk mode edit)
  Future<Map<String, dynamic>> getQuizDetail({
    required int classId,
    required int quizId,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/teacher/classes/$classId/quizzes/$quizId'),
        headers: await _headers(),
      );
      final data = jsonDecode(response.body);

      return {
        'statusCode': response.statusCode,
        'success': data['success'] == true,
        'message': data['message'] ?? 'Gagal memuat detail kuis.',
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

  // Store: simpan kuis baru + seluruh soal sekaligus (selalu draft, is_published: false)
  Future<Map<String, dynamic>> createQuiz({
    required int classId,
    int? topicId,
    String? title,
    String? description,
    DateTime? deadline,
    String? assignTo,
    List<int> studentIds = const [],
    required List<Map<String, dynamic>> questions,
  }) async {
    try {
      final token = await _getToken();

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/teacher/classes/$classId/quizzes'),
      );

      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      if (topicId != null) request.fields['topic_id'] = '$topicId';
      if (title != null) request.fields['title'] = title;
      if (description != null) request.fields['description'] = description;
      if (deadline != null) {
        request.fields['deadline'] = deadline.toIso8601String();
      }
      if (assignTo != null) request.fields['assign_to'] = assignTo;
      if (assignTo == 'selected') {
        for (var i = 0; i < studentIds.length; i++) {
          request.fields['student_ids[$i]'] = '${studentIds[i]}';
        }
      }

      _appendQuestions(request, questions);

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      final data = jsonDecode(response.body);

      return {
        'statusCode': response.statusCode,
        'success': data['success'] == true,
        'message': data['message'] ?? 'Gagal menyimpan kuis.',
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

  // Update: edit kuis + sinkronkan soal (create/update/delete lewat id), multipart + _method override
  Future<Map<String, dynamic>> updateQuiz({
    required int classId,
    required int quizId,
    int? topicId,
    String? title,
    String? description,
    DateTime? deadline,
    String? assignTo,
    List<int> studentIds = const [],
    required List<Map<String, dynamic>> questions,
  }) async {
    try {
      final token = await _getToken();

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/teacher/classes/$classId/quizzes/$quizId'),
      );

      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      request.fields['_method'] = 'PUT';

      if (topicId != null) request.fields['topic_id'] = '$topicId';
      if (title != null) request.fields['title'] = title;
      if (description != null) request.fields['description'] = description;
      if (deadline != null) {
        request.fields['deadline'] = deadline.toIso8601String();
      }
      if (assignTo != null) request.fields['assign_to'] = assignTo;
      if (assignTo == 'selected') {
        for (var i = 0; i < studentIds.length; i++) {
          request.fields['student_ids[$i]'] = '${studentIds[i]}';
        }
      }

      _appendQuestions(request, questions, withIds: true);

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      final data = jsonDecode(response.body);

      return {
        'statusCode': response.statusCode,
        'success': data['success'] == true,
        'message': data['message'] ?? 'Gagal memperbarui kuis.',
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

  void _appendQuestions(
    http.MultipartRequest request,
    List<Map<String, dynamic>> questions, {
    bool withIds = false,
  }) {
    for (var qi = 0; qi < questions.length; qi++) {
      final q = questions[qi];

      if (withIds && q['id'] != null) {
        request.fields['questions[$qi][id]'] = '${q['id']}';
      }
      request.fields['questions[$qi][question]'] = q['question'] as String;
      request.fields['questions[$qi][type]'] = q['type'] as String;
      if (q['remove_image'] == true) {
        request.fields['questions[$qi][remove_image]'] = '1';
      }

      final questionImage = q['image'] as PlatformFile?;
      if (questionImage?.bytes != null) {
        request.files.add(http.MultipartFile.fromBytes(
          'questions[$qi][image]',
          questionImage!.bytes!,
          filename: questionImage.name,
        ));
      }

      final options = (q['options'] as List?) ?? [];
      for (var oi = 0; oi < options.length; oi++) {
        final o = options[oi] as Map<String, dynamic>;

        if (withIds && o['id'] != null) {
          request.fields['questions[$qi][options][$oi][id]'] = '${o['id']}';
        }
        request.fields['questions[$qi][options][$oi][option]'] =
            o['option'] as String;
        request.fields['questions[$qi][options][$oi][is_correct]'] =
            (o['is_correct'] as bool) ? '1' : '0';
        if (o['remove_image'] == true) {
          request.fields['questions[$qi][options][$oi][remove_image]'] = '1';
        }

        final optionImage = o['image'] as PlatformFile?;
        if (optionImage?.bytes != null) {
          request.files.add(http.MultipartFile.fromBytes(
            'questions[$qi][options][$oi][image]',
            optionImage!.bytes!,
            filename: optionImage.name,
          ));
        }
      }
    }
  }

  // Hapus kuis sepenuhnya (dipanggil saat guru menekan "Hapus" di dialog keluar)
  Future<Map<String, dynamic>> deleteQuiz({
    required int classId,
    required int quizId,
  }) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/teacher/classes/$classId/quizzes/$quizId'),
        headers: await _headers(),
      );
      final data = jsonDecode(response.body);

      return {
        'statusCode': response.statusCode,
        'success': data['success'] == true,
        'message': data['message'] ?? 'Gagal menghapus kuis.',
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

  // Publish kuis yang sudah tersimpan
  Future<Map<String, dynamic>> publishQuiz({
    required int classId,
    required int quizId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/teacher/classes/$classId/quizzes/$quizId/publish'),
        headers: await _headers(),
      );
      final data = jsonDecode(response.body);

      return {
        'statusCode': response.statusCode,
        'success': data['success'] == true,
        'message': data['message'] ?? 'Gagal mempublikasikan kuis.',
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