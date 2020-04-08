import 'package:flutter/material.dart';
import 'package:nearbymenus/app/common_widgets/custom_raised_button.dart';
import 'package:nearbymenus/app/models/session.dart';
import 'package:nearbymenus/app/models/user_details.dart';
import 'package:nearbymenus/app/services/database.dart';
import 'package:nearbymenus/app/services/iap_manager.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PurchaseButton extends StatelessWidget {
  final Package package;

  PurchaseButton({Key key, @required this.package}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final iap = Provider.of<IAPManagerBase>(context, listen: false);
    final database = Provider.of<Database>(context);
    final session = Provider.of<Session>(context);
    return CustomRaisedButton(
      height: 150.0,
      width: 250.0,
      color: Theme.of(context).buttonTheme.colorScheme.background,
      onPressed: () async {
        iap.purchasePackage(package);
        var userDetails = session.userDetails;
        userDetails.role = ROLE_MANAGER;
        database.setUserDetails(userDetails);
        Navigator.of(context).pop();
        // TODO wrap in try/catch for server errors
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text("${package.product.description}", style: Theme.of(context).accentTextTheme.title,),
          Text("Buy - (${package.product.priceString})", style: Theme.of(context).accentTextTheme.title),
        ],
      ),
    );
  }
}
