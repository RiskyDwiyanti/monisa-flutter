import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monisa/app/data/services/teacher/teacher_materi_service.dart';
import 'package:monisa/app/modules/teacher/kelas/content_draft/controllers/teacher_content_draft_controller.dart' show MaterialFileRef;
import 'package:monisa/app/modules/teacher/kelas/content_draft/controllers/teacher_topic_picker_controller.dart' show TopicOption;
import 'package:monisa/app/modules/teacher/kelas/content_draft/views/widget/teacher_topic_picker_dialog.dart';

class MaterialFormController extends GetxController {
  final _service = TeacherMateriService();

  late final int classId;
  int? materialId; // null = mode tambah, terisi = mode edit

  final judulC = TextEditingController();
  final deskripsiC = TextEditingController();

  final selectedTopic = Rxn<TopicOption>();
  final pickedFiles = <PlatformFile>[].obs; // file baru yang mau ditambahkan
  final existingFiles = <MaterialFileRef>[].obs; // file yang sudah ada di server

  final isSubmitting = false.obs;
  final isSavingDraft = false.obs;

  bool _exitHandled = false;

  bool get isEditMode => materialId != null;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments as Map<String, dynamic>? ?? {};
    classId = args['classId'] as int? ?? 0;
    materialId = args['materialId'] as int?;

    // Pre-fill kalau mode edit (datang dari draft dialog)
    if (isEditMode) {
      judulC.text = (args['title'] ?? '').toString();
      deskripsiC.text = (args['description'] ?? '').toString();

      final topicId = args['topicId'] as int?;
      final topicName = args['topicName'] as String?;
      if (topicId != null && topicName != null) {
        selectedTopic.value = TopicOption(id: topicId, name: topicName);
      }

      final files = args['files'] as List? ?? [];
      existingFiles.assignAll(files.whereType<MaterialFileRef>());
    }
  }

  @override
  void onClose() {
    judulC.dispose();
    deskripsiC.dispose();
    super.onClose();
  }

  Future<void> onPickTopic(BuildContext context) async {
    final result = await openTeacherTopicPickerDialog(
      context,
      classId: classId,
      selectedTopicId: selectedTopic.value?.id,
    );
    if (result != null) {
      selectedTopic.value = result;
    }
  }

  Future<void> pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      withData: true,
      type: FileType.custom,
      allowedExtensions: [
        'pdf', 'ppt', 'pptx', 'doc', 'docx', 'xls', 'xlsx', 'txt',
        'jpg', 'jpeg', 'png',
      ],
    );

    if (result != null) {
      pickedFiles.addAll(result.files);
    }
  }

  void removeFile(PlatformFile file) {
    pickedFiles.remove(file);
  }

  bool get _isFormEmpty =>
      judulC.text.trim().isEmpty &&
      deskripsiC.text.trim().isEmpty &&
      pickedFiles.isEmpty;

  Future<void> submitPublish() async {
    if (judulC.text.trim().isEmpty) {
      Get.snackbar('Lengkapi data', 'Judul materi wajib diisi.');
      return;
    }
    if (selectedTopic.value == null) {
      Get.snackbar('Lengkapi data', 'Pilih topik terlebih dahulu.');
      return;
    }

    isSubmitting.value = true;

    final result = isEditMode
        ? await _service.updateMaterial(
            classId: classId,
            materialId: materialId!,
            topicId: selectedTopic.value!.id,
            title: judulC.text.trim(),
            description:
                deskripsiC.text.trim().isEmpty ? null : deskripsiC.text.trim(),
            isPublished: true,
            newFiles: pickedFiles,
          )
        : await _service.createMaterial(
            classId: classId,
            topicId: selectedTopic.value!.id,
            title: judulC.text.trim(),
            description:
                deskripsiC.text.trim().isEmpty ? null : deskripsiC.text.trim(),
            isPublished: true,
            files: pickedFiles,
          );

    isSubmitting.value = false;

    if (result['success'] == true) {
      _exitHandled = true;
      Get.back(result: true);
      Get.snackbar(
          'Berhasil', result['message']?.toString() ?? 'Materi dipublikasikan.');
    } else {
      Get.snackbar('Gagal', result['message']?.toString() ?? 'Terjadi kesalahan.');
    }
  }

  Future<void> handleExit() async {
    if (_exitHandled) {
      Get.back();
      return;
    }
    _exitHandled = true;

    // Mode edit: kalau tidak ada perubahan file baru dan field tidak diubah drastis,
    // tetap simpan sebagai draft (update, is_published tetap false) supaya progres tersimpan.
    if (!isEditMode && _isFormEmpty) {
      Get.back();
      return;
    }

    if (selectedTopic.value == null) {
      Get.back();
      return;
    }

    isSavingDraft.value = true;

    final result = isEditMode
        ? await _service.updateMaterial(
            classId: classId,
            materialId: materialId!,
            topicId: selectedTopic.value!.id,
            title: judulC.text.trim().isEmpty ? '(Tanpa judul)' : judulC.text.trim(),
            description:
                deskripsiC.text.trim().isEmpty ? null : deskripsiC.text.trim(),
            isPublished: false,
            newFiles: pickedFiles,
          )
        : await _service.createMaterial(
            classId: classId,
            topicId: selectedTopic.value!.id,
            title: judulC.text.trim().isEmpty ? '(Tanpa judul)' : judulC.text.trim(),
            description:
                deskripsiC.text.trim().isEmpty ? null : deskripsiC.text.trim(),
            isPublished: false,
            files: pickedFiles,
          );

    isSavingDraft.value = false;

    if (result['success'] == true) {
      Get.snackbar('Tersimpan', 'Materi disimpan sebagai draf.');
    }
    Get.back();
  }
}