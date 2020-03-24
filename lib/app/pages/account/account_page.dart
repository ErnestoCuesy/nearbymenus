import 'package:flutter/material.dart';
import 'package:nearbymenus/app/common_widgets/form_submit_button.dart';
import 'package:nearbymenus/app/common_widgets/platform_alert_dialog.dart';
import 'package:nearbymenus/app/config/flavour_config.dart';
import 'package:nearbymenus/app/pages/session/restaurant_query.dart';
import 'package:nearbymenus/app/pages/session/role_selection_page.dart';
import 'package:nearbymenus/app/pages/session/user_details_form.dart';
import 'package:nearbymenus/app/services/auth.dart';
import 'package:nearbymenus/app/services/database.dart';
import 'package:nearbymenus/app/services/session.dart';

class AccountPage extends StatefulWidget {
  final AuthBase auth;
  final Session session;
  final Database database;

  const AccountPage({Key key, this.auth, this.session, this.database})
      : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  Auth get auth => widget.auth;
  Session get session => widget.session;
  Database get database => widget.database;

  Future<void> _signOut() async {
    try {
      session.signOut();
      database.setUserDetails(session.userDetails);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut() async {
    final didRequestSignOut = await PlatformAlertDialog(
      title: 'Logout',
      content: 'Are you sure you want to logout?',
      cancelActionText: 'Cancel',
      defaultActionText: 'Logout',
    ).show(context);
    if (didRequestSignOut == true) {
      _signOut();
    }
  }

  List<Widget> _buildContents() {
    return [
      SizedBox(height: 8.0),
      Text(
        'Closest restaurant',
        style: Theme.of(context).primaryTextTheme.headline,
      ),
      SizedBox(
        height: 8.0,
      ),
      Text(
        session.userDetails.nearestRestaurant,
        style: Theme.of(context).primaryTextTheme.body1,
      ),
      SizedBox(
        height: 8.0,
      ),
      FormSubmitButton(
        context: context,
        text: 'Change Restaurant',
        color: Theme.of(context).primaryColor,
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (BuildContext context) {
            return RestaurantQuery();
          }),
        ),
      ),
      SizedBox(
        height: 16.0,
      ),
      Text(
        'Name and address',
        style: Theme.of(context).primaryTextTheme.headline,
      ),
      SizedBox(
        height: 8.0,
      ),
      Text(
        session.userDetails.name,
        style: Theme.of(context).primaryTextTheme.body1,
      ),
      SizedBox(
        height: 8.0,
      ),
      Text(
        session.userDetails.address,
        style: Theme.of(context).primaryTextTheme.body1,
      ),
      SizedBox(
        height: 8.0,
      ),
      Text(
        session.userDetails.complexName,
        style: Theme.of(context).primaryTextTheme.body1,
      ),
      SizedBox(
        height: 16.0,
      ),
      FormSubmitButton(
        context: context,
        text: 'Change Name and Address',
        color: Theme.of(context).primaryColor,
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (BuildContext context) {
            return Scaffold(
              appBar: AppBar(
                title: Text('Enter new user details', style: TextStyle(color: Theme.of(context).appBarTheme.color),),
                elevation: 2.0,
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    child: UserDetailsForm.create(context),
                  ),
                ),
              ),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            );
          }),
        ),
      ),
      SizedBox(
        height: 16.0,
      ),
      Text(
        'Current role',
        style: Theme.of(context).primaryTextTheme.headline,
      ),
      SizedBox(
        height: 8.0,
      ),
      Text(
        session.userDetails.role,
        style: Theme.of(context).primaryTextTheme.body1,
      ),
      SizedBox(
        height: 16.0,
      ),
      FormSubmitButton(
        context: context,
        text: 'Change Role',
        color: Theme.of(context).primaryColor,
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (BuildContext context) {
            return RoleSelectionPage();
          }),
        ),
      ),
      SizedBox(
        height: 16.0,
      ),
      Text(
        'Current device:',
        style: Theme.of(context).primaryTextTheme.headline,
      ),
      SizedBox(
        height: 8.0,
      ),
      Text(
        session.userDetails.deviceName,
        style: Theme.of(context).primaryTextTheme.body1,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
//    auth = Provider.of<Auth>(context);
//    sessionManager = Provider.of<Session>(context);
//    database = Provider.of<Database>(context);
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
            onPressed: () => _confirmSignOut(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: _buildContents(),
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    );
  }
}
// TODO store user name and address in Firebase.
// TODO Display here along with subscription status
