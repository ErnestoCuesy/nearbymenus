import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nearbymenus/app/pages/landing/landing_page.dart';
import 'package:nearbymenus/app/services/auth.dart';
import 'package:nearbymenus/app/utilities/app_theme.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Provider<AuthBase>(
      builder: (context) => Auth(),
      child: MaterialApp(
        title: 'Nearby Menus',
        theme: AppTheme.createTheme(context),
        home: LandingPage(),
      ),
    );
  }
}
