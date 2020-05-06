import 'package:flutter/material.dart';
import 'package:nearbymenus/app/common_widgets/custom_raised_button.dart';
import 'package:nearbymenus/app/models/restaurant.dart';
import 'package:nearbymenus/app/pages/menu_builder/menu/menu_page.dart';
import 'package:nearbymenus/app/pages/option_builder/option/option_page.dart';

class MenusAndOptionsMaintenance extends StatefulWidget {
  final Restaurant restaurant;

  const MenusAndOptionsMaintenance({Key key, this.restaurant}) : super(key: key);

  @override
  _MenusAndOptionsMaintenanceState createState() =>
      _MenusAndOptionsMaintenanceState();
}

class _MenusAndOptionsMaintenanceState
    extends State<MenusAndOptionsMaintenance> {
  List<Widget> _buildContents() {
    return [
      Text(
        '${widget.restaurant.name}',
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
            builder: (BuildContext context) => MenuPage(
              restaurant: widget.restaurant,
            ),
          ),
        ),
        child: Text(
          'Menus Maintenance',
          style: Theme.of(context).accentTextTheme.headline6,
        ),
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
            builder: (BuildContext context) => OptionPage(
              restaurant: widget.restaurant,
            ),
          ),
        ),
        child: Text(
          'Options Maintenance',
          style: Theme.of(context).accentTextTheme.headline6,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Menus and Options Maintenance',
            style: TextStyle(color: Theme.of(context).appBarTheme.color),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _buildContents(),
          ),
        ));
  }
}
