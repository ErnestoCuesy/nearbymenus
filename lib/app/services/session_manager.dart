import 'package:nearbymenus/app/models/user_details.dart';
import 'package:nearbymenus/app/services/auth.dart';
import 'package:nearbymenus/app/services/database.dart';
import 'package:nearbymenus/app/services/device_info.dart';

class SessionManager {
  final AuthBase auth = Auth();
  final DeviceInfo deviceInfo = DeviceInfo();
  UserDetails userDetails;

  void setUserDetails(UserDetails userDetails) {
    this.userDetails = userDetails;
  }

  void signOut() {
    this.userDetails.userDeviceName = '';
  }
}
