import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nearbymenus/app/pages/landing/splash_screen.dart';
import 'package:nearbymenus/app/services/auth.dart';
import 'package:nearbymenus/app/services/database.dart';
import 'package:nearbymenus/app/services/device_info.dart';
import 'package:nearbymenus/app/models/session.dart';
import 'package:nearbymenus/app/services/iap_manager.dart';
import 'package:nearbymenus/app/utilities/app_theme.dart';
import 'package:nearbymenus/app/utilities/logo_image_asset.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:nearbymenus/app/pages/landing/subscription_check.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Geolocator _geolocator;
  Position _currentLocation;
  PermissionStatus _permissionStatus;

  @override
  void initState() {
    super.initState();
    _determinePermissions();
  }

  _determinePermissions(){
    PermissionHandler().checkPermissionStatus(PermissionGroup.location)
        .then((status) => _updatePermissions(status));
  }

  _updatePermissions(PermissionStatus status){
    if (_permissionStatus != status) {
      setState(() {
        _permissionStatus = status;
        if (_permissionStatus == PermissionStatus.granted){
          // print('Permission had already been granted... determining location...');
          _determineCurrentLocation();
        } else {
          // print('Permission not granted yet... asking...');
          PermissionHandler().requestPermissions([PermissionGroup.location])
              .then((permission){
            if (permission[PermissionGroup.location] == PermissionStatus.granted){
              // print('Permission granted... determining location...');
              _determineCurrentLocation();
            } else {
              // print('Permission not granted by user... exiting...');
              exit (0);
            }
          });
        }
      });
    }
  }

  _determineCurrentLocation() {
    _geolocator = Geolocator();
    _geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best).then((position) {
      _currentLocation = position;
      print('Current location: ${_currentLocation.latitude} : ${_currentLocation.longitude}');
      setState(() {
        _currentLocation = position;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Below line disabled since the bottom android nav bar behaves funny
    // SystemChrome.setEnabledSystemUIOverlays([]);
    if (_currentLocation != null) {
      return MultiProvider(
          providers: [
            Provider<LogoImageAsset>(create: (context) => LogoImageAsset()),
            Provider<IAPManagerBase>(create: (context) => IAPManagerMock(userID: 'test@test.com')),
            Provider<DeviceInfo>(create: (context) => DeviceInfo()),
            Provider<AuthBase>(create: (context) => Auth(),),
            Provider<Database>(create: (context) => FirestoreDatabase()),
            Provider<Session>(create: (context) => Session(position: _currentLocation)),
          ],
          child: MaterialApp(
            title: 'Nearby Menus',
            theme: AppTheme.createTheme(context),
            // home: LandingPage(),
            home: SubscriptionCheck(),
            builder: (context, widget) => ResponsiveWrapper.builder(
              widget,
              maxWidth: 1200,
              minWidth: 450,
              defaultScale: true,
              breakpoints: [
                ResponsiveBreakpoint(breakpoint: 450, name: MOBILE),
                ResponsiveBreakpoint(breakpoint: 800, name: TABLET, autoScale: true),
                ResponsiveBreakpoint(breakpoint: 1000, name: TABLET, autoScale: true),
              ],
            ),
          )
      );
    } else {
      return SplashScreen();
    }
  }
}
