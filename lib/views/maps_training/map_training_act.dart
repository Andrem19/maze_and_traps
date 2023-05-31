import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mazeandtraps/controllers/map_training_act_controller.dart';
import 'package:mazeandtraps/elements/play_material/cube_widget_A.dart';
import 'package:mazeandtraps/elements/play_material/cube_widget_A.dart';

import '../../elements/controll.dart';
import '../../elements/shell.dart';

class MapTrainingAct extends StatelessWidget {
  const MapTrainingAct({super.key});

  @override
  Widget build(BuildContext context) {
    return Shell.getShell(
      Scaffold(
        body: GetBuilder<MapTrainingActController>(initState: (state) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
          overlays: [SystemUiOverlay.bottom]);
    }, dispose: (state) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
          overlays: SystemUiOverlay.values);
    }, builder: (controller) {
      return Stack(
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children:
                  List.generate(controller.mazeMap.value.mazeMap.length, (row) {
                return Expanded(
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: List.generate(
                          controller.mazeMap.value.mazeMap[row].length, (col) {
                        return Expanded(
                          child: NodeWidget.getNode(controller.gameInfo.value, controller.mazeMap.value.mazeMap[row]
                                  [col]),
                        );
                      })),
                );
              }),
            ),
          ),
          Row(
            children: [
              Opacity(
                opacity: 0.5,
                child: Text(
                  controller.timerText.value, 
                  style: TextStyle(
                    color: Colors.red, 
                    fontSize: 20, 
                    fontWeight: FontWeight.bold),)),
                    SizedBox(width: 10,),
                    Text(controller.textMessage.value, style: TextStyle(
                    color: Colors.red, 
                    fontSize: 20, 
                    fontWeight: FontWeight.bold), ),
            ],
          ),
          Positioned(
            bottom: 15,
            right: 15,
            child: Control()),
        ],
      );
    }),
      )
    );
  }
}