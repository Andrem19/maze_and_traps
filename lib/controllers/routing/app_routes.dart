part of 'app_pages.dart';

abstract class Routes {
  Routes_();

  static const GENERAL_MENU = _Paths.GENERAL_MENU;
  static const QR_SCANNER = _Paths.QR_SCANNER;
  static const SETTINGS = _Paths.SETTINGS;
  static const MAP_EDITOR = _Paths.MAP_EDITOR;
  static const EDIT_MENU = _Paths.EDIT_MENU;
  static const GAME_SPLASH_SCREEN = _Paths.GAME_SPLASH_SCREEN;
  static const PAUSE_SPLASH_SCREEN = _Paths.PAUSE_SPLASH_SCREEN;
}

abstract class _Paths {
  static const GENERAL_MENU = "/home";
  static const QR_SCANNER = "/qr_scanner";
  static const SETTINGS = "/settings";
  static const MAP_EDITOR = "/map_editor";
  static const EDIT_MENU = "/edit_menu";
  static const GAME_SPLASH_SCREEN = "/game_splash_screen";
  static const PAUSE_SPLASH_SCREEN = "/pause_splash_screen";
}