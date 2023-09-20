import 'package:flutter/material.dart';

class LibColors{
  static const Color white70 = Colors.white70;
  static const Color redColor= Colors.red;
  static const Color blackColor= Colors.black;
  static const Color whiteColor =Colors.white;
  static  Color grey100 = Colors.grey[100]!;
  static Color grey300 =Colors.grey[300]!;
  static Color red300 = Colors.red[300]!;
}

Color LibThemeColor(BuildContext ctx)
{
return  Theme.of(ctx).primaryColor;

}