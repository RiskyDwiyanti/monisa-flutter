import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monisa/app/modules/parent/home_parent/controllers/home_parent_controller.dart';
import 'package:monisa/app/theme/app_colors.dart';
import 'package:monisa/app/theme/app_text.dart';

class NilaiSection extends StatelessWidget {
  final HomeParentController controller;
  const NilaiSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Rekap Nilai', style: AppText.Header2),
            GestureDetector(
              onTap: () {
                // TODO: navigate to full nilai page
              },
              child: Text(
                'Selengkapnya',
                style: AppText.Body.copyWith(decoration: TextDecoration.underline),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text('Cek rekap nilai anak di sini.', style: AppText.SubHeading),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.black),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              _buildHeaderRow(),
              Obx(() {
                final nilai = controller.nilaiList;
                return Column(
                  children: [
                    for (int i = 0; i < nilai.length; i++)
                      _buildDataRow(nilai[i], isLast: i == nilai.length - 1),
                  ],
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderRow() {
    return Container(
      color: AppColors.Tangerine,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text('Mata pelajaran', style: AppText.body_grafik)),
          Expanded(flex: 2, child: Text('Rerata', style: AppText.body_grafik)),
          Expanded(flex: 2, child: Text('Tugas terkumpul', style: AppText.body_grafik)),
        ],
      ),
    );
  }

  Widget _buildDataRow(NilaiModel nilai, {required bool isLast}) {
    final rerataLabel = nilai.rerata.truncateToDouble() == nilai.rerata
        ? nilai.rerata.toStringAsFixed(0)
        : nilai.rerata.toStringAsFixed(1);
 
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        border: isLast ? null : const Border(bottom: BorderSide(color: AppColors.black, width: 1)),
      ),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text(nilai.mataPelajaran, style: AppText.Body)),
          Expanded(flex: 2, child: Text(rerataLabel, style: AppText.Body)),
          Expanded(flex: 2, child: Text(nilai.tugasTerkumpul, style: AppText.Body)),
        ],
      ),
    );
  }
}