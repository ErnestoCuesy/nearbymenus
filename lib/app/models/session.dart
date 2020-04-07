import 'package:geolocator/geolocator.dart';
import 'package:nearbymenus/app/models/restaurant.dart';
import 'package:nearbymenus/app/models/user_details.dart';
import 'package:nearbymenus/app/services/iap_manager.dart';

class Session {
  final Position position;
  UserDetails userDetails = UserDetails();
  Restaurant nearestRestaurant;
  bool restaurantsFound = false;
  Subscription subscription = Subscription();

  Session({this.position});

  void setUserDetails(UserDetails userDetails) {
    this.userDetails = userDetails;
    this.nearestRestaurant = nearestRestaurant ?? Restaurant(id: '');
  }

  void setSubscription(Subscription subscription) {
    this.subscription = subscription != null ? subscription : this.subscription;
  }

  void signOut() {
    this.userDetails.deviceName = '';
  }

}
