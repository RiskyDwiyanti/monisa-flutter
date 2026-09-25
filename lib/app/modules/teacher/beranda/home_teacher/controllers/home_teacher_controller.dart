import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monisa/app/data/services/home_service.dart';
import 'package:monisa/app/theme/app_colors.dart';

// Model Schedule
class ScheduleModel {
  final String id;
  final int jamKe;
  final String jam;
  final String? jenjang;
  final String? jurusan;
  final String? kelas;
  final String? mataPelajaran;

  ScheduleModel({
    required this.id,
    required this.jamKe,
    required this.jam,
    this.jenjang,
    this.jurusan,
    this.kelas,
    this.mataPelajaran,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      id: json['id']?.toString() ?? '', 
      jamKe: json['jam_ke'] is int ? json['jam_ke'] : int.tryParse('${json['jam_ke']}') ?? 0, 
      jam: json['jam'] ?? '',
      jenjang: json['jenjang'],
      jurusan: json['jurusan'],
      kelas: json['name'],
      mataPelajaran: json['mata_pelajaran'],
    );
  }

  // Parsing jam mulai/selesai
  TimeOfDay? get _jamMulai => _parseJam(jam.split(RegExp(r'[–-]')).first);

  TimeOfDay? get _jamSelesai{
    final parts = jam.split(RegExp(r'[–-]'));
    if (parts.length < 2) return null;
    return _parseJam(parts[1]);
  }

  static TimeOfDay? _parseJam(String raw) {
    final parts = raw.trim().split(':');
    if (parts.length != 2) return null;
    final h = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    if (h == null || m == null) return null;
    return TimeOfDay(hour: h, minute: m);
  }

  bool get isSedangBerlangsung {
    final mulai = _jamMulai;
    final selesai = _jamSelesai;
    if (mulai == null || selesai == null) return false;
    final now = TimeOfDay.now();
    final nowMinutes = now.hour * 60 + now.minute;
    final mulaiMinutes = mulai.hour * 60 + mulai.minute;
    final selesaiMinutes = selesai.hour * 60 + selesai.minute;
    return nowMinutes >= mulaiMinutes && nowMinutes < selesaiMinutes;
  }
}

// Model DraftTugasModel
class DraftTugasModel {
  final String id;
  final String judul; // 'Kuis Bab Puisi'
  final String infoSoal; // '15 Soal'
  final List<String> tipeSoal; // ['PG', 'PG-J', 'Uraian']
  final String kelas; // 'Kelas XI IPA A'
  final Color accentColor;

  DraftTugasModel({
    required this.id,
    required this.judul,
    required this.infoSoal,
    required this.tipeSoal,
    required this.kelas,
    required this.accentColor,
  });
}

class HomeTeacherController extends GetxController {
  //TODO: Implement HomeTeacherController
  final HomeService homeService = HomeService();

  final RxString nama = ''.obs;
  final RxString hari = ''.obs;
  final RxString tanggal = ''.obs;

  final RxList<ScheduleModel> scheduleList = <ScheduleModel> [].obs;
  final RxBool isLoadingSchedule = false.obs;
  final RxString scheduleError = ''.obs;

  final List<DraftTugasModel> draftTugasList = [
    DraftTugasModel(
      id: '1',
      judul: 'Kuis Bab Puisi',
      infoSoal: '15 Soal',
      tipeSoal: const ['PG', 'PG-J', 'Uraian'],
      kelas: 'Kelas XI IPA A',
      accentColor: AppColors.Blush,
    ),
    DraftTugasModel(
      id: '2',
      judul: 'Praktikum Titrasi',
      infoSoal: '1 Tugas',
      tipeSoal: const ['Praktik'],
      kelas: 'Kelas XII IPA B',
      accentColor: AppColors.Sky,
    ),
  ];

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    fetchSchedule();
  }

  Future<void> fetchSchedule() async {
    isLoadingSchedule.value = true;
    scheduleError.value = '';
    try {
      final response = await homeService.getTeacherHome();

      if (response['success'] != true) {
        Get.snackbar(
          'Gagal',
          response['message'] ?? 'Gagal mengambil data presensi.',
        );
        return;
      }

      final data = response['data'] as Map<String, dynamic>? ?? {};
      final guru = data['guru'] as Map<String, dynamic>? ?? {};
      final List jadwalJson = data['jadwal_mengajar'] ?? [];

      nama.value = guru['nama'] ?? '';
      hari.value = data['hari'] ?? '';
      tanggal.value = data['tanggal'] ?? '';
      scheduleList.assignAll(
        jadwalJson
            .map((j) =>
                ScheduleModel.fromJson(j as Map<String, dynamic>))
            .toList(),
      );
    } catch (e) {
      scheduleError.value = 'Gagal memuat jadwal mengajar';
    } finally {
      isLoadingSchedule.value = false;
    }
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
