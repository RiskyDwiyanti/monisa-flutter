import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monisa/app/modules/teacher/kelas/quiz/quiz_form/controllers/quiz_form_controller.dart';
import 'package:monisa/app/theme/app_colors.dart';
import 'package:monisa/app/theme/app_text.dart';
import 'quiz_publish_form_dialog.dart';

void showQuizUploadConfirmDialog(
  BuildContext context,
  QuizFormController controller,
) {
  final hasContent =
      controller.questions.isNotEmpty || controller.pertanyaanC.text.trim().isNotEmpty;

  if (!hasContent) {
    Get.snackbar('Lengkapi data', 'Tambahkan minimal satu pertanyaan.');
    return;
  }

  Get.dialog(
    Dialog(
      backgroundColor: AppColors.white,
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
            Text('Unggah kuis?', style: AppText.Header2),
            const SizedBox(height: 8),
            Text('Pastikan soal dan jawaban sudah sesuai.', style: AppText.Body2),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                        side: const BorderSide(color: AppColors.black, width: 1),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text('Batal',
                        style: AppText.Body1_SemiBold.copyWith(color: AppColors.black)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                      showQuizPublishFormDialog(context, controller);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.Tangerine,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                        side: const BorderSide(color: AppColors.black, width: 1),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text('Unggah',
                        style: AppText.Body1_SemiBold.copyWith(color: AppColors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}