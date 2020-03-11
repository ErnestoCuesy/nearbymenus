import 'package:flutter/material.dart';
import 'package:nearbymenus/app/common_widgets/platform_alert_dialog.dart';
import 'package:nearbymenus/app/config/flavour_config.dart';
import 'package:nearbymenus/app/services/auth.dart';
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
    final user = Provider.of<User>(context);
    var accountText = 'Account';
    return Scaffold(
      appBar: AppBar(
        title: Text(
          FlavourConfig.isProduction()
              ? accountText
              : accountText + ' [DEV]',
          style: Theme.of(context).primaryTextTheme.title,
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Logout',
              style: Theme.of(context).primaryTextTheme.button,
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    );
  }

  Widget _buildUserInfo(BuildContext context, User user) {
    return Column(
      children: <Widget>[
        SizedBox(height: 8.0),
        if (user.displayName != null)
          Text(
            user.displayName,
            style: Theme.of(context).primaryTextTheme.body1,
          ),
        SizedBox(
          height: 8.0,
        )
      ],
    );
  }
}
// TODO store user name and address in Firebase.
// TODO Display here along with subscription status
