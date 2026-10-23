import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:monisa/app/theme/app_colors.dart';
import 'package:monisa/app/theme/app_text.dart';

import '../controllers/material_form_controller.dart';

class MaterialFormView extends GetView<MaterialFormController> {
  const MaterialFormView({super.key});
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        controller.handleExit();
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: _buildCard(context),
                ),
              ),
            ],
          ),
        ),
      ), 
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      child: Row(
        children: [
          GestureDetector(
            onTap: controller.handleExit,
            child: const Icon(Icons.arrow_back, size: 26),
          ),
          const SizedBox(width: 16),
          Text('Tambah materi', style: AppText.Header1),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.black, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label('Judul'),
          _textField(controller.judulC, 'Masukkan judul ...'),
          const SizedBox(height: 20),

          _label('Deskripsi'),
          _textArea(controller.deskripsiC, 'Masukkan deskripsi ...'),
          const SizedBox(height: 20),

          _label('Unggah file'),
          _buildFileUploader(),
          const SizedBox(height: 20),

          _label('Topik'),
          _buildTopicPicker(context),

          const SizedBox(height: 28),
          const Divider(height: 1, color: AppColors.black),
          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: Obx(() => ElevatedButton(
                  onPressed: controller.isSubmitting.value
                      ? null
                      : controller.submitPublish,
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
                      : Text('Unggah materi',
                          style: AppText.Body1_SemiBold
                              .copyWith(color: AppColors.white)),
              )),
          ),
        ],
      ),
    );
  }

  Widget _buildFileUploader() {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (controller.existingFiles.isNotEmpty) ...[
            ...controller.existingFiles.map((file) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.black, width: 1),
                      color: AppColors.black.withOpacity(0.03),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.insert_drive_file, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            file.originalName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppText.Body2,
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
            const SizedBox(height: 8),
          ],
          GestureDetector(
            onTap: controller.pickFiles,
            child: Container(
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.black, width: 1),
              ),
              child: const Center(
                child: Icon(Icons.add, size: 28),
              ),
            ),
          ),
          if (controller.pickedFiles.isNotEmpty) ...[
            const SizedBox(height: 12),
            ...controller.pickedFiles.map((file) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.black, width: 1),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.insert_drive_file, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            file.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppText.Body2,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => controller.removeFile(file),
                          child: const Icon(Icons.close, size: 18),
                        ),
                      ],
                    ),
                  ),
                )),
          ],
        ],
      );
    });
  }
  
  Widget _buildTopicPicker(BuildContext context) {
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

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(text, style: AppText.Body1_SemiBold),
      );

  Widget _textField(TextEditingController c, String hint) {
    return TextField(controller: c, decoration: _inputDecoration(hint));
  }

  Widget _textArea(TextEditingController c, String hint) {
    return TextField(
      controller: c,
      maxLines: 3,
      decoration: _inputDecoration(hint),
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

}
