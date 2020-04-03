import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nearbymenus/app/models/restaurant.dart';
import 'package:nearbymenus/app/models/session.dart';
import 'package:nearbymenus/app/pages/sign_in/validators.dart';
import 'package:nearbymenus/app/services/database.dart';

class RestaurantDetailsModel with RestaurantDetailsValidators, ChangeNotifier {
  final Database database;
  final Session session;
  String id;
  String managerId;
  String name;
  String restaurantLocation;
  String typeOfFood;
  Position coordinates;
  int deliveryRadius;
  TimeOfDay workingHoursFrom;
  TimeOfDay workingHoursTo;
  String telephoneNumber;
  String notes;
  bool active;
  bool open;
  bool acceptingStaffRequests;
  bool acceptCash;
  bool acceptCard;
  bool acceptZapper;
  bool isLoading;
  bool submitted;

  RestaurantDetailsModel({
    @required this.database,
    this.session,
    this.id,
    this.managerId,
    this.name,
    this.restaurantLocation,
    this.typeOfFood,
    this.coordinates,
    this.deliveryRadius,
    this.workingHoursFrom,
    this.workingHoursTo,
    this.telephoneNumber,
    this.notes,
    this.active = false,
    this.open = false,
    this.acceptingStaffRequests = false,
    this.acceptCash = false,
    this.acceptCard = false,
    this.acceptZapper = false,
    this.isLoading = false,
    this.submitted = false,
  });

  Future<void> save() async {
    updateWith(isLoading: true, submitted: true);
    if (id == null || id == '') {
      id = documentIdFromCurrentDate();
    }
    try {
      await database.setRestaurantDetails(
        Restaurant(
            id: id,
            managerId: database.userId,
            name: name,
            restaurantLocation: restaurantLocation,
            typeOfFood: typeOfFood,
            coordinates: session.position,
            deliveryRadius: deliveryRadius,
          workingHoursFrom: workingHoursFrom,
          workingHoursTo: workingHoursTo,
          telephoneNumber: telephoneNumber,
          notes: notes,
          open: open,
          active: active,
          acceptingStaffRequests: acceptingStaffRequests,
          acceptCash: acceptCash,
          acceptCard: acceptCard,
          acceptZapper: acceptZapper,
        ),
      );
      await database.setUserDetails(session.userDetails);
    } catch (e) {
      print(e);
      updateWith(isLoading: false);
      rethrow;
    }
  }

  String get primaryButtonText => 'Save';

  bool get canSave {
    bool canSubmitFlag = false;
    if (restaurantNameValidator.isValid(name) &&
        restaurantLocationValidator.isValid(restaurantLocation) &&
        typeOfFoodValidator.isValid(typeOfFood) &&
        deliveryRadiusValidator.isValid(deliveryRadius) &&
        telephoneNumberValidator.isValid(telephoneNumber) &&
        workingHoursFrom != null && workingHoursTo != null &&
        !isLoading) {
      canSubmitFlag = true;
    }
    return canSubmitFlag;
  }

  String get restaurantNameErrorText {
    bool showErrorText = !restaurantNameValidator.isValid(name);
    return showErrorText ? invalidRestaurantNameErrorText : null;
  }

  String get restaurantLocationErrorText {
    bool showErrorText = !restaurantLocationValidator.isValid(restaurantLocation);
    return showErrorText ? invalidRestaurantLocationErrorText : null;
  }

  String get typeOfFoodErrorText {
    bool showErrorText = !typeOfFoodValidator.isValid(typeOfFood);
    return showErrorText ? invalidTypeOfFoodErrorText : null;
  }

  String get deliveryRadiusErrorText {
    bool showErrorText = !deliveryRadiusValidator.isValid(deliveryRadius);
    return showErrorText ? invalidDeliveryRadiusErrorText : null;
  }

  String get telephoneNumberErrorText {
    bool showErrorText = !telephoneNumberValidator.isValid(telephoneNumber);
    return showErrorText ? invalidTelephoneNumberErrorText : null;
  }

  void updateRestaurantName(String name) => updateWith(name: name);

  void updateRestaurantLocation(String restaurantLocation) =>
      updateWith(restaurantLocation: restaurantLocation);

  void updateTypeOfFood(String typeOfFood) =>
      updateWith(typeOfFood: typeOfFood);

  void updateCoordinates(Position coordinates) =>
      updateWith(coordinates: coordinates);

  void updateDeliveryRadius(int deliveryRadius) =>
      updateWith(deliveryRadius: deliveryRadius);

  void updateWorkingHoursFrom(TimeOfDay workingHoursFrom) =>
      updateWith(workingHoursFrom: workingHoursFrom);

  void updateWorkingHoursTo(TimeOfDay workingHoursTo) =>
      updateWith(workingHoursTo: workingHoursTo);

  void updateTelephoneNumber(String telephoneNumber) =>
      updateWith(telephoneNumber: telephoneNumber);

  void updateNotes(String notes) =>
      updateWith(notes: notes);

  void updateActive(bool active) =>
      updateWith(active: active);

  void updateOpen(bool open) =>
      updateWith(open: open);

  void updateAcceptingStaffRequests(bool acceptingStaffRequests) =>
      updateWith(acceptingStaffRequests: acceptingStaffRequests);

  void updateAcceptCash(bool acceptCash) =>
      updateWith(acceptCash: acceptCash);

  void updateAcceptCard(bool acceptCard) =>
      updateWith(acceptCard: acceptCard);

  void updateAcceptZapper(bool acceptZapper) =>
      updateWith(acceptZapper: acceptZapper);

  void updateWith({
    String name,
    String restaurantLocation,
    String typeOfFood,
    Position coordinates,
    int deliveryRadius,
    TimeOfDay workingHoursFrom,
    TimeOfDay workingHoursTo,
    String telephoneNumber,
    String notes,
    bool active,
    bool open,
    bool acceptingStaffRequests,
    bool acceptCash,
    bool acceptCard,
    bool acceptZapper,
    bool isLoading,
    bool submitted,
  }) {
    this.name = name ?? this.name;
    this.restaurantLocation = restaurantLocation ?? this.restaurantLocation;
    this.typeOfFood = typeOfFood ?? this.typeOfFood;
    this.coordinates = coordinates ?? this.coordinates;
    this.deliveryRadius = deliveryRadius ?? this.deliveryRadius;
    this.workingHoursFrom = workingHoursFrom ?? this.workingHoursFrom;
    this.workingHoursTo = workingHoursTo ?? this.workingHoursTo;
    this.telephoneNumber = telephoneNumber ?? this.telephoneNumber;
    this.notes = notes ?? this.notes;
    this.active = active ?? this.active;
    this.open = open ?? this.open;
    this.acceptingStaffRequests = acceptingStaffRequests ?? this.acceptingStaffRequests;
    this.acceptCash = acceptCash ?? this.acceptCash;
    this.acceptCard = acceptCard ?? this.acceptCard;
    this.acceptZapper = acceptZapper ?? this.acceptZapper;
    this.isLoading = isLoading ?? this.isLoading;
    this.submitted = this.submitted;
    notifyListeners();
  }
}
