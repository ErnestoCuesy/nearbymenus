import 'package:flutter/material.dart';
import 'package:nearbymenus/app/models/user_details.dart';
import 'package:nearbymenus/app/pages/session/upsell_screen.dart';
import 'package:nearbymenus/app/services/database.dart';
import 'package:nearbymenus/app/models/session.dart';
import 'package:nearbymenus/app/services/iap_manager.dart';
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
        icon: Icon(Icons.accessibility),
        roleName: ROLE_PATRON,
        roleDescription: 'Hungry? Browse the restaurant\'s menu and place your order!',
        onPressed: () => _changeRole(ROLE_PATRON),
      ),
      SizedBox(height: 16.0,),
      _roleContainer(
        width: 200.0,
        height: 200.0,
        icon: Icon(Icons.account_box),
        roleName: ROLE_MANAGER,
        roleDescription: 'Open a restaurant, create menus and manage orders! \n(Requires subscription)',
        // onPressed: () => _changeRole(ROLE_CHECK_SUBSCRIPTION),
        onPressed: () {
          if (session.subscription.subscriptionType == SubscriptionType.Unsubscribed) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    UpsellScreen(subscription: session.subscription),
              ),
            );
          } else {
            _changeRole(ROLE_MANAGER);
          }
        },
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
//      if (FlavourConfig.isDevelopment())
//      SizedBox(height: 16.0,),
//      if (FlavourConfig.isDevelopment())
//      _roleContainer(
//        width: 125.0,
//        height: 125.0,
//        icon: Icon(Icons.adb),
//        roleName: ROLE_DEV,
//        roleDescription: '',
//        onPressed: () => _changeRole(ROLE_DEV),
//      ),
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
            Text(roleName, style: Theme.of(context).textTheme.title,),
            SizedBox(
              height: 8.0,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                roleDescription,
                style: Theme.of(context).textTheme.body2,
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
