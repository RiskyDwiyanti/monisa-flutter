import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:monisa/app/modules/teacher/kelas/class_info/views/widget/info_widgets.dart';
import 'package:monisa/app/theme/app_colors.dart';
import 'package:monisa/app/theme/app_text.dart';

import '../controllers/class_student_detail_controller.dart';

class ClassStudentDetailView extends GetView<ClassStudentDetailController> {
  const ClassStudentDetailView({super.key});
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
                final student = controller.student.value;

                if (controller.isLoading.value && student == null) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.errorMessage.value != null && student == null) {
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
                            onPressed: controller.fetchDetail,
                            child: Text('Coba lagi', style: AppText.Body1_SemiBold),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (student == null) return const SizedBox.shrink();

                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Column(
                    children: [
                      _buildProfileCard(student),
                      const SizedBox(height: 16),
                      _buildTasksCard(),
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
          Text('Tentang Siswa', style: AppText.Header1),
        ],
      ),
    );
  }

  BoxDecoration get _cardDecoration => BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.black, width: 1),
      );

  Widget _buildProfileCard(StudentProfile s) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration,
      child: Row(
        children: [
          InfoAvatar(
            url: s.photo, 
            name: s.name, 
            size: 100, 
            circle: false, 
            color: InfoAvatar.colorFor(s.id),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s.name, style: AppText.Header2),
                if (s.classLabel.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(s.classLabel, style: AppText.Body1_SemiBold),
                ],
                if (s.idLabel != null) ...[
                  const SizedBox(height: 8),
                  Text(s.idLabel!, style: AppText.Body1_SemiBold),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTasksCard() {
    final isDone = controller.selectedTab.value == 0;
    final items = isDone ? controller.completed : controller.notSubmitted;

    return Container(
      width: double.infinity,
      decoration: _cardDecoration,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(19),
        child: Column(
          children: [
            InfoTabSwitcher(
              labels: const ['Selesai', 'Belum terkumpul'],
              selectedIndex: controller.selectedTab.value,
              onChanged: controller.onTabChanged,
              standalone: false,
            ),
            const Divider(height: 1, color: AppColors.black),
            if (items.isEmpty)
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  isDone
                      ? 'Belum ada tugas atau kuis yang diselesaikan.'
                      : 'Tidak ada tugas atau kuis yang belum dikumpulkan.',
                  style: AppText.Body2,
                ),
              )
            else
              ...items.asMap().entries.map((entry) {
                final isLast = entry.key == items.length - 1;
                final t = entry.value;

                return Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: isLast
                        ? null
                        : const Border(
                            bottom: BorderSide(color: AppColors.black, width: 1)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(t.title, style: AppText.Body1_SemiBold),
                            const SizedBox(height: 6),
                            Text(
                              isDone
                                  ? t.dateLabel
                                  : (t.date == null ? 'Tanpa tenggat' : 'Tenggat: ${t.dateLabel}'),
                              style: AppText.Body2,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(t.scoreLabel, style: AppText.Body1_SemiBold),
                    ],
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}
