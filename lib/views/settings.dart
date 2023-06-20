import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:mazeandtraps/controllers/routing/app_pages.dart';
import 'package:mazeandtraps/controllers/settings_controller.dart';
import 'package:mazeandtraps/elements/appbar_pages.dart';

import '../controllers/main_game_controller.dart';
import '../elements/custom_text_field.dart';
import '../elements/shell.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Shell(
      content: GetBuilder<SettingsController>(builder: (controller) {
        return Scaffold(
            appBar: AppBarPages.getAppBar(Routes.GENERAL_MENU, 'SETTINGS'),
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
                  Row(
                    children: [
                      Text('Show direction arrows controller: '),
                      Switch(
                        value: controller.showControl.value,
                        onChanged: (value) {
                          controller.showControl.value = value;
                          controller.changeShowControl(value);
                          controller.update();
                        },
                        activeTrackColor: Colors.lightGreenAccent,
                        activeColor: Colors.green,
                      ),
                    ],
                  ),
                ],
              ),
            ));
      }),
    );
  }
}
