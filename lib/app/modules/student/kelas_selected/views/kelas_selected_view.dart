import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:monisa/app/theme/app_colors.dart';
import 'package:monisa/app/theme/app_text.dart';

import '../controllers/kelas_selected_controller.dart';

class KelasSelectedView extends GetView<KelasSelectedController> {
  const KelasSelectedView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(child: _buildContent()),
          ],
        ),
      ),
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
          Text(controller.mapel, style: AppText.Heading1),
          const Spacer(),
          GestureDetector(
            onTap: () {

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

  Widget _buildContent() {
    return Obx(() => ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          itemCount: controller.materiGroups.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final group = controller.materiGroups[index];
            return _buildMateriGroupCard(group);
          },
        ));
  }

  Widget _buildMateriGroupCard(MateriGroup group) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.black, width: 1),
      ),
      child: Column(
        children: [
          // ===== HEADER GROUP =====
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: const BoxDecoration(
              color: AppColors.Blush,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Text(
              group.title,
              style: AppText.Heading2.copyWith(color: AppColors.white),
            ),
          ),

          // ===== LIST ITEM =====
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
                          bottom: BorderSide(color: AppColors.black, width: 1),
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
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.black, width: 1),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          item.icon,
                          width: 18,
                          height: 18,
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
                          const SizedBox(height: 4),
                          Text(item.tanggal, style: AppText.Body2),
                        ],
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
}
