import 'package:get/get.dart';
import 'package:monisa/app/data/services/presensi_service.dart';

class StudentAttendanceModel {
  final String id;
  final String name;
  final String photoUrl;
  final String status; // 'hadir' | 'tidak_hadir'

  StudentAttendanceModel({
    required this.id,
    required this.name,
    required this.photoUrl,
    required this.status,
  });

  factory StudentAttendanceModel.fromJson(Map<String, dynamic> json) {
    final attendance = json['attendance'];

    final String status = attendance != null
      ? attendance['status']?.toString() ?? 'alpha'
      : 'alpha';

    return StudentAttendanceModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      photoUrl: json['photo_url'] ?? '',
      status: status,
    );
  }

  // Map<String, dynamic> toJson() => {
  //       'id': id,
  //       'name': name,
  //       'photo_url': photoUrl,
  //       'status': status,
  //     };
}

class PresensiTeacherController extends GetxController {
  //TODO: Implement PresensiTeacherController
  final PresensiService presensiService = PresensiService();
  final RxInt tabIndex = 0.obs;

  final RxString className = ''.obs;
  final RxString jenjang = ''.obs;
  final RxString major = ''.obs;

  String get fullClassName {
    return [
      jenjang.value,
      major.value,
      className.value,
    ].where((e) => e.isNotEmpty).join(' ');
  }

  final Rx<DateTime> attendanceDate = DateTime.now().obs;
  final RxList<StudentAttendanceModel> students = <StudentAttendanceModel>[].obs;
  final RxBool isLoading = false.obs;

  int get hadirCount => students.where((s) => s.status == 'hadir').length;
  int get tidakHadirCount => students.where((s) => s.status == 'alpha' || s.status == 'izin' || s.status == 'sakit').length;
  int get totalCount => students.length;
  double get hadirPercentage => totalCount == 0 ? 0 : hadirCount / totalCount;

  List<StudentAttendanceModel> get filteredStudents {
    if (tabIndex.value == 0) {
      // Tab Hadir
      return students
          .where((s) => s.status == 'hadir')
          .toList();
    }

    // Tab Tidak Hadir
    return students
        .where(
          (s) =>
              s.status == 'alpha' || s.status == 'izin' || s.status == 'sakit',
        )
        .toList();
  }

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    fetchStudents();
  }

  void changeTab(int index) => tabIndex.value = index;

  Future<void> fetchStudents() async {
    isLoading.value = true;

    try {
      final response =
        await presensiService.getTeacherAttendances();

      if (response['success'] != true) {
        Get.snackbar(
          'Gagal',
          response['message'] ??
              'Gagal mengambil data presensi.',
        );
        return;
      }

      final data = response['data'];

      if (data == null) {
        students.clear();
        return;
      }

      final schedule = data['schedule'];

      if (schedule != null) {
        final rombel = schedule['rombel'];

        if (rombel != null) {
          className.value = rombel['name']?.toString() ?? '';
          jenjang.value = rombel['jenjang']?.toString() ?? '';
          major.value = rombel['major']?.toString() ?? '';
        }
      }

      final List studentData = data['students'] ?? [];

      final List<StudentAttendanceModel>
          studentList =
          studentData
              .map(
                (student) =>
                    StudentAttendanceModel
                        .fromJson(student),
              )
              .toList();

      students.assignAll(studentList);
    } catch (e) {
      print(
        'ERROR FETCH TEACHER ATTENDANCE: $e',
      );

      Get.snackbar(
        'Gagal',
        'Terjadi kesalahan saat mengambil data presensi.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  void setStudentStatus(String studentId, String status) {
    final index = students.indexWhere((s) => s.id == studentId);
    if (index == -1) return;
    final old = students[index];
    students[index] = StudentAttendanceModel(
      id: old.id,
      name: old.name,
      photoUrl: old.photoUrl,
      status: status,
    );
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
