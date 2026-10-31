import 'package:flutter/material.dart';
import 'package:monisa/app/theme/app_colors.dart';
import 'package:monisa/app/theme/app_text.dart';

/// Dua tab. standalone = true: punya border sendiri (Tentang Kelas).
/// standalone = false: ditaruh di dalam card yang di-clip (Tentang Siswa).
class InfoTabSwitcher extends StatelessWidget {
  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final bool standalone;

  const InfoTabSwitcher({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onChanged,
    this.standalone = true,
  });

  @override
  Widget build(BuildContext context) {
    final row = Row(
      children: List.generate(labels.length, (i) {
        final selected = i == selectedIndex;

        return Expanded(
          child: GestureDetector(
            onTap: () => onChanged(i),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: standalone ? 18 : 18),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected ? AppColors.Tangerine : AppColors.white,
                border: i == 0
                    ? null
                    : const Border(left: BorderSide(color: AppColors.black, width: 1)),
              ),
              child: Text(
                labels[i],
                style: AppText.Body1_SemiBold.copyWith(
                  color: selected ? AppColors.white : AppColors.black,
                ),
              ),
            ),
          ),
        );
      }),
    );

    if (!standalone) return row;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.black, width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(19),
        child: row,
      ),
    );
  }
}

/// Palet warna avatar. Tambahkan warna lain dari AppColors Anda di sini.
const List<Color> kAvatarPalette = [
  AppColors.Tangerine,
  AppColors.Blush,
  AppColors.Butter,
  AppColors.Electric,
  // AppColors.xxx,
];

/// Foto bulat (circle = true) atau kotak membulat. Fallback ke inisial.
class InfoAvatar extends StatelessWidget {
  final String? url;
  final String name;
  final double size;
  final bool circle;
  final Color? color;

  const InfoAvatar({
    super.key,
    required this.url,
    required this.name,
    this.size = 48,
    this.circle = true,
    this.color,
  });

  static Color colorFor(int seed) => kAvatarPalette[seed.abs() % kAvatarPalette.length];

  @override
  Widget build(BuildContext context) {
    final bg = color ?? AppColors.black.withOpacity(0.05);

    final initial = Container(
      color: bg,
      alignment: Alignment.center,
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : '?',
        style: AppText.Body1_SemiBold,
      ),
    );

    return Container(
      width: size,
      height: size,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(circle ? size / 2 : 12),
        border: Border.all(color: AppColors.black, width: 1),
      ),
      child: (url != null && url!.isNotEmpty)
          ? Image.network(
              url!,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => initial,
            )
          : initial,
    );
  }
}

class InfoDashedDivider extends StatelessWidget {
  const InfoDashedDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: CustomPaint(
        size: const Size(double.infinity, 1),
        painter: _DashedLinePainter(),
      ),
    );
  }
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