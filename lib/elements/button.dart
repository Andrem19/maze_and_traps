import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mazeandtraps/controllers/ad_visual_controller.dart';

class MenuButton extends StatelessWidget {
  final String name;
  final String path;
  static const double shaddow = 0.5;
  const MenuButton({super.key, required this.path, required this.name});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdAndVisualController>(builder: (controller) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
        child: InkWell(
          onTap: () async {
            if (!controller.buttonWasClick) {
              await controller.pressMenuButtonEffects(path);
            }
          },
          child: Container(
            width: 200,
            child: Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                        Colors.black
                            .withOpacity(path == controller.currentPress ? 0.0 : controller.mainScreenShaddow.value),
                        BlendMode.darken),
                    child: Image.asset(
                      'assets/images/texture_ButtonIdle.png',
                      height: Get.size.height / 20,
                      width: Get.size.width / 2,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Text(
                  name,
                  style: const TextStyle(
                      // fontFamily: 'ArchitectsDaughter',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      shadows: [
                        Shadow(
                            // bottomLeft
                            offset: Offset(-shaddow, -shaddow),
                            color: Colors.white),
                        Shadow(
                            // bottomRight
                            offset: Offset(shaddow, -shaddow),
                            color: Colors.white),
                        Shadow(
                            // topRight
                            offset: Offset(shaddow, shaddow),
                            color: Colors.white),
                        Shadow(
                            // topLeft
                            offset: Offset(-shaddow, shaddow),
                            color: Colors.white),
                      ]),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
