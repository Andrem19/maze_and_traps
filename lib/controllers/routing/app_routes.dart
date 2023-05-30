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
  static const LEADERBOARD = _Paths.LEADERBOARD;
  static const SCROLL_LIST = _Paths.SCROLL_LIST;
  static const BACKPACK = _Paths.BACKPACK;
  static const TRAPS_SHOP = _Paths.TRAPS_SHOP;
  static const MAP_TRAINING_MENU = _Paths.MAP_TRAINING_MENU;
  static const MAP_TRAINING_ACT = _Paths.MAP_TRAINING_ACT;
  static const MAP_CHAMPIONS = _Paths.MAP_CHAMPIONS;
}

abstract class _Paths {
  static const GENERAL_MENU = "/home";
  static const QR_SCANNER = "/qr_scanner";
  static const SETTINGS = "/settings";
  static const MAP_EDITOR = "/map_editor";
  static const EDIT_MENU = "/edit_menu";
  static const GAME_SPLASH_SCREEN = "/game_splash_screen";
  static const PAUSE_SPLASH_SCREEN = "/pause_splash_screen";
  static const LEADERBOARD = "/leaderboard";
  static const SCROLL_LIST = "/scroll_list";
  static const BACKPACK = "/backpack";
  static const TRAPS_SHOP = "/traps_shop";
  static const MAP_TRAINING_MENU = "/map_training_menu";
  static const MAP_TRAINING_ACT = "/map_training_act";
  static const MAP_CHAMPIONS = "/map_champions";
}