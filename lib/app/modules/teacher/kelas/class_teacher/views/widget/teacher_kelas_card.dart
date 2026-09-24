import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:monisa/app/modules/teacher/kelas/class_teacher/controllers/class_teacher_controller.dart';
import 'package:monisa/app/theme/app_colors.dart';
import 'package:monisa/app/theme/app_text.dart';

class TeacherKelasCard extends StatelessWidget {
  final String mataPelajaran;
  final String kelas;
  final String tahunAjaran;
  final List<StudentPreview> students;
  final int studentsCount;
  final Color bgColor;
  final VoidCallback? onTap;
  final VoidCallback? onQrTap;

  const TeacherKelasCard({
    super.key,
    required this.mataPelajaran,
    required this.kelas,
    required this.tahunAjaran,
    required this.students,
    required this.studentsCount,
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

  Color get _textColor => bgColor == AppColors.Blush ? AppColors.white : AppColors.black;

  String get _studentsLabel {
    if (students.isEmpty) return 'Belum ada siswa';
    final first = students.first.name;
    final others = studentsCount - 1;
    return others > 0 ? '$first dan $others lainnya' : first;
  }

  @override
  Widget build(BuildContext context) {
    const spiralWidth = 52.0;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 160,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SvgPicture.asset(
              _spiralAsset,
              width: spiralWidth,
              fit: BoxFit.fill,
            ),
            Expanded(
              child: Transform.translate(
                offset: const Offset(-10, 0),
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
                      SizedBox(
                        width: 16,
                        child: CustomPaint(
                          painter: _DashedLinePainter(),
                          child: const SizedBox.expand(),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          mataPelajaran,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: AppText.Header2
                                              .copyWith(color: _textColor),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          '$kelas • $tahunAjaran',
                                          style: AppText.Body2
                                              .copyWith(color: _textColor),
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
                                  _StackedAvatars(
                                    students: students,
                                    borderColor: AppColors.black,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      _studentsLabel,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppText.Body1_SemiBold
                                          .copyWith(color: _textColor),
                                    ),
                                  ),
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

/// Maksimal 3 avatar bertumpuk. Jika tidak ada foto -> inisial nama.
class _StackedAvatars extends StatelessWidget {
  final List<StudentPreview> students;
  final Color borderColor;

  const _StackedAvatars({required this.students, required this.borderColor});

  static const double _size = 32;
  static const double _overlap = 20; // jarak antar avatar (size - overlap)
  static const _fallbackColors = [
    Color(0xFFF5C6AA),
    Color(0xFFF0D890),
    Color(0xFFB9CFD8),
  ];

  @override
  Widget build(BuildContext context) {
    final shown = students.take(3).toList();
    if (shown.isEmpty) return const SizedBox(height: _size);

    return SizedBox(
      width: _size + (shown.length - 1) * _overlap,
      height: _size,
      child: Stack(
        children: [
          for (int i = 0; i < shown.length; i++)
            Positioned(
              left: i * _overlap,
              child: Container(
                width: _size,
                height: _size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _fallbackColors[i % _fallbackColors.length],
                  border: Border.all(color: borderColor, width: 1),
                  image: shown[i].photoUrl != null
                      ? DecorationImage(
                          image: NetworkImage(shown[i].photoUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                alignment: Alignment.center,
                child: shown[i].photoUrl == null
                    ? Text(
                        shown[i].name.isNotEmpty
                            ? shown[i].name[0].toUpperCase()
                            : '?',
                        style: AppText.Body1_SemiBold
                            .copyWith(color: AppColors.black),
                      )
                    : null,
              ),
            ),
        ],
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