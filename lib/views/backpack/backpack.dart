import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:mazeandtraps/controllers/routing/app_pages.dart';
import 'package:mazeandtraps/controllers/traps_and_shop_controller.dart';
import 'package:mazeandtraps/elements/appbar_pages.dart';
import 'package:mazeandtraps/elements/shell.dart';
import 'package:mazeandtraps/views/backpack/current_set.dart';
import 'package:mazeandtraps/views/backpack/upper_collection.dart';

class BackpackScreen extends StatelessWidget {
  const BackpackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Shell.getShell(Scaffold(
      appBar: AppBarPages.getAppBar(Routes.GENERAL_MENU, 'BACKPACK'),
      body: GetBuilder<TrapsAndShopController>(builder: (controller) {
        return Column(
          children: [
            UpperCollection.upperCollection(),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: const Text(
                'Backpack Game Set',
                style: const TextStyle(fontSize: 25),
              ),
            ),
            CurrentSet.currentSet(),
            Text(
              'Weight: ${controller.weight.value.toString()}',
              style: TextStyle(fontSize: 30, color: Colors.green),
            ),
          ],
        );
      }),
    ));
  }
}
