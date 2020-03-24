import 'package:flutter/material.dart';
import 'package:nearbymenus/app/models/nearest_restaurant.dart';
import 'package:nearbymenus/app/pages/landing/loading_view.dart';
import 'package:nearbymenus/app/pages/session/restaurant_list.dart';
import 'package:nearbymenus/app/services/database.dart';
import 'package:nearbymenus/app/services/session.dart';
import 'package:provider/provider.dart';

class RestaurantQuery extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context, listen: true);
    final session = Provider.of<Session>(context);
    final userCoordinates = session.position;
    final bloc = NearRestaurantBloc(source: database.restaurantStream(), userCoordinates: userCoordinates);
    return StreamBuilder<List<NearestRestaurant>>(
      stream: bloc.stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData && snapshot.data.length > 0) {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  'Select your nearest restaurant',
                  style: TextStyle(color: Theme
                      .of(context)
                      .appBarTheme
                      .color),
                ),
                elevation: 2.0,
              ),
              body: RestaurantList(nearbyRestaurantsList: snapshot.data),
              backgroundColor: Theme
                  .of(context)
                  .scaffoldBackgroundColor,
            );
          } else {
            // TODO handle empty snapshot or timeout or something
            return LoadingView();
          }
        } else {
          return LoadingView();
        }
      },
    );
  }
}
