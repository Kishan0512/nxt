import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nextapp/A_FB_Trigger/SharedPref.dart';
import 'package:nextapp/A_SQL_Trigger/sql_sub_messages.dart';
import 'package:nextapp/A_SQL_Trigger/sql_usermast.dart';
import 'package:nextapp/Constant/Con_Clr.dart';
import 'package:nextapp/Constant/Con_Icons.dart';
import 'package:nextapp/Constant/Con_Usermast.dart';
import 'package:nextapp/Constant/Con_Wid.dart';
import 'package:nextapp/Constant/Constants.dart';
import 'package:nextapp/mdi_page/Wallpaper/chat_wallpaper.dart';

import '../../OSFind.dart';

class sub_chat_settings extends StatefulWidget {
  const sub_chat_settings({Key? key}) : super(key: key);

  @override
  _sub_chat_settings createState() => _sub_chat_settings();
}

class _sub_chat_settings extends State<sub_chat_settings> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Os.isIOS
        ? Scaffold(
            appBar: AppBar(
              elevation: 0,
              automaticallyImplyLeading: false,
              leading: Con_Wid.mIconButton(
                icon: Own_ArrowBack,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Con_Wid.mAppBar("Chats"),
            ),
            body: _myListView(context),
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
                  "Chats",
                  style: TextStyle(color: Con_white),
                )),
            child: Cupertino_myListView(context));
  }

  Widget _myListView(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: <Widget>[
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(left: 15.0, top: 5),
                child: Text("Wallpaper",
                    style: TextStyle(
                      color: App_IconColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                    )))
          ],
        ),
        ListTile(
            title: const Text(
              'Chat Wallpaper',
              style: TextStyle(
                  fontSize: 14,
                  fontFamily: "Inter",
                  fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.push(context,
                  RouteTransitions.slideTransition(chat_wallpaper("", "")));
            }),
        Constants.SettingBuildDivider(),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(left: 15.0, top: 5),
                child: Text("Auto download media : Mobile ",
                    style: TextStyle(
                      color: App_IconColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                    )))
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        SwitchListTile(
            activeColor: App_IconColor,
            value: Constants_Usermast.user_chat_mobile_images,
            title: const Text(
              'Images',
              style: TextStyle(
                  fontSize: 14,
                  fontFamily: "Inter",
                  fontWeight: FontWeight.bold),
            ),
            subtitle: const Text(
              'Auto download image with mobile data',
              style:
                  TextStyle(fontSize: 12, fontFamily: "Inter", color: Con_grey),
            ),
            onChanged: (bool val) {
              setState(() {
                Constants_Usermast.user_chat_mobile_images = val;
                SharedPref.save_bool('user_chat_mobile_images', val);
              });
            }),
        Constants.SettingBuildDivider(),
        SwitchListTile(
            activeColor: App_IconColor,
            value: Constants_Usermast.user_chat_mobile_video,
            title: const Text(
              'Video',
              style: TextStyle(
                  fontSize: 14,
                  fontFamily: "Inter",
                  fontWeight: FontWeight.bold),
            ),
            subtitle: const Text('Auto download video with mobile data',
                style: TextStyle(
                    fontSize: 12, fontFamily: "Inter", color: Con_grey)),
            onChanged: (bool val) {
              setState(() {
                Constants_Usermast.user_chat_mobile_video = val;
                SharedPref.save_bool('user_chat_mobile_video', val);
              });
            }),
        Constants.SettingBuildDivider(),
        SwitchListTile(
            activeColor: App_IconColor,
            value: Constants_Usermast.user_chat_mobile_audio,
            title: const Text(
              'Audio',
              style: TextStyle(
                  fontSize: 14,
                  fontFamily: "Inter",
                  fontWeight: FontWeight.bold),
            ),
            subtitle: const Text('Auto download audio with mobile data',
                style: TextStyle(
                    fontSize: 12, fontFamily: "Inter", color: Con_grey)),
            onChanged: (bool val) {
              setState(() {
                Constants_Usermast.user_chat_mobile_audio = val;
                SharedPref.save_bool('user_chat_mobile_audio', val);
              });
            }),
        Constants.SettingBuildDivider(),
        SwitchListTile(
            activeColor: App_IconColor,
            value: Constants_Usermast.user_chat_mobile_Document,
            title: const Text(
              'Document',
              style: TextStyle(
                  fontSize: 14,
                  fontFamily: "Inter",
                  fontWeight: FontWeight.bold),
            ),
            subtitle: const Text('Auto download document with mobile data',
                style: TextStyle(
                    fontSize: 12, fontFamily: "Inter", color: Con_grey)),
            onChanged: (bool val) {
              setState(() {
                Constants_Usermast.user_chat_mobile_Document = val;
                SharedPref.save_bool('user_chat_mobile_Document', val);
              });
            }),
        Constants.SettingBuildDivider(),
        const Padding(
            padding: EdgeInsets.only(left: 15.0, top: 8),
            child: Text("Auto download media : Wifi ",
                style: TextStyle(
                  color: App_IconColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0,
                ))),
        SwitchListTile(
            activeColor: App_IconColor,
            value: Constants_Usermast.user_chat_wifi_images,
            title: const Text(
              'Images',
              style: TextStyle(
                  fontSize: 14,
                  fontFamily: "Inter",
                  fontWeight: FontWeight.bold),
            ),
            subtitle: const Text('Auto download image with wifi',
                style: TextStyle(
                    fontSize: 12, fontFamily: "Inter", color: Con_grey)),
            onChanged: (bool val) {
              setState(() {
                Constants_Usermast.user_chat_wifi_images = val;
                SharedPref.save_bool('user_chat_wifi_images', val);
              });
            }),
        Constants.SettingBuildDivider(),
        SwitchListTile(
            activeColor: App_IconColor,
            value: Constants_Usermast.user_chat_wifi_video,
            title: const Text(
              'Video',
              style: TextStyle(
                  fontSize: 14,
                  fontFamily: "Inter",
                  fontWeight: FontWeight.bold),
            ),
            subtitle: const Text('Auto download video with wifi',
                style: TextStyle(
                    fontSize: 12, fontFamily: "Inter", color: Con_grey)),
            onChanged: (bool val) {
              setState(() {
                Constants_Usermast.user_chat_wifi_video = val;
                SharedPref.save_bool('user_chat_wifi_video', val);
              });
            }),
        Constants.SettingBuildDivider(),
        SwitchListTile(
            activeColor: App_IconColor,
            value: Constants_Usermast.user_chat_wifi_audio,
            title: const Text(
              'Audio',
              style: TextStyle(
                  fontSize: 14,
                  fontFamily: "Inter",
                  fontWeight: FontWeight.bold),
            ),
            subtitle: const Text('Auto download audio with wifi',
                style: TextStyle(
                    fontSize: 12, fontFamily: "Inter", color: Con_grey)),
            onChanged: (bool val) {
              setState(() {
                Constants_Usermast.user_chat_wifi_audio = val;
                SharedPref.save_bool('user_chat_wifi_audio', val);
              });
            }),
        Constants.SettingBuildDivider(),
        SwitchListTile(
            activeColor: App_IconColor,
            value: Constants_Usermast.user_chat_wifi_Document,
            title: const Text(
              'Document',
              style: TextStyle(
                  fontSize: 14,
                  fontFamily: "Inter",
                  fontWeight: FontWeight.bold),
            ),
            subtitle: const Text('Auto download document with wifi',
                style: TextStyle(
                    fontSize: 12, fontFamily: "Inter", color: Con_grey)),
            onChanged: (bool val) {
              setState(() {
                Constants_Usermast.user_chat_wifi_Document = val;
                SharedPref.save_bool('user_chat_wifi_Document', val);
              });
            }),
        Constants.SettingBuildDivider(),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(left: 15.0, top: 5),
                child: Text("Ticks Style",
                    style: TextStyle(
                      color: App_IconColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                    )))
          ],
        ),
        GestureDetector(
          onTapDown: (TapDownDetails details) {
            _showMenu(context, details.globalPosition);
          },
          child: const ListTile(
            title: Text(
              'Set Customize Ticks icon',
              style: TextStyle(
                  fontSize: 14,
                  fontFamily: "Inter",
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Constants.SettingBuildDivider(),
        const Padding(
            padding: EdgeInsets.only(left: 15.0, top: 5),
            child: Text("Favourite Contacts",
                style: TextStyle(
                  color: App_IconColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0,
                ))),
        SwitchListTile(
            activeColor: App_IconColor,
            value: Constants_Usermast.user_chat_bln_favourite_contacts,
            title: Text(
              Constants_Usermast.user_chat_bln_favourite_contacts == false
                  ? 'Enable Favourites List '
                  : 'Disable Favourites List ',
              style: TextStyle(
                  fontSize: 14,
                  fontFamily: "Inter",
                  fontWeight: FontWeight.bold),
            ),
            onChanged: (bool val) {
              setState(() {
                Constants_Usermast.user_chat_bln_favourite_contacts = val;
                SharedPref.save_bool('user_chat_bln_favourite_contacts',
                    Constants_Usermast.user_chat_bln_favourite_contacts);
              });
            }),
        Constants.SettingBuildDivider(),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(left: 15.0, top: 10),
                child: Text("Other",
                    style: TextStyle(
                      color: App_IconColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                    )))
          ],
        ),
        SwitchListTile(
            activeColor: App_IconColor,
            value: Constants_Usermast.user_chat_bln_quick_reply,
            title: Text(
              Constants_Usermast.user_chat_bln_quick_reply == false
                  ? 'Enable Quick Replies'
                  : 'Disable Quick Replies',
              style: TextStyle(
                  fontSize: 14,
                  fontFamily: "Inter",
                  fontWeight: FontWeight.bold),
            ),
            onChanged: (bool val) {
              setState(() {
                setState(() {
                  Constants_Usermast.user_chat_bln_quick_reply = val;
                  SharedPref.save_bool('Quick_Rep', val);
                });
              });
            }),
        Constants.SettingBuildDivider(),
        ListTile(
          title: const Text(
            'Clear all chats',
            style: TextStyle(
                fontSize: 14, fontFamily: "Inter", fontWeight: FontWeight.bold),
          ),
          onTap: () async {
            ConfirmClear(false);
          },
        ),
        Constants.SettingBuildDivider(),
        ListTile(
          title: const Text(
            'Delete all chats',
            style: TextStyle(
                fontSize: 14, fontFamily: "Inter", fontWeight: FontWeight.bold),
          ),
          onTap: () async {
            ConfirmClear(true);
          },
        )
      ],
    );
  }

  Widget Cupertino_myListView(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Material(
              color: Con_transparent,
              child: Padding(
                  padding: EdgeInsets.only(left: 20.0, top: 5),
                  child: Text("Wallpaper",
                      style: TextStyle(
                        color: App_IconColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                      ))),
            )
          ],
        ),
        CupertinoListTile(
            trailing: const Icon(CupertinoIcons.chevron_right),
            title: const Text('Chat Wallpaper'),
            onTap: () {
              Navigator.push(context,
                  RouteTransitions.slideTransition(chat_wallpaper("", "")));
            }),
        Constants.SettingBuildDivider(),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Material(
              color: Con_transparent,
              child: Padding(
                  padding: EdgeInsets.only(left: 20.0, top: 5),
                  child: Text("Auto download media : Mobile ",
                      style: TextStyle(
                        color: App_IconColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                      ))),
            )
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        CupertinoListTile(
          trailing: CupertinoSwitch(
              activeColor: App_IconColor,
              value: Constants_Usermast.user_chat_mobile_images,
              onChanged: (bool val) {
                setState(() {
                  Constants_Usermast.user_chat_mobile_images = val;
                  SharedPref.save_bool('user_chat_mobile_images', val);
                });
              }),
          title: const Text('Images'),
          subtitle: const Text('Auto download image with mobile data'),
        ),
        Constants.SettingBuildDivider(),
        CupertinoListTile(
          trailing: CupertinoSwitch(
              activeColor: App_IconColor,
              value: Constants_Usermast.user_chat_mobile_video,
              onChanged: (bool val) {
                setState(() {
                  Constants_Usermast.user_chat_mobile_video = val;
                  SharedPref.save_bool('user_chat_mobile_video', val);
                });
              }),
          title: const Text('Video'),
          subtitle: const Text('Auto download video with mobile data'),
        ),
        Constants.SettingBuildDivider(),
        CupertinoListTile(
          trailing: CupertinoSwitch(
              activeColor: App_IconColor,
              value: Constants_Usermast.user_chat_mobile_audio,
              onChanged: (bool val) {
                setState(() {
                  Constants_Usermast.user_chat_mobile_audio = val;
                  SharedPref.save_bool('user_chat_mobile_audio', val);
                });
              }),
          title: const Text('Audio'),
          subtitle: const Text('Auto download audio with mobile data'),
        ),
        Constants.SettingBuildDivider(),
        CupertinoListTile(
          trailing: CupertinoSwitch(
              activeColor: App_IconColor,
              value: Constants_Usermast.user_chat_mobile_Document,
              onChanged: (bool val) {
                setState(() {
                  Constants_Usermast.user_chat_mobile_Document = val;
                  SharedPref.save_bool('user_chat_mobile_Document', val);
                });
              }),
          title: const Text('Document'),
          subtitle: const Text('Auto download document with mobile data'),
        ),
        Constants.SettingBuildDivider(),
        const Material(
          color: Con_transparent,
          child: Padding(
              padding: EdgeInsets.only(left: 20.0, top: 8),
              child: Text("Auto download media : Wifi ",
                  style: TextStyle(
                    color: App_IconColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                  ))),
        ),
        CupertinoListTile(
          trailing: CupertinoSwitch(
              activeColor: App_IconColor,
              value: Constants_Usermast.user_chat_wifi_images,
              onChanged: (bool val) {
                setState(() {
                  Constants_Usermast.user_chat_wifi_images = val;
                  SharedPref.save_bool('user_chat_wifi_images', val);
                });
              }),
          title: const Text('Images'),
          subtitle: const Text('Auto download image with wifi'),
        ),
        Constants.SettingBuildDivider(),
        CupertinoListTile(
          trailing: CupertinoSwitch(
              activeColor: App_IconColor,
              value: Constants_Usermast.user_chat_wifi_video,
              onChanged: (bool val) {
                setState(() {
                  Constants_Usermast.user_chat_wifi_video = val;
                  SharedPref.save_bool('user_chat_wifi_video', val);
                });
              }),
          title: const Text('Video'),
          subtitle: const Text('Auto download video with wifi'),
        ),
        Constants.SettingBuildDivider(),
        CupertinoListTile(
          trailing: CupertinoSwitch(
              activeColor: App_IconColor,
              value: Constants_Usermast.user_chat_wifi_audio,
              onChanged: (bool val) {
                setState(() {
                  Constants_Usermast.user_chat_wifi_audio = val;
                  SharedPref.save_bool('user_chat_wifi_audio', val);
                });
              }),
          title: const Text('Audio'),
          subtitle: const Text('Auto download audio with wifi'),
        ),
        Constants.SettingBuildDivider(),
        CupertinoListTile(
          trailing: CupertinoSwitch(
              activeColor: App_IconColor,
              value: Constants_Usermast.user_chat_wifi_Document,
              onChanged: (bool val) {
                setState(() {
                  Constants_Usermast.user_chat_wifi_Document = val;
                  SharedPref.save_bool('user_chat_wifi_Document', val);
                });
              }),
          title: const Text('Document'),
          subtitle: const Text('Auto download document with wifi'),
        ),
        Constants.SettingBuildDivider(),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Material(
              color: Con_transparent,
              child: Padding(
                  padding: EdgeInsets.only(left: 20.0, top: 5),
                  child: Text("Ticks Style",
                      style: TextStyle(
                        color: App_IconColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                      ))),
            )
          ],
        ),
        CupertinoListTile(
            title: const Text('Set Customize Ticks icon'),
            onTap: () => showDialog(
                context: context,
                barrierDismissible: true,
                builder: (BuildContext context) {
                  return SimpleDialog(
                    title: const Text(
                      'Set Ticks Style',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    children: <Widget>[
                      RadioListTile(
                          value: 0,
                          activeColor: App_IconColor,
                          groupValue: Constants_Usermast.user_icon_selected,
                          title: const Row(
                            children: <Widget>[
                              Text("delivered"),
                              Expanded(
                                flex: 1,
                                child: InkWell(
                                  child: Icon(
                                    Icons.check_circle_outline,
                                    size: 30.0,
                                  ),
                                ),
                              ),
                              Text("read"),
                              Expanded(
                                flex: 1,
                                child: InkWell(
                                  child: Icon(
                                    Icons.check_circle,
                                    size: 30.0,
                                  ),
                                ),
                              )
                            ],
                          ),
                          onChanged: (int? val) {
                            {
                              Navigator.pop(
                                  context, selected_update_custicon(val!));
                            }
                          }),
                      RadioListTile(
                          value: 1,
                          activeColor: App_IconColor,
                          groupValue: Constants_Usermast.user_icon_selected,
                          title: const Row(
                            children: <Widget>[
                              Text("delivered"),
                              Expanded(
                                flex: 1,
                                child: InkWell(
                                  child: Icon(
                                    Icons.update,
                                    size: 30.0,
                                  ),
                                ),
                              ),
                              Text("read"),
                              Expanded(
                                flex: 1,
                                child: InkWell(
                                  child: Icon(
                                    Icons.image,
                                    size: 30.0,
                                  ),
                                ),
                              )
                            ],
                          ),
                          onChanged: (int? val) {
                            {
                              Navigator.pop(
                                  context, selected_update_custicon(val!));
                            }
                          }),
                      RadioListTile(
                          value: 2,
                          activeColor: App_IconColor,
                          groupValue: Constants_Usermast.user_icon_selected,
                          title: const Row(
                            children: <Widget>[
                              Text("delivered"),
                              Expanded(
                                flex: 1,
                                child: InkWell(
                                  child: Icon(
                                    Icons.clear,
                                    size: 30.0,
                                  ),
                                ),
                              ),
                              Text("read"),
                              Expanded(
                                flex: 1,
                                child: InkWell(
                                  child: Icon(
                                    Icons.print,
                                    size: 30.0,
                                  ),
                                ),
                              )
                            ],
                          ),
                          onChanged: (int? val) {
                            {
                              Navigator.pop(
                                  context, selected_update_custicon(val!));
                            }
                          }),
                      RadioListTile(
                          value: 3,
                          activeColor: App_IconColor,
                          groupValue: Constants_Usermast.user_icon_selected,
                          title: const Row(
                            children: <Widget>[
                              Text("delivered"),
                              Expanded(
                                flex: 1,
                                child: InkWell(
                                  child: Icon(
                                    Icons.exit_to_app,
                                    size: 30.0,
                                  ),
                                ),
                              ),
                              Text("read"),
                              Expanded(
                                flex: 1,
                                child: InkWell(
                                  child: Icon(
                                    Icons.chat,
                                    size: 30.0,
                                  ),
                                ),
                              )
                            ],
                          ),
                          onChanged: (int? val) {
                            {
                              Navigator.pop(
                                  context, selected_update_custicon(val!));
                            }
                          }),
                    ],
                  );
                })),
        Constants.SettingBuildDivider(),
        const Material(
          color: Con_transparent,
          child: Padding(
              padding: EdgeInsets.only(left: 20.0, top: 5),
              child: Text("Favourite Contacts",
                  style: TextStyle(
                    color: App_IconColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                  ))),
        ),
        CupertinoListTile(
          trailing: CupertinoSwitch(
              activeColor: App_IconColor,
              value: Constants_Usermast.user_chat_bln_favourite_contacts,
              onChanged: (bool val) {
                setState(() {
                  Constants_Usermast.user_chat_bln_favourite_contacts = val;
                  SharedPref.save_bool('user_chat_bln_favourite_contacts', val);
                });
              }),
          title: Text(
              Constants_Usermast.user_chat_bln_favourite_contacts == false
                  ? 'Enable Favourites List '
                  : 'Disable Favourites List '),
        ),
        Constants.SettingBuildDivider(),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Material(
              color: Con_transparent,
              child: Padding(
                  padding: EdgeInsets.only(left: 20.0, top: 10),
                  child: Text("Other",
                      style: TextStyle(
                        color: App_IconColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                      ))),
            )
          ],
        ),
        CupertinoListTile(
          trailing: CupertinoSwitch(
              activeColor: App_IconColor,
              value: Constants_Usermast.user_chat_bln_quick_reply,
              onChanged: (bool val) {
                setState(() {
                  setState(() {
                    Constants_Usermast.user_chat_bln_quick_reply = val;
                  });
                });
              }),
          title: Text(Constants_Usermast.user_chat_bln_quick_reply == false
              ? 'Enable Quick Replies'
              : 'Disable Quick Replies'),
        ),
        Constants.SettingBuildDivider(),
        CupertinoListTile(
          title: const Text('Clear all chats'),
          onTap: () async {
            Cupertino_ConfirmClear(false);
          },
        ),
        Constants.SettingBuildDivider(),
        CupertinoListTile(
          title: const Text('Delete all chats'),
          onTap: () async {
            Cupertino_ConfirmClear(true);
          },
        )
      ],
    );
  }

  ConfirmClear(isdelete) {
    Con_Wid.mConfirmDialog(
        context: context,
        title: isdelete ? "Delete all chats" : "Clear all chat",

        message:
            'Are you sure you want to ${isdelete ? "Delete all chats?" : "clear all messages and media in all chats?"}?',
        onOkPressed: () async {
          if (isdelete) {
            try {

              var toIds = Constants_List.needs_main_chat
                  .map((e) => e.msg_to_user_mast_id)
                  .join(",");

              for (int i = 0; i < Constants_List.needs_main_chat.length; i++) {
                await sql_sub_messages_tran.Sub_UserWiseClear(
                    Constants_Usermast.user_id,
                    Constants_List.needs_main_chat[i].msg_to_user_mast_id);
              }
              for (int i = 0; i < Constants_List.needs_main_chat.length; i++) {
                await sql_sub_messages_tran.Sub_UserWiseDelete(
                    Constants_Usermast.user_id,
                    Constants_List.needs_main_chat[i].msg_to_user_mast_id
                        .toString(),
                    false);
              }


              // await sql_sub_messages_tran.Sub_UserWiseDelete(
              //     Constants_Usermast.user_id, toIds, false);

              Constants_List.needs_main_chat = [];
              Constants_List.needs_main_chat.clear();
            } catch (e) {}
          } else {
            for (int i = 0; i < Constants_List.needs_main_chat.length; i++) {
              await sql_sub_messages_tran.Sub_UserWiseClear(
                  Constants_Usermast.user_id,
                  Constants_List.needs_main_chat[i].msg_to_user_mast_id);
            }
          }
          setState(() {});
          Navigator.pop(context);
        },
        onCancelPressed: () {
          Navigator.pop(context);
        });
  }

  Cupertino_ConfirmClear(isdelete) {
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          content: Text(
              'Are you sure you want to ${isdelete ? "Delete all chats?" : "clear all messages and media in all chats?"}?'),
          title: Text(isdelete ? "Delete all chats" : "Clear all chat"),
          actions: [
            CupertinoDialogAction(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel")),
            CupertinoDialogAction(
                onPressed: () {
                  setState(() {
                    if (isdelete) {
                      for (int i = 0;
                          i < Constants_List.needs_main_chat.length;
                          i++) {
                        sql_sub_messages_tran.Sub_UserWiseClear(
                            Constants_Usermast.user_id,
                            Constants_List
                                .needs_main_chat[i].msg_to_user_mast_id);
                      }
                      for (int i = 0;
                          i < Constants_List.needs_main_chat.length;
                          i++) {
                        sql_sub_messages_tran.Sub_UserWiseDelete(
                            Constants_Usermast.user_id,
                            Constants_List
                                .needs_main_chat[i].msg_to_user_mast_id
                                .toString(),
                            true);
                      }
                      Constants_List.needs_main_chat = [];
                      Constants_List.needs_main_chat.clear();
                    } else {
                      for (int i = 0;
                          i < Constants_List.needs_main_chat.length;
                          i++) {
                        sql_sub_messages_tran.Sub_UserWiseClear(
                            Constants_Usermast.user_id,
                            Constants_List
                                .needs_main_chat[i].msg_to_user_mast_id);
                      }
                    }
                    Navigator.pop(context);
                  });
                },
                child: const Text("Ok"))
          ],
        );
      },
    );
  }

  void _showMenu(BuildContext context, Offset position) {

    final RenderBox overlay =
        Overlay.of(context)!.context.findRenderObject() as RenderBox;
    double iconSize = 22;
    String Send = 'Send';
    String Delivered = 'Delivered';
    String Read = 'Read';
    TextStyle style = const TextStyle(
        fontSize: 16, fontWeight: FontWeight.w600);
    showMenu(
        context: context,
        position: RelativeRect.fromRect(
            position & Size(0, 0), Offset.zero & overlay.size),
        items: [
          PopupMenuItem(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                    // margin: EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                  Send,
                  style: style,
                )),
                Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      Delivered,
                      style: style,
                    )),
                Container(
                    child: Text(
                      Read,
                      style: style,
                    )),
              ],
            ),
          ),
          PopupMenuItem(
            child: RadioListTile(
                visualDensity: VisualDensity(vertical: VisualDensity.minimumDensity,horizontal: VisualDensity.minimumDensity),
              contentPadding: EdgeInsets.zero,
                value: 0,
                activeColor: App_IconColor,
                groupValue: Constants_Usermast.user_icon_selected,
                title: Row(
                  children: <Widget>[
                    // Text(Send),
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        child: Image.asset(Con_Wid.Ticks_Style_1['send'],
                            color: TickIconColor(),
                            height: iconSize,
                            width: iconSize),
                      ),
                    ),
                    // Text(Delivered),
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        child: Image.asset(Con_Wid.Ticks_Style_1['delivered'],
                            color: TickIconColor(),
                            height: iconSize,
                            width: iconSize),
                      ),
                    ),
                    // Text(Read),
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        child: Image.asset(Con_Wid.Ticks_Style_1['delivered'],
                            color: getPlatformBrightness()
                                ? Dark_Read_Tick
                                : Light_Read_Tick,
                            height: iconSize,
                            width: iconSize),
                      ),
                    )
                  ],
                ),
                onChanged: (int? val) {
                  {
                    Navigator.pop(context, selected_update_custicon(val!));
                  }
                }),
          ),
          PopupMenuItem(
            child: RadioListTile(
                visualDensity: VisualDensity(vertical: VisualDensity.minimumDensity,horizontal: VisualDensity.minimumDensity),
                contentPadding: EdgeInsets.zero,
                value: 1,
                activeColor: App_IconColor,
                groupValue: Constants_Usermast.user_icon_selected,
                title: Row(
                  children: <Widget>[
                    // Text(Send),
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        child: Image.asset(Con_Wid.Ticks_Style_2['send'],
                            color: TickIconColor(),
                            height: iconSize,
                            width: iconSize),
                      ),
                    ),
                    // Text(Delivered),
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        child: Image.asset(Con_Wid.Ticks_Style_2['delivered'],
                            color: TickIconColor(),
                            height: iconSize,
                            width: iconSize),
                      ),
                    ),
                    // Text(Read),
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        child: Image.asset(Con_Wid.Ticks_Style_2['delivered'],
                            color: getPlatformBrightness()
                                ? Dark_Read_Tick
                                : Light_Read_Tick,
                            height: iconSize,
                            width: iconSize),
                      ),
                    )
                  ],
                ),
                onChanged: (int? val) {
                  {
                    Navigator.pop(context, selected_update_custicon(val!));
                  }
                }),
          ),
          PopupMenuItem(

            child: RadioListTile(
                visualDensity: VisualDensity(vertical: VisualDensity.minimumDensity,horizontal: VisualDensity.minimumDensity),
                contentPadding: EdgeInsets.zero,
                value: 2,
                activeColor: App_IconColor,
                groupValue: Constants_Usermast.user_icon_selected,
                title: Row(
                  children: <Widget>[
                    // Text(Send),
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        child: Image.asset(Con_Wid.Ticks_Style_3['send'],
                            color: TickIconColor(),
                            height: iconSize,
                            width: iconSize),
                      ),
                    ),
                    // Text(Delivered),
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        child: Image.asset(Con_Wid.Ticks_Style_3['delivered'],
                            color: TickIconColor(),
                            height: iconSize,
                            width: iconSize),
                      ),
                    ),
                    // Text(Read),
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        child: Image.asset(Con_Wid.Ticks_Style_3['delivered'],
                            color: getPlatformBrightness()
                                ? Dark_Read_Tick
                                : Light_Read_Tick,
                            height: iconSize,
                            width: iconSize),
                      ),
                    ),
                  ],
                ),
                onChanged: (int? val) {
                  {
                    Navigator.pop(context, selected_update_custicon(val!));
                  }
                }),
          ),
          PopupMenuItem(
            child: RadioListTile(
                visualDensity: VisualDensity(vertical: VisualDensity.minimumDensity,horizontal: VisualDensity.minimumDensity),
                contentPadding: EdgeInsets.zero,
                value: 3,
                activeColor: App_IconColor,
                groupValue: Constants_Usermast.user_icon_selected,
                title: Row(
                  children: <Widget>[
                    // Text(Send),
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        child: Image.asset(Con_Wid.Ticks_Style_4['send'],
                            color: TickIconColor(),
                            height: iconSize,
                            width: iconSize),
                      ),
                    ),
                    // Text(Delivered),
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        child: Image.asset(Con_Wid.Ticks_Style_4['delivered'],
                            color: TickIconColor(),
                            height: iconSize,
                            width: iconSize),
                      ),
                    ),
                    // Text(Read),
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        child: Image.asset(Con_Wid.Ticks_Style_4['delivered'],
                            color: getPlatformBrightness()
                                ? Dark_Read_Tick
                                : Light_Read_Tick,
                            height: iconSize,
                            width: iconSize),
                      ),
                    ),
                  ],
                ),
                onChanged: (int? val) {
                  {
                    Navigator.pop(context, selected_update_custicon(val!));
                  }
                }),
          ),
        ]);
  }

  Color TickIconColor() {
    return getPlatformBrightness() ? Con_white : Con_black;
  }

  selected_update_custicon(int value) {
    setState(() {
      sql_usermast_tran.mSetUserUpdateBln(
          'user_icon_selected', (value.toString()));
      Constants_Usermast.user_icon_selected = value;
    });
  }
}
