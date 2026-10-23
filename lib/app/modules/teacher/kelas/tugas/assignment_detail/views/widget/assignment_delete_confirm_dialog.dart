import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monisa/app/modules/teacher/kelas/tugas/assignment_detail/controllers/assignment_detail_controller.dart';
import 'package:monisa/app/theme/app_colors.dart';
import 'package:monisa/app/theme/app_text.dart';

void showAssignmentDeleteConfirmDialog(
  BuildContext context,
  AssignmentDetailController controller,
) {
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
            Text('Hapus tugas?', style: AppText.Header2),
            const SizedBox(height: 8),
            Text(
              'Hapus tugas secara permanen. Aksi ini tidak dapat dibatalkan.',
              style: AppText.Body2,
            ),
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
                      controller.deleteAssignment();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.Tangerine,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                        side: const BorderSide(color: AppColors.black, width: 1),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text('Hapus',
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