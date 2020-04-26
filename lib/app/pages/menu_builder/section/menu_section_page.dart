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
import 'package:nearbymenus/app/models/section.dart';
import 'package:nearbymenus/app/models/session.dart';
import 'package:nearbymenus/app/pages/menu_builder/item/menu_item_page.dart';
import 'package:nearbymenus/app/pages/menu_builder/section/menu_section_details_page.dart';
import 'package:nearbymenus/app/services/database.dart';
import 'package:provider/provider.dart';

class MenuSectionPage extends StatefulWidget {
  final Restaurant restaurant;
  final Menu menu;

  const MenuSectionPage({Key key, this.restaurant, this.menu,})
      : super(key: key);

  @override
  _MenuSectionPageState createState() => _MenuSectionPageState();
}

class _MenuSectionPageState extends State<MenuSectionPage> {
  Session session;
  Database database;

  void _createMenuSectionDetailsPage(BuildContext context, Section section) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: false,
        builder: (context) => MenuSectionDetailsPage(
          session: session,
          database: database,
          restaurant: widget.restaurant,
          menu: widget.menu,
          section: section,
        ),
      ),
    );
  }

  Future<void> _deleteSection(BuildContext context, Section section) async {
    try {
      await database.deleteSection(section);
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Operation failed',
        exception: e,
      ).show(context);
    }
  }

  Future<bool> _confirmDismiss(BuildContext context, Section section) async {
    return await PlatformAlertDialog(
      title: 'Confirm menu section deletion',
      content: 'Do you really want to delete this menu section?',
      cancelActionText: 'No',
      defaultActionText: 'Yes',
    ).show(context);
  }

  Widget _buildContents(BuildContext context) {
    return StreamBuilder<List<Section>>(
      stream: database.menuSections(widget.menu.id),
      builder: (context, snapshot) {
        return ListItemsBuilder<Section>(
            snapshot: snapshot,
            itemBuilder: (context, section) {
              return Dismissible(
                background: Container(color: Colors.red),
                key: Key('section-${section.id}'),
                direction: DismissDirection.endToStart,
                confirmDismiss: (_) => _confirmDismiss(context, section),
                onDismissed: (direction) => _deleteSection(context, section),
                child: Card(
                  margin: EdgeInsets.all(12.0),
                  child: ListTile(
                    isThreeLine: false,
                    leading: Icon(Icons.link),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          section.name,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ],
                    ),
                    subtitle: Text(section.notes ?? ''),
                    trailing: IconButton(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) => MenuItemPage(
                            restaurant: widget.restaurant,
                            menu: widget.menu,
                            section: section,
                          ),
                        ),
                      ),
                      icon: PlatformTrailingIcon(),
                    ),
                    onTap: () =>
                        _createMenuSectionDetailsPage(context, section),
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
            '${widget.menu.name}',
            style: TextStyle(color: Theme.of(context).appBarTheme.color),
          ),
        ),
        body: _buildContents(context),
        floatingActionButton: FloatingActionButton(
          tooltip: 'Add new menu section',
          child: Icon(
            Icons.add,
          ),
          onPressed: () => _createMenuSectionDetailsPage(
              context, Section(menuId: widget.menu.id)),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            '${widget.menu.name}',
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
              onPressed: () => _createMenuSectionDetailsPage(
                  context, Section(menuId: widget.menu.id)),
            ),
          ],
        ),
        body: _buildContents(context),
      );
    }
  }
}
