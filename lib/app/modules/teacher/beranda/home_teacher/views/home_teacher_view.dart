import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:monisa/app/modules/teacher/home_teacher/views/widget/draft_tugas_card.dart';
import 'package:monisa/app/modules/teacher/home_teacher/views/widget/jadwal_item_tile.dart';
import 'package:monisa/app/theme/app_colors.dart';
import 'package:monisa/app/theme/app_text.dart';

import '../controllers/home_teacher_controller.dart';

class HomeTeacherView extends GetView<HomeTeacherController> {
  const HomeTeacherView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.Butter,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              // width: double.infinity,
              color: AppColors.Butter,
              padding:  const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: _buildHeader(),
            ),

            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: _buildJadwalSection(),
                      ),
                      const SizedBox(height: 24),
                      _buildDraftTugasSection(),
                    ],
                  ),
                ),
              ), 
            ),
          ],
        )
      )
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(left: 0),
      child: Container(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        // decoration: BoxDecoration(
        //   color: AppColors.Lychee,
        // ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(() => Text(
                  'Selamat Pagi, ${controller.nama.value}!',
                  style: AppText.Header1,
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

  Widget _buildJadwalSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Jadwal Mengajar',
          style: AppText.Header2,
        ),
        const SizedBox(height: 4),
        Text(
          'Lihat di mana anda mengajar hari ini.',
          style: AppText.SubHeading,
        ),
        const SizedBox(height: 14),
        Container(
          height: 240,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.black),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Obx(() {
            if (controller.isLoadingSchedule.value) {
              return const Center(child: CircularProgressIndicator());
            }
            if (controller.scheduleError.value.isNotEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      controller.scheduleError.value,
                      style: TextStyle(color: Colors.red.shade400, fontSize: 12),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: controller.fetchSchedule,
                      child: const Text('Coba lagi'),
                    ),
                  ],
                ),
              );
            }
            if (controller.scheduleList.isEmpty) {
              return const Center(child: Text('Tidak ada jadwal mengajar hari ini'));
            }
            return ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: controller.scheduleList.length,
              itemBuilder: (context, i) => JadwalItemTile(jadwal: controller.scheduleList[i]),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildDraftTugasSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Draf Tugas',
                style: AppText.Header2,
              ),
              const SizedBox(height: 4),
              Text(
                'Mari selesaikan dan kirim draf tugas anda!',
                style: AppText.SubHeading,
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: IntrinsicHeight(
            child: Row(
              children: [
                for (int i = 0; i < controller.draftTugasList.length; i++) ...[
                  if (i != 0) const SizedBox(width: 12),
                  DraftTugasCard(draft: controller.draftTugasList[i]),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
