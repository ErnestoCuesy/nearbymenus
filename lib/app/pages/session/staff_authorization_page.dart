import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nearbymenus/app/common_widgets/platform_exception_alert_dialog.dart';
import 'package:nearbymenus/app/models/restaurant.dart';
import 'package:nearbymenus/app/models/user_message.dart';
import 'package:nearbymenus/app/services/database.dart';
import 'package:nearbymenus/app/models/session.dart';
import 'package:nearbymenus/app/utilities/logo_image_asset.dart';
import 'package:provider/provider.dart';

class StaffAuthorizationPage extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const StaffAuthorizationPage({Key key, this.scaffoldKey,}) : super(key: key);

  @override
  _StaffAuthorizationPageState createState() => _StaffAuthorizationPageState();
}

class _StaffAuthorizationPageState extends State<StaffAuthorizationPage> {
  Session session;
  Database database;
  bool staffRequestPending = false;
  Restaurant get restaurant => session.currentRestaurant;

  List<Widget> _buildAccountDetails(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final imageAsset = Provider.of<LogoImageAsset>(context);
    final staffAccessSubtitle =
        'You are not allowed to access orders';
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
      // STAFF STATUS SECTION
      _userDetailsSection(
        sectionTitle: '${session.currentRestaurant.name} access status',
        cardTitle: staffAccessSubtitle,
        cardSubtitle: restaurantStatusTitle,
        onPressed: session.currentRestaurant.acceptingStaffRequests &&
            !staffRequestPending &&
            !session.restaurantAccessGranted
            ? () => _requestRestaurantAccess(context)
            : null,
      ),
    ];
  }

  Future<void> _requestRestaurantAccess(BuildContext context) async {
    if (session.userDetails.name == null ||
        session.userDetails.name == '') {
        await PlatformExceptionAlertDialog(
            title: 'Empty user name',
            exception: PlatformException(
            code: 'USERNAME_IS_EMPTY',
            message:
            'Please enter your name in the profile page before requesting access.',
            details:
            'Please enter your name in the profile page before requesting access',
        ),
      ).show(context);
    } else {
      final double timestamp = dateFromCurrentDate() / 1.0;
      database.setMessageDetails(UserMessage(
        id: documentIdFromCurrentDate(),
        timestamp: timestamp,
        fromUid: database.userId,
        toUid: session.currentRestaurant.managerId,
        restaurantId: session.currentRestaurant.id,
        fromRole: ROLE_STAFF,
        toRole: ROLE_MANAGER,
        fromName: session.userDetails.name,
        delivered: false,
        type: 'Access to ${session.currentRestaurant.name}',
        authFlag: false,
      ));
      Navigator.of(context).pop();
      widget.scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Access request sent, pending approval... please wait'),
        ),
      );
    }
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
              icon: Icon(Icons.error_outline),
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
    session = Provider.of<Session>(context);
    database = Provider.of<Database>(context);
    var accountText = 'Your access status';
    return Scaffold(
      appBar: AppBar(
        title: Text(
          accountText,
          style: Theme.of(context).primaryTextTheme.headline6,
        ),
      ),
      body: _buildContents(context),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    );
  }
}
