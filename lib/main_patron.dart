import 'package:flutter/material.dart';
import 'app/config/flavour_config.dart';
import 'app/app.dart';

void main() {
  var flavour = Flavour.PATRON;
  FlavourConfig(
    flavour: flavour,
    colorTheme: ColorTheme.GREEN,
    bannerColor: Colors.blue,
  );

  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MaterialApp(
      home: MyApp(),
    ),
  );
}
