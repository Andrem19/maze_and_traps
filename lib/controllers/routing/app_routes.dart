part of 'app_pages.dart';

abstract class Routes {
  Routes_();

  static const GENERAL_MENU = _Paths.GENERAL_MENU;
  static const QR_SCANNER = _Paths.QR_SCANNER;
  static const SETTINGS = _Paths.SETTINGS;
}

abstract class _Paths {
  static const GENERAL_MENU = "/home";
  static const QR_SCANNER = "/qr_scanner";
  static const SETTINGS = "/settings";
}