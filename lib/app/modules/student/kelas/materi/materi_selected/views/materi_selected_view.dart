import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:monisa/app/theme/app_colors.dart';
import 'package:monisa/app/theme/app_text.dart';

import '../controllers/materi_selected_controller.dart';

class MateriSelectedView extends GetView<MateriSelectedController> {
  const MateriSelectedView({super.key});
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
                final m = controller.material.value;

                if (controller.isLoading.value && m == null) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.errorMessage.value != null && m == null) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            controller.errorMessage.value!,
                            textAlign: TextAlign.center,
                            style: AppText.Body2,
                          ),
                          const SizedBox(height: 16),
                          OutlinedButton(
                            onPressed: controller.fetchDetail,
                            child: Text('Coba lagi', style: AppText.Body1_SemiBold),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (m == null) return const SizedBox.shrink();

                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: _buildCard(m),
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
      padding: const EdgeInsets.fromLTRB(20, 52, 20, 24),
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

  Widget _buildCard(MateriDetail m) {
    final desc = (m.description ?? '').trim();

    return Container(
      width: double.infinity,
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
            child: Text(m.title, style: AppText.Header2),
          ),
          const Divider(height: 1, color: AppColors.black),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildTeacherAvatar(m),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(m.teacherName, style: AppText.Body1_SemiBold),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(desc.isEmpty ? 'Tidak ada deskripsi.' : desc, style: AppText.SubHeader_Regular),
                const SizedBox(height: 16),
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/share_icon.svg',
                      width: 23,
                      height: 23,
                    ),
                    const SizedBox(width: 8),
                    Text.rich(
                      TextSpan(
                        style: AppText.Body1_Regular,
                        children: [
                          const TextSpan(text: 'Diunggah pada: '),
                          TextSpan(
                            text: m.uploadedDateLabel,
                            style: AppText.Body1_SemiBold,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (m.files.isNotEmpty) ...[
            CustomPaint(
              size: const Size(double.infinity, 1),
              painter: _DashedLinePainter(),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: _buildFileGrid(m.files),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTeacherAvatar(MateriDetail m) {
    final photo = m.teacherPhoto ?? '';
    final hasPhoto = photo.startsWith('http');

    return CircleAvatar(
      radius: 16,
      backgroundColor: m.avatarColor,
      backgroundImage: hasPhoto ? NetworkImage(photo) : null,
      onBackgroundImageError: hasPhoto ? (_, __) {} : null,
      child: hasPhoto
          ? null
          : Text(
              m.teacherName.isNotEmpty ? m.teacherName[0].toUpperCase() : '?',
              style: AppText.Body1_SemiBold.copyWith(color: AppColors.white),
            ),
    );
  }

  Widget _buildFileGrid(List<MateriFileItem> files) {
    return LayoutBuilder(builder: (context, constraints) {
      const spacing = 12.0;
      const tileHeight = 100.0;
      final tileWidth = (constraints.maxWidth - spacing) / 2;

      return Wrap(
        spacing: spacing,
        runSpacing: spacing,
        children: files.map((file) {
          return GestureDetector(
            onTap: () => controller.openFile(file),
            child: SizedBox(
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
                    child: (file.isImage && file.url.isNotEmpty)
                        ? Image.network(
                            file.url,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _buildDocLogo(file),
                          )
                        : _buildDocLogo(file),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    file.originalName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: AppText.Body1_Regular,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      );
    });
  }

  // ===== Logo format dokumen =====
  Widget _buildDocLogo(MateriFileItem file) {
    final style = _docStyleFor(file.extension);

    return Container(
      color: style.color.withOpacity(0.08),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.insert_drive_file, size: 40, color: style.color),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: style.color,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                style.label,
                style: AppText.Body2.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _DocStyle _docStyleFor(String ext) {
    switch (ext) {
      case 'pdf':
        return const _DocStyle('PDF', Color(0xFFD32F2F));
      case 'doc':
      case 'docx':
        return const _DocStyle('DOC', Color(0xFF1976D2));
      case 'xls':
      case 'xlsx':
      case 'csv':
        return const _DocStyle('XLS', Color(0xFF2E7D32));
      case 'ppt':
      case 'pptx':
        return const _DocStyle('PPT', Color(0xFFE65100));
      case 'txt':
        return const _DocStyle('TXT', Color(0xFF616161));
      default:
        return _DocStyle(ext.isEmpty ? 'FILE' : ext.toUpperCase(), const Color(0xFF616161));
    }
  }

}

class _DocStyle {
  final String label;
  final Color color;

  const _DocStyle(this.label, this.color);
}

class _DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.black
      ..strokeWidth = 1;

    const dashWidth = 8.0;
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
