import 'package:flutter/material.dart';
import 'package:nearbymenus/app/models/nearest_restaurant.dart';
import 'package:nearbymenus/app/models/restaurant.dart';
import 'package:nearbymenus/app/pages/restaurant/restaurant_list.dart';
import 'package:nearbymenus/app/services/database.dart';
import 'package:nearbymenus/app/models/session.dart';
import 'package:provider/provider.dart';

class RestaurantQuery extends StatefulWidget {

  @override
  _RestaurantQueryState createState() => _RestaurantQueryState();
}

class _RestaurantQueryState extends State<RestaurantQuery> {
  NearRestaurantBloc bloc;

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context, listen: true);
    final session = Provider.of<Session>(context);
    final userCoordinates = session.position;
    bloc = NearRestaurantBloc(
        source: database.patronRestaurants(),
        userCoordinates: userCoordinates,
    );
    return StreamBuilder<List<Restaurant>>(
      stream: bloc.stream,
      builder: (context, snapshot) {
        bool stillLoading = true;
        var restaurantList = List<Restaurant>();
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData && snapshot.data.length > 0) {
            restaurantList = snapshot.data;
          }
          stillLoading = false;
        }
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Restaurants near you',
              style: TextStyle(color: Theme.of(context).appBarTheme.color),
            ),
            elevation: 2.0,
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: RefreshIndicator(
            onRefresh: () async {
              setState(() {

              });
            },
            child: RestaurantList(
              nearbyRestaurantsList: restaurantList,
              stillLoading: stillLoading,
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

}
