import 'package:flutter/material.dart';

class AppColors {
  static Color primaryColor = Color(0xffFec7e23);
  static Color borderColor = Color(0xff9E9E9E);
  static Color onPrimaryColor = Colors.white;

  static Color secondaryColor = Color(0xff275a8a);
  static Color onSecondaryColor = Colors.white;

  static Color surfaceColor = Colors.white;
  static Color onSurfaceColor = Colors.black;
  static Color inputShadowBlue = Color(0xff275a8a);
  static Color navBarColor = Color(0xff3C77AD);
  static Color greenColor = Color(0xff53b567);

  static List<Color> splashGradient = [
    Color(0xffE97E31),
    Color(0xffF5AF19),
    Color(0xffF49E18),
    Color(0xffF48F17)
  ];
}


extension ColorExtension on String {
  toColor() {
    var hexStringColor = this;
    final buffer = StringBuffer();

    if (hexStringColor.length == 6 || hexStringColor.length == 7) {
      buffer.write('ff');
      buffer.write(hexStringColor.replaceFirst("#", ""));
      return Color(int.parse(buffer.toString(), radix: 16));
    }
  }
}