import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:monisa/app/theme/app_colors.dart';
import 'package:monisa/app/theme/app_text.dart';

class KelasCard extends StatelessWidget {
  final String mataPelajaran;
  final String kelas;
  final String tahunAjaran;
  final String namaGuru;
  final String fotoGuru;
  final Color bgColor;
  final VoidCallback? onTap;
  final VoidCallback? onQrTap;

  const KelasCard({
    super.key,
    required this.mataPelajaran,
    required this.kelas,
    required this.tahunAjaran,
    required this.namaGuru,
    required this.fotoGuru,
    required this.bgColor,
    this.onTap,
    this.onQrTap,
  });

  String get _spiralAsset {
    if (bgColor == AppColors.Blush) return 'assets/images/spiral-blush.svg';
    if (bgColor == AppColors.Sky) return 'assets/images/spiral-sky.svg';
    if (bgColor == AppColors.Butter) return 'assets/images/spiral-butter.svg';
    return 'assets/images/spiral-pink.svg';
  }

  Color get _textColor {
    if (bgColor == AppColors.Blush) return AppColors.white;
    return AppColors.black;
  }

  @override
  Widget build(BuildContext context) {
    const spiralWidth = 52.0;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 160, // tentukan tinggi di sini
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ===== SPIRAL KIRI =====
            SvgPicture.asset(
              _spiralAsset,
              width: spiralWidth,
              fit: BoxFit.fill, // fill agar SVG mengisi tepat sesuai height
            ),

            // ===== KONTEN + BORDER =====
            Expanded(
              child: Transform.translate(
                offset: const Offset(-10, 0), // jarak antara spiral dan konten
                child: Container(
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    border: Border(
                      top: BorderSide(color: AppColors.black, width: 1),
                      bottom: BorderSide(color: AppColors.black, width: 1),
                      right: BorderSide(color: AppColors.black, width: 1),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // ===== GARIS PUTUS-PUTUS =====
                      SizedBox(
                        width: 16,
                        child: CustomPaint(
                          painter: _DashedLinePainter(),
                          child: const SizedBox.expand(),
                        ),
                      ),

                      // ===== KONTEN =====
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center, // konten di tengah
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(mataPelajaran,
                                            style: AppText.Heading2
                                                .copyWith(color: _textColor)),
                                        const SizedBox(height: 2),
                                        Text(
                                          '$kelas • $tahunAjaran',
                                          style:
                                              AppText.Body2.copyWith(color: _textColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: onQrTap,
                                    child: SvgPicture.asset(
                                      'assets/icons/qr-code_icon.svg',
                                      width: 32,
                                      height: 32,
                                      color: _textColor,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 32),
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 16,
                                    backgroundImage: AssetImage(fotoGuru),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(namaGuru,
                                      style: AppText.Body1_SemiBold
                                          .copyWith(color: _textColor)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}

class _DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.black
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const dashHeight = 13.0;
    const dashSpace = 7.8;
    double startY = 0;

    while (startY < size.height) {
      canvas.drawLine(
        Offset(size.width / 2, startY),
        Offset(size.width / 2, startY + dashHeight),
        paint,
      );
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}