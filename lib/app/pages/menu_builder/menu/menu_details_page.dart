import 'package:flutter/material.dart';
import 'package:nearbymenus/app/models/menu.dart';
import 'package:nearbymenus/app/models/restaurant.dart';
import 'package:nearbymenus/app/pages/menu_builder/menu/menu_details_form.dart';

class MenuDetailsPage extends StatelessWidget {
  final Restaurant restaurant;
  final Menu menu;

  const MenuDetailsPage(
      {Key key, this.menu, this.restaurant})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter menu details'),
        elevation: 2.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            child: MenuDetailsForm.create(
              context: context,
              restaurant: restaurant,
              menu: menu,
            ),
          ),
        ),
      ),
      backgroundColor: Colors.grey[200],
    );
  }
}
