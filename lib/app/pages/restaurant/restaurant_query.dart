import 'package:flutter/material.dart';
import 'package:nearbymenus/app/common_widgets/list_items_builder.dart';
import 'package:nearbymenus/app/config/flavour_config.dart';
import 'package:nearbymenus/app/pages/messages/messages_listener.dart';
import 'package:nearbymenus/app/pages/restaurant/check_staff_authorization.dart';
import 'package:nearbymenus/app/pages/restaurant/menu_and_orders_page.dart';
import 'package:nearbymenus/app/pages/restaurant/restaurant_list_tile.dart';
import 'package:nearbymenus/app/services/near_restaurant_bloc.dart';
import 'package:nearbymenus/app/models/restaurant.dart';
import 'package:nearbymenus/app/services/database.dart';
import 'package:nearbymenus/app/models/session.dart';
import 'package:provider/provider.dart';

class RestaurantQuery extends StatefulWidget {

  @override
  _RestaurantQueryState createState() => _RestaurantQueryState();
}

class _RestaurantQueryState extends State<RestaurantQuery> {
  Session session;
  Database database;
  NearRestaurantBloc bloc;
  String role = ROLE_PATRON;

  void _menuAndOrdersPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: false,
        builder: (context) => MessagesListener(child: MenuAndOrdersPage(),),
      ),
    );
  }

  void _staffAuthorizationPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: false,
        builder: (context) => CheckStaffAuthorization(),
      ),
    );
  }

  Widget _buildContents(BuildContext context) {
    return StreamBuilder<List<Restaurant>>(
        stream: bloc.stream,
        builder: (context, snapshot) {
          return ListItemsBuilder<Restaurant>(
            title: 'No nearby restaurants found',
            message: 'You seem to be far away from them',
            snapshot: snapshot,
            itemBuilder: (context, restaurant) {
              return Card(
                child: ListTile(
                  leading: Icon(Icons.restaurant),
                  // title: _buildTitle(index),
                  title: RestaurantListTile(
                    restaurant: restaurant,
                    restaurantFound: true,
                  ),
                  onTap: () {
                    session.currentRestaurant = restaurant;
                    if (role == ROLE_PATRON) {
                      _menuAndOrdersPage(context);
                    } else {
                      _staffAuthorizationPage(context);
                    }
                  },
                ),
              );
            }
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    database = Provider.of<Database>(context, listen: true);
    session = Provider.of<Session>(context);
    final userCoordinates = session.position;
    if (FlavourConfig.isManager()) {
      role = ROLE_MANAGER;
    } else if (FlavourConfig.isStaff()) {
      role = ROLE_STAFF;
    } else if (FlavourConfig.isVenue()) {
      role = ROLE_VENUE;
    }
    bloc = NearRestaurantBloc(
        source: database.patronRestaurants(),
        userCoordinates: userCoordinates,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Restaurants near you',
          style: TextStyle(color: Theme.of(context).appBarTheme.color),
        ),
        elevation: 2.0,
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: _buildContents(context),
    );
  }

}
