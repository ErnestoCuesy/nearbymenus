import 'package:flutter/material.dart';
import 'package:nearbymenus/app/common_widgets/form_submit_button.dart';
import 'package:nearbymenus/app/common_widgets/platform_alert_dialog.dart';
import 'package:nearbymenus/app/config/flavour_config.dart';
import 'package:nearbymenus/app/models/user_details.dart';
import 'package:nearbymenus/app/pages/welcome/role_selection_page.dart';
import 'package:nearbymenus/app/services/database.dart';
import 'package:nearbymenus/app/services/session_manager.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatelessWidget {
  Future<void> _signOut(BuildContext context) async {
    final sessionManager = Provider.of<SessionManager>(context);
    final database = Provider.of<Database>(context);
    try {
      sessionManager.signOut();
      database.setUserDetails(sessionManager.userDetails);
      // final auth = Provider.of<AuthBase>(context);
      await sessionManager.auth.signOut();
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

  List<Widget> _buildContents(BuildContext context, UserDetails userDetails) {
    return [
      SizedBox(height: 8.0),
      Text(
        userDetails.userName,
        style: Theme.of(context).primaryTextTheme.headline,
      ),
      SizedBox(
        height: 8.0,
      ),
      Text(
        userDetails.userAddress,
        style: Theme.of(context).primaryTextTheme.body1,
      ),
      SizedBox(
        height: 8.0,
      ),
      Text(
        userDetails.userLocation,
        style: Theme.of(context).primaryTextTheme.body1,
      ),
      SizedBox(
        height: 8.0,
      ),
      Text(
        userDetails.userRole,
        style: Theme.of(context).primaryTextTheme.body1,
      ),
      SizedBox(
        height: 8.0,
      ),
      Text(
        userDetails.userDeviceName,
        style: Theme.of(context).primaryTextTheme.body1,
      ),
      SizedBox(
        height: 8.0,
      ),
      FormSubmitButton(
        context: context,
        text: 'Change Role',
        color: Theme.of(context).primaryColor,
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              final sessionManager = Provider.of<SessionManager>(context);
              UserDetails userDetails = sessionManager.userDetails;
              final database = Provider.of<Database>(context);
              return RoleSelectionPage(
                userDetails: userDetails,
                database: database,
              );
            }
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final sessionManager = Provider.of<SessionManager>(context);
    UserDetails userDetails = sessionManager.userDetails;
    var accountText = 'Account Details';
    return Scaffold(
      appBar: AppBar(
        title: Text(
          FlavourConfig.isProduction() ? accountText : accountText + ' [DEV]',
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: _buildContents(context, userDetails),
          ),
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    );
  }
}
// TODO store user name and address in Firebase.
// TODO Display here along with subscription status
