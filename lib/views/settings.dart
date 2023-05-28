import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:mazeandtraps/controllers/settings_controller.dart';

import '../controllers/main_game_controller.dart';
import '../elements/custom_text_field.dart';
import '../elements/shell.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
    return Shell.getShell(
      GetBuilder<SettingsController>(builder: (controller) {
        return Scaffold(
            appBar: AppBar(
              title: Center(child: const Text('SETTINGS')),
              leading: IconButton(
                onPressed: () async {
                  // await onBackPressed();
                  Get.back();
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'User Name:',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: kIsWeb ? Get.size.width / 6 : Get.size.width / 2,
                        child: CustomTextField(
                            controller: controller.userNameController.value,
                            iconData: Icons.person,
                            hintText: 'User Name'),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey,
                              textStyle: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                          onPressed: () async {
                            await controller.updateName();
                          },
                          child: Text('Submit')),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Migration Token:',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${controller.migrationTokenGen}',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey,
                              textStyle: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                      onPressed: () {
                        controller.generateMigrationToken();
                      },
                      child: Text('Generate And Copy')),
                  const SizedBox(
                    height: 20,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Input the token from the account you want to transfer to this device:',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: kIsWeb ? Get.size.width / 6 : Get.size.width / 2,
                        child: CustomTextField(
                            controller: controller.migrationToken.value,
                            iconData: Icons.person,
                            hintText: 'Token'),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey,
                              textStyle: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                          onPressed: () async {
                            controller.migrate();
                          },
                          child: Text('Migrate')),
                    ],
                  ),
                  // Container(
                  //   width: kIsWeb ? Get.size.width / 6 : Get.size.width / 2,
                  //   child: CustomTextField(
                  //       controller: controller.migrationToken.value,
                  //       iconData: Icons.swap_horiz,
                  //       hintText: 'Token'),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 8),
                  //   child: ElevatedButton(
                  //       style: ElevatedButton.styleFrom(
                  //             backgroundColor: Colors.grey,
                  //             textStyle: const TextStyle(
                  //                 color: Colors.black,
                  //                 fontWeight: FontWeight.bold)),
                  //       onPressed: () {
                  //         controller.migrate();
                  //       },
                  //       child: const Text('Migrate')),
                  // ),
                ],
              ),
            ));
      }),
    );
  }
}
