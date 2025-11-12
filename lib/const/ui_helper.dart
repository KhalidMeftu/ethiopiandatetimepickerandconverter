import 'package:flutter/material.dart';

BorderRadius roundedBorderSmall = BorderRadius.circular(5);
BorderRadius roundedBorderMedium = BorderRadius.circular(7);
BorderRadius roundedBorderLarge = BorderRadius.circular(10);
double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;
double screenHeight(BuildContext context) => MediaQuery.of(context).size.height;

/// text fonts  25--->0.06127
double textFont07(BuildContext context)=> screenWidth(context)*0.017000;
double textFont025(BuildContext context)=> screenWidth(context)*0.04000;
double textFont030(BuildContext context)=> screenWidth(context)*0.07352;
double textFont035(BuildContext context)=> screenWidth(context)*0.08577;
double textFont040(BuildContext context)=> screenWidth(context)*0.09803;
double textFont045(BuildContext context)=> screenWidth(context)*0.11028;

/// paddings
double padding8(BuildContext context)=> screenHeight(context)*0.00949;/// fixed
double padding15(BuildContext context)=> screenHeight(context)*0.01779375;/// fixed
double padding80(BuildContext context)=> screenHeight(context)*0.0949;/// fixed

/// container heights
double height200(BuildContext context)=>screenHeight(context)*0.17000;/// fixes
double height12(BuildContext context)=>screenHeight(context)*0.0123;/// fixed

/// container width
double width203(BuildContext context)=>screenHeight(context)*0.0232;/// fixed
double width250(BuildContext context)=>screenHeight(context)*0.0552;/// fixed

/// icon heights
double iconSize20(BuildContext context)=>screenHeight(context)*0.023714;/// fixed
double iconSize16(BuildContext context)=>screenHeight(context)*0.0189701;///fixed

/// vertical and horizontal paddings
double verticalPadding(BuildContext context)=>screenWidth(context)*0.00800;/// fixed
double horizontalPadding(BuildContext context)=>screenWidth(context)*0.0165;///fixed

double verticalPadding098(BuildContext context)=>screenWidth(context)*0.0023819651;///fixed
double horizontalPadding18(BuildContext context)=>screenWidth(context)*0.0080086486;///fixed