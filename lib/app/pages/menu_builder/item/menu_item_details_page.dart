import 'package:flutter/material.dart';
import 'package:nearbymenus/app/models/item.dart';
import 'package:nearbymenus/app/models/menu.dart';
import 'package:nearbymenus/app/models/restaurant.dart';
import 'package:nearbymenus/app/models/session.dart';
import 'package:nearbymenus/app/pages/menu_builder/item/menu_item_details_form.dart';
import 'package:nearbymenus/app/services/database.dart';

class MenuItemDetailsPage extends StatelessWidget {
  final Session session;
  final Database database;
  final Restaurant restaurant;
  final Menu menu;
  final Item item;

  const MenuItemDetailsPage({
    Key key,
    this.restaurant,
    this.menu,
    this.session,
    this.database,
    this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter menu item details'),
        elevation: 2.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            child: MenuItemDetailsForm.create(
              context: context,
              session: session,
              database: database,
              menu: menu,
              restaurant: restaurant,
              item: item,
            ),
          ),
        ),
      ),
      backgroundColor: Colors.grey[200],
    );
  }
}
