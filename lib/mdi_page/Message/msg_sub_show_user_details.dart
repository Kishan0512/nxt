import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nextapp/A_SQL_Trigger/sql_contact.dart';
import 'package:nextapp/A_SQL_Trigger/sql_sub_messages.dart';
import 'package:nextapp/Constant/Con_AppBar_ChatProfile.dart';
import 'package:nextapp/Constant/Con_Clr.dart';
import 'package:nextapp/Constant/Con_Icons.dart';

import '../../A_FB_Trigger/SharedPref.dart';
import '../../A_FB_Trigger/sql_need_main_sub_chat.dart';
import '../../Constant/Con_Profile_Get.dart';
import '../../Constant/Con_Wid.dart';
import '../../Constant/Constants.dart';
import '../../OSFind.dart';
import 'msg_sub_quickreplies.dart';
import 'msg_sub_show_media_list.dart';

class sub_show_user_details extends StatefulWidget {
  late String usermastid;
  late String mStrMobile;
  late String mStrName;
  late String user_profile;
  late String user_bio;
  late String user_last_biodate;
  late String user_last_birthdate;
  late String user_last_final_mobile_number;
  late bool user_block;
  late List<Need_Main_Sub_Chat> imageList;
  late List<Need_Main_Sub_Chat> videolist;
  late List<Need_Main_Sub_Chat> audiolist;
  late List<Need_Main_Sub_Chat> doculist;

  sub_show_user_details(
      this.usermastid,
      this.mStrMobile,
      this.mStrName,
      this.user_profile,
      this.user_bio,
      this.user_last_biodate,
      this.user_last_birthdate,
      this.user_last_final_mobile_number,
      this.user_block,
      this.imageList,
      this.videolist,
      this.audiolist,
      this.doculist,
      {Key? key})
      : super(key: key);

  @override
  _sub_show_user_details_detailsPageState createState() =>
      _sub_show_user_details_detailsPageState();
}

class _sub_show_user_details_detailsPageState
    extends State<sub_show_user_details> {
  _sub_show_user_details_detailsPageState();

  int pIntMediaCount = 0;
  bool mBlnMuteNotifcation = false;

  @override
  void initState() {
    super.initState();
    GetMuteValue();
  }

  GetMuteValue() async {
    mBlnMuteNotifcation =
        await SharedPref.read_bool('mute_user_${widget.usermastid}') ?? false;
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Os.isIOS
          ? Scaffold(
              appBar: AppBar(
                titleSpacing: -8,
                leadingWidth: 45,
                elevation: 0,
                automaticallyImplyLeading: false,
                leading: Container(
                  margin: const EdgeInsets.only(left: 6),
                  child: Con_Wid.mIconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Own_ArrowBack),
                ),
              ),
              body: Container(
                color: getPlatformBrightness() ? Con_Clr_App_3 : Con_Clr_App_4,
                child: ListView(shrinkWrap: true, children: [
                  Container(
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                        color: getPlatformBrightness()
                            ? Dark_Divider_Shadow
                            : Light_Divider_Shadow,
                        blurStyle: BlurStyle.outer,
                        blurRadius: 2,
                      ),
                      // BoxShadow(
                      //     color: const Con_Clr_App_4, offset: Offset(0, -5)),
                    ]),
                    child: Container(
                      color: getPlatformBrightness()
                          ? DarkTheme_Main
                          : LightTheme_White,
                      child: Column(children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                RouteTransitions.slideTransition(sub_show_profile_details(
                                    widget.mStrMobile.toString(),
                                    widget.mStrName.toString(),
                                    widget.user_profile.toString())));
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Column(
                              children: <Widget>[
                                Stack(fit: StackFit.loose, children: <Widget>[
                                  Container(
                                      height: 135,
                                      width: 135,
                                      padding: const EdgeInsets.all(3),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              width: 2, color: Con_Clr_App_7)),
                                      child: Con_profile_get(
                                        pStrImageUrl: widget.user_profile,
                                        Size: 120,
                                      )),
                                ]),
                              ],
                            ),
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Text(
                              widget.mStrName,
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                        widget.user_last_final_mobile_number
                                    .contains(widget.mStrName) ==
                                false
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Text(
                                    widget.user_last_final_mobile_number,
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ),
                              )
                            : Container(),
                        const SizedBox(height: 15),
                      ]),
                    ),
                  ),
                  Container(
                      margin: const EdgeInsets.only(top: 7),
                      child: Container(
                        decoration: BoxDecoration(
                            color: getPlatformBrightness()
                                ? DarkTheme_Main
                                : LightTheme_White,
                            boxShadow: [
                              BoxShadow(
                                color: getPlatformBrightness()
                                    ? Dark_Divider_Shadow
                                    : Light_Divider_Shadow,
                                blurStyle: BlurStyle.outer,
                                blurRadius: 2,
                              ),
                              getPlatformBrightness()
                                  ? const BoxShadow()
                                  : const BoxShadow(
                                      color: Color(0xffeaf2f5),
                                      blurRadius: 1,
                                      offset: Offset(0, -2))
                            ]),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Container(
                                      margin: const EdgeInsets.only(left: 6),
                                      padding: const EdgeInsets.all(10.0),
                                      child: const Text("Information",
                                          style: TextStyle(
                                            color: App_IconColor,
                                            fontSize: 17.0,
                                          )))
                                ],
                              ),
                            ),
                            ListTile(
                              leading: const Padding(
                                padding: EdgeInsets.only(top: 8.0),
                                child:
                                    Icon(Icons.details, color: App_IconColor),
                              ),
                              title: Text(
                                widget.user_bio.replaceAll("\n", ''),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Text(
                                  widget.user_last_biodate,
                                ),
                              ),
                            ),
                            widget.user_last_birthdate.isNotEmpty
                                ? ListTile(
                                    leading: const Padding(
                                      padding: EdgeInsets.only(top: 8.0),
                                      child: Icon(Icons.celebration,
                                          color: App_IconColor),
                                    ),
                                    title: Text(widget.user_last_birthdate),
                                    subtitle: const Text("Birthdate"),
                                  )
                                : Container(),
                            ListTile(
                              leading: const Padding(
                                padding: EdgeInsets.only(top: 8.0),
                                child: Icon(Icons.phone, color: App_IconColor),
                              ),
                              title: Text(
                                (widget.user_last_final_mobile_number),
                              ),
                              subtitle: const Text("Mobile"),
                              trailing: GestureDetector(
                                child: Own_Message,
                                onTap: () {
                                  Navigator.pop(context, true);
                                },
                              ),
                              onLongPress: () {
                                Clipboard.setData(ClipboardData(
                                    text: (widget
                                        .user_last_final_mobile_number)));
                                Fluttertoast.showToast(
                                  msg: "Phone number copied",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                );
                              },
                            ),
                          ],
                        ),
                      )),
                  Container(
                    margin: const EdgeInsets.only(top: 7),
                    decoration: BoxDecoration(
                        color: getPlatformBrightness()
                            ? DarkTheme_Main
                            : LightTheme_White,
                        boxShadow: [
                          BoxShadow(
                            color: getPlatformBrightness()
                                ? Dark_Divider_Shadow
                                : Light_Divider_Shadow,
                            blurStyle: BlurStyle.outer,
                            blurRadius: 2,
                          ),
                          getPlatformBrightness()
                              ? const BoxShadow()
                              : const BoxShadow(
                                  color: Color(0xffeaf2f5),
                                  blurRadius: 1,
                                  offset: Offset(0, -2))
                        ]),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              margin: const EdgeInsets.only(top: 5, left: 6),
                              padding: const EdgeInsets.all(10.0),
                              child: const Material(
                                color: Con_transparent,
                                child: Text("More options",
                                    style: TextStyle(
                                      color: App_IconColor,
                                      fontSize: 17.0,
                                    )),
                              )),
                          SwitchListTile(
                              activeColor: Con_blue,
                              secondary: const Padding(
                                padding: EdgeInsets.only(top: 3.0),
                                child: Icon(
                                  Icons.notifications,
                                  color: App_IconColor,
                                ),
                              ),
                              value: mBlnMuteNotifcation,
                              title: const Text('Mute notifications'),
                              onChanged: (bool value) {
                                setState(() {
                                  mBlnMuteNotifcation = value;
                                  SharedPref.save_bool(
                                      'mute_user_${widget.usermastid}', value);
                                });
                              }),
                          ListTile(
                              title: const Text('Media list'),
                              leading: const Icon(
                                Icons.perm_media,
                                color: App_IconColor,
                              ),
                              onTap: () {
                                Navigator.of(context).push(
                                    MaterialPageRoute<void>(
                                        builder: (BuildContext context) {
                                  return MsgMediaList(
                                    widget.mStrMobile,
                                    widget.mStrName,
                                    widget.usermastid,
                                    widget.imageList,
                                    widget.videolist,
                                    widget.audiolist,
                                    widget.doculist,
                                  );
                                }));
                              },
                              trailing:
                                  // FutureBuilder(
                                  //     future: CountData(),
                                  //     builder: (context, snapshot) {
                                  //       if (snapshot.connectionState ==
                                  //               ConnectionState.waiting &&
                                  //           !snapshot.hasData &&
                                  //           snapshot.data == null) {
                                  //         return const Text("");
                                  //       }
                                  //
                                  //       return
                                  Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                        pIntMediaCount <= 0
                                            ? ""
                                            : pIntMediaCount.toString(),
                                        style: const TextStyle(
                                            color: Con_black87)),
                                    const Icon(Icons.keyboard_arrow_right)
                                  ],
                                ),
                              )
                              // }),
                              ),
                          ListTile(
                            title: const Text('Clear Chat'),
                            leading: Clear_Chat,
                            onTap: () async {
                              ConfirmClear();
                            },
                          ),
                        ]),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 7),
                    decoration: BoxDecoration(
                        color: getPlatformBrightness()
                            ? DarkTheme_Main
                            : LightTheme_White,
                        boxShadow: [
                          BoxShadow(
                            color: getPlatformBrightness()
                                ? Dark_Divider_Shadow
                                : Light_Divider_Shadow,
                            blurStyle: BlurStyle.outer,
                            blurRadius: 2,
                          ),
                          getPlatformBrightness()
                              ? const BoxShadow()
                              : const BoxShadow(
                                  color: Color(0xffeaf2f5),
                                  blurRadius: 1,
                                  offset: Offset(0, -2))
                        ]),
                    child: Container(
                      color: getPlatformBrightness()
                          ? DarkTheme_Main
                          : LightTheme_White,
                      child: Column(children: [
                        ListTile(
                          leading: const Icon(Icons.block, color: Con_red),
                          title: Text(
                            widget.user_block == true ? "Unblock" : "Block",
                          ),
                          onTap: () {
                            if (widget.user_block == false) {
                              widget.user_block = true;
                            } else {
                              widget.user_block = false;
                            }
                            sql_contact_tran.mSetUserWiseUpdateFav(
                                widget.mStrMobile.toString(),
                                'user_is_block',
                                widget.user_block == true ? "1" : "0");
                            int count = 0;
                            setState(() {});
                            Navigator.of(context).popUntil((_) => count++ >= 2);
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.thumb_down, color: Con_red),
                          title: const Text("Report"),
                          onTap: () {
                            if (widget.user_block == false) {
                              widget.user_block = true;
                            } else {
                              widget.user_block = false;
                            }
                            sql_contact_tran.mSetUserWiseUpdateFav(
                                widget.mStrMobile.toString(),
                                'user_is_block',
                                widget.user_block == true ? "1" : "0");

                            int count = 0;
                            setState(() {});
                            Navigator.of(context).popUntil((_) => count++ >= 2);
                          },
                        ),
                      ]),
                    ),
                  ),
                ]),
              ),
            )
          : CupertinoPageScaffold(
              navigationBar: CupertinoNavigationBar(
                  padding: EdgeInsetsDirectional.zero,
                  leading: CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: const Icon(CupertinoIcons.left_chevron,
                        color: Con_white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  backgroundColor: App_IconColor),
              child: Container(
                color: getPlatformBrightness() ? Con_Clr_App_3 : Con_Clr_App_4,
                child: ListView(shrinkWrap: true, children: [
                  Container(
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                        color: getPlatformBrightness()
                            ? Dark_Divider_Shadow
                            : Light_Divider_Shadow,
                        blurStyle: BlurStyle.outer,
                        blurRadius: 2,
                      ),
                      const BoxShadow(color: Con_white, offset: Offset(0, -5)),
                    ]),
                    child: Container(
                      color: getPlatformBrightness()
                          ? DarkTheme_Main
                          : LightTheme_White,
                      child: Column(children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                RouteTransitions.slideTransition(sub_show_profile_details(
                                    widget.mStrMobile.toString(),
                                    widget.mStrName.toString(),
                                    widget.user_profile.toString())));
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Column(
                              children: <Widget>[
                                Stack(fit: StackFit.loose, children: <Widget>[
                                  Container(
                                      height: 135,
                                      width: 135,
                                      padding: const EdgeInsets.all(3),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              width: 2, color: Con_Clr_App_7)),
                                      child: Con_profile_get(
                                        pStrImageUrl: widget.user_profile,
                                        Size: 120,
                                      )),
                                ]),
                              ],
                            ),
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Material(
                              color: Con_transparent,
                              child: Text(
                                widget.mStrName,
                                style: const TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Material(
                              color: Con_transparent,
                              child: Text(
                                widget.user_last_final_mobile_number,
                                style: const TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                      ]),
                    ),
                  ),
                  Container(
                      margin: const EdgeInsets.only(top: 7),
                      child: Container(
                        decoration: BoxDecoration(
                            color: getPlatformBrightness()
                                ? DarkTheme_Main
                                : LightTheme_White,
                            boxShadow: [
                              BoxShadow(
                                color: getPlatformBrightness()
                                    ? Dark_Divider_Shadow
                                    : Light_Divider_Shadow,
                                blurStyle: BlurStyle.outer,
                                blurRadius: 2,
                                // offset: Offset(0, 5)
                              ),
                            ]),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Container(
                                      margin: const EdgeInsets.only(left: 6),
                                      padding: const EdgeInsets.all(10.0),
                                      child: const Material(
                                        color: Con_transparent,
                                        child: Text("Information",
                                            style: TextStyle(
                                              color: App_IconColor,
                                              fontSize: 17.0,
                                            )),
                                      ))
                                ],
                              ),
                            ),
                            CupertinoListTile(
                              leading: const Padding(
                                padding: EdgeInsets.only(top: 8.0),
                                child:
                                    Icon(Icons.details, color: App_IconColor),
                              ),
                              title: Text(
                                widget.user_bio.replaceAll("\n", ''),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Text(
                                  widget.user_last_biodate,
                                ),
                              ),
                            ),
                            widget.user_last_birthdate.isNotEmpty
                                ? CupertinoListTile(
                                    leading: const Padding(
                                      padding: EdgeInsets.only(top: 8.0),
                                      child: Icon(Icons.celebration,
                                          color: App_IconColor),
                                    ),
                                    title: Text(widget.user_last_birthdate),
                                    subtitle: const Text("Birthdate"),
                                  )
                                : Container(),
                            CupertinoListTile(
                              leading: const Padding(
                                padding: EdgeInsets.only(top: 8.0),
                                child: Icon(Icons.phone, color: App_IconColor),
                              ),
                              title: Text(
                                (widget.user_last_final_mobile_number),
                              ),
                              subtitle: const Text("Mobile"),
                              trailing: GestureDetector(
                                child: Own_Message,
                                onTap: () {
                                  Navigator.pop(context, true);
                                },
                              ),
                              // onLongPress: () {
                              //   Clipboard.setData(ClipboardData(
                              //       text: (widget
                              //           .user_last_final_mobile_number)));
                              //   Fluttertoast.showToast(
                              //     msg: "Phone number copied",
                              //     toastLength: Toast.LENGTH_SHORT,
                              //     gravity: ToastGravity.BOTTOM,
                              //   );
                              // },
                            ),
                          ],
                        ),
                      )),
                  Container(
                    margin: const EdgeInsets.only(top: 7),
                    decoration: BoxDecoration(
                        color: getPlatformBrightness()
                            ? DarkTheme_Main
                            : LightTheme_White,
                        boxShadow: [
                          BoxShadow(
                            color: getPlatformBrightness()
                                ? Dark_Divider_Shadow
                                : Light_Divider_Shadow,
                            blurStyle: BlurStyle.outer,
                            blurRadius: 2,
                            // offset: Offset(0, 5)
                          ),
                        ]),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              margin: const EdgeInsets.only(top: 5, left: 6),
                              padding: const EdgeInsets.all(10.0),
                              child: const Material(
                                color: Con_transparent,
                                child: Text("More options",
                                    style: TextStyle(
                                      color: App_IconColor,
                                      fontSize: 17.0,
                                    )),
                              )),
                          CupertinoListTile(
                            trailing: CupertinoSwitch(
                                activeColor: App_IconColor,
                                value: mBlnMuteNotifcation,
                                onChanged: (bool value) {
                                  setState(() {
                                    mBlnMuteNotifcation = value;
                                    SharedPref.save_bool(
                                        'mute_user_${widget.usermastid}',
                                        value);
                                  });
                                }),
                            title: const Text('Mute notifications'),
                          ),
                          CupertinoListTile(
                              title: const Text('Media list'),
                              leading: const Icon(
                                Icons.perm_media,
                                color: App_IconColor,
                              ),
                              onTap: () {
                                Navigator.of(context).push(
                                    MaterialPageRoute<void>(
                                        builder: (BuildContext context) {
                                  return MsgMediaList(
                                    widget.mStrMobile,
                                    widget.mStrName,
                                    widget.usermastid,
                                    widget.imageList,
                                    widget.videolist,
                                    widget.audiolist,
                                    widget.doculist,
                                  );
                                }));
                              },
                              trailing:
                                  // FutureBuilder(
                                  //     future: CountData(),
                                  //     builder: (context, snapshot) {
                                  //       if (snapshot.connectionState ==
                                  //               ConnectionState.waiting &&
                                  //           !snapshot.hasData &&
                                  //           snapshot.data == null) {
                                  //         return const Text("");
                                  //       }
                                  //
                                  //       return
                                  Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                        pIntMediaCount <= 0
                                            ? ""
                                            : pIntMediaCount.toString(),
                                        style: const TextStyle(
                                            color: Con_black87)),
                                    const Icon(CupertinoIcons.right_chevron)
                                  ],
                                ),
                              )
                              // }),
                              ),
                          CupertinoListTile(
                              title: const Text('Quick Reply'),
                              leading: const Icon(
                                Icons.reply,
                                color: App_IconColor,
                              ),
                              onTap: () {
                                Navigator.push(
                                    context, RouteTransitions.slideTransition(QuickReplies()));
                              },
                              trailing:
                                  // FutureBuilder(
                                  //     future: CountData(),
                                  //     builder: (context, snapshot) {
                                  //       if (snapshot.connectionState ==
                                  //               ConnectionState.waiting &&
                                  //           !snapshot.hasData &&
                                  //           snapshot.data == null) {
                                  //         return const Text("");
                                  //       }
                                  //
                                  //       return
                                  Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                        pIntMediaCount <= 0
                                            ? ""
                                            : pIntMediaCount.toString(),
                                        style: const TextStyle(
                                            color: Con_black87)),
                                    const Icon(CupertinoIcons.right_chevron)
                                  ],
                                ),
                              )
                              // }),
                              ),
                          CupertinoListTile(
                            title: const Text('Clear Chat'),
                            leading: Clear_Chat,
                            onTap: () async {
                              Cupertino_ConfirmClear();
                            },
                          ),
                        ]),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 7),
                    decoration: const BoxDecoration(boxShadow: [
                      BoxShadow(
                          color: Light_Divider_Shadow,
                          blurStyle: BlurStyle.outer,
                          blurRadius: 1,
                          offset: Offset(0, -7.5)),
                      BoxShadow(color: Con_white, offset: Offset(0, 0)),
                    ]),
                    child: Container(
                      color: getPlatformBrightness()
                          ? DarkTheme_Main
                          : LightTheme_White,
                      child: Column(children: [
                        CupertinoListTile(
                          leading: const Icon(Icons.block, color: Con_red),
                          title: Text(
                            widget.user_block == true ? "Unblock" : "Block",
                          ),
                          onTap: () {
                            setState(() {
                              if (widget.user_block == false) {
                                widget.user_block = true;
                              } else {
                                widget.user_block = false;
                              }
                              sql_contact_tran.mSetUserWiseUpdateFav(
                                  widget.mStrMobile.toString(),
                                  'user_is_block',
                                  widget.user_block == true ? "1" : "0");
                              int count = 0;
                              Navigator.of(context)
                                  .popUntil((_) => count++ >= 2);
                            });
                          },
                        ),
                        CupertinoListTile(
                          leading: const Icon(Icons.thumb_down, color: Con_red),
                          title: const Text("Report"),
                          onTap: () {
                            setState(() async {
                              if (widget.user_block == false) {
                                widget.user_block = true;
                              } else {
                                widget.user_block = false;
                              }
                              sql_contact_tran.mSetUserWiseUpdateFav(
                                  widget.mStrMobile.toString(),
                                  'user_is_block',
                                  widget.user_block == true ? "1" : "0");

                              int count = 0;
                              Navigator.of(context)
                                  .popUntil((_) => count++ >= 2);
                            });
                          },
                        ),
                      ]),
                    ),
                  ),
                ]),
              )),
    );
  }

  // ConfirmBlock(bool isblock) async {
  //   Con_Wid.mConfirmDialog(
  //       context: context,
  //       title: isblock ? "Block!" : "Unblock!",
  //       message:
  //           'Are you sure you want to ${isblock ? "Block" : "Unblock"} ${widget.mStrName} ?',
  //       onOkPressed: () {
  //         if (isblock) {
  //           setState(() {
  //             if (mBlnIsBlockMe == false) {
  //               mBlnIsBlockMe = true;
  //               widget.mBlnBlock = mBlnIsBlockMe;
  //             } else {
  //               mBlnIsBlockMe = false;
  //               widget.mBlnBlock = mBlnIsBlockMe;
  //             }
  //             sql_contact_tran.mSetUserWiseUpdateFav(
  //                 widget.mStrMobile.toString(),
  //                 'user_is_block',
  //                 widget.mBlnBlock == true ? "1" : "0");
  //           });
  //         } else {
  //           setState(() {
  //             mBlnIsBlockMe = false;
  //             widget.mBlnBlock = false;
  //             sql_contact_tran.mSetUserWiseUpdateFav(
  //                 widget.mStrMobile.toString(), 'user_is_block', "0");
  //           });
  //         }
  //         Navigator.pop(context);
  //       },
  //       onCancelPressed: () {
  //         Navigator.pop(context);
  //       });
  // }
  Cupertino_ConfirmClear() {
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          content: const Text(
              'Are you sure you want to clear all messages and media of from this chat ?'),
          title: const Text("Clear all chat"),
          actions: [
            CupertinoDialogAction(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel")),
            CupertinoDialogAction(
                onPressed: () {
                  setState(() {
                    Constants_List.needs_main_chat
                        .where((e) =>
                            e.user_mast_id.toString() == widget.usermastid)
                        .toList()
                        .forEach((e) {
                      sql_sub_messages_tran.Sub_UserWiseClear(
                        e.msg_from_user_mast_id.toString(),
                        e.msg_to_user_mast_id,
                      );
                    });
                    Navigator.pop(context);
                  });
                },
                child: const Text("Ok"))
          ],
        );
      },
    );
  }

  ConfirmClear() {
    Con_Wid.mConfirmDialog(
        context: context,
        title: "Clear all chat",
        message:
            'Are you sure you want to clear all messages and media of from this chat ?',
        onOkPressed: () {
          setState(() {
            Constants_List.needs_main_chat
                .where((e) => e.user_mast_id.toString() == widget.usermastid)
                .toList()
                .forEach((e) {
              sql_sub_messages_tran.Sub_UserWiseClear(
                e.msg_from_user_mast_id.toString(),
                e.msg_to_user_mast_id,
              );
            });
            Navigator.pop(context);
          });
        },
        onCancelPressed: () {
          Navigator.pop(context);
        });
  }

  CountData() async {}
}
