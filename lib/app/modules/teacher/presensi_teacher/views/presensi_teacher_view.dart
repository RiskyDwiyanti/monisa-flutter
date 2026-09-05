import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:monisa/app/modules/teacher/presensi_teacher/views/widget/attendance_donut_chart.dart';
import 'package:monisa/app/modules/teacher/presensi_teacher/views/widget/student_attendance_tile.dart';
import 'package:monisa/app/theme/app_colors.dart';
import 'package:monisa/app/theme/app_text.dart';

import '../controllers/presensi_teacher_controller.dart';

class PresensiTeacherView extends GetView<PresensiTeacherController> {
  const PresensiTeacherView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value && controller.students.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 20),
                  _buildInfoCards(),
                  const SizedBox(height: 20),
                  _buildTabBar(),
                  _buildStudentList()
                ],
              ),
            )
          );
        }),
      )
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 40, 0, 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Presensi siswa',
            style: AppText.Header1,
          ),
          InkWell(
            onTap: () {
              // TODO: navigasi ke halaman daftar kelas/siswa
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.black),
              ),
              child: SvgPicture.asset(
                'assets/icons/people_icon.svg',
                width: 24,
                height: 24,
              )
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCards() {
    return Obx(() {
      final date = controller.attendanceDate.value;
      const hariList = ['Senin', 'Selasa', 'Rabu', 'Kamis', "Jum'at", 'Sabtu', 'Minggu'];
      final hari = hariList[date.weekday - 1];
      final tanggal = '${date.day} ${_bulan(date.month)} ${date.year}';
      final jam =
          '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')} WIB';
 
      return IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: _InfoCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(hari, style: AppText.Header2),
                    const SizedBox(height: 7),
                    Text(tanggal, style: AppText.SubHeading),
                    const SizedBox(height: 3),
                    Text(jam, style: AppText.Body1),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 9),
            Expanded(
              child: _InfoCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(controller.fullClassName,
                        style: AppText.Header2),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        AttendanceDonutChart(
                          percentage: controller.hadirPercentage,
                          hadirColor: AppColors.Electric,
                          tidakHadirColor: AppColors.Tangerine,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${controller.hadirCount} Hadir',
                                  style: AppText.Body1_SemiBold),
                              Text('${controller.tidakHadirCount} Tidak hadir',
                                  style: AppText.Body1_SemiBold),
                            ],
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
      );
    });
  }

  String _bulan(int m) {
    const bulan = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Ags', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    return bulan[m - 1];
  }
 
  Widget _buildTabBar() {
    return Obx(() {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.black),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        ),
        child: Row(
          children: [
            Expanded(child: _tabButton('Hadir', 0)),
            Expanded(child: _tabButton('Tidak hadir', 1)),
          ],
        ),
      );
    });
  }

  Widget _tabButton(String label, int index) {
    final selected = controller.tabIndex.value == index;
    return GestureDetector(
      onTap: () => controller.changeTab(index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: selected ? AppColors.Tangerine : AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: index == 0 ? const Radius.circular(11) : Radius.zero,
            topRight: index == 1 ? const Radius.circular(11) : Radius.zero,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: AppText.Body_Bold.copyWith(
            color: selected ? AppColors.white : AppColors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildStudentList() {
    return Obx(() {
      final list = controller.filteredStudents;
 
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.black, width: 1),
            left: BorderSide(color: AppColors.black, width: 1),
            right: BorderSide(color: AppColors.black, width: 1),
          ),
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
        ),
        child: list.isEmpty
            ? const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Center(child: Text('Belum ada data')),
              )
            : Column(
              children: list.map((student) {
                return StudentAttendanceTile(
                  student: student,
                  onTap: () {
                    // TODO
                  },
                );
              }).toList(),
            ),
        );
    });
  }
}

class _InfoCard extends StatelessWidget {
  final Widget child;
  const _InfoCard({required this.child});
 
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.black),
        borderRadius: BorderRadius.circular(14),
      ),
      child: child,
    );
  }
}