import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monisa/app/theme/app_colors.dart';
import 'package:monisa/app/theme/app_text.dart';

import '../../controllers/home_controller.dart';

class Calendar extends StatefulWidget {
  Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  final HomeController controller = Get.find();

  late int year;
  late int month;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    year = now.year;
    month = now.month;
  }

  void _prevMonth() {
    setState(() {
      if (month == 1) {
        month = 12;
        year--;
      } else {
        month--;
      }
    });
  }

  void _nextMonth() {
    setState(() {
      if (month == 12) {
        month = 1;
        year++;
      } else {
        month++;
      }
    });
  }

  String _monthName(int m) {
    const names = [
      '', 'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
    ];
    return names[m];
  }

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateUtils.getDaysInMonth(year, month);
    final firstWeekday = (DateTime(year, month, 1).weekday - 1) % 7;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.black),
      ),
      child: Column(
        children: [
          // ===== HEADER =====
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: const BoxDecoration(
              color: Color(0xFFE8921A),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              border: Border(
                bottom: BorderSide(color: AppColors.black, width: 1),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_monthName(month)} $year',
                  style: AppText.Heading2.copyWith(color: AppColors.white),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: _prevMonth,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        child: const Icon(
                          Icons.chevron_left_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: _nextMonth,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        child: const Icon(
                          Icons.chevron_right_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
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
                _buildCalendarGrid(daysInMonth, firstWeekday),
              ],
            ),
          ),
        ],
      ),
    );
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

  Widget _buildCalendarGrid(int daysInMonth, int firstWeekday) {
    final now = DateTime.now();
    final today = now.day;
    final isCurrentMonth = now.year == year && now.month == month;
    final cells = <Widget>[];

    for (int i = 0; i < firstWeekday; i++) {
      cells.add(const SizedBox());
    }

    for (int day = 1; day <= daysInMonth; day++) {
      final weekIndex = (firstWeekday + day - 1) % 7;
      final isWeekend = weekIndex == 5 || weekIndex == 6;
      final isToday = isCurrentMonth && day == today;
      final isPast = isCurrentMonth ? day < today : DateTime(year, month).isBefore(DateTime(now.year, now.month));
      final status = controller.attendanceStatus[DateTime(year, month, day)];

      cells.add(_buildDayCell(day, status, isWeekend, isToday, isPast));
    }

    final rows = <Widget>[];

    for (int i = 0; i < cells.length; i += 7) {
      final rowCells = cells.sublist(
        i,
        i + 7 > cells.length ? cells.length : i + 7,
      );

      while (rowCells.length < 7) {
        rowCells.add(const SizedBox());
      }

      rows.add(
        Row(
          children: rowCells.map((c) => Expanded(child: c)).toList(),
        ),
      );

      if (i + 7 < cells.length) {
        rows.add(const SizedBox(height: 4));
      }
    }

    return Column(children: rows);
  }

  Widget _buildDayCell(
    int day,
    String? status,
    bool isWeekend,
    bool isToday,
    bool isPast,
  ) {
    Color? bgColor;
    Color textColor = AppColors.black;
    Border? border;

    if (status == 'hadir') {
      bgColor = AppColors.Electric;
      textColor = Colors.white;
    } else if (status == 'sakit') {
      bgColor = AppColors.Tangerine;
      textColor = Colors.white;
    } else if (status == 'izin') {
      bgColor = AppColors.Sky;
      textColor = Colors.white;
    } else if (status == 'libur') {
      bgColor = AppColors.Blush;
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
              ? BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(8),
                  border: border,
                )
              : null,
          child: Center(
            child: Text(
              '$day',
              style: AppText.Body2.copyWith(color: textColor),
            ),
          ),
        ),
      ),
    );
  }
}