import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monisa/app/modules/teacher/kelas/quiz/quiz_form/controllers/quiz_form_controller.dart';
import 'package:monisa/app/theme/app_colors.dart';
import 'package:monisa/app/theme/app_text.dart';

void showQuizQuestionListDialog(
  BuildContext context,
  QuizFormController controller,
) {
  Get.dialog(
    Dialog(
      backgroundColor: AppColors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppColors.black, width: 1),
      ),
      child: ConstrainedBox(
        constraints:
            BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Daftar soal', style: AppText.Header2),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: const Icon(Icons.close, size: 22),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                onChanged: controller.onQuestionSearchChanged,
                decoration: InputDecoration(
                  hintText: 'Cari',
                  hintStyle:
                      AppText.Body2.copyWith(color: AppColors.black.withOpacity(0.4)),
                  prefixIcon: const Icon(Icons.search, size: 22),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: const BorderSide(color: AppColors.black, width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: const BorderSide(color: AppColors.black, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: const BorderSide(color: AppColors.black, width: 1.4),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Flexible(
                child: Obx(() {
                  final filtered = controller.filteredQuestionIndexes;

                  if (filtered.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text('Belum ada soal.',
                          style: AppText.Body2, textAlign: TextAlign.center),
                    );
                  }

                  return ListView.separated(
                    shrinkWrap: true,
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, i) {
                      final index = filtered[i];
                      final q = controller.questions[index];
                      final isCurrentlyEditing = controller.editingQuestionIndex == index;

                      return GestureDetector(
                        onTap: () {
                          controller.openQuestionForEditing(index);
                          Get.back();
                        },
                        child: Container(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(color: AppColors.black, width: 1),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.drag_indicator, size: 20),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text('No. ${index + 1}',
                                            style: AppText.Body1_SemiBold),
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(50),
                                            border: Border.all(
                                                color: AppColors.black, width: 1),
                                          ),
                                          child: Text(q.type.shortLabel,
                                              style: AppText.Body2),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(q.preview,
                                        style: AppText.Body2,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis),
                                  ],
                                ),
                              ),
                              if (isCurrentlyEditing)
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
    ),
  );
}