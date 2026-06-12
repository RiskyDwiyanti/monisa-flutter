import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:monisa/app/theme/app_colors.dart';
import 'package:monisa/app/theme/app_text.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../controllers/qr_sharing_controller.dart';

class QrSharingView extends GetView<QrSharingController> {
  const QrSharingView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: controller.bgColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Column(
                  children: [
                    _buildQrCard(),
                    const SizedBox(height: 16),
                    _buildShareButton(),
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
      padding: const EdgeInsets.fromLTRB(20, 52, 20, 20),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Icon(Icons.arrow_back, color: AppColors.white),
          ),
          const SizedBox(width: 12),
          Text(
            'QR Sharing',
            style: AppText.Heading1.copyWith(color: AppColors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildQrCard() {
    const spiralHeight = 65.0;
    
    return Column(
      children: [
        // ============ Spiral Top ============
        SizedBox(
          height: spiralHeight, 
          child: _buildSpiralTop()
        ),

        // ============ QR Card ============
        Transform.translate(
          offset: const Offset(0, -5),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              border: const Border(
                left: BorderSide(color: AppColors.black, width: 1),
                right: BorderSide(color: AppColors.black, width: 1),
                bottom: BorderSide(color: AppColors.black, width: 1),
              ),
            ),
            child: Column(
              children: [
                // ===== DASHED LINE =====
                SizedBox(
                  height: 16,
                  width: double.infinity,
                  child: CustomPaint(
                    size: Size.infinite,
                    painter: _DashedLinePainterHorizontal(),
                  ),
                ),

                // ===== QR CODE PLACEHOLDER =====
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        Text(
                          controller.mapel,
                          style: AppText.Heading1,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${controller.kelas} • ${controller.tahunAjaran}',
                          style: AppText.SubHeading,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        QrImageView(
                          data: '${controller.mapel}-${controller.kelas}-${controller.tahunAjaran}',
                          version: QrVersions.auto,
                          size: 200,
                          eyeStyle: const QrEyeStyle(
                            eyeShape: QrEyeShape.square,
                            color: AppColors.black,
                          ),
                          dataModuleStyle: const QrDataModuleStyle(
                            dataModuleShape: QrDataModuleShape.circle,
                            color: AppColors.black,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Scan kode QR di atas untuk bergabung\ndengan kelas ${controller.mapel}!',
                          style: AppText.Body2,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                ),
              ],
            ),
          ), 
        ),
      ],
    );
  }

  Widget _buildSpiralTop() {
    return SizedBox(
      height: 80,
      width: double.infinity,
      child: SvgPicture.asset(
        'assets/images/spiral-top.svg',
        fit: BoxFit.fitWidth,
      ),
    );
  }

  Widget _buildShareButton() {
    return GestureDetector(
      onTap: controller.bagikanTautan,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: AppColors.black, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/icons/share_icon.svg',
              width: 37,
              height: 37,
              color: AppColors.black,
            ),
            const SizedBox(width: 8),
            Text('Bagikan sebagai tautan', style: AppText.Body1_SemiBold),
          ],
        ),
      ),
    );
  }

}

class _DashedLinePainterHorizontal extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.black
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const dashWidth = 8.0;
    const dashSpace = 6.0;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(Offset(startX, size.height / 2),
          Offset(startX + dashWidth, size.height / 2), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
