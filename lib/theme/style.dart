import 'package:flutter/material.dart';

const Color amarilloSolidaria1 = Color(0xffef8e00);
const Color azulSolidaria1 = Color(0xff003f75);
const Color amarilloSolidaria2 = Color(0xfff8ae00);
const Color amarilloSolidaria3 = Color(0xfff0ad4e);
const Color azulSolidaria2 = Color(0xff428bca);

ThemeData appTheme() {
  return ThemeData(
    primaryColor: azulSolidaria2,
    accentColor: amarilloSolidaria1,
    hintColor: azulSolidaria1,
    dividerColor: azulSolidaria2,
    buttonColor: azulSolidaria2,
    scaffoldBackgroundColor: Colors.white,
    canvasColor: Colors.white,
  );
}