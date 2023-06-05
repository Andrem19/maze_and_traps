import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mazeandtraps/controllers/leaders_controller.dart';
import 'package:mazeandtraps/controllers/routing/app_pages.dart';
import 'package:mazeandtraps/elements/appbar_pages.dart';

import '../elements/shell.dart';

class GeneralLeaderboard extends StatelessWidget {
  const GeneralLeaderboard({super.key});

  // Future<void> onBackPressed() async {
  //   var adCtrl = Get.find<AdController>();
  //   if (adCtrl.interstitialAd != null) {
  //     adCtrl.interstitialAd?.show();
  //   } else {
  //     Get.back();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LeadersController>(builder: (controller) {
      return Shell(
      content: Scaffold(
        appBar: AppBarPages.getAppBar(Routes.GENERAL_MENU, 'LEADERBOARD'),
        body: controller.isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: false,
                itemCount: controller.leaders.value.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Text(
                      (index + 1).toString(),
                      style: TextStyle(fontSize: 20, color: Colors.greenAccent),
                    ),
                    title: Text(controller.leaders.value[index].name),
                    trailing:
                        Text(controller.leaders.value[index].points.toString()),
                  );
                },
              ),
      ));
    });
  }
}
