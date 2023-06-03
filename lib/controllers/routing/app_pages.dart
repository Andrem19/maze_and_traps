import 'package:get/get.dart';
import 'package:mazeandtraps/views/backpack/backpack.dart';
import 'package:mazeandtraps/views/editor/map_editor.dart';
import 'package:mazeandtraps/views/general_menu.dart';
import 'package:mazeandtraps/views/play/maps_training/map_training_act.dart';
import 'package:mazeandtraps/views/play/maps_training/maps_champions.dart';
import 'package:mazeandtraps/views/play/multiplayer/battle_act.dart';
import 'package:mazeandtraps/views/play/multiplayer/end_game_screen.dart';
import 'package:mazeandtraps/views/play/play_menu.dart';
import 'package:mazeandtraps/views/scrolls/scrolls_list.dart';
import 'package:mazeandtraps/views/settings.dart';
import 'package:mazeandtraps/views/traps_shop.dart/traps_shop.dart';

import '../../elements/qr_scanner.dart';
import '../../views/editor/edit_menu.dart';
import '../../views/general_leaderboard.dart';
import '../../views/play/maps_training/maps_training_menu.dart';
import '../../views/play/multiplayer/waiting_page.dart';
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
    GetPage(
      name: _Paths.MAP_TRAINING_MENU, 
      page: () => MapsTrainingMenu(),
      binding: MapMenuBinding()
    ),
    GetPage(
      name: _Paths.MAP_CHAMPIONS, 
      page: () => MapChampions(),
      binding: MapMenuBinding()
    ),
    GetPage(
      name: _Paths.MAP_TRAINING_ACT, 
      page: () => MapTrainingAct(),
      binding: MapTrainingActBinding()
    ),
    GetPage(
      name: _Paths.PLAY_MENU, 
      page: () => PlayMenu(),
      binding: PlayMenuControllerBinding()
    ),
    GetPage(
      name: _Paths.BATTLE_ACT, 
      page: () => BattleAct(),
      binding: BattleActControllerBinding()
    ),
    GetPage(
      name: _Paths.WAITING_PAGE, 
      page: () => WaitingPage(),
      binding: WaitingGameControllerBinding()
    ),
    GetPage(
      name: _Paths.END_GAME_SCREEN, 
      page: () => EndGameScreen(),
    ),
  ];
}