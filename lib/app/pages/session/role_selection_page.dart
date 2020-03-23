import 'package:flutter/material.dart';
import 'package:nearbymenus/app/config/flavour_config.dart';
import 'package:nearbymenus/app/services/database.dart';
import 'package:nearbymenus/app/services/session.dart';
import 'package:provider/provider.dart';

class RoleSelectionPage extends StatefulWidget {

  @override
  _RoleSelectionPageState createState() => _RoleSelectionPageState();
}

class _RoleSelectionPageState extends State<RoleSelectionPage> {
  Database database;
  Session session;

  void _changeRole(String role) {
    session.userDetails.role = role;
    database.setUserDetails(session.userDetails);
  }

  List<Widget> _buildChildren(BuildContext context) {
    return [
      Text('Please select your role'),
      SizedBox(height: 16.0,),
      IconButton(
        icon: Icon(Icons.accessibility),
        iconSize: 36,
        color: Colors.black,
        onPressed: () => _changeRole('patron'),
      ),
      SizedBox(height: 16.0,),
      IconButton(
        icon: Icon(Icons.account_box),
        iconSize: 36,
        color: Colors.black,
        onPressed: () => _changeRole('admin'),
      ),
      SizedBox(height: 16.0,),
      IconButton(
        icon: Icon(Icons.account_circle),
        iconSize: 36,
        color: Colors.black,
        onPressed: () => _changeRole('staff'),
      ),
      if (FlavourConfig.isDevelopment())
      SizedBox(height: 16.0,),
      if (FlavourConfig.isDevelopment())
      IconButton(
        icon: Icon(Icons.adb),
        iconSize: 36,
        color: Colors.black,
        onPressed: () => _changeRole('dev'),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    session = Provider.of<Session>(context);
    database = Provider.of<Database>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Welcome to Nearby Menus',
          style: TextStyle(color: Theme.of(context).appBarTheme.color),
        ),
        elevation: 2.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: _buildChildren(context),
            ),
          ),
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    );
  }
}
