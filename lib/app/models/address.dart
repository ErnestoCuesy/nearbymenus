import 'package:location/location.dart';

class Address {
  final String complexName;
  final int unitNumber;
  final String streetName;
  final String suburb;
  final String province;
  final LocationData gpsLocation;

  Address(this.complexName, this.unitNumber, this.streetName, this.suburb, this.province, this.gpsLocation);
}
