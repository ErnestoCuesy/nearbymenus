import 'package:flutter/material.dart';
import 'app/config/flavour_config.dart';
import 'app/app.dart';

void main() async {
  var flavour = Flavour.DEV;
  FlavourConfig(
    flavour: flavour,
    colorTheme: ColorTheme.GREENISH,
    bannerColor: Colors.blue,
  );

  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}
