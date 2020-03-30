import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:nearbymenus/app/models/user_details.dart';
import 'package:nearbymenus/app/pages/sign_in/validators.dart';
import 'package:nearbymenus/app/services/database.dart';

class UserDetailsModel with UserDetailsValidators, ChangeNotifier {
  final Database database;
  String userName;
  String userAddress;
  String userLocation;
  String userNearestRestaurant;
  String userRole;
  String deviceName;
  bool isLoading;
  bool submitted;

  UserDetailsModel({
    @required this.database,
    this.userName,
    this.userAddress,
    this.userLocation,
    this.userNearestRestaurant,
    this.userRole,
    this.isLoading = false,
    this.submitted = false,
  });

  Future<void> save() async {
    updateWith(isLoading: true, submitted: true);
    try {
      await database.setUserDetails(
        UserDetails(
          name: userName,
          address: userAddress,
          complexName: userLocation,
          nearestRestaurant: userNearestRestaurant,
          role: userRole,
          deviceName: deviceName
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

  void updateUserName(String userName) => updateWith(userName: userName);

  void updateUserAddress(String userAddress) =>
      updateWith(userAddress: userAddress);

  void updateUserLocation(String userLocation) =>
      updateWith(userLocation: userLocation);

  void updateUserNearestRestaurant(String userNearestRestaurant) =>
      updateWith(userNearestRestaurant: userNearestRestaurant);

  void updateUserRole(String userRole) =>
      updateWith(userRole: userRole);

  void updateWith({
    String userName,
    String userAddress,
    String userLocation,
    String userNearestRestaurant,
    String userRole,
    bool isLoading,
    bool submitted,
  }) {
    this.userName = userName ?? this.userName;
    this.userAddress = userAddress ?? this.userAddress;
    this.userLocation = userLocation ?? this.userLocation;
    this.userNearestRestaurant = userNearestRestaurant ?? this.userNearestRestaurant;
    this.userRole = userRole ?? this.userRole;
    this.isLoading = isLoading ?? this.isLoading;
    this.submitted = this.submitted;
    notifyListeners();
  }
}
