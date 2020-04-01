import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nearbymenus/app/common_widgets/form_submit_button.dart';
import 'package:nearbymenus/app/common_widgets/platform_alert_dialog.dart';
import 'package:nearbymenus/app/models/nearest_restaurant.dart';
import 'package:nearbymenus/app/models/user_details.dart';
import 'package:nearbymenus/app/services/database.dart';
import 'package:nearbymenus/app/models/session.dart';
import 'package:provider/provider.dart';

class RestaurantList extends StatefulWidget {
  final List<NearestRestaurant> nearbyRestaurantsList;

  const RestaurantList({Key key, this.nearbyRestaurantsList}) : super(key: key);
  @override
  _RestaurantListState createState() => _RestaurantListState();
}

class _RestaurantListState extends State<RestaurantList> {
  Session session;
  Database database;

  List<NearestRestaurant> get nearbyRestaurantsList =>
      widget.nearbyRestaurantsList;

  void _setNearestRestaurant(int index) {
    var complexName = '';
    var nearestRestaurantName = 'None selected';
    var nearestRestaurant = NearestRestaurant(name: nearestRestaurantName);
    if (index != -1) {
      complexName = nearbyRestaurantsList[index].complexName;
      nearestRestaurantName = nearbyRestaurantsList[index].name;
      nearestRestaurant = nearbyRestaurantsList[index];
    }
    database.setUserDetails(UserDetails(
        name: session.userDetails.name,
        address: session.userDetails.address,
        complexName: complexName,
        nearestRestaurant: nearestRestaurantName,
        role: session.userDetails.role,
        deviceName: session.userDetails.deviceName));
    session.nearestRestaurant = nearestRestaurant;
    session.restaurantsFound = true;
  }

  Widget _buildTitle(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          nearbyRestaurantsList[index].name,
          style: Theme.of(context).textTheme.headline,
        ),
        SizedBox(
          height: 8.0,
        ),
        Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Icon(Icons.home, size: 20.0,),
            ),
            Text(
              nearbyRestaurantsList[index].complexName,
              //style: Theme.of(context).textTheme.subhead,
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Icon(Icons.restaurant, size: 20.0,),
            ),
            Text(
              nearbyRestaurantsList[index].restaurant.typeOfFood,
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Icon(Icons.info_outline, size: 20.0,),
            ),
            Text(
              nearbyRestaurantsList[index].restaurant.notes,
            ),
          ],
        ),
        _buildSubtitle(index),
      ],
    );
  }

  Widget _buildSubtitle(int index) {
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);
    final String hoursFrom = localizations.formatTimeOfDay(nearbyRestaurantsList[index].restaurant.workingHoursFrom);
    final String hoursTo = localizations.formatTimeOfDay(nearbyRestaurantsList[index].restaurant.workingHoursTo);
    final status = nearbyRestaurantsList[index].restaurant.open
        ? 'Open'
        : 'Closed';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Icon(Icons.access_time, size: 20.0,),
            ),
            Text(
              '$hoursFrom  - $hoursTo ($status)',
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Icon(Icons.call, size: 20.0,),
            ),
            Text(
              nearbyRestaurantsList[index].restaurant.telephoneNumber,
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                'Payment methods on delivery: ',
              ),
            ),
            if (nearbyRestaurantsList[index].restaurant.acceptCash)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.euro_symbol, size: 14.0,),
            ),
            if (nearbyRestaurantsList[index].restaurant.acceptCard)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.credit_card, size: 14.0,),
            ),
            if (nearbyRestaurantsList[index].restaurant.acceptZapper)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.flash_on, size: 14.0,),
            ),
          ],
        ),
      ],
    );
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
                    //leading: Icon(Icons.restaurant),
                    title: _buildTitle(index),
                    trailing: Text(
                      nearbyRestaurantsList[index].distance.round().toString() +
                          'm',
                    ),
                    subtitle: _buildSubtitle(index),
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
              Text('No restaurants found near you'),
              SizedBox(height: 32.0,),
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
