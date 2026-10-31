import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:monisa/app/modules/teacher/kelas/class_info/views/widget/info_widgets.dart';
import 'package:monisa/app/theme/app_colors.dart';
import 'package:monisa/app/theme/app_text.dart';

import '../controllers/tentang_kelas_controller.dart';

class TentangKelasView extends GetView<TentangKelasController> {
  const TentangKelasView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Obx(() {
                final about = controller.about.value;

                if (controller.isLoading.value && about == null) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.errorMessage.value != null && about == null) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            controller.errorMessage.value!,
                            textAlign: TextAlign.center,
                            style: AppText.Body2,
                          ),
                          const SizedBox(height: 16),
                          OutlinedButton(
                            onPressed: controller.fetchAll,
                            child: Text('Coba lagi', style: AppText.Body1_SemiBold),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (about == null) return const SizedBox.shrink();

                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Column(
                    children: [
                      InfoTabSwitcher(
                        labels: ['Ikhtisar', 'Siswa (${controller.students.length})'],
                        selectedIndex: controller.selectedTab.value,
                        onChanged: controller.onTabChanged,
                      ),
                      const SizedBox(height: 16),
                      if (controller.selectedTab.value == 0)
                        _buildOverview(about)
                      else
                        _buildStudents(),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 52, 20, 24),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: const Icon(Icons.arrow_back, size: 26),
          ),
          const SizedBox(width: 16),
          Text('Tentang Kelas', style: AppText.Header1),
        ],
      ),
    );
  }

  BoxDecoration get _cardDecoration => BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.black, width: 1),
      );

  // ============== IKHTISAR ==============
  Widget _buildOverview(ClassAbout a) {
    final text = a.descriptionText;

    return Container(
      width: double.infinity,
      decoration: _cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(a.schoolMapel ?? a.name, style: AppText.Header2),
          ),
          const Divider(height: 1, color: AppColors.black),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    InfoAvatar(url: a.teacherPhoto, name: a.teacherName, size: 48),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(a.teacherName, style: AppText.Body1_SemiBold),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  (text.isEmpty) ? 'Tidak ada deskripsi.' : text,
                  style: AppText.Body2,
                ),
              ],
            ),
          ),
          const InfoDashedDivider(),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow('icons/door_icon.svg', 'Kelas: ', a.rombel ?? '-'),
                const SizedBox(height: 10),
                _buildInfoRow('icons/calendar_icon.svg', 'Tahun ajaran: ', a.tahunAjaran ?? '-'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String iconPath, String label, String value) {
    return Row(
      children: [
        SvgPicture.asset(
          iconPath,
          width: 20,
          height: 20,
          color: AppColors.black,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text.rich(
            TextSpan(
              style: AppText.Body2,
              children: [
                TextSpan(text: label),
                TextSpan(
                  text: value,
                  style: AppText.Body2.copyWith(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ============== SISWA ==============
  Widget _buildStudents() {
    final list = controller.students;

    return Container(
      width: double.infinity,
      decoration: _cardDecoration,
      child: list.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(20),
              child: Text('Belum ada siswa di kelas ini.', style: AppText.Body2),
            )
          : Column(
              children: list.asMap().entries.map((entry) {
                final isLast = entry.key == list.length - 1;
                final s = entry.value;

                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => controller.onStudentTap(s),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: isLast
                          ? null
                          : const Border(
                              bottom: BorderSide(color: AppColors.black, width: 1)),
                    ),
                    child: Row(
                      children: [
                        InfoAvatar(url: s.photo, name: s.name, size: 50, color: InfoAvatar.colorFor(s.id)),
                        const SizedBox(width: 16),
                        Expanded(child: Text(s.name, style: AppText.Body1_SemiBold)),
                        Text(s.progressLabel, style: AppText.Body1_SemiBold),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
    );
  }

}