import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:nearbymenus/app/common_widgets/platform_exception_alert_dialog.dart';
import 'package:nearbymenus/app/models/order.dart';
import 'package:nearbymenus/app/models/restaurant.dart';
import 'package:nearbymenus/app/models/session.dart';
import 'package:nearbymenus/app/pages/menu_browser/expandable_list_view.dart';
import 'package:nearbymenus/app/pages/orders/view_order.dart';
import 'package:nearbymenus/app/services/database.dart';
import 'package:provider/provider.dart';

class ExpandableMenuBrowser extends StatefulWidget {

  @override
  _ExpandableMenuBrowserState createState() => _ExpandableMenuBrowserState();
}

class _ExpandableMenuBrowserState extends State<ExpandableMenuBrowser> {
  Session session;
  Database database;
  Restaurant restaurant;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final f = NumberFormat.simpleCurrency(locale: "en_ZA");
  bool get orderOnHold =>
      session.currentOrder != null &&
      session.currentOrder.restaurantId == session.currentRestaurant.id &&
      session.currentOrder.status == ORDER_ON_HOLD;

  Widget _buildContents(BuildContext context, Map<String, dynamic> menus,
      Map<String, dynamic> options, dynamic sortedKeys) {
    return ListView.builder(
      itemCount: sortedKeys.length,
      itemBuilder: (BuildContext context, int index) {
        final menu = menus[sortedKeys[index]];
        return ExpandableListView(
          menu: menu,
          options: options,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    session = Provider.of<Session>(context);
    Map<String, dynamic> menus;
    Map<String, dynamic> options;
    Map<String, dynamic> sortedMenus = Map<String, dynamic>();
    restaurant = session.currentRestaurant;
    menus = restaurant.restaurantMenus;
    options = restaurant.restaurantOptions;
    sortedMenus.clear();
    menus.forEach((key, value) {
      if (value['hidden'] == false) {
        sortedMenus.putIfAbsent(value['sequence'].toString(), () => value);
      }
    });
    var sortedKeys = sortedMenus.keys.toList()..sort();
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          '${restaurant.name}',
          style: TextStyle(color: Theme.of(context).appBarTheme.color),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 26.0),
            child: IconButton(
              icon: Icon(Icons.add_shopping_cart),
              onPressed: () async {
                if (session.userDetails.name == '' ||
                    session.userDetails.address1 == '' ||
                    session.userDetails.address2 == '') {
                  await PlatformExceptionAlertDialog(
                    title: 'No delivery details',
                    exception: PlatformException(
                      code: 'NO_DELIVERY_DETAILS',
                      message:
                      'Please enter your delivery details in your profile page.',
                      details:
                      'Please enter your delivery details in your profile page.',
                    ),
                  ).show(context);
                } else {
                  if (orderOnHold) {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        fullscreenDialog: false,
                        builder: (context) => ViewOrder.create(
                          context: context,
                          scaffoldKey: _scaffoldKey,
                          order: session.currentOrder,
                        ),
                      ),
                    );
                  } else {
                    session.currentOrder = null;
                    await PlatformExceptionAlertDialog(
                      title: 'Empty Order',
                      exception: PlatformException(
                        code: 'ORDER_IS_EMPTY',
                        message:
                        'Please tap on the menu items you wish to order first.',
                        details:
                        'Please tap on the menu items you wish to order first.',
                      ),
                    ).show(context);
                  }
                }
              },
            ),
          ),
        ],
      ),
      body: _buildContents(context, sortedMenus, options, sortedKeys),
    );
  }
}
