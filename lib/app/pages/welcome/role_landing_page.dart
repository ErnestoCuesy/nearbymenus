import 'package:flutter/material.dart';
import 'package:nearbymenus/app/models/user_details.dart';
import 'package:nearbymenus/app/pages/home/home_page.dart';
import 'package:nearbymenus/app/pages/welcome/role_selection_page.dart';
import 'package:nearbymenus/app/pages/welcome/user_details_page.dart';
import 'package:nearbymenus/app/services/database.dart';
import 'package:nearbymenus/app/services/device_info.dart';
import 'package:provider/provider.dart';

class RoleLandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context, listen: true);
    return StreamBuilder<UserDetails>(
      stream: database.userDetailsStream(),
      builder: (context, snapshot) {
        final deviceInfo = Provider.of<DeviceInfo>(context, listen: false);
        if (snapshot.connectionState == ConnectionState.active) {
          UserDetails userDetails = snapshot.data;
          if (userDetails == null) {
            return UserDetailsPage();
          } else {
            if (userDetails.userRole == 'none' ||
                userDetails.userRole == '') {
              return RoleSelectionPage(
                database: database,
                userDetails: userDetails,
              );
            } else {
              if (userDetails.userDeviceName != '' &&
                  userDetails.userDeviceName != deviceInfo.deviceName) {
                return Scaffold(
                  body: Center(
                    child: Text(
                      'User is already logged-in on device:\n${userDetails.userDeviceName}',
                      style: Theme.of(context).textTheme.title,
                    ),
                  ),
                );
              }
            }
          }
          return HomePage(userDetails: userDetails,);
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
