import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monisa/app/theme/app_colors.dart';
import 'package:monisa/app/theme/app_text.dart';

import '../../controllers/teacher_topic_picker_controller.dart';

/// Buka dialog "Daftar topik". Mengembalikan TopicOption yang dipilih
/// (baik dari list yang sudah ada, maupun topik baru yang baru dibuat),
/// atau null kalau dialog ditutup tanpa memilih.
Future<TopicOption?> openTeacherTopicPickerDialog(
  BuildContext context, {
  required int classId,
  int? selectedTopicId,
}) {
  final tag = 'topic_picker_$classId';

  Get.put(
    TeacherTopicPickerController(classId: classId, selectedTopicId: selectedTopicId),
    tag: tag,
  );

  return Get.dialog<TopicOption>(
    _TopicPickerDialog(tag: tag, classId: classId),
  ).whenComplete(() {
    Get.delete<TeacherTopicPickerController>(tag: tag);
  });
}

class _TopicPickerDialog extends StatelessWidget {
  final String tag;
  final int classId;

  const _TopicPickerDialog({required this.tag, required this.classId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TeacherTopicPickerController>(tag: tag);

    return Dialog(
      backgroundColor: AppColors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 36),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppColors.black, width: 1),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== HEADER (dengan garis bawah penuh) =====
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppColors.black, width: 1),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Daftar topik', style: AppText.Header2),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: const Icon(Icons.close, size: 22),
                  ),
                ],
              ),
            ),

            // ===== ISI =====
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ===== SEARCH =====
                    TextField(
                      onChanged: controller.onSearchChanged,
                      decoration: InputDecoration(
                        hintText: 'Cari',
                        hintStyle: AppText.Body2.copyWith(color: AppColors.black.withOpacity(0.8)),
                        prefixIcon: const Icon(Icons.search, size: 24),
                        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
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

                    // ===== TOMBOL TAMBAH TOPIK =====
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final newTopic =
                              await _openAddTopicDialog(context, classId);
                          if (newTopic != null) {
                            // Topik baru langsung dipilih & picker ditutup
                            Get.back(result: newTopic);
                          } else {
                            // Tidak jadi menambah -> refresh list, siapa tahu ada perubahan
                            controller.fetchTopics();
                          }
                        },
                        icon: const Icon(Icons.add, color: Colors.white),
                        label: Text(
                          'Tambah topik baru',
                          style: AppText.Body1_SemiBold.copyWith(color: AppColors.white),
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

                    // ===== LIST TOPIK =====
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

                        final topics = controller.filteredTopics;

                        if (topics.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Text(
                              'Belum ada topik.',
                              style: AppText.Body2,
                              textAlign: TextAlign.center,
                            ),
                          );
                        }

                        return ListView.separated(
                          shrinkWrap: true,
                          itemCount: topics.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final topic = topics[index];
                            final isSelected = topic.id == controller.selectedTopicId;

                            return GestureDetector(
                              onTap: () => Get.back(result: topic),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: AppColors.black, width: 1),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(topic.name, style: AppText.SubHeader_SemiBold),
                                    ),
                                    if (isSelected)
                                      const Icon(Icons.check, size: 20),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<TopicOption?> _openAddTopicDialog(BuildContext context, int classId) {
    final tag = 'topic_form_$classId';
    Get.put(TeacherTopicFormController(classId: classId), tag: tag);

    return Get.dialog<TopicOption>(
      _TopicFormDialog(tag: tag),
    ).whenComplete(() {
      Get.delete<TeacherTopicFormController>(tag: tag);
    });
  }
}

class _TopicFormDialog extends StatelessWidget {
  final String tag;

  const _TopicFormDialog({required this.tag});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TeacherTopicFormController>(tag: tag);

    return Dialog(
      backgroundColor: AppColors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppColors.black, width: 1),
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
                Text('Tambah topik', style: AppText.Header2),
                GestureDetector(
                  onTap: () => Get.back(),
                  child: const Icon(Icons.close, size: 22),
                ),
              ],
            ),
            const SizedBox(height: 16),

            TextField(
              controller: controller.namaC,
              decoration: InputDecoration(
                hintText: 'Masukkan nama topik ...',
                hintStyle: AppText.Body2
                    .copyWith(color: AppColors.black.withOpacity(0.4)),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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

            SizedBox(
              width: double.infinity,
              height: 52,
              child: Obx(() => ElevatedButton(
                    onPressed:
                        controller.isSubmitting.value ? null : controller.submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.Tangerine,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                        side: const BorderSide(color: AppColors.black, width: 1),
                      ),
                    ),
                    child: controller.isSubmitting.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text('Tambah',
                            style: AppText.Body1_SemiBold
                                .copyWith(color: AppColors.white)),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}