import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'address.dart';
import 'enumerations.dart';
import 'menu_item.dart';

class Restaurant {
  final String name;
  final String description;
  final Address address;
  final TimeOfDay workingHoursFrom;
  final TimeOfDay workingHoursTo;
  final List<MenuItem> menu;
  final RestaurantStatus status;

  Restaurant(this.name, this.description, this.address, this.workingHoursFrom, this.workingHoursTo, this.menu, this.status);
}


