import 'package:flutter/material.dart';
import 'package:nearbymenus/app/models/user_details.dart';
import 'package:nearbymenus/app/services/database.dart';
import 'package:nearbymenus/app/models/session.dart';
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
      _roleContainer(
        width: 200.0,
        height: 200.0,
        icon: Icon(Icons.account_circle),
        roleName: ROLE_PATRON,
        roleDescription: 'Hungry? Browse the restaurant\'s menu and place your order!',
        onPressed: () => _changeRole(ROLE_PATRON),
      ),
      SizedBox(height: 16.0,),
      _roleContainer(
        width: 200.0,
        height: 200.0,
        icon: Icon(Icons.account_circle),
        roleName: ROLE_MANAGER,
        roleDescription: 'Open a restaurant, create menus and manage orders! \n(Requires subscription)',
        // onPressed: () => _changeRole(ROLE_CHECK_SUBSCRIPTION),
        onPressed: () => _changeRole(ROLE_MANAGER),
      ),
      SizedBox(height: 16.0,),
      _roleContainer(
        width: 200.0,
        height: 200.0,
        icon: Icon(Icons.account_circle),
        roleName: ROLE_STAFF,
        roleDescription: 'Request access to the restaurant to manage orders.',
        onPressed: () => _changeRole(ROLE_STAFF),
      ),
    ];
  }

  Widget _roleContainer({Icon icon, String roleName, String roleDescription, VoidCallback onPressed, double height, double width}) {
    return Container(
      width: width,
      height: height,
      child: Card(
        child: Column(
          children: <Widget>[
            IconButton(
              icon: icon,
              iconSize: 36,
              color: Colors.black,
              onPressed: onPressed,
            ),
            Text(roleName, style: Theme.of(context).textTheme.headline6,),
            SizedBox(
              height: 8.0,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                roleDescription,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
          ],
        ),
      ),
    );

  }
  @override
  Widget build(BuildContext context) {
    session = Provider.of<Session>(context);
    database = Provider.of<Database>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Select your role',
          style: TextStyle(color: Theme.of(context).appBarTheme.color),
        ),
        elevation: 2.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
