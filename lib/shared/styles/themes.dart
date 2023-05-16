// ignore_for_file: deprecated_member_use

import 'package:date_in_firebase/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class MyTheme {
  static ThemeData lightTheme = ThemeData(
      brightness: Brightness.light,
      backgroundColor: Appcolors.white,
      fontFamily: "Montserrat",
      textTheme: TextTheme(
        headline1: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
          color: Appcolors.black,
        ),
        subtitle1: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w500,
          color: Colors.grey,
        ),
      ));

  static ThemeData darkTheme = ThemeData(
      brightness: Brightness.dark,
      backgroundColor: Appcolors.black,
      fontFamily: "Montserrat",
      textTheme: const TextTheme(
        headline1: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: Appcolors.white,
        ),
        subtitle1: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w300,
          color: Appcolors.white,
        ),
      ));
}
