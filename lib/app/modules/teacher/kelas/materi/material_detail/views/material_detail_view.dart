import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:monisa/app/modules/teacher/kelas/materi/material_detail/views/widget/material_delete_confirm_dialog.dart';
import 'package:monisa/app/theme/app_colors.dart';
import 'package:monisa/app/theme/app_text.dart';

import '../controllers/material_detail_controller.dart';

class MaterialDetailView extends GetView<MaterialDetailController> {
  const MaterialDetailView({super.key});
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
                if (controller.isLoading.value && controller.material.value == null) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.errorMessage.value != null &&
                    controller.material.value == null) {
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

                final material = controller.material.value;
                if (material == null) return const SizedBox.shrink();

                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: _buildCard(context, material),
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
          Text('Detail Materi', style: AppText.Header1),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, material) {
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Text(material.title, style: AppText.Header2),
                )
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
                    Text(
                      // TODO: nama guru tidak tersedia dari API saat ini
                      'Anda',
                      style: AppText.Body1_SemiBold,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  (material.description == null || material.description.isEmpty)
                      ? 'Tidak ada deskripsi.'
                      : material.description,
                  style: AppText.Body2,
                ),
                const SizedBox(height: 16),
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
                            text: material.uploadedDateLabel,
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

          if (material.files.isNotEmpty) ...[
            _buildDashedDivider(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: _buildFileGrid(material.files),
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
                    child: Text('Edit materi',
                        style: AppText.Body1_SemiBold.copyWith(color: AppColors.black)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => showMaterialDeleteConfirmDialog(context, controller),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                        side: const BorderSide(color: AppColors.black, width: 1),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text('Hapus materi',
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
    return lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.png');
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