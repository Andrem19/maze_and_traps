import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mazeandtraps/controllers/ad_visual_controller.dart';
import 'package:mazeandtraps/controllers/main_game_controller.dart';
import 'package:mazeandtraps/elements/app_bar.dart';
import 'package:mazeandtraps/elements/button.dart';
import 'package:mazeandtraps/elements/play_switcher.dart';
import 'package:mazeandtraps/elements/qr_code.dart';
import 'package:mazeandtraps/elements/search_field.dart';
import 'package:mazeandtraps/elements/shell.dart';

import '../controllers/routing/app_pages.dart';

class GeneralMenu extends StatelessWidget {
  const GeneralMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Shell.getShell(GetBuilder<MainGameController>(builder: (controller) {
      return Scaffold(
        appBar: AppBarElement.getAppBar(),
        body: GetBuilder<AdAndVisualController>(builder: (AdController) {
          return Stack(
            children: [
              DecoratedBox(
              position: DecorationPosition.background,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/texture_Background.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(),
            ),
              Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.black
                    .withOpacity(AdController.mainScreenShaddow.value),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      QrCode(),
                      Row(
                        children: [
                          Text(controller.wantToPlay.value ? 'I agree to receive invitations to the game' : 'I do not agree to receive invitations to the game'),
                          PlaySwitcher.getPlaySwitcher(controller),
                        ],
                      ),
                      MenuButton(path: Routes.PLAY_MENU, name: 'Play'),
                      MenuButton(path: Routes.TRAPS_SHOP, name: 'Traps Shop'),
                      MenuButton(path: Routes.LEADERBOARD, name: 'Leaderboard'),
                      MenuButton(path: Routes.EDIT_MENU, name: 'Map Editor'),
                      MenuButton(path: Routes.SETTINGS, name: 'Settings')
                    ],
                  ),
                ],
              ),
            ],
          );
        }),
      );
    }));
  }
}
