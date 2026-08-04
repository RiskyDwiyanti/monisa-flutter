import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:monisa/app/modules/student/kehadiran/presensi/views/widget/calendar.dart';
import 'package:monisa/app/routes/app_pages.dart';
import 'package:monisa/app/theme/app_colors.dart';
import 'package:monisa/app/theme/app_text.dart';

import '../controllers/presensi_controller.dart';

class PresensiView extends GetView<PresensiController> {
  const PresensiView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 16),
                    _buildInfoCards(),
                    const SizedBox(height: 16),
                    CalendarPresensi(),
                    const SizedBox(height: 16),
                    _buildRekap(),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ======================= HEADER =========================
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 40, bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Presensi', style: AppText.Header1),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.black, width: 1),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Get.toNamed(Routes.TAMBAH_PRESENSI);
                  },
                  child: SvgPicture.asset(
                    'assets/icons/plus_icon.svg',
                    width: 22,
                    height: 22,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(width: 14),
                GestureDetector(
                  onTap: () {
                    Get.toNamed(Routes.SQAN_QR_PRESENSI);
                  },
                  child: SvgPicture.asset(
                    'assets/icons/scanner_icon.svg',
                    width: 22,
                    height: 22,
                    color: AppColors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ======================= INFO CARDS =========================
  Widget _buildInfoCards() {
    return Row(
      children: [
        // Card kiri: hari & tanggal
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.black, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(controller.hariIni, style: AppText.Header2),
                const SizedBox(height: 2),
                Text(controller.tanggalHariIni, style: AppText.SubHeading),
                const SizedBox(height: 4),
                Text(controller.lokasiKelas, style: AppText.Body2),
                const SizedBox(height: 6),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Card kanan: waktu & keterangan
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.black, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    text: controller.waktuMasuk,
                    style: AppText.Header2,
                    children: [
                      TextSpan(
                        text: "WIB",
                        style: AppText.SubHeading,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Keterangan: ${controller.keterangan}',
                  style: AppText.Body2,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.attach_file, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${controller.jumlahLampiran} Lampiran',
                      style: AppText.Body2,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ======================= REKAP KEHADIRAN =========================
  Widget _buildRekap() {
    final total = controller.rekapTotal;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.black, width: 1),
      ),
      child: Column(
        children: [
          // Header orange
          Container(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            decoration: const BoxDecoration(
              color: AppColors.Tangerine,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Rekap Kehadiran',
                  style: AppText.Header2.copyWith(color: AppColors.white),
                ),
                Obx(() => GestureDetector(
                  onTap: _showSemesterPicker,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Text(
                          controller.selectedSemester.value,
                          style: AppText.body_grafik,
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.keyboard_arrow_down, size: 18),
                      ],
                    ),
                  ),
                )),
              ],
            ),
          ),

          // Donut + Legend
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // Donut chart
                SizedBox(
                  width: 120,
                  height: 120,
                  child: CustomPaint(
                    painter: _DonutPainter(controller: controller, total: total),
                  ),
                ),
                const SizedBox(width: 24),
                // Legend
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _legendItem(const Color(0xFF3D52D5), 'Hadir: ${controller.rekapHadir} hari'),
                    _legendItem(const Color(0xFFB0B8D1), 'Izin: ${controller.rekapIzin} hari'),
                    _legendItem(AppColors.Tangerine, 'Sakit: ${controller.rekapSakit} hari'),
                    _legendItem(const Color(0xFFE8C84A), 'Alpha: ${controller.rekapAlpha} hari'),
                    _legendItem(const Color(0xFFE8607A), 'Libur: ${controller.rekapLibur} hari'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _legendItem(Color color, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(label, style: AppText.Body2),
        ],
      ),
    );
  }

  void _showSemesterPicker() {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Pilih Semester', style: AppText.Header2),
            const SizedBox(height: 12),
            ...controller.semesterList.map((s) => ListTile(
              title: Text(s, style: AppText.Body1),
              trailing: Obx(() => controller.selectedSemester.value == s
                  ? const Icon(Icons.check, color: AppColors.Tangerine)
                  : const SizedBox()),
              onTap: () {
                controller.selectedSemester.value = s;
                Get.back();
              },
            )),
          ],
        ),
      ),
    );
  }

}

// ======================= DONUT PAINTER =========================

class _DonutPainter extends CustomPainter {
  final PresensiController controller;
  final int total;

  _DonutPainter({required this.controller, required this.total});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const strokeWidth = 22.0;
    final rect = Rect.fromCircle(center: center, radius: radius - strokeWidth / 2);

    final segments = [
      (controller.rekapHadir, AppColors.Electric),
      (controller.rekapIzin, AppColors.Sky),
      (controller.rekapSakit, AppColors.Tangerine),
      (controller.rekapAlpha, AppColors.Butter),
      (controller.rekapLibur, AppColors.Blush),
    ];

    double startAngle = -math.pi / 2;
    const gap = 0.03;

    for (final seg in segments) {
      final sweep = (seg.$1 / total) * 2 * math.pi - gap;
      if (sweep <= 0) continue;
      final paint = Paint()
        ..color = seg.$2
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;
      canvas.drawArc(rect, startAngle, sweep, false, paint);
      startAngle += sweep + gap;
    }
  }

  @override
  bool shouldRepaint(_DonutPainter old) => false;
}