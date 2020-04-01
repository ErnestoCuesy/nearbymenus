import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nearbymenus/app/common_widgets/list_items_builder.dart';
import 'package:nearbymenus/app/models/restaurant.dart';
import 'package:nearbymenus/app/models/session.dart';
import 'package:nearbymenus/app/pages/restaurant/restaurant_details_page.dart';
import 'package:nearbymenus/app/services/database.dart';
import 'package:provider/provider.dart';

class RestaurantPage extends StatefulWidget {
  @override
  _RestaurantPageState createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> {
  Session session;
  Database database;

  void _createRestaurantDetailsPage(BuildContext context, Restaurant restaurant) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: false,
        builder: (context) => RestaurantDetailsPage(
          session: session,
          database: database,
          restaurant: restaurant,
        ),
      ),
    );
  }

  Widget _buildContents(BuildContext context) {
    return StreamBuilder<List<Restaurant>>(
      stream: database.managerRestaurants(database.userId),
      builder: (context, snapshot) {
        return ListItemsBuilder<Restaurant>(
          snapshot: snapshot,
          itemBuilder: (context, restaurant) {
            return Card(
              child: ListTile(
                isThreeLine: true,
                leading: Icon(Icons.restaurant),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                        restaurant.name,
                      style: Theme.of(context).textTheme.title,
                    ),
                    Text(restaurant.restaurantLocation),
                  ],
                ),
                // subtitle: Text('${restaurant.restaurantLocation}'),
                subtitle: Column(
                  children: <Widget>[
                    CheckboxListTile(
                      title: Text('Listing is active'),
                      value: restaurant.active,
                    ),
                    CheckboxListTile(
                      title: Text('Restaurant shows as open'),
                      value: restaurant.open,
                    ),
                    CheckboxListTile(
                      title: Text('Accepting staff requests'),
                      value: restaurant.acceptingStaffRequests,
                    ),
                  ],
                ),
                trailing: Icon(Icons.edit),
                onTap: () => _createRestaurantDetailsPage(context, restaurant),
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your managed restaurants', style: TextStyle(color: Theme
            .of(context)
            .appBarTheme
            .color),
        ),
        actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add, color: Theme.of(context).appBarTheme.color,),
              iconSize: 32.0,
              padding: const EdgeInsets.only(right: 16.0),
              onPressed: () => _createRestaurantDetailsPage(context, Restaurant()),
            ),
        ],
      ),
      body: _buildContents(context),
    );
  }

}