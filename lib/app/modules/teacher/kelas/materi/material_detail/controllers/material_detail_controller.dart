import 'package:get/get.dart';
import 'package:monisa/app/data/services/teacher/teacher_materi_service.dart';

import 'package:monisa/app/modules/teacher/kelas/content_draft/controllers/teacher_content_draft_controller.dart' show TeacherContentDraft;
import 'package:monisa/app/routes/app_pages.dart';

class MaterialDetailController extends GetxController {
  final _service = TeacherMateriService();

  late final int classId;
  late final int materialId;

  final material = Rxn<TeacherContentDraft>();
  final isLoading = false.obs;
  final errorMessage = RxnString();
  final isDeleting = false.obs;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments as Map<String, dynamic>? ?? {};
    classId = args['classId'] as int? ?? 0;
    materialId = args['materialId'] as int? ?? 0;

    fetchDetail();
  }

  Future<void> fetchDetail() async {
    isLoading.value = true;
    errorMessage.value = null;

    final result = await _service.getMaterialDetail(
      classId: classId,
      materialId: materialId,
    );

    if (result['success'] == true) {
      try {
        material.value = TeacherContentDraft.fromJson(
            result['data'] as Map<String, dynamic>);
      } catch (e) {
        errorMessage.value = 'Format data materi tidak sesuai.';
      }
    } else {
      errorMessage.value = result['message']?.toString();
    }

    isLoading.value = false;
  }

  Future<void> onEditTap() async {
    final m = material.value;
    if (m == null) return;

    final result = await Get.toNamed(Routes.MATERIAL_FORM, arguments: {
      'classId': classId,
      'materialId': m.id,
      'title': m.title,
      'description': m.description,
      'topicId': m.topicId,
      'topicName': m.topicName,
      'files': m.files,
    });

    if (result == true) {
      fetchDetail(); // refresh setelah diedit
    }
  }

  Future<void> deleteMaterial() async {
    isDeleting.value = true;

    final result = await _service.deleteMaterial(
      classId: classId,
      materialId: materialId,
    );

    isDeleting.value = false;

    if (result['success'] == true) {
      Get.back(result: true); // kembali ke kelas_selected, minta refresh
      Get.snackbar('Berhasil', result['message']?.toString() ?? 'Materi dihapus.');
    } else {
      Get.snackbar('Gagal', result['message']?.toString() ?? 'Gagal menghapus materi.');
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
