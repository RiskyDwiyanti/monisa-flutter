import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanQrController extends GetxController {
  //TODO: Implement ScanQrController
  final MobileScannerController scannerController = MobileScannerController();
  final isProcessing = false.obs;

  void onDetect(BarcodeCapture capture) {
    if (isProcessing.value) return;

    final barcode = capture.barcodes.first;
    final rawValue = barcode.rawValue;

    if (rawValue != null) {
      isProcessing.value = true;
      // Process the scanned QR code value here
      print('Scanned QR Code: $rawValue');

      // Simulate a delay for processing
      Future.delayed(const Duration(seconds: 1), () {
        Get.back(result: rawValue); // Return the scanned value to the previous screen
      });
    }
  }

  // void toggleFlash() {
  //   scannerController.toggleTorch();
  // }

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    scannerController.dispose();
    super.onClose();
  }

  void increment() => count.value++;
}
