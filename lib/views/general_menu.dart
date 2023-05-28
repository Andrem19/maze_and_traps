import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mazeandtraps/controllers/ad_visual_controller.dart';
import 'package:mazeandtraps/controllers/main_game_controller.dart';
import 'package:mazeandtraps/elements/app_bar.dart';
import 'package:mazeandtraps/elements/button.dart';
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
        appBar: AppBarElement.getAppBar(controller),
        body: GetBuilder<AdAndVisualController>(builder: (AdController) {
          return Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  QrCode(),
                  SearchField(),
                  MenuButton.getButton('Map Editor', Routes.EDIT_MENU),
                  MenuButton.getButton('Settings', Routes.SETTINGS)
                ],
              ),
              Builder(
                builder: (context) {
                  if (AdController.buttonWasClick) {
                    return Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.black
                          .withOpacity(AdController.mainScreenShaddow.value),
                    );
                  } else
                    return SizedBox();
                },
              ),
            ],
          );
        }),
      );
    }));
  }
}
