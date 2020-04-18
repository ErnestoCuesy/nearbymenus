import 'package:flutter/material.dart';
import 'package:nearbymenus/app/common_widgets/list_items_builder.dart';
import 'package:nearbymenus/app/models/authorizations.dart';
import 'package:nearbymenus/app/models/session.dart';
import 'package:nearbymenus/app/models/user_notification.dart';
import 'package:nearbymenus/app/services/database.dart';
import 'package:provider/provider.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  Session session;
  Database database;

  Widget _buildContents(BuildContext context) {
    return StreamBuilder<List<UserNotification>>(
      stream: database.userNotifications2(session.nearestRestaurant.id, database.userId, session.userDetails.role),
      builder: (context, snapshot) {
        return ListItemsBuilder<UserNotification>(
            snapshot: snapshot,
            itemBuilder: (context, notification) {
              return Card(
                child: ListTile(
                  isThreeLine: true,
                  leading: Icon(Icons.message),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'To:  ${notification.toRole}',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      Text(
                          'From: ${notification.fromRole} (${notification.fromName})',
                      ),
                    ],
                  ),
                  // subtitle: Text('${restaurant.restaurantLocation}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(notification.type)
                    ],
                  ),
                  trailing: Icon(Icons.traffic),
                  onTap: () {
                    // TODO append to existing document's maps
                      final authorizations = Authorizations(
                          authorizedRoles: {'${notification.fromUid}': 'Staff'},
                          authorizedNames: {'${notification.fromUid}': '${notification.fromName}'}
                      );
                      database.setAuthorization(session.nearestRestaurant.id, authorizations);
                    },
                ),
              );
            }
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    session = Provider.of<Session>(context);
    database = Provider.of<Database>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications', style: TextStyle(color: Theme
            .of(context)
            .appBarTheme
            .color),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete, color: Theme.of(context).appBarTheme.color,),
            iconSize: 32.0,
            padding: const EdgeInsets.only(right: 16.0),
            onPressed: () => {},
          ),
        ],
      ),
      body: _buildContents(context),
    );
  }
}
