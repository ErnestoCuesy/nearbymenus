import 'package:flutter/material.dart';
import 'package:nearbymenus/app/common_widgets/platform_progress_indicator.dart';
import 'package:nearbymenus/app/models/bundle.dart';
import 'package:nearbymenus/app/pages/home/home_page_manager.dart';
import 'package:nearbymenus/app/models/session.dart';
import 'package:nearbymenus/app/pages/messages/messages_listener.dart';
import 'package:nearbymenus/app/services/database.dart';
import 'package:nearbymenus/app/services/iap_manager.dart';
import 'package:provider/provider.dart';

class SubscriptionCheck extends StatelessWidget {

  Future<void> _setBundleAndUnlock(Database database, List<Bundle> bundleSnapshot, Map<String, dynamic> allPurchasesDates) async {
    bundleSnapshot.forEach((bundle) {
      allPurchasesDates.removeWhere((key, value) => value == bundle.id);
    });
    String bundleDate;
    String bundleCode;
    int ordersInBundle = 0;
    allPurchasesDates.forEach((key, value) async {
      bundleCode = key;
      bundleDate = value;
      switch (bundleCode) {
        case 'in_app_mp0':
          ordersInBundle += 50;
          break;
        case 'in_app_mp1':
          ordersInBundle += 100;
          break;
        case 'in_app_mp2':
          ordersInBundle += 500;
          break;
        case 'in_app_mp3':
          ordersInBundle += 1000;
          break;
      }
      try {
        database.setBundle(database.userId, Bundle(
          id: bundleDate,
          bundleCode: bundleCode,
          ordersInBundle: ordersInBundle,
        ));
      } catch (e) {
        print('DB Bundle set and unlock failed: $e');
      }
    });
    if (ordersInBundle > 0) {
      await database.setBundleCounterTransaction(
          database.userId, ordersInBundle);
    }
  }

  @override
  Widget build(BuildContext context) {
    final iap = Provider.of<IAPManagerBase>(context, listen: true);
    final session = Provider.of<Session>(context, listen: true);
    final database = Provider.of<Database>(context, listen: true);
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
          return FutureBuilder<List<Bundle>>(
              future: database.bundlesSnapshot(database.userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.waiting &&
                    snapshot.hasData) {
                  _setBundleAndUnlock(database, snapshot.data,
                      session.subscription.purchaserInfo.allPurchaseDates);
                  return MessagesListener(page: HomePageManager());
                } else {
                  return Scaffold(
                    body: Center(
                      child: PlatformProgressIndicator(),
                    ),
                  );
                }
              });
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
