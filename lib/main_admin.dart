import 'package:flutter/material.dart';
import 'app/config/flavour_config.dart';
import 'app/app.dart';

void main() {
  var flavour = Flavour.ADMIN;
  FlavourConfig(
    flavour: flavour,
    colorTheme: ColorTheme.BLACK,
    bannerColor: Colors.blue,
  );

  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MaterialApp(
      home: MyApp(),
    ),
  );
}
