import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mazeandtraps/controllers/play_menu_controller.dart';
import 'package:mazeandtraps/controllers/routing/app_pages.dart';
import 'package:mazeandtraps/elements/appbar_pages.dart';
import 'package:mazeandtraps/elements/friend_battle.dart';

import '../../elements/button.dart';
import '../../elements/shell.dart';

class PlayMenu extends StatelessWidget {
  const PlayMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Shell(
      content: Scaffold(
      appBar: AppBarPages.getAppBar(Routes.GENERAL_MENU, 'Maze Rush'),
      body: GetBuilder<PlayMenuController>(
        builder: (controller) {
          return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FriendBattle(),
                      MenuButton(path: Routes.WAITING_PAGE, name: 'Search Random Rival', onPressed: () => controller.setUpRandomRival(true)),
                      const MenuButton(path: Routes.MAP_TRAINING_MENU, name: 'Training Maps'),
                      
                    ],
                  );
        }
      ),
    ));
  }
}