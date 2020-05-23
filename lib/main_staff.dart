import 'package:flutter/material.dart';
import 'app/config/flavour_config.dart';
import 'app/app.dart';

void main() {
  var flavour = Flavour.STAFF;
  FlavourConfig(
    flavour: flavour,
    colorTheme: ColorTheme.ORANGE,
    bannerColor: Colors.blue,
  );

  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MaterialApp(
      home: MyApp(),
    ),
  );
}
