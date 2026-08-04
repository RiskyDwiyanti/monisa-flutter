import 'package:get/get.dart';
import 'package:monisa/app/modules/student/kehadiran/tambah_presensi/controllers/tambah_lampiran_controller.dart';

import '../controllers/tambah_presensi_controller.dart';

class TambahPresensiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TambahPresensiController>(
      () => TambahPresensiController(),
    );
    Get.lazyPut<TambahLampiranController>(
      () => TambahLampiranController(),
    );
  }
}
