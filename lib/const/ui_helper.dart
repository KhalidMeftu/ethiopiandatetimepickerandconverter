import 'package:flutter/material.dart';

BorderRadius roundedBorderSmall = BorderRadius.circular(5);
BorderRadius roundedBorderMedium = BorderRadius.circular(7);
BorderRadius roundedBorderLarge = BorderRadius.circular(10);
double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;
double screenHeight(BuildContext context) => MediaQuery.of(context).size.height;

/// text fonts
double textFont025(BuildContext context)=> screenWidth(context)*0.25;
double textFont030(BuildContext context)=> screenWidth(context)*0.30;
double textFont035(BuildContext context)=> screenWidth(context)*0.35;
double textFont040(BuildContext context)=> screenWidth(context)*0.40;
double textFont045(BuildContext context)=> screenWidth(context)*0.45;

/// paddings
double padding8(BuildContext context)=> screenHeight(context)*0.00949;/// fixed
double padding15(BuildContext context)=> screenHeight(context)*0.01779375;/// fixed
double padding80(BuildContext context)=> screenHeight(context)*0.0949;/// fixed



/// container heights
double height200(BuildContext context)=>screenHeight(context)*0.23714;/// fixes
double height12(BuildContext context)=>screenHeight(context)*0.0123;/// fixed

/// container width
double width203(BuildContext context)=>screenHeight(context)*0.0232;/// fixed

/// icon heights
double iconSize20(BuildContext context)=>screenHeight(context)*0.023714;/// fixed
double iconSize16(BuildContext context)=>screenHeight(context)*0.0189701;///fixed


/// vertical and horizontal paddings
double verticalPadding(BuildContext context)=>screenWidth(context)*0.39;
double horizontalPadding(BuildContext context)=>screenWidth(context)*0.69;

double verticalPadding098(BuildContext context)=>screenWidth(context)*0.98;
double horizontalPadding18(BuildContext context)=>screenWidth(context)*1.85;