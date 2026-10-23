import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:monisa/app/modules/teacher/kelas/tugas/assignment_detail/views/widget/assignment_delete_confirm_dialog.dart';
import 'package:monisa/app/theme/app_colors.dart';
import 'package:monisa/app/theme/app_text.dart';

import '../controllers/assignment_detail_controller.dart';

class AssignmentDetailView extends GetView<AssignmentDetailController> {
  const AssignmentDetailView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value && controller.assignment.value == null) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.errorMessage.value != null &&
                    controller.assignment.value == null) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        controller.errorMessage.value!,
                        textAlign: TextAlign.center,
                        style: AppText.Body2,
                      ),
                    ),
                  );
                }

                final assignment = controller.assignment.value;
                if (assignment == null) return const SizedBox.shrink();

                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Column(
                    children: [
                      _buildCard(context, assignment),
                      const SizedBox(height: 20),
                      _buildTabsAndList(),
                    ],
                  ),
                );
              }),
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

  Widget _buildCard(BuildContext context, assignment) {
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
                  child: Text(assignment.title, style: AppText.Header2),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: AppColors.black, width: 1),
                  ),
                  child: Text(
                    assignment.isPublished ? 'Ditugaskan' : 'Draf',
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
                      child: const Icon(Icons.person, size: 18),
                    ),
                    const SizedBox(width: 10),
                    // TODO: nama guru tidak tersedia dari API saat ini
                    Text('Anda', style: AppText.Body1_SemiBold),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  (assignment.description == null || assignment.description.isEmpty)
                      ? 'Tidak ada deskripsi.'
                      : assignment.description,
                  style: AppText.Body2,
                ),
              ],
            ),
          ),

          _buildDashedDivider(),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.file_upload_outlined, size: 18),
                    const SizedBox(width: 8),
                    Text.rich(
                      TextSpan(
                        style: AppText.Body2,
                        children: [
                          const TextSpan(text: 'Diunggah pada: '),
                          TextSpan(
                            text: assignment.uploadedDateLabel,
                            style: AppText.Body2.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (assignment.deadline != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.hourglass_bottom, size: 18),
                      const SizedBox(width: 8),
                      Text.rich(
                        TextSpan(
                          style: AppText.Body2,
                          children: [
                            const TextSpan(text: 'Tenggat: '),
                            TextSpan(
                              text: _formatDeadline(assignment.deadline!),
                              style: AppText.Body2.copyWith(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          if (assignment.files.isNotEmpty) ...[
            const Divider(height: 1, color: AppColors.black),
            Padding(
              padding: const EdgeInsets.all(20),
              child: _buildFileGrid(assignment.files),
            ),
          ],

          const Divider(height: 1, color: AppColors.black),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: controller.onEditTap,
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                        side: const BorderSide(color: AppColors.black, width: 1),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text('Edit tugas',
                        style: AppText.Body1_SemiBold.copyWith(color: AppColors.black)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () =>
                        showAssignmentDeleteConfirmDialog(context, controller),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                        side: const BorderSide(color: AppColors.black, width: 1),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text('Hapus tugas',
                        style: AppText.Body1_SemiBold.copyWith(color: AppColors.black)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDeadline(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    final time = '${d.hour.toString().padLeft(2, '0')}.${d.minute.toString().padLeft(2, '0')}';
    return '${d.day} ${months[d.month - 1]} ${d.year}, $time';
  }

  Widget _buildDashedDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: CustomPaint(
        size: const Size(double.infinity, 1),
        painter: _DashedLinePainter(),
      ),
    );
  }

  bool _isImageFile(String name) {
    final lower = name.toLowerCase();
    return lower.endsWith('.jpg') || lower.endsWith('.jpeg') || lower.endsWith('.png');
  }

  Widget _buildFileGrid(List files) {
    return LayoutBuilder(builder: (context, constraints) {
      const spacing = 12.0;
      const tileHeight = 100.0;
      final tileWidth = (constraints.maxWidth - spacing) / 2;

      return Wrap(
        spacing: spacing,
        runSpacing: spacing,
        children: files.map((file) {
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
    });
  }

  Widget _filePlaceholder() {
    return Container(
      color: AppColors.black.withOpacity(0.03),
      child: const Center(child: Icon(Icons.insert_drive_file, size: 28)),
    );
  }

  Widget _buildTabsAndList() {
    return Obx(() {
      final completed = controller.completedSubmissions;
      final notSubmitted = controller.notSubmittedStudents;

      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.black, width: 1),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildTabButton(
                    label: 'Selesai',
                    isSelected: controller.selectedTab.value == 0,
                    onTap: () => controller.onTabChanged(0),
                    isLeft: true,
                  ),
                ),
                Expanded(
                  child: _buildTabButton(
                    label: 'Belum terkumpul',
                    isSelected: controller.selectedTab.value == 1,
                    onTap: () => controller.onTabChanged(1),
                    isLeft: false,
                  ),
                ),
              ],
            ),
            if (controller.selectedTab.value == 0)
              _buildCompletedList(completed)
            else
              _buildNotSubmittedList(notSubmitted),
          ],
        ),
      );
    });
  }

  Widget _buildTabButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isLeft,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.Tangerine : AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: isLeft ? const Radius.circular(19) : Radius.zero,
            topRight: !isLeft ? const Radius.circular(19) : Radius.zero,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: AppText.Body1_SemiBold.copyWith(
            color: isSelected ? AppColors.white : AppColors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildCompletedList(List completed) {
    if (completed.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Text('Belum ada siswa yang mengumpulkan.', style: AppText.Body2),
      );
    }

    return Column(
      children: completed.asMap().entries.map((entry) {
        final isLast = entry.key == completed.length - 1;
        final s = entry.value;

        return GestureDetector(
          onTap: () => controller.onSubmissionTap(s),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: isLast
                  ? null
                  : const Border(
                      bottom: BorderSide(color: AppColors.black, width: 1)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.black.withOpacity(0.05),
                  child: Text(
                    s.studentName.isNotEmpty ? s.studentName[0].toUpperCase() : '?',
                    style: AppText.Body1_SemiBold,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(s.studentName, style: AppText.Body1_SemiBold),
                ),
                Text(
                  '${s.score ?? '-'}/${controller.assignment.value?.maxScore ?? 100}',
                  style: AppText.Body2,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildNotSubmittedList(List notSubmitted) {
    if (notSubmitted.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Text('Semua siswa sudah mengumpulkan.', style: AppText.Body2),
      );
    }

    return Column(
      children: notSubmitted.asMap().entries.map((entry) {
        final isLast = entry.key == notSubmitted.length - 1;
        final s = entry.value;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: isLast
                ? null
                : const Border(bottom: BorderSide(color: AppColors.black, width: 1)),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.black.withOpacity(0.05),
                child: Text(
                  s.name.isNotEmpty ? s.name[0].toUpperCase() : '?',
                  style: AppText.Body1_SemiBold,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(s.name, style: AppText.Body1_SemiBold)),
              Text(
                '-/${controller.assignment.value?.maxScore ?? 100}',
                style: AppText.Body2,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.black
      ..strokeWidth = 1;

    const dashWidth = 6.0;
    const dashSpace = 4.0;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}