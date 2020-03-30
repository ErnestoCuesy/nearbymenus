import 'package:flutter/material.dart';
import 'package:nearbymenus/app/common_widgets/platform_alert_dialog.dart';
import 'package:nearbymenus/app/config/flavour_config.dart';
import 'package:nearbymenus/app/models/user_details.dart';
import 'package:nearbymenus/app/pages/session/user_details_form.dart';
import 'package:nearbymenus/app/services/auth.dart';
import 'package:nearbymenus/app/services/database.dart';
import 'package:nearbymenus/app/models/session.dart';

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
      // RESTAURANT
      _detailsSection(
        sectionTitle: 'Closest restaurant',
        cardTitle: session.userDetails.nearestRestaurant,
        cardSubtitle: session.userDetails.complexName,
        onPressed: () {
          session.userDetails.nearestRestaurant = '';
          database.setUserDetails(session.userDetails);
        },
      ),
      // NAME AND ADDRESS
      _detailsSection(
        sectionTitle: 'Name and address',
        cardTitle: session.userDetails.name,
        cardSubtitle: session.userDetails.address,
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Change your details',
                style:
                TextStyle(color: Theme.of(context).appBarTheme.color),
              ),
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
        })),
      ),
      // ROLE
      _detailsSection(
        sectionTitle: 'Current role',
        cardTitle: session.userDetails.role,
        cardSubtitle: '',
        onPressed: () {
          session.userDetails.role = ROLE_NONE;
          database.setUserDetails(session.userDetails);
        },
      ),
    ];
  }

  Widget _detailsSection(
      {String sectionTitle,
      String cardTitle,
      String cardSubtitle,
      VoidCallback onPressed}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 8.0),
          child: Text(
            sectionTitle,
            style: Theme.of(context).primaryTextTheme.headline,
          ),
        ),
        SizedBox(
          height: 8.0,
        ),
        Card(
          child: ListTile(
            title: Text(
              cardTitle,
              style: Theme.of(context).primaryTextTheme.body1,
            ),
            subtitle: Text(
              cardSubtitle,
              style: Theme.of(context).primaryTextTheme.body1,
            ),
            trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: onPressed,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: _buildContents(),
          ),
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    );
  }
}
// TODO store user name and address in Firebase.
// TODO Display here along with subscription status
