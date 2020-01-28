import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nearbymenus/app/common_widgets/avatar.dart';
import 'package:nearbymenus/app/common_widgets/platform_alert_dialog.dart';
import 'package:nearbymenus/app/services/auth.dart';
import 'package:nearbymenus/app/services/database.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatelessWidget {
  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await PlatformAlertDialog(
      title: 'Logout',
      content: 'Are you sure you want to logout?',
      cancelActionText: 'Cancel',
      defaultActionText: 'Logout',
    ).show(context);
    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }

  _buildContents(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<Database>(context);
    final user = Provider.of<User>(context);
    final environment = db.environment?? '...';
    var accountText = 'Account';
    return Scaffold(
      appBar: AppBar(
        title: Text(
          environment == 'Production'
              ? accountText
              : accountText + ' [$environment]',
          style: TextStyle(color: Theme.of(context).accentColor),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Logout',
              style: TextStyle(
                fontSize: 18.0,
                color: Theme.of(context).accentColor,
              ),
            ),
            onPressed: () => _confirmSignOut(context),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(130),
          child: _buildUserInfo(context, user),
        ),
      ),
      body: _buildContents(context),
      backgroundColor: Theme.of(context).backgroundColor,
    );
  }

  Widget _buildUserInfo(BuildContext context, User user) {
    return Column(
      children: <Widget>[
        Avatar(
          photoUrl: user.photoUrl,
          radius: 50,
        ),
        SizedBox(height: 8.0),
        if (user.displayName != null)
          Text(
            user.displayName,
            style: TextStyle(color: Theme.of(context).accentColor),
          ),
        SizedBox(
          height: 8.0,
        )
      ],
    );
  }
}
