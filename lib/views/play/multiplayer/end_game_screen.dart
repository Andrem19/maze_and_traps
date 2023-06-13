import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mazeandtraps/controllers/main_game_controller.dart';
import 'package:mazeandtraps/elements/shell.dart';

import '../../../controllers/routing/app_pages.dart';

class EndGameScreen extends StatelessWidget {
  const EndGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Shell(
      content: Scaffold(
        body: GetBuilder<MainGameController>(
          builder: (controller) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    controller.YourCurrentRole.value == controller.vinner.value
                        ? 'YOU WON'
                        : 'YOU LOSE',
                    style: TextStyle(
                      fontSize: 25,
                      color: controller.YourCurrentRole.value == controller.vinner.value
                          ? Colors.green
                          : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  controller.randomRival
                      ? Text(
                          controller.YourCurrentRole.value == controller.vinner.value
                              ? '+ 2 points'
                              : '- 1 point',
                          style: const TextStyle(fontSize: 18),
                        )
                      : SizedBox(),
                  ElevatedButton(
                    onPressed: () {
                      controller.deleteGameInstant();
                      Get.offAllNamed(Routes.GENERAL_MENU);
                    },
                    child: const Text('To Main Screen'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
