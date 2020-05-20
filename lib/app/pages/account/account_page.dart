import 'package:flutter/material.dart';
import 'package:nearbymenus/app/common_widgets/platform_alert_dialog.dart';
import 'package:nearbymenus/app/common_widgets/platform_progress_indicator.dart';
import 'package:nearbymenus/app/config/flavour_config.dart';
import 'package:nearbymenus/app/models/user_message.dart';
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
  Restaurant restaurant = Restaurant(name: '', restaurantLocation: '', acceptingStaffRequests: false);
  bool restaurantFound = false;

  Auth get auth => widget.auth;
  Session get session => widget.session;
  Database get database => widget.database;
  bool staffRequestPending = false;


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

  List<Widget> _buildAccountDetails(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final imageAsset = Provider.of<LogoImageAsset>(context);
    // TODO restaurant could be null - fix
    final restaurantName = restaurant.name == '' ? '(unknown)' : restaurant.name;
    final staffAccessStatus = session.restaurantAccessGranted ? '' : 'not ';
    final staffAccessSubtitle = 'You are ${staffAccessStatus}allowed to access orders';
    var restaurantStatusTitle = '';
    if (!session.restaurantAccessGranted) {
      restaurantStatusTitle = restaurant.acceptingStaffRequests
          ? 'Tap to request access'
          : 'Restaurant is not accepting staff requests at the moment';
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
      // RESTAURANT
      if (session.userDetails.role == ROLE_PATRON ||
          session.userDetails.role == ROLE_STAFF)
        _restaurantDetailsSection(
          sectionTitle: 'Current restaurant',
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
        _userDetailsSection(
          sectionTitle: 'Your details',
          cardTitle: session.userDetails.name ?? '',
          cardSubtitle: session.userDetails.address == null
              ? 'Address unknown'
              : '${session.userDetails.address} ${restaurant.restaurantLocation}',
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
        cardSubtitle: 'At $restaurantName',
        onPressed: () {
          session.userDetails.role = ROLE_NONE;
          database.setUserDetails(session.userDetails);
        },
      ),
      // TODO in progress subscription details for managers
      // SUBSCRIPTION
      if (session.userDetails.role == ROLE_MANAGER)
        _userDetailsSection(
          sectionTitle: 'Bundle details',
          cardTitle: session.subscription.subscriptionTypeString,
          cardSubtitle:
              'Last purchase was on: ${session.subscription.latestExpirationDate}',
          onPressed: () {
            _ordersLeft().then((value) {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                    fullscreenDialog: false,
                    builder: (context) => UpsellScreen(
                      ordersLeft: value,
                      blockedOrders: null,
                    )
                ),
              );
            });
          },
        ),
      // STAFF STATUS SECTION
      if (session.userDetails.role == ROLE_STAFF && restaurantFound)
        _userDetailsSection(
          sectionTitle: 'Restaurant status',
          cardTitle: staffAccessSubtitle,
          cardSubtitle: restaurantStatusTitle,
          onPressed: session.nearestRestaurant.acceptingStaffRequests &&
              !staffRequestPending &&
              !session.restaurantAccessGranted
              ? () => _requestRestaurantAccess(context)
              : null,
        ),
    ];
  }

  void _requestRestaurantAccess(BuildContext context) {
    final double timestamp = dateFromCurrentDate() / 1.0;
    database.setMessageDetails(UserMessage(
        id: documentIdFromCurrentDate(),
        timestamp: timestamp,
        fromUid: database.userId,
        toUid: session.nearestRestaurant.managerId,
        restaurantId: session.userDetails.nearestRestaurantId,
        fromRole: ROLE_STAFF,
        toRole: ROLE_MANAGER,
        fromName: session.userDetails.name,
        delivered: false,
        type: 'Access to ${session.nearestRestaurant.name}',
        authFlag: false,
    ));
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text('Access request sent, pending approval... please wait'),
      ),
    );
  }

  Future<int> _ordersLeft() async {
    int ordersLeft;
    await database.ordersLeft(database.userId).then((value) {
      if (value != null) {
        ordersLeft = value;
      }
    }).catchError((_) => null);
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
            style: Theme.of(context).primaryTextTheme.headline5,
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
            style: Theme.of(context).primaryTextTheme.headline5,
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
                children: _buildAccountDetails(context),
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
    var accountText = 'Your profile';
    return Scaffold(
      appBar: AppBar(
        title: Text(
          FlavourConfig.isProduction() ? accountText : accountText + ' [DEV]',
          style: Theme.of(context).primaryTextTheme.headline6,
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
