import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:monisa/app/modules/student/class/views/widgets/custom_kelas_card.dart';
import 'package:monisa/app/routes/app_pages.dart';
import 'package:monisa/app/theme/app_colors.dart';
import 'package:monisa/app/theme/app_text.dart';

import '../controllers/class_controller.dart';

class ClassView extends GetView<ClassController> {
  const ClassView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _buildKelasList(),
            ),
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
          Text('Kelas', style: AppText.Heading1),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: AppColors.black, width: 1),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Get.toNamed(Routes.TUGAS);
                  },
                  child: SvgPicture.asset(
                    'assets/icons/list_icon.svg',
                    width: 22,
                    height: 22,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    Get.toNamed(Routes.SCAN_QR);
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

  Widget _buildKelasList() {
    return Obx(() => ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      itemCount: controller.kelasList.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final item = controller.kelasList[index];
        return KelasCard(
          mataPelajaran: item.mapel,
          kelas: item.kelas,
          tahunAjaran: item.tahunAjaran,
          namaGuru: item.namaGuru,
          fotoGuru: item.fotoGuru,
          bgColor: item.bgColor,
          onTap: () {
            Get.toNamed(Routes.KELAS_SELECTED, arguments: {
              'mapel': item.mapel,
              'kelas': item.kelas,
              'tahunAjaran': item.tahunAjaran,
              'bgColor': item.bgColor,
            });
          },
          onQrTap: () {
            Get.toNamed(Routes.QR_SHARING, arguments: {
              'mapel': item.mapel,
              'kelas': item.kelas,
              'tahunAjaran': item.tahunAjaran,
              'bgColor': item.bgColor,
            });
          },
        );
      },
    ));
  }

}
