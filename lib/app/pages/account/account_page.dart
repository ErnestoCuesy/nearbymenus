import 'package:flutter/material.dart';
import 'package:nearbymenus/app/common_widgets/platform_alert_dialog.dart';
import 'package:nearbymenus/app/common_widgets/platform_progress_indicator.dart';
import 'package:nearbymenus/app/config/flavour_config.dart';
import 'package:nearbymenus/app/models/restaurant.dart';
import 'package:nearbymenus/app/models/user_details.dart';
import 'package:nearbymenus/app/pages/session/restaurant_list_tile.dart';
import 'package:nearbymenus/app/pages/session/upsell_screen.dart';
import 'package:nearbymenus/app/pages/session/user_details_form.dart';
import 'package:nearbymenus/app/services/auth.dart';
import 'package:nearbymenus/app/services/database.dart';
import 'package:nearbymenus/app/models/session.dart';
import 'package:nearbymenus/app/utilities/logo_image_asset.dart';
import 'package:provider/provider.dart';

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
  Restaurant restaurant = Restaurant(name: '', restaurantLocation: '');
  bool restaurantFound = false;

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

  List<Widget> _buildAccountDetails() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final imageAsset = Provider.of<LogoImageAsset>(context);
    final nameAndAddressTitle = restaurant.restaurantLocation != '' ? 'at ' + restaurant.restaurantLocation : '';
    return [
      Container(
        width: screenWidth / 4,
        height: screenHeight / 4,
        child: imageAsset.image,
      ),
      SizedBox(
        height: 16.0,
      ),
      // RESTAURANT
      if (session.userDetails.role == ROLE_PATRON ||
          session.userDetails.role == ROLE_STAFF)
        _restaurantDetailsSection(
          sectionTitle: 'Restaurant details',
          restaurantListTile: RestaurantListTile(
            restaurant: restaurant,
            restaurantFound: restaurantFound,
          ),
          onPressed: () {
            session.userDetails.nearestRestaurantId = '';
            database.setUserDetails(session.userDetails);
          },
        ),
      // NAME AND ADDRESS
      if (session.userDetails.role == ROLE_PATRON)
        _userDetailsSection(
          sectionTitle: 'Name and address $nameAndAddressTitle',
          cardTitle: session.userDetails.name ?? '',
          cardSubtitle: session.userDetails.address ?? 'Address unknown',
          onPressed: () => Navigator.of(context)
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
                    child: UserDetailsForm.create(context),
                  ),
                ),
              ),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            );
          })),
        ),
      // ROLE
      _userDetailsSection(
        sectionTitle: 'Current role',
        cardTitle: session.userDetails.role,
        cardSubtitle: '',
        onPressed: () {
          session.userDetails.role = ROLE_NONE;
          database.setUserDetails(session.userDetails);
        },
      ),
      // TODO in progress subscription details for managers
      // SUBSCRIPTION
      if (session.userDetails.role == ROLE_MANAGER)
        _subscriptionDetailsSection(
          sectionTitle: 'Subscription details',
          cardTitle: session.subscription.subscriptionTypeString,
          cardSubtitle:
              'Expired on: ${session.subscription.latestExpirationDate}',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    UpsellScreen(subscription: session.subscription),
              ),
            );
          },
        ),
    ];
  }

  Widget _subscriptionDetailsSection(
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
            ),
            subtitle: Text(
              cardSubtitle,
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

  Widget _restaurantDetailsSection(
      {String sectionTitle,
      RestaurantListTile restaurantListTile,
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
            title: restaurantListTile,
            trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: onPressed,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContents(BuildContext context) {
    return StreamBuilder<List<Restaurant>>(
      stream: database.userRestaurant(session.userDetails.nearestRestaurantId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData && snapshot.data.length > 0) {
            restaurant = snapshot.data.elementAt(0);
            session.nearestRestaurant = restaurant;
            restaurantFound = true;
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: _buildAccountDetails(),
              ),
            ),
          );
        } else {
          return Center(
            child: PlatformProgressIndicator(),
          );
        }
      },
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
      body: _buildContents(context),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    );
  }
}
