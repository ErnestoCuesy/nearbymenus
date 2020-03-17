import 'package:flutter/material.dart';
import 'package:nearbymenus/app/config/flavour_banner.dart';
import 'package:nearbymenus/app/pages/sign_in/sign_in_page.dart';
import 'package:nearbymenus/app/pages/welcome/role_landing_page.dart';
import 'package:nearbymenus/app/services/auth.dart';
import 'package:nearbymenus/app/services/database.dart';
import 'package:nearbymenus/app/services/session_manager.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sessionManager = Provider.of<SessionManager>(context, listen: true);
    return FlavourBanner(
      child: StreamBuilder<User>(
        stream: sessionManager.auth.onAuthStateChanged,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            User user = snapshot.data;
            if (user == null || user.isEmailVerified == false) {
              return SignInPage();
            }
            return Provider<User>.value(
              value: user,
              child: Provider<Database>(
                  create: (_) => FirestoreDatabase(uid: user.uid),
                  child: RoleLandingPage()),
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
