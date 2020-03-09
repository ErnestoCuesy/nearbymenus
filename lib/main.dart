import 'package:flutter/material.dart';
import 'package:nearbymenus/app/services/apple_sign_in_available.dart';
import 'app/config/flavour_config.dart';
import 'package:provider/provider.dart';
import 'app/app.dart';

void main() async {
  var flavour = Flavour.DEV;
  FlavourConfig(
    flavour: flavour,
    colorTheme: ColorTheme.GREENISH,
    bannerColor: Colors.blue,
    signInWithGoogle: false,
    signInWithFacebook: false,
    signInWithApple: false,
    values: FlavourValues(
      dbRootCollection: flavour == Flavour.DEV ? 'development' : 'production',
    ),
  );

  WidgetsFlutterBinding.ensureInitialized();
  final appleSignInAvailable = FlavourConfig.instance.signInWithApple ? await AppleSignInAvailable.check() : null;

  if (FlavourConfig.instance.signInWithApple) {
    runApp(Provider<AppleSignInAvailable>.value(
      value: appleSignInAvailable,
      child: MyApp(),
    ));
  } else {
    runApp(MyApp());
  }
}
