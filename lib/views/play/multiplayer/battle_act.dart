import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:mazeandtraps/controllers/battle_act_controller.dart';

import '../../../elements/shell.dart';

class BattleAct extends StatelessWidget {
  const BattleAct({super.key});

  @override
  Widget build(BuildContext context) {
    return Shell.getShell(Scaffold(
      body: GetBuilder<BattleActController>(
        builder: (controller) {
          return Center(child: Text(''));
        }
      ),
    ));
  }
}