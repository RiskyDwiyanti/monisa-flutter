import 'package:flutter/painting.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:monisa/app/data/services/home_service.dart';
import 'package:monisa/app/theme/app_colors.dart';

enum StatusPresensi {
  hadir,
  izin,
  sakit,
  alpha,
  libur,
  none
}

StatusPresensi _statusFromString(String? value) {
  switch (value) {
    case 'hadir':
      return StatusPresensi.hadir;
    case 'sakit':
      return StatusPresensi.sakit;
    case 'izin':
      return StatusPresensi.izin;
    case 'libur':
      return StatusPresensi.libur;
    default:
      return StatusPresensi.none;
  }
}

class CalendarDayModel {
  final DateTime date;
  final StatusPresensi status;

  CalendarDayModel({
    required this.date,
    required this.status,
  });

  factory CalendarDayModel.fromJson(Map<String, dynamic> json) {
    return CalendarDayModel(
      date: DateTime.parse(json['tanggal']),
      status: _statusFromString(json['status']),
    );
  }
}

class LatestAttendanceModel {
  final DateTime date;
  final StatusPresensi status;
  final String time;
  final String keterangan;
  final List<String> lampiran;

  LatestAttendanceModel({
    required this.date,
    required this.status,
    required this.time,
    required this.keterangan,
    required this.lampiran,
  });

  int get lampiranCount => lampiran.length;

  factory LatestAttendanceModel.fromJson(Map<String, dynamic> json) {
    return LatestAttendanceModel(
      date: DateTime.parse(json['tanggal']),
      status: _statusFromString(json['status']),
      time: json['jam'] ?? '-',
      keterangan: json['keterangan'] ?? '-',
      lampiran: _lampiranFromJson(json['lampiran']),
    );
  }

  static List<String> _lampiranFromJson(dynamic value) {
    if (value == null) return [];
    if (value is List) return value.map((e) => e.toString()).toList();
    if (value is String && value.isNotEmpty) return [value];
    return [];
  }
}

class HomeParentModel {
  final String name;
  // final int? studentId;
  final int year;
  final int month;
  final List<CalendarDayModel> days;
  final LatestAttendanceModel? latestAttendance;

  HomeParentModel({
    required this.name,
    // required this.studentId,
    required this.year,
    required this.month,
    required this.days,
    this.latestAttendance,
  });

  factory HomeParentModel.fromJson(Map<String, dynamic> json) {
    final periode = json['periode'] ?? {};
 
    return HomeParentModel(
      name: json['orang_tua']?['nama'] ?? '',
      // studentId: json['siswa']?['id'],
      year: periode['tahun'] ?? DateTime.now().year,
      month: periode['bulan'] ?? DateTime.now().month,
      days: (json['kalender_kehadiran'] as List? ?? [])
          .map((e) => CalendarDayModel.fromJson(e))
          .toList(),
      latestAttendance: json['presensi_terbaru'] != null
          ? LatestAttendanceModel.fromJson(json['presensi_terbaru'])
          : null,
    );
  }
}

class TugasModel {
  final String title;
  final String subject;
  final String status; // e.g. 'Selesai', 'Belum'
  final DateTime deadline;
  final Color bgColor;

  TugasModel({
    required this.title,
    required this.subject,
    required this.status,
    required this.deadline,
    required this.bgColor,
  });
}

class NilaiModel {
  final String mataPelajaran;
  final double rerata;
  final String tugasTerkumpul;

  NilaiModel({
    required this.mataPelajaran,
    required this.rerata,
    required this.tugasTerkumpul,
  });
}

class HomeParentController extends GetxController {
  //TODO: Implement HomeParentController
  final HomeService _homeService = HomeService();

  final Rx<DateTime> currentMonth = DateTime.now().obs;
  final Rxn<HomeParentModel> homeData = Rxn<HomeParentModel>();
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  final RxList<TugasModel> tugasList = <TugasModel>[
    TugasModel(
      title: 'Rangkuman: Silsilah Kerajaan Mataram',
      subject: 'Sejarah',
      status: 'Selesai',
      deadline: DateTime(2026, 5, 10, 23, 59),
      bgColor: AppColors.Butter,
    ),
    TugasModel(
      title: 'Rangkuman: Silsilah Kerajaan Mataram',
      subject: 'Sejarah',
      status: 'Selesai',
      deadline: DateTime(2026, 5, 10, 23, 59),
      bgColor: AppColors.Butter,
    ),
  ].obs;

  final RxList<NilaiModel> nilaiList = <NilaiModel>[
    NilaiModel(mataPelajaran: 'Bahasa Indonesia', rerata: 93.5, tugasTerkumpul: '14/15'),
    NilaiModel(mataPelajaran: 'Matematika', rerata: 94, tugasTerkumpul: '10/10'),
    NilaiModel(mataPelajaran: 'Bahasa Inggris', rerata: 92, tugasTerkumpul: '12/12'),
  ].obs;

  String get greetingName => homeData.value?.name ?? '';

  String get monthYearLabel => DateFormat('MMMM yyyy', 'id_ID').format(currentMonth.value);

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    fetchHomeData();
  }

  Future<void> fetchHomeData() async {
    isLoading.value = true;
    errorMessage.value = '';

    final result = await _homeService.getParentHome(
      year: currentMonth.value.year,
      month: currentMonth.value.month,
    );

    if (result['success'] == true && result['data'] != null) {
      homeData.value = HomeParentModel.fromJson(result['data']);
    } else {
      errorMessage.value = result['message'] ?? 'Gagal memuat data beranda.';
      Get.snackbar('Gagal memuat', errorMessage.value);
    }

    isLoading.value = false;
  }

  void changeMonth(int offset) {
    currentMonth.value = DateTime(currentMonth.value.year, currentMonth.value.month + offset);
    fetchHomeData();
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
