import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:mazeandtraps/controllers/traps_controller.dart';

import '../../controllers/main_game_controller.dart';
import '../../models/trap.dart';

class TrapsShow extends StatelessWidget {
  const TrapsShow({super.key});

  @override
  Widget build(BuildContext context) {
    var trapsController = Get.find<TrapsController>();
    return GetBuilder<MainGameController>(builder: (controller) {
      return Center(
        child: Container(
            color: Colors.transparent,
            width: Get.size.height * 0.6,
            alignment: Alignment.topCenter,
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 5,
              children: controller.backpackSet.map((element) {
                return InkWell(
                    onTap: element.used
                        ? null
                        : () {
                            if (element.name != 'empty') {
                              trapsController.traps(element);
                              // controller.backpackSet
                              //     .firstWhere((p0) => p0.name == element.name)
                              //     .used = true;
                              // controller.update();
                            }
                          },
                    child: Opacity(
                      opacity: element.used ? 0.6 : 1,
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
                              child: element.img == ''
                                  ? null
                                  : Opacity(
                                      opacity: 0.5,
                                      child: Image.asset(element.img),
                                    ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  element.name == 'empty' ? '' : element.name,
                                  style: const TextStyle(fontSize: 10),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ));
              }).toList(),
            )),
      );
    });
  }
}
