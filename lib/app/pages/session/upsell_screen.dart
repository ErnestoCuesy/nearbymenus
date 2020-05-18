import 'package:flutter/material.dart';
import 'package:nearbymenus/app/common_widgets/purchase_button.dart';
import 'package:nearbymenus/app/models/session.dart';
import 'package:nearbymenus/app/services/database.dart';
import 'package:nearbymenus/app/services/iap_manager.dart';
import 'package:provider/provider.dart';

class UpsellScreen extends StatefulWidget {
  final Database database;
  final Session session;
  final int ordersLeft;
  final int ordersBlocked;

  const UpsellScreen({Key key, this.database, this.session, this.ordersLeft, this.ordersBlocked}) : super(key: key);

  @override
  _UpsellScreenState createState() => _UpsellScreenState();
}

class _UpsellScreenState extends State<UpsellScreen> {
  IAPManagerBase iap;

  Database get database => widget.database;
  Session get session => widget.session;
  int get ordersLeft => widget.ordersLeft;
  int get ordersBlocked => widget.ordersBlocked;

  List<Widget> buildPackages(BuildContext context) {
    print('Orders left: $ordersLeft');
    List<Widget> packages = List<Widget>();
    if (ordersLeft != null) {
      packages.add(Text(
        'Orders left: ${ordersLeft.toString()}',
        style: Theme
            .of(context)
            .textTheme
            .headline4,
      ));
      packages.add(SizedBox(height: 16.0,));
    }
    if (ordersBlocked != null) {
      packages.add(Text(
        'Orders locked: ${widget.ordersBlocked}',
        style: Theme
            .of(context)
            .textTheme
            .headline4,
      ));
      packages.add(SizedBox(height: 16.0,));
    }
    session.subscription.availableOfferings.forEach((pkg) {
      packages.add(PurchaseButton(
        iap: iap,
        database: database,
        package: pkg,
      ));
      packages.add(SizedBox(height: 24.0,));
    });
    return packages;
  }

  @override
  Widget build(BuildContext context) {
    iap = Provider.of<IAPManagerBase>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Buy a bundle to unlock your orders',
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: buildPackages(context),
          ),
        ));
  }
}
