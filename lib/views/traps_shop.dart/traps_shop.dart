import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:mazeandtraps/controllers/routing/app_pages.dart';
import 'package:mazeandtraps/elements/appbar_pages.dart';
import 'package:mazeandtraps/elements/appbar_withscrolls.dart';
import 'package:mazeandtraps/elements/shell.dart';
import 'package:mazeandtraps/services/dialog.dart';

import '../../controllers/main_game_controller.dart';
import '../../models/trap.dart';

class TrapShop extends StatelessWidget {
  const TrapShop({super.key});

  @override
  Widget build(BuildContext context) {
    return Shell(content: GetBuilder<MainGameController>(builder: (controller) {
      return Scaffold(
        appBar: AppBarWithScrolls.getAppBar(Routes.GENERAL_MENU, 'TRAPS SHOP'),
        body: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Center(
            child: Column(
              children: [
                Container(
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
                      children: controller.allTrapsInTheGame.map((element) {
                        return InkWell(
                          onTap: () {
                            if (element.name != 'empty') {
                              CustomDialog.getDialogTrapShop(element);
                            }
                          },
                          child: Builder(
                            builder: (context) {
                              if (element.name != 'empty') {
                                return Card(
                                  child: Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.black,
                                            width: 3,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Image.asset(element.img),
                                      ),
                                      Column(
                                        children: [
                                          Text(element.name),
                                        ],
                                      ),
                                      Builder(builder: (context) {
                                        if (controller.allMyTraps
                                            .contains(element) || controller.backpackSet.contains(element)) {
                                          return Icon(Icons.check, color: Colors.blue, size: 40,);
                                        } else {
                                          return SizedBox();
                                        }
                                      })
                                    ],
                                  ),
                                );
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
                SizedBox()
              ],
            ),
          ),
        ),
      );
    }));
  }
}
