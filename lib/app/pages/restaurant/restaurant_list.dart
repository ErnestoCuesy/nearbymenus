import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nearbymenus/app/common_widgets/form_submit_button.dart';
import 'package:nearbymenus/app/common_widgets/platform_alert_dialog.dart';
import 'package:nearbymenus/app/config/flavour_config.dart';
import 'package:nearbymenus/app/models/restaurant.dart';
import 'package:nearbymenus/app/pages/messages/messages_listener.dart';
import 'package:nearbymenus/app/pages/restaurant/menu_and_orders_page.dart';
import 'package:nearbymenus/app/pages/restaurant/check_staff_authorization.dart';
import 'package:nearbymenus/app/pages/restaurant/restaurant_list_tile.dart';
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
  String role = ROLE_PATRON;
  List<Restaurant> get nearbyRestaurantsList => widget.nearbyRestaurantsList;

  Future<void> _confirmContinue(BuildContext context) async {
    final didRequestContinue = await PlatformAlertDialog(
      title: 'Restaurant search',
      content: 'No restaurants where found near you.',
      cancelActionText: 'Exit',
      defaultActionText: 'Continue',
    ).show(context);
    if (didRequestContinue == true) {
      session.currentRestaurant = null;
    } else {
      exit(0);
    }
  }

  void _menuAndOrdersPage(BuildContext context, int index) {
    session.currentRestaurant = nearbyRestaurantsList[index];
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: false,
        builder: (context) => MessagesListener(page: MenuAndOrdersPage(),),
      ),
    );
  }

  void _staffAuthorizationPage(BuildContext context, int index) {
    session.currentRestaurant = nearbyRestaurantsList[index];
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: false,
        builder: (context) => CheckStaffAuthorization(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    session = Provider.of<Session>(context);
    database = Provider.of<Database>(context, listen: true);
    if (FlavourConfig.isManager()) {
      role = ROLE_MANAGER;
    } else if (FlavourConfig.isStaff()) {
      role = ROLE_STAFF;
    }
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
                    onTap: () {
                      if (role == ROLE_PATRON) {
                        _menuAndOrdersPage(context, index);
                      } else {
                        _staffAuthorizationPage(context, index);
                      }
                    },
                  ),
                );
              });
    } else {
      return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('No restaurants found near you', style: Theme
                .of(context)
                .accentTextTheme
                .headline6,),
            SizedBox(
              height: 32.0,
            ),
            FormSubmitButton(
              context: context,
              text: 'OK',
              color: Theme
                  .of(context)
                  .primaryColor,
              onPressed: () => _confirmContinue(context),
            ),
          ],
        ),
      );
    }
  }
}
