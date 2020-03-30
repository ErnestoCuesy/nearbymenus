import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

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
  final String notes;
  final bool active;
  final bool open;
  final bool acceptingStaffRequests;

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
    this.notes,
    this.active,
    this.open,
    this.acceptingStaffRequests,
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
        notes: value['notes'],
        active: value['active'],
        open: value['open'],
        acceptingStaffRequests: value['acceptingStaffRequests']
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
      'notes': notes,
      'active': active,
      'open': open,
      'acceptingStaffRequests': acceptingStaffRequests
    };
  }
}
