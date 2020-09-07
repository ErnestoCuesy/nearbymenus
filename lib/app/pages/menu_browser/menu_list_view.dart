import 'dart:core';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nearbymenus/app/models/session.dart';
import 'package:nearbymenus/app/pages/menu_browser/menu_item_view.dart';
import 'package:nearbymenus/app/services/database.dart';
import 'package:provider/provider.dart';

class MenuListView extends StatefulWidget {
  final Map<dynamic, dynamic> menu;
  final Map<dynamic, dynamic> options;

  const MenuListView({Key key, this.menu, this.options})
      : super(key: key);

  @override
  _MenuListViewState createState() => _MenuListViewState();
}

class _MenuListViewState extends State<MenuListView> {
  Session session;
  Database database;
  Map<dynamic, dynamic> items;
  bool expandItemsFlag = false;
  Map<dynamic, dynamic> sortedMenuItems = Map<dynamic, dynamic>();
  final f = NumberFormat.simpleCurrency(locale: "en_ZA");

  Map<dynamic, dynamic> get menu => widget.menu;

  @override
  Widget build(BuildContext context) {
    session = Provider.of<Session>(context);
    database = Provider.of<Database>(context);
    sortedMenuItems.clear();
    final itemCount = menu.entries
        .where((element) {
          if (element.key.toString().length > 20 &&
              (element.value['hidden'] == null ||
                  element.value['hidden'] == false)) {
            sortedMenuItems.putIfAbsent(
                menu[element.key]['sequence'], () => element.value);
            return true;
          } else {
            return false;
          }
        })
        .toList()
        .length;
    final sortedKeys = sortedMenuItems.keys.toList()..sort();
    if (itemCount == 0) {
      return Container();
    }
    final key =
        menu.keys.firstWhere((element) => element.toString().length > 20);
    items = menu[key];
    String menuName = menu['name'];
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.0),
      child: Column(
        children: <Widget>[
          Card(
            color: Theme.of(context).canvasColor,
            margin: EdgeInsets.all(12.0),
            child: ListTile(
              isThreeLine: false,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    menu['name'],
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ],
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Text(
                  menu['notes'],
                ),
              ),
              trailing: IconButton(
                  icon: Container(
                    height: 50.0,
                    width: 50.0,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.keyboard_arrow_right,
                        color: Colors.white,
                        size: 30.0,
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        fullscreenDialog: false,
                        builder: (context) => MenuItemView(
                          session: session,
                          sortedMenuItems: sortedMenuItems,
                          options: widget.options,
                          sortedKeys: sortedKeys,
                          menuName: menuName,
                        ),
                      ),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
