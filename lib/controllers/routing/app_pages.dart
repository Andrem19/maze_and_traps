import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:mazeandtraps/views/general_menu.dart';
import 'package:mazeandtraps/views/settings.dart';

import '../../elements/qr_scanner.dart';
import '../bindings/bindings.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = _Paths.GENERAL_MENU;

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
    ),
  ];
}