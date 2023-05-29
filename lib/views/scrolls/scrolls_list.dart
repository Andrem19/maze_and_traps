import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mazeandtraps/controllers/main_game_controller.dart';
import 'package:mazeandtraps/controllers/routing/app_pages.dart';
import 'package:mazeandtraps/elements/appbar_pages.dart';
import 'package:mazeandtraps/elements/shell.dart';

class ScrollListScreen extends StatelessWidget {
  const ScrollListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainGameController>(builder: (controller) {
      return Shell.getShell(Scaffold(
        appBar: AppBarPages.getAppBar(Routes.GENERAL_MENU, 'SCROLLS'),
        body: ListView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: false,
                itemCount: controller.scrollsList.value.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Image.asset('assets/images/scrolls.png', height: Get.size.height/25,),
                    title:
                        Text(controller.scrollsList.value[index]),
                  );
                },
              ),
      ));
    });
  }
}