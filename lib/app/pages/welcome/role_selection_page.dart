import 'package:flutter/material.dart';
import 'package:nearbymenus/app/models/user_details.dart';
import 'package:nearbymenus/app/services/database.dart';

class RoleSelectionPage extends StatefulWidget {
  final Database database;
  final UserDetails userDetails;

  const RoleSelectionPage({Key key, this.database, this.userDetails})
      : super(key: key);

  @override
  _RoleSelectionPageState createState() => _RoleSelectionPageState();
}

class _RoleSelectionPageState extends State<RoleSelectionPage> {
  Database get database => widget.database;
  UserDetails get userDetails => widget.userDetails;

  void _changeRole(String role) {
    database.setUserDetails(
      UserDetails(
          userName: userDetails.userName,
          userAddress: userDetails.userAddress,
          userLocation: userDetails.userLocation,
          userRole: role),
    );
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
        icon: Icon(Icons.adb),
        iconSize: 36,
        color: Colors.black,
        onPressed: () => _changeRole('staff'),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
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
