import 'package:flutter/material.dart';

import '../Constant/Con_Clr.dart';

const DATETIME_PICKER_BACKGROUND_COLOR = Con_white;
const DATETIME_PICKER_BACKGROUND_DARK_COLOR = DarkTheme_Main;

const DATETIME_PICKER_SHOW_TITLE_DEFAULT = true;

const double DATETIME_PICKER_HEIGHT = 160.0;

const double DATETIME_PICKER_TITLE_HEIGHT = 36.0;

const double DATETIME_PICKER_ITEM_HEIGHT = 36.0;

const TextStyle DATETIME_PICKER_ITEM_TEXT_STYLE =
    TextStyle(color: Con_black, fontSize: 20.0);

const Color DATETIME_PICKER_ITEM_TEXT_COLOR = Con_black;
const double DATETIME_PICKER_ITEM_TEXT_SIZE_SMALL = 15;
const double DATETIME_PICKER_ITEM_TEXT_SIZE_BIG = 17;

class DateTimePickerTheme {
  final cancelDefault = const Text('OK');

  const DateTimePickerTheme({
    this.backgroundColor = DATETIME_PICKER_BACKGROUND_COLOR,
    this.darkbackgroundColor = DATETIME_PICKER_BACKGROUND_DARK_COLOR,
    this.cancelTextStyle,
    this.confirmTextStyle,
    this.cancel,
    this.confirm,
    this.title,
    this.showTitle = DATETIME_PICKER_SHOW_TITLE_DEFAULT,
    this.pickerHeight = DATETIME_PICKER_HEIGHT,
    this.titleHeight = DATETIME_PICKER_TITLE_HEIGHT,
    this.itemHeight = DATETIME_PICKER_ITEM_HEIGHT,
    this.itemTextStyle = DATETIME_PICKER_ITEM_TEXT_STYLE,
    this.dividerColor,
  });

  static const DateTimePickerTheme Default = DateTimePickerTheme();

  final Color backgroundColor;
  final Color darkbackgroundColor;

  final TextStyle? cancelTextStyle;

  final TextStyle? confirmTextStyle;

  final Widget? cancel;

  final Widget? confirm;

  final Widget? title;

  final bool showTitle;

  final double pickerHeight;

  final double titleHeight;

  final double itemHeight;

  final TextStyle itemTextStyle;

  final Color? dividerColor;
}
