import 'package:flutter/material.dart';

import 'enumerations.dart';

class Discount {
  final String discountName;
  final Day day;
  final TimeOfDay fromHour;
  final TimeOfDay toHour;
  final double discount;

  Discount(this.day, this.fromHour, this.toHour, this.discount, this.discountName);
}
