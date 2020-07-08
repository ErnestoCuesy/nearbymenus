import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nearbymenus/app/common_widgets/list_items_builder.dart';
import 'package:nearbymenus/app/common_widgets/platform_exception_alert_dialog.dart';
import 'package:nearbymenus/app/config/flavour_config.dart';
import 'package:nearbymenus/app/models/authorizations.dart';
import 'package:nearbymenus/app/models/session.dart';
import 'package:nearbymenus/app/models/user_message.dart';
import 'package:nearbymenus/app/pages/messages/authorized_dates.dart';
import 'package:nearbymenus/app/services/database.dart';
import 'package:nearbymenus/app/utilities/format.dart';
import 'package:provider/provider.dart';

class MessagesPage extends StatefulWidget {
  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  Session session;
  Database database;
  Authorizations authorizations =
      Authorizations(authorizedRoles: {}, authorizedNames: {}, authorizedDates: {});
  String role = ROLE_PATRON;

  Future<void> _getAuthorizations(UserMessage message) async {
    await database.authorizationsSnapshot().then((authorizationsList) {
      if (authorizationsList.length > 0) {
        authorizationsList.forEach((authorization) {
          if (authorization.id == message.restaurantId) {
            authorizations = authorization;
          }
        });
      }
    });
  }

  Future<void> _deleteMessage(BuildContext context, UserMessage message) async {
    try {
      await database.deleteMessage(message.id);
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Operation failed',
        exception: e,
      ).show(context);
    }
  }

  Future<bool> _confirmDismiss(BuildContext context, UserMessage message) async {
    if (message.authFlag) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Disable access first to delete'),
        ),
      );
    }
    return !message.authFlag;
  }

  Widget _buildContents(BuildContext context) {
    if (FlavourConfig.isManager()) {
      role = ROLE_MANAGER;
    } else if (FlavourConfig.isStaff()) {
      role = ROLE_STAFF;
    } else if (FlavourConfig.isVenue()) {
      role = ROLE_VENUE;
    }
    return StreamBuilder<List<UserMessage>>(
      stream: database.managerMessages(
        database.userId,
        role,
      ),
      builder: (context, snapshot) {
        return ListItemsBuilder<UserMessage>(
            title: 'Restaurant Access',
            message: 'You don\'t have restaurant access requests',
            snapshot: snapshot,
            itemBuilder: (context, message) {
              return Dismissible(
                background: Container(color: Colors.red),
                key: Key('msg-${message.id}'),
                direction: DismissDirection.endToStart,
                confirmDismiss: (_) => _confirmDismiss(context, message),
                onDismissed: (direction) => _deleteMessage(context, message),
                child: Card(
                  margin: EdgeInsets.all(12.0),
                  child: ListTile(
                    isThreeLine: true,
                    leading: Icon(Icons.message),
                    title: Padding(
                      padding: const EdgeInsets.only(top: 4.0, bottom: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 8.0, bottom: 4.0),
                            child: Text(
                              message.type,
                              style: Theme.of(context).textTheme.headline6,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 4.0, bottom: 4.0),
                            child: Text(
                              'Requested by: ${message.fromName}',
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 4.0, bottom: 4.0),
                            child: Text(
                              'Slide the switch to grant or deny',
                            ),
                          ),
                          Text(
                            'Swipe message left to delete it',
                          ),
                        ],
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            Format.formatDateTime(message.timestamp.toInt()),
                          ),
                        ),
                      ],
                    ),
                    trailing: Column(
                      children: [
                        if (message.fromRole == ROLE_STAFF)
                        CupertinoSwitch(
                          value: message.authFlag,
                          onChanged: (flag) async {
                            await _getAuthorizations(message);
                            _changeAuthorization(message, flag);
                          }
                        ),
                        if (message.fromRole == ROLE_VENUE)
                        IconButton(
                          icon: Icon(Icons.calendar_today),
                          onPressed: () async {
                            await _getAuthorizations(message);
                            _changeAuthorization(message, true);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            });
      },
    );
  }

  void _changeAuthorization(UserMessage message, bool flag) async {
    setState(() {
      message.authFlag = flag;
    });
    List<dynamic> authorizedIntDates = authorizations.authorizedDates[message.fromUid] ?? [];
    if (flag && message.fromRole == ROLE_VENUE) {
      final authorizedDates = await Navigator.of(context).push(
        MaterialPageRoute<List<DateTime>>(
          fullscreenDialog: false,
          builder: (context) =>
              AuthorizedDates(
                authorizedIntDates: authorizedIntDates,
              ),
        ),
      );
      print('$authorizedDates');
      if (authorizedDates != null) {
        authorizedIntDates.clear();
        authorizedDates.forEach((date) {
          authorizedIntDates.add(date.millisecondsSinceEpoch);
        });
      }
    }
    if (flag) {
      authorizations.authorizedRoles
          .putIfAbsent(message.fromUid, () => message.fromRole);
      authorizations.authorizedNames
          .putIfAbsent(message.fromUid, () => message.fromName);
      if (authorizations.authorizedDates.containsKey(message.fromUid)) {
        authorizations.authorizedDates.update(message.fromUid, (value) => authorizedIntDates);
      } else {
        authorizations.authorizedDates
            .putIfAbsent(message.fromUid, () => authorizedIntDates);
      }
    } else {
      if (message.fromRole == ROLE_STAFF) {
        authorizations.authorizedRoles.remove(message.fromUid);
        authorizations.authorizedNames.remove(message.fromUid);
        authorizations.authorizedDates.remove(message.fromUid);
      }
    }
    database.setAuthorization(message.restaurantId, authorizations);
    UserMessage readMessage = UserMessage(
        id: message.id,
        timestamp: message.timestamp,
        fromUid: message.fromUid,
        toUid: message.toUid,
        restaurantId: message.restaurantId,
        fromRole: message.fromRole,
        toRole: message.toRole,
        fromName: message.fromName,
        type: message.type,
        authFlag: message.authFlag,
        delivered: true,
        attendedFlag: true
    );
    database.setMessageDetails(readMessage);
    setState(() {
      session.pendingStaffAuthorizations--;
    });
  }

  @override
  Widget build(BuildContext context) {
    session = Provider.of<Session>(context);
    database = Provider.of<Database>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Restaurant Access',
          style: TextStyle(color: Theme.of(context).appBarTheme.color),
        ),
      ),
      body: _buildContents(context),
    );
  }
}
