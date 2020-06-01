import 'package:flutter/material.dart';
import 'package:nearbymenus/app/common_widgets/platform_progress_indicator.dart';
import 'package:nearbymenus/app/pages/landing/landing_page.dart';
import 'package:nearbymenus/app/models/session.dart';
import 'package:nearbymenus/app/services/iap_manager.dart';
import 'package:provider/provider.dart';

class SubscriptionCheck extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final iap = Provider.of<IAPManagerBase>(context, listen: true);
    final session = Provider.of<Session>(context, listen: true);
    return StreamBuilder<Subscription>(
      stream: iap.onSubscriptionChanged,
      builder: (context, snapshot) {
        Subscription subscription;
        if (snapshot.connectionState == ConnectionState.active) {
          session.setSubscription(snapshot.data);
          if (snapshot.hasData) {
            subscription = snapshot.data;
            session.subscription = subscription;
            print('Subscription data: ${subscription.purchaserInfo.allPurchaseDates}');
          }
          return LandingPage();
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
