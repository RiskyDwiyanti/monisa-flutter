import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:monisa/app/theme/app_colors.dart';
import 'package:monisa/app/theme/app_text.dart';

import '../controllers/form_add_class_controller.dart';

class FormAddClassView extends GetView<FormAddClassController> {
  const FormAddClassView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: _buildCard(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: const Icon(Icons.arrow_back, size: 26),
          ),
          const SizedBox(width: 16),
          Text('Tambah kelas', style: AppText.Header1),
        ],
      ),
    );
  }

   Widget _buildCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.black, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label('Mata Pelajaran'),
          Obx(() {
            if (controller.isLoadingMapel.value) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              );
            }

            if (controller.mapelErrorMessage.value != null) {
              return Text(
                controller.mapelErrorMessage.value!,
                style: AppText.Body2.copyWith(color: Colors.red),
              );
            }

            if (controller.mapelOptions.isEmpty) {
              return Text('Belum ada mapel yang Anda ajar.',
                  style: AppText.Body2);
            }

            return _dropdown<MapelOption>(
              value: controller.selectedMapel.value,
              items: controller.mapelOptions,
              labelBuilder: (e) => e.name,
              onChanged: controller.onMapelChanged,
            );
          }),
          const SizedBox(height: 20),

          _label('Deskripsi'),
          _textArea(controller.deskripsiC, 'Masukkan deskripsi ...'),
          const SizedBox(height: 20),

          _label('Tahun Ajaran'),
          Obx(() => _dropdown<String>(
                value: controller.selectedTahunAjaran.value,
                items: controller.tahunAjaranOptions,
                labelBuilder: (e) => e,
                onChanged: controller.onTahunAjaranChanged,
              )),
          const SizedBox(height: 20),

          _label('Kelas'),
          Obx(() {
            if (controller.selectedMapel.value == null) {
              return Text('Pilih mata pelajaran terlebih dahulu.',
                  style: AppText.Body2);
            }

            if (controller.isLoadingOptions.value) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              );
            }

            if (controller.errorMessage.value != null) {
              return Text(
                controller.errorMessage.value!,
                style: AppText.Body2.copyWith(color: Colors.red),
              );
            }

            if (controller.rombelOptions.isEmpty) {
              return Text(
                'Tidak ada kelas untuk mapel & tahun ajaran ini.',
                style: AppText.Body2,
              );
            }

            return Row(
              children: [
                Expanded(
                  child: _dropdown<String>(
                    value: controller.selectedJenjang.value,
                    items: controller.jenjangList,
                    labelBuilder: (e) => e,
                    onChanged: controller.onJenjangChanged,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _dropdown<String>(
                    value: controller.selectedJurusan.value,
                    items: controller.jurusanList,
                    labelBuilder: (e) => e,
                    onChanged: controller.selectedJenjang.value == null
                        ? null
                        : controller.onJurusanChanged,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _dropdown<String>(
                    value: controller.selectedKelas.value,
                    items: controller.kelasList,
                    labelBuilder: (e) => e,
                    onChanged: controller.selectedJurusan.value == null
                        ? null
                        : controller.onKelasChanged,
                  ),
                ),
              ],
            );
          }),

          const SizedBox(height: 28),
          const Divider(height: 1, color: AppColors.black),
          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: Obx(() => ElevatedButton(
                  onPressed: controller.isSubmitting.value
                      ? null
                      : controller.submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.Tangerine,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                      side: const BorderSide(color: AppColors.black, width: 1),
                    ),
                  ),
                  child: controller.isSubmitting.value
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text('Tambah kelas',
                          style: AppText.Body1_SemiBold
                              .copyWith(color: AppColors.white)),
                )),
          ),
        ],
      ),
    );
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(text, style: AppText.Body1_SemiBold),
      );

  Widget _textArea(TextEditingController c, String hint) {
    return TextField(
      controller: c,
      maxLines: 3,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppText.Body2.copyWith(color: AppColors.black.withOpacity(0.4)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.black, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.black, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.black, width: 1.4),
        ),
      ),
    );
  }

  Widget _dropdown<T>({
    required T? value,
    required List<T> items,
    required String Function(T) labelBuilder,
    required ValueChanged<T?>? onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: AppColors.black, width: 1),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          hint: const Text('-'),
          onChanged: onChanged,
          items: items
              .map((e) => DropdownMenuItem<T>(
                    value: e,
                    child: Text(labelBuilder(e), style: AppText.Body2),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
