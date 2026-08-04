import 'package:get/get.dart';

class TambahPresensiController extends GetxController {
  //TODO: Implement TambahPresensiController
  final RxString selectedKeterangan = 'Hadir'.obs;
 
  /// Izin & Sakit butuh lampiran surat, Hadir tidak.
  bool get requiresAttachment => selectedKeterangan.value != 'Hadir';
 
  void selectKeterangan(String value) {
    selectedKeterangan.value = value;
  }

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
    super.onClose();
  }

  void increment() => count.value++;
}
