import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData createTheme (BuildContext context){
    var textTheme = GoogleFonts.montserratTextTheme(Theme.of(context).textTheme);
    // var theme = GoogleFonts.ralewayTextTheme(Theme.of(context).textTheme);
    // var theme = GoogleFonts.ubuntuTextTheme(Theme.of(context).textTheme);
    // var theme = GoogleFonts.cabinTextTheme(Theme.of(context).textTheme);
    // var theme = GoogleFonts.abelTextTheme(Theme.of(context).textTheme);
    // var theme = GoogleFonts.fjallaOneTextTheme(Theme.of(context).textTheme);
    // var theme = GoogleFonts.gayathriTextTheme(Theme.of(context).textTheme);
    // var theme = GoogleFonts.comfortaaTextTheme(Theme.of(context).textTheme);
    // var theme = GoogleFonts.promptTextTheme(Theme.of(context).textTheme);
    // var theme = GoogleFonts.orbitronTextTheme(Theme.of(context).textTheme);
    return ThemeData(
      brightness: Brightness.dark,
        backgroundColor: Colors.black,
        // primaryColor: Colors.black,
        primarySwatch: Colors.purple,
        accentColor: Colors.pink[100],
        accentColorBrightness: Brightness.light,
        textTheme: textTheme,
        appBarTheme: AppBarTheme(textTheme: textTheme),
    );
  }
}