import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nearbymenus/app/common_widgets/list_items_builder.dart';
import 'package:nearbymenus/app/common_widgets/platform_alert_dialog.dart';
import 'package:nearbymenus/app/common_widgets/platform_exception_alert_dialog.dart';
import 'package:nearbymenus/app/common_widgets/platform_trailing_icon.dart';
import 'package:nearbymenus/app/models/menu.dart';
import 'package:nearbymenus/app/models/restaurant.dart';
import 'package:nearbymenus/app/models/session.dart';
import 'package:nearbymenus/app/pages/menu_builder/menu_item/menu_item_page.dart';
import 'package:nearbymenus/app/pages/menu_builder/menu/menu_details_page.dart';
import 'package:nearbymenus/app/services/database.dart';
import 'package:provider/provider.dart';

class MenuPage extends StatefulWidget {
  final Restaurant restaurant;

  const MenuPage({Key key, this.restaurant,})
      : super(key: key);

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  Session session;
  Database database;

  void _createMenuDetailsPage(BuildContext context, Menu menu) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: false,
        builder: (context) => MenuDetailsPage(
          restaurant: widget.restaurant,
          menu: menu,
        ),
      ),
    );
  }

  Future<void> _deleteMenu(BuildContext context, Menu menu) async {
    try {
      await database.deleteMenu(menu);
      widget.restaurant.restaurantMenus.remove(menu.id);
      Restaurant.setRestaurant(database, widget.restaurant);
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Operation failed',
        exception: e,
      ).show(context);
    }
  }

  Future<bool> _confirmDismiss(BuildContext context, Menu menu) async {
    var hasStuff = false;
    widget.restaurant.restaurantMenus[menu.id].forEach((key, value) {
      if (key.toString().length > 20){
        hasStuff = true;
      }
    });
    if (hasStuff) {
      return !await PlatformExceptionAlertDialog(
        title: 'Menu is not empty',
        exception: PlatformException(
          code: 'MAP_IS_NOT_EMPTY',
          message:  'Please delete all the menu items first.',
          details:  'Please delete all the menu items first.',
        ),
      ).show(context);
    } else {
      return await PlatformAlertDialog(
        title: 'Confirm menu deletion',
        content: 'Do you really want to delete this menu?',
        cancelActionText: 'No',
        defaultActionText: 'Yes',
      ).show(context);
    }
  }

  Widget _buildContents(BuildContext context) {
    return StreamBuilder<List<Menu>>(
      stream: database.restaurantMenus(widget.restaurant.id),
      builder: (context, snapshot) {
        return ListItemsBuilder<Menu>(
            snapshot: snapshot,
            itemBuilder: (context, menu) {
              return Dismissible(
                background: Container(color: Colors.red),
                key: Key('menu-${menu.id}'),
                direction: DismissDirection.endToStart,
                confirmDismiss: (_) => _confirmDismiss(context, menu),
                onDismissed: (direction) => _deleteMenu(context, menu),
                child: Card(
                  margin: EdgeInsets.all(12.0),
                  child: ListTile(
                    isThreeLine: false,
                    leading: menu.hidden ? Icon(Icons.visibility_off) : Icon(Icons.visibility),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          menu.name,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ],
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top:8.0),
                      child: Text(menu.notes ?? ''),
                    ),
                    trailing: IconButton(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) => MenuItemPage(
                            restaurant: widget.restaurant,
                            menu: menu,
                          ),
                        ),
                      ),
                      icon: PlatformTrailingIcon(),
                    ),
                    onTap: () => _createMenuDetailsPage(context, menu),
                  ),
                ),
              );
            });
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
            '${widget.restaurant.name}',
            style: TextStyle(color: Theme.of(context).appBarTheme.color),
          ),
        ),
        body: _buildContents(context),
        floatingActionButton: FloatingActionButton(
          tooltip: 'Add new menu',
          child: Icon(
            Icons.add,
          ),
          onPressed: () => _createMenuDetailsPage(context, Menu()),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            '${widget.restaurant.name}',
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
              onPressed: () => _createMenuDetailsPage(context, Menu()),
            ),
          ],
        ),
        body: _buildContents(context),
      );
    }
  }
}
