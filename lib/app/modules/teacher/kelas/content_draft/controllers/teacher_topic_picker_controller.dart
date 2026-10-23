import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monisa/app/data/services/teacher/teacher_topic_service.dart';

class TopicOption {
  final int id;
  final String name;
  final bool isActive;

  TopicOption({required this.id, required this.name, this.isActive = true});

  factory TopicOption.fromJson(Map<String, dynamic> json) {
    return TopicOption(
      id: json['id'] as int,
      name: (json['name'] ?? '-').toString(),
      isActive: json['is_active'] == true || json['is_active'] == 1,
    );
  }
}

// ===== CONTROLLER (Daftar topik) =====
class TeacherTopicPickerController extends GetxController {
  final _service = TeacherTopicService();

  final int classId;
  final int? selectedTopicId;

  TeacherTopicPickerController({required this.classId, this.selectedTopicId});

  final topics = <TopicOption>[].obs;
  final searchQuery = ''.obs;
  final isLoading = false.obs;
  final errorMessage = RxnString();

  List<TopicOption> get filteredTopics {
    if (searchQuery.value.trim().isEmpty) return topics;
    final q = searchQuery.value.trim().toLowerCase();
    return topics.where((e) => e.name.toLowerCase().contains(q)).toList();
  }

  @override
  void onInit() {
    super.onInit();
    fetchTopics();
  }

  Future<void> fetchTopics() async {
    isLoading.value = true;
    errorMessage.value = null;

    final result = await _service.getTopics(classId);

    if (result['success'] == true) {
      try {
        final data = result['data'] as Map<String, dynamic>;
        final list = (data['topics'] as List? ?? [])
            .map((e) => TopicOption.fromJson(e as Map<String, dynamic>))
            .toList();
        topics.assignAll(list);
      } catch (e) {
        errorMessage.value = 'Format data topik tidak sesuai.';
        debugPrint('Parse topics error: $e');
      }
    } else {
      errorMessage.value = result['message']?.toString();
    }

    isLoading.value = false;
  }

  void onSearchChanged(String value) => searchQuery.value = value;
}

class TeacherTopicFormController extends GetxController {
  final _service = TeacherTopicService();

  final int classId;
  TeacherTopicFormController({required this.classId});

  final namaC = TextEditingController();
  final isSubmitting = false.obs;

  @override
  void onClose() {
    namaC.dispose();
    super.onClose();
  }

  Future<void> submit() async {
    if (namaC.text.trim().isEmpty) {
      Get.snackbar('Lengkapi data', 'Nama topik wajib diisi.');
      return;
    }

    isSubmitting.value = true;

    final result = await _service.createTopic(
      classId: classId,
      name: namaC.text.trim(),
    );

    isSubmitting.value = false;

    if (result['success'] == true) {
      final topic = TopicOption.fromJson(result['data'] as Map<String, dynamic>);
      Get.back(result: topic);
    } else {
      Get.snackbar('Gagal', result['message']?.toString() ?? 'Terjadi kesalahan.');
    }
  }
}