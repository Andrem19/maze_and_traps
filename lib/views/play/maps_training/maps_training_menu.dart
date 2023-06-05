import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mazeandtraps/controllers/maps_menu_controller.dart';
import 'package:mazeandtraps/controllers/routing/app_pages.dart';
import 'package:mazeandtraps/elements/appbar_pages.dart';
import 'package:mazeandtraps/elements/shell.dart';

class MapsTrainingMenu extends StatelessWidget {
  const MapsTrainingMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Shell(
      content: 
      Scaffold(
  appBar: AppBarPages.getAppBar(Routes.GENERAL_MENU, 'MAPS TRAINING'),
  body: GetBuilder<MapsMenuController>(
    builder: (controller) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextField(
                onChanged: (value) {
                  controller.search(value);
                },
                controller: controller.queryKey,
                keyboardType: TextInputType.text,
                maxLines: 1,
                decoration: InputDecoration(
                  labelText: 'Map Name',
                  prefixIcon: Icon(Icons.search),
                  hintMaxLines: 1,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.green, 
                      width: 4.0
                    )
                  )
                ),
              ),
            ),
          ),
          Expanded(
            flex: 10,
            child: StreamBuilder(
              stream: controller.maps,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Container(
                    height: MediaQuery.of(context).size.height - kToolbarHeight - 80,
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      children: snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                        return ListTile(
                          trailing: FittedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: InkWell(
                                    onTap: () {
                                      controller.loadMapChampions(data['id']);
                                      Get.toNamed(Routes.MAP_CHAMPIONS);
                                    },
                                    child: Icon(Icons.leaderboard),
                                  ),
                                ),
                                ElevatedButton(
                                  child: Text('PLAY'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color.fromARGB(255, 54, 244, 67),
                                    textStyle: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold
                                    )
                                  ),
                                  onPressed: () {
                                    controller.prepareQuestGame(data['id'].toString());
                                  },
                                ),
                              ],
                            ),
                          ),
                          leading: ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth: 50,
                              minHeight: 50,
                              maxWidth: 50,
                              maxHeight: 50,
                            ),
                            child: Image.asset('assets/images/maze_icon.png', fit: BoxFit.cover),
                          ),
                          title: Text(data['name'].toString()),
                          subtitle: Text(data['author'].toString().substring(0, 20)),
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    },
  ),
)
    );
  }
}