import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:monisa/app/modules/teacher/kelas/quiz/quiz_form/views/widget/quiz_exit_confirm_dialog.dart';
import 'package:monisa/app/modules/teacher/kelas/quiz/quiz_form/views/widget/quiz_image_picker_thumbnail.dart';
import 'package:monisa/app/modules/teacher/kelas/quiz/quiz_form/views/widget/quiz_question_list_dialog.dart';
import 'package:monisa/app/modules/teacher/kelas/quiz/quiz_form/views/widget/quiz_upload_confirm_dialog.dart';
import 'package:monisa/app/theme/app_colors.dart';
import 'package:monisa/app/theme/app_text.dart';

import '../controllers/quiz_form_controller.dart';

class QuizFormView extends GetView<QuizFormController> {
  const QuizFormView({super.key});
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _onBackPressed(context);
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: Obx(() {
            if (controller.isLoadingDetail.value) {
              return const Center(child: CircularProgressIndicator());
            }
            return Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: Column(
                      children: [
                        _buildQuestionCard(),
                        const SizedBox(height: 20),
                        _buildAddQuestionButton(),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  void _onBackPressed(BuildContext context) {
    if (controller.exitHandled) {
      Get.back();
      return;
    }

    final hasContent = controller.questions.isNotEmpty ||
        controller.pertanyaanC.text.trim().isNotEmpty;

    if (!hasContent) {
      controller.discardAndExit();
      return;
    }

    showQuizExitConfirmDialog(context, controller);
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _onBackPressed(context),
            child: const Icon(Icons.arrow_back, size: 26),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              controller.isEditMode ? 'Edit kuis' : 'Tambah kuis',
              style: AppText.Header1,
            ),
          ),
          GestureDetector(
            onTap: () => showQuizQuestionListDialog(context, controller),
            child: const Icon(Icons.format_list_bulleted, size: 24),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () => showQuizUploadConfirmDialog(context, controller),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.Tangerine,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.black, width: 1),
              ),
              child: const Icon(Icons.upload, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.black, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() {
            if (controller.editingQuestionIndex.value == null) {
              return const SizedBox.shrink();
            }
            return Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: controller.removeCurrentlyEditingQuestion,
                icon: const Icon(Icons.delete_outline, size: 18, color: Colors.red),
                label: const Text('Hapus pertanyaan ini',
                    style: TextStyle(color: Colors.red)),
              ),
            );
          }),

          _label('Pertanyaan'),
          _buildQuestionField(),
          const SizedBox(height: 20),

          _label('Tipe pertanyaan'),
          _buildTypeDropdown(),
          const SizedBox(height: 20),

          Obx(() {
            if (!controller.selectedType.value.hasOptions) {
              return const SizedBox.shrink();
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _label('Pilihan jawaban'),
                _buildOptionsList(),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: controller.addOption,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Tambah opsi'),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildQuestionField() {
    return TextField(
      controller: controller.pertanyaanC,
      maxLines: 3,
      decoration: InputDecoration(
        hintText: 'Masukkan pertanyaan ...',
        hintStyle: AppText.Body2.copyWith(color: AppColors.black.withOpacity(0.4)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        suffixIcon: Padding(
          padding: const EdgeInsets.all(8),
          child: buildImagePickerThumbnail(
            newImage: controller.questionImage,
            existingImageUrl: controller.questionExistingImageUrl,
            onPick: controller.pickQuestionImage,
            onRemove: controller.removeQuestionImage,
          ),
        ),
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
    );
  }

  Widget _buildTypeDropdown() {
    return Obx(() => Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: AppColors.black, width: 1),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<QuestionType>(
              value: controller.selectedType.value,
              isExpanded: true,
              onChanged: controller.onTypeChanged,
              items: QuestionType.values
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e.label, style: AppText.Body2),
                      ))
                  .toList(),
            ),
          ),
        ));
  }

  Widget _buildOptionsList() {
    return Obx(() => Column(
          children: controller.options.map((option) {
            final isSingle = controller.selectedType.value.isSingleAnswer;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => controller.onPickCorrect(option),
                    child: Obx(() => _buildSelector(
                          isSingle: isSingle,
                          selected: option.isCorrect.value,
                        )),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: option.optionC,
                      decoration: InputDecoration(
                        hintText: 'Masukkan opsi jawaban ...',
                        hintStyle: AppText.Body2
                            .copyWith(color: AppColors.black.withOpacity(0.4)),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.all(6),
                          child: buildImagePickerThumbnail(
                            newImage: option.image,
                            existingImageUrl: option.existingImageUrl,
                            onPick: () => controller.pickOptionImage(option),
                            onRemove: () => controller.removeOptionImage(option),
                            size: 32,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide:
                              const BorderSide(color: AppColors.black, width: 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide:
                              const BorderSide(color: AppColors.black, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide:
                              const BorderSide(color: AppColors.black, width: 1.4),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => controller.removeOption(option),
                    child: const Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Icon(Icons.close, size: 18),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ));
  }

  Widget _buildSelector({required bool isSingle, required bool selected}) {
    if (isSingle) {
      // Radio button
      return Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: selected ? AppColors.Tangerine : AppColors.black,
            width: 2,
          ),
        ),
        child: selected
            ? Center(
                child: Container(
                  width: 11,
                  height: 11,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.Tangerine,
                  ),
                ),
              )
            : null,
      );
    }
    // Checkbox
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: selected ? AppColors.Tangerine : AppColors.black,
          width: 2,
        ),
        color: selected ? AppColors.Tangerine : null,
      ),
      child: selected
          ? const Icon(Icons.check, size: 16, color: Colors.white)
          : null,
    );
  }

  Widget _buildAddQuestionButton() {
    return Obx(() {
      final isEditing = controller.editingQuestionIndex.value != null;

      return SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton.icon(
          onPressed: controller.addQuestion,
          icon: Icon(isEditing ? Icons.check : Icons.add, color: Colors.white),
          label: Text(
            isEditing ? 'Simpan perubahan soal' : 'Tambah pertanyaan',
            style: AppText.Body1_SemiBold.copyWith(color: AppColors.white),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.Tangerine,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
              side: const BorderSide(color: AppColors.black, width: 1),
            ),
          ),
        ),
      );
    });
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(text, style: AppText.Body1_SemiBold),
      );

}
