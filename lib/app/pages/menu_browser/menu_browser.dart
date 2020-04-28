import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nearbymenus/app/common_widgets/platform_progress_indicator.dart';
import 'package:nearbymenus/app/models/session.dart';
import 'package:provider/provider.dart';

class MenuBrowser extends StatelessWidget {

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
    final restaurant = session.nearestRestaurant;
    final menus = restaurant.restaurantMenus;
    if (menus == null) {
      // TODO listen to restaurant stream in case restaurant object not in memory
      return Center(child: PlatformProgressIndicator());
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
        floatingActionButton: FloatingActionButton(
          tooltip: 'Add new menu',
          child: Icon(
            Icons.add,
          ),
          onPressed: null,
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            '${restaurant.name} Menu',
            style: TextStyle(color: Theme.of(context).appBarTheme.color),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.add,
                color: Theme.of(context).appBarTheme.color,
              ),
              iconSize: 32.0,
              padding: const EdgeInsets.only(right: 16.0),
              onPressed: null,
            ),
          ],
        ),
        body: _buildContents(context, _parseMenuContents(menus)),
      );
    }
  }
}
