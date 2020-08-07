import 'package:flutter/material.dart';
import 'package:nearbymenus/app/common_widgets/custom_raised_button.dart';
import 'package:nearbymenus/app/common_widgets/empty_content.dart';
import 'package:nearbymenus/app/common_widgets/platform_progress_indicator.dart';
import 'package:nearbymenus/app/models/restaurant.dart';
import 'package:nearbymenus/app/models/session.dart';
import 'package:nearbymenus/app/pages/images/item_image_page.dart';
import 'package:nearbymenus/app/pages/menu_browser/expandable_menu_browser.dart';
import 'package:nearbymenus/app/pages/orders/active_orders.dart';
import 'package:nearbymenus/app/services/database.dart';
import 'package:provider/provider.dart';

class RestaurantPatronPage extends StatefulWidget {

  @override
  _RestaurantPatronPageState createState() =>
      _RestaurantPatronPageState();
}

class _RestaurantPatronPageState extends State<RestaurantPatronPage> {
  Session session;
  Database database;

  void _expandableMenuBrowserPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: false,
        builder: (context) => session.currentRestaurant.restaurantMenus.isNotEmpty
            ? ExpandableMenuBrowser()
            : Scaffold(
              appBar: AppBar(title: Text(''),),
              body: EmptyContent(
                  title: 'Empty menu',
                  message: 'This restaurant hasn\'t loaded any menus yet',
                ),
            ),
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
    database = Provider.of<Database>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(
            '${session.currentRestaurant.name}',
            style: TextStyle(color: Theme.of(context).appBarTheme.color),
          ),
        ),
        body: StreamBuilder<Restaurant>(
          stream: database.selectedRestaurantStream(session.currentRestaurant.id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: PlatformProgressIndicator());
            } else {
              if (snapshot.hasData) {
                session.currentRestaurant = snapshot.data;
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _buildContents(context),
                  ),
                );
              } else {
                return Placeholder();
              }
            }
          }
        ));
  }
}
