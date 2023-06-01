import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mazeandtraps/controllers/main_game_controller.dart';
import 'package:mazeandtraps/controllers/map_training_act_controller.dart';

class Player {
  static getPlayer(Color color, Color borderColor) {
    var cont = Get.find<MainGameController>();
    double onePerc = (Get.size.height / 35) / 100;
    double onePercHealth = cont.globalSettings.default_health.toDouble() / 100;
    double num = 101 - (cont.player_A_Life.value / onePercHealth);
    double height = onePerc * num;
    return GetBuilder<MainGameController>(builder: (controller) {
      return Stack(
        children: [
          Container(
            decoration: new BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          Container(
            height: height,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 158, 152, 152),
              border: Border(
                top: BorderSide(width: 2.0, color: Colors.black12),
                left: BorderSide(width: 2.0, color: Colors.black12),
                right: BorderSide(width: 2.0, color: Colors.black12),
                bottom: BorderSide.none,
              ),
            ),
          ),
          Container(
            decoration: new BoxDecoration(
              color: Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(
                width: 2.0,
                color: borderColor,
              ),
            ),
          ),
          Center(
            child: Text(
              '${controller.player_A_Life.value.toInt()}',
              style: TextStyle(fontSize: 10),
            ),
          )
        ],
      );
    });
  }
}
