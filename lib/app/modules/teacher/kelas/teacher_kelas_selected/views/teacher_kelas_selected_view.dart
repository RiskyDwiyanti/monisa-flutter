import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:monisa/app/modules/teacher/kelas/content_draft/views/widget/teacher_content_draft_dialog.dart';
import 'package:monisa/app/theme/app_colors.dart';
import 'package:monisa/app/theme/app_text.dart';

import '../controllers/teacher_kelas_selected_controller.dart';

class TeacherKelasSelectedView extends GetView<TeacherKelasSelectedController> {
  const TeacherKelasSelectedView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
      floatingActionButton: _buildAddButton(context),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 52, 20, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Icon(Icons.arrow_back, color: AppColors.black),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(controller.mapel, style: AppText.Header1)),
          GestureDetector(
            onTap: () {
              // TODO: info kelas
            },
            child: SvgPicture.asset(
              'assets/icons/info_icon.svg',
              width: 23,
              height: 23,
              color: AppColors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Obx(() {
      if (controller.isLoading.value && controller.materiGroups.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.errorMessage.value != null &&
          controller.materiGroups.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              controller.errorMessage.value!,
              textAlign: TextAlign.center,
              style: AppText.Body2,
            ),
          ),
        );
      }

      if (controller.materiGroups.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Belum ada materi. Tekan + untuk menambahkan.',
              textAlign: TextAlign.center,
              style: AppText.Body2,
            ),
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: controller.fetchClassContents,
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
          itemCount: controller.materiGroups.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final group = controller.materiGroups[index];
            return _buildMateriGroupCard(group);
          },
        ),
      );
    });
  }

  Widget _buildMateriGroupCard(MateriGroup group) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.black, width: 1),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: controller.bgColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Text(
              group.title,
              style: AppText.Header2.copyWith(color: AppColors.white),
            ),
          ),
          if (group.items.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Belum ada konten di topik ini.',
                  style: AppText.Body2,
                ),
              ),
            )
          else
            ...group.items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isLast = index == group.items.length - 1;

              return GestureDetector(
                onTap: () => controller.onMateriTap(item),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    border: isLast
                        ? null
                        : const Border(
                            bottom: BorderSide(
                              color: AppColors.black,
                              width: 1,
                            ),
                          ),
                    borderRadius: isLast
                        ? const BorderRadius.only(
                            bottomLeft: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                          )
                        : null,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.black, width: 1),
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            item.icon,
                            width: 25,
                            height: 25,
                            color: AppColors.black,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.title, style: AppText.Body1_SemiBold),
                            const SizedBox(height: 8),
                            Text(item.tanggal, style: AppText.Body2),
                          ],
                        ),
                      ),
                      if (!item.isPublished)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.black.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Draft',
                            style: AppText.Body2.copyWith(
                              color: AppColors.black,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: GestureDetector(
        onTap: () => _showAddSheet(context),
        child: Container(
          width: 55,
          height: 55,
          decoration: BoxDecoration(
            color: controller.bgColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.black, width: 1),
          ),
          child: const Icon(Icons.add, color: Colors.white, size: 28),
        ),
      ),
    );
  }

  void _showAddSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(
          16,
          24,
          16,
          24 + MediaQuery.of(context).padding.bottom,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          border: Border(top: BorderSide(color: AppColors.black, width: 1)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _AddSheetOption(
              icon: 'assets/icons/book_outline_icon.svg',
              label: 'Materi',
              onTap: () {
                Get.back();
                openTeacherContentDraftDialog(
                  context,
                  classId: controller.classId,
                  type: 'material',
                );
              },
            ),
            _AddSheetOption(
              icon: 'assets/icons/pen_icon.svg',
              label: 'Tugas',
              onTap: () {
                Get.back();
                openTeacherContentDraftDialog(
                  context,
                  classId: controller.classId,
                  type: 'assignment',
                );
              },
            ),
            _AddSheetOption(
              icon: 'assets/icons/pen_icon.svg',
              label: 'Kuis',
              onTap: () {
                Get.back();
                openTeacherContentDraftDialog(
                  context,
                  classId: controller.classId,
                  type: 'quiz',
                );
              },
            ),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: false,
    );
  }
}

class _AddSheetOption extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onTap;

  const _AddSheetOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.black, width: 1),
            ),
            child: Center(
              child: SvgPicture.asset(
                icon,
                width: 40,
                height: 36,
                color: AppColors.black,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(label, style: AppText.Body2),
        ],
      ),
    );
  }
}
