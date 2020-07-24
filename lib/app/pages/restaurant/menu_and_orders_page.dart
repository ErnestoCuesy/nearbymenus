import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nearbymenus/app/common_widgets/custom_raised_button.dart';
import 'package:nearbymenus/app/common_widgets/platform_exception_alert_dialog.dart';
import 'package:nearbymenus/app/models/session.dart';
import 'package:nearbymenus/app/pages/images/item_image_page.dart';
import 'package:nearbymenus/app/pages/menu_browser/expandable_menu_browser.dart';
import 'package:nearbymenus/app/pages/orders/active_orders.dart';
import 'package:provider/provider.dart';

class MenuAndOrdersPage extends StatefulWidget {

  @override
  _MenuAndOrdersPageState createState() =>
      _MenuAndOrdersPageState();
}

class _MenuAndOrdersPageState extends State<MenuAndOrdersPage> {
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
        builder: (context) => ActiveOrders(),
      ),
    );
  }

  Future<void> _checkUserDetails(BuildContext context) async {
    if (session.userDetails.name == null ||
        session.userDetails.name == '' ||
        session.userDetails.address1 == '' ||
        session.userDetails.address2 == '') {
      await PlatformExceptionAlertDialog(
        title: 'No delivery details',
        exception: PlatformException(
          code: 'USERNAME_IS_EMPTY',
          message:
          'Please enter your name and address in the profile page before proceeding.',
          details:
          'Please enter your name and address in the profile page before proceeding',
        ),
      ).show(context);
    } else {
      _expandableMenuBrowserPage(context);
    }
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
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => ItemImagePage(viewOnly: true,),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Food Gallery',
              style: Theme.of(context).accentTextTheme.headline6,
            ),
            SizedBox(height: 8.0,),
            Icon(
              Icons.image,
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
        onPressed: () => _checkUserDetails(context),
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
              'Order History',
              style: Theme.of(context).accentTextTheme.headline6,
            ),
            SizedBox(height: 16.0,),
            Icon(
              Icons.assignment,
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
