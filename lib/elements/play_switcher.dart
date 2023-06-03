import 'package:flutter/material.dart';
import 'package:mazeandtraps/controllers/main_game_controller.dart';

class PlaySwitcher {
  static Widget getPlaySwitcher(MainGameController controller) {
    return Center(
      child: Switch(
        value: controller.wantToPlay.value,
        onChanged: (value) {
          controller.wantToPlay.value = value;
          controller.changeWantToPlay();
          controller.update();
        },
        activeTrackColor: Colors.lightGreenAccent,
        activeColor: Colors.green,
      ),
    );
  }
}
