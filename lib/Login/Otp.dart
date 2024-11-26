import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nextapp/A_SQL_Trigger/sql_usermast.dart';
import 'package:nextapp/Constant/Con_Clr.dart';

import '../Constant/Con_Icons.dart';
import '../Constant/Con_Wid.dart';
import '../OSFind.dart';
import 'ProfilePic.dart';

class OTP extends StatefulWidget {
  const OTP({super.key});

  // String verificationId;
  //
  // OTP({required this.verificationId});

  @override
  _OTPState createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  String pStrFirstOtp = "",
      pStrSecondOtp = "",
      pStrThirdOtp = "",
      pStrFourthOtp = "",
      pStrFifthhOtp = "",
      pStrSixththOtp = "";
  int ResendInSecond = 30;
  bool resend = false;
  FocusNode f1 = FocusNode(),
      f2 = FocusNode(),
      f3 = FocusNode(),
      f4 = FocusNode(),
      f5 = FocusNode(),
      f6 = FocusNode();

  @override
  void initState() {
    super.initState();
    f1 = FocusNode();
    f2 = FocusNode();
    f3 = FocusNode();
    f4 = FocusNode();
    f5 = FocusNode();
    f6 = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Os.isIOS
        ? Scaffold(
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
            body: Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.only(left: 5.0),
                    child: Text(
                      'Verify your\nMobile.',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        height: 1.3333333333333333,
                      ),
                      textHeightBehavior:
                          TextHeightBehavior(applyHeightToFirstAscent: false),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        ' The OTP has been sent to your registered \n '
                        'mobile number.\n Please enter the OTP.',
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
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 18.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          _otpTextField(context, 0, f1),
                          _otpTextField(context, 1, f2),
                          _otpTextField(context, 2, f3),
                          _otpTextField(context, 3, f4),
                          _otpTextField(context, 4, f5),
                          _otpTextField(context, 5, f6),
                        ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Stack(
                          children: [
                            Visibility(
                              visible: !resend,
                              child: Text.rich(
                                TextSpan(
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: getPlatformBrightness()
                                        ? Dark_AppGreyColor
                                        : AppGreyColor,
                                    height: 1.7857142857142858,
                                  ),
                                  children: [
                                    const TextSpan(
                                      text: 'If you didn\'t receive an OTP!  ',
                                    ),
                                    TextSpan(
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          ResendInSecond = 30;
                                          resend = true;
                                          setState(() {});
                                          Timer.periodic(
                                              const Duration(seconds: 1),
                                              (timer) {
                                            if (ResendInSecond != 1) {
                                              ResendInSecond--;
                                              setState(() {});
                                            } else {
                                              timer.cancel();
                                              resend = false;
                                              setState(() {});
                                            }
                                          });
                                        },
                                      text: 'Resend now',
                                      style: const TextStyle(
                                        color: Chat_Row_UnRead_Color,
                                      ),
                                    ),
                                  ],
                                ),
                                textHeightBehavior: const TextHeightBehavior(
                                    applyHeightToFirstAscent: false),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Center(
                              child: Visibility(
                                  visible: resend,
                                  child: Text.rich(TextSpan(
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Chat_Row_UnRead_Color,
                                        height: 0.7857142857142858,
                                      ),
                                      children: [
                                        const TextSpan(text: 'Resend in '),
                                        TextSpan(
                                            text: ResendInSecond.toString()),
                                        const TextSpan(text: ' seconds')
                                      ]))),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        : SafeArea(
          child: CupertinoPageScaffold(
              child: Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(children: [
                      CupertinoButton(alignment: Alignment.centerLeft,
                        padding: EdgeInsets.zero,
                        child: Icon(Icons.chevron_left,color: getPlatformBrightness() ? Con_white : Con_black, size: 30),
                        onPressed: () {
                        Navigator.pop(context);
                        },
                      )
                    ],),

                    const Padding(
                      padding: EdgeInsets.only(left: 5.0),
                      child: Text(
                        'Verify your\nMobile.',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                          height: 1.3333333333333333,
                        ),
                        textHeightBehavior:
                            TextHeightBehavior(applyHeightToFirstAscent: false),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          ' The OTP has been sent to your registered \n '
                          'mobile number.\n Please enter the OTP.',
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
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 18.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Cupertino_otpTextField(context, 0, f1),
                            Cupertino_otpTextField(context, 1, f2),
                            Cupertino_otpTextField(context, 2, f3),
                            Cupertino_otpTextField(context, 3, f4),
                            Cupertino_otpTextField(context, 4, f5),
                            Cupertino_otpTextField(context, 5, f6),
                          ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Stack(
                            children: [
                              Visibility(
                                visible: !resend,
                                child: Text.rich(
                                  TextSpan(
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: getPlatformBrightness()
                                          ? Dark_AppGreyColor
                                          : AppGreyColor,
                                      height: 1.7857142857142858,
                                    ),
                                    children: [
                                      const TextSpan(
                                        text: 'If you didn\'t receive an OTP!  ',
                                      ),
                                      TextSpan(
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            ResendInSecond = 30;
                                            resend = true;
                                            setState(() {});
                                            Timer.periodic(
                                                const Duration(seconds: 1),
                                                (timer) {
                                              if (ResendInSecond != 1) {
                                                ResendInSecond--;
                                                setState(() {});
                                              } else {
                                                timer.cancel();
                                                resend = false;
                                                setState(() {});
                                              }
                                            });
                                          },
                                        text: 'Resend now',
                                        style: const TextStyle(
                                          color: Chat_Row_UnRead_Color,
                                        ),
                                      ),
                                    ],
                                  ),
                                  textHeightBehavior: const TextHeightBehavior(
                                      applyHeightToFirstAscent: false),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Center(
                                child: Visibility(
                                    visible: resend,
                                    child: Text.rich(TextSpan(
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Chat_Row_UnRead_Color,
                                          height: 0.7857142857142858,
                                        ),
                                        children: [
                                          const TextSpan(text: 'Resend in '),
                                          TextSpan(
                                              text: ResendInSecond.toString()),
                                          const TextSpan(text: ' seconds')
                                        ]))),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        );
  }

  _handleKeyEvent(RawKeyEvent event) {
    setState(() {
      if (event.logicalKey == LogicalKeyboardKey.backspace) {
      } else {}
    });
  }

  Widget _otpTextField(BuildContext context, int pInt, FocusNode _f) {
    return SizedBox(
      width: 35.0,
      height: 40.0,
      child: TextFormField(
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLines: 1,
        autofocus: true,
        focusNode: _f,
        maxLength: 1,
        decoration: const InputDecoration(
          counter: Offstage(),
        ),
        onChanged: (String val) async {
          if (pInt == 0) {
            pStrFirstOtp = val;
            FocusScope.of(context).requestFocus(f2);
            if (pStrFirstOtp.isEmpty) {
              FocusScope.of(context).requestFocus(f1);
            }
          }
          if (pInt == 1) {
            pStrSecondOtp = val;
            f2.unfocus();
            FocusScope.of(context).requestFocus(f3);
            if (pStrSecondOtp.isEmpty) {
              FocusScope.of(context).requestFocus(f1);
            }
          }
          if (pInt == 2) {
            pStrThirdOtp = val;
            f3.unfocus();
            FocusScope.of(context).requestFocus(f4);
            if (pStrThirdOtp.isEmpty) {
              FocusScope.of(context).requestFocus(f2);
            }
          }
          if (pInt == 3) {
            pStrFourthOtp = val;
            f4.unfocus();
            FocusScope.of(context).requestFocus(f5);
            if (pStrFourthOtp.isEmpty) {
              FocusScope.of(context).requestFocus(f3);
            }
          }
          if (pInt == 4) {
            pStrFifthhOtp = val;
            f5.unfocus();
            FocusScope.of(context).requestFocus(f6);
            if (pStrFifthhOtp.isEmpty) {
              FocusScope.of(context).requestFocus(f4);
            }
          }
          if (pInt == 5) {
            pStrSixththOtp = val;
            f6.unfocus();
            if (pStrSixththOtp.isEmpty) {
              FocusScope.of(context).requestFocus(f5);
            }
          }

          if (pStrFirstOtp == "" ||
              pStrSecondOtp == "" ||
              pStrThirdOtp == "" ||
              pStrFourthOtp == "" ||
              pStrFifthhOtp == "" ||
              pStrSixththOtp == "") {}

          String strOtp = pStrFirstOtp.toString() +
              pStrSecondOtp.toString() +
              pStrThirdOtp.toString() +
              pStrFourthOtp.toString() +
              pStrFifthhOtp.toString() +
              pStrSixththOtp.toString();

          if (strOtp.length == 6) {
            // _signInWithPhoneNumber(context, strOtp);
            String? deviceKey = await FirebaseMessaging.instance.getToken();
            sql_usermast_tran.mSetUserOtpDetail(strOtp,
                deviceKey: deviceKey ?? '');

            Navigator.push(
                context, RouteTransitions.slideTransition(ProfilePic("Login")));
          }
        },
      ),
    );
  }

  Widget Cupertino_otpTextField(BuildContext context, int pInt, FocusNode _f) {
    return SizedBox(
      width: 35.0,
      height: 40.0,
      child: CupertinoTextField(
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLines: 1,
        autofocus: true,
        focusNode: _f,
        maxLength: 1,
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Con_Clr_App_2))),
        onChanged: (String val) async {
          if (pInt == 0) {
            pStrFirstOtp = val;
            FocusScope.of(context).requestFocus(f2);
            if (pStrFirstOtp.isEmpty) {
              FocusScope.of(context).requestFocus(f1);
            }
          }
          if (pInt == 1) {
            pStrSecondOtp = val;
            f2.unfocus();
            FocusScope.of(context).requestFocus(f3);
            if (pStrSecondOtp.isEmpty) {
              FocusScope.of(context).requestFocus(f1);
            }
          }
          if (pInt == 2) {
            pStrThirdOtp = val;
            f3.unfocus();
            FocusScope.of(context).requestFocus(f4);
            if (pStrThirdOtp.isEmpty) {
              FocusScope.of(context).requestFocus(f2);
            }
          }
          if (pInt == 3) {
            pStrFourthOtp = val;
            f4.unfocus();
            FocusScope.of(context).requestFocus(f5);
            if (pStrFourthOtp.isEmpty) {
              FocusScope.of(context).requestFocus(f3);
            }
          }
          if (pInt == 4) {
            pStrFifthhOtp = val;
            f5.unfocus();
            FocusScope.of(context).requestFocus(f6);
            if (pStrFifthhOtp.isEmpty) {
              FocusScope.of(context).requestFocus(f4);
            }
          }
          if (pInt == 5) {
            pStrSixththOtp = val;
            f6.unfocus();
            if (pStrSixththOtp.isEmpty) {
              FocusScope.of(context).requestFocus(f5);
            }
          }

          if (pStrFirstOtp == "" ||
              pStrSecondOtp == "" ||
              pStrThirdOtp == "" ||
              pStrFourthOtp == "" ||
              pStrFifthhOtp == "" ||
              pStrSixththOtp == "") {}

          String strOtp = pStrFirstOtp.toString() +
              pStrSecondOtp.toString() +
              pStrThirdOtp.toString() +
              pStrFourthOtp.toString() +
              pStrFifthhOtp.toString() +
              pStrSixththOtp.toString();

          if (strOtp.length == 6) {
            // _signInWithPhoneNumber(context, strOtp);
            String? deviceKey = await FirebaseMessaging.instance.getToken();
            sql_usermast_tran.mSetUserOtpDetail(strOtp,
                deviceKey: deviceKey ?? '');

            Navigator.push(
                context, RouteTransitions.slideTransition(ProfilePic("Login")));
          }
        },
      ),
    );
  }

// Future<void> _signInWithPhoneNumber(
//     BuildContext context, String strOtp) async {
//   FirebaseAuth _auth = FirebaseAuth.instance;
//
//   PhoneAuthCredential credential = PhoneAuthProvider.credential(
//       verificationId: widget.verificationId, smsCode: strOtp);
//   await _auth.signInWithCredential(credential).then((value) {
//     if (value != null) {
//       Navigator.push(context, MaterialPageRoute(
//         builder: (context) {
//           return ProfilePic("Login");
//         },
//       ));
//     }
//   });
// }
}
