import 'package:get/get.dart';

import '../controllers/sqan_qr_presensi_controller.dart';

class SqanQrPresensiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SqanQrPresensiController>(
      () => SqanQrPresensiController(),
    );
  }
}
