import 'dart:ui';
import 'package:flutter/material.dart';

TextStyle _baseFont({
  Color color = Colors.black,
  required FontWeight fontWeight,
  required double fontSize,
}) {
  return TextStyle(
    color: color,
    fontWeight: fontWeight,
    fontSize: fontSize,
  );
}
class LibFonts {
  static TextStyle extraExtraSmallRegular() {
    return _baseFont(
      fontWeight: FontWeight.w400,
      fontSize: 12,
    );
  }
}