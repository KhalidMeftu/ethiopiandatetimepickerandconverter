import 'package:abushakir/abushakir.dart';
import 'package:ethiopiandatepickerandconvertor/const/app_strings.dart';

/// contains constant functions for our library

ethiopianToGregorianDateConvertor(
    int day, ETC ethiopianCalender, bool forCalender) {
  /// this function will be called when we want to display
  /// gregorian calender with ethiopian calender
  /// it takes ethiopian calender and date as a param and returns gregorian calender
  EtDatetime ethiopianDateTime = EtDatetime(
      year: ethiopianCalender.year, month: ethiopianCalender.month, day: day);
  DateTime gregorianCalender =
      DateTime.fromMillisecondsSinceEpoch(ethiopianDateTime.moment);
  String result = gregorianCalender
      .toString()
      .substring(0, gregorianCalender.toString().indexOf(' '));
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
  final month = dateTime.split('-');
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

/// do day name comparsion for afaan oromoo and amharic
/// isMonthTitle is when i need to return for only for month name
String? returnDayAndMonthName(String dayname, String currentDate,
    String monthname, String userLanguage, String year, bool isMonthTitle) {
  String dayName = '';
  String monthn = '';
  Map<String, Map<String, String>> translations = {
    'am': {
      LibEnglishStrings.monday: LibAmharicStrings.monday,
      LibEnglishStrings.tuesday: LibAmharicStrings.tuesday,
      LibEnglishStrings.wednesday: LibAmharicStrings.wednesday,
      LibEnglishStrings.thursday: LibAmharicStrings.thursday,
      LibEnglishStrings.friday: LibAmharicStrings.friday,
      LibEnglishStrings.saturday: LibAmharicStrings.saturday,
      LibEnglishStrings.sunday: LibAmharicStrings.sunday,
    },
    'ao': {
      LibEnglishStrings.monday: LibOromoStrings.monday,
      LibEnglishStrings.tuesday: LibOromoStrings.tuesday,
      LibEnglishStrings.wednesday: LibOromoStrings.wednesday,
      LibEnglishStrings.thursday: LibOromoStrings.thursday,
      LibEnglishStrings.friday: LibOromoStrings.friday,
      LibEnglishStrings.saturday: LibOromoStrings.saturday,
      LibEnglishStrings.sunday: LibOromoStrings.sunday,
    },
    // Add more languages and translations as needed
  };

  Map<String, Map<String, String>> months = {
    'en': {
      LibAmharicStrings.jan: LibEnglishStrings.jan,
      LibAmharicStrings.feb: LibEnglishStrings.feb,
      LibAmharicStrings.mar: LibEnglishStrings.mar,
      LibAmharicStrings.apr: LibEnglishStrings.apr,
      LibAmharicStrings.may: LibEnglishStrings.may,
      LibAmharicStrings.jun: LibEnglishStrings.jun,
      LibAmharicStrings.jul: LibEnglishStrings.jul,
      LibAmharicStrings.aug: LibEnglishStrings.aug,
      LibAmharicStrings.sep: LibEnglishStrings.sep,
      LibAmharicStrings.oct: LibEnglishStrings.oct,
      LibAmharicStrings.nov: LibEnglishStrings.nov,
      LibAmharicStrings.dec: LibEnglishStrings.dec,
      LibAmharicStrings.pag: LibEnglishStrings.sep,
    },
    'am': {
      LibAmharicStrings.jan: LibAmharicStrings.jan,
      LibAmharicStrings.feb: LibAmharicStrings.feb,
      LibAmharicStrings.mar: LibAmharicStrings.mar,
      LibAmharicStrings.apr: LibAmharicStrings.apr,
      LibAmharicStrings.may: LibAmharicStrings.may,
      LibAmharicStrings.jun: LibAmharicStrings.jun,
      LibAmharicStrings.jul: LibAmharicStrings.jul,
      LibAmharicStrings.aug: LibAmharicStrings.aug,
      LibAmharicStrings.sep: LibAmharicStrings.sep,
      LibAmharicStrings.oct: LibAmharicStrings.oct,
      LibAmharicStrings.nov: LibAmharicStrings.nov,
      LibAmharicStrings.dec: LibAmharicStrings.dec,
      LibAmharicStrings.pag: LibAmharicStrings.pag,
    },
    'ao': {
      LibAmharicStrings.jan: LibOromoStrings.jan,
      LibAmharicStrings.feb: LibOromoStrings.feb,
      LibAmharicStrings.mar: LibOromoStrings.mar,
      LibAmharicStrings.apr: LibOromoStrings.apr,
      LibAmharicStrings.may: LibOromoStrings.may,
      LibAmharicStrings.jun: LibOromoStrings.jun,
      LibAmharicStrings.jul: LibOromoStrings.jul,
      LibAmharicStrings.aug: LibOromoStrings.aug,
      LibAmharicStrings.sep: LibOromoStrings.sep,
      LibAmharicStrings.oct: LibOromoStrings.oct,
      LibAmharicStrings.nov: LibOromoStrings.nov,
      LibAmharicStrings.dec: LibOromoStrings.dec,
      LibAmharicStrings.pag: LibOromoStrings.pag,
    },
    // Add more languages and translations as needed
  };

  if (translations.containsKey(userLanguage)) {
    final languageTranslations = translations[userLanguage];
    if (languageTranslations!.containsKey(dayname)) {
      dayName = languageTranslations[dayname]!;
    }
  }
  if (months.containsKey(userLanguage)) {
    final mNames = months[userLanguage];
    if (mNames!.containsKey(monthname)) {

      monthn = mNames[monthname]!;
    }
  }



  return isMonthTitle? '$monthn $year':'$monthn $dayName $currentDate $year';
}


/// we will return mon, tues abrivated date for all language
String? returnAbrivateWeekNames(String weekName, String userLanguage) {


  String shortendName='';
  Map<String, Map<String, String>> weekdnames = {
    /// always returns amaharic so... make them some
    'am':{
      LibAmharicStrings.shortMonday: LibAmharicStrings.shortMonday,
      LibAmharicStrings.shortTuesday: LibAmharicStrings.shortTuesday,
      LibAmharicStrings.shortWednesday: LibAmharicStrings.shortWednesday,
      LibAmharicStrings.shortThursday: LibAmharicStrings.shortThursday,
      LibAmharicStrings.shortFriday: LibAmharicStrings.shortFriday,
      LibAmharicStrings.shortSaturday: LibAmharicStrings.shortSaturday,
      LibAmharicStrings.shortSunday: LibAmharicStrings.shortSunday,
    },
    'en': {
      LibAmharicStrings.shortMonday: LibEnglishStrings.shortMonday,
      LibAmharicStrings.shortTuesday: LibEnglishStrings.shortTuesday,
      LibAmharicStrings.shortWednesday: LibEnglishStrings.shortWednesday,
      LibAmharicStrings.shortThursday: LibEnglishStrings.shortThursday,
      LibAmharicStrings.shortFriday: LibEnglishStrings.shortFriday,
      LibAmharicStrings.shortSaturday: LibEnglishStrings.shortSaturday,
      LibAmharicStrings.shortSunday: LibEnglishStrings.shortSunday,
    },
    'ao': {
      LibAmharicStrings.shortMonday: LibOromoStrings.shortMonday,
      LibAmharicStrings.shortTuesday: LibOromoStrings.shortTuesday,
      LibAmharicStrings.shortWednesday: LibOromoStrings.shortWednesday,
      LibAmharicStrings.shortThursday: LibOromoStrings.shortThursday,
      LibAmharicStrings.shortFriday: LibOromoStrings.shortFriday,
      LibAmharicStrings.shortSaturday: LibOromoStrings.shortSaturday,
      LibAmharicStrings.shortSunday: LibOromoStrings.shortSunday,
    },
    // Add more languages and translations as needed
  };

  if (weekdnames.containsKey(userLanguage)) {
    final languageTranslations = weekdnames[userLanguage];
    if (languageTranslations!.containsKey(weekName)) {
      shortendName = languageTranslations[weekName]!;
    }
  }



  return shortendName;
}


/// month name
String? returnMonthName(String dayname, String currentDate,
    String monthname, String userLanguage, String year) {
  String monthName = '';

  Map<String, Map<String, String>> months = {
    'en': {
      LibAmharicStrings.jan: LibEnglishStrings.jan,
      LibAmharicStrings.feb: LibEnglishStrings.feb,
      LibAmharicStrings.mar: LibEnglishStrings.mar,
      LibAmharicStrings.apr: LibEnglishStrings.apr,
      LibAmharicStrings.may: LibEnglishStrings.may,
      LibAmharicStrings.jun: LibEnglishStrings.jun,
      LibAmharicStrings.jul: LibEnglishStrings.jul,
      LibAmharicStrings.aug: LibEnglishStrings.aug,
      LibAmharicStrings.sep: LibEnglishStrings.sep,
      LibAmharicStrings.oct: LibEnglishStrings.oct,
      LibAmharicStrings.nov: LibEnglishStrings.nov,
      LibAmharicStrings.dec: LibEnglishStrings.dec,
      LibAmharicStrings.pag: LibEnglishStrings.sep,
    },
    'am': {
      LibAmharicStrings.jan: LibAmharicStrings.jan,
      LibAmharicStrings.feb: LibAmharicStrings.feb,
      LibAmharicStrings.mar: LibAmharicStrings.mar,
      LibAmharicStrings.apr: LibAmharicStrings.apr,
      LibAmharicStrings.may: LibAmharicStrings.may,
      LibAmharicStrings.jun: LibAmharicStrings.jun,
      LibAmharicStrings.jul: LibAmharicStrings.jul,
      LibAmharicStrings.aug: LibAmharicStrings.aug,
      LibAmharicStrings.sep: LibAmharicStrings.sep,
      LibAmharicStrings.oct: LibAmharicStrings.oct,
      LibAmharicStrings.nov: LibAmharicStrings.nov,
      LibAmharicStrings.dec: LibAmharicStrings.dec,
      LibAmharicStrings.pag: LibAmharicStrings.pag,
    },
    'ao': {
      LibAmharicStrings.jan: LibOromoStrings.jan,
      LibAmharicStrings.feb: LibOromoStrings.feb,
      LibAmharicStrings.mar: LibOromoStrings.mar,
      LibAmharicStrings.apr: LibOromoStrings.apr,
      LibAmharicStrings.may: LibOromoStrings.may,
      LibAmharicStrings.jun: LibOromoStrings.jun,
      LibAmharicStrings.jul: LibOromoStrings.jul,
      LibAmharicStrings.aug: LibOromoStrings.aug,
      LibAmharicStrings.sep: LibOromoStrings.sep,
      LibAmharicStrings.oct: LibOromoStrings.oct,
      LibAmharicStrings.nov: LibOromoStrings.nov,
      LibAmharicStrings.dec: LibOromoStrings.dec,
      LibAmharicStrings.pag: LibOromoStrings.pag,
    },
  };


  if (months.containsKey(userLanguage)) {
    final monthNames = months[userLanguage];
    if (monthNames!.containsKey(monthname)) {
      monthName = monthNames[monthname]!;
    }
  }


  return monthName;
}

 getCalenderSpecificYear(int val) {
  final EtDatetime date;
   date = EtDatetime.now();
   return ETC(year: val, month: date.month);
}
