import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nextapp/A_SQL_Trigger/sql_usermast.dart';
import 'package:nextapp/Constant/Con_Clr.dart';
import 'package:nextapp/Constant/Con_Usermast.dart';
import 'package:nextapp/ExtraDarts/date_picker.dart';
import 'package:nextapp/ExtraDarts/date_picker_theme.dart';
import 'package:nextapp/ExtraDarts/widget/date_picker_widget.dart';

import '../Constant/Con_Icons.dart';
import '../Constant/Con_Wid.dart';
import '../OSFind.dart';
import 'DownloadData.dart';

class Dateofbirth extends StatefulWidget {
  const Dateofbirth({Key? key}) : super(key: key);

  @override
  _Dateofbirth createState() => _Dateofbirth();
}

class _Dateofbirth extends State<Dateofbirth> {
  DateTime _selectedDate = DateTime.parse('1990-09-07');
  DateTime? _IntDate = DateTime.parse('1990-09-07');

  @override
  void initState() {
    super.initState();
    if (Constants_Usermast.user_birthdate != "") {
      _IntDate = DateTime.tryParse(Constants_Usermast.user_birthdate);
      _selectedDate = (_IntDate ?? DateTime.parse('1990-09-07'));
    }
  }

  @override
  Widget build(BuildContext context) {
    var suffix = "th";
    var digit = _selectedDate.day % 10;
    if ((digit > 0 && digit < 4) &&
        (_selectedDate.day < 11 || _selectedDate.day > 13)) {
      suffix = ["st", "nd", "rd"][digit - 1];
    }
    return Os.isIOS? Scaffold(
      appBar: AppBar(
        backgroundColor:
            getPlatformBrightness() ? DarkTheme_Main : LightTheme_White,
        elevation: 0,
        leading: IconButton(
          icon: Own_ArrowBack,
          color: getPlatformBrightness() ? Con_white : Con_black,
          splashRadius: 20,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                Container(height: 20,),
                const Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child: Text.rich(
                    TextSpan(
                      style: TextStyle(
                        fontSize: 30,
                        height: 1.3333333333333333,
                      ),
                      children: [
                        TextSpan(
                          text: 'Tell us your\nBirthday.',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    textHeightBehavior:
                        TextHeightBehavior(applyHeightToFirstAscent: false),
                    textAlign: TextAlign.left,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15, left: 15.0),
                  child: Text(
                    'You will Receive birthday wishes from friends.',
                    style: TextStyle(
                      fontSize: 14,
                      color: getPlatformBrightness()
                          ? Dark_AppGreyColor
                          : AppGreyColor,
                      height: 1.7857142857142858,
                    ),
                    textHeightBehavior: const TextHeightBehavior(
                        applyHeightToFirstAscent: false),
                    textAlign: TextAlign.left,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: SizedBox(
                    height: 200.0,
                    child: Column(
                      children: <Widget>[
                        Stack(fit: StackFit.loose, children: <Widget>[
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: DatePickerWidget(
                              looping: false,
                              firstDate: DateTime(1950, 01, 01),
                              lastDate: DateTime(2021, 12, 1),
                              initialDate:
                                  (_IntDate ?? DateTime.parse('1990-09-07')),
                              dateFormat: "MMM-dd-yyyy",
                              locale: DatePicker.localeFromString('en'),
                              onChange: (DateTime newDate, _) {
                                setState(() {
                                  _selectedDate = newDate;
                                });
                              },
                              pickerTheme: const DateTimePickerTheme(
                                itemTextStyle:
                                    TextStyle(color: Con_black, fontSize: 19),
                                dividerColor: Con_Main_1,
                              ),
                            ),
                          )
                        ])
                      ],
                    ),
                  ),
                ),
                Text(
                  DateFormat("MMM d'$suffix', yyyy").format(_selectedDate),
                  style: const TextStyle(
                    fontSize: 18,
                    color: Con_Main_1,
                    height: 2.2222222222222223,
                  ),
                  textHeightBehavior:
                      const TextHeightBehavior(applyHeightToFirstAscent: false),
                  textAlign: TextAlign.center,
                ),
              ].toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () async {
                  sql_usermast_tran
                      .mSetUserBirthDateDetail(_selectedDate.toString());
                  Navigator.push(
                    context,
                    RouteTransitions.slideTransition( const DownloadData()),
                  );
                },
                child: const Button(),
              ),
            ),
          )
        ],
      ),
    ):CupertinoPageScaffold(child:  Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Text.rich(
                  TextSpan(
                    style: TextStyle(
                      fontSize: 30,
                      height: 1.3333333333333333,
                    ),
                    children: [
                      TextSpan(
                        text: 'Tell us your\nBirthday.',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  textHeightBehavior:
                  TextHeightBehavior(applyHeightToFirstAscent: false),
                  textAlign: TextAlign.left,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15, left: 15.0),
                child: Text(
                  'You will Receive birthday wishes from friends.',
                  style: TextStyle(
                    fontSize: 14,
                    color: getPlatformBrightness()
                        ? Dark_AppGreyColor
                        : AppGreyColor,
                    height: 1.7857142857142858,
                  ),
                  textHeightBehavior: const TextHeightBehavior(
                      applyHeightToFirstAscent: false),
                  textAlign: TextAlign.left,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: SizedBox(
                  height: 200.0,
                  child: Column(
                    children: <Widget>[
                      Stack(fit: StackFit.loose, children: <Widget>[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: DatePickerWidget(
                            looping: false,
                            firstDate: DateTime(1950, 01, 01),
                            lastDate: DateTime(2021, 12, 1),
                            initialDate:
                            (_IntDate ?? DateTime.parse('1990-09-07')),
                            dateFormat: "MMM-dd-yyyy",
                            locale: DatePicker.localeFromString('en'),
                            onChange: (DateTime newDate, _) {
                              setState(() {
                                _selectedDate = newDate;
                              });
                            },
                            pickerTheme: const DateTimePickerTheme(
                              itemTextStyle:
                              TextStyle(color: Con_black, fontSize: 19),
                              dividerColor: Con_Main_1,
                            ),
                          ),
                        )
                      ])
                    ],
                  ),
                ),
              ),
              Text(
                DateFormat("MMM d'$suffix', yyyy").format(_selectedDate),
                style: const TextStyle(
                  fontSize: 18,
                  color: Con_Main_1,
                  height: 2.2222222222222223,
                ),
                textHeightBehavior:
                const TextHeightBehavior(applyHeightToFirstAscent: false),
                textAlign: TextAlign.center,
              ),
            ].toList(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 50.0),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () async {
                sql_usermast_tran
                    .mSetUserBirthDateDetail(_selectedDate.toString());
                Navigator.push(
                  context,
                  RouteTransitions.slideTransition( const DownloadData()),
                );
              },
              child: const Button(),
            ),
          ),
        )
      ],
    ));
  }
}

class Button extends StatelessWidget {
  const Button({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width - 150,
        height: 45,
        child: const Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: Text(
            'Log in',
            style: TextStyle(
              fontSize: 16,
              color: Con_white,
              height: 1.25,
            ),
            textHeightBehavior:
                TextHeightBehavior(applyHeightToFirstAscent: false),
            textAlign: TextAlign.center,
          ),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(200.0),
          color: Con_Main_1,
          boxShadow: const [
            BoxShadow(
              color: Con_Clr_App_2,
              offset: Offset(0, 3),
              blurRadius: 6,
            ),
          ],
        ),
      ),
    );
  }
}
