library country_code_picker;

import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'package:nextapp/Constant/CountryCodePicker/country_code.dart';
import 'package:nextapp/Constant/CountryCodePicker/country_codes.dart';
import 'package:nextapp/Constant/CountryCodePicker/selection_dialog.dart';
import 'package:universal_platform/universal_platform.dart';

import '../Con_Clr.dart';
import '../Con_Icons.dart';

export 'country_code.dart';

class CountryCodePicker extends StatefulWidget {
  final ValueChanged<CountryCode>? onChanged;
  final ValueChanged<CountryCode?>? onInit;
  final String? initialSelection;
  final List<String> favorite;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry padding;
  final bool showCountryOnly;
  final TextStyle? searchStyle;
  final TextStyle? dialogTextStyle;
  final WidgetBuilder? emptySearchBuilder;
  final Function(CountryCode?)? builder;
  final bool enabled;
  final TextOverflow textOverflow;
  final Icon closeIcon;

  final Color? barrierColor;

  final Color? backgroundColor;

  final BoxDecoration? boxDecoration;

  final Size? dialogSize;

  final Color? dialogBackgroundColor;

  final List<String>? countryFilter;

  final bool showOnlyCountryWhenClosed;

  final bool alignLeft;

  final bool showFlag;

  final bool hideMainText;

  final bool? showFlagMain;

  final bool? showFlagDialog;

  final double flagWidth;

  final Comparator<CountryCode>? comparator;

  final bool hideSearch;

  final bool showDropDownButton;

  final Decoration? flagDecoration;

  const CountryCodePicker({
    this.onChanged,
    this.onInit,
    this.initialSelection,
    this.favorite = const [],
    this.textStyle,
    this.padding = const EdgeInsets.all(0.0),
    this.showCountryOnly = false,
    this.searchStyle,
    this.dialogTextStyle,
    this.emptySearchBuilder,
    this.showOnlyCountryWhenClosed = false,
    this.alignLeft = false,
    this.showFlag = true,
    this.showFlagDialog,
    this.hideMainText = false,
    this.showFlagMain,
    this.flagDecoration,
    this.builder,
    this.flagWidth = 20.0,
    this.enabled = true,
    this.textOverflow = TextOverflow.ellipsis,
    this.barrierColor,
    this.backgroundColor,
    this.boxDecoration,
    this.comparator,
    this.countryFilter,
    this.hideSearch = false,
    this.showDropDownButton = false,
    this.dialogSize,
    this.dialogBackgroundColor,
    this.closeIcon = Own_Remove,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    List<Map> jsonList = codes;

    List<CountryCode> elements = jsonList
        .map((json) => CountryCode.fromJson(json as Map<String, dynamic>))
        .toList();

    if (comparator != null) {
      elements.sort(comparator);
    }

    if (countryFilter != null && countryFilter!.isNotEmpty) {
      final uppercaseCustomList =
          countryFilter!.map((c) => c.toUpperCase()).toList();
      elements = elements
          .where((c) =>
              uppercaseCustomList.contains(c.code) ||
              uppercaseCustomList.contains(c.name) ||
              uppercaseCustomList.contains(c.dialCode))
          .toList();
    }

    return CountryCodePickerState(elements);
  }
}

class CountryCodePickerState extends State<CountryCodePicker> {
  CountryCode? selectedItem;
  List<CountryCode> elements = [];
  List<CountryCode> favoriteElements = [];

  CountryCodePickerState(this.elements);

  @override
  Widget build(BuildContext context) {
    Widget _widget;
    if (widget.builder != null) {
      _widget = InkWell(
        onTap: showCountryCodePickerDialog,
        child: widget.builder!(selectedItem),
      );
    } else {
      _widget = TextButton(
        onPressed: widget.enabled ? showCountryCodePickerDialog : null,
        child: Padding(
          padding: widget.padding,
          child: Flex(
            direction: Axis.horizontal,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (widget.showFlagMain != null
                  ? widget.showFlagMain!
                  : widget.showFlag)
                Flexible(
                  flex: widget.alignLeft ? 0 : 1,
                  fit: widget.alignLeft ? FlexFit.tight : FlexFit.loose,
                  child: Container(
                    clipBehavior: widget.flagDecoration == null
                        ? Clip.none
                        : Clip.hardEdge,
                    decoration: widget.flagDecoration,
                    margin: widget.alignLeft
                        ? const EdgeInsets.only(right: 0.0, left: 0)
                        : const EdgeInsets.only(right: 0),
                    child: Image.asset(
                      selectedItem!.flagUri!,
                      width: widget.flagWidth,
                    ),
                  ),
                ),
              SizedBox(width: 5),
              if (!widget.hideMainText)
                Flexible(
                  fit: widget.alignLeft ? FlexFit.tight : FlexFit.loose,
                  child: Text(
                    widget.showOnlyCountryWhenClosed
                        ? selectedItem!.toCountryStringOnly()
                        : selectedItem.toString(),
                    style: widget.textStyle ??
                        Theme.of(context).textTheme.labelLarge,
                    overflow: widget.textOverflow,
                  ),
                ),
              if (widget.showDropDownButton)
                Flexible(
                  flex: widget.alignLeft ? 0 : 1,
                  fit: widget.alignLeft ? FlexFit.tight : FlexFit.loose,
                  child: Padding(
                      padding: widget.alignLeft
                          ? const EdgeInsets.only(right: 0.0, left: 0.0)
                          : const EdgeInsets.only(right: 0.0),
                      child: Icon(
                        Icons.arrow_drop_down,
                        color: Con_grey,
                        size: widget.flagWidth,
                      )),
                ),
            ],
          ),
        ),
      );
    }
    return _widget;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    elements = elements.map((e) => e.localize(context)).toList();
    _onInit(selectedItem);
  }

  @override
  void didUpdateWidget(CountryCodePicker oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.initialSelection != widget.initialSelection) {
      if (widget.initialSelection != null) {
        selectedItem = elements.firstWhere(
            (e) =>
                (e.code!.toUpperCase() ==
                    widget.initialSelection!.toUpperCase()) ||
                (e.dialCode == widget.initialSelection) ||
                (e.name!.toUpperCase() ==
                    widget.initialSelection!.toUpperCase()),
            orElse: () => elements[0]);
      } else {
        selectedItem = elements[0];
      }
      _onInit(selectedItem);
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.initialSelection != null) {
      selectedItem = elements.firstWhere(
          (e) =>
              (e.code!.toUpperCase() ==
                  widget.initialSelection!.toUpperCase()) ||
              (e.dialCode == widget.initialSelection) ||
              (e.name!.toUpperCase() == widget.initialSelection!.toUpperCase()),
          orElse: () => elements[0]);
    } else {
      selectedItem = elements[0];
    }

    favoriteElements = elements
        .where((e) =>
            widget.favorite.firstWhereOrNull((f) =>
                e.code!.toUpperCase() == f.toUpperCase() ||
                e.dialCode == f ||
                e.name!.toUpperCase() == f.toUpperCase()) !=
            null)
        .toList();
  }

  void showCountryCodePickerDialog() {
    if (!UniversalPlatform.isAndroid && !UniversalPlatform.isIOS) {
      showDialog(
        barrierColor: widget.barrierColor ?? Con_white.withOpacity(0.5),
        context: context,
        builder: (context) => Center(
          child: Container(
            constraints: const BoxConstraints(maxHeight: 500, maxWidth: 400),
            child: Dialog(
              child: SelectionDialog(
                elements,
                favoriteElements,
                showCountryOnly: widget.showCountryOnly,
                emptySearchBuilder: widget.emptySearchBuilder,
                searchStyle: widget.searchStyle,
                textStyle: widget.dialogTextStyle,
                boxDecoration: widget.boxDecoration,
                showFlag: widget.showFlagDialog ?? widget.showFlag,
                flagWidth: widget.flagWidth,
                size: widget.dialogSize,
                backgroundColor: widget.backgroundColor,
                barrierColor: Con_white,
                hideSearch: widget.hideSearch,
                closeIcon: widget.closeIcon,
                flagDecoration: widget.flagDecoration,
              ),
            ),
          ),
        ),
      ).then((e) {
        if (e != null) {
          setState(() {
            selectedItem = e;
          });

          _publishSelection(e);
        }
      });
    } else {
      showModalBottomSheet(
        barrierColor: widget.barrierColor ?? Con_white.withOpacity(0.5),
        context: context,
        builder: (context) => Center(
          child: Container(
            padding: const EdgeInsets.all(10),
            // margin: EdgeInsets.all(100),
            child: Material(
              child: SelectionDialog(
                elements,
                favoriteElements,
                showCountryOnly: widget.showCountryOnly,
                emptySearchBuilder: widget.emptySearchBuilder,
                searchStyle: widget.searchStyle,
                textStyle: widget.dialogTextStyle,
                boxDecoration: widget.boxDecoration,
                showFlag: widget.showFlagDialog ?? widget.showFlag,
                flagWidth: widget.flagWidth,
                flagDecoration: widget.flagDecoration,
                size: widget.dialogSize,
                backgroundColor: widget.backgroundColor,
                barrierColor: Con_white,
                hideSearch: widget.hideSearch,
                closeIcon: widget.closeIcon,
              ),
            ),
          ),
        ),
      ).then((e) {
        if (e != null) {
          setState(() {
            selectedItem = e;
          });
          _publishSelection(e);
        }
      });
    }
  }

  void _publishSelection(CountryCode e) {
    if (widget.onChanged != null) {
      widget.onChanged!(e);
    }
  }

  void _onInit(CountryCode? e) {
    if (widget.onInit != null) {
      widget.onInit!(e);
    }
  }
}
