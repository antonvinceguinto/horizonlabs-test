import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomThemeData {
  static ThemeData lightTheme() {
    return ThemeData(
      primaryColor: Colors.blue,
      cupertinoOverrideTheme: const NoDefaultCupertinoThemeData(
        textTheme: CupertinoTextThemeData(
          navLargeTitleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: const Color(0xFFf9f9f9),
      textTheme: TextTheme(
        headline6: TextStyle(
          color: Colors.black,
        ),
        bodyText2: TextStyle(
          color: Colors.black,
        ),
      ),
      appBarTheme: const AppBarTheme(
        iconTheme: IconThemeData(
          color: Colors.black,
          size: 16,
        ),
        color: Colors.white,
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
      ),
    );
  }

  static ThemeData darkTheme() {
    return ThemeData.dark().copyWith(
      cupertinoOverrideTheme: const NoDefaultCupertinoThemeData(
        textTheme: CupertinoTextThemeData(
          navLargeTitleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: const Color(0xFF2a2a2a),
      textTheme: TextTheme(
        headline6: TextStyle(
          color: Colors.white,
        ),
        bodyText2: TextStyle(
          color: Colors.white,
        ),
      ),
      appBarTheme: const AppBarTheme(
        iconTheme: IconThemeData(
          color: Colors.white,
          size: 16,
        ),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    );
  }
}
