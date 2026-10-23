import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:monisa/app/theme/app_colors.dart';
import 'package:monisa/app/theme/app_text.dart';

import '../controllers/assignment_form_controller.dart';

class AssignmentFormView extends GetView<AssignmentFormController> {
  const AssignmentFormView({super.key});

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
          Text('Tambah tugas', style: AppText.Header1),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.black, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _label('Judul'),
                _textField(controller.judulC, 'Masukkan judul ...'),
                const SizedBox(height: 20),

                _label('Deskripsi'),
                _textArea(controller.deskripsiC, 'Masukkan deskripsi ...'),
                const SizedBox(height: 20),

                _buildDeadlineRow(context),
                const SizedBox(height: 20),

                _label('Unggah file'),
                _buildFileUploader(),
                const SizedBox(height: 20),

                _buildAssignTargetRow(context),
                const SizedBox(height: 20),

                _label('Topik'),
                _buildTopicPicker(context),
              ],
            ),
          ),

          // Garis selebar card
          const Divider(height: 1, thickness: 1, color: AppColors.black),

          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: Obx(() => ElevatedButton(
                    onPressed: controller.isSubmitting.value
                        ? null
                        : controller.submitPublish,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.Tangerine,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: const BorderSide(
                            color: AppColors.black, width: 1),
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
                        : Text(
                            controller.isEditMode
                                ? 'Publikasikan tugas'
                                : 'Unggah tugas',
                            style: AppText.Body1_SemiBold
                                .copyWith(color: AppColors.white),
                          ),
                  )),
            ),
          ),
        ],
      ),
    );
  }

  // ===== TENGGAT (label + field + tombol kalender dalam satu baris) =====
  Widget _buildDeadlineRow(BuildContext context) {
    return Obx(() {
      final value = controller.deadline.value;
      final text =
          value == null ? 'XX-XX-XXXX' : DateFormat('dd-MM-yyyy').format(value);

      return Row(
        children: [
          Text('Tenggat', style: AppText.Body1_SemiBold),
          const SizedBox(width: 16),
          Expanded(
            child: GestureDetector(
              onTap: () => controller.pickDeadline(context),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
              child: const Icon(Icons.calendar_today,
                  color: Colors.white, size: 20),
            ),
          ),
        ],
      );
    });
  }

  // ===== UNGGAH FILE =====
  bool _isImageName(String name) {
    final n = name.toLowerCase();
    return n.endsWith('.png') ||
        n.endsWith('.jpg') ||
        n.endsWith('.jpeg') ||
        n.endsWith('.gif') ||
        n.endsWith('.webp');
  }

  Widget _fileIconPlaceholder() => Container(
        color: AppColors.black.withOpacity(0.05),
        child: const Center(child: Icon(Icons.insert_drive_file, size: 28)),
      );

  Widget _buildFileUploader() {
    return Obx(() {
      // Baca keduanya di sini supaya Obx melacak kedua list
      final existing = controller.existingFiles.toList();
      final picked = controller.pickedFiles.toList();
      final totalFiles = existing.length + picked.length;

      // Belum ada file -> satu kotak lebar dengan tanda +
      if (totalFiles == 0) {
        return GestureDetector(
          onTap: controller.pickFiles,
          child: Container(
            width: double.infinity,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.black, width: 1),
            ),
            child: const Center(child: Icon(Icons.add, size: 28)),
          ),
        );
      }

      // Sudah ada file -> grid 2 kolom
      return LayoutBuilder(builder: (context, constraints) {
        const spacing = 12.0;
        const tileHeight = 100.0;
        final tileWidth = (constraints.maxWidth - spacing) / 2;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            // ===== FILE LAMA (bisa dihapus, dengan pratinjau) =====
            ...existing.map((file) {
              final isImage = _isImageName(file.originalName) || _isImageName(file.url);
              return SizedBox(
                width: tileWidth,
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: tileWidth,
                          height: tileHeight,
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.black, width: 1),
                          ),
                          child: isImage && file.url.isNotEmpty
                              ? Image.network(
                                  file.url,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child, progress) {
                                    if (progress == null) return child;
                                    return const Center(
                                      child: SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2),
                                      ),
                                    );
                                  },
                                  errorBuilder: (_, __, ___) =>
                                      _fileIconPlaceholder(),
                                )
                              : _fileIconPlaceholder(),
                        ),
                        Positioned(
                          top: 6,
                          right: 6,
                          child: GestureDetector(
                            onTap: () => controller.removeExistingFile(file),
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.close, size: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      file.originalName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: AppText.Body2,
                    ),
                  ],
                ),
              );
            }),

            // ===== FILE BARU =====
            ...picked.map((file) {
              final isImage = controller.isImageFile(file);
              final bytes = file.bytes;

              return SizedBox(
                width: tileWidth,
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: tileWidth,
                          height: tileHeight,
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border:
                                Border.all(color: AppColors.black, width: 1),
                          ),
                          child: isImage && bytes != null
                              ? Image.memory(bytes,
                                  fit: BoxFit.cover,
                                  width: tileWidth,
                                  height: tileHeight)
                              : _fileIconPlaceholder(),
                        ),
                        Positioned(
                          top: 6,
                          right: 6,
                          child: GestureDetector(
                            onTap: () => controller.removeFile(file),
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.close, size: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      file.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: AppText.Body2,
                    ),
                  ],
                ),
              );
            }),

            // ===== TOMBOL TAMBAH (disembunyikan kalau sudah 3 file) =====
            if (totalFiles < 3)
              GestureDetector(
                onTap: controller.pickFiles,
                child: Container(
                  width: tileWidth,
                  height: tileHeight,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.black, width: 1),
                  ),
                  child: const Center(child: Icon(Icons.add, size: 28)),
                ),
              ),
          ],
        );
      });
    });
  }

  // ===== TUGASKAN UNTUK(?) -> langsung buka picker siswa =====
  Widget _buildAssignTargetRow(BuildContext context) {
    return Row(
      children: [
        Text('Tugaskan untuk', style: AppText.Body1_SemiBold),
        GestureDetector(
          onTap: () {
            Get.snackbar(
              'Info',
              'Ketuk kolom di samping untuk memilih siswa. '
                  '"Semua" berarti tugas diberikan ke seluruh siswa di kelas ini.',
            );
          },
          child: Text('(?)', style: AppText.Body1_SemiBold),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Obx(() {
            final hasSelected =
                controller.assignTarget.value == AssignTarget.pilihSiswa &&
                    controller.selectedStudents.isNotEmpty;
            final text = hasSelected
                ? '${controller.selectedStudents.length} siswa'
                : 'Semua';

            return GestureDetector(
              onTap: () => controller.onAssignTargetChanged(
                  AssignTarget.pilihSiswa, context),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.black, width: 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        text,
                        style: AppText.Body2,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Icon(Icons.keyboard_arrow_down, size: 20),
                  ],
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildTopicPicker(BuildContext context) {
    return Obx(() => GestureDetector(
          onTap: () => controller.onPickTopic(context),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
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
                            : AppColors.black),
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
      hintStyle:
          AppText.Body2.copyWith(color: AppColors.black.withOpacity(0.4)),
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