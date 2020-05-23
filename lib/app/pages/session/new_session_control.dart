import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nearbymenus/app/common_widgets/platform_alert_dialog.dart';
import 'package:nearbymenus/app/common_widgets/platform_progress_indicator.dart';
import 'package:nearbymenus/app/config/flavour_config.dart';
import 'package:nearbymenus/app/models/notification_streams.dart';
import 'package:nearbymenus/app/models/order.dart';
import 'package:nearbymenus/app/models/user_details.dart';
import 'package:nearbymenus/app/pages/home/home_page_manager.dart';
import 'package:nearbymenus/app/pages/home/home_page_patron.dart';
import 'package:nearbymenus/app/pages/home/home_page_staff.dart';
import 'package:nearbymenus/app/pages/session/messages_listener.dart';
import 'package:nearbymenus/app/services/database.dart';
import 'package:nearbymenus/app/services/device_info.dart';
import 'package:nearbymenus/app/models/session.dart';
import 'package:provider/provider.dart';

class NewSessionControl extends StatefulWidget {

  @override
  _NewSessionControlState createState() => _NewSessionControlState();
}

class _NewSessionControlState extends State<NewSessionControl> {
  Session session;
  Database database;
  DeviceInfo deviceInfo;
  UserDetails userDetails;
  NotificationStreams notificationStreams;

  @override
  void dispose() {
    notificationStreams.didReceiveLocalNotificationSubject.close();
    notificationStreams.selectNotificationSubject.close();
    super.dispose();
  }

  Future<void> _confirmContinue(BuildContext context) async {
    final didRequestSignOut = await PlatformAlertDialog(
      title: 'User will be signed-off from the other device',
      content: 'Are you sure you want to continue?',
      cancelActionText: 'Exit',
      defaultActionText: 'Continue',
    ).show(context);
    if (didRequestSignOut == true) {
      userDetails.deviceName = deviceInfo.deviceName;
      database.setUserDetails(userDetails);
    } else {
      exit(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    session = Provider.of<Session>(context);
    database = Provider.of<Database>(context, listen: false);
    deviceInfo = Provider.of<DeviceInfo>(context);
    notificationStreams = Provider.of<NotificationStreams>(context, listen: true);
    return FutureBuilder<UserDetails>(
      future: database.userDetailsSnapshot(database.userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done ||
            !snapshot.hasData || snapshot.data == null) {
            return Scaffold(
              body: Center(
                child: PlatformProgressIndicator(),
              ),
            );
        } else {
          userDetails = snapshot.data;
          if (userDetails.email == null || userDetails.email == '') {
            userDetails.email = session.userDetails.email;
          }
          session.setUserDetails(userDetails);
          session.currentOrder = null;
          if (userDetails.orderOnHold != null || userDetails.orderOnHold.isNotEmpty) {
            session.currentOrder = Order.fromMap(userDetails.orderOnHold, null);
          }
          print('User details: ${userDetails.toString()}');
          if (userDetails.deviceName != '' &&
              userDetails.deviceName != deviceInfo.deviceName) {
            _confirmContinue(context);
          }
          if (FlavourConfig.isManager()) {
            userDetails.role = ROLE_MANAGER;
          } else if (FlavourConfig.isStaff()) {
            userDetails.role = ROLE_STAFF;
          } else {
            userDetails.role = ROLE_PATRON;
          }
          database.setUserDetails(userDetails);
          Widget widget, home;
          switch (userDetails.role) {
            case ROLE_PATRON:
              {
                home = HomePagePatron(role: ROLE_PATRON,);
              }
              break;
            case ROLE_MANAGER:
              {
                home = HomePageManager(role: ROLE_MANAGER,);
              }
              break;
            case ROLE_STAFF:
              {
                home = HomePageStaff(role: ROLE_STAFF,);
              }
              break;
          }
          widget = MessagesListener(page: home);
          return widget;
        }
    });
  }
}
