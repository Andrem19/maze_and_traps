import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mazeandtraps/controllers/main_game_controller.dart';
import 'package:mazeandtraps/models/trap.dart';

import '../../controllers/traps_and_shop_controller.dart';
import '../../services/dialog.dart';

class CurrentSet {
  static Widget currentSet() {
    TrapsAndShopController trapcController = Get.find<TrapsAndShopController>();
    return GetBuilder<MainGameController>(builder: (controller) {
      return Center(
        child: Container(
            decoration: BoxDecoration(
              color: Colors.green[900],
              border: Border.all(
                width: 5.0,
                color: Colors.black26,
              ),
            ),
            width: 300,
            alignment: Alignment.topCenter,
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 4,
              children: controller.backpackSet.value.map((element) {
                return InkWell(
                  onTap: () {
                    if (element.name != 'empty') {
                      CustomDialog.getDialogTrapInfo(element);
                    }
                  },
                  child: DragTarget<Trap>(
                    onAccept: (data) {
                      trapcController.backpackOnAccept(element, data);
                    },
                    builder: (context, _, __) {
                      if (element.name != 'empty') {
                        return LongPressDraggable(
                            data: element,
                            feedback: Card(
                              child: Stack(
                                children: [
                                  Image.asset(
                                    element.img,
                                    height: 75,
                                    width: 75,
                                  ),
                                  Column(
                                    children: [
                                      Text(element.name),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            child: Card(
                              child: Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 3,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Image.asset(
                                      element.img,
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Text(element.name),
                                    ],
                                  )
                                ],
                              ),
                            ));
                      } else {
                        return Card(
                          child: Text(' '),
                        );
                      }
                    },
                  ),
                );
              }).toList(),
            )),
      );
    });
  }
}
