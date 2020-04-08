import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nearbymenus/app/models/restaurant.dart';

class RestaurantListTile extends StatelessWidget {
  final Restaurant restaurant;
  final bool restaurantFound;

  const RestaurantListTile({Key key, this.restaurant, this.restaurantFound})
      : super(key: key);

  Widget _buildTitle(BuildContext context) {
    if (!restaurantFound) {
      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'No restaurants found near you',
              style: Theme.of(context).textTheme.subhead,
            ),
            SizedBox(
              height: 8.0,
            ),
          ]);
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            restaurant.name,
            style: Theme.of(context).textTheme.headline,
          ),
          SizedBox(
            height: 8.0,
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Icon(
                  Icons.home,
                  size: 20.0,
                ),
              ),
              Text(
                restaurant.restaurantLocation,
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Icon(
                  Icons.restaurant,
                  size: 20.0,
                ),
              ),
              Text(
                restaurant.typeOfFood,
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Icon(
                  Icons.info_outline,
                  size: 20.0,
                ),
              ),
              Text(
                restaurant.notes,
              ),
            ],
          ),
          _buildSubtitle(context),
        ],
      );
    }
  }

  Widget _buildSubtitle(BuildContext context) {
    final currencySymbol = NumberFormat.simpleCurrency(locale: "en_ZA");
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final String hoursFrom =
        localizations.formatTimeOfDay(restaurant.workingHoursFrom);
    final String hoursTo =
        localizations.formatTimeOfDay(restaurant.workingHoursTo);
    final status = restaurant.open ? 'Open' : 'Closed';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Icon(
                Icons.access_time,
                size: 20.0,
              ),
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
              child: Icon(
                Icons.call,
                size: 20.0,
              ),
            ),
            Text(
              restaurant.telephoneNumber,
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                'Payment on delivery: ',
              ),
            ),
            if (restaurant.acceptCash)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(currencySymbol.currencySymbol),
              ),
            if (restaurant.acceptCard)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.credit_card,
                  size: 14.0,
                ),
              ),
            if (restaurant.acceptZapper)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.flash_on,
                  size: 14.0,
                ),
              ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (restaurant.id == '') {
      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'No restaurant selected. Tap to search for nearby Restaurants',
              style: Theme.of(context).textTheme.headline,
            ),
          ]);
    } else {
      return _buildTitle(context);
    }
  }
}
