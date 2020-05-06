import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nearbymenus/app/common_widgets/platform_progress_indicator.dart';
import 'package:nearbymenus/app/models/restaurant.dart';
import 'package:nearbymenus/app/models/session.dart';
import 'package:nearbymenus/app/pages/menu_browser/expandable_list_view.dart';
import 'package:nearbymenus/app/services/database.dart';
import 'package:provider/provider.dart';

class ExpandableMenuBrowser extends StatefulWidget {

  @override
  _ExpandableMenuBrowserState createState() => _ExpandableMenuBrowserState();
}

class _ExpandableMenuBrowserState extends State<ExpandableMenuBrowser> {
  final f = NumberFormat.simpleCurrency(locale: "en_ZA");

  Widget _buildContents(BuildContext context, Map<String, dynamic> menus, Map<String, dynamic> options, dynamic sortedKeys) {
    return ListView.builder(
      itemCount: sortedKeys.length,
      itemBuilder: (BuildContext context, int index) {
        // String key = menus.keys.elementAt(index);
        // final menu = menus[key];
        print(sortedKeys[index]);
        final menu = menus[sortedKeys[index]];
        print(menu);
        return ExpandableListView(menu: menu, options: options,);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final session = Provider.of<Session>(context);
    final database = Provider.of<Database>(context, listen: true);
    Restaurant restaurant;
    Map<String, dynamic> menus;
    Map<String, dynamic> options;
    Map<String, dynamic> sortedMenus = Map<String, dynamic>();
    return StreamBuilder<List<Restaurant>>(
      stream: database.userRestaurant(session.userDetails.nearestRestaurantId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData && snapshot.data.length > 0) {
            restaurant = snapshot.data.elementAt(0);
            session.nearestRestaurant = restaurant;
            menus = restaurant.restaurantMenus;
            options = restaurant.restaurantOptions;
            print(menus);
          }
          sortedMenus.clear();
          menus.forEach((key, value) {
            sortedMenus.putIfAbsent(value['sequence'].toString(), () => value);
          });
          var sortedKeys = sortedMenus.keys.toList()..sort();
          print(sortedKeys);
          if (Platform.isAndroid) {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  '${restaurant.name}',
                  style: TextStyle(color: Theme.of(context).appBarTheme.color),
                ),
              ),
              body: _buildContents(context, sortedMenus, options, sortedKeys),
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  '${restaurant.name}',
                  style: TextStyle(color: Theme.of(context).appBarTheme.color),
                ),
              ),
              body: _buildContents(context, sortedMenus, options, sortedKeys),
            );
          }
        } else {
          return Center(
            child: PlatformProgressIndicator(),
          );
        }
      },
    );
  }
}
