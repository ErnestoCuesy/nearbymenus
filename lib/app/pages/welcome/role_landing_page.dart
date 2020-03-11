import 'package:flutter/material.dart';
import 'package:nearbymenus/app/config/flavour_banner.dart';
import 'package:nearbymenus/app/models/user_details.dart';
import 'package:nearbymenus/app/pages/home/home_page.dart';
import 'package:nearbymenus/app/pages/sign_in/sign_in_page.dart';
import 'package:nearbymenus/app/pages/welcome/role_selection_page.dart';
import 'package:nearbymenus/app/pages/welcome/user_details_page.dart';
import 'package:nearbymenus/app/services/auth.dart';
import 'package:nearbymenus/app/services/database.dart';
import 'package:provider/provider.dart';

class RoleLandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context, listen: true);
    return FlavourBanner(
      child: StreamBuilder<UserDetails>(
        stream: database.userDetailsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            UserDetails userDetails = snapshot.data;
            if (userDetails == null) {
                return UserDetailsPage();
            } else {
              if (userDetails.userRole == 'none' || userDetails.userRole == '') {
                return RoleSelectionPage(database: database, userDetails: userDetails,);
              }
            }
            return HomePage();
          } else {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }
}
