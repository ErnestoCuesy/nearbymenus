import 'package:geolocator/geolocator.dart';
import 'package:nearbymenus/app/models/restaurant.dart';
import 'package:nearbymenus/app/models/user_details.dart';

class Session {
  final Position position;
  UserDetails userDetails = UserDetails();
  Restaurant nearestRestaurant;
  bool restaurantsFound = false;

  Session({this.position});

  void setUserDetails(UserDetails userDetails) {
    this.userDetails = userDetails;
    this.nearestRestaurant = nearestRestaurant ?? Restaurant(id: '');
  }

  void signOut() {
    this.userDetails.deviceName = '';
  }

}
