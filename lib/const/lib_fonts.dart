import 'package:flutter/material.dart';

TextStyle myBaseFont({
  Color color = Colors.white,
  required FontWeight fontWeight,
  required double fontSize,
}) {
  return TextStyle(
    color: color,
    fontWeight: fontWeight,
    fontSize: fontSize,
  );
}
class EthiopianDatePickerFont {
  static TextStyle textFont() {
    return myBaseFont(
      fontWeight: FontWeight.w400,
      fontSize: 12,
    );
  }
}

