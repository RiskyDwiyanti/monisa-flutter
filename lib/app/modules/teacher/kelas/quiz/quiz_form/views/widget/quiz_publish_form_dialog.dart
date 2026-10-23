import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:monisa/app/modules/teacher/kelas/quiz/quiz_form/controllers/quiz_form_controller.dart';
import 'package:monisa/app/theme/app_colors.dart';
import 'package:monisa/app/theme/app_text.dart';

import 'package:monisa/app/modules/teacher/kelas/tugas/assignment_form/controllers/assignment_form_controller.dart'
    show AssignTarget, AssignTargetX;

void showQuizPublishFormDialog(
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
            BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Unggah kuis', style: AppText.Header2),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: const Icon(Icons.close, size: 22),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text('Judul', style: AppText.Body1_SemiBold),
              const SizedBox(height: 8),
              TextField(
                controller: controller.judulC,
                decoration: _inputDecoration('Masukkan judul ...'),
              ),
              const SizedBox(height: 16),
              Text('Deskripsi', style: AppText.Body1_SemiBold),
              const SizedBox(height: 8),
              TextField(
                controller: controller.deskripsiC,
                maxLines: 3,
                decoration: _inputDecoration('Masukkan deskripsi ...'),
              ),
              const SizedBox(height: 16),
              Text('Tenggat', style: AppText.Body1_SemiBold),
              const SizedBox(height: 8),
              _buildDeadlineRow(context, controller),
              const SizedBox(height: 16),
              Text('Tugaskan untuk', style: AppText.Body1_SemiBold),
              const SizedBox(height: 8),
              _buildAssignTargetDropdown(context, controller),
              const SizedBox(height: 16),
              Text('Topik', style: AppText.Body1_SemiBold),
              const SizedBox(height: 8),
              _buildTopicRow(context, controller),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: Obx(() => ElevatedButton(
                      onPressed: controller.isSubmittingPublish.value
                          ? null
                          : controller.publishQuiz,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.Tangerine,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                          side: const BorderSide(color: AppColors.black, width: 1),
                        ),
                      ),
                      child: controller.isSubmittingPublish.value
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white),
                            )
                          : Text('Unggah kuis',
                              style: AppText.Body1_SemiBold
                                  .copyWith(color: AppColors.white)),
                    )),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

InputDecoration _inputDecoration(String hint) {
  return InputDecoration(
    hintText: hint,
    hintStyle: AppText.Body2.copyWith(color: AppColors.black.withOpacity(0.4)),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
  );
}

Widget _buildDeadlineRow(
    BuildContext context, QuizFormController controller) {
  return Obx(() {
    final value = controller.deadline.value;
    final text = value == null ? 'XX-XX-XXXX' : DateFormat('dd-MM-yyyy').format(value);

    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => controller.pickDeadline(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.black, width: 1),
              ),
              child: Text(
                text,
                style: AppText.Body2.copyWith(
                  color: value == null
                      ? AppColors.black.withOpacity(0.4)
                      : AppColors.black,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: () => controller.pickDeadline(context),
          child: Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.Tangerine,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.black, width: 1),
            ),
            child: const Icon(Icons.calendar_today, color: Colors.white, size: 20),
          ),
        ),
      ],
    );
  });
}

Widget _buildAssignTargetDropdown(
    BuildContext context, QuizFormController controller) {
  return Obx(() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: AppColors.black, width: 1),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<AssignTarget>(
                value: controller.assignTarget.value,
                isExpanded: true,
                hint: Text('Pilih tujuan', style: AppText.Body2),
                onChanged: (value) =>
                    controller.onAssignTargetChanged(value, context),
                items: AssignTarget.values
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e.label, style: AppText.Body2),
                        ))
                    .toList(),
              ),
            ),
          ),
          if (controller.assignTarget.value == AssignTarget.pilihSiswa &&
              controller.selectedStudents.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              '${controller.selectedStudents.length} siswa dipilih: '
              '${controller.selectedStudents.map((e) => e.name).join(', ')}',
              style: AppText.Body2,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ));
}

Widget _buildTopicRow(BuildContext context, QuizFormController controller) {
  return Obx(() => GestureDetector(
        onTap: () => controller.onPickTopic(context),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: AppColors.black, width: 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  controller.selectedTopic.value?.name ?? 'Pilih topik',
                  style: AppText.Body2.copyWith(
                    color: controller.selectedTopic.value == null
                        ? AppColors.black.withOpacity(0.4)
                        : AppColors.black,
                  ),
                ),
              ),
              const Icon(Icons.keyboard_arrow_down, size: 20),
            ],
          ),
        ),
      ));
}