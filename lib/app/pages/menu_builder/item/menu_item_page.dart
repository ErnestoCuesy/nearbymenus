import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:nearbymenus/app/common_widgets/list_items_builder.dart';
import 'package:nearbymenus/app/common_widgets/platform_alert_dialog.dart';
import 'package:nearbymenus/app/common_widgets/platform_exception_alert_dialog.dart';
import 'package:nearbymenus/app/models/item.dart';
import 'package:nearbymenus/app/models/session.dart';
import 'package:nearbymenus/app/pages/menu_builder/item/menu_item_details_page.dart';
import 'package:nearbymenus/app/services/database.dart';
import 'package:provider/provider.dart';

class MenuItemPage extends StatefulWidget {
  final String sectionId;
  final String sectionName;

  const MenuItemPage({Key key, this.sectionId, this.sectionName}) : super(key: key);

  @override
  _MenuItemPageState createState() => _MenuItemPageState();
}

class _MenuItemPageState extends State<MenuItemPage> {
  Session session;
  Database database;
  final f = NumberFormat.simpleCurrency(locale: "en_ZA");

  void _createMenuSectionDetailsPage(BuildContext context, Item item) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: false,
        builder: (context) => MenuItemDetailsPage(
          session: session,
          database: database,
          item: item,
        ),
      ),
    );
  }

  Future<void> _deleteItem(BuildContext context, Item item) async {
    try {
      await database.deleteItem(item);
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Operation failed',
        exception: e,
      ).show(context);
    }
  }

  Future<bool> _confirmDismiss(BuildContext context, Item item) async {
    return await PlatformAlertDialog(
      title: 'Confirm menu item deletion',
      content: 'Do you really want to delete this menu item?',
      cancelActionText: 'No',
      defaultActionText: 'Yes',
    ).show(context);
  }

  Widget _buildContents(BuildContext context) {
    return StreamBuilder<List<Item>>(
      stream: database.menuItems(widget.sectionId),
      builder: (context, snapshot) {
        return ListItemsBuilder<Item>(
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
                    onTap: () => _createMenuSectionDetailsPage(context, item),
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
            '${widget.sectionName} section items', style: TextStyle(color: Theme
              .of(context)
              .appBarTheme
              .color),
          ),
        ),
        body: _buildContents(context),
        floatingActionButton: FloatingActionButton(
          tooltip: 'Add new item',
          child: Icon(
            Icons.add,
          ),
          onPressed: () => _createMenuSectionDetailsPage(context, Item(sectionId: widget.sectionId)),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            '${widget.sectionName} section items', style: TextStyle(color: Theme
              .of(context)
              .appBarTheme
              .color),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add, color: Theme.of(context).appBarTheme.color,),
              iconSize: 32.0,
              padding: const EdgeInsets.only(right: 16.0),
              onPressed: () => _createMenuSectionDetailsPage(context, Item(sectionId: widget.sectionId)),
            ),
          ],
        ),
        body: _buildContents(context),
      );
    }
  }

}