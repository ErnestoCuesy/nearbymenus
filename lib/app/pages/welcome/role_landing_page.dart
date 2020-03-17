import 'package:flutter/material.dart';
import 'package:nearbymenus/app/models/user_details.dart';
import 'package:nearbymenus/app/pages/home/home_page_admin.dart';
import 'package:nearbymenus/app/pages/home/home_page_dev.dart';
import 'package:nearbymenus/app/pages/home/home_page_patron.dart';
import 'package:nearbymenus/app/pages/home/home_page_staff.dart';
import 'package:nearbymenus/app/pages/welcome/already_logged_in_page.dart';
import 'package:nearbymenus/app/pages/welcome/role_selection_page.dart';
import 'package:nearbymenus/app/pages/welcome/user_details_page.dart';
import 'package:nearbymenus/app/services/database.dart';
import 'package:nearbymenus/app/services/session_manager.dart';
import 'package:provider/provider.dart';

class RoleLandingPage extends StatelessWidget {

  void _setUserDetails(SessionManager sessionManager, Database database, UserDetails userDetails) {
    database.setUserDetails(userDetails);
    sessionManager.setUserDetails(userDetails);
  }

  @override
  Widget build(BuildContext context) {
    final sessionManager = Provider.of<SessionManager>(context);
    final database = Provider.of<Database>(context, listen: true);
    return StreamBuilder<UserDetails>(
      stream: database.userDetailsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          UserDetails userDetails = snapshot.data;
          if (userDetails == null) {
            return UserDetailsPage();
          } else {
            if (userDetails.userRole == 'none' || userDetails.userRole == '') {
              return RoleSelectionPage(
                database: database,
                userDetails: userDetails,
              );
            } else {
              if (userDetails.userDeviceName != '' &&
                  userDetails.userDeviceName != sessionManager.deviceInfo.deviceName) {
                return AlreadyLoggedIn(
                  userDetails: userDetails,
                );
              }
            }
          }
          userDetails.userDeviceName = sessionManager.deviceInfo.deviceName;
          _setUserDetails(sessionManager, database, userDetails);
          Widget home;
          switch (userDetails.userRole) {
            case 'admin': {
              home = HomePageAdmin(userDetails: userDetails);
              break;
            }
            case 'staff': {
              home = HomePageStaff(userDetails: userDetails);
              break;
            }
            case 'patron': {
              home = HomePagePatron(userDetails: userDetails);
              break;
            }
            case 'dev': {
              home = HomePageDev(userDetails: userDetails);
              break;
            }
          }
          return home;
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
