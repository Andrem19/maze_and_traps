import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mazeandtraps/controllers/main_game_controller.dart';
import 'package:mazeandtraps/controllers/routing/app_pages.dart';
import 'package:mazeandtraps/controllers/traps_and_shop_controller.dart';
import 'package:mazeandtraps/elements/shell.dart';
import 'package:mazeandtraps/views/backpack/current_set.dart';
import 'package:mazeandtraps/views/backpack/upper_collection.dart';

import '../../elements/appbar_withscrolls.dart';

class BackpackScreen extends StatelessWidget {
  const BackpackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var main = Get.find<MainGameController>();
    return Shell(
      content: Scaffold(
      appBar: AppBarWithScrolls.getAppBar(Routes.GENERAL_MENU, 'BACKPACK'),
      body: GetBuilder<TrapsAndShopController>(builder: (controller) {
        return Column(
          children: [
            UpperCollection.upperCollection(),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: const Text(
                'Backpack Game Set',
                style: const TextStyle(fontSize: 25),
              ),
            ),
            CurrentSet.currentSet(),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Text(
                'Weight: ${controller.weight.value} kg',
                style: TextStyle(fontSize: 30, color: Colors.green),
              ),
            ),
            Container(
              width: Get.size.height /3,
              child: ElevatedButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('+ 1kg = ${controller.weightPrice.value}', style: TextStyle(fontSize: 15),),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Image.asset('assets/images/scrolls.png', height: Get.size.height /25,),
                    ),
                    
                  ],
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    textStyle: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold)),
                onPressed: main.scrolls.value >= controller.weightPrice.value
                    ? () {
                        controller.buyWeight();
                      }
                    : null,
              ),
            ),
          ],
        );
      }),
    ));
  }
}
