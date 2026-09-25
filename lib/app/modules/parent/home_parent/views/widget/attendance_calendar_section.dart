import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:intl/intl.dart';
import 'package:monisa/app/modules/parent/home_parent/controllers/home_parent_controller.dart';
import 'package:monisa/app/theme/app_colors.dart';
import 'package:monisa/app/theme/app_text.dart';

class AttendanceCalendarSection extends StatelessWidget {
  final HomeParentController controller;
  const AttendanceCalendarSection({super.key, required this.controller});

  String _monthName(int m) {
    const names = [
      '', 'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
    ];
    return names[m];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Kalender Kehadiran', style: AppText.Header2),
            GestureDetector(
              onTap: () {
                // TODO: navigate to full attendance calendar page
              },
              child: Text(
                'Selengkapnya',
                style: AppText.SubHeading.copyWith(decoration: TextDecoration.underline),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text('Cek rekap kehadiran anak di sini.', style: AppText.SubHeading),
        const SizedBox(height: 12),
        _buildCalendarCard(),
        _buildTodayDetail(),
      ],
    );
  }

  Widget _buildCalendarCard() {
    return Obx(() {
      final year = controller.currentMonth.value.year;
      final month = controller.currentMonth.value.month;
      final daysInMonth = DateUtils.getDaysInMonth(year, month);
      final firstWeekday = (DateTime(year, month, 1).weekday - 1) % 7;
 
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16)
          ),
          border: Border.all(color: AppColors.black),
        ),
        child: Column(
          children: [
            // ===== HEADER =====
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: const BoxDecoration(
                color: AppColors.Tangerine,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                border: Border(bottom: BorderSide(color: AppColors.black, width: 1)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${_monthName(month)} $year',
                    style: AppText.Header2.copyWith(color: AppColors.white),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => controller.changeMonth(-1),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.black, width: 1),
                          ),
                          padding: const EdgeInsets.all(4),
                          child: const Icon(Icons.chevron_left_rounded, color: Colors.black, size: 24),
                        ),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () => controller.changeMonth(1),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.black, width: 1),
                          ),
                          padding: const EdgeInsets.all(4),
                          child: const Icon(Icons.chevron_right_rounded, color: Colors.black, size: 24),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
 
            // ===== GRID =====
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildDayLabel('S', isWeekend: false),
                      _buildDayLabel('S', isWeekend: false),
                      _buildDayLabel('R', isWeekend: false),
                      _buildDayLabel('K', isWeekend: false),
                      _buildDayLabel('J', isWeekend: false),
                      _buildDayLabel('S', isWeekend: true),
                      _buildDayLabel('M', isWeekend: true),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (controller.isLoading.value)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    )
                  else
                    _buildCalendarGrid(year, month, daysInMonth, firstWeekday),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildDayLabel(String label, {required bool isWeekend}) {
    return Expanded(
      child: Center(
        child: Text(
          label,
          style: AppText.SubHeading.copyWith(
            color: isWeekend ? AppColors.Blush : AppColors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarGrid(int year, int month, int daysInMonth, int firstWeekday) {
    final now = DateTime.now();
    final today = now.day;
    final isCurrentMonth = now.year == year && now.month == month;
    final days = controller.homeData.value?.days ?? [];
    final cells = <Widget>[];
 
    for (int i = 0; i < firstWeekday; i++) {
      cells.add(const SizedBox());
    }
 
    for (int day = 1; day <= daysInMonth; day++) {
      final weekIndex = (firstWeekday + day - 1) % 7;
      final isWeekend = weekIndex == 5 || weekIndex == 6;
      final isToday = isCurrentMonth && day == today;
      final isPast = isCurrentMonth
          ? day < today
          : DateTime(year, month).isBefore(DateTime(now.year, now.month));
      final status = days
          .firstWhereOrNull((d) => d.date.year == year && d.date.month == month && d.date.day == day)
          ?.status;
 
      cells.add(_buildDayCell(day, status, isWeekend, isToday, isPast));
    }
 
    final rows = <Widget>[];
    for (int i = 0; i < cells.length; i += 7) {
      final rowCells = cells.sublist(i, i + 7 > cells.length ? cells.length : i + 7);
      while (rowCells.length < 7) {
        rowCells.add(const SizedBox());
      }
      rows.add(Row(children: rowCells.map((c) => Expanded(child: c)).toList()));
      if (i + 7 < cells.length) rows.add(const SizedBox(height: 4));
    }
 
    return Column(children: rows);
  }

  Widget _buildDayCell(
    int day,
    StatusPresensi? status,
    bool isWeekend,
    bool isToday,
    bool isPast,
  ) {
    Color? bgColor;
    Color textColor = AppColors.black;
    Border? border;
 
    if (status == StatusPresensi.hadir) {
      bgColor = AppColors.Electric;
      textColor = Colors.white;
    } else if (status == StatusPresensi.sakit) {
      bgColor = AppColors.Tangerine;
      textColor = Colors.white;
    } else if (status == StatusPresensi.izin) {
      bgColor = AppColors.Sky;
      textColor = Colors.white;
    } else if (status == StatusPresensi.libur) {
      bgColor = AppColors.Blush;
      textColor = Colors.white;
    } else if (status == StatusPresensi.alpha) {
      bgColor = AppColors.Tangerine;
      textColor = Colors.white;
    } else if (isWeekend && status == null) {
      if (isPast) {
        bgColor = AppColors.Blush;
        textColor = AppColors.white;
      } else {
        textColor = AppColors.Blush;
      }
    } else if (!isWeekend && status == null && isPast && !isToday) {
      bgColor = AppColors.Butter;
      textColor = AppColors.white;
    }
 
    if (isToday && status == null) {
      bgColor = null;
      border = Border.all(color: AppColors.black, width: 1);
      textColor = AppColors.black;
    }
 
    return Container(
      margin: const EdgeInsets.all(2),
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: (bgColor != null || border != null)
              ? BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(8), border: border)
              : null,
          child: Center(
            child: Text('$day', style: AppText.Body2.copyWith(color: textColor)),
          ),
        ),
      ),
    );
  }

  Widget _buildTodayDetail() {
    return Obx(() {
      final detail = controller.homeData.value?.latestAttendance;
      if (detail == null) return const SizedBox.shrink();
 
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16)
          ),
          border: Border(
            bottom: BorderSide(color: AppColors.black,width: 1),
            left: BorderSide(color: AppColors.black,width: 1),
            right: BorderSide(color: AppColors.black,width: 1),
          )
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 60,
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  decoration: BoxDecoration(
                    color: AppColors.Tangerine,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    border: Border(
                      top: BorderSide(color: AppColors.black,width: 1),
                      right: BorderSide(color: AppColors.black,width: 1),
                      left: BorderSide(color: AppColors.black,width: 1),
                      bottom: BorderSide(color: AppColors.black,width: 1),
                    )
                  ),
                ),
                Container(
                  width: 60,
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                    border: Border(
                      bottom: BorderSide(color: AppColors.black,width: 1),
                      right: BorderSide(color: AppColors.black,width: 1),
                      left: BorderSide(color: AppColors.black,width: 1),
                    )
                  ),
                  child: Column(
                    children: [
                      Text(
                        '${detail.date.day}',
                        style: AppText.Header2,
                      ),
                      Text(DateFormat('MMM', 'id_ID').format(detail.date), style: AppText.Body2),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${detail.time} WIB', style: AppText.SubHeading),
                  const SizedBox(height: 4),
                  Text('Keterangan: ${detail.keterangan}', style: AppText.Body2),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.attach_file, size: 14, color: AppColors.black),
                      const SizedBox(width: 4),
                      Text('${detail.lampiranCount} Lampiran', style: AppText.Body2),
                    ],
                  ),
                ],
              ),
            ),
            if (detail.lampiran.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  detail.lampiran.first,
                  width: 97,
                  height: 82,
                  fit: BoxFit.cover,
                ),
              ),
          ],
        ),
      );
    });
  }
}

extension _FirstWhereOrNullExt<T> on List<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    for (final e in this) {
      if (test(e)) return e;
    }
    return null;
  }
}