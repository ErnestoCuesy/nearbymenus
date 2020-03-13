import 'package:flutter/material.dart';
import 'package:nearbymenus/app/pages/landing/landing_page.dart';
import 'package:nearbymenus/app/services/auth.dart';
import 'package:nearbymenus/app/services/device_info.dart';
import 'package:nearbymenus/app/utilities/app_theme.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Below line disabled since the bottom android nav bar behaves funny
    // SystemChrome.setEnabledSystemUIOverlays([]);
    return MultiProvider(
      providers: [
        Provider<AuthBase>(create: (context) => Auth(),),
        Provider<DeviceInfo>(create: (context) => DeviceInfo()),
      ],
      child: MaterialApp(
        title: 'Nearby Menus',
        theme: AppTheme.createTheme(context),
        home: LandingPage(),
      )
    );
//    return Provider<AuthBase>(
//      create: (context) => Auth(),
//      child: MaterialApp(
//        title: 'Nearby Menus',
//        theme: AppTheme.createTheme(context),
//        home: LandingPage(),
//      ),
//    );
  }
}
