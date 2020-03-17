import 'package:flutter/material.dart';
import 'package:nearbymenus/app/models/user_details.dart';

class AlreadyLoggedIn extends StatelessWidget {
  const AlreadyLoggedIn({
    Key key,
    @required this.userDetails,
  }) : super(key: key);

  final UserDetails userDetails;

  @override
  Widget build(BuildContext context) {
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
