import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:mazeandtraps/views/backpack/backpack.dart';
import 'package:mazeandtraps/views/editor/map_editor.dart';
import 'package:mazeandtraps/views/general_menu.dart';
import 'package:mazeandtraps/views/scrolls/scrolls_list.dart';
import 'package:mazeandtraps/views/settings.dart';
import 'package:mazeandtraps/views/splashscreen/pause_splash_screen.dart';
import 'package:mazeandtraps/views/traps_shop.dart/traps_shop.dart';

import '../../elements/qr_scanner.dart';
import '../../views/editor/edit_menu.dart';
import '../../views/general_leaderboard.dart';
import '../../views/splashscreen/game_splash_screen.dart';
import '../bindings/bindings.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = _Paths.GAME_SPLASH_SCREEN;

  static final routes = [
    GetPage(
      name: _Paths.GENERAL_MENU, 
      page: () => GeneralMenu(), 
    ),
    GetPage(
      name: _Paths.QR_SCANNER, 
      page: () => QRView(),
      binding: QrControllerBinding()
    ),
    GetPage(
      name: _Paths.SETTINGS, 
      page: () => SettingsScreen(),
      binding: SettingsBinding()
    ),
    GetPage(
      name: _Paths.EDIT_MENU, 
      page: () => EditMenu(),
      binding: MapEditorBinding()
    ),
    GetPage(
      name: _Paths.MAP_EDITOR, 
      page: () => MapEditorScreen(),
      binding: MapEditorBinding()
    ),
    GetPage(
      name: _Paths.GAME_SPLASH_SCREEN, 
      page: () => GameSplashScreen(),
    ),
    GetPage(
      name: _Paths.LEADERBOARD, 
      page: () => GeneralLeaderboard(),
      binding: LeaderboardBinding()
    ),
    GetPage(
      name: _Paths.SCROLL_LIST, 
      page: () => ScrollListScreen(),
    ),
    GetPage(
      name: _Paths.BACKPACK, 
      page: () => BackpackScreen(),
      binding: TrapsAndShopBinding()
    ),
    GetPage(
      name: _Paths.TRAPS_SHOP, 
      page: () => TrapShop(),
      binding: TrapsAndShopBinding()
    ),
  ];
}