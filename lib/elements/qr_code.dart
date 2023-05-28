import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:mazeandtraps/controllers/ad_visual_controller.dart';
import 'package:mazeandtraps/controllers/main_game_controller.dart';

class QrCode extends StatelessWidget {
  const QrCode({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdAndVisualController>(builder: (controller) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: InkWell(
          onTap: () => controller.changeQrShow(),
          child: Builder(builder: (context) {
            if (controller.showQR.value) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Container(
                  color: Colors.white,
                  height: 200,
                  width: 200,
                  child: controller.createQR(),
                ),
              );
            } else {
              return ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Container(
                  color: Colors.white,
                  height: 200,
                  width: 200,
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(controller.mainScreenShaddow.value), BlendMode.darken),
                    child: Image.asset('assets/images/maze_preview.jpg'),
                  ),
                ),
              );
            }
          }),
        ),
      );
    });
  }
}
