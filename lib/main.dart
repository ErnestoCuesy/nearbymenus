import 'package:flutter/material.dart';
import 'package:nearbymenus/app/services/apple_sign_in_available.dart';
import 'app/config/flavour_config.dart';
import 'package:provider/provider.dart';
import 'app/app.dart';

void main() async {
  FlavourConfig(
      flavour: Flavour.PROD,
      color: Colors.green,
      values: FlavourValues(databaseName: 'dev'));

  WidgetsFlutterBinding.ensureInitialized();
  final appleSignInAvailable = await AppleSignInAvailable.check();

  runApp(Provider<AppleSignInAvailable>.value(
    value: appleSignInAvailable,
    child: MyApp(),
  ));
}
