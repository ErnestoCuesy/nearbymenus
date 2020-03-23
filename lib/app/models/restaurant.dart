import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'enumerations.dart';
import 'menu_item.dart';

class Restaurant {
  final String name;
  final String complexName;
  final String description;
  final Position coordinates;
  final int deliveryRadius;
  final TimeOfDay workingHoursFrom;
  final TimeOfDay workingHoursTo;
  final List<MenuItem> menu;
  final RestaurantStatus status;

  Restaurant({this.name, this.complexName, this.description, this.coordinates, this.deliveryRadius, this.workingHoursFrom, this.workingHoursTo, this.menu, this.status});

  factory Restaurant.fromMap(Map<dynamic, dynamic> value, String id) {
    if (value == null) {
      return null;
    }
    final geoPoint = value['coordinates'] as GeoPoint;
    final int deliveryRadius = value['deliveryRadius'];
    return Restaurant(
      name: value['name'],
      complexName: value['complexName'],
      coordinates: Position(latitude: geoPoint.latitude, longitude: geoPoint.longitude),
      deliveryRadius: deliveryRadius,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'complexName': complexName,
      'description': description,
      'coordinates': coordinates.toString(),
      'deliveryRadius': deliveryRadius,
    };
  }

}


