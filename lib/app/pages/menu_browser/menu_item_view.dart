import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:nearbymenus/app/common_widgets/platform_exception_alert_dialog.dart';
import 'package:nearbymenus/app/config/flavour_config.dart';
import 'package:nearbymenus/app/models/session.dart';
import 'package:nearbymenus/app/pages/orders/add_to_order.dart';

class MenuItemView extends StatelessWidget {
  final Session session;
  final Map<dynamic, dynamic> sortedMenuItems;
  final Map<dynamic, dynamic> options;
  final List<dynamic> sortedKeys;
  final String menuName;

  MenuItemView({Key key, this.session, this.sortedMenuItems, this.options, this.sortedKeys, this.menuName}) : super(key: key);

  final f = NumberFormat.simpleCurrency(locale: "en_ZA");
  int get itemCount => sortedMenuItems.length;

  Future<void> _exceptionDialog(BuildContext context, String title, String code, String message) async {
    await PlatformExceptionAlertDialog(
      title: title,
      exception: PlatformException(
        code: code,
        message: message,
        details: message,
      ),
    ).show(context);
  }

  Future<void> _addMenuItemToOrder(BuildContext context, String menuCode, Map<dynamic, dynamic> menuItem) async {
    if (FlavourConfig.isAdmin()) {
      return;
    }
    if (session.currentRestaurant.isOpen || FlavourConfig.isManager()) {
      final result = await Navigator.of(context).push(
        MaterialPageRoute<String>(
          fullscreenDialog: false,
          builder: (context) =>
              AddToOrder.create(
                context: context,
                menuCode: menuCode,
                item: menuItem,
                options: options,
              ),
        ),
      );
      if (result == 'Yes') {
        Scaffold.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text('Item added to the order.'),
            ),
          );
      }
    } else {
      _exceptionDialog(
        context,
        'Restaurant is closed',
        'RESTAURANT_IS_CLOSED',
        '${session.currentRestaurant.name} cannot take your order at this moment. Sorry.',
      );
    }
  }

  String _menuCode(String menuName) {
    RegExp consonantFilter = RegExp(r'([^A|E|I|O|U ])');
    Iterable<Match> matchResult =
    consonantFilter.allMatches(menuName.toUpperCase());
    String result = '';
    for (Match m in matchResult) {
      result = result + m.group(0);
    }
    result = result + '    ';
    return '[' + result.substring(0, 4) + '] ';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          menuName
        ),
      ),
      body: ListView.builder(
        itemCount: itemCount,
        itemBuilder: (BuildContext context, int index) {
          final menuItem = sortedMenuItems[sortedKeys[index]];
          String adjustedName = menuItem['name'];
          if (adjustedName.length > 25) {
            adjustedName = adjustedName.substring(0, 25) + '...(more)';
          }
          String adjustedDescription = menuItem['description'];
          if (adjustedDescription.length > 70) {
            adjustedDescription =
                adjustedDescription.substring(0, 70) + '...(more)';
          }
          return Container(
            height: 90.0,
            decoration: BoxDecoration(
              border: Border.all(
                width: 0.5,
                color: Theme.of(context).primaryColor,
              ),
            ),
            child: ListTile(
              title: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  '$adjustedName',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, top: 8.0, bottom: 8.0),
                child: Text(
                  '$adjustedDescription',
                ),
              ),
              trailing: Text(
                f.format(menuItem['price']),
                style: Theme.of(context).textTheme.headline6,
              ),
              onTap: () =>
                  _addMenuItemToOrder(context, _menuCode(menuName), menuItem),
            ),
          );
        },
      ),
    );
  }
}
