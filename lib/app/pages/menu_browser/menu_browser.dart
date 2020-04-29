import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nearbymenus/app/common_widgets/platform_progress_indicator.dart';
import 'package:nearbymenus/app/models/restaurant.dart';
import 'package:nearbymenus/app/models/session.dart';
import 'package:nearbymenus/app/services/database.dart';
import 'package:provider/provider.dart';

class MenuBrowser extends StatefulWidget {

  @override
  _MenuBrowserState createState() => _MenuBrowserState();
}

class _MenuBrowserState extends State<MenuBrowser> {
  final f = NumberFormat.simpleCurrency(locale: "en_ZA");

  Widget _buildTile(String title, String description, String price) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: ListTile(
          title: Text(title),
          subtitle: Text(description),
          trailing: Text(price),
        ),
      ),
    );
  }

  Widget _buildContents(BuildContext context, List<Widget> menuList) {
    return ListWheelScrollView(
      itemExtent: 200,
      children: menuList,
    );
  }

  List<Widget> _parseMenuContents(Map<dynamic, dynamic> menus) {
    List<Widget> itemList = List<Widget>();
    menus.forEach((key, value) {
      if (key.toString().length > 20) {
        //itemList.add(_buildTile(value['name']));
        Map<dynamic, dynamic> sectionsMap = menus[key];
        sectionsMap.forEach((key, value) {
          if (key.toString().length > 20) {
            // itemList.add(_buildTile(value['name']));
            Map<dynamic, dynamic> itemsMap = sectionsMap[key];
            itemsMap.forEach((key, value) {
              if (key.toString().length > 20) {
                itemList.add(_buildTile(value['name'], value['description'], f.format(value['price'])));
              }
            });
          }
        });
      }
    });
    return itemList;
  }

  @override
  Widget build(BuildContext context) {
    final session = Provider.of<Session>(context);
    final database = Provider.of<Database>(context);
    //final restaurant = session.nearestRestaurant;
    Restaurant restaurant;
    Map<dynamic, dynamic> menus;
    return StreamBuilder<List<Restaurant>>(
      stream: database.userRestaurant(session.userDetails.nearestRestaurantId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData && snapshot.data.length > 0) {
            restaurant = snapshot.data.elementAt(0);
            session.nearestRestaurant = restaurant;
            menus = restaurant.restaurantMenus;
          }
          if (Platform.isAndroid) {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  '${restaurant.name} Menu',
                  style: TextStyle(color: Theme.of(context).appBarTheme.color),
                ),
              ),
              body: _buildContents(context, _parseMenuContents(menus)),
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  '${restaurant.name} Menu',
                  style: TextStyle(color: Theme.of(context).appBarTheme.color),
                ),
              ),
              body: _buildContents(context, _parseMenuContents(menus)),
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
