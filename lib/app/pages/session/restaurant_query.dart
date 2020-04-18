import 'package:flutter/material.dart';
import 'package:nearbymenus/app/models/nearest_restaurant.dart';
import 'package:nearbymenus/app/models/restaurant.dart';
import 'package:nearbymenus/app/pages/session/restaurant_list.dart';
import 'package:nearbymenus/app/services/database.dart';
import 'package:nearbymenus/app/models/session.dart';
import 'package:provider/provider.dart';

class RestaurantQuery extends StatefulWidget {
  final String role;

  const RestaurantQuery({Key key, this.role}) : super(key: key);

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
    final useStaffFilter = false; //widget.role == ROLE_STAFF ? true : false;
    bloc = NearRestaurantBloc(
        source: database.patronRestaurants(), userCoordinates: userCoordinates, useStaffFilter: useStaffFilter);
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

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

}
