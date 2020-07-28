import 'package:flutter/material.dart';
import 'package:nearbymenus/app/common_widgets/custom_raised_button.dart';
import 'package:nearbymenus/app/config/flavour_config.dart';
import 'package:nearbymenus/app/models/restaurant.dart';
import 'package:nearbymenus/app/models/session.dart';
import 'package:nearbymenus/app/pages/images/item_image_page.dart';
import 'package:nearbymenus/app/pages/menu_browser/expandable_menu_browser.dart';
import 'package:nearbymenus/app/pages/menu_builder/menu/menu_page.dart';
import 'package:nearbymenus/app/pages/option_builder/option/option_page.dart';
import 'package:nearbymenus/app/pages/orders/active_orders.dart';
import 'package:nearbymenus/app/pages/orders/inactive_orders.dart';
import 'package:nearbymenus/app/pages/orders/order_totals.dart';
import 'package:provider/provider.dart';

class RestaurantAdministratorPage extends StatefulWidget {

  @override
  _RestaurantAdministratorPageState createState() =>
      _RestaurantAdministratorPageState();
}

class _RestaurantAdministratorPageState extends State<RestaurantAdministratorPage> {
  Session session;
  Restaurant get restaurant => session.currentRestaurant;
  double buttonSize = 180.0;

  List<Widget> _buildContents(BuildContext context) {
    return [
      Text(
        '${restaurant.name}',
        style: Theme.of(context).accentTextTheme.headline4
      ),
      SizedBox(
        height: 32.0,
      ),
      if (FlavourConfig.isManager())
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomRaisedButton(
            height: buttonSize,
            width: buttonSize,
            color: Theme.of(context).buttonTheme.colorScheme.surface,
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => MenuPage(),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Menu Builder',
                  style: Theme.of(context).accentTextTheme.headline6,
                ),
                SizedBox(height: 8.0,),
                Icon(
                  Icons.format_list_bulleted,
                  size: 36.0,
                ),
              ],
            ),
          ),
          SizedBox(
            width: 16.0,
          ),
          CustomRaisedButton(
            height: buttonSize,
            width: buttonSize,
            color: Theme.of(context).buttonTheme.colorScheme.surface,
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => OptionPage(),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Option Builder',
                  style: Theme.of(context).accentTextTheme.headline6,
                ),
                SizedBox(height: 8.0,),
                Icon(
                  Icons.check_box,
                  size: 36.0,
                ),
              ],
            ),
          ),
        ],
      ),
      if (FlavourConfig.isManager())
      SizedBox(
        height: 16.0,
      ),
      if (FlavourConfig.isManager())
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomRaisedButton(
            height: buttonSize,
            width: buttonSize,
            color: Theme.of(context).buttonTheme.colorScheme.surface,
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => ExpandableMenuBrowser(),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Menu Browser',
                  style: Theme.of(context).accentTextTheme.headline6,
                ),
                SizedBox(height: 8.0,),
                Icon(
                  Icons.import_contacts,
                  size: 36.0,
                ),
              ],
            ),
          ),
          SizedBox(
            width: 16.0,
          ),
          CustomRaisedButton(
            height: buttonSize,
            width: buttonSize,
            color: Theme.of(context).buttonTheme.colorScheme.surface,
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => ItemImagePage(viewOnly: false,),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Images',
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
        ],
      ),
      if (FlavourConfig.isManager())
      SizedBox(
        height: 16.0,
      ),
      if (FlavourConfig.isManager() || session.userDetails.role == ROLE_STAFF)
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomRaisedButton(
            height: buttonSize,
            width: buttonSize,
            color: Theme.of(context).buttonTheme.colorScheme.surface,
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => ActiveOrders(),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Active Orders',
                  style: Theme.of(context).accentTextTheme.headline6,
                ),
                SizedBox(height: 8.0,),
                Icon(
                  Icons.assignment,
                  size: 36.0,
                ),
              ],
            ),
          ),
          SizedBox(
            width: 16.0,
          ),
          CustomRaisedButton(
            height: buttonSize,
            width: buttonSize,
            color: Theme.of(context).buttonTheme.colorScheme.surface,
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => InactiveOrders(),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Inactive Orders',
                  style: Theme.of(context).accentTextTheme.headline6,
                ),
                SizedBox(height: 8.0,),
                Icon(
                  Icons.assignment,
                  size: 36.0,
                ),
              ],
            ),
          ),
        ],
      ),
    SizedBox(
    height: 16.0,
    ),
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomRaisedButton(
          height: buttonSize,
          width: buttonSize,
          color: Theme.of(context).buttonTheme.colorScheme.surface,
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => OrderTotals(),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Sales',
                style: Theme.of(context).accentTextTheme.headline6,
              ),
              SizedBox(height: 8.0,),
              Icon(
                Icons.attach_money,
                size: 36.0,
              ),
            ],
          ),
        ),
      ]
    )
    ];
  }

  @override
  Widget build(BuildContext context) {
    session = Provider.of<Session>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Administration',
            style: TextStyle(color: Theme.of(context).appBarTheme.color),
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildContents(context),
              ),
            ),
          ),
        ));
  }
}
