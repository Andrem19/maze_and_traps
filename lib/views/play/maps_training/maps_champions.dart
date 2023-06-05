import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:mazeandtraps/controllers/maps_menu_controller.dart';
import 'package:mazeandtraps/controllers/routing/app_pages.dart';
import 'package:mazeandtraps/elements/appbar_pages.dart';
import 'package:mazeandtraps/elements/shell.dart';

class MapChampions extends StatelessWidget {
  const MapChampions({super.key});

  @override
  Widget build(BuildContext context) {
    return Shell(
      content: 
      GetBuilder<MapsMenuController>(
        builder: (controller) {
          return Scaffold(
            appBar: AppBarPages.getAppBar(Routes.GENERAL_MENU, 'MAP CHAMPIONS'),
            body: controller.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ListView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: false,
                itemCount: controller.mapChampions.value.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Text(
                      (index + 1).toString(),
                      style: TextStyle(fontSize: 20, color: Colors.greenAccent),
                    ),
                    title: Text(controller.mapChampions.value[index].name),
                    trailing:
                        Text(controller.mapChampions.value[index].seconds.toString()),
                  );
                },
              ),
          );
        }
      )
    );
  }
}