import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:monisa/app/theme/app_colors.dart';
import 'package:monisa/app/theme/app_text.dart';

import '../controllers/assignment_submission_detail_controller.dart';

class AssignmentSubmissionDetailView
    extends GetView<AssignmentSubmissionDetailController> {
  const AssignmentSubmissionDetailView({super.key});
  @override
  Widget build(BuildContext context) {
    final submission = controller.submission;
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Column(
                  children: [
                    _buildInfoCard(submission),
                    const SizedBox(height: 20),
                    if (submission.files.isNotEmpty)
                      _buildFilesCard(submission),
                    const SizedBox(height: 20),
                    _buildGradeButton(),
                  ],
                ),
              ),
            ),
          ],
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
            onTap: () => Get.back(),
            child: const Icon(Icons.arrow_back, size: 26),
          ),
          const SizedBox(width: 16),
          Text('Detail Tugas', style: AppText.Header1),
        ],
      ),
    );
  }

  Widget _buildInfoCard(submission) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.black, width: 1),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: Text(controller.assignmentTitle, style: AppText.Header2),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: AppColors.black, width: 1),
                  ),
                  child: Text(
                    '${submission.score ?? '-'}/${controller.maxScore}',
                    style: AppText.Body2,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.black),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: AppColors.black.withOpacity(0.05),
                      child: Text(
                        submission.studentName.isNotEmpty
                            ? submission.studentName[0].toUpperCase()
                            : '?',
                        style: AppText.Body2,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(submission.studentName, style: AppText.Body1_SemiBold),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.file_upload_outlined, size: 18),
                    const SizedBox(width: 8),
                    Text.rich(
                      TextSpan(
                        style: AppText.Body2,
                        children: [
                          const TextSpan(text: 'Dikirim pada: '),
                          TextSpan(
                            text: submission.submittedDateLabel,
                            style: AppText.Body2.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool _isImageFile(String name) {
    final lower = name.toLowerCase();
    return lower.endsWith('.jpg') || lower.endsWith('.jpeg') || lower.endsWith('.png');
  }

  Widget _buildFilesCard(submission) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.black, width: 1),
      ),
      child: LayoutBuilder(builder: (context, constraints) {
        const spacing = 12.0;
        const tileHeight = 100.0;
        final tileWidth = (constraints.maxWidth - spacing) / 2;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: submission.files.map<Widget>((file) {
            final isImage = _isImageFile(file.originalName) || _isImageFile(file.url);

            return SizedBox(
              width: tileWidth,
              child: Column(
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
                            errorBuilder: (_, __, ___) => _filePlaceholder(),
                          )
                        : _filePlaceholder(),
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
          }).toList(),
        );
      }),
    );
  }

  Widget _filePlaceholder() {
    return Container(
      color: AppColors.black.withOpacity(0.03),
      child: const Center(child: Icon(Icons.insert_drive_file, size: 28)),
    );
  }

  Widget _buildGradeButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: controller.onGradeTap, // TODO: fitur nilai tugas menyusul
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.Tangerine,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
            side: const BorderSide(color: AppColors.black, width: 1),
          ),
        ),
        child: Text('Nilai tugas',
            style: AppText.Body1_SemiBold.copyWith(color: AppColors.white)),
      ),
    );
  }
}
