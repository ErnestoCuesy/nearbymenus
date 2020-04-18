import 'package:flutter/material.dart';
import 'package:nearbymenus/app/common_widgets/platform_progress_indicator.dart';
import 'package:nearbymenus/app/models/authorizations.dart';
import 'package:nearbymenus/app/models/session.dart';
import 'package:nearbymenus/app/models/user_details.dart';
import 'package:nearbymenus/app/pages/home/home_page_staff.dart';
import 'package:nearbymenus/app/services/database.dart';
import 'package:provider/provider.dart';

class CheckStaffAuthorization extends StatefulWidget {
  @override
  _CheckStaffAuthorizationState createState() => _CheckStaffAuthorizationState();
}

class _CheckStaffAuthorizationState extends State<CheckStaffAuthorization> {
  Session session;
  Database database;

  @override
  Widget build(BuildContext context) {
    session = Provider.of<Session>(context);
    database = Provider.of<Database>(context, listen: true);
    session.restaurantAccessGranted = false;
    return StreamBuilder<Authorizations>(
      stream: database.authorizationsStream(session.userDetails.nearestRestaurantId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: PlatformProgressIndicator(),
            ),
          );
        }
        if (snapshot.hasData) {
          final Authorizations authorizations = snapshot.data;
          if (authorizations.authorizedRoles[database.userId] == 'Staff') {
            session.restaurantAccessGranted = true;
          }
        }
        return HomePageStaff(role: ROLE_STAFF);
      }
    );
  }
}
