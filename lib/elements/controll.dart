import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/main_game_controller.dart';
import '../models/maze_map.dart';

class Control extends StatelessWidget {
  const Control({super.key});
  final double radiusCircle = 40;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainGameController>(builder: (controller) {
      return Opacity(
        opacity: 0.5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    controller.moveDir = Direction.up;
                    controller.playButton();
                  },
                  child: Image.asset('assets/images/control/UpDamageIcon.png', height: radiusCircle,)
                )
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    controller.moveDir = Direction.left;
                    controller.playButton();
                  },
                  child: Image.asset('assets/images/control/texture_LeftRed.png', height: radiusCircle,)
                ),
                SizedBox(
                  width: 5,
                ),
                Builder(
                  builder: (context) {
                    if (controller.moveDir == Direction.up) {
                      return currentDirection(Icon(Icons.arrow_circle_up));
                    } else if (controller.moveDir == Direction.left) {
                      return currentDirection(Icon(Icons.arrow_circle_left));
                    } else if (controller.moveDir == Direction.right) {
                      return currentDirection(Icon(Icons.arrow_circle_right));
                    } else if (controller.moveDir == Direction.down) {
                      return currentDirection(Icon(Icons.arrow_circle_down));
                    }
                    return currentDirection(Icon(Icons.arrow_circle_up));
                  },
                ),
                SizedBox(
                  width: 5,
                ),
                InkWell(
                  onTap: () {
                    controller.moveDir = Direction.right;
                    controller.playButton();
                  },
                  child: Image.asset('assets/images/control/texture_RightRed.png', height: radiusCircle,)
                )
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    controller.moveDir = Direction.down;
                    controller.playButton();
                  },
                  child: Image.asset('assets/images/control/texture_DownRed.png', height: radiusCircle,)
                )
              ],
            )
          ],
        ),
      );
    });
  }

  Container currentDirection(Icon icon) {
    return Container(
      height: radiusCircle,
      width: radiusCircle,
      decoration: new BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: icon,
      ),
    );
  }
}
