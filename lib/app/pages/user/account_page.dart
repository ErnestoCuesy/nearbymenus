import 'package:flutter/material.dart';
import 'package:nearbymenus/app/common_widgets/platform_alert_dialog.dart';
import 'package:nearbymenus/app/common_widgets/platform_progress_indicator.dart';
import 'package:nearbymenus/app/config/flavour_config.dart';
import 'package:nearbymenus/app/models/bundle.dart';
import 'package:nearbymenus/app/models/restaurant.dart';
import 'package:nearbymenus/app/models/user_details.dart';
import 'package:nearbymenus/app/pages/orders/locked_orders.dart';
import 'package:nearbymenus/app/pages/user/upsell_screen.dart';
import 'package:nearbymenus/app/pages/user/user_details_form.dart';
import 'package:nearbymenus/app/services/auth.dart';
import 'package:nearbymenus/app/services/database.dart';
import 'package:nearbymenus/app/models/session.dart';
import 'package:nearbymenus/app/utilities/logo_image_asset.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatefulWidget {

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  AuthBase auth;
  Session session;
  Database database;
  Restaurant restaurant = Restaurant(
      name: '', address1: '', acceptingStaffRequests: false);
  int _ordersLeft = 0;
  String _lastBundlePurchase = '';
  bool isAnonymousUser = false;

  Future<void> _signOut() async {
    try {
      session.userDetails.orderOnHold = null;
      session.currentOrder = null;
      database.setUserDetails(session.userDetails);
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
      _signOut();
    }
  }

  void _changeDetails(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Change your details',
            style: TextStyle(color: Theme.of(context).appBarTheme.color),
          ),
          elevation: 2.0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              child: UserDetailsForm.create(
                context: context,
                userDetails: session.userDetails,
              ),
            ),
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      );
    }));
  }

  List<Widget> _buildAccountDetails(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final imageAsset = Provider.of<LogoImageAsset>(context);
    String nameEmail = session.userDetails.name;
    if (!isAnonymousUser) {
      nameEmail = nameEmail + ' (${session.userDetails.email})';
    } else {
      nameEmail = 'Anonymous user';
    }
    return [
      Container(
        width: screenWidth / 4,
        height: screenHeight / 4,
        child: imageAsset.image,
      ),
      SizedBox(
        height: 16.0,
      ),
      // NAME AND ADDRESS
      _userDetailsSection(
        sectionTitle: 'Your details',
        cardTitle:
            nameEmail,
        cardSubtitle: session.userDetails.address1 == ''
            ? 'Address unknown'
            : '${session.userDetails.address1}\n'
            '${session.userDetails.address2}\n'
            '${session.userDetails.address3}\n'
            '${session.userDetails.address4}\n'
            '${session.userDetails.telephone}',
        onPressed: isAnonymousUser ? null : () => _changeDetails(context),
      ),
      // SUBSCRIPTION
      if (FlavourConfig.isManager())
        _userDetailsSection(
          sectionTitle: 'Bundle details',
          cardTitle: 'Orders left: $_ordersLeft',
          cardSubtitle:
              'Last purchase was on: $_lastBundlePurchase',
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                  fullscreenDialog: false,
                  builder: (context) => UpsellScreen(
                        ordersLeft: _ordersLeft,
                        blockedOrders: null,
                      ),
              ),
            );
          },
        ),
      if (FlavourConfig.isManager())
        _userDetailsSection(
          sectionTitle: 'Locked orders',
          cardTitle: 'Tap to see and unlock orders across all your restaurants',
          cardSubtitle: '',
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => LockedOrders(),
            ),
          ),
        ),
    ];
  }

  Future<bool> _checkAnonymous() async {
    return await auth.currentUser().then((value) => value.isAnonymous);
  }

  Future<int> _loadOrdersLeft() async {
    int ordersLeft;
    try {
      await database.ordersLeft(database.userId).then((value) {
        if (value != null) {
          ordersLeft = value;
        }
      });
    } catch (e) {
      print(e);
      ordersLeft = 0;
    }
    print('Orders left: $ordersLeft');
    return ordersLeft;
  }

  Widget _userDetailsSection(
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
            style: Theme.of(context).accentTextTheme.headline5,
          ),
        ),
        SizedBox(
          height: 8.0,
        ),
        Card(
          child: ListTile(
            title: Text(
              cardTitle,
            ),
            subtitle: Text(
              cardSubtitle,
            ),
            trailing: IconButton(
              icon: Icon(isAnonymousUser ? null : Icons.arrow_forward),
              onPressed: onPressed,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContents(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: _buildAccountDetails(context),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    auth = Provider.of<AuthBase>(context);
    session = Provider.of<Session>(context);
    database = Provider.of<Database>(context);
    if (FlavourConfig.isManager()) {
      _loadOrdersLeft().then((value) => _ordersLeft = value ?? 0);
    }
    _checkAnonymous().then((value) => isAnonymousUser = value);
    var accountText = 'Your profile';
    return Scaffold(
      appBar: AppBar(
        title: Text(
          accountText,
          style: Theme.of(context).primaryTextTheme.headline6,
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
      body: StreamBuilder<UserDetails>(
        stream: database.userDetailsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.active || !snapshot.hasData) {
            return Center(child: PlatformProgressIndicator());
          } else {
            session.userDetails = snapshot.data;
            if (FlavourConfig.isManager()) {
              _lastBundlePurchase = '\nYou haven\'t bought any bundles';
              return FutureBuilder<List<Bundle>>(
                  future: database.bundlesSnapshot(database.userId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.waiting &&
                        snapshot.hasData) {
                      if (snapshot.data.length > 0) {
                        final bundles = snapshot.data;
                        bundles.removeWhere((element) => element.id == null);
                        bundles.sort((a, b) => b.id.compareTo(a.id));
                        if (bundles.length > 0) {
                          _lastBundlePurchase = '\n' + bundles[0].id;
                        }
                      }
                      return _buildContents(context);
                    } else {
                      return Center(child: PlatformProgressIndicator());
                    }
                  });
            } else {
              return _buildContents(context);
            }
          }
        }
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    );
  }
}
