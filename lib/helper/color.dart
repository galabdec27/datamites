import 'package:flutter/material.dart';

class MainColor {
  Color black = Colors.black;
  Color white = Colors.white;
  Color textColor = const Color(0xff000000);
  static Color textBlue = const Color(0xff143A5D);
  static Color textColorConst = const Color(0xff000000);
  static Color textColorFaint = const Color(0xfff8f8f8);
  static Color lightBlue = const Color(0xffDEEBFF);
  static Color darkBlue = const Color(0xff003399);
  static Color lightGreen = const Color(0xffE2FFEE);
  static Color darkGreen = const Color(0xff00875A);
  static Color lightRed = const Color(0xffFFEBE5);
  static Color darkRed = const Color(0xffDE350B);
  static Color lightOrange = Colors.yellow.shade100;
  static Color darkOrange = Colors.deepOrange;
  static Color datamiteOrange = const Color(0xffF38F1E);
  static Color lightGrey = const Color(0xffDEDEDE);
  static Color darkGrey = const Color(0xff4D4D4D);

  Color getMainColor() {
    return textColor;
  }
}
