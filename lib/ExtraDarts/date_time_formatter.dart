import 'dart:math';

import 'date_picker.dart';
import 'date_picker_constants.dart';
import 'i18n/date_picker_i18n.dart';

const String DATE_FORMAT_SEPARATOR = r'[|,-\._: ]+';

class DateTimeFormatter {
  static String generateDateFormat(
      String dateFormat, DateTimePickerMode pickerMode) {
    if (dateFormat.isNotEmpty) {
      return dateFormat;
    }
    switch (pickerMode) {
      case DateTimePickerMode.date:
        return DATETIME_PICKER_DATE_FORMAT;
      case DateTimePickerMode.datetime:
        return DATETIME_PICKER_DATETIME_FORMAT;
    }
  }

  static bool isDayFormat(String format) {
    return format.contains(RegExp(r'[yMdE]'));
  }

  static bool isTimeFormat(String format) {
    return format.contains(RegExp(r'[Hms]'));
  }

  static List<String> splitDateFormat(String? dateFormat,
      {DateTimePickerMode? mode}) {
    if (dateFormat == null || dateFormat.isEmpty) {
      return [];
    }
    List<String> result = dateFormat.split(RegExp(DATE_FORMAT_SEPARATOR));
    if (mode == DateTimePickerMode.datetime) {
      List<String> temp = [];
      StringBuffer dayFormat = StringBuffer();
      for (int i = 0; i < result.length; i++) {
        String format = result[i];
        if (isDayFormat(format)) {
          int end = dateFormat.indexOf(format);
          if (end > 0) {
            int start = 0;
            if (i > 0) {
              start = dateFormat.indexOf(result[i - 1]) + result[i - 1].length;
            }
            dayFormat.write(dateFormat.substring(start, end));
          }
          dayFormat.write(format);
        } else if (isTimeFormat(format)) {
          temp.add(format);
        }
      }
      if (dayFormat.length > 0) {
        temp.insert(0, dayFormat.toString());
      } else {
        temp.insert(0, DATETIME_PICKER_DATE_FORMAT);
      }
      result = temp;
    }
    return result;
  }

  static String formatDateTime(
      int value, String format, DateTimePickerLocale? locale, weekday) {
    if (format.isEmpty) {
      return value.toString();
    }

    String result = format;
    if (format.contains('y')) {
      result = _formatYear(value, result, locale);
    }
    if (format.contains('M')) {
      result = _formatMonth(value, result, locale);
    }
    if (format.contains('d')) {
      result = _formatDay(value, result, locale);
    }
    if (format.contains('E')) {
      result = _formatWeek(weekday, result, locale);
    }
    if (format.contains('H')) {
      result = _formatHour(value, result, locale);
    }
    if (format.contains('m')) {
      result = _formatMinute(value, result, locale);
    }
    if (format.contains('s')) {
      result = _formatSecond(value, result, locale);
    }
    if (result == format) {
      return value.toString();
    }
    return result;
  }

  static String _formatYear(
      int value, String format, DateTimePickerLocale? locale) {
    if (format.contains('yyyy')) {
      return format.replaceAll('yyyy', value.toString());
    } else if (format.contains('yy')) {
      return format.replaceAll('yy',
          value.toString().substring(max(0, value.toString().length - 2)));
    }
    return value.toString();
  }

  static String _formatMonth(
      int value, String format, DateTimePickerLocale? locale) {
    List<String> months = DatePickerI18n.getLocaleMonths(locale);
    if (format.contains('MMMM')) {
      return format.replaceAll('MMMM', months[value - 1]);
    } else if (format.contains('MMM')) {
      String month = months[value - 1];
      return format.replaceAll('MMM', month.substring(0, min(3, month.length)));
    }
    return _formatNumber(value, format, 'M');
  }

  static String _formatDay(
      int value, String format, DateTimePickerLocale? locale) {
    return _formatNumber(value, format, 'd');
  }

  static String _formatWeek(
      int value, String format, DateTimePickerLocale? locale) {
    if (format.contains('EEEE')) {
      List<String> weeks = DatePickerI18n.getLocaleWeeks(locale)!;
      return format.replaceAll('EEEE', weeks[value - 1]);
    }
    List<String> weeks = DatePickerI18n.getLocaleWeeks(locale, false)!;
    return format.replaceAll(RegExp(r'E+'), weeks[value - 1]);
  }

  static String _formatHour(
      int value, String format, DateTimePickerLocale? locale) {
    return _formatNumber(value, format, 'H');
  }

  static String _formatMinute(
      int value, String format, DateTimePickerLocale? locale) {
    return _formatNumber(value, format, 'm');
  }

  static String _formatSecond(
      int value, String format, DateTimePickerLocale? locale) {
    return _formatNumber(value, format, 's');
  }

  static String _formatNumber(int value, String format, String unit) {
    if (format.contains('$unit$unit')) {
      return format.replaceAll('$unit$unit', value.toString().padLeft(2, '0'));
    } else if (format.contains(unit)) {
      return format.replaceAll(unit, value.toString());
    }
    return value.toString();
  }
}
