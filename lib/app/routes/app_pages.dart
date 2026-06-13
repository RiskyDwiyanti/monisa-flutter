import 'package:get/get.dart';

import '../modules/auth/signin/bindings/signin_binding.dart';
import '../modules/auth/signin/views/signin_view.dart';
import '../modules/auth/splash/bindings/splash_binding.dart';
import '../modules/auth/splash/views/splash_view.dart';
import '../modules/student/class/bindings/class_binding.dart';
import '../modules/student/class/views/class_view.dart';
import '../modules/student/home/bindings/home_binding.dart';
import '../modules/student/home/views/home_view.dart';
import '../modules/student/kelas_selected/bindings/kelas_selected_binding.dart';
import '../modules/student/kelas_selected/views/kelas_selected_view.dart';
import '../modules/student/main/bindings/main_binding.dart';
import '../modules/student/main/views/main_view.dart';
import '../modules/student/presence/bindings/presence_binding.dart';
import '../modules/student/presence/views/presence_view.dart';
import '../modules/student/profile/bindings/profile_binding.dart';
import '../modules/student/profile/views/profile_view.dart';
import '../modules/student/qr_sharing/bindings/qr_sharing_binding.dart';
import '../modules/student/qr_sharing/views/qr_sharing_view.dart';
import '../modules/student/scan_qr/bindings/scan_qr_binding.dart';
import '../modules/student/scan_qr/views/scan_qr_view.dart';
import '../modules/student/tugas/bindings/tugas_binding.dart';
import '../modules/student/tugas/views/tugas_view.dart';

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
      name: Routes.PRESENCE,
      page: () => const PresenceView(),
      binding: PresenceBinding(),
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
  ];
}
