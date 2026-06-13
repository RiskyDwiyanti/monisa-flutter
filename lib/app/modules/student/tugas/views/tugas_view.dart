import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:monisa/app/modules/student/tugas/views/widget/tugas_list_card.dart';
import 'package:monisa/app/theme/app_colors.dart';
import 'package:monisa/app/theme/app_text.dart';

import '../controllers/tugas_controller.dart';

class TugasView extends GetView<TugasController> {
  const TugasView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body:  SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchBar(),
            const SizedBox(height: 26),
            _buildToolbar(),
            const SizedBox(height: 26),
            Expanded(child: _buildTugasList()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 52, 20, 20),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Icon(Icons.arrow_back, color: AppColors.black),
          ),
          const SizedBox(width: 12),
          Text(
            'Daftar Tugas',
            style: AppText.Heading1,
          ),
        ],
      ),
    );
  }

   Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.black, width: 1),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/icons/search_icon.svg',
              width: 24,
              height: 24,
              color: AppColors.black,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextField(
                onChanged: controller.onSearchChanged,
                decoration: InputDecoration(
                  hintText: 'Cari',
                  hintStyle: AppText.Body2.copyWith(color: AppColors.black),
                  border: InputBorder.none,
                  isDense: true,
                ),
                style: AppText.Body2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolbar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // ===== SORT BUTTON =====
          GestureDetector(
            onTap: controller.toggleSort,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: AppColors.black, width: 1),
              ),
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/sort_icon.svg',
                    width: 25,
                    height: 25,
                    color: AppColors.black,
                  ),
                  const SizedBox(width: 6),
                  Obx(() => Text(
                        controller.sortNewest.value ? 'Terbaru' : 'Terlama',
                        style: AppText.Body1_SemiBold,
                      )),
                ],
              ),
            ),
          ),

          // ===== FILTER BUTTON =====
          GestureDetector(
            onTap: controller.openFilter,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: AppColors.black, width: 1),
              ),
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/filter_icon.svg',
                    width: 24,
                    height: 24,
                    color: AppColors.black,
                  ),
                  const SizedBox(width: 6),
                  Text('Filter', style: AppText.Body1_SemiBold),
                  Obx(() {
                    if (controller.activeFilterCount.value == 0) {
                      return const SizedBox.shrink();
                    }
                    return Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: CircleAvatar(
                        radius: 10,
                        backgroundColor: AppColors.Sky,
                        child: Text(
                          '${controller.activeFilterCount.value}',
                          style: AppText.Body1_SemiBold.copyWith(
                            color: AppColors.black,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTugasList() {
    return Obx(() => ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      itemCount: controller.filteredTugas.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final tugas = controller.filteredTugas[index];
          return TugasListCard(
            title: tugas.title,
            subject: tugas.subject,
            deadline: tugas.deadline,
            status: tugas.status,
            bgColor: tugas.bgColor,
            onTap: () {},
          );
        },
      )
    );
  }
}
