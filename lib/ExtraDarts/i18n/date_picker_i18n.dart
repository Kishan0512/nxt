import 'dart:math';

part 'strings_ar.dart';
part 'strings_bn.dart';
part 'strings_de.dart';
part 'strings_en_us.dart';
part 'strings_es.dart';
part 'strings_fr.dart';
part 'strings_he.dart';
part 'strings_hu.dart';
part 'strings_id.dart';
part 'strings_it.dart';
part 'strings_jp.dart';
part 'strings_ko.dart';
part 'strings_no_nb.dart';
part 'strings_no_nn.dart';
part 'strings_pt_br.dart';
part 'strings_ro.dart';
part 'strings_ru.dart';
part 'strings_th.dart';
part 'strings_tr.dart';
part 'strings_zh_cn.dart';

abstract class _StringsI18n {
  const _StringsI18n();

  String getDoneText();

  String getCancelText();

  List<String> getMonths();

  List<String> getWeeksFull();

  List<String>? getWeeksShort();
}

enum DateTimePickerLocale {
  /// English (EN) United
  en_us,

  /// Chinese (ZH) Simplified
  zh_cn,

  /// Portuguese (PT) Brazil
  pt_br,

  /// Spanish (ES)
  es,

  /// Romanian (RO)
  ro,

  /// Bengali (BN)
  bn,

  /// Arabic (AR)
  ar,

  /// Japanese (JP)
  jp,

  /// Russian (RU)
  ru,

  /// German (DE)
  de,

  /// Korea (KO)
  ko,

  /// Italian (IT)
  it,

  /// Hungarian (HU)
  hu,

  /// Hebrew (HE)
  he,

  /// Indonesian (ID)
  id,

  /// Turkish (TR)
  tr,

  /// Norwegian Bokmål (NO)
  no_nb,

  /// Norwegian Nynorsk (NO)
  no_nn,

  /// French (FR)
  fr,

  /// Thai (TH)
  th,
}

const DateTimePickerLocale DATETIME_PICKER_LOCALE_DEFAULT =
    DateTimePickerLocale.en_us;

const Map<DateTimePickerLocale, _StringsI18n> datePickerI18n = {
  DateTimePickerLocale.en_us: _StringsEnUs(),
  DateTimePickerLocale.zh_cn: _StringsZhCn(),
  DateTimePickerLocale.pt_br: _StringsPtBr(),
  DateTimePickerLocale.es: _StringsEs(),
  DateTimePickerLocale.ro: _StringsRo(),
  DateTimePickerLocale.bn: _StringsBn(),
  DateTimePickerLocale.ar: _StringsAr(),
  DateTimePickerLocale.jp: _StringsJp(),
  DateTimePickerLocale.ru: _StringsRu(),
  DateTimePickerLocale.de: _StringsDe(),
  DateTimePickerLocale.ko: _StringsKo(),
  DateTimePickerLocale.it: _StringsIt(),
  DateTimePickerLocale.hu: _StringsHu(),
  DateTimePickerLocale.he: _StringsHe(),
  DateTimePickerLocale.id: _StringsId(),
  DateTimePickerLocale.tr: _StringsTr(),
  DateTimePickerLocale.no_nb: _StringsNoNb(),
  DateTimePickerLocale.no_nn: _StringsNoNn(),
  DateTimePickerLocale.fr: _StringsFr(),
  DateTimePickerLocale.th: _StringsTh(),
};

class DatePickerI18n {
  static String getLocaleDone(DateTimePickerLocale locale) {
    _StringsI18n i18n = datePickerI18n[locale] ??
        datePickerI18n[DATETIME_PICKER_LOCALE_DEFAULT]!;
    return i18n.getDoneText();
  }

  static String getLocaleCancel(DateTimePickerLocale locale) {
    _StringsI18n i18n = datePickerI18n[locale] ??
        datePickerI18n[DATETIME_PICKER_LOCALE_DEFAULT]!;
    return i18n.getCancelText();
  }

  static List<String> getLocaleMonths(DateTimePickerLocale? locale) {
    _StringsI18n i18n = datePickerI18n[locale!] ??
        datePickerI18n[DATETIME_PICKER_LOCALE_DEFAULT]!;
    List<String> months = i18n.getMonths();
    if (months.isNotEmpty) {
      return months;
    }
    return datePickerI18n[DATETIME_PICKER_LOCALE_DEFAULT]!.getMonths();
  }

  static List<String>? getLocaleWeeks(DateTimePickerLocale? locale,
      [bool isFull = true]) {
    _StringsI18n? i18n = datePickerI18n[locale!] ??
        datePickerI18n[DATETIME_PICKER_LOCALE_DEFAULT];
    if (isFull) {
      List<String> weeks = i18n!.getWeeksFull();
      if (weeks.isNotEmpty) {
        return weeks;
      }
      return datePickerI18n[DATETIME_PICKER_LOCALE_DEFAULT]!.getWeeksFull();
    }

    List<String>? weeks = i18n!.getWeeksShort();
    if (weeks != null && weeks.isNotEmpty) {
      return weeks;
    }

    List<String> fullWeeks = i18n.getWeeksFull();
    if (fullWeeks.isNotEmpty) {
      return fullWeeks
          .map((item) => item.substring(0, min(3, item.length)))
          .toList();
    }
    return datePickerI18n[DATETIME_PICKER_LOCALE_DEFAULT]!.getWeeksShort();
  }
}
