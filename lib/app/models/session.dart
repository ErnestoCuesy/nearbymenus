import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:nearbymenus/app/models/nearest_restaurant.dart';
import 'package:nearbymenus/app/models/restaurant.dart';
import 'package:nearbymenus/app/models/user_details.dart';

class Session {
  final Position position;
  static final StreamController controller = StreamController.broadcast();
  UserDetails userDetails = UserDetails();
  NearestRestaurant nearestRestaurant;
  bool restaurantsFound = false;

  Session({this.position});

  void setUserDetails(UserDetails userDetails) {
    this.userDetails = userDetails;
    this.nearestRestaurant = NearestRestaurant(
      name: userDetails.nearestRestaurant,
      complexName: userDetails.complexName,
      restaurant: Restaurant(),
      distance: 0.0,
    );
  }

  void signOut() {
    this.userDetails.deviceName = '';
  }

  void dispose() {
    controller.close();
  }
}
