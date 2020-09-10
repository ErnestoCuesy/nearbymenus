import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'app/config/flavour_config.dart';
import 'app/app.dart';

void main() async {
  var flavour = Flavour.MANAGER;
  FlavourConfig(
    flavour: flavour,
    colorTheme: ColorTheme.BLACK,
    bannerColor: Colors.blue,
  );

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MaterialApp(
      home: MyApp(),
    ),
  );
}
