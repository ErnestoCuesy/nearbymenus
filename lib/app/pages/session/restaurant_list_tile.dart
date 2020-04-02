import 'package:flutter/material.dart';
import 'package:nearbymenus/app/models/nearest_restaurant.dart';

class RestaurantListTile extends StatelessWidget {
  final NearestRestaurant nearbyRestaurant;

  const RestaurantListTile({Key key, this.nearbyRestaurant}) : super(key: key);

  Widget _buildTitle(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          nearbyRestaurant.name,
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
              nearbyRestaurant.complexName,
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
              nearbyRestaurant.restaurant.typeOfFood,
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
              nearbyRestaurant.restaurant.notes,
            ),
          ],
        ),
        _buildSubtitle(context),
      ],
    );
  }

  Widget _buildSubtitle(BuildContext context) {
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);
    final String hoursFrom = localizations.formatTimeOfDay(nearbyRestaurant.restaurant.workingHoursFrom);
    final String hoursTo = localizations.formatTimeOfDay(nearbyRestaurant.restaurant.workingHoursTo);
    final status = nearbyRestaurant.restaurant.open
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
              nearbyRestaurant.restaurant.telephoneNumber,
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
            if (nearbyRestaurant.restaurant.acceptCash)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.euro_symbol, size: 14.0,),
              ),
            if (nearbyRestaurant.restaurant.acceptCard)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.credit_card, size: 14.0,),
              ),
            if (nearbyRestaurant.restaurant.acceptZapper)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.flash_on, size: 14.0,),
              ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTitle(context);
  }
}
