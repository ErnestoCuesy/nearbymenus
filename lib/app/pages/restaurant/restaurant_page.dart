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
              margin: EdgeInsets.all(12.0),
              child: ListTile(
                isThreeLine: true,
                leading: Icon(Icons.restaurant),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                        restaurant.name,
                      style: Theme.of(context).textTheme.headline6,
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
                      onChanged: null,
                    ),
                    CheckboxListTile(
                      title: Text('Restaurant shows as open'),
                      value: restaurant.open,
                      onChanged: null,
                    ),
                    CheckboxListTile(
                      title: Text('Accepting staff requests'),
                      value: restaurant.acceptingStaffRequests,
                      onChanged: null,
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
      ),
      body: _buildContents(context),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add new restaurant',
        child: Icon(
          Icons.add,
        ),
        onPressed: () => _createRestaurantDetailsPage(context, Restaurant()),
      ),
    );
  }

}