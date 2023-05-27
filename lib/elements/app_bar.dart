import 'package:flutter/material.dart';
import 'package:mazeandtraps/controllers/main_game_controller.dart';

class AppBarElement {
  static AppBar getAppBar(MainGameController controller) {
    return AppBar(
      actions: [
        Center(
            child: Text(
          'score: ${controller.score.value ?? 0}',
          style: TextStyle(fontSize: 20),
        )),
        SizedBox(
          width: 5,
        )
      ],
      title: Text(controller.userName.value),
    );
  }
}
