import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:mazeandtraps/controllers/routing/app_pages.dart';
import 'package:mazeandtraps/controllers/waiting_game_controller.dart';
import 'package:mazeandtraps/elements/appbar_pages.dart';

import '../../../elements/shell.dart';

class WaitingPage extends StatelessWidget {
  const WaitingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Shell(
      content: Scaffold(
      appBar: AppBarPages.getAppBar(Routes.GENERAL_MENU, ''),
      body: GetBuilder<WaitingGameController>(
        builder: (controller) {
          return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/maze_icon.png',
                                  height: 40,
                                  width: 40,
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Text('A new maze has been generated'),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(controller.gameStatus.value),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              child: Text('PLAY'),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  textStyle: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                              onPressed: controller.startButtonShow.value
                                  ? () {
                                      controller.toPlay();
                                    }
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    );
        }
      )),
    );
  }
}