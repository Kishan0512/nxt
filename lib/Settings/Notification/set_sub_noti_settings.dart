import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nextapp/Constant/Con_Clr.dart';
import 'package:nextapp/Constant/Con_Icons.dart';
import 'package:nextapp/Constant/Con_Usermast.dart';
import 'package:nextapp/Constant/Con_Wid.dart';
import 'package:nextapp/Constant/Constants.dart';

import '../../A_FB_Trigger/SharedPref.dart';
import '../../OSFind.dart';

class sub_noti_settings extends StatefulWidget {
  const sub_noti_settings({Key? key}) : super(key: key);

  @override
  _sub_noti_settings createState() => _sub_noti_settings();
}

class _sub_noti_settings extends State<sub_noti_settings> {
  List mstrVibrate = ["Off", "Default", "Short", "Long"];

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
              title: Con_Wid.mAppBar("Notification"),
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
                  "Notification",
                  style: TextStyle(color: Con_white),
                )),
            child: Container(
              child: Cupertino_myListView(context),
            ));
  }

  Widget _myListView(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: <Widget>[
        const Padding(
            padding: EdgeInsets.only(left: 15.0, top: 5),
            child: Text("Messages",
                style: TextStyle(
                  color: App_IconColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0,
                ))),
        SizedBox(height: 5,),
        SwitchListTile(
          visualDensity: VisualDensity(vertical: VisualDensity.minimumDensity),
          value: Constants_Usermast.user_notify_conversionTone,
          title: const Text('Conversation tones',style: TextStyle(fontSize: 14,fontFamily: "Inter",fontWeight: FontWeight.bold),),
          activeColor: App_IconColor,
          onChanged: (bool val) async {
            setState(() {
              Constants_Usermast.user_notify_conversionTone = val;
              SharedPref.save_bool('user_notify_conversionTone', val);
            });
          },
        ),
        Constants.SettingBuildDivider(),
        ListTile(
            visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
            title: const Text('Vibrate',style: TextStyle(fontSize: 14,fontFamily: "Inter",fontWeight: FontWeight.bold),),
            subtitle: const Text(""),
            onTap: () => showMenu(context: context, position: RelativeRect.fromDirectional(textDirection: TextDirection.ltr, start: 100, top: 180, end: 30, bottom: 400), items: <PopupMenuEntry>[

            PopupMenuItem(
              child: RadioListTile(
                  contentPadding: EdgeInsets.zero,
              visualDensity: VisualDensity(vertical: VisualDensity.minimumDensity,horizontal: VisualDensity.minimumDensity),
              value: 0,
              activeColor: App_IconColor,
              groupValue: Constants_Usermast.user_vibrate,
              title:  Text("Off",style: TextStyle(fontSize: 14,fontFamily: "Inter",fontWeight: FontWeight.bold),),
              onChanged: (int? value) async {
                Constants_Usermast.user_vibrate = value!;
                await SharedPref.save_int('user_vibrate',value);
                Navigator.pop(context);
              }),
            ),
        PopupMenuItem(
          child: RadioListTile(
              contentPadding: EdgeInsets.zero,
              visualDensity: VisualDensity(vertical: VisualDensity.minimumDensity,horizontal: VisualDensity.minimumDensity),
              value: 1,
              activeColor: App_IconColor,
              groupValue: Constants_Usermast.user_vibrate,
              title: const Text("Default",style: TextStyle(fontSize: 14,fontFamily: "Inter",fontWeight: FontWeight.bold),),
              onChanged: (int? value) async {
                Constants_Usermast.user_vibrate = value!;
                await SharedPref.save_int('user_vibrate',value);
                Navigator.pop(context);
              }),
        ),
        PopupMenuItem(
          child: RadioListTile(
            contentPadding: EdgeInsets.zero,
              visualDensity: VisualDensity(vertical: VisualDensity.minimumDensity,horizontal: VisualDensity.minimumDensity),
              value: 2,
              activeColor: App_IconColor,
              groupValue: Constants_Usermast.user_vibrate,
              title: const Text("Short",style: TextStyle(fontSize: 14,fontFamily: "Inter",fontWeight: FontWeight.bold),),
              onChanged: (int? value) async {
                Constants_Usermast.user_vibrate = value!;
                await SharedPref.save_int('user_vibrate',value);
                Navigator.pop(context);
              }),
        ),
        PopupMenuItem(
          child: RadioListTile(
              contentPadding: EdgeInsets.zero,
              visualDensity: VisualDensity(vertical: VisualDensity.minimumDensity,horizontal: VisualDensity.minimumDensity),
              value: 3,
              activeColor: App_IconColor,
              groupValue: Constants_Usermast.user_vibrate,
              title: const Text("Long",style: TextStyle(fontSize: 14,fontFamily: "Inter",fontWeight: FontWeight.bold),),
              onChanged: (int? value) async {
                Constants_Usermast.user_vibrate = value!;
                await SharedPref.save_int('user_vibrate',value);
                Navigator.pop(context);
              }),
        )
      ],)),
      ],
    );
  }

  Widget Cupertino_myListView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Material(
          color: Con_transparent,
          child: Padding(
              padding: EdgeInsets.only(left: 20.0, top: 10),
              child: Text("Messages",
                  style: TextStyle(
                    color: App_IconColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                  ))),
        ),
        CupertinoListTile(
            title: const Text('Conversation tones'),
            trailing: CupertinoSwitch(
              value: Constants_Usermast.user_notify_conversionTone,
              onChanged: (bool val) async {
                setState(() {
                  Constants_Usermast.user_notify_conversionTone = val;
                  SharedPref.save_bool('user_notify_conversionTone', val);
                });
              },
              activeColor: App_IconColor,
            )),
        Constants.SettingBuildDivider(),
        const Material(
          color: Con_transparent,
          child: Padding(
              padding: EdgeInsets.only(left: 20.0, top: 5),
              child: Text("Vibrate",
                  style: TextStyle(
                    color: App_IconColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                  ))),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: mstrVibrate.length,
            itemBuilder: (context, index) {
              return CupertinoListTile(
                  onTap: () {
                    setState(() async {
                      Constants_Usermast.user_vibrate = index;
                      await SharedPref.save_int('user_vibrate',index);
                    });
                  },
                  leading: Constants_Usermast.user_vibrate == index
                      ? const Icon(
                          CupertinoIcons.checkmark_alt,
                          color: App_IconColor,
                        )
                      : const Icon(CupertinoIcons.circle, color: Con_white),
                  title: Text("${mstrVibrate[index]}"));
            },
          ),
        )
      ],
    );
  }
}
