import 'dart:core';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nearbymenus/app/models/session.dart';
import 'package:nearbymenus/app/pages/menu_browser/expandable_container.dart';
import 'package:nearbymenus/app/pages/orders/add_to_order.dart';
import 'package:nearbymenus/app/services/database.dart';
import 'package:provider/provider.dart';

class ExpandableListView extends StatefulWidget {
  final Function callBack;
  final Map<String, dynamic> menu;
  final Map<String, dynamic> options;

  const ExpandableListView({Key key, this.callBack, this.menu, this.options})
      : super(key: key);

  @override
  _ExpandableListViewState createState() => _ExpandableListViewState();
}

class _ExpandableListViewState extends State<ExpandableListView> {
  Session session;
  Database database;
  Map<String, dynamic> items;
  bool expandItemsFlag = false;
  Map<String, dynamic> sortedMenuItems = Map<String, dynamic>();
  final f = NumberFormat.simpleCurrency(locale: "en_ZA");

  Map<String, dynamic> get menu => widget.menu;

  void _addMenuItemToOrder(BuildContext context, String menuCode, Map<String, dynamic> menuItem) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute<String>(
        fullscreenDialog: false,
        builder: (context) => AddToOrder.create(
          context: context,
          menuCode: menuCode,
          item: menuItem,
          options: widget.options,
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
    widget.callBack();
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
    session = Provider.of<Session>(context);
    database = Provider.of<Database>(context);
    sortedMenuItems.clear();
    final itemCount = menu.entries
        .where((element) {
          if (element.key.toString().length > 20 &&
              (element.value['hidden'] == null ||
                  element.value['hidden'] == false)) {
            sortedMenuItems.putIfAbsent(
                menu[element.key]['sequence'].toString(), () => element.value);
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
                        expandItemsFlag
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: Colors.white,
                        size: 30.0,
                      ),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      expandItemsFlag = !expandItemsFlag;
                    });
                  }),
            ),
          ),
          ExpandableContainer(
            expanded: expandItemsFlag,
            expandedHeight: 100.0 * itemCount,
            child: ListView.builder(
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
          ),
        ],
      ),
    );
  }
}
