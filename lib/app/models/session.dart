import 'package:geolocator/geolocator.dart';
import 'package:nearbymenus/app/models/order.dart';
import 'package:nearbymenus/app/models/restaurant.dart';
import 'package:nearbymenus/app/models/user_details.dart';
import 'package:nearbymenus/app/services/iap_manager.dart';

const String ROLE_NONE = 'None';
const String ROLE_MANAGER = 'Manager';
const String ROLE_STAFF = 'Staff';
const String ROLE_PATRON = 'Patron';
const String ROLE_CHECK_SUBSCRIPTION = 'Subscription';

class Session {
  final Position position;
  final String role;
  UserDetails userDetails = UserDetails();
  Restaurant currentRestaurant;
  bool restaurantsFound = false;
  Subscription subscription = Subscription();
  bool restaurantAccessGranted = false;
  Order currentOrder;

  Session({this.position, this.role});

  void setUserDetails(UserDetails userDetails) {
    this.userDetails = userDetails;
  }

  void setSubscription(Subscription subscription) {
    this.subscription = subscription != null ? subscription : this.subscription;
  }

}
