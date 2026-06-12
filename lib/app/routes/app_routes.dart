part of 'app_pages.dart';
// DO NOT EDIT. This is code generated via package:get_cli/get_cli.dart

abstract class Routes {
  Routes._();
  static const HOME = _Paths.STUDENT + _Paths.HOME;
  static const SPLASH = _Paths.AUTH + _Paths.SPLASH;
  static const SIGNIN = _Paths.AUTH + _Paths.SIGNIN;
  static const MAIN = _Paths.MAIN;
  static const CLASS = _Paths.STUDENT + _Paths.CLASS;
  static const PRESENCE = _Paths.STUDENT + _Paths.PRESENCE;
  static const PROFILE = _Paths.STUDENT + _Paths.PROFILE;
  static const QR_SHARING = _Paths.STUDENT + _Paths.QR_SHARING;
  static const SCAN_QR = _Paths.STUDENT + _Paths.SCAN_QR;
}

abstract class _Paths {
  _Paths._();
  static const AUTH = '/auth';
  static const STUDENT = '/student';
  static const HOME = '/home';
  static const SPLASH = '/splash';
  static const SIGNIN = '/signin';
  static const MAIN = '/main';
  static const CLASS = '/class';
  static const PRESENCE = '/presence';
  static const PROFILE = '/profile';
  static const QR_SHARING = '/qr-sharing';
  static const SCAN_QR = '/scan-qr';
}
