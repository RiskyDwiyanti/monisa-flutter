import 'package:get/get.dart';

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
  final focusedMonth = DateTime(2026, 5).obs;
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

  // Data presensi per tanggal (bulan Mei 2026)
  final Map<DateTime, String> attendanceStatus = {
    DateTime(2026, 5, 4): 'hadir',
    DateTime(2026, 5, 5): 'hadir',
    DateTime(2026, 5, 6): 'hadir',
    DateTime(2026, 5, 7): 'hadir',
    DateTime(2026, 5, 8): 'hadir',
    DateTime(2026, 5, 11): 'hadir',
    DateTime(2026, 5, 12): 'hadir',
    DateTime(2026, 5, 13): 'sakit',
    DateTime(2026, 5, 14): 'libur',
    DateTime(2026, 5, 15): 'sakit',
  };

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
}
