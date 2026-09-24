import 'package:get/get.dart';
import 'package:monisa/app/modules/teacher/beranda/home_teacher/bindings/home_teacher_binding.dart';
import 'package:monisa/app/modules/teacher/beranda/home_teacher/views/home_teacher_view.dart';

import '../modules/auth/signin/bindings/signin_binding.dart';
import '../modules/auth/signin/views/signin_view.dart';
import '../modules/auth/splash/bindings/splash_binding.dart';
import '../modules/auth/splash/views/splash_view.dart';
import '../modules/parent/class_parent/bindings/class_parent_binding.dart';
import '../modules/parent/class_parent/views/class_parent_view.dart';
import '../modules/parent/home_parent/bindings/home_parent_binding.dart';
import '../modules/parent/home_parent/views/home_parent_view.dart';
import '../modules/parent/main_parent/bindings/main_parent_binding.dart';
import '../modules/parent/main_parent/views/main_parent_view.dart';
import '../modules/parent/presensi_parent/bindings/presensi_parent_binding.dart';
import '../modules/parent/presensi_parent/views/presensi_parent_view.dart';
import '../modules/parent/profile_parent/bindings/profile_parent_binding.dart';
import '../modules/parent/profile_parent/views/profile_parent_view.dart';
import '../modules/student/beranda/home/bindings/home_binding.dart';
import '../modules/student/beranda/home/views/home_view.dart';
import '../modules/student/kehadiran/presensi/bindings/presensi_binding.dart';
import '../modules/student/kehadiran/presensi/views/presensi_view.dart';
import '../modules/student/kehadiran/sqan_qr_presensi/bindings/sqan_qr_presensi_binding.dart';
import '../modules/student/kehadiran/sqan_qr_presensi/views/sqan_qr_presensi_view.dart';
import '../modules/student/kehadiran/tambah_presensi/bindings/tambah_presensi_binding.dart';
import '../modules/student/kehadiran/tambah_presensi/views/tambah_presensi_view.dart';
import '../modules/student/kelas/class/bindings/class_binding.dart';
import '../modules/student/kelas/class/views/class_view.dart';
import '../modules/student/kelas/detail_tugas/bindings/detail_tugas_binding.dart';
import '../modules/student/kelas/detail_tugas/views/detail_tugas_view.dart';
import '../modules/student/kelas/kelas_selected/bindings/kelas_selected_binding.dart';
import '../modules/student/kelas/kelas_selected/views/kelas_selected_view.dart';
import '../modules/student/kelas/qr_sharing/bindings/qr_sharing_binding.dart';
import '../modules/student/kelas/qr_sharing/views/qr_sharing_view.dart';
import '../modules/student/kelas/scan_qr/bindings/scan_qr_binding.dart';
import '../modules/student/kelas/scan_qr/views/scan_qr_view.dart';
import '../modules/student/kelas/tugas/bindings/tugas_binding.dart';
import '../modules/student/kelas/tugas/views/tugas_view.dart';
import '../modules/student/main/bindings/main_binding.dart';
import '../modules/student/main/views/main_view.dart';
import '../modules/student/profile/bindings/profile_binding.dart';
import '../modules/student/profile/views/profile_view.dart';
import '../modules/teacher/kelas/class_teacher/bindings/class_teacher_binding.dart';
import '../modules/teacher/kelas/class_teacher/views/class_teacher_view.dart';
import '../modules/teacher/main/main_teacher/bindings/main_teacher_binding.dart';
import '../modules/teacher/main/main_teacher/views/main_teacher_view.dart';
import '../modules/teacher/kehadiran/presensi_teacher/bindings/presensi_teacher_binding.dart';
import '../modules/teacher/kehadiran/presensi_teacher/views/presensi_teacher_view.dart';
import '../modules/teacher/profile/profile_teacher/bindings/profile_teacher_binding.dart';
import '../modules/teacher/profile/profile_teacher/views/profile_teacher_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: Routes.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.SIGNIN,
      page: () => const SigninView(),
      binding: SigninBinding(),
    ),
    GetPage(
      name: Routes.MAIN,
      page: () => const MainView(),
      binding: MainBinding(),
    ),
    GetPage(
      name: Routes.CLASS,
      page: () => const ClassView(),
      binding: ClassBinding(),
    ),
    GetPage(
      name: Routes.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: Routes.QR_SHARING,
      page: () => const QrSharingView(),
      binding: QrSharingBinding(),
    ),
    GetPage(
      name: Routes.SCAN_QR,
      page: () => const ScanQrView(),
      binding: ScanQrBinding(),
    ),
    GetPage(
      name: Routes.TUGAS,
      page: () => const TugasView(),
      binding: TugasBinding(),
    ),
    GetPage(
      name: Routes.KELAS_SELECTED,
      page: () => const KelasSelectedView(),
      binding: KelasSelectedBinding(),
    ),
    GetPage(
      name: Routes.DETAIL_TUGAS,
      page: () => const DetailTugasView(),
      binding: DetailTugasBinding(),
    ),
    GetPage(
      name: Routes.PRESENSI,
      page: () => const PresensiView(),
      binding: PresensiBinding(),
    ),
    GetPage(
      name: Routes.SQAN_QR_PRESENSI,
      page: () => const SqanQrPresensiView(),
      binding: SqanQrPresensiBinding(),
    ),
    GetPage(
      name: Routes.TAMBAH_PRESENSI,
      page: () => TambahPresensiView(),
      binding: TambahPresensiBinding(),
    ),
    GetPage(
      name: Routes.MAIN_TEACHER,
      page: () => const MainTeacherView(),
      binding: MainTeacherBinding(),
    ),
    GetPage(
      name: Routes.HOME_TEACHER,
      page: () => const HomeTeacherView(),
      binding: HomeTeacherBinding(),
    ),
    GetPage(
      name: Routes.CLASS_TEACHER,
      page: () => const ClassTeacherView(),
      binding: ClassTeacherBinding(),
    ),
    GetPage(
      name: Routes.PRESENSI_TEACHER,
      page: () => const PresensiTeacherView(),
      binding: PresensiTeacherBinding(),
    ),
    GetPage(
      name: Routes.PROFILE_TEACHER,
      page: () => const ProfileTeacherView(),
      binding: ProfileTeacherBinding(),
    ),
    GetPage(
      name: Routes.PRESENSI_PARENT,
      page: () => const PresensiParentView(),
      binding: PresensiParentBinding(),
    ),
    GetPage(
      name: Routes.MAIN_PARENT,
      page: () => const MainParentView(),
      binding: MainParentBinding(),
    ),
    GetPage(
      name: Routes.CLASS_PARENT,
      page: () => const ClassParentView(),
      binding: ClassParentBinding(),
    ),
    GetPage(
      name: Routes.PROFILE_PARENT,
      page: () => const ProfileParentView(),
      binding: ProfileParentBinding(),
    ),
    GetPage(
      name: _Paths.HOME_PARENT,
      page: () => const HomeParentView(),
      binding: HomeParentBinding(),
    ),
  ];
}
