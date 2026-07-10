import 'package:get/get.dart';
import 'package:monisa/app/modules/student/detail_tugas/controllers/tambah_tugas_controller.dart';

import '../controllers/detail_tugas_controller.dart';

class DetailTugasBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailTugasController>(
      () => DetailTugasController(),
    );
    Get.lazyPut<TambahTugasController>(
      () => TambahTugasController(),
    );
  }
}
