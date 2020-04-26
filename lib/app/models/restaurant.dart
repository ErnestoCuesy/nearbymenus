import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nearbymenus/app/services/database.dart';

class Restaurant {
  final String id;
  final String managerId;
  final String name;
  final String restaurantLocation;
  final String typeOfFood;
  final Position coordinates;
  final int deliveryRadius;
  final TimeOfDay workingHoursFrom;
  final TimeOfDay workingHoursTo;
  final String telephoneNumber;
  final String notes;
  final bool active;
  final bool open;
  final bool acceptingStaffRequests;
  final bool acceptCash;
  final bool acceptCard;
  final bool acceptZapper;
  final Map<String, dynamic> restaurantFlags;
  final Map<String, dynamic> paymentFlags;
  final Map<dynamic, dynamic> restaurantMenus;

  Restaurant({
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
    this.active,
    this.open,
    this.acceptingStaffRequests,
    this.acceptCash,
    this.acceptCard,
    this.acceptZapper,
    this.restaurantFlags,
    this.paymentFlags,
    this.restaurantMenus,
  });

  factory Restaurant.fromMap(Map<dynamic, dynamic> value, String documentId) {
    if (value == null) {
      return null;
    }
    final geoPoint = value['coordinates'] as GeoPoint;
    final int deliveryRadius = value['deliveryRadius'];
    final hoursFromHours = value['hoursFromHours'];
    final hoursFromMinutes = value['hoursFromMinutes'];
    final hoursToHours = value['hoursToHours'];
    final hoursToMinutes = value['hoursToMinutes'];
    return Restaurant(
        id: documentId,
        managerId: value['managerId'],
        name: value['name'],
        typeOfFood: value['typeOfFood'],
        restaurantLocation: value['restaurantLocation'],
        coordinates: Position(
            latitude: geoPoint.latitude, longitude: geoPoint.longitude),
        deliveryRadius: deliveryRadius,
        workingHoursFrom: TimeOfDay(hour: hoursFromHours, minute: hoursFromMinutes),
        workingHoursTo: TimeOfDay(hour: hoursToHours, minute: hoursToMinutes),
        telephoneNumber: value['telephoneNumber'],
        notes: value['notes'],
        active: value['restaurantFlags']['active'],
        open: value['restaurantFlags']['open'],
        acceptingStaffRequests: value['restaurantFlags']['acceptingStaffRequests'],
        acceptCash: value['paymentFlags']['acceptCash'],
        acceptCard: value['paymentFlags']['acceptCard'],
        acceptZapper: value['paymentFlags']['acceptZapper'],
        restaurantFlags: value['restaurantFlags'],
        paymentFlags: value['paymentFlags'],
        restaurantMenus: value['restaurantMenus'] ?? {},
    );
  }

  Map<String, dynamic> toMap() {
    final GeoPoint geoPoint =
        GeoPoint(coordinates.latitude, coordinates.longitude);
    return <String, dynamic>{
      'id': id,
      'managerId': managerId,
      'name': name,
      'typeOfFood': typeOfFood,
      'restaurantLocation': restaurantLocation,
      'coordinates': geoPoint,
      'deliveryRadius': deliveryRadius,
      'hoursFromHours': workingHoursFrom.hour,
      'hoursFromMinutes': workingHoursFrom.minute,
      'hoursToHours': workingHoursTo.hour,
      'hoursToMinutes': workingHoursTo.minute,
      'telephoneNumber': telephoneNumber,
      'notes': notes,
      'restaurantFlags': restaurantFlags,
      'paymentFlags': paymentFlags,
      'restaurantMenus': restaurantMenus ?? {},
    };
  }

  static Future<void> setRestaurant(Database database, Restaurant restaurant) async {
    await database.setRestaurant(restaurant);
  }
}
