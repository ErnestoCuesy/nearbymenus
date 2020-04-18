import 'package:flutter/material.dart';
import 'package:nearbymenus/app/common_widgets/list_items_builder.dart';
import 'package:nearbymenus/app/models/authorizations.dart';
import 'package:nearbymenus/app/models/session.dart';
import 'package:nearbymenus/app/models/user_message.dart';
import 'package:nearbymenus/app/services/database.dart';
import 'package:provider/provider.dart';

class MessagesPage extends StatefulWidget {
  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  Session session;
  Database database;
  Authorizations authorizations = Authorizations(authorizedRoles: {}, authorizedNames: {});

  void _getAuthorizations() async {
    await database.authorizationsSnapshot().then((authorizationsList) {
      if (authorizationsList.length > 0) {
        authorizationsList.forEach((authorization) {
          if (authorization.id == session.nearestRestaurant.id) {
            authorizations = authorization;
          }
        });
      }
    });
  }

  Widget _buildContents(BuildContext context) {
    return StreamBuilder<List<UserMessage>>(
      stream: database.userMessages(
        session.nearestRestaurant.id,
        database.userId,
        session.userDetails.role,
      ),
      builder: (context, snapshot) {
        return ListItemsBuilder<UserMessage>(
            snapshot: snapshot,
            itemBuilder: (context, message) {
              return Card(
                child: ListTile(
                  isThreeLine: true,
                  leading: Icon(Icons.message),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        message.type,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      Text(
                        'From: ${message.fromName}',
                      ),
                      Text(
                        'To:  ${session.userDetails.name}',
                      ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[Text(message.id)],
                  ),
                  trailing: Icon(Icons.traffic),
                  onTap: () {
                    // TODO append to existing document's maps
                    authorizations.authorizedRoles.putIfAbsent(message.fromUid, () => 'Staff');
                    authorizations.authorizedNames.putIfAbsent(message.fromUid, () => message.fromName);
                    database.setAuthorization(session.nearestRestaurant.id, authorizations);
                  },
                ),
              );
            });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    session = Provider.of<Session>(context);
    database = Provider.of<Database>(context);
    _getAuthorizations();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Messages',
          style: TextStyle(color: Theme.of(context).appBarTheme.color),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.delete,
              color: Theme.of(context).appBarTheme.color,
            ),
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
