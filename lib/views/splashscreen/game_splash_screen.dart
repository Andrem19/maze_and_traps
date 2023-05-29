import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mazeandtraps/views/splashscreen/pause_splash_screen.dart';

import '../../controllers/routing/app_pages.dart';
import '../../elements/shell.dart';

class GameSplashScreen extends StatelessWidget {
  const GameSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Shell.getShell(AnimatedSplashScreen(
      duration: 1000,
      splash: Image.asset("assets/images/maze_preview.jpg"),
      nextScreen: PauseSplashScreen(),
      splashTransition: SplashTransition.scaleTransition,
      splashIconSize: 250,
      backgroundColor: Colors.black,
    ));
  }
}
