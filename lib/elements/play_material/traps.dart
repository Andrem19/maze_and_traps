import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';

import '../../controllers/main_game_controller.dart';
import '../../models/trap.dart';

class TrapsShow extends StatelessWidget {
  const TrapsShow({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainGameController>(builder: (controller) {
      List<Trap> backpack = [];
      for (var i = 0; i < 5; i++) {
        backpack.add(controller.backpackSet[i]);
      }
      return Center(
        child: Opacity(
          opacity: 0.7,
          child: Container(
              color: Colors.transparent,
              width: 300,
              alignment: Alignment.topCenter,
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 5,
                children: backpack.map((element) {
                  return InkWell(
                      onTap: () {
                        if (element.name != 'empty') {
                          // CustomDialog.getDialogTrapInfo(element);
                        }
                      },
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
                              child: element.img == ''? null : Opacity(
                                opacity: 0.5,
                                child: Image.asset(element.img
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(element.name == 'empty' ? '' : element.name, style: const TextStyle(fontSize: 10),),
                              ],
                            )
                          ],
                        ),
                      ));
                }).toList(),
              )),
        ),
      );
    });
  }
}
