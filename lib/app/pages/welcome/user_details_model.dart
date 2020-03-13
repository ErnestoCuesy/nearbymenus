import 'package:flutter/foundation.dart';
import 'package:nearbymenus/app/models/user_details.dart';
import 'package:nearbymenus/app/pages/sign_in/validators.dart';
import 'package:nearbymenus/app/services/database.dart';

class UserDetailsModel with UserCredentialsValidators, ChangeNotifier {
  final Database database;
  String userName;
  String userAddress;
  String userLocation;
  String userRole;
  String deviceName;
  bool isLoading;
  bool submitted;

  UserDetailsModel({
    @required this.database,
    this.userName,
    this.userAddress,
    this.userLocation,
    this.userRole,
    this.isLoading = false,
    this.submitted = false,
  });

  Future<void> save() async {
    updateWith(isLoading: true, submitted: true);
    try {
      await database.setUserDetails(
        UserDetails(
          userName: userName,
          userAddress: userAddress,
          userLocation: userLocation,
          userRole: 'none',
          userDeviceName: deviceName
        ),
      );
    } catch (e) {
      print(e);
      updateWith(isLoading: false);
      rethrow;
    }
  }

  String get primaryButtonText => 'Save';

  bool get canSave {
    bool canSubmitFlag = false;
    if (userNameValidator.isValid(userName) &&
        userAddressValidator.isValid(userAddress) &&
        userLocationValidator.isValid(userLocation) &&
        !isLoading) {
      canSubmitFlag = true;
    }
    return canSubmitFlag;
  }

  String get userNameErrorText {
    bool showErrorText = !userNameValidator.isValid(userName);
    return showErrorText ? invalidUsernameErrorText : null;
  }

  String get userAddressErrorText {
    bool showErrorText = !userAddressValidator.isValid(userAddress);
    return showErrorText ? invalidAddressErrorText : null;
  }

  String get userLocationErrorText {
    // TODO implement a validator for location
    bool showErrorText = !userLocationValidator.isValid(userLocation);
    return showErrorText ? invalidLocationErrorText : null;
  }

  void updateUserName(String userName) => updateWith(userName: userName);

  void updateUserAddress(String userAddress) =>
      updateWith(userAddress: userAddress);

  void updateUserLocation(String userLocation) =>
      updateWith(userLocation: userLocation);

  void updateUserRole(String userRole) =>
      updateWith(userRole: userRole);

  void updateWith({
    String userName,
    String userAddress,
    String userLocation,
    String userRole,
    bool isLoading,
    bool submitted,
  }) {
    this.userName = userName ?? this.userName;
    this.userAddress = userAddress ?? this.userAddress;
    this.userLocation = userLocation ?? this.userLocation;
    this.userRole = userRole ?? this.userRole;
    this.isLoading = isLoading ?? this.isLoading;
    this.submitted = this.submitted;
    notifyListeners();
  }
}
