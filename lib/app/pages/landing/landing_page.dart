import 'package:flutter/material.dart';
import 'package:nearbymenus/app/common_widgets/platform_progress_indicator.dart';
import 'package:nearbymenus/app/config/flavour_config.dart';
import 'package:nearbymenus/app/models/user_details.dart';
import 'package:nearbymenus/app/pages/home/home_page_staff_and_patron.dart';
import 'package:nearbymenus/app/pages/landing/check_purchases.dart';
import 'package:nearbymenus/app/pages/sign_in/sign_in_page.dart';
import 'package:nearbymenus/app/services/auth.dart';
import 'package:nearbymenus/app/services/database.dart';
import 'package:nearbymenus/app/models/session.dart';
import 'package:nearbymenus/app/services/iap_manager.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {

  void _setUser(Database database, Session session, UserAuth user) async {
    database.setUserId(user.uid);
    String role = ROLE_PATRON;
    if (FlavourConfig.isManager()) {
      role = ROLE_MANAGER;
    } else if (FlavourConfig.isStaff()) {
      role = ROLE_STAFF;
    }
    session.userDetails.role = role;
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: true);
    final database = Provider.of<Database>(context, listen: true);
    final session = Provider.of<Session>(context, listen: true);
    print('Landing page user coord: ${session.position.toString()}');
    return StreamBuilder<UserAuth>(
      stream: auth.onAuthStateChanged,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          UserAuth user = snapshot.data;
          if (user == null) {
            if (FlavourConfig.isPatron()) {
              return SignInPage(allowAnonymousSignIn: true,);
            } else {
              return SignInPage(allowAnonymousSignIn: false,);
            }
          }
          _setUser(database, session, user);
          return FutureBuilder<UserDetails>(
            future: database.userDetailsSnapshot(user.uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                final userDetails = snapshot.data;
                if (!user.isAnonymous) {
                  if (userDetails.email == null || userDetails.email == '' ||
                      userDetails.role == null || userDetails.role == '') {
                    database.setUserDetails(session.userDetails);
                  } else {
                    session.userDetails = userDetails;
                  }
                }
                if (FlavourConfig.isManager()) {
                  return Provider<IAPManagerBase>(
                    create: (context) =>
                        IAPManager(userID: session.userDetails.email),
                    child: CheckPurchases(),
                  );
                } else {
                  return HomePageStaffAndPatron();
                }
              } else {
                return Scaffold(
                  body: Center(
                    child: PlatformProgressIndicator(),
                  ),
                );
              }
            },
          );
        } else {
          return Scaffold(
            body: Center(
              child: PlatformProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
