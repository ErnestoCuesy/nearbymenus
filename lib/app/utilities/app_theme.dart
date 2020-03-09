import 'package:flutter/material.dart';
import 'package:nearbymenus/app/config/flavour_config.dart';
import 'package:nearbymenus/app/utilities/brown_theme.dart';
import 'package:nearbymenus/app/utilities/greenish_theme.dart';
import 'package:nearbymenus/app/utilities/purple_theme.dart';

class AppTheme {
  static ThemeData createTheme(BuildContext context) {
    ThemeData theme;
    switch (FlavourConfig.instance.colorTheme) {
      case ColorTheme.PURPLE: {
        theme = PurpleTheme.theme;
      }
      break;
      case ColorTheme.BROWN: {
        theme = BrownTheme.theme;
      }
      break;
      case ColorTheme.GREENISH: {
        theme = GreenishTheme.theme;
      }
      break;
    }
    return theme;
  }
}
