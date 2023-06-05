import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mazeandtraps/controllers/ad_visual_controller.dart';

class MenuButton extends StatelessWidget {
  final String name;
  final String path;
  final void Function()? onPressed;
  static const double shadow = 0.5;
  static const double width = 200;
  static const double height = 40;

  const MenuButton({
    Key? key,
    required this.path,
    required this.name,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdAndVisualController>(
      builder: (controller) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
        child: InkWell(
          onTap: () async {
            if (!controller.buttonWasClick) {
              onPressed?.call();
              await controller.pressMenuButtonEffects(path);
            }
          },
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: AssetImage('assets/images/texture_ButtonIdle.png'),
                fit: BoxFit.fill,
                colorFilter: path == controller.currentPress
                    ? null
                    : ColorFilter.mode(
                        Colors.black.withOpacity(controller.mainScreenShaddow.value),
                        BlendMode.darken,
                      ),
              ),
            ),
            child: Center(
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  shadows: [
                    Shadow(offset: Offset(-shadow, -shadow), color: Colors.white),
                    Shadow(offset: Offset(shadow, -shadow), color: Colors.white),
                    Shadow(offset: Offset(shadow, shadow), color: Colors.white),
                    Shadow(offset: Offset(-shadow, shadow), color: Colors.white),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
