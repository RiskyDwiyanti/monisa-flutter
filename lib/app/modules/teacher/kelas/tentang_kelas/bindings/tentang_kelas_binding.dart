import 'package:get/get.dart';

import '../controllers/tentang_kelas_controller.dart';

class TentangKelasBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TentangKelasController>(
      () => TentangKelasController(),
    );
  }
}
