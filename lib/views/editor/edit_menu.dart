import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mazeandtraps/elements/shell.dart';

import '../../controllers/ad_visual_controller.dart';
import '../../controllers/map_editor_controller.dart';
import '../../controllers/routing/app_pages.dart';
import '../../elements/appbar_pages.dart';

class EditMenu extends StatelessWidget {
  const EditMenu({super.key});

  // Future<void> onBackPressed() async {
  //   var adCtrl = Get.find<AdController>();
  //   if (adCtrl.interstitialAd != null) {
  //     adCtrl.interstitialAd?.show();
  //   } else {
  //     Get.offNamed(Routes.GENERAL_MENU);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Shell(
      content: 
      GetBuilder<MapEditorController>(
        builder: (controller) {
          return Scaffold(
            appBar: AppBarPages.getAppBar(Routes.GENERAL_MENU, 'MAP EDITOR'),
            body: Column(
              children: [
                StreamBuilder(
                  stream: controller.maps,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text("Loading");
                    }

                    return ListView(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;
                        return ListTile(
                          trailing: SizedBox(
                            width: Get.size.width / 5,
                            child: ElevatedButton(
                              child: Text('LOAD'),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Color.fromARGB(255, 54, 244, 67),
                                  textStyle: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                              onPressed: () {
                                controller.loadMap(data['name'].toString());
                              },
                            ),
                          ),
                          leading: ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth: 50,
                              minHeight: 50,
                              maxWidth: 50,
                              maxHeight: 50,
                            ),
                            child: Image.asset('assets/images/maze_icon.png',
                                fit: BoxFit.cover),
                          ),
                          title: Text(data['name'].toString()),
                          subtitle:
                              Text(data['author'].toString().substring(0, 20)),
                        );
                      }).toList(),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 150,
                    child: ElevatedButton(
                      child: Text('NEW MAP'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          textStyle: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold)),
                      onPressed: () {
                        controller.createNewMap();
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      ),
    );
  }
}
