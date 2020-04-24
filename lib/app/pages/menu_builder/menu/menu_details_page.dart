import 'package:flutter/material.dart';
import 'package:nearbymenus/app/models/menu.dart';
import 'package:nearbymenus/app/models/session.dart';
import 'package:nearbymenus/app/pages/menu_builder/menu/menu_details_form.dart';
import 'package:nearbymenus/app/services/database.dart';

class MenuDetailsPage extends StatelessWidget {
  final Session session;
  final Database database;
  final Menu menu;
  final String restaurantId;

  const MenuDetailsPage({Key key, this.session, this.database, this.menu, this.restaurantId}) : super(key: key);

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
              context, session, database, menu, restaurantId),
            ),
          ),
        ),
      backgroundColor: Colors.grey[200],
    );
  }
}
