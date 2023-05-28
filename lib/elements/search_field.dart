import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:mazeandtraps/controllers/ad_visual_controller.dart';
import 'package:mazeandtraps/controllers/main_game_controller.dart';

import '../controllers/routing/app_pages.dart';

class SearchField extends StatelessWidget {
  const SearchField({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<MainGameController>();
    return GetBuilder<AdAndVisualController>(builder: (AdController) {
      return ColorFiltered(
        colorFilter: ColorFilter.mode(
                        Colors.black
                            .withOpacity(AdController.mainScreenShaddow.value),
                        BlendMode.darken),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
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
                          borderSide:
                              BorderSide(color: Colors.green, width: 4.0))),
                ),
              ),
            ),
            Flexible(
                child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: ElevatedButton(
                child: Text('BATTLE'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    textStyle: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold)),
                onPressed: () {
                  // controller.invitePlayerForBattle();
                },
              ),
            )),
          ],
        ),
      );
    });
  }
}
