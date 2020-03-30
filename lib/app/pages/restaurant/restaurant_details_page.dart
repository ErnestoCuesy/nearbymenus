import 'package:flutter/material.dart';
import 'package:nearbymenus/app/models/restaurant.dart';
import 'package:nearbymenus/app/models/session.dart';
import 'package:nearbymenus/app/pages/restaurant/restaurant_details_form.dart';
import 'package:nearbymenus/app/services/database.dart';

class RestaurantDetailsPage extends StatelessWidget {
  final Session session;
  final Database database;
  final Restaurant restaurant;

  const RestaurantDetailsPage({Key key, this.session, this.database, this.restaurant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter restaurant details'),
        elevation: 2.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            child: RestaurantDetailsForm.create(
                context, session, database, restaurant),
          ),
        ),
      ),
      backgroundColor: Colors.grey[200],
    );
  }
}
