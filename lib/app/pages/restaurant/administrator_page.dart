import 'package:flutter/material.dart';
import 'package:nearbymenus/app/common_widgets/custom_raised_button.dart';
import 'package:nearbymenus/app/models/restaurant.dart';
import 'package:nearbymenus/app/models/session.dart';
import 'package:nearbymenus/app/pages/menu_browser/expandable_menu_browser.dart';
import 'package:nearbymenus/app/pages/menu_builder/menu/menu_page.dart';
import 'package:nearbymenus/app/pages/option_builder/option/option_page.dart';
import 'package:nearbymenus/app/pages/orders/order_history.dart';
import 'package:provider/provider.dart';

class AdministratorPage extends StatefulWidget {

  @override
  _AdministratorPageState createState() =>
      _AdministratorPageState();
}

class _AdministratorPageState extends State<AdministratorPage> {
  Session session;
  Restaurant get restaurant => session.currentRestaurant;
  double buttonSize = 180.0;

  List<Widget> _buildContents(BuildContext context) {
    return [
      Text(
        '${restaurant.name}',
        style: Theme.of(context).primaryTextTheme.headline4
      ),
      SizedBox(
        height: 32.0,
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
                  Icons.build,
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
      SizedBox(
        height: 8.0,
      ),
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
        height: 8.0,
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
                builder: (BuildContext context) => OrderHistory(showBlocked: false,),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'All orders',
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
                builder: (BuildContext context) => OrderHistory(showBlocked: true,),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Locked orders',
                  style: Theme.of(context).accentTextTheme.headline6,
                ),
                SizedBox(height: 8.0,),
                Icon(
                  Icons.lock,
                  size: 36.0,
                ),
              ],
            ),
          ),
        ],
      ),
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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _buildContents(context),
          ),
        ));
  }
}
