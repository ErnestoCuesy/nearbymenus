import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nearbymenus/app/common_widgets/form_submit_button.dart';
import 'package:nearbymenus/app/common_widgets/platform_alert_dialog.dart';
import 'package:nearbymenus/app/models/restaurant.dart';
import 'package:nearbymenus/app/models/user_details.dart';
import 'package:nearbymenus/app/pages/session/restaurant_list_tile.dart';
import 'package:nearbymenus/app/services/database.dart';
import 'package:nearbymenus/app/models/session.dart';
import 'package:provider/provider.dart';

class RestaurantList extends StatefulWidget {
  final List<Restaurant> nearbyRestaurantsList;

  const RestaurantList({Key key, this.nearbyRestaurantsList}) : super(key: key);
  @override
  _RestaurantListState createState() => _RestaurantListState();
}

class _RestaurantListState extends State<RestaurantList> {
  Session session;
  Database database;

  List<Restaurant> get nearbyRestaurantsList => widget.nearbyRestaurantsList;

  void _setNearestRestaurant(int index) {
    var nearestRestaurantId = 'No restaurants found';
    var nearestRestaurant = Restaurant(id: nearestRestaurantId);
    if (index != -1) {
      nearestRestaurantId = nearbyRestaurantsList[index].id;
      nearestRestaurant = nearbyRestaurantsList[index];
    }
    database.setUserDetails(UserDetails(
        name: session.userDetails.name,
        address: session.userDetails.address,
        nearestRestaurantId: nearestRestaurantId,
        role: session.userDetails.role,
        deviceName: session.userDetails.deviceName));
    session.nearestRestaurant = nearestRestaurant;
    session.restaurantsFound = true;
  }

  Future<void> _confirmContinue(BuildContext context) async {
    final didRequestContinue = await PlatformAlertDialog(
      title: 'Restaurant search',
      content: 'No restaurants where found near you.',
      cancelActionText: 'Exit',
      defaultActionText: 'Continue',
    ).show(context);
    if (didRequestContinue == true) {
      _setNearestRestaurant(-1);
    } else {
      exit(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    session = Provider.of<Session>(context);
    database = Provider.of<Database>(context, listen: true);
    if (nearbyRestaurantsList.length > 0) {
      return ListView.builder(
              itemCount: nearbyRestaurantsList.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: ListTile(
                    leading: Icon(Icons.restaurant),
                    // title: _buildTitle(index),
                    title: RestaurantListTile(
                      restaurant: nearbyRestaurantsList[index],
                      restaurantFound: true,
                    ),
                    // subtitle: _buildSubtitle(index),
                    onTap: () => _setNearestRestaurant(index),
                  ),
                );
              });
    } else {
      return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('No restaurants found near you', style: Theme.of(context).accentTextTheme.title,),
            SizedBox(
              height: 32.0,
            ),
            FormSubmitButton(
              context: context,
              text: 'OK',
              color: Theme.of(context).primaryColor,
              onPressed: () => _confirmContinue(context),
            ),
          ],
        ),
      );
    }
  }
}
