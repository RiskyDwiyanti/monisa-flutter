import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:monisa/app/modules/teacher/home_teacher/controllers/home_teacher_controller.dart';
import 'package:monisa/app/theme/app_colors.dart';
import 'package:monisa/app/theme/app_text.dart';

class JadwalItemTile extends StatelessWidget {
  const JadwalItemTile({super.key, required this.jadwal});
  final ScheduleModel jadwal;

  static const _activeColor = Color(0xFFD1567A);
  static const _defaultBarColor = Color(0xFFD1567A);
  static const _altBarColor = Color(0xFFF7941D);

  Color get _barColor => jadwal.jamKe.isOdd ? _defaultBarColor : _altBarColor;

  @override
  Widget build(BuildContext context) {
    final isActive = jadwal.isSedangBerlangsung;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isActive ? _activeColor : Colors.white,
        border: Border.all(color: isActive ? _activeColor : Colors.black),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsetsGeometry.symmetric(horizontal: 14, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'JP ${jadwal.jamKe}',
                      style: AppText.Body1_SemiBold.copyWith(
                        color: isActive ? AppColors.white : AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      jadwal.jam,
                      style: AppText.Body1_SemiBold.copyWith(
                        color: isActive ? AppColors.white : AppColors.black,
                      ),
                    )
                  ],
                ), 
              ), 
            ),
            Container(
              width: 3,
              margin: const EdgeInsets.symmetric(vertical: 10),
              color: isActive ? AppColors.white : _barColor,
            ),
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      jadwal.kelas ?? '-',
                      style: AppText.Body1_SemiBold.copyWith(
                        color: isActive ? AppColors.white : AppColors.black,
                      ),
                    ),
                    if ((jadwal.mataPelajaran ?? '-').isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        jadwal.mataPelajaran!,
                        style: AppText.Body1_SemiBold.copyWith(
                          color: isActive ? AppColors.white : AppColors.black,
                        ),
                      )
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}