import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monisa/app/routes/app_pages.dart';
import 'package:monisa/app/theme/app_colors.dart';
import 'package:monisa/app/theme/app_text.dart';

import '../../controllers/teacher_content_draft_controller.dart';

void openTeacherContentDraftDialog(
  BuildContext context, {
  required int classId,
  required String type, // 'material' | 'assignment' | 'quiz'
}) {
  final tag = '${type}_$classId';

  Get.put(
    TeacherContentDraftController(classId: classId, type: type),
    tag: tag,
  );

  Get.dialog(
    _TeacherContentDraftDialog(tag: tag, classId: classId, type: type),
  ).whenComplete(() {
    Get.delete<TeacherContentDraftController>(tag: tag);
  });
}

class _TeacherContentDraftDialog extends StatelessWidget {
  final String tag;
  final int classId;
  final String type;

  const _TeacherContentDraftDialog({
    required this.tag,
    required this.classId,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TeacherContentDraftController>(tag: tag);

    return Dialog(
      backgroundColor: AppColors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.black, width: 1),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(controller.title, style: AppText.Header2),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: const Icon(Icons.close, size: 22),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // ===== SEARCH =====
              TextField(
                onChanged: controller.onSearchChanged,
                decoration: InputDecoration(
                  hintText: 'Cari',
                  hintStyle: AppText.Body2
                      .copyWith(color: AppColors.black.withOpacity(0.4)),
                  prefixIcon: const Icon(Icons.search, size: 22),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppColors.black, width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppColors.black, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppColors.black, width: 1.4),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // ===== TOMBOL TAMBAH =====
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () => _onAddTap(context),
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: Text(
                    controller.addButtonLabel,
                    style:
                        AppText.Body1_SemiBold.copyWith(color: AppColors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.Tangerine,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: const BorderSide(color: AppColors.black, width: 1),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // ===== LIST DRAFT =====
              Flexible(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (controller.errorMessage.value != null) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        controller.errorMessage.value!,
                        style: AppText.Body2,
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  final drafts = controller.filteredDrafts;

                  if (drafts.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        'Belum ada draf.',
                        style: AppText.Body2,
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  return ListView.separated(
                    shrinkWrap: true,
                    itemCount: drafts.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final draft = drafts[index];
                      return _DraftCard(
                        draft: draft, 
                        onTap: () => _onDraftTap(context, draft),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onAddTap(BuildContext context) {
    Get.back(); // tutup dialog draft

    switch (type) {
      case 'assignment':
        try {
          Get.toNamed(Routes.ASSIGNMENT_FORM, arguments: {'classId': classId});
        } catch (e, s) {
          debugPrint('ERR: $e');
          debugPrint('STACK: $s');
        }
        break;
      case 'quiz':
        Get.toNamed(Routes.QUIZ_FORM, arguments: {
          'classId': classId,
        });
        break;
      case 'material':
      default:
        Get.toNamed(Routes.MATERIAL_FORM, arguments: {
          'classId': classId,
        });
    }
  }

  void _onDraftTap(BuildContext context, TeacherContentDraft draft) {
    Get.back(); // tutup dialog draft

    switch (type) {
      case 'material':
        Get.toNamed(Routes.MATERIAL_FORM, arguments: {
          'classId': classId,
          'materialId': draft.id,
          'title': draft.title,
          'description': draft.description,
          'topicId': draft.topicId,
          'topicName': draft.topicName,
          'files': draft.files, // List<MaterialFileRef>
        });
        break;
      case 'assignment':
        Get.toNamed(Routes.ASSIGNMENT_FORM, arguments: {
          'classId': classId,
          'assignmentId': draft.id,
          'title': draft.title,
          'description': draft.description,
          'topicId': draft.topicId,
          'topicName': draft.topicName,
          'files': draft.files,
          'deadline': draft.deadline,
          'assignTo': draft.assignTo,
          'students': draft.students,
          'maxScore': draft.maxScore, 
        });
        break;
      case 'quiz':
        Get.toNamed(Routes.QUIZ_FORM, arguments: {
          'classId': classId,
          'quizId': draft.id,
        });
        break;
    }
  }
}

class _DraftCard extends StatelessWidget {
  final TeacherContentDraft draft;
  final VoidCallback onTap;

  const _DraftCard({required this.draft, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.black, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(draft.title, style: AppText.Body1_SemiBold),
                  const SizedBox(height: 4),
                  Text(
                    (draft.description == null || draft.description!.isEmpty)
                        ? 'Description here.'
                        : draft.description!,
                    style: AppText.Body2,
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: AppColors.black, width: 1)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.access_time, size: 16),
                  const SizedBox(width: 6),
                  Text.rich(
                    TextSpan(
                      style: AppText.Body1_Regular,
                      children: [
                        const TextSpan(text: 'Terakhir diubah pada '),
                        TextSpan(
                          text: draft.lastEditedLabel,
                          style: AppText.Body1_SemiBold.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}