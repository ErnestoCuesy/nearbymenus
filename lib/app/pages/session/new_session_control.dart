import 'package:flutter/material.dart';
import 'package:nearbymenus/app/common_widgets/platform_progress_indicator.dart';
import 'package:nearbymenus/app/models/notification_streams.dart';
import 'package:nearbymenus/app/models/user_details.dart';
import 'package:nearbymenus/app/pages/home/home_page_manager.dart';
import 'package:nearbymenus/app/pages/home/home_page_patron.dart';
import 'package:nearbymenus/app/pages/home/home_page_staff.dart';
import 'package:nearbymenus/app/pages/session/messages_listener.dart';
import 'package:nearbymenus/app/services/database.dart';
import 'package:nearbymenus/app/models/session.dart';
import 'package:provider/provider.dart';

class NewSessionControl extends StatefulWidget {

  @override
  _NewSessionControlState createState() => _NewSessionControlState();
}

class _NewSessionControlState extends State<NewSessionControl> {
  Session session;
  Database database;
  UserDetails userDetails;
  NotificationStreams notificationStreams;

  @override
  void dispose() {
    notificationStreams.didReceiveLocalNotificationSubject.close();
    notificationStreams.selectNotificationSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    session = Provider.of<Session>(context);
    database = Provider.of<Database>(context, listen: false);
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
          Widget widget, home;
          switch (session.role) {
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
