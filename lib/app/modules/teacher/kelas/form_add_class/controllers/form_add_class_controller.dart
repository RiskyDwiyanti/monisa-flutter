import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:monisa/app/data/services/teacher/teacher_class_service.dart';

// ===== MODEL =====
class MapelOption {
  final int id;
  final String name;

  MapelOption({required this.id, required this.name});

  factory MapelOption.fromJson(Map<String, dynamic> json) {
    return MapelOption(
      id: json['id'] as int,
      name: (json['name'] ?? '-').toString(),
    );
  }
}


class RombelOption {
  final int id;
  final String jenjang;
  final int? jurusanId;
  final String? jurusan;
  final String name; // contoh: "A", "B"

  RombelOption({
    required this.id,
    required this.jenjang,
    this.jurusanId,
    this.jurusan,
    required this.name,
  });

  factory RombelOption.fromJson(Map<String, dynamic> json) {
    return RombelOption(
      id: json['id'] as int,
      jenjang: (json['jenjang'] ?? '-').toString(),
      jurusanId: json['jurusan_id'] as int?,
      jurusan: json['jurusan'] as String?,
      name: (json['name'] ?? '-').toString(),
    );
  }
}

class FormAddClassController extends GetxController {
  final _service = TeacherClassService();

  // Input form
  final deskripsiC = TextEditingController();

  // Mapel
  final mapelOptions = <MapelOption>[].obs;
  final selectedMapel = Rxn<MapelOption>();
  final isLoadingMapel = false.obs;
  final mapelErrorMessage = RxnString();

  // Tahun ajaran: 3 pilihan di sekitar tahun berjalan
  late final List<String> tahunAjaranOptions;
  final selectedTahunAjaran = RxnString();

  // Pilihan kelas, terisi setelah fetch ke endpoint option
  final rombelOptions = <RombelOption>[].obs;
  final selectedJenjang = RxnString();
  final selectedJurusan = RxnString();
  final selectedKelas = RxnString();

  final isLoadingOptions = false.obs;
  final isSubmitting = false.obs;
  final errorMessage = RxnString();

  List<String> get jenjangList => rombelOptions.map((e) => e.jenjang).toSet().toList();

  List<String> get jurusanList => rombelOptions
      .where((e) => e.jenjang == selectedJenjang.value)
      .map((e) => e.jurusan ?? '-')
      .toSet()
      .toList();

  List<String> get kelasList => rombelOptions
      .where((e) =>
          e.jenjang == selectedJenjang.value &&
          (e.jurusan ?? '-') == selectedJurusan.value)
      .map((e) => e.name)
      .toSet()
      .toList();

  RombelOption? get _selectedRombel {
    if (selectedJenjang.value == null ||
        selectedJurusan.value == null ||
        selectedKelas.value == null) {
      return null;
    }
    try {
      return rombelOptions.firstWhere((e) =>
          e.jenjang == selectedJenjang.value &&
          (e.jurusan ?? '-') == selectedJurusan.value &&
          e.name == selectedKelas.value);
    } catch (_) {
      return null;
    }
  }

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();

    final currentYear = DateTime.now().year;
    // Kalau sudah lewat Juli, anggap tahun ajaran berjalan = currentYear/currentYear+1
    final startYear = DateTime.now().month >= 7 ? currentYear : currentYear - 1;
    tahunAjaranOptions = List.generate(
      3,
      (i) => '${startYear + i}/${startYear + i + 1}',
    );
    selectedTahunAjaran.value = tahunAjaranOptions.first;

    fetchMapelOptions();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    deskripsiC.dispose();
    super.onClose();
  }

  Future<void> fetchMapelOptions() async {
    isLoadingMapel.value = true;
    mapelErrorMessage.value = null;

    final result = await _service.getMapelOptions();

    if (result['success'] == true) {
      try {
        final list = (result['data'] as List? ?? [])
            .map((e) => MapelOption.fromJson(e as Map<String, dynamic>))
            .toList();
        mapelOptions.assignAll(list);
      } catch (e) {
        mapelErrorMessage.value = 'Format data mapel tidak sesuai.';
        debugPrint('Parse mapel error: $e');
      }
    } else {
      mapelErrorMessage.value = result['message']?.toString();
    }

    isLoadingMapel.value = false;
  }

  void onMapelChanged(MapelOption? value) {
    selectedMapel.value = value;
    // Reset pilihan kelas karena bergantung pada mapel yang dipilih
    rombelOptions.clear();
    selectedJenjang.value = null;
    selectedJurusan.value = null;
    selectedKelas.value = null;

    if (value != null) fetchOptions();
  }

   Future<void> fetchOptions() async {
    if (selectedMapel.value == null || selectedTahunAjaran.value == null) {
      return;
    }

    isLoadingOptions.value = true;
    errorMessage.value = null;

    selectedJenjang.value = null;
    selectedJurusan.value = null;
    selectedKelas.value = null;

    final result = await _service.getOptions(
      schoolMapelId: selectedMapel.value!.id,
      tahunAjaran: selectedTahunAjaran.value!,
    );

    if (result['success'] == true) {
      try {
        final list = (result['data'] as List? ?? [])
            .map((e) => RombelOption.fromJson(e as Map<String, dynamic>))
            .toList();
        rombelOptions.assignAll(list);
      } catch (e) {
        errorMessage.value = 'Format data kelas tidak sesuai.';
        debugPrint('Parse option error: $e');
      }
    } else {
      rombelOptions.clear();
      errorMessage.value = result['message']?.toString();
    }

    isLoadingOptions.value = false;
  }

  void onTahunAjaranChanged(String? value) {
    selectedTahunAjaran.value = value;
    if (selectedMapel.value != null) fetchOptions();
  }

  void onJenjangChanged(String? value) {
    selectedJenjang.value = value;
    selectedJurusan.value = null;
    selectedKelas.value = null;
  }

  void onJurusanChanged(String? value) {
    selectedJurusan.value = value;
    selectedKelas.value = null;
  }

  void onKelasChanged(String? value) {
    selectedKelas.value = value;
  }

  Future<bool> submit() async {
    final mapel = selectedMapel.value;
    final rombel = _selectedRombel;

    if (mapel == null) {
      Get.snackbar('Lengkapi data', 'Pilih mata pelajaran.');
      return false;
    }

    if (rombel == null || selectedTahunAjaran.value == null) {
      Get.snackbar('Lengkapi data', 'Pilih jenjang, jurusan, dan kelas.');
      return false;
    }

    isSubmitting.value = true;

    final result = await _service.createClass(
      rombelId: rombel.id,
      schoolMapelId: mapel.id,
      name: '${mapel.name} ${rombel.jenjang} ${rombel.jurusan ?? ''} ${rombel.name}'.replaceAll(RegExp(r'\s+'), ' ') .trim(),
      tahunAjaran: selectedTahunAjaran.value!,
      description: deskripsiC.text.trim().isEmpty ? null : deskripsiC.text.trim(),
    );

    isSubmitting.value = false;

    if (result['success'] == true) {
      Get.back(result: true);
      Get.snackbar('Berhasil', result['message']?.toString() ?? 'Kelas dibuat.');
      return true;
    }

    Get.snackbar('Gagal', result['message']?.toString() ?? 'Terjadi kesalahan.');
    return false;
  }

  void increment() => count.value++;
}
