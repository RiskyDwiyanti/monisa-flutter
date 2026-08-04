import 'package:get/get.dart';

import '../controllers/qr_sharing_controller.dart';

class QrSharingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QrSharingController>(
      () => QrSharingController(),
    );
  }
}
