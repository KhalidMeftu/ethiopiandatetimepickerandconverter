
import 'package:abushakir/abushakir.dart';

/// contains constant functions for our library


 ethiopianToGregorianDateConvertor(int day,ETC ethiopianCalender ){
   /// this function will be called when we want to display
   /// gregorian calender with ethiopian calender
   /// it takes ethiopian calender and date as a param and returns gregorian calender
   EtDatetime ethiopianDateTime = EtDatetime(year: ethiopianCalender.year, month: ethiopianCalender.month, day: day);
   DateTime gregorianCalender = DateTime.fromMillisecondsSinceEpoch(ethiopianDateTime.moment);
   String result =  gregorianCalender.toString().substring(0, gregorianCalender.toString().indexOf(' '));
   var gregorianConvertedDate = result.split('-');
   return gregorianConvertedDate[2].toString().replaceAll(RegExp(r'^0+(?=.)'), '');
}