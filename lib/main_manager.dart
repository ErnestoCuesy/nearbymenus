import 'package:flutter/material.dart';
import 'app/config/flavour_config.dart';
import 'app/app.dart';

void main() {
  var flavour = Flavour.MANAGER;
  FlavourConfig(
    flavour: flavour,
    colorTheme: ColorTheme.PURPLE,
    bannerColor: Colors.blue,
  );

  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MaterialApp(
      home: MyApp(),
    ),
  );
}
