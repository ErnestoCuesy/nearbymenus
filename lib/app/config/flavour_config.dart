import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

enum Flavour {
  DEV,
  PROD
}

class StringUtils {
  static String enumName(String enumToString) {
    List<String> paths = enumToString.split('.');
    return paths[paths.length - 1];
  }
}

class FlavourValues {
  final String databaseName;

  FlavourValues({@required this.databaseName});
}

class FlavourConfig {
  final Flavour flavour;
  final String name;
  final Color color;
  final FlavourValues values;
  static FlavourConfig _instance;

  factory FlavourConfig({
    @required Flavour flavour,
    Color color: Colors.blue,
    @required FlavourValues values}) {
    _instance ??= FlavourConfig._internal(flavour, StringUtils.enumName(flavour.toString()), color, values);
    return _instance;
  }

  FlavourConfig._internal(this.flavour, this.name, this.color, this.values);
  static FlavourConfig get instance => _instance;
  static bool isProduction() => _instance.flavour == Flavour.PROD;
  static bool isDevelopment() => _instance.flavour == Flavour.DEV;
}