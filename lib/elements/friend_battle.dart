import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/ad_visual_controller.dart';
import '../controllers/main_game_controller.dart';
import '../controllers/play_menu_controller.dart';
import '../controllers/routing/app_pages.dart';

class FriendBattle extends StatelessWidget {
  const FriendBattle({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<MainGameController>();
    return GetBuilder<AdAndVisualController>(builder: (AdController) {
      return ColorFiltered(
        colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(AdController.mainScreenShaddow.value),
            BlendMode.darken),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Container(
                  width: Get.size.height / 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: TextField(
                          onChanged: (value) {},
                          controller: controller.mapSearch,
                          keyboardType: TextInputType.text,
                          maxLines: 1,
                          decoration: InputDecoration(
                              labelText: 'Map Name',
                              prefixIcon: Icon(Icons.map),
                              suffixIcon: InkWell(
                                  onTap: () {
                                    controller.randomMapName();
                                  },
                                  child: Icon(Icons.plus_one)),
                              hintMaxLines: 1,
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.green, width: 4.0))),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: TextField(
                          onChanged: (value) {},
                          controller: controller.playerSearch,
                          keyboardType: TextInputType.text,
                          maxLines: 1,
                          decoration: InputDecoration(
                              labelText: 'Player Name',
                              prefixIcon: Icon(Icons.search),
                              suffixIcon: InkWell(
                                  onTap: () {
                                    Get.toNamed(Routes.QR_SCANNER);
                                  },
                                  child: Icon(Icons.qr_code_2_sharp)),
                              hintMaxLines: 1,
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.green, width: 4.0))),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: ElevatedButton(
                  child: Text('BATTLE'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      textStyle: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                  onPressed: () {
                    Get.find<PlayMenuController>().invitePlayerForBattle();
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
