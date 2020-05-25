import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nearbymenus/app/common_widgets/form_submit_button.dart';
import 'package:nearbymenus/app/common_widgets/platform_alert_dialog.dart';
import 'package:nearbymenus/app/common_widgets/platform_progress_indicator.dart';
import 'package:nearbymenus/app/models/restaurant.dart';
import 'package:nearbymenus/app/pages/menu_browser/expandable_menu_browser.dart';
import 'package:nearbymenus/app/pages/session/check_staff_authorization.dart';
import 'package:nearbymenus/app/pages/session/restaurant_list_tile.dart';
import 'package:nearbymenus/app/services/database.dart';
import 'package:nearbymenus/app/models/session.dart';
import 'package:provider/provider.dart';

class RestaurantList extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final List<Restaurant> nearbyRestaurantsList;
  final bool stillLoading;

  const RestaurantList({Key key, this.scaffoldKey, this.nearbyRestaurantsList, this.stillLoading}) : super(key: key);
  @override
  _RestaurantListState createState() => _RestaurantListState();
}

class _RestaurantListState extends State<RestaurantList> {
  Session session;
  Database database;

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

  void _expandableMenuBrowserPage(BuildContext context, int index) {
    session.currentRestaurant = nearbyRestaurantsList[index];
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: false,
        builder: (context) => ExpandableMenuBrowser(),
      ),
    );
  }

  void _staffAuthorizationPage(BuildContext context, int index) {
    session.currentRestaurant = nearbyRestaurantsList[index];
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: false,
        builder: (context) => CheckStaffAuthorization(scaffoldKey: widget.scaffoldKey,),
      ),
    );
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
                    onTap: () {
                      if (session.role == ROLE_PATRON) {
                        _expandableMenuBrowserPage(context, index);
                      } else {
                        _staffAuthorizationPage(context, index);
                      }
                    },
                  ),
                );
              });
    } else {
      if (!widget.stillLoading) {
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
      } else {
        return Center(child: PlatformProgressIndicator());
      }
    }
  }
}
