import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:nearbymenus/app/common_widgets/list_items_builder.dart';
import 'package:nearbymenus/app/common_widgets/platform_alert_dialog.dart';
import 'package:nearbymenus/app/common_widgets/platform_exception_alert_dialog.dart';
import 'package:nearbymenus/app/models/menu_item.dart';
import 'package:nearbymenus/app/models/menu.dart';
import 'package:nearbymenus/app/models/restaurant.dart';
import 'package:nearbymenus/app/models/session.dart';
import 'package:nearbymenus/app/pages/menu_builder/menu_item/menu_item_details_page.dart';
import 'package:nearbymenus/app/services/database.dart';
import 'package:provider/provider.dart';

class MenuItemPage extends StatefulWidget {
  final Restaurant restaurant;
  final Menu menu;

  const MenuItemPage({Key key, this.restaurant, this.menu}) : super(key: key);

  @override
  _MenuItemPageState createState() => _MenuItemPageState();
}

class _MenuItemPageState extends State<MenuItemPage> {
  Session session;
  Database database;
  final f = NumberFormat.simpleCurrency(locale: "en_ZA");

  void _createMenuItemDetailsPage(BuildContext context, MenuItem item) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: false,
        builder: (context) => MenuItemDetailsPage(
          session: session,
          database: database,
          restaurant: widget.restaurant,
          menu: widget.menu,
          item: item,
        ),
      ),
    );
  }

  Future<void> _deleteItem(BuildContext context, MenuItem item) async {
    try {
      await database.deleteMenuItem(item);
      widget.restaurant.restaurantMenus[widget.menu.id].remove(item.id);
      Restaurant.setRestaurant(database, widget.restaurant);
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Operation failed',
        exception: e,
      ).show(context);
    }
  }

  Future<bool> _confirmDismiss(BuildContext context, MenuItem item) async {
    return await PlatformAlertDialog(
      title: 'Confirm menu item deletion',
      content: 'Do you really want to delete this menu item?',
      cancelActionText: 'No',
      defaultActionText: 'Yes',
    ).show(context);
  }

  Widget _buildContents(BuildContext context) {
    return StreamBuilder<List<MenuItem>>(
      stream: database.menuItems(widget.menu.id),
      builder: (context, snapshot) {
        return ListItemsBuilder<MenuItem>(
            snapshot: snapshot,
            itemBuilder: (context, item) {
              return Dismissible(
                background: Container(color: Colors.red),
                key: Key('item-${item.id}'),
                direction: DismissDirection.endToStart,
                confirmDismiss: (_) => _confirmDismiss(context, item),
                onDismissed: (direction) => _deleteItem(context, item),
                child: Card(
                  margin: EdgeInsets.all(12.0),
                  child: ListTile(
                    isThreeLine: true,
                    leading: Icon(Icons.link),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          item.name,
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        SizedBox(
                          height: 4.0,
                        ),
                        Text(
                          item.description,
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ],
                    ),
                    subtitle: Column(
                      children: <Widget>[
                        CheckboxListTile(
                          title: Text('Is extra or side dish'),
                          value: item.isExtra,
                          onChanged: null,
                        ),
                      ],
                    ),
                    trailing: Text(
                      f.format(item.price),
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    onTap: () => _createMenuItemDetailsPage(context, item),
                  ),
                ),
              );
            }
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    session = Provider.of<Session>(context);
    database = Provider.of<Database>(context);
    if (Platform.isAndroid) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            '${widget.menu.name}', style: TextStyle(color: Theme
              .of(context)
              .appBarTheme
              .color),
          ),
        ),
        body: _buildContents(context),
        floatingActionButton: FloatingActionButton(
          tooltip: 'Add new menu item',
          child: Icon(
            Icons.add,
          ),
          onPressed: () => _createMenuItemDetailsPage(context, MenuItem(menuId: widget.menu.id)),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            '${widget.menu.name}', style: TextStyle(color: Theme
              .of(context)
              .appBarTheme
              .color),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add, color: Theme.of(context).appBarTheme.color,),
              iconSize: 32.0,
              padding: const EdgeInsets.only(right: 16.0),
              onPressed: () => _createMenuItemDetailsPage(context, MenuItem(menuId: widget.menu.id)),
            ),
          ],
        ),
        body: _buildContents(context),
      );
    }
  }

}