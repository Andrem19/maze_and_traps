import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mazeandtraps/controllers/main_game_controller.dart';
import 'package:mazeandtraps/controllers/traps_and_shop_controller.dart';

import '../models/trap.dart';

class CustomDialog {
  static void getDialogTrapInfo(Trap trap) {
    Get.dialog(AlertDialog(
        title: Text(trap.name),
        content: Container(
            constraints: BoxConstraints(
                maxWidth: kIsWeb ? Get.size.width / 5 : Get.size.width * 0.7,
                maxHeight: Get.size.height / 5),
            child: Column(
              children: [
                Text(
                  trap.description,
                  maxLines: 5,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text('Weight: ${trap.weight}'),
                )
              ],
            )),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                textStyle: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold)),
            onPressed: () {
              Get.back();
            },
            child: Text(
              'OK',
              style: TextStyle(color: Colors.white, fontSize: 16.0),
            ),
          ),
        ]));
  }

  static void getDialogTrapShop(Trap trap) {
    Get.dialog(GetBuilder<MainGameController>(builder: (controller) {
      return AlertDialog(
          title: Text(trap.name),
          content: Container(
              constraints: BoxConstraints(
                  maxWidth: kIsWeb ? Get.size.width / 5 : Get.size.width * 0.7,
                  maxHeight: Get.size.height / 4),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 4,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child:
                          Image.asset(trap.img, height: Get.size.height / 10),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      trap.description,
                      maxLines: 5,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'Price: ${trap.cost}',
                      style: TextStyle(fontSize: 20),
                    ),
                  )
                ],
              )),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Builder(
                  builder: (context) {
                    var cont = Get.find<TrapsAndShopController>();
                    if (trap.cost <= controller.scrolls.value) {
                      return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              textStyle: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                          onPressed: () {
                            cont.buyTrap(trap);
                            Get.back();
                          },
                          child: Text(
                            'BUY',
                            style:
                                TextStyle(color: Colors.white, fontSize: 16.0),
                          ));
                    } else {
                      return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              textStyle: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                          onPressed: null,
                          child: Text(
                            'NOT ENOUGH SCROLS',
                            style:
                                TextStyle(color: Colors.white, fontSize: 12.0),
                          ));
                    }
                  },
                ),
              ],
            )
          ]);
    }));
  }
}
