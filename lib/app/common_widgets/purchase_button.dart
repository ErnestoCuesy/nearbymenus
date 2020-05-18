import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nearbymenus/app/common_widgets/custom_raised_button.dart';
import 'package:nearbymenus/app/common_widgets/platform_exception_alert_dialog.dart';
import 'package:nearbymenus/app/models/bundle.dart';
import 'package:nearbymenus/app/services/database.dart';
import 'package:nearbymenus/app/services/iap_manager.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PurchaseButton extends StatelessWidget {
  final IAPManagerBase iap;
  final Database database;
  final Package package;

  PurchaseButton({Key key, @required this.iap, this.database, this.package}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) => CustomRaisedButton(
        height: 150.0,
        width: 250.0,
        color: Theme.of(context).buttonTheme.colorScheme.background,
        onPressed: () async {
          try {
            iap.purchasePackage(package);
            int testBundles = 5;
            final bundleUpdateDate = documentIdFromCurrentDate();
            await database.setBundleCounterTransaction(database.userId, testBundles);
            database.setBundle(database.userId, Bundle(
                      id: bundleUpdateDate,
                      purchaseDate: bundleUpdateDate,
                      rcInfo: 'RevenueCat stuff',
                      ordersInBundle: testBundles
                    ));
            await PlatformExceptionAlertDialog(
                title: 'Thank you!',
                exception: PlatformException(
                code: 'ORDER_BUNDLED_PURCHASE_SUCCESS',
                message:  'Your purchase was successful. You can unlock your orders.',
                details:  'Your purchase was successful. You can unlock your orders.',
              ),
            ).show(context);
          } catch (e) {
            print(e);
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              "${package.product.description}",
              style: Theme.of(context).accentTextTheme.headline6,
            ),
            Text(
                "Buy - (${package.product.priceString})",
                style: Theme.of(context).accentTextTheme.headline6,
            ),
          ],
        ),
      ),
    );
  }
}
