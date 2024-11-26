import 'dart:async';

import 'package:adobe_xd/pinned.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:nextapp/A_FB_Trigger/SharedPref.dart';
import 'package:nextapp/A_Local_DB/Sync_Json.dart';
import 'package:nextapp/A_SQL_Trigger/sql_usermast.dart';
import 'package:nextapp/Constant/Con_Usermast.dart';
import 'package:nextapp/Login/Login.dart';
import 'package:nextapp/Settings/Folders/Folder.dart';
import 'package:stack_trace/stack_trace.dart';
import '../Constant/Con_Clr.dart';
import '../Constant/Con_Wid.dart';
import '../Constant/GlobalExceptionClass.dart';
import '../mdi_page/chat_mdi_page.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  SplashState createState() => SplashState();
}

class SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    checkFirstSeen();
    SyncJSon.user_main_chat_box();
    Folder.getpath();
  }

  Future checkFirstSeen() async {
    try {
      bool _blnLogin = false;
      _blnLogin = await SharedPref.read_bool('is_login') ?? false;
      if (_blnLogin) {
        String number = await (SharedPref.read_string('user_id') ?? "");
        if (number.isEmpty) {
          LoginCaller();
        } else {
          String Profile = await (SharedPref.read_string('profile_pic') ?? "");
          String LoginName =
              await (SharedPref.read_string('user_login_name') ?? "");
          CacheDataGet();
          setState(() {
            Constants_Usermast.user_id = number;
            Constants_Usermast.user_profileimage_path = Profile;
            Constants_Usermast.user_login_name = LoginName;
            sql_usermast_tran.SelectUserTable();
          });
          Future.delayed(const Duration(seconds: 1)).then((value) {
            Navigator.of(context).pushReplacement(
                RouteTransitions.slideTransition( MdiMainPage()));
          });
        }
      } else {
        LoginCaller();
      }
    } catch (e) {
      var current =
          Trace.current().frames[0].member.toString().replaceAll('.<fn>', '');
      GlobalExceptionClass()
          .globalExceptionClass("Splash.dart", current, e.toString());
    }
    await SyncJSon.user_contact_select_fav_stream();
  }



  void CacheDataGet() async {
    try {
      bool userChatBlnFavouriteContacts = false;
      try {
        userChatBlnFavouriteContacts =
            await (SharedPref.read_bool('user_chat_bln_favourite_contacts'));
      } catch (e) {
        userChatBlnFavouriteContacts = false;
      }
      Constants_Usermast.user_chat_bln_favourite_contacts =
          userChatBlnFavouriteContacts;
    } catch (e) {
      var current =
          Trace.current().frames[0].member.toString().replaceAll('.<fn>', '');
      GlobalExceptionClass()
          .globalExceptionClass("Splash.dart", current, e.toString());
    }
  }

  Future<void> LoginCaller() async {
    try {
      // await Hive.close();
      // await Hive.deleteFromDisk();

      Constants_Usermast.BlankCaller();
      Navigator.of(context).pushReplacement(
          RouteTransitions.slideTransition( const Login()));
    } catch (e) {
      var current =
          Trace.current().frames[0].member.toString().replaceAll('.<fn>', '');
      GlobalExceptionClass()
          .globalExceptionClass("Splash.dart", current, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    try {
      return Scaffold(
        body: Stack(
          children: <Widget>[
            Pinned.fromPins(
              Pin(start: 0.0, end: 0.0),
              Pin(start: 0.0, end: 0.0),
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: const AssetImage('assets/images/Spalsh_image.webp'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                        Con_black.withOpacity(0.03), BlendMode.dstIn),
                  ),
                ),
              ),
            ),
            Center(
              child: Container(
                height: MediaQuery.of(context).size.height / 4.6,
                width: MediaQuery.of(context).size.width / 2.6,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image:
                        AssetImage(Constants_Usermast.user_appfirstscreen_logo),
                  ),
                ),
              ),
            ),
            const Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 8.0),
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
            )
          ],
        ),
      );
    } catch (e) {
      var current =
          Trace.current().frames[0].member.toString().replaceAll('.<fn>', '');
      GlobalExceptionClass()
          .globalExceptionClass("Splash.dart", current, e.toString());
      return const SizedBox(
        height: 100,
        width: 100,
      );
    }
  }
}
