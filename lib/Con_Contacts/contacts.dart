import 'dart:async';

import 'package:contacts_service/contacts_service.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nextapp/A_FB_Trigger/sql_need_contact.dart';
import 'package:nextapp/A_SQL_Trigger/sql_contact.dart';
import 'package:nextapp/A_SQL_Trigger/sql_sub_messages.dart';
import 'package:nextapp/A_SQL_Trigger/sql_usermast.dart';
import 'package:nextapp/Constant/Con_Clr.dart';
import 'package:nextapp/Constant/Con_Icons.dart';
import 'package:nextapp/Constant/Con_Usermast.dart';
import 'package:nextapp/Constant/Constants.dart';
import 'package:nextapp/Settings/Help/set_sub_help_settings.dart';
import 'package:nextapp/mdi_page/Broadcast/Con_Three_Broadcast.dart';
import 'package:phone_number/phone_number.dart';

import '../A_Local_DB/Sync_Database.dart';
import '../A_Local_DB/Sync_Json.dart';
import '../Constant/Con_Profile_Get.dart';
import '../Constant/Con_Wid.dart';
import '../Constant/CountryCodePicker/country_code_picker.dart';
import '../OSFind.dart';
import '../mdi_page/Message/msg_sub_contactsdetails.dart';
import '../mdi_page/chat_mdi_page.dart';

class Contacts extends StatefulWidget {
  const Contacts({Key? key}) : super(key: key);

  @override
  _Contacts createState() => _Contacts();
}

enum PopUpData { Contacts, Refresh, Help }

class _Contacts extends State<Contacts> {
  List<Item>? phones = [];
  bool isSearching = false;
  final msgController = TextEditingController();
  final mobileController = TextEditingController();
  final _searchQuery = TextEditingController();
  String pStrCountryCode = "", pStrMobile = "";
  List<Need_Contact> _ContactList = [];

  @override
  void initState() {
    super.initState();
    _setupNeeds();
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  _SearchListState() {
    _searchQuery.addListener(() {
      if (_searchQuery.text.isEmpty) {
        setState(() {
          _ContactList = Constants_List.need_contact;
        });
      } else {
        setState(() {
          isSearching = true;
          _setupNeeds();
        });
      }
    });
  }

  Future<List<Need_Contact>> _setupNeeds() async {
    if (_searchQuery.text.isEmpty) {
      // Constants_List.show_contact = await SyncJSon.user_contact_select(0);
      Constants_List.need_contact =
          (await SyncJSon.user_contact_select_contacts_stream());
      _ContactList = Constants_List.need_contact;
    } else {
      _ContactList = Constants_List.need_contact
          .where((element) =>
              element.name
                  .toLowerCase()
                  .toString()
                  .contains(_searchQuery.text.toLowerCase().toString()) ||
              element.mobile_number
                  .toLowerCase()
                  .toString()
                  .contains(_searchQuery.text.toLowerCase().toString()) ||
              element.user_bio
                  .toLowerCase()
                  .toString()
                  .contains(_searchQuery.text.toLowerCase().toString()))
          .toList();
      if (mounted) {
        setState(() {});
      }
    }
    return _ContactList;
  }

  Future<bool> onBackPress() {
    Navigator.pushReplacement(
        context, RouteTransitions.slideTransition(MdiMainPage())
        // RouteTransitions.slideTransition( MdiMainPage())
        );
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onBackPress,
      child: Os.isIOS
          ? Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                automaticallyImplyLeading: true,
                leading: isSearching
                    ? Con_Wid.mIconButton(
                        icon: Own_ArrowBack,
                        onPressed: () {
                          setState(() {
                            isSearching = false;
                            _searchQuery.text = "";
                          });
                        },
                      )
                    : Con_Wid.mIconButton(
                        icon: Own_ArrowBack,
                        onPressed: () {
                          Navigator.pushReplacement(context,
                              RouteTransitions.slideTransition(MdiMainPage()));
                        },
                      ),
                title: isSearching
                    ? TextField(
                        autofocus: true,
                        style: const TextStyle(color: Con_white),
                        keyboardType: TextInputType.text,
                        controller: _searchQuery,
                        onChanged: (value) {
                          setState(() {
                            _SearchListState();
                          });
                        },
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            hintText: "Search.."),
                      )
                    : Con_Wid.mAppBar("Contacts"),
                actions: <Widget>[
                  isSearching
                      ? _searchQuery.text
                              .trim()
                              .trimLeft()
                              .trimRight()
                              .isNotEmpty
                          ? Con_Wid.mIconButton(
                              icon: Own_Delete_Search,
                              onPressed: () {
                                setState(() {
                                  _searchQuery.text = "";
                                  _SearchListState();
                                });
                              },
                            )
                          : const Text("")
                      : Con_Wid.mIconButton(
                          icon: Own_Search,
                          onPressed: () {
                            setState(() {
                              isSearching = true;
                            });
                          },
                        ),
                  isSearching == false
                      ? PopupMenuButton<PopUpData>(
                          splashRadius: 20,
                          onSelected: (PopUpData result) {
                            setState(() {
                              switch (result) {
                                case PopUpData.Contacts:
                                  call_contact_app();
                                  break;
                                case PopUpData.Refresh:
                                  sql_contact_tran.SaveContactDetail();
                                  _setupNeeds();
                                  break;
                                case PopUpData.Help:
                                  Navigator.push(
                                      context,
                                      RouteTransitions.slideTransition(
                                          sub_help_settings()));
                                  break;
                              }
                            });
                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<PopUpData>>[
                            const PopupMenuItem<PopUpData>(
                                height: 30,
                                value: PopUpData.Contacts,
                                child: Text('Contacts    ')),
                            const PopupMenuItem(
                              height: 0,
                              enabled: false,
                              child: Divider(
                                color: Con_Main_1,
                              ),
                            ),
                            const PopupMenuItem<PopUpData>(
                              height: 30,
                              value: PopUpData.Refresh,
                              child: Text('Refresh     '),
                            ),
                            const PopupMenuItem(
                              height: 0,
                              enabled: false,
                              child: Divider(
                                color: Con_Main_1,
                              ),
                            ),
                            const PopupMenuItem<PopUpData>(
                              height: 30,
                              value: PopUpData.Help,
                              child: Text('Help     '),
                            ),
                          ],
                        )
                      : Container(),
                ],
              ),
              body: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                Container(
                margin: const EdgeInsets.only(bottom: 7),
                decoration: BoxDecoration(
                    color: getPlatformBrightness()
                        ? Con_black
                        : Con_white,
                    boxShadow: [
                      BoxShadow(
                        color: getPlatformBrightness()
                            ? Dark_Divider_Shadow
                            : Light_Divider_Shadow,
                        blurStyle: BlurStyle.outer,
                        blurRadius: 2,
                      ),
                      const BoxShadow(
                          color: Con_white,
                          offset: Offset(0, -5)),
                    ]),
                child: Container(
                  color: getPlatformBrightness()
                      ? DarkTheme_Main
                      : LightTheme_White,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, top: 5.0, right: 10.0),
                    child: Center(
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            children: [
                              Container(
                                  child: Con_Wid.mIconButton(
                                    icon: Image.asset(
                                        "assets/images/direct.webp"),
                                    //broadcast
                                    onPressed: () {
                                      msgController.text = "";
                                      mobileController.text = "";
                                      _DirectShow(context);
                                    },
                                  ),
                                  width: 38.0,
                                  height: 38.0,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Con_black12),
                                    shape: BoxShape.circle,
                                    color: App_IconColor,
                                  )),
                              const Padding(
                                padding: EdgeInsets.only(
                                    top: 5.0, bottom: 5.0),
                                child: Text(
                                  "Direct Message",
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.only(left: 30.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    RouteTransitions.slideTransition(
                                        Con_Broadcast("", "", "",
                                            true, const [], "")));
                              },
                              child: Column(
                                children: [
                                  Container(
                                      child: Con_Wid.mIconButton(
                                        icon: Image.asset(
                                            "assets/images/broadcast.webp"),
                                        //broadcast
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              RouteTransitions.slideTransition(
                                                  Con_Broadcast(
                                                      "",
                                                      "",
                                                      "",
                                                      true,
                                                      const [],
                                                      "")));
                                        },
                                      ),
                                      width: 38.0,
                                      height: 38.0,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Con_black12),
                                        shape: BoxShape.circle,
                                        color: App_IconColor,
                                      )),
                                  const Padding(
                                    padding:
                                    EdgeInsets.only(top: 5.0),
                                    child: Text(
                                      "New Broadcast",
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),),
                          _ContactList.isNotEmpty
                              ? Material(
                                  color: Con_transparent,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        "  Contacts (" +
                                            _ContactList.length.toString() +
                                            ")",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Con_msg_auto_6)),
                                  ),
                                )
                              : Container(),
                          Expanded(
                            child: Container(
                              child: FutureBuilder(
                                  future: _setupNeeds(),
                                  builder: (context, snapshot) {
                                    _ContactList.sort(
                                      (a, b) => a.name.compareTo(b.name),
                                    );
                                    return ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: _ContactList.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          Need_Contact need =
                                              _ContactList[index];
                                          return ListTile(
                                              dense: true,
                                              onTap: () {
                                                Navigator.pushReplacement(
                                                    context,
                                                    RouteTransitions
                                                        .slideTransition(
                                                            sub_contactsdetails(
                                                      need.id.toString(),
                                                      need.user_mast_id
                                                          .toString(),
                                                      need.name.toString(),
                                                      need.user_profileimage_path
                                                          .toString(),
                                                      need.user_is_favourite,
                                                      need.user_bio,
                                                      need.user_bio_last_datetime,
                                                      need.user_is_online,
                                                      need.user_last_login_time,
                                                      need.user_birthdate,
                                                      need.user_countrywithmobile,
                                                      need.user_is_block,
                                                      isContact: true,
                                                    )));
                                              },
                                              leading: Con_profile_get(
                                                pStrImageUrl:
                                                    need.user_profileimage_path,
                                                Size: 45,
                                              ),
                                              title: Text(
                                                need.name,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    fontSize: Constants_Fonts
                                                        .mGblFontTitleSize,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              subtitle: Text(
                                                need.user_bio,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontFamily: "Inter",
                                                    fontSize: Constants_Fonts
                                                        .mGblFontSubTitleSize,
                                                    color:
                                                        getPlatformBrightness()
                                                            ? Dark_AppGreyColor
                                                            : AppGreyColor,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ));
                                        });
                                  }),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ))
          : CupertinoPageScaffold(
              navigationBar: CupertinoNavigationBar(
                  padding: EdgeInsetsDirectional.zero,
                  leading: CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: const Icon(CupertinoIcons.left_chevron,
                        color: Con_white),
                    onPressed: () {
                      Navigator.pushReplacement(context,
                          RouteTransitions.slideTransition(MdiMainPage()));
                    },
                  ),
                  backgroundColor: App_IconColor,
                  middle: const Text(
                    "Contacts",
                    style: TextStyle(color: Con_white),
                  )),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CupertinoSearchTextField(
                        controller: _searchQuery,
                        onChanged: (value) {
                          setState(() {
                            _SearchListState();
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            color: getPlatformBrightness()
                                ? Con_Clr_App_3
                                : Con_Clr_App_4,
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 7),
                              decoration: BoxDecoration(
                                  color: getPlatformBrightness()
                                      ? Con_black
                                      : Con_white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: getPlatformBrightness()
                                          ? Dark_Divider_Shadow
                                          : Light_Divider_Shadow,
                                      blurStyle: BlurStyle.outer,
                                      blurRadius: 2,
                                    ),
                                    const BoxShadow(
                                        color: Con_white,
                                        offset: Offset(0, -5)),
                                  ]),
                              child: Container(
                                color: getPlatformBrightness()
                                    ? DarkTheme_Main
                                    : LightTheme_White,
                                child: Material(
                                  color: Con_transparent,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0, top: 5.0, right: 10.0),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Column(
                                            children: [
                                              Container(
                                                  child: Con_Wid.mIconButton(
                                                    icon: Image.asset(
                                                        "assets/images/direct.webp"),
                                                    onPressed: () {
                                                      msgController.text = "";
                                                      mobileController.text =
                                                          "";

                                                      _DirectShowIOs(context);
                                                    },
                                                  ),
                                                  width: 38.0,
                                                  height: 38.0,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Con_black12),
                                                    shape: BoxShape.circle,
                                                    color: App_IconColor,
                                                  )),
                                              const Material(
                                                color: Con_transparent,
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 5.0, bottom: 5.0),
                                                  child: Text(
                                                    "Direct Message",
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 30.0),
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    RouteTransitions
                                                        .slideTransition(
                                                            Con_Broadcast(
                                                                "",
                                                                "",
                                                                "",
                                                                true,
                                                                const [],
                                                                "")));
                                              },
                                              child: Column(
                                                children: [
                                                  Container(
                                                      child:
                                                          Con_Wid.mIconButton(
                                                        icon: Image.asset(
                                                            "assets/images/broadcast.webp"),
                                                        //broadcast
                                                        onPressed: () {
                                                          Navigator.push(
                                                              context,
                                                              RouteTransitions
                                                                  .slideTransition(
                                                                      Con_Broadcast(
                                                                          "",
                                                                          "",
                                                                          "",
                                                                          true,
                                                                          const [],
                                                                          "")));
                                                        },
                                                      ),
                                                      width: 38.0,
                                                      height: 38.0,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Con_black12),
                                                        shape: BoxShape.circle,
                                                        color: App_IconColor,
                                                      )),
                                                  const Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 5.0),
                                                    child: Text(
                                                      "New Broadcast",
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          _ContactList.isNotEmpty
                              ? Material(
                                  color: Con_transparent,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Contacts (" +
                                        _ContactList.length.toString() +
                                        ")"),
                                  ),
                                )
                              : Container(),
                          Expanded(
                            child: Container(
                              child: FutureBuilder(
                                  future: _setupNeeds(),
                                  builder: (context, snapshot) {
                                    return ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: _ContactList.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          Need_Contact need =
                                              _ContactList[index];
                                          return CupertinoListTile(
                                              onTap: () {
                                                Navigator.pushReplacement(
                                                    context,
                                                    RouteTransitions
                                                        .slideTransition(
                                                            sub_contactsdetails(
                                                      need.id.toString(),
                                                      need.user_mast_id
                                                          .toString(),
                                                      need.name.toString(),
                                                      need.user_profileimage_path
                                                          .toString(),
                                                      need.user_is_favourite,
                                                      need.user_bio,
                                                      need.user_bio_last_datetime,
                                                      need.user_is_online,
                                                      need.user_last_login_time,
                                                      need.user_birthdate,
                                                      need.user_countrywithmobile,
                                                      need.user_is_block,
                                                      isContact: true,
                                                    )));
                                              },
                                              leading: Con_profile_get(
                                                pStrImageUrl:
                                                    need.user_profileimage_path,
                                                Size: 45,
                                              ),
                                              title: Text(
                                                need.name,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    fontSize: Constants_Fonts
                                                        .mGblFontTitleSize,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                              subtitle: Text(
                                                need.user_bio,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize: Constants_Fonts
                                                        .mGblFontSubTitleSize,
                                                    color:
                                                        getPlatformBrightness()
                                                            ? Dark_AppGreyColor
                                                            : AppGreyColor,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ));
                                        });
                                  }),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
    );
  }

  Future<void> call_contact_app() async {
    List<Application> apps =
        await DeviceApps.getInstalledApplications(includeSystemApps: true);
    final targetPackages = {
      "com.google.android.contacts",
      "com.samsung.android.app.contacts",
      "com.android.contacts",
      "com.android.htccontacts",
      "com.sonyericsson.android.socialphonebook",
      "com.android.providers.contacts",
    };
    for (var e in apps) {
      final packageName = e.packageName.toString();
      if (targetPackages.any((e) => e == packageName) &&
          await DeviceApps.isAppInstalled(packageName)) {
        DeviceApps.openApp(packageName);
      }
    }
  }

  ContryCodePicker() {
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
      closeIcon: Own_Remove,
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
    return concodepicker;
  }

  onsubmit() async {
    final concodepicker = ContryCodePicker();
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
    // bool? isValid = await PhoneNumberUtil.isValidPhoneNumber(
    //     phoneNumber: pStrMobileNumber,
    //     isoCode: concodepicker.initialSelection.toString());
    bool isValid = await PhoneNumberUtil().validate(pStrMobileNumber,
        regionCode: concodepicker.initialSelection.toString());
    if (!isValid) {
      Fluttertoast.showToast(
        msg: 'Mobile Number is not valid',
        toastLength: Toast.LENGTH_SHORT,
      );
      return;
    } else {
      setState(() {
        if (pStrMobileNumber == "") {
          Fluttertoast.showToast(
            msg: 'Mobile Number is not valid',
            toastLength: Toast.LENGTH_SHORT,
          );
          return;
        } else if (msgController.text
            .toString()
            .trimLeft()
            .trimRight()
            .isEmpty) {
          Fluttertoast.showToast(
            msg: 'Nohting to send',
            toastLength: Toast.LENGTH_SHORT,
          );
          return;
        } else {
          Existusersendmsg(pStrMobileNumber);
        }
      });
    }
  }

  Future _DirectShow(context) async {
    final concodepicker = ContryCodePicker();
    return await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              insetPadding: EdgeInsets.symmetric(
                horizontal: 30,
                vertical: WidgetsBinding.instance.window.viewInsets.bottom > 0.0
                    ? 100
                    : 200,
              ),
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 2.4,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Material(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(3),
                          topRight: Radius.circular(3)),
                      color: Colors.white,
                      child: SizedBox(
                        height: 50,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                  margin:
                                      const EdgeInsets.only(left: 15, top: 5),
                                  child: const Text("Direct  Message",
                                      style: TextStyle(
                                          fontFamily: "Inter",
                                          fontWeight: FontWeight.bold,
                                          color: Con_msg_auto_6,
                                          fontSize: 20))),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            margin: const EdgeInsets.only(
                                left: 7, right: 7, top: 10, bottom: 5),
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              onSaved: (value) {
                                if (value!.length == 10) {
                                  FocusScope.of(context).nextFocus();
                                }
                              },
                              autofocus: true,
                              obscureText: false,
                              decoration: InputDecoration(
                                prefixIcon: SizedBox(
                                    width: 75, height: 25, child: concodepicker
                                    // Container(
                                    //   padding: EdgeInsetsDirectional.zero,
                                    //   child: concodepicker,
                                    // ),
                                    ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: Con_Main_1,
                                      width: 4,
                                    )),
                                hintText: 'Mobile Number',
                              ),
                              controller: mobileController,
                              onChanged: (String val) {
                                pStrMobile = val;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      flex: 5,
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        padding: const EdgeInsets.only(
                            top: 10, left: 7, bottom: 5, right: 7),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextField(
                          controller: msgController,
                          maxLines: 8,
                          autofocus: true,
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.done,
                          onSubmitted: (value) {
                            onsubmit();
                          },
                          decoration: InputDecoration(
                            isDense: true,
                            border: OutlineInputBorder(
                                borderSide: const BorderSide(color: Con_Main_1),
                                borderRadius: BorderRadius.circular(10)),
                            hintText: "Enter your message",
                            hintStyle: const TextStyle(color: Con_grey),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 7.0, bottom: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              child: OutlinedButton(
                                child: const Text("Cancel"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              child: OutlinedButton(
                                child: const Text("Ok",
                                    style: TextStyle(color: Con_white)),
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.resolveWith(
                                            (states) => Con_msg_auto_6)),
                                onPressed: () async {
                                  onsubmit();
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ));
        });
  }

  Future _DirectShowIOs(context) async {
    // final concodepicker = ContryCodePicker();
    return CupertinoDialogRoute(
        builder: (context) {
          return CupertinoAlertDialog();
        },
        context: context);
  }

  Existusersendmsg(String pStrMobileNumber) async {
    var value = await sql_usermast_tran.mSetUserDirectMessageExist(
        pStrCountryCode, pStrMobileNumber, pStrMobile);
    if (value.toString().isEmpty) {
      Fluttertoast.showToast(
        msg: 'User not using NxtApp',
        toastLength: Toast.LENGTH_SHORT,
      );
      return;
    } else {
      var value1 = await sql_contact_tran
          .mContactDirectSaveUser(value.toString().trimRight());

      await sql_sub_messages_tran.Send_Msg(
        sender_name: Constants_Usermast.user_login_name,
        msg_content: msgController.text.trimLeft().trimLeft().trim(),
        msg_type: "1",
        msg_document_url: '',
        from_id: Constants_Usermast.user_id,
        to_id: value.toString(),
        is_broadcast: "0",
        broadcast_id: '',
      );
      await SyncDB.SyncTable("USER_MSG1", true, value.toString());
    }
    Navigator.of(context).pop();
    Navigator.pushReplacement(
        context, RouteTransitions.slideTransition(MdiMainPage()));
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
