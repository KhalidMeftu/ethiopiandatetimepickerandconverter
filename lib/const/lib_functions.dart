import 'package:abushakir/abushakir.dart';
import 'package:ethiopiandatepickerandconvertor/const/app_strings.dart';
import 'package:flutter/material.dart';

/// contains constant functions for our library

ethiopianToGregorianDateConvertor(
    int day, ETC ethiopianCalender, bool forCalender) {
  /// this function will be called when we want to display
  /// gregorian calender with ethiopian calender
  /// it takes ethiopian calender and date as a param and returns gregorian calender
  EtDatetime ethiopianDateTime = EtDatetime(year: ethiopianCalender.year, month: ethiopianCalender.month, day: day);
  DateTime gregorianCalender = DateTime.fromMillisecondsSinceEpoch(ethiopianDateTime.moment);
  String result = gregorianCalender.toString().substring(0, gregorianCalender.toString().indexOf(' '));
  var gregorianConvertedDate = result.split('-');
  return forCalender
      ? gregorianConvertedDate[2].toString().replaceAll(RegExp(r'^0+(?=.)'), '')
      : result;
}
/// function to remove Hyphens
removeHyphenGetDate(String dateTime) {
  final date = dateTime.split('-');
  return date[0];
}

removeHyphenGetMonth(String dateTime) {
  final month= dateTime.split('-');
  return month[1];
}

removeHyphenGetYear(String dateTime) {
  final year = dateTime.split('-');
  return year[2];
}
///
List<String> days = [
  LibAmharicStrings.shortMonday,
  LibAmharicStrings.shortTuesday,
  LibAmharicStrings.shortWednesday,
  LibAmharicStrings.shortThursday,
  LibAmharicStrings.shortFriday,
  LibAmharicStrings.shortSaturday,
  LibAmharicStrings.shortSunday,
];
