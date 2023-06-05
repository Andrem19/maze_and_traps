import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/bindings/bindings.dart';
import 'controllers/routing/app_pages.dart';
import 'firebase_options.dart';
import 'keys.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      scaffoldMessengerKey: Keys.scaffoldMessengerKey,
      debugShowCheckedModeBanner: false,
      title: 'Maze Rush',
      theme: ThemeData(
        fontFamily: 'MazeRush',
        brightness: Brightness.dark,
        buttonTheme: ButtonThemeData(
        buttonColor: Colors.grey, // replace with your desired color
      ),
      ),
      getPages: AppPages.routes,
      initialRoute: AppPages.INITIAL,
      initialBinding: MainScreenBinding(),
    );
  }
}

