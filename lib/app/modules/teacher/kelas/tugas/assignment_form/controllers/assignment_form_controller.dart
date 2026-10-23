import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:monisa/app/data/services/teacher/teacher_assignment_service.dart';
import 'package:monisa/app/modules/teacher/kelas/content_draft/controllers/teacher_topic_picker_controller.dart' show TopicOption;
import 'package:monisa/app/modules/teacher/kelas/content_draft/views/widget/teacher_topic_picker_dialog.dart';
import 'package:monisa/app/modules/teacher/kelas/content_draft/controllers/teacher_student_picker_controller.dart' show StudentOption;
import 'package:monisa/app/modules/teacher/kelas/content_draft/views/widget/teacher_student_picker_dialog.dart';
import 'package:monisa/app/modules/teacher/kelas/content_draft/controllers/teacher_content_draft_controller.dart' show AssignedStudentRef, MaterialFileRef;

enum AssignTarget { semua, pilihSiswa }

extension AssignTargetX on AssignTarget {
  String get label => this == AssignTarget.semua ? 'Semua' : 'Pilih siswa';
  String get apiValue => this == AssignTarget.semua ? 'all' : 'selected';

  static AssignTarget fromApiValue(String? value) {
    return value == 'selected' ? AssignTarget.pilihSiswa : AssignTarget.semua;
  }
}

class AssignmentFormController extends GetxController {
  final _service = TeacherAssignmentService();

  late final int classId;
  int? assignmentId;

  final judulC = TextEditingController();
  final deskripsiC = TextEditingController();

  final selectedTopic = Rxn<TopicOption>();
  final deadline = Rxn<DateTime>();
  final assignTarget = AssignTarget.semua.obs;
  final selectedStudents = <StudentOption>[].obs;

  final pickedFiles = <PlatformFile>[].obs;
  final existingFiles = <MaterialFileRef>[].obs;
  final isDeletingFile = false.obs;

  final isSubmitting = false.obs;
  final isSavingDraft = false.obs;

  bool _exitHandled = false;
  bool get isEditMode => assignmentId != null;
  
  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments as Map<String, dynamic>? ?? {};
    classId = args['classId'] as int? ?? 0;
    assignmentId = args['assignmentId'] as int?;

    if (isEditMode) {
      judulC.text = (args['title'] ?? '').toString();
      deskripsiC.text = (args['description'] ?? '').toString();

      final topicId = args['topicId'] as int?;
      final topicName = args['topicName'] as String?;
      if (topicId != null && topicName != null) {
        selectedTopic.value = TopicOption(id: topicId, name: topicName);
      }

      deadline.value = args['deadline'] as DateTime?;

      assignTarget.value = AssignTargetX.fromApiValue(args['assignTo'] as String?);

      final students = args['students'] as List? ?? [];
      selectedStudents.assignAll(
        students.whereType<AssignedStudentRef>().map(
              (e) => StudentOption(id: e.id, name: e.name),
            ),
      );

      final files = args['files'] as List? ?? [];
      existingFiles.assignAll(files.whereType<MaterialFileRef>());
    }
  }

  @override
  void onReady() {
    super.onReady();
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

  Future<void> pickDeadline(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: deadline.value ?? now,
      firstDate: now.subtract(const Duration(days: 1)),
      lastDate: DateTime(now.year + 2),
    );
    if (picked != null) {
      deadline.value = picked;
    }
  }

  Future<void> onAssignTargetChanged(AssignTarget? value, BuildContext context) async {
    if (value == null) return;

    if (value == AssignTarget.pilihSiswa) {
      final result = await openTeacherStudentPickerDialog(
        context,
        classId: classId,
        initialSelectedIds: selectedStudents.map((e) => e.id).toList(),
      );

      if (result != null) {
        selectedStudents.assignAll(result);
        assignTarget.value = AssignTarget.pilihSiswa;
      }
      // kalau result null (dibatalkan), assignTarget tidak berubah
      return;
    }

    // pilih "Semua" -> kosongkan daftar siswa terpilih
    selectedStudents.clear();
    assignTarget.value = value;
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
      // Laravel membatasi maksimal 3 file untuk tugas
      final remaining = 3 - pickedFiles.length;
      if (remaining <= 0) {
        Get.snackbar('Batas file', 'Maksimal 3 file untuk setiap tugas.');
        return;
      }
      pickedFiles.addAll(result.files.take(remaining));
      if (result.files.length > remaining) {
        Get.snackbar('Batas file', 'Maksimal 3 file untuk setiap tugas.');
      }
    }
  }

  void removeFile(PlatformFile file) {
    pickedFiles.remove(file);
  }

  bool isImageFile(PlatformFile file) {
    final ext = file.extension?.toLowerCase() ?? '';
    return ['jpg', 'jpeg', 'png'].contains(ext);
  }

  Uint8List? imageBytesOf(PlatformFile file) => file.bytes;

  bool get _isFormEmpty =>
      judulC.text.trim().isEmpty &&
      deskripsiC.text.trim().isEmpty &&
      pickedFiles.isEmpty;

  // Hapus file saat edit
  Future<void> removeExistingFile(MaterialFileRef file) async {
    if (!isEditMode) return; // jaga-jaga, harusnya hanya muncul di mode edit

    isDeletingFile.value = true;

    final result = await _service.deleteAssignmentFile(
      classId: classId,
      assignmentId: assignmentId!,
      fileId: file.id,
    );

    isDeletingFile.value = false;

    if (result['success'] == true) {
      existingFiles.remove(file);
    } else {
      Get.snackbar('Gagal', result['message']?.toString() ?? 'Gagal menghapus file.');
    }
  }

  /// "Unggah tugas" -> langsung publish.
  Future<void> submitPublish() async {
    if (judulC.text.trim().isEmpty) {
      Get.snackbar('Lengkapi data', 'Judul tugas wajib diisi.');
      return;
    }
    if (selectedTopic.value == null) {
      Get.snackbar('Lengkapi data', 'Pilih topik terlebih dahulu.');
      return;
    }
    if (assignTarget.value == AssignTarget.pilihSiswa && selectedStudents.isEmpty) {
      Get.snackbar('Lengkapi data', 'Pilih minimal satu siswa.');
      return;
    }

    isSubmitting.value = true;

    final result = isEditMode
        ? await _service.updateAssignment(
            classId: classId,
            assignmentId: assignmentId!,
            topicId: selectedTopic.value!.id,
            title: judulC.text.trim(),
            description:
                deskripsiC.text.trim().isEmpty ? null : deskripsiC.text.trim(),
            deadline: deadline.value,
            isPublished: true,
            assignTo: assignTarget.value.apiValue,
            studentIds: selectedStudents.map((e) => e.id).toList(),
            newFiles: pickedFiles,
          )

        : await _service.createAssignment(
            classId: classId,
            topicId: selectedTopic.value!.id,
            title: judulC.text.trim(),
            description:
                deskripsiC.text.trim().isEmpty ? null : deskripsiC.text.trim(),
            deadline: deadline.value,
            isPublished: true,
            assignTo: assignTarget.value.apiValue,
            studentIds: selectedStudents.map((e) => e.id).toList(),
            files: pickedFiles,
          );

    isSubmitting.value = false;

    if (result['success'] == true) {
      _exitHandled = true;
      Get.back(result: true);
      Get.snackbar('Berhasil', result['message']?.toString() ?? 'Tugas dipublikasikan.');
    } else {
      Get.snackbar('Gagal', result['message']?.toString() ?? 'Terjadi kesalahan.');
    }
  }

  /// Keluar tanpa publish -> simpan sebagai draft (is_published: false).
  Future<void> handleExit() async {
    if (_exitHandled) {
      Get.back();
      return;
    }
    _exitHandled = true;

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
        ? await _service.updateAssignment(
            classId: classId,
            assignmentId: assignmentId!,
            topicId: selectedTopic.value!.id,
            title:
                judulC.text.trim().isEmpty ? '(Tanpa judul)' : judulC.text.trim(),
            description:
                deskripsiC.text.trim().isEmpty ? null : deskripsiC.text.trim(),
            deadline: deadline.value,
            isPublished: false,
            assignTo: assignTarget.value.apiValue,
            studentIds: selectedStudents.map((e) => e.id).toList(),
            newFiles: pickedFiles,
          )
        : await _service.createAssignment(
            classId: classId,
            topicId: selectedTopic.value!.id,
            title:
                judulC.text.trim().isEmpty ? '(Tanpa judul)' : judulC.text.trim(),
            description:
                deskripsiC.text.trim().isEmpty ? null : deskripsiC.text.trim(),
            deadline: deadline.value,
            isPublished: false,
            assignTo: assignTarget.value.apiValue,
            studentIds: selectedStudents.map((e) => e.id).toList(),
            files: pickedFiles,
          );

    isSavingDraft.value = false;

    if (result['success'] == true) {
      Get.snackbar('Tersimpan', 'Tugas disimpan sebagai draf.');
    }
    Get.back();
  }
}
