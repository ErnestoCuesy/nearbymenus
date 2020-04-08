import 'package:flutter/material.dart';
import 'package:nearbymenus/app/common_widgets/purchase_button.dart';
import 'package:nearbymenus/app/services/iap_manager.dart';

class UpsellScreen extends StatelessWidget {
  final Subscription subscription;

  const UpsellScreen({Key key, this.subscription}) : super(key: key);

  List<Widget> buildPackages() {
    List<Widget> packages = List<Widget>();
    if (subscription.subscriptionType == SubscriptionType.Unsubscribed) {
      subscription.availableOfferings.forEach((pkg) {
        packages.add(PurchaseButton(
          package: pkg,
        ));
        packages.add(SizedBox(height: 24.0,));
      });
    } else {
      packages.add(Text(
          'Active subscriptions: ${subscription.numberOfActiveSubscriptions}'));
      packages.add(Text('First seen: ${subscription.firstSeen}'));
      packages.add(
          Text('Latest expiration date: ${subscription.latestExpirationDate}'));
    }
    return packages;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            subscription.subscriptionType == SubscriptionType.Unsubscribed
                ? "Available Packages"
                : "Subscription Details",
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: buildPackages(),
          ),
        ));
  }
}
