import 'package:flutter/material.dart';
import 'package:nearbymenus/app/common_widgets/custom_raised_button.dart';
import 'package:nearbymenus/app/models/session.dart';
import 'package:nearbymenus/app/pages/menu_browser/expandable_menu_browser.dart';
import 'package:nearbymenus/app/pages/orders/order_history.dart';
import 'package:provider/provider.dart';

class MenuAndOrders extends StatefulWidget {

  @override
  _MenuAndOrdersState createState() =>
      _MenuAndOrdersState();
}

class _MenuAndOrdersState extends State<MenuAndOrders> {
  Session session;

  void _expandableMenuBrowserPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: false,
        builder: (context) => ExpandableMenuBrowser(),
      ),
    );
  }

  void _orderHistoryPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: false,
        builder: (context) => OrderHistory(showBlocked: false,),
      ),
    );
  }

  List<Widget> _buildContents(BuildContext context) {
    return [
      Text(
          '${session.currentRestaurant.name}',
          style: Theme.of(context).primaryTextTheme.headline4
      ),
      SizedBox(
        height: 32.0,
      ),
      CustomRaisedButton(
        height: 150.0,
        width: 250.0,
        color: Theme.of(context).buttonTheme.colorScheme.surface,
        onPressed: () => _expandableMenuBrowserPage(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Menu',
              style: Theme.of(context).accentTextTheme.headline6,
            ),
            SizedBox(height: 16.0,),
            Icon(
              Icons.import_contacts,
              size: 36.0,
            ),
          ],
        ),
      ),
      SizedBox(
        height: 32.0,
      ),
      CustomRaisedButton(
        height: 150.0,
        width: 250.0,
        color: Theme.of(context).buttonTheme.colorScheme.surface,
        onPressed: () => _orderHistoryPage(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Order history',
              style: Theme.of(context).accentTextTheme.headline6,
            ),
            SizedBox(height: 16.0,),
            Icon(
              Icons.update,
              size: 36.0,
            ),
          ],
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    session = Provider.of<Session>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(
            '${session.currentRestaurant.name}',
            style: TextStyle(color: Theme.of(context).appBarTheme.color),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _buildContents(context),
          ),
        ));
  }
}
