import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:monisa/app/theme/app_colors.dart';
import 'package:monisa/app/theme/app_text.dart';

import '../controllers/scan_qr_controller.dart';

class ScanQrView extends GetView<ScanQrController> {
  const ScanQrView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.Tangerine,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Padding(
              padding: const EdgeInsetsGeometry.fromLTRB(20, 0, 20, 20),
              child: _buildScannerCard(),
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
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Icon(Icons.arrow_back, color: AppColors.white),
          ),
          const SizedBox(width: 12),
          Text(
            'Scan QR',
            style: AppText.Heading1.copyWith(color: AppColors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildScannerCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.black, width: 1),
      ),
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 4/6,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.black, width: 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(11),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      MobileScanner(
                        controller: controller.scannerController,
                        onDetect: controller.onDetect,
                      ),
                      // Overlay frame corners (opsional)
                      // _buildScannerOverlay(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Arahkan kode QR ke dalam kotak',
            style: AppText.SubHeading,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

   Widget _buildScannerOverlay() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.Butter,
          width: 3,
        ),
        borderRadius: BorderRadius.circular(11),
      ),
    );
  }
}
