import 'package:flutter/cupertino.dart';

const String ko = 'ko';
const String en = 'en';

extension LocaleExtension on Locale {
  List<String> get months {
    return languageCode == ko ? intMonths : enMonths;
  }
}

const List<String> intMonths = [
  '1',
  '2',
  '3',
  '4',
  '5',
  '6',
  '7',
  '8',
  '9',
  '10',
  '11',
  '12',
];
const List<String> enMonths = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];
