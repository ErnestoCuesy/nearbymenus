import 'package:flutter/material.dart';
import 'package:nearbymenus/app/config/flavour_banner.dart';
import 'package:nearbymenus/app/pages/sign_in/sign_in_page.dart';
import 'package:nearbymenus/app/pages/welcome/welcome_page.dart';
import 'package:nearbymenus/app/services/auth.dart';
import 'package:nearbymenus/app/services/database.dart';
import 'package:nearbymenus/app/services/user_shared_preferences.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: true);
    final userPreferences = Provider.of<UserSharedPreferences>(context, listen: true);
    var userName;
    var userAddress;
    if (userPreferences.preferences != null) {
      userName = userPreferences.preferences.getString('userName');
      userAddress = userPreferences.preferences.getString('userAddress');
    }
    return FlavourBanner(
      child: StreamBuilder<User>(
        stream: auth.onAuthStateChanged,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            User user = snapshot.data;
            if (user == null || user.isEmailVerified == false) {
              return SignInPage.create(context);
            }
            return Provider<User>.value(
              value: user,
              child: Provider<Database>(
                  builder: (_) => FirestoreDatabase(uid: user.uid),
                  child: WelcomePage()),
            );
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
