import 'package:flutter/material.dart';
import 'package:nearbymenus/app/common_widgets/platform_progress_indicator.dart';
import 'package:nearbymenus/app/pages/session/new_session_control.dart';
import 'package:nearbymenus/app/pages/sign_in/sign_in_page.dart';
import 'package:nearbymenus/app/services/auth.dart';
import 'package:nearbymenus/app/services/database.dart';
import 'package:nearbymenus/app/models/session.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {

  void _setUser(Database database, Session session, UserAuth user) async {
    database.setUserId(user.uid);
    await database.userDetailsSnapshot(user.uid).then((value) {
      if (value.email == null || value.email == '') {
        database.setUserDetails(session.userDetails);
      } else {
        session.userDetails = value;
      }
    });
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
            return SignInPage();
          }
          _setUser(database, session, user);
          return NewSessionControl();
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
