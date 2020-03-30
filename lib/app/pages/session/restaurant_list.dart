import 'package:flutter/material.dart';
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
  List<NearestRestaurant> get nearbyRestaurantsList => widget.nearbyRestaurantsList;
  @override
  Widget build(BuildContext context) {
    final session = Provider.of<Session>(context);
    final database = Provider.of<Database>(context, listen: true);
    return  ListView.builder(
          itemCount: nearbyRestaurantsList.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child: ListTile(
                leading: Icon(Icons.restaurant),
                title: Text(nearbyRestaurantsList[index].name),
                subtitle: Text(nearbyRestaurantsList[index].complexName),
                trailing: Text(nearbyRestaurantsList[index].distance.round().toString() + 'm'),
                onTap: () {
                  database.setUserDetails(UserDetails(
                    name: session.userDetails.name,
                    address: session.userDetails.address,
                    complexName: nearbyRestaurantsList[index].complexName,
                    nearestRestaurant: nearbyRestaurantsList[index].name,
                    role: session.userDetails.role,
                    deviceName: session.userDetails.deviceName
                  ));
                  session.nearestRestaurant = nearbyRestaurantsList[index];
                  session.restaurantsFound = true;
                },
              ),
            );
          });
  }
}
