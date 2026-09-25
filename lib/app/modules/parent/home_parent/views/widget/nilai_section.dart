import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monisa/app/modules/parent/home_parent/controllers/home_parent_controller.dart';
import 'package:monisa/app/theme/app_colors.dart';
import 'package:monisa/app/theme/app_text.dart';

class NilaiSection extends StatelessWidget {
  final HomeParentController controller;

  const NilaiSection({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Rekap Nilai',
              style: AppText.Header2,
            ),
            GestureDetector(
              onTap: () {
                // TODO: navigate to full nilai page
              },
              child: Text(
                'Selengkapnya',
                style: AppText.Body.copyWith(
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 4),

        Text(
          'Cek rekap nilai anak di sini.',
          style: AppText.SubHeading,
        ),

        const SizedBox(height: 12),

        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            // border: Border.all(
            //   color: AppColors.black,
            //   width: 1,
            // ),
          ),
          clipBehavior: Clip.antiAlias,
          child: Obx(() {
            final nilai = controller.nilaiList;

            return Table(
              columnWidths: const {
                0: FlexColumnWidth(3),
                1: FlexColumnWidth(2),
                2: FlexColumnWidth(2),
              },
              border: TableBorder.all(
                color: AppColors.black,
                width: 1,
              ),
              children: [
                // HEADER
                TableRow(
                  decoration: const BoxDecoration(
                    color: AppColors.Tangerine,
                  ),
                  children: [
                    _buildHeaderCell('Mata pelajaran'),
                    _buildHeaderCell('Rerata'),
                    _buildHeaderCell('Tugas terkumpul'),
                  ],
                ),

                // DATA
                for (int i = 0; i < nilai.length; i++)
                  _buildDataRow(
                    nilai[i],
                    isLast: i == nilai.length - 1,
                  ),
              ],
            );
          }),
        ),
      ],
    );
  }

  Widget _buildHeaderCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 12,
      ),
      child: Text(
        text,
        style: AppText.body_grafik,
      ),
    );
  }

  TableRow _buildDataRow(
    NilaiModel nilai, {
    required bool isLast,
  }) {
    final rerataLabel =
        nilai.rerata.truncateToDouble() == nilai.rerata
            ? nilai.rerata.toStringAsFixed(0)
            : nilai.rerata.toStringAsFixed(1);

    return TableRow(
      children: [
        _buildDataCell(
          nilai.mataPelajaran,
        ),
        _buildDataCell(
          rerataLabel,
        ),
        _buildDataCell(
          nilai.tugasTerkumpul,
        ),
      ],
    );
  }

  Widget _buildDataCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 14,
        horizontal: 12,
      ),
      child: Text(
        text,
        style: AppText.Body,
      ),
    );
  }
}