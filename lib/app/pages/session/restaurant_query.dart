import 'package:flutter/material.dart';
import 'package:nearbymenus/app/models/nearest_restaurant.dart';
import 'package:nearbymenus/app/models/restaurant.dart';
import 'package:nearbymenus/app/pages/session/restaurant_list.dart';
import 'package:nearbymenus/app/services/database.dart';
import 'package:nearbymenus/app/models/session.dart';
import 'package:provider/provider.dart';

class RestaurantQuery extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context, listen: true);
    final session = Provider.of<Session>(context);
    final userCoordinates = session.position;
    final bloc = NearRestaurantBloc(
        source: database.patronRestaurants(), userCoordinates: userCoordinates);
    return StreamBuilder<List<Restaurant>>(
      stream: bloc.stream,
      builder: (context, snapshot) {
        var restaurantList = List<Restaurant>();
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData && snapshot.data.length > 0) {
            restaurantList = snapshot.data;
          }
        }
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Select your nearest restaurant',
              style: TextStyle(color: Theme.of(context).appBarTheme.color),
            ),
            elevation: 2.0,
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: RestaurantList(nearbyRestaurantsList: restaurantList),
        );
      },
    );
  }
}
