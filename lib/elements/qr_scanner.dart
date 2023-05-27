import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../controllers/qr_controller.dart';

class QRView extends StatefulWidget {
  const QRView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewState();
}

class _QRViewState extends State<QRView> {
  QrController qrCtrl = Get.find<QrController>();

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      qrCtrl.controller!.pauseCamera();
    }
    qrCtrl.controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<QrController>(
      builder: (controller) {
        return Scaffold(
          body: Column(
            children: <Widget>[
              Expanded(flex: 4, child: controller.BuildQrView(context)),
            ],
          ),
        );
      }
    );
  }

  
}
