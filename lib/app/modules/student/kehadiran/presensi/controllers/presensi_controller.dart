import 'package:get/get.dart';
import 'package:monisa/app/data/services/presensi_service.dart';

enum StatusPresensi {
  hadir,
  izin,
  sakit,
  alpha,
  libur,
}

class PresensiHari {
  final int tanggal;
  final StatusPresensi status;
 
  PresensiHari({required this.tanggal, required this.status});
}

class RekapKehadiran {
  final int hadir;
  final int izin;
  final int sakit;
  final int alpha;
  final int libur;
 
  RekapKehadiran({
    required this.hadir,
    required this.izin,
    required this.sakit,
    required this.alpha,
    required this.libur,
  });
}

class PresensiController extends GetxController {
  //TODO: Implement PresensiController
  final PresensiService _presensiService = PresensiService();
  final focusedMonth = DateTime.now().obs;
  final selectedSemester = 'Semester 4'.obs;
  final List<String> semesterList = [
    'Semester 1',
    'Semester 2',
    'Semester 3',
    'Semester 4',
    'Semester 5',
    'Semester 6',
  ];

  // Info presensi terkini
  final String hariIni = "Jum'at";
  final String tanggalHariIni = "15 Mei 2026";
  final String lokasiKelas = "Lorem Ipsum";
  final String waktuMasuk = "08:06:15";
  final String keterangan = "Sakit";
  final int jumlahLampiran = 2;

  final RxMap<DateTime, String> attendanceStatus = <DateTime, String>{}.obs;
  final RxBool isLoadingAttendance = false.obs;

  // Rekap
  final int rekapHadir = 125;
  final int rekapIzin = 4;
  final int rekapSakit = 3;
  final int rekapAlpha = 1;
  final int rekapLibur = 45;

  int get rekapTotal => rekapHadir + rekapIzin + rekapSakit + rekapAlpha + rekapLibur;

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

  Future<void> fetchAttendance(int year, int month) async {
    try {
      isLoadingAttendance.value = true;

      final result = await _presensiService.getAttendances(
        year: year,
        month: month,
      );

      if (result['success'] == true && result['data'] != null) {
        final List rawList = result['data'] as List;
        final Map<DateTime, String> parsed = {};

        for (final item in rawList) {
          final tanggalStr = item['tanggal'];
          final status = item['status'];

          if (tanggalStr == null || status == null) continue;

          final date = DateTime.parse(tanggalStr.toString());
          parsed[DateTime(date.year, date.month, date.day)] =
              status.toString().toLowerCase();
        }

        // Hapus data lama utk bulan ini supaya tidak stale, lalu masukkan
        // hasil fetch terbaru.
        attendanceStatus.removeWhere(
          (key, value) => key.year == year && key.month == month,
        );
        attendanceStatus.addAll(parsed);
      } else {
        Get.snackbar(
          'Gagal',
          result['message'] ?? 'Gagal memuat data presensi.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
      } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan saat memuat data presensi.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoadingAttendance.value = false;
    }
  }
}
