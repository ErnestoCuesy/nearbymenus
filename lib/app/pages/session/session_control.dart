import 'package:flutter/material.dart';
import 'package:nearbymenus/app/common_widgets/platform_alert_dialog.dart';
import 'package:nearbymenus/app/common_widgets/platform_progress_indicator.dart';
import 'package:nearbymenus/app/models/notification_streams.dart';
import 'package:nearbymenus/app/models/received_notification.dart';
import 'package:nearbymenus/app/models/user_details.dart';
import 'package:nearbymenus/app/pages/home/home_page_manager.dart';
import 'package:nearbymenus/app/pages/home/home_page_dev.dart';
import 'package:nearbymenus/app/pages/home/home_page_patron.dart';
import 'package:nearbymenus/app/pages/home/home_page_staff.dart';
import 'package:nearbymenus/app/pages/landing/loading_progress_indicator.dart';
import 'package:nearbymenus/app/pages/session/already_logged_in_page.dart';
import 'package:nearbymenus/app/pages/session/dbnotifications_listener.dart';
import 'package:nearbymenus/app/pages/session/restaurant_query.dart';
import 'package:nearbymenus/app/pages/session/role_selection_page.dart';
import 'package:nearbymenus/app/pages/session/user_details_page.dart';
import 'package:nearbymenus/app/services/database.dart';
import 'package:nearbymenus/app/services/device_info.dart';
import 'package:nearbymenus/app/models/session.dart';
import 'package:provider/provider.dart';

class SessionControl extends StatefulWidget {

  @override
  _SessionControlState createState() => _SessionControlState();
}

class _SessionControlState extends State<SessionControl> {
  Session session;
  Database database;
  DeviceInfo deviceInfo;
  UserDetails userDetails;
  NotificationStreams notificationStreams;

  void _configureDidReceiveLocalNotificationSubject() {
    notificationStreams.didReceiveLocalNotificationSubject.stream
        .listen((ReceivedNotification receivedNotification) async {
      final notificationReceived = await PlatformAlertDialog(
        title: receivedNotification.title != null
            ? receivedNotification.title
            : null,
        content: receivedNotification.body != null
            ? receivedNotification.body
            : null,
        defaultActionText: 'Ok',
      ).show(context);
      if (notificationReceived) {
        Navigator.of(context, rootNavigator: true).pop();
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                Placeholder(),
          ),
        );
      }
    });
  }

  void _configureSelectNotificationSubject() {
    notificationStreams.selectNotificationSubject.stream.listen((String payload) async {
      // TODO there's a problem here
      await Navigator.of(context).push(
        MaterialPageRoute(
          fullscreenDialog: false,
            builder: (context) => Placeholder(),
        ),
      );
    });
  }

  @override
  void dispose() {
    notificationStreams.didReceiveLocalNotificationSubject.close();
    notificationStreams.selectNotificationSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    session = Provider.of<Session>(context);
    database = Provider.of<Database>(context, listen: true);
    deviceInfo = Provider.of<DeviceInfo>(context);
    notificationStreams = Provider.of<NotificationStreams>(context, listen: true);
    _configureSelectNotificationSubject();
    _configureDidReceiveLocalNotificationSubject();
    return StreamBuilder<UserDetails>(
      stream: database.userDetailsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData && snapshot.data != null) {
            userDetails = snapshot.data;
            session.setUserDetails(userDetails);
            print('User details: ${userDetails.toString()}');
            if (userDetails.deviceName != '' &&
                userDetails.deviceName != deviceInfo.deviceName) {
              return AlreadyLoggedIn(
                userDetails: userDetails,
                database: database,
                deviceInfo: deviceInfo,
              );
            }
            if (userDetails.role == '' || userDetails.role == null ||
                userDetails.role == ROLE_NONE) {
              return RoleSelectionPage();
            }
            if ((userDetails.nearestRestaurantId == '' || userDetails.nearestRestaurantId == null) &&
                (userDetails.role == ROLE_PATRON ||
                 userDetails.role == ROLE_STAFF)) {
              return RestaurantQuery(role: userDetails.role,);
            }
            if (userDetails.name == '') {
              return UserDetailsPage();
            }
            userDetails.deviceName = deviceInfo.deviceName;
            userDetails.nearestRestaurantId = userDetails.nearestRestaurantId ?? 'None found';
            userDetails.address = userDetails.address ?? 'Not entered yet';
            database.setUserDetails(userDetails);
            Widget home = LoadingProgressIndicator();
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
              case ROLE_DEV:
                {
                  home = HomePageDev(role: ROLE_DEV,);
                }
                break;
            }
            return DBNotificationsListener(page: home);
          } else {
            return Scaffold(
              body: Center(
                child: PlatformProgressIndicator(),
              ),
            );
          }
        } else {
          return Scaffold(
            body: Center(
              child: PlatformProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
