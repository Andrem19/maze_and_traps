import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Shell {
  static Widget getShell(Widget content) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Scaffold(
        body: Center(
          child: Container(
            decoration: kIsWeb
                ? BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color.fromARGB(255, 72, 68, 68),
                    boxShadow: [
                      BoxShadow(color: Colors.green, spreadRadius: 3),
                    ],
                  )
                : const BoxDecoration(),
            width: kIsWeb ? Get.size.width / 3 : Get.size.width,
            child: content,
          ),
        ),
      );
    });
  }
}
