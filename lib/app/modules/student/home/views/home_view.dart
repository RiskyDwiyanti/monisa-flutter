import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:monisa/app/modules/student/home/views/widgets/calendar.dart';
import 'package:monisa/app/modules/student/home/views/widgets/tugas_card.dart';
import 'package:monisa/app/theme/app_colors.dart';
import 'package:monisa/app/theme/app_text.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.Lychee,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  border: Border(
                    top: BorderSide(
                      color: AppColors.black,
                      width: 1,
                    ),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(0, 0, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      _buildDaftarTugas(),
                      const SizedBox(height: 24),
                      _buildPresensi(),
                      const SizedBox(height: 24),
                      _buildKalenderKehadiran(),
                      const SizedBox(height: 20),
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

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(left: 0),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 42, 20, 20),
        decoration: BoxDecoration(
          color: AppColors.Lychee,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(() => Text(
                  'Selamat ${controller.getGreeting()}, ${controller.name.value}!',
                  style: AppText.Heading1,
                )),
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.black, width: 1.5),
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/icons/bell_icon.svg',
                  width: 22,
                  height: 22,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDaftarTugas() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Daftar Tugas', style: AppText.Heading2),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      'Lihat Semua',
                      style: AppText.Body_Bold.copyWith(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text('Yuk kerjakan tugas-tugasmu!', style: AppText.Body2),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Transform.translate(
          offset: const Offset(20, 0),
          child: SizedBox(
            height: 170,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                TugasCard(
                  title: 'Rangkuman: Silsilah Kerajaan Mataram',
                  subject: 'Sejarah',
                  deadline: '10 Mei 2026, 23:59',
                  status: 'Ditugaskan',
                  bgColor: AppColors.Butter,
                ),
                TugasCard(
                  title: 'Lembar Kerja SPLTV',
                  subject: 'Matematika',
                  deadline: '8 Mei 2026, 21:00',
                  status: 'Terlambat',
                  bgColor: AppColors.Sky,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPresensi() {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Presensi', style: AppText.Heading2),
          const SizedBox(height: 4),
          Text(
            'Jangan lupa catat presensimu hari ini, ya!',
            style: AppText.Body2,
          ),
          const SizedBox(height: 12),
          Container(
            height: 130,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.black, width: 1),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Row(
                children: [

                  // ===== BAGIAN 1: STRIP ORANGE =====
                  Container(
                    width: 18,
                    decoration: BoxDecoration(
                      color: AppColors.Tangerine,
                      border: Border(
                        right: BorderSide(
                          color: AppColors.black,
                          width: 1,
                        ),
                      )
                    ),
                  ),

                  // ===== BAGIAN 2: INFO (PUTIH) =====
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Obx(() => RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: controller.currentTime.value,
                                      style: AppText.Heading2,
                                    ),
                                    TextSpan(
                                      text: ' WIB',
                                      style: AppText.Body2,
                                    ),
                                  ],
                                ),
                              )),
                          const SizedBox(height: 6),
                          Text('Keterangan: Sakit', style: AppText.Body2),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              SvgPicture.asset(
                                'assets/icons/attachments_icon.svg',
                                width: 17,
                                height: 17,
                                color: AppColors.black
                              ),
                              const SizedBox(width: 4),
                              Text('2 Lampiran', style: AppText.Body2),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ===== GARIS PUTUS-PUTUS =====
                  SizedBox(
                    width: 20,
                    height: double.infinity,
                    child: CustomPaint(
                      painter: _DashedLinePainter(),
                    ),
                  ),

                  // ===== BAGIAN 3: QR (PUTIH) =====
                  GestureDetector(
                    onTap: () {},
                    child: SizedBox(
                      width: 95,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/icons/scanner_icon.svg',
                            width: 35,
                            height: 35,
                            color: AppColors.black
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Scan QR\nPresensi',
                            textAlign: TextAlign.center,
                            style: AppText.Body1_SemiBold,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKalenderKehadiran() {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Kalender Kehadiran', style: AppText.Heading2),
              GestureDetector(
                onTap: () {},
                child: Text(
                  'Selengkapnya',
                  style: AppText.Body_Bold.copyWith(
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text('Cek histori kehadiranmu di sini.', style: AppText.Body2),
          const SizedBox(height: 12),
          Calendar(),
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
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const dashHeight = 9.0;
    const dashSpace = 6.0;
    double startY = 0;

    while (startY < size.height - 0) {
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