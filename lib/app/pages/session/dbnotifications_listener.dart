import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:nearbymenus/app/common_widgets/platform_progress_indicator.dart';
import 'package:nearbymenus/app/models/session.dart';
import 'package:nearbymenus/app/models/user_details.dart';
import 'package:nearbymenus/app/models/user_notification.dart';
import 'package:nearbymenus/app/pages/session/check_staff_authorization.dart';
import 'package:nearbymenus/app/services/database.dart';
import 'package:provider/provider.dart';

class DBNotificationsListener extends StatefulWidget {
  final Widget page;

  const DBNotificationsListener({Key key, this.page}) : super(key: key);

  @override
  _DBNotificationsListenerState createState() => _DBNotificationsListenerState();
}

class _DBNotificationsListenerState extends State<DBNotificationsListener> {
  Session session;
  Database database;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  Future<void> _notifyUser(UserNotification notification) async {
    // TODO temp notifications code for testing
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'CH1', 'Role notifications', 'Channel used to notify restaurant roles',
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'Nearby Menus', 'Notification from ${notification.fromRole}: ${notification.type}', platformChannelSpecifics,
        payload: 'item x');
  }

  @override
  Widget build(BuildContext context) {
    session = Provider.of<Session>(context);
    database = Provider.of<Database>(context, listen: true);
    flutterLocalNotificationsPlugin = Provider.of<FlutterLocalNotificationsPlugin>(context);
    return StreamBuilder<List<UserNotification>>(
        stream: database.userNotifications2(session.nearestRestaurant.id, database.userId, session.userDetails.role),
        //stream: database.userNotifications(database.userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: PlatformProgressIndicator(),
              ),
            );
          }
          if (snapshot.hasData) {
            final notificationsList = snapshot.data;
            notificationsList.forEach((notification) {
              print('Notification for ${notification.toRole}');
              if (notification.toRole == session.userDetails.role && !notification.read) {
                _notifyUser(notification);
              }
            });
          }
          if (session.userDetails.role == ROLE_STAFF) {
            return CheckStaffAuthorization();
          } else {
            return widget.page;
          }
        }
    );
  }
}
