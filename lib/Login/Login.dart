import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:phone_number/phone_number.dart';

import '../A_FB_Trigger/SharedPref.dart';
import '../A_Local_DB/Sync_Json.dart';
import '../A_SQL_Trigger/sql_devicesession.dart';
import '../A_SQL_Trigger/sql_usermast.dart';
import '../Constant/Con_Clr.dart';
import '../Constant/Con_Usermast.dart';
import '../Constant/Con_Wid.dart';
import '../Constant/CountryCodePicker/country_code_picker.dart';
import '../Login/Otp.dart';
import '../OSFind.dart';
import '../mdi_page/chat_mdi_page.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  String pStrMobile = '';
  String pStrCountryCode = "";
  TextEditingController myController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  bool load = false;
  bool isTapped = false;

  @override
  void initState() {
    super.initState();
  }

  Future deleteData() async {
    try {
      SyncJSon.user_mast_table_Clear();
      SharedPref.clear();
      Constants_Usermast.BlankCaller();
      Directory appDir = await getApplicationDocumentsDirectory();
      String hivePath = appDir.path + '/databases';
      Directory(hivePath).deleteSync(recursive: true);
    } catch (e) {
      print("ERROR FROM DELETE DATA  " + e.toString());
    }
    MdiMainPage.mDelete.clear();
  }

  @override
  Widget build(BuildContext context) {
    final concodepicker = CountryCodePicker(
      initialSelection: 'IN',
      onChanged: (
        print1,
      ) async {
        pStrCountryCode = (print1.dialCode)!;
      },
      favorite: const ['+91', 'IN'],
      showCountryOnly: false,
      showFlagDialog: true,
      alignLeft: true,
      closeIcon: const Icon(Icons.close, size: 20),
      padding: const EdgeInsets.only(right: 0.0),
      boxDecoration: const BoxDecoration(
        color: Con_white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          bottomLeft: Radius.circular(30),
          topLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        border: Border(
          right: BorderSide(width: 2, color: Con_Main_1),
          left: BorderSide(width: 2, color: Con_Main_1),
          bottom: BorderSide(width: 2, color: Con_Main_1),
          top: BorderSide(width: 2, color: Con_Main_1),
        ),
      ),
      onInit: (code) async {
        if (code != null) {
          pStrCountryCode = (code.dialCode)!;
        }
      },
    );

    return WillPopScope(
      onWillPop: () {
        SystemChannels.platform.invokeListMethod('SystemNavigator.pop');
        return Future.value();
      },
      child: Os.isIOS? Scaffold(
        body: Container(
          child: Column(
            children: [
              Spacer(),
              // Container(
              //   padding: EdgeInsets.only(
              //       top: WidgetsBinding.instance.window.viewInsets.bottom > 0.0
              //           ? MediaQuery.of(context).size.height * 0.06
              //           : MediaQuery.of(context).size.height * 0.11,
              //       left: 30,
              //       right: 30),
              //   child: Center(
              //     child: Image(
              //       image:
              //           AssetImage(Constants_Usermast.user_appfirstscreen_logo),
              //       height: 130,
              //       width: 150,
              //     ),
              //   ),
              // ),
              const SizedBox(
                height: 20,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 30, right: 30),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Welcome.",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    )),
              ),
              const SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "A new and exciting way to chat with loved ones!",
                      style: TextStyle(fontFamily: "Inter",
                        fontSize: 16,
                        color: getPlatformBrightness()
                            ? Dark_AppGreyColor
                            : AppGreyColor,
                      ),
                    )),
              ),
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 0),
                      child: concodepicker,
                    ),
                  ),
                  Expanded(
                    flex: 13,
                    child: Center(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        maxLength: 15,
                        onTap: () {},
                        autofocus: false,
                        obscureText: false,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          counterText: "",
                          hintText: 'Mobile Number',
                        ),
                        controller: myController,
                        onChanged: (String val) {
                          pStrMobile = val;
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const Center(
                  child: Divider(
                height: 1,
                thickness: 2,
                indent: 30,
                endIndent: 15,
                color: Color.fromRGBO(112, 112, 112, 0.30),
              )),
              const SizedBox(
                height: 20,
              ),
              Visibility(
                  visible: load,
                  child: const CircularProgressIndicator(
                    color: Con_Main_1,
                  )),
              Spacer(),
              Spacer(),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onHighlightChanged: (value) {
                      setState(() {
                        isTapped = value;
                      });
                    },
                    onTap: () async {
                      deleteData();

                          var pStrMobileNumber = (pStrMobile
                              .toString()
                              .trim()
                              .replaceAll("[^a-zA-Z]", "")
                              .replaceAll(RegExp(r'[^\w\s]+'), '')
                              .replaceAll(" ", '')
                              .trim()
                              .trimRight()
                              .trimLeft());
                          var RetVal = validateMobile(pStrMobileNumber);
                          if (RetVal != '') {
                            Fluttertoast.showToast(
                              msg: RetVal.toString(),
                              toastLength: Toast.LENGTH_SHORT,
                            );
                            return;
                          }
                          bool isValid = await PhoneNumberUtil().validate(
                              pStrMobileNumber,
                              regionCode:
                                  concodepicker.initialSelection.toString());
                          // bool? isValid = await PhoneNumberUtil.validate(
                          //     phoneNumber: pStrMobileNumber,
                          //     isoCode: concodepicker.initialSelection.toString());
                          if (!isValid) {
                            Fluttertoast.showToast(
                              msg: 'Mobile Number is not valid',
                              toastLength: Toast.LENGTH_SHORT,
                            );
                            return;
                          } else {
                            if (pStrMobileNumber != "") {
                              try {
                                // await FirebaseAuth.instance.verifyPhoneNumber(
                                //   phoneNumber:
                                //       '${pStrCountryCode.toString() + pStrMobile.toString()}',
                                //   verificationCompleted:
                                //       (PhoneAuthCredential credential) async {
                                //     await auth.signInWithCredential(credential);
                                //   },
                                //   verificationFailed: (FirebaseAuthException e) {
                                //     if (e.code == 'invalid-phone-number') {
                                //       print(
                                //           'The provided phone number is not valid.');
                                //     }
                                //   },
                                //   codeSent:
                                //       (String verificationId, int? resendToken) {
                                //     CalltoNewpage(pStrMobileNumber, verificationId);
                                CalltoNewpage(pStrMobileNumber, "");
                                //     setState(() {});
                                //   },
                                //   codeAutoRetrievalTimeout:
                                //       (String verificationId) {},
                                // );
                              } catch (e) {
                                print("Firebase auth ---------> $e");
                              }
                            }
                            setState(() {});
                          }
                    },
                    child: Center(
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.fastLinearToSlowEaseIn,
                        height: isTapped ? 40 : 45,
                        width: isTapped ? 180 : 200,
                        decoration: BoxDecoration(
                          color: Con_Main_1,
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x19000000),
                              blurRadius: 4,
                              offset: Offset(0, 4),
                              spreadRadius: 0,
                            )
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'Log in',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                              height: 0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ):CupertinoPageScaffold(child:  Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(
                  top: WidgetsBinding.instance.window.viewInsets.bottom > 0.0
                      ? MediaQuery.of(context).size.height * 0.06
                      : MediaQuery.of(context).size.height * 0.11,
                  left: 30,
                  right: 30),
              child: Center(
                child: Image(
                  image:
                  AssetImage(Constants_Usermast.user_appfirstscreen_logo),
                  height: 130,
                  width: 150,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 30, right: 30),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Welcome.",
                    style:
                    TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  )),
            ),
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "A new and exciting way to chat with loved ones!",
                    style: TextStyle(
                      fontSize: 16,
                      color: getPlatformBrightness()
                          ? Dark_AppGreyColor
                          : AppGreyColor,
                    ),
                  )),
            ),
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 0),
                    child: concodepicker,
                  ),
                ),
                Expanded(
                  flex: 13,
                  child: Center(
                    child: CupertinoTextField(
                      keyboardType: TextInputType.number,
                      maxLength: 15,
                      onTap: () {},
                      autofocus: false,
                      obscureText: false,
                      placeholder: "Mobile Number",
                      decoration: BoxDecoration(border: Border.all(width: 0,color: Colors.transparent)),
                      controller: myController,
                      onChanged: (String val) {
                        pStrMobile = val;
                      },
                    ),
                  ),
                ),
              ],
            ),
            const Center(
                child: Divider(
                  height: 1,
                  thickness: 2,
                  indent: 30,
                  endIndent: 15,
                  color: Color.fromRGBO(112, 112, 112, 0.30),
                )),
            const SizedBox(
              height: 20,
            ),
            Visibility(
                visible: load,
                child: const CircularProgressIndicator(
                  color: Con_Main_1,
                )),

            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding:  EdgeInsets.only(bottom:30),
                  child:
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onHighlightChanged: (value) {
                        setState(() {
                          isTapped = value;
                        });
                      },
                      onTap: () async {
                        deleteData();

                        var pStrMobileNumber = (pStrMobile
                            .toString()
                            .trim()
                            .replaceAll("[^a-zA-Z]", "")
                            .replaceAll(RegExp(r'[^\w\s]+'), '')
                            .replaceAll(" ", '')
                            .trim()
                            .trimRight()
                            .trimLeft());
                        var RetVal = validateMobile(pStrMobileNumber);
                        if (RetVal != '') {
                          Fluttertoast.showToast(
                            msg: RetVal.toString(),
                            toastLength: Toast.LENGTH_SHORT,
                          );
                          return;
                        }
                        bool isValid = await PhoneNumberUtil().validate(
                            pStrMobileNumber,
                            regionCode:
                            concodepicker.initialSelection.toString());
                        // bool? isValid = await PhoneNumberUtil.validate(
                        //     phoneNumber: pStrMobileNumber,
                        //     isoCode: concodepicker.initialSelection.toString());
                        if (!isValid) {
                          Fluttertoast.showToast(
                            msg: 'Mobile Number is not valid',
                            toastLength: Toast.LENGTH_SHORT,
                          );
                          return;
                        } else {
                          if (pStrMobileNumber != "") {
                            try {
                              // await FirebaseAuth.instance.verifyPhoneNumber(
                              //   phoneNumber:
                              //       '${pStrCountryCode.toString() + pStrMobile.toString()}',
                              //   verificationCompleted:
                              //       (PhoneAuthCredential credential) async {
                              //     await auth.signInWithCredential(credential);
                              //   },
                              //   verificationFailed: (FirebaseAuthException e) {
                              //     if (e.code == 'invalid-phone-number') {
                              //       print(
                              //           'The provided phone number is not valid.');
                              //     }
                              //   },
                              //   codeSent:
                              //       (String verificationId, int? resendToken) {
                              //     CalltoNewpage(pStrMobileNumber, verificationId);
                              CalltoNewpage(pStrMobileNumber, "");
                              //     setState(() {});
                              //   },
                              //   codeAutoRetrievalTimeout:
                              //       (String verificationId) {},
                              // );
                            } catch (e) {
                              print("Firebase auth ---------> $e");
                            }
                          }
                          setState(() {});
                        }
                      },
                      child: Center(
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.fastLinearToSlowEaseIn,
                          height: isTapped ? 40 : 45,
                          width: isTapped ? 180 : 200,
                          decoration: BoxDecoration(
                            color: Con_Main_1,
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x19000000),
                                blurRadius: 4,
                                offset: Offset(0, 4),
                                spreadRadius: 0,
                              )
                            ],
                          ),
                          child: Center(
                            child: Text(
                              'Log in',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                                height: 0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // ElevatedButton(
                  //   style: ElevatedButton.styleFrom(
                  //       backgroundColor: Con_Main_1,
                  //       minimumSize: const Size(200, 45),
                  //       shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(200.0))),
                  //   onPressed: () async {
                  //     deleteData();
                  //
                  //     var pStrMobileNumber = (pStrMobile
                  //         .toString()
                  //         .trim()
                  //         .replaceAll("[^a-zA-Z]", "")
                  //         .replaceAll(RegExp(r'[^\w\s]+'), '')
                  //         .replaceAll(" ", '')
                  //         .trim()
                  //         .trimRight()
                  //         .trimLeft());
                  //     var RetVal = validateMobile(pStrMobileNumber);
                  //     if (RetVal != '') {
                  //       Fluttertoast.showToast(
                  //         msg: RetVal.toString(),
                  //         toastLength: Toast.LENGTH_SHORT,
                  //       );
                  //       return;
                  //     }
                  //     bool isValid = await PhoneNumberUtil().validate(
                  //         pStrMobileNumber,
                  //         regionCode:
                  //             concodepicker.initialSelection.toString());
                  //     // bool? isValid = await PhoneNumberUtil.validate(
                  //     //     phoneNumber: pStrMobileNumber,
                  //     //     isoCode: concodepicker.initialSelection.toString());
                  //     if (!isValid) {
                  //       Fluttertoast.showToast(
                  //         msg: 'Mobile Number is not valid',
                  //         toastLength: Toast.LENGTH_SHORT,
                  //       );
                  //       return;
                  //     } else {
                  //       if (pStrMobileNumber != "") {
                  //         try {
                  //           // await FirebaseAuth.instance.verifyPhoneNumber(
                  //           //   phoneNumber:
                  //           //       '${pStrCountryCode.toString() + pStrMobile.toString()}',
                  //           //   verificationCompleted:
                  //           //       (PhoneAuthCredential credential) async {
                  //           //     await auth.signInWithCredential(credential);
                  //           //   },
                  //           //   verificationFailed: (FirebaseAuthException e) {
                  //           //     if (e.code == 'invalid-phone-number') {
                  //           //       print(
                  //           //           'The provided phone number is not valid.');
                  //           //     }
                  //           //   },
                  //           //   codeSent:
                  //           //       (String verificationId, int? resendToken) {
                  //           //     CalltoNewpage(pStrMobileNumber, verificationId);
                  //           CalltoNewpage(pStrMobileNumber, "");
                  //           //     setState(() {});
                  //           //   },
                  //           //   codeAutoRetrievalTimeout:
                  //           //       (String verificationId) {},
                  //           // );
                  //         } catch (e) {
                  //           print("Firebase auth ---------> $e");
                  //         }
                  //       }
                  //       setState(() {});
                  //     }
                  //   },
                  //   child: const Text(
                  //     "Log in",
                  //     style: TextStyle(fontSize: 16, height: 1.25),
                  //   ),
                  // ),
                ),
              ),
            ),
          ],
        ),
      ),),
    );
  }

  CalltoNewpage(String pStrMobileNumber, String verificationId) async {
    load = true;
    deleteData();
    await sql_usermast_tran.mSetUserLoginDetails(
        pStrCountryCode, pStrMobileNumber, pStrMobile);
    String number = await SharedPref.read_string('user_id') ?? "";
    if (number.isEmpty || number == "0") {
      load = false;
      setState(() {});
      Fluttertoast.showToast(
        msg: 'Something Went Wrong',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }
    sql_devicesession_tran.setLoginSessionDetails(true);
    SharedPref.save_bool('user_chat_bln_favourite_contacts', true);
    Navigator.push(context, RouteTransitions.slideTransition(const OTP(
        // verificationId: verificationId,
        ))).then((value) {
      load = false;
    });
  }

  String validateMobile(String value) {
    if (value == "") {
      return 'Enter Mobile Number';
    } else if (value.isEmpty) {
      return 'Enter Mobile Number';
    } else if (value.length <= 3) {
      return 'Mobile Number is not valid';
    } else {
      return '';
    }
  }
}
