import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nearbymenus/app/common_widgets/custom_raised_button.dart';
import 'package:nearbymenus/app/common_widgets/platform_alert_dialog.dart';
import 'package:nearbymenus/app/models/user_details.dart';
import 'package:nearbymenus/app/services/database.dart';
import 'package:nearbymenus/app/services/device_info.dart';
import 'package:provider/provider.dart';

class AlreadyLoggedIn extends StatelessWidget {
  const AlreadyLoggedIn({
    Key key,
    @required this.userDetails, this.database, this.deviceInfo,
  }) : super(key: key);

  final Database database;
  final DeviceInfo deviceInfo;
  final UserDetails userDetails;

  Future<void> _confirmContinue(BuildContext context) async {
    final didRequestSignOut = await PlatformAlertDialog(
      title: 'User will be signed-off from the other device',
      content: 'Are you sure you want to continue?',
      cancelActionText: 'Exit',
      defaultActionText: 'Continue',
    ).show(context);
    if (didRequestSignOut == true) {
      userDetails.deviceName = deviceInfo.deviceName;
      database.setUserDetails(userDetails);
    } else {
      exit(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'User is already signed-in on device:',
              style: Theme.of(context).textTheme.title,
            ),
            SizedBox(
              height: 16.0,
            ),
            Text(
              '${userDetails.deviceName}',
              style: Theme.of(context).textTheme.title,
            ),
            SizedBox(
              height: 16.0,
            ),
            CustomRaisedButton(
              context: context,
              color: Theme.of(context).buttonTheme.colorScheme.background,
              child: Text('Continue with this device'),
              onPressed: () => _confirmContinue(context),
            ),
          ],
        ),
      ),
    );
  }
}
