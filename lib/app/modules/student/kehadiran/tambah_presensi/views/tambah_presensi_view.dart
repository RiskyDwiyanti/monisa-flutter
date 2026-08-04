import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:monisa/app/modules/student/kehadiran/tambah_presensi/controllers/tambah_lampiran_controller.dart';
import 'package:monisa/app/modules/student/kehadiran/tambah_presensi/controllers/tambah_presensi_controller.dart';
import 'package:monisa/app/modules/student/kehadiran/tambah_presensi/views/spring_expanded.dart';
import 'package:monisa/app/theme/app_colors.dart';
import 'package:monisa/app/theme/app_text.dart';

class TambahPresensiView extends StatelessWidget {
  TambahPresensiView({super.key});

  final TambahPresensiController keterangan = Get.find();
  final TambahLampiranController lampiran = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            // Card di-scroll, BUKAN di-Expanded tanpa scroll — supaya kalau
            // lampiran gambarnya banyak, kontennya scroll (tidak overflow),
            // dan tingginya mengikuti konten (tidak maksa full-height layar).
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: _buildKeteranganCard(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================== HEADER ==============================
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 52, 20, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Icon(Icons.arrow_back, color: AppColors.black),
          ),
          const SizedBox(width: 12),
          Text('Presensi', style: AppText.Header1),
        ],
      ),
    );
  }

  // ===== CARD =====
  Widget _buildKeteranganCard() {
    return Container(
      width: double.infinity,
      // Clip supaya konten anak (garis header, dsb) tidak menutupi/memotong
      // sudut rounded milik container ini.
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.black, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---- Title with bottom divider ----
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.black, width: 1),
              ),
            ),
            child: Text(
              'Keterangan',
              style: AppText.Header2,
            ),
          ),

          // ---- Radio options (tetap punya padding 16) ----
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Obx(
              () => Row(
                children: [
                  _buildRadioOption('Hadir'),
                  const SizedBox(width: 8),
                  _buildRadioOption('Izin'),
                  const SizedBox(width: 8),
                  _buildRadioOption('Sakit'),
                ],
              ),
            ),
          ),

          // ---- Section lampiran, muncul dengan animasi spring ----
          // TIDAK dibungkus Padding horizontal di sini, karena dash line
          // di dalamnya perlu full-width (mentok kiri-kanan).
          Obx(
            () => SpringExpand(
              expand: keterangan.requiresAttachment,
              child: _buildAttachmentSection(),
            ),
          ),

          // ---- Tombol aksi utama (Scan QR / Kirim), tetap punya padding 16 ----
          Container(
            width: double.infinity,
            // decoration: const BoxDecoration(
            //   border: Border(
            //     top: BorderSide(color: AppColors.black, width: 1),
            //   ),
            // ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Obx(
                () => SizedBox(
                  width: double.infinity,
                  child: GestureDetector(
                    onTap: lampiran.onPrimaryActionTap,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: AppColors.Tangerine,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.black, width: 1),
                      ),
                      child: Center(
                        child: Text(
                          lampiran.primaryActionLabel,
                          style: AppText.SubHeading.copyWith(color: AppColors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadioOption(String label) {
    return GestureDetector(
      onTap: () => keterangan.selectKeterangan(label),
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Radio<String>(
            value: label,
            groupValue: keterangan.selectedKeterangan.value,
            onChanged: (value) => keterangan.selectKeterangan(value!),
            fillColor: WidgetStateProperty.resolveWith<Color>((states) {
              if (states.contains(WidgetState.selected)) {
                return AppColors.Tangerine; // warna saat dipilih
              }
              return AppColors.Tangerine; // ← ganti ini ke warna yang kamu mau saat BELUM dipilih
            }),
            visualDensity: VisualDensity.compact,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          const SizedBox(width: 2),
          Text(
            label,
            style: AppText.SubHeading
          ),
        ],
      ),
    );
  }

  // ===== SECTION: Masukkan surat izin =====
  Widget _buildAttachmentSection() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.black, width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          // Dash line FULL WIDTH, mentok kiri-kanan (tidak ada padding
          // horizontal di sini karena section ini sengaja tidak dibungkus
          // Padding horizontal di _buildKeteranganCard).
          const _DashedDivider(),

          // Sisanya (judul + grid) tetap punya padding 16 kiri-kanan.
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Masukkan surat izin',
                  style: AppText.SubHeading,
                ),
                const SizedBox(height: 12),

                // ---- Grid thumbnail + tombol tambah ----
                Obx(
                  () => Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      ...List.generate(lampiran.attachedFiles.length, (index) {
                        return _buildImageThumb(
                            index, lampiran.attachedFiles[index]);
                      }),
                      _buildAddBox(),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildImageThumb(int index, XFile file) {
    final Uint8List? bytes = lampiran.bytesFor(file);
    const width = 160.0;
    const height = 100.0;

    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.black, width: 1),
            ),
            clipBehavior: Clip.antiAlias,
            child: bytes != null
                ? Image.memory(bytes, fit: BoxFit.cover)
                : const Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
          ),
          const SizedBox(height: 6),

          Row(
            children: [
              Expanded(
                child: Text(
                  file.name, // XFile sudah punya getter .name
                  style: AppText.Body2.copyWith(color: AppColors.black),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              const SizedBox(width: 4),
              GestureDetector(
                onTap: () => lampiran.removeImage(index),
                child: SvgPicture.asset(
                  'assets/icons/close_icon.svg',
                  width: 16,
                  height: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddBox() {
    return GestureDetector(
      onTap: lampiran.pickImage,
      child: Container(
        width: 160,
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.black, width: 1),
        ),
        child: Center(
          child: SvgPicture.asset(
            'assets/icons/plus_icon.svg',
            width: 32,
            height: 32,
          ),
        ),
      ),
    );
  }
}

// ===== Garis putus-putus horizontal =====
class _DashedDivider extends StatelessWidget {
  const _DashedDivider();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 1,
      width: double.infinity,
      child: LayoutBuilder(
        builder: (context, constraints) {
          const dashWidth = 10.4;
          const dashSpace = 5.0;
          final count =
              (constraints.maxWidth / (dashWidth + dashSpace)).floor();
          return Row(
            children: List.generate(count, (_) {
              return Padding(
                padding: const EdgeInsets.only(right: dashSpace),
                child: Container(
                  width: dashWidth,
                  height: 1,
                  color: AppColors.black,
                ),
              );
            }),
          );
        },
      ),
    );
  }
}