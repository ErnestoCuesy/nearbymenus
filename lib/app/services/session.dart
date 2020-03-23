import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:nearbymenus/app/models/nearest_restaurant.dart';
import 'package:nearbymenus/app/models/user_details.dart';

class Session {
  final Position position;
  static final StreamController controller = StreamController.broadcast();
  UserDetails userDetails = UserDetails();
  NearestRestaurant nearestRestaurant;
  List<NearestRestaurant> nearbyRestaurants;
  bool restaurantsFound = false;

  Session({this.position});

  final Stream<List<NearestRestaurant>> restaurantStream = controller.stream.map((restaurants) {
    return restaurants;
  });

  void setUserDetails(UserDetails userDetails) {
    this.userDetails = userDetails;
  }

  void signOut() {
    this.userDetails.deviceName = '';
  }

  void dispose() {
    controller.close();
  }
}
