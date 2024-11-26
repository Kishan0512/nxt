import 'dart:io';

import 'package:adobe_xd/pinned.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../../A_FB_Trigger/SharedPref.dart';
import '../../A_SQL_Trigger/sql_devicesession.dart';
import '../../Constant/Con_Icons.dart';
import '../../Constant/Con_Usermast.dart';
import '../../Constant/Con_Wid.dart';
import '../../Constant/Constants.dart';
import '../../Login/ProfilePic.dart';
import '../../Settings/Folders/Folders.dart';
import '../../Settings/Notification/set_sub_noti_settings.dart';
import '../../mdi_page/chat_mdi_page.dart';
import '../Constant/Con_Clr.dart';
import '../Constant/Con_Profile_Get.dart';
import '../OSFind.dart';
import 'Chats/set_sub_chat_settings.dart';
import 'Help/set_sub_help_settings.dart';
import 'Privacy/set_sub_privacy_settings.dart';

bool logout = false;

class sub_main_settings extends StatefulWidget {
  const sub_main_settings({Key? key}) : super(key: key);

  @override
  _sub_main_settings createState() => _sub_main_settings();
}

class _sub_main_settings extends State<sub_main_settings> {
  bool Procces = false;

  Future<bool> onBackPress() {
    setState(() {
      Procces = false;
    });
    Navigator.pushReplacement(
        context, RouteTransitions.slideTransition(MdiMainPage()));
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: onBackPress,
      child: Os.isIOS
          ? Scaffold(
              appBar: AppBar(
                elevation: 0,
                automaticallyImplyLeading: false,
                leading: Con_Wid.mIconButton(
                    onPressed: () {
                      setState(() {
                        Procces = false;
                      });
                      Navigator.pushReplacement(context,
                          RouteTransitions.slideTransition(MdiMainPage()));
                    },
                    icon: Own_ArrowBack),
                title: Con_Wid.mAppBar("Settings"),
              ),
              body: Container(

                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height / 4,
                      child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(height: MediaQuery.of(context).size.height / 7,
                              width: MediaQuery.of(context).size.height / 7,
                              child: Stack(
                                fit: StackFit.loose,
                                children: [
                                  InkWell(
                                    borderRadius:
                                    BorderRadius.circular(100),
                                    onTap: () async {
                                      final result = await Navigator.push(
                                                  context, RouteTransitions.slideTransition(ProfilePic("Setting")));
                                              if (result != null) {
                                                if (result != "") {
                                                  setState(() {
                                                    Constants_Usermast.user_bio;
                                                  });
                                                }
                                              }
                                    },
                                    child: Container(

                                      height: MediaQuery.of(context).size.height / 8,
                                      width: MediaQuery.of(context).size.height / 8,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              width: 3,
                                              color: Con_Clr_App_7)),
                                      child: Con_profile_get(
                                        pStrImageUrl: Constants_Usermast
                                            .user_profileimage_path,
                                        Size: 120,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 10,
                                    child: Baseline(
                                      baselineType: TextBaseline.alphabetic,
                                      baseline: MediaQuery.of(context).size.height / 8.5,
                                      child: Container(
                                        height: 35,
                                        width: 35,
                                        decoration:  BoxDecoration(
                                          border: Border.all(color: Con_Main_1,width: 2),
                                          shape: BoxShape.circle,
                                        ),
                                        child: FloatingActionButton(
                                          heroTag: '1',
                                          backgroundColor: Con_white,
                                          shape:
                                          const RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.all(
                                                Radius.circular(30.0),
                                              )),
                                          onPressed: () async {
                                            final result = await Navigator.push(
                                                        context, RouteTransitions.slideTransition(ProfilePic("Setting")));
                                                    if (result != null) {
                                                      if (result != "") {
                                                        setState(() {
                                                          Constants_Usermast.user_bio;
                                                        });
                                                      }
                                                    }
                                          },
                                          child:  const Icon(
                                            Icons.edit,
                                            size: 20,
                                            color: Con_Main_1,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),

                        Text(Constants_Usermast.user_login_name,
                            style: const TextStyle(fontWeight: FontWeight.bold,fontFamily: "Inter",
                              fontSize: 20,
                            ),textAlign: TextAlign.center),
                        Text(
                          Constants_Usermast.user_bio,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            fontSize: 15,
                            color: getPlatformBrightness()
                                ? Dark_AppGreyColor
                                : AppGreyColor,
                          ),
                        ),
                      ]),
                      // margin: const EdgeInsets.only(bottom: 7),
                      // decoration: BoxDecoration(
                      //     color: getPlatformBrightness()
                      //         ? DarkTheme_Main
                      //         : LightTheme_White,
                      //     boxShadow: [
                      //       BoxShadow(
                      //         color: getPlatformBrightness()
                      //             ? Dark_Divider_Shadow
                      //             : Light_Divider_Shadow,
                      //         blurStyle: BlurStyle.outer,
                      //         blurRadius: 2,
                      //         // offset: Offset(0, 5)
                      //       ),
                      //     ]),
                      // child: ListTile(
                      //   dense: true,
                      //   leading: Con_profile_get(
                      //     pStrImageUrl:
                      //         Constants_Usermast.user_profileimage_path,
                      //     Size: 60,
                      //   ),
                      //   title: Padding(
                      //     padding: const EdgeInsets.only(top: 8.0),
                      //     child: Text(
                      //       Constants_Usermast.user_login_name,
                      //       style: const TextStyle(
                      //         fontSize: 18,
                      //       ),
                      //     ),
                      //   ),
                      //   onTap: () async {
                      //     final result = await Navigator.push(
                      //         context, RouteTransitions.slideTransition(ProfilePic("Setting")));
                      //     if (result != null) {
                      //       if (result != "") {
                      //         setState(() {
                      //           Constants_Usermast.user_bio;
                      //         });
                      //       }
                      //     }
                      //   },
                      //   isThreeLine: true,
                      //   subtitle: Padding(
                      //     padding: const EdgeInsets.only(top: 2.0, bottom: 4.0),
                      //     child: Text(
                      //       Constants_Usermast.user_bio,
                      //       overflow: TextOverflow.clip,
                      //       style: TextStyle(
                      //         fontSize: 15,
                      //         color: getPlatformBrightness()
                      //             ? Dark_AppGreyColor
                      //             : AppGreyColor,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ),
                    Container(
                      color: getPlatformBrightness()
                          ? DarkTheme_Main
                          : LightTheme_White,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: ListTile(
                              visualDensity: const VisualDensity(
                                  horizontal: 0, vertical: -4),
                              leading: Con_Wid.mIconButton(
                                icon: Own_NotificationTone,
                                onPressed: () {},
                              ),
                              title: const Text(
                                'Notification',
                                style: TextStyle(fontSize: 14,fontFamily: "Inter",fontWeight: FontWeight.bold),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    RouteTransitions.slideTransition(
                                        const sub_noti_settings()));
                              },
                              trailing: const Icon(Icons.keyboard_arrow_right),
                              subtitle: const Text(
                                'Customization for app notification.',style: TextStyle(fontSize: 12,fontFamily: "Inter",color: Con_grey),
                              ),
                            ),
                          ),
                          Constants.MainSettingBuildDivider(),
                          ListTile(
                            visualDensity: const VisualDensity(
                                horizontal: 0, vertical: -4),
                            leading: Con_Wid.mIconButton(
                              icon: Own_Lock_Outline,
                              onPressed: () {},
                            ),
                            title: const Text(
                              'Privacy and Security',style: TextStyle(fontSize: 14,fontFamily: "Inter",fontWeight: FontWeight.bold),
                            ),
                            subtitle: const Text(
                              'You are going to secured with NXT.',style: TextStyle(fontSize: 12,fontFamily: "Inter",color: Con_grey)
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  RouteTransitions.slideTransition(
                                      const sub_privacy_settings()));
                            },
                            trailing: const Icon(Icons.keyboard_arrow_right),
                          ),
                          Constants.MainSettingBuildDivider(),
                          ListTile(
                              visualDensity: const VisualDensity(
                                  horizontal: 0, vertical: -4),
                              leading: Con_Wid.mIconButton(
                                icon: Own_ChatBubble,
                                onPressed: () {},
                              ),
                              title: const Padding(
                                padding: EdgeInsets.only(top: 8.0),
                                child: Text(
                                  'Chats',style: TextStyle(fontSize: 14,fontFamily: "Inter",fontWeight: FontWeight.bold),
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    RouteTransitions.slideTransition(
                                        const sub_chat_settings()));
                              },
                              trailing: const Icon(Icons.keyboard_arrow_right),
                              subtitle: const Text(
                                'Spread your experience with your friends.',style: TextStyle(fontSize: 12,fontFamily: "Inter",color: Con_grey)
                              )),
                          Constants.MainSettingBuildDivider(),
                          ListTile(
                            visualDensity: const VisualDensity(
                                horizontal: 0, vertical: -4),
                            leading: Con_Wid.mIconButton(
                              icon: Own_FolderOutlined,
                              onPressed: () {},
                            ),
                            title: const Text(
                              'Folders',style: TextStyle(fontSize: 14,fontFamily: "Inter",fontWeight: FontWeight.bold),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  RouteTransitions.slideTransition(
                                      const Folders()));
                            },
                            trailing: const Icon(Icons.keyboard_arrow_right),
                          ),
                          Constants.MainSettingBuildDivider(),
                          Padding(
                            padding: const EdgeInsets.only(top: 3.0),
                            child: ListTile(
                              visualDensity: const VisualDensity(
                                  horizontal: 0, vertical: -4),
                              leading: Con_Wid.mIconButton(
                                icon: Own_HelpOutline,
                                onPressed: () {},
                              ),
                              title: const Text(
                                'Get Help',style: TextStyle(fontSize: 14,fontFamily: "Inter",fontWeight: FontWeight.bold),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    RouteTransitions.slideTransition(
                                        const sub_help_settings()));
                              },
                              trailing: const Icon(Icons.keyboard_arrow_right),
                            ),
                          ),
                          Constants.MainSettingBuildDivider(),
                          ListTile(
                            visualDensity: const VisualDensity(
                                horizontal: 0, vertical: -4),
                            onTap: () async {
                              ConfirmLogout();
                            },
                            leading: Con_Wid.mIconButton(
                              icon: Own_LogoutMain,
                              onPressed: () {},
                            ),
                            title: const Text(
                              'Log out',style: TextStyle(fontSize: 14,fontFamily: "Inter",fontWeight: FontWeight.bold),
                            ),
                          ),
                          Constants.MainSettingBuildDivider(),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: 25,
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Made with"),
                                  Icon(
                                    Icons.favorite,
                                    color: Con_red,
                                  ),
                                  Text("in India "),
                                  Image(
                                    image: AssetImage("assets/flags/in.png"),
                                    height: 20,
                                    width: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          : CupertinoPageScaffold(
              navigationBar: CupertinoNavigationBar(
                  padding: EdgeInsetsDirectional.zero,
                  leading: CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: const Icon(CupertinoIcons.back, color: Con_white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  backgroundColor: App_Float_Back_Color,
                  middle: const Text(
                    "Settings",
                    style: TextStyle(color: Con_white),
                  )),
              child: Container(
                color: getPlatformBrightness() ? Con_Clr_App_3 : Con_Clr_App_4,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 7),
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
                      child: CupertinoListTile(
                        leading: Con_profile_get(
                          pStrImageUrl:
                              Constants_Usermast.user_profileimage_path,
                          Size: 60,
                        ),
                        title: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            Constants_Usermast.user_login_name,
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                        onTap: () async {
                          final result = await Navigator.push(
                              context,
                              RouteTransitions.slideTransition(
                                  ProfilePic("Setting")));
                          if (result != null) {
                            if (result != "") {
                              setState(() {
                                Constants_Usermast.user_bio;
                              });
                            }
                          }
                        },
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 2.0, bottom: 4.0),
                          child: Text(
                            Constants_Usermast.user_bio,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                              fontSize: 15,
                              color: getPlatformBrightness()
                                  ? Dark_AppGreyColor
                                  : AppGreyColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color: getPlatformBrightness()
                          ? DarkTheme_Main
                          : LightTheme_White,
                      child: Column(
                        children: [
                          CupertinoListTile(
                            leading: const Icon(CupertinoIcons.bell),
                            title: const Text('Notification'),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  RouteTransitions.slideTransition(
                                      const sub_noti_settings()));
                            },
                            trailing: const Icon(Icons.keyboard_arrow_right),
                            subtitle: const Text(
                              'Customization for app notification.',
                            ),
                          ),
                          CupertinoListTile(
                            leading: const Icon(CupertinoIcons.lock),
                            title: const Text(
                              'Privacy and Security',
                            ),
                            subtitle: const Text(
                              'You are going to secured with NXT.',
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  RouteTransitions.slideTransition(
                                      const sub_privacy_settings()));
                            },
                            trailing: const Icon(Icons.keyboard_arrow_right),
                          ),
                          CupertinoListTile(
                              leading:
                                  const Icon(CupertinoIcons.captions_bubble),
                              title: const Text(
                                'Chats',
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    RouteTransitions.slideTransition(
                                        const sub_chat_settings()));
                              },
                              trailing: const Icon(Icons.keyboard_arrow_right),
                              subtitle: const Text(
                                'Spread your experience with your friends.',
                              )),
                          CupertinoListTile(
                            leading: const Icon(CupertinoIcons.folder),
                            title: const Text(
                              'Folders',
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  RouteTransitions.slideTransition(
                                      const Folders()));
                            },
                            trailing: const Icon(Icons.keyboard_arrow_right),
                          ),
                          CupertinoListTile(
                            leading: const Icon(CupertinoIcons.question_circle),
                            title: const Text(
                              'Get Help',
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  RouteTransitions.slideTransition(
                                      const sub_help_settings()));
                            },
                            trailing: const Icon(Icons.keyboard_arrow_right),
                          ),
                          CupertinoListTile(
                            onTap: () async {
                              Cupertino_ConfirmLogout();
                            },
                            leading: Own_LogoutMain,
                            title: const Text(
                              'Log out',
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 2.8,
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: 25,
                              width: double.infinity,
                              child: Material(
                                color: Con_transparent,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Made with"),
                                    Icon(
                                      CupertinoIcons.heart_fill,
                                      color: Con_red,
                                    ),
                                    Text("in India "),
                                    Image(
                                      image: AssetImage("assets/flags/in.png"),
                                      height: 20,
                                      width: 20,
                                    ),
                                  ],
                                ),
                              ),
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

  ConfirmLogout() {
    Con_Wid.mConfirmDialog(
        context: context,
        title: "Logout",
        message: 'Are you sure you want to logout from app ?',
        onOkPressed: () {
          setState(() {
            Procces = true;
            logout = true;
            logoutmethod();
            Navigator.pop(context);
          });
        },
        onCancelPressed: () {
          Navigator.pop(context);
        });
  }

  Cupertino_ConfirmLogout() {
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text("Logout"),
          content: const Text("Are you sure to logout from app ?"),
          actions: [
            CupertinoDialogAction(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel")),
            CupertinoDialogAction(
              child: const Text("Ok"),
              onPressed: () {
                setState(() {
                  logoutmethod();
                  Navigator.pop(context);
                });
              },
            )
          ],
        );
      },
    );
  }

  Future<void> logoutmethod() async {
    await sql_devicesession_tran.setLoginSessionDetails(false);
    SharedPref.save_bool('is_login', false);
    SharedPref.save_string('user_id', '');
    SharedPref.clear();
    deleteData().then((value) {
      Constants_List.Constants_List_Clear();
      setState(() {
        Procces = false;
      });
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/Splash',
        (_) => false,
      );
    });
  }
}

Future deleteData() async {
  try {
    // if(await Hive.box<sql_usermast_tran>("sql_usermast_tran").isOpen){await Hive.box<sql_usermast_tran>("sql_usermast_tran").clear();}
    // if(await Hive.box<Need_Contact>("Need_Contact").isOpen){await Hive.box<Need_Contact>("Need_Contact").clear();}
    // if(await Hive.box<Need_Broadcast>("Need_Broadcast").isOpen){await Hive.box<Need_Broadcast>("Need_Broadcast").clear();}
    // if(await Hive.box<Need_QuickReply>("Need_QuickReply").isOpen){await Hive.box<Need_QuickReply>("Need_QuickReply").clear();}
    // if(await Hive.box<Need_DeviceSession>("Need_DeviceSession").isOpen){await Hive.box<Need_DeviceSession>("Need_DeviceSession").clear();}
    // if(await Hive.box<Need_MainChat>("Need_MainChat").isOpen){await Hive.box<Need_MainChat>("Need_MainChat").clear();}
    // if(await Hive.box<Need_Main_Sub_Chat>("Need_Main_Sub_Chat").isOpen){await Hive.box<Need_Main_Sub_Chat>("Need_Main_Sub_Chat").clear();}
    // for (int i = 0; i < MdiMainPage.mDelete.length;i++) {
    //   if(await Hive.box<Need_Main_Sub_Chat>("Need_Main_Sub_Chat${MdiMainPage.mDelete[i].toString()}").isOpen)
    //       {await Hive.box<Need_Main_Sub_Chat>("Need_Main_Sub_Chat${MdiMainPage.mDelete[i].toString()}").close();}
    // }
    Directory appDir = await getApplicationDocumentsDirectory();

    String hivePath = appDir.path + '/databases';
    Directory(hivePath).deleteSync(recursive: true);

  } catch (e) {
    print("ERROR FROM DELETE DATA  " + e.toString());
  }
  // await Hive.close();
  // await Hive.deleteFromDisk();
  MdiMainPage.mDelete.clear();
}

class Button extends StatelessWidget {
  const Button({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Pinned.fromPins(
          Pin(start: 0.0, end: 0.0),
          Pin(start: 0.0, end: 0.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(200.0),
              color: Chat_Row_UnRead_Color,
              boxShadow: const [
                BoxShadow(
                  color: Con_Clr_App_2,
                  offset: Offset(0, 3),
                  blurRadius: 6,
                ),
              ],
            ),
          ),
        ),
        Pinned.fromPins(
          Pin(size: 44.0, middle: 0.5),
          Pin(size: 21.0, middle: 0.4583),
          child: const Text(
            'Log in',
            style: TextStyle(
              color: Con_white,
            ),
            textHeightBehavior:
                TextHeightBehavior(applyHeightToFirstAscent: false),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
