import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:mazeandtraps/controllers/pausesplashcontroller.dart';

import '../../controllers/routing/app_pages.dart';
import '../../elements/shell.dart';

class PauseSplashScreen extends StatefulWidget {
  PauseSplashScreen({super.key});

  @override
  State<PauseSplashScreen> createState() => _PauseSplashScreenState();
}

class _PauseSplashScreenState extends State<PauseSplashScreen> {
  @override
  void initState() {
    Get.put(PauseSplashController());

    super.initState();
  }

  @override
  void dispose() {
    Get.delete<PauseSplashController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PauseSplashController>(builder: (controller) {
      return GestureDetector(
        onTap: () async {
          controller.playDoor();
        },
        child: Shell(
      content: Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Center(
                  child: Image.asset(
                    "assets/images/maze_preview.jpg",
                    width: 250,
                    height: 250,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      controller.isShow.value ? controller.text.value : '',
                      style: const TextStyle(fontSize: 25),
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        )
      );
    });
  }
}
