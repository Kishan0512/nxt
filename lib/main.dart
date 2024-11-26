//todo                                                  શ્રી ગણેશાય નમઃ 🚩
//todo                                                  ॐ નમઃ શિવાય 🚩
import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:nextapp/A_FB_Trigger/SharedPref.dart';
import 'package:nextapp/A_FB_Trigger/sql_need_main_sub_chat.dart';
import 'package:nextapp/A_FB_Trigger/sql_need_mainchat.dart';
import 'package:nextapp/A_FB_Trigger/sql_need_quickreply.dart';
import 'package:nextapp/A_FB_Trigger/sql_user_device_session.dart';
import 'package:nextapp/A_Local_DB/Sync_Json.dart';
import 'package:nextapp/A_SQL_Trigger/sql_contact.dart';
import 'package:nextapp/A_SQL_Trigger/sql_main_messages.dart';
import 'package:nextapp/A_SQL_Trigger/sql_sub_messages.dart';
import 'package:nextapp/Constant/Con_Clr.dart';
import 'package:nextapp/Constant/Con_Usermast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

import 'A_FB_Trigger/USER_MSG_AUTOSENDER.dart';
import 'A_FB_Trigger/sql_need_broadcast_sub_msg.dart';
import 'A_FB_Trigger/sql_need_contact.dart';
import 'A_FB_Trigger/sql_user_broadcast.dart';
import 'A_SQL_Trigger/Local_Contact.dart';
import 'A_SQL_Trigger/sql_usermast.dart';
import 'Constant/Con_Wid.dart';
import 'Login/Splash.dart';
import 'Notifications/NotificationService.dart';
import 'OSFind.dart';
import 'mdi_page/Message/msg_sub_contactsdetails.dart';

bool users = false;
bool navigate = false;
String touser = "";

var platform = const MethodChannel("com.app.nextapp/notifications");
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
List<String> GlbPandingNotification = [];

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
   await initializeLocalNotifications();

   //await ThemeModeBuilderConfig.ensureInitialized();

  await FirebaseMessaging.instance.requestPermission();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  final NotificationAppLaunchDetails? notificationAppLaunchDetails =
       await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
   if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
     GlbPandingNotification.clear();
   }
  var dir = await getApplicationDocumentsDirectory();
  var path = "${dir.path}/databases";
  Constants_Usermast.dbpath = Directory(path.toString());
  Hive
    ..init(path)
    ..registerAdapter(sqlusermasttranAdapter());
  Hive
    ..init(path)
    ..registerAdapter(sqlcontacttranAdapter());
  Hive
    ..init(path)
    ..registerAdapter(NeedContactAdapter());
  Hive
    ..init(path)
    ..registerAdapter(NeedBroadcastAdapter());
  Hive
    ..init(path)
    ..registerAdapter(NeedBroadcastSubMsgAdapter());
  Hive
    ..init(path)
    ..registerAdapter(NeedQuickReplyAdapter());
  Hive
    ..init(path)
    ..registerAdapter(NeedDeviceSessionAdapter());
  Hive
    ..init(path)
    ..registerAdapter(NeedMainChatAdapter());
  Hive
    ..init(path)
    ..registerAdapter(NeedMainSubChatAdapter());
  Hive
    ..init(path)
    ..registerAdapter(USERMSGAUTOSENDERAdapter());
  Hive
    ..init(path)
    ..registerAdapter(MediaListClassAdapter());
  Hive
    ..init(path)
    ..registerAdapter(LocalContactAdapter());
  final cameras = await availableCameras();

  runApp(const MyApp());
}
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    List<String> MainChatids = await SharedPref.readlist('Need_MainChat');
    final notification = message.data,
        body = notification['body'] ?? '',
        fromid = notification['fromid'] ?? '',
        senderToken = notification['Sender_token'] ?? '',
        pStrMediaType = notification['mediatype'] ?? '',
        ImageUrl = notification['imageurl'] ?? '',
        Medianame = notification['medianame'] ?? '';
    var title;
    try {
      title = MainChatids.firstWhere((e) => e.contains(fromid.toString()))
          .split('/*/')
          .last;
    } catch (e) {
      title = notification['title'] ?? '';
    }

    bool ismute = await SharedPref.read_bool(
            'mute_user_${fromid.toString().trim().trimRight().trimLeft()}') ??
        false;
    if (!ismute) {
      if (GlbPandingNotification.length < 7) {
        GlbPandingNotification.add(body);
      } else {
        GlbPandingNotification.removeAt(0);
        GlbPandingNotification.add(body);
      }
      await showLocalNotification(
          title: title,
          body: body,
          fromid: fromid,
          Sender_token: senderToken,
          ImageUrl: ImageUrl,
          pStrMediaType: pStrMediaType,
          MediaName: Medianame);
    }
  } catch (e) {
    print(e);
  }
}

@pragma('vm:entry-point')
Future<void> initializeLocalNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: onTapNotification,
    onDidReceiveBackgroundNotificationResponse: onReplyNotification,
  );
}

@pragma('vm:entry-point')
onTapNotification(NotificationResponse notificationResponse) async {
  GlbPandingNotification.clear();
  List<Need_MainChat> _firstchatlist = await SyncJSon.user_main_chat_select();
  Need_MainChat chat = _firstchatlist.firstWhere((e) =>
      e.msg_to_user_mast_id.toString() == notificationResponse.id.toString());
  navigatorKey.currentState!.push(RouteTransitions.slideTransition(
    sub_contactsdetails(
      chat.uc_contact_id.toString(),
      chat.user_mast_id.toString(),
      chat.disp_name.toString(),
      chat.user_profileimage_path,
      chat.user_is_favourite,
      chat.user_bio,
      chat.user_bio_last_datetime,
      chat.user_is_online,
      chat.user_last_login_time,
      chat.user_birthdate,
      chat.user_countrywithmobile,
      chat.user_is_block,
      serverKey: chat.server_key,
    ),
  ));
}

@pragma('vm:entry-point')
onReplyNotification(NotificationResponse notificationResponse) async {
  try {
    String userId = await (SharedPref.read_string('user_id') ?? "");
    String LoginName = await (SharedPref.read_string('user_login_name') ?? "");
    if (notificationResponse.actionId == 'Mark_As_Read') {
      sql_main_messages_tran.ReadUserWiseMsg(
          notificationResponse.id.toString(), userId);
    } else {
      await Firebase.initializeApp();
      await sql_sub_messages_tran.Send_Msg(
          sender_name: LoginName,
          msg_content: notificationResponse.input.toString(),
          msg_type: "1",
          msg_document_url: '',
          from_id: userId,
          to_id: notificationResponse.actionId.toString(),
          is_broadcast: "0",
          broadcast_id: '',
          server_key: notificationResponse.payload.toString());
    }
  } catch (e) {}
  // await SyncDB.SyncTable(
  //     "USER_MSG1", true, notificationResponse.payload.toString());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    ReceiveSharingIntent.getInitialMedia().then((List<SharedMediaFile> value) {
      if (value.isNotEmpty) {
        Fluttertoast.showToast(msg: value[0].path);
      }
      // if (Platform.isAndroid) {
      //   Os.isIOS = true;
      // } else if (Platform.isIOS) {
      //   Os.isIOS = false;
      // }
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Os.isIOS
        ? MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Nxt',
            themeMode: ThemeMode.system,
            theme: ThemeData(
              unselectedWidgetColor: Con_black,
              checkboxTheme: CheckboxThemeData(
                  checkColor: MaterialStateProperty.all(Con_white),
                  shape: const CircleBorder(),
                  fillColor: MaterialStateProperty.all(Con_Main_1)),
              primaryColor: const Color(0xFF999696),
              primaryColorDark: Con_white,
              listTileTheme: ListTileThemeData(
                iconColor: Con_black,
                selectedColor: const Color(0xFF06159F).withOpacity(0.70),
              ),
              textTheme: Theme.of(context).textTheme.apply(
                    bodyColor: Con_black,
                    displayColor: Con_black,
                  ),
              inputDecorationTheme: const InputDecorationTheme(
                labelStyle: TextStyle(color: Con_black),
                hintStyle: TextStyle(color: Con_white),
                fillColor: Con_white,
              ),
              popupMenuTheme: const PopupMenuThemeData(
                  color: Con_white, textStyle: TextStyle(color: Con_black)),
              floatingActionButtonTheme: const FloatingActionButtonThemeData(
                  backgroundColor: Con_Main_1),
              buttonTheme: const ButtonThemeData(buttonColor: Con_Main_1),
              elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ElevatedButton.styleFrom(backgroundColor: Con_Main_1)),
              tabBarTheme: TabBarTheme(
                unselectedLabelColor: Con_white.withOpacity(0.60),
                labelColor: Con_white,
              ),
              appBarTheme: AppBarTheme(
                  backgroundColor: Con_Main_1.withOpacity(0.70),
                  titleTextStyle: const TextStyle(
                      color: Con_white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  elevation: 0,
                  iconTheme: const IconThemeData(
                    color: Con_white,
                  ),
                  actionsIconTheme: const IconThemeData(
                    color: Con_white,
                  )),
              textSelectionTheme: const TextSelectionThemeData(
                cursorColor: Color.fromRGBO(66, 133, 244, 1.0),
                selectionColor: Color(0xff90caf9),
                selectionHandleColor: Color(0xff64b5f6),
              ),
              splashColor: Con_Main_1.withOpacity(0.20),
              highlightColor: Con_Main_1.withOpacity(0.20),
              scaffoldBackgroundColor: AppBar_PrimaryColor,
              hintColor: AppBlueGreyColor2,
              pageTransitionsTheme: const PageTransitionsTheme(builders: {
                TargetPlatform.android: CupertinoPageTransitionsBuilder()
              }),
              colorScheme: ColorScheme.fromSwatch()
                  .copyWith(primary: Con_Main_1)
                  .copyWith(background: Con_white),
            ),
            darkTheme: ThemeData(
              checkboxTheme: CheckboxThemeData(
                  checkColor: MaterialStateProperty.all(Con_white),
                  shape: const CircleBorder(),
                  fillColor: MaterialStateProperty.all(Con_Main_1)),
              // buttonTheme: const ButtonThemeData(buttonColor: Color(0xff1a73e8)),
              buttonTheme:
                  const ButtonThemeData(buttonColor: Colors.deepPurpleAccent),
              iconTheme: const IconThemeData(color: Dark_AppGreyColor),
              elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Chat_Row_UnRead_Color)),
              radioTheme: RadioThemeData(
                  fillColor:
                      MaterialStateProperty.all(Con_Main_1.withOpacity(0.70))),
              brightness: Brightness.values.first,
              bottomSheetTheme:
                  const BottomSheetThemeData(backgroundColor: Con_grey),
              drawerTheme: const DrawerThemeData(backgroundColor: Con_grey),
              switchTheme: SwitchThemeData(
                  trackColor: MaterialStateProperty.all(Con_grey)),
              primaryColor: DarkTheme_Main,
              // primaryColor: Con_black,
              primaryColorDark: DarkTheme_Main,
              unselectedWidgetColor: Con_white,
              dialogBackgroundColor: DarkTheme_Main,
              listTileTheme: ListTileThemeData(
                iconColor: Con_white,
                selectedTileColor: Con_Main_1.withOpacity(0.70),
                selectedColor: Con_Main_1.withOpacity(0.70),
              ),
              textTheme: Theme.of(context).textTheme.apply(
                    bodyColor: Con_white,
                    displayColor: Con_white,
                  ),
              popupMenuTheme: const PopupMenuThemeData(
                  color: DarkTheme_Main,
                  textStyle: TextStyle(color: Con_white)),
              floatingActionButtonTheme: const FloatingActionButtonThemeData(
                  backgroundColor: Con_Main_1),
              tabBarTheme: const TabBarTheme(unselectedLabelColor: Con_white),
              appBarTheme: const AppBarTheme(
                  backgroundColor: DarkTheme_AppBar, // appbar color
                  elevation: 0,
                  iconTheme: IconThemeData(color: Con_white),
                  actionsIconTheme: IconThemeData(color: Con_white)),
              textSelectionTheme: const TextSelectionThemeData(
                cursorColor: Color.fromRGBO(66, 133, 244, 1.0),
                selectionColor: Con_green,
                // selectionColor: Color(0xff90caf9),
                selectionHandleColor: Color(0xff64b5f6),
              ),
              splashColor: const Color(0x4d5193a1),
              highlightColor: const Color(0x4d5193a1),
              scaffoldBackgroundColor: DarkTheme_Main,
              hintColor: AppBlueGreyColor2,
              // colorScheme: ColorScheme(background: Con_black, onSecondary: ),
            ),
            // home: const Splash(),
            initialRoute: '/',
            navigatorKey: navigatorKey,
            onGenerateRoute: (RouteSettings settings) {
              switch (settings.name) {
                case '/':
                  return RouteTransitions.slideTransition(const Splash());
                case '/Splash':
                  return RouteTransitions.slideTransition(const Splash());
                default:
                  return null;
              }
            },
          )
        : const CupertinoApp(
            debugShowCheckedModeBanner: false,
            home: Splash(),
          );
  }
// @override
// Widget build(BuildContext context) {
//   return ThemeModeBuilder(
//       builder: (BuildContext context, ThemeMode themeMode) {
//     return Os.isIOS
//         ? MaterialApp(
//             debugShowCheckedModeBanner: false,
//             title: 'Nxt',
//             themeMode: themeMode,
//             theme: ThemeData(
//               unselectedWidgetColor: Con_black,
//               checkboxTheme: CheckboxThemeData(
//                   checkColor: MaterialStateProperty.all(Con_white),
//                   shape: const CircleBorder(),
//                   fillColor: MaterialStateProperty.all(Con_Main_1)),
//               primaryColor: const Color(0xFF999696),
//               primaryColorDark: Con_white,
//               listTileTheme: ListTileThemeData(
//                 iconColor: Con_black,
//                 selectedColor: const Color(0xFF06159F).withOpacity(0.70),
//               ),
//               textTheme: Theme.of(context).textTheme.apply(
//                     bodyColor: Con_black,
//                     displayColor: Con_black,
//                   ),
//               inputDecorationTheme: const InputDecorationTheme(
//                 labelStyle: TextStyle(color: Con_black),
//                 hintStyle: TextStyle(color: Con_white),
//                 fillColor: Con_white,
//               ),
//               popupMenuTheme: const PopupMenuThemeData(
//                   color: Con_white, textStyle: TextStyle(color: Con_black)),
//               floatingActionButtonTheme: const FloatingActionButtonThemeData(
//                   backgroundColor: Con_Main_1),
//               buttonTheme: const ButtonThemeData(buttonColor: Con_Main_1),
//               elevatedButtonTheme: ElevatedButtonThemeData(
//                   style:
//                       ElevatedButton.styleFrom(backgroundColor: Con_Main_1)),
//               tabBarTheme: TabBarTheme(
//                 unselectedLabelColor: Con_white.withOpacity(0.60),
//                 labelColor: Con_white,
//               ),
//               appBarTheme: AppBarTheme(
//                   backgroundColor: Con_Main_1.withOpacity(0.70),
//                   titleTextStyle: const TextStyle(
//                       color: Con_white,
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold),
//                   elevation: 0,
//                   iconTheme: const IconThemeData(
//                     color: Con_white,
//                   ),
//                   actionsIconTheme: const IconThemeData(
//                     color: Con_white,
//                   )),
//               textSelectionTheme: const TextSelectionThemeData(
//                 cursorColor: Color.fromRGBO(66, 133, 244, 1.0),
//                 selectionColor: Color(0xff90caf9),
//                 selectionHandleColor: Color(0xff64b5f6),
//               ),
//               splashColor: Con_Main_1.withOpacity(0.20),
//               highlightColor: Con_Main_1.withOpacity(0.20),
//               scaffoldBackgroundColor: AppBar_PrimaryColor,
//               hintColor: AppBlueGreyColor2,
//               pageTransitionsTheme: const PageTransitionsTheme(builders: {
//                 TargetPlatform.android: CupertinoPageTransitionsBuilder()
//               }),
//               colorScheme: ColorScheme.fromSwatch()
//                   .copyWith(primary: Con_Main_1)
//                   .copyWith(background: Con_white),
//             ),
//             darkTheme: ThemeData(
//               checkboxTheme: CheckboxThemeData(
//                   checkColor: MaterialStateProperty.all(Con_white),
//                   shape: const CircleBorder(),
//                   fillColor: MaterialStateProperty.all(Con_Main_1)),
//               // buttonTheme: const ButtonThemeData(buttonColor: Color(0xff1a73e8)),
//               buttonTheme:
//                   const ButtonThemeData(buttonColor: Colors.deepPurpleAccent),
//               iconTheme: const IconThemeData(color: Dark_AppGreyColor),
//               elevatedButtonTheme: ElevatedButtonThemeData(
//                   style: ElevatedButton.styleFrom(
//                       backgroundColor: Chat_Row_UnRead_Color)),
//               radioTheme: RadioThemeData(
//                   fillColor: MaterialStateProperty.all(
//                       Con_Main_1.withOpacity(0.70))),
//               brightness: Brightness.values.first,
//               bottomSheetTheme:
//                   const BottomSheetThemeData(backgroundColor: Con_grey),
//               drawerTheme: const DrawerThemeData(backgroundColor: Con_grey),
//               switchTheme: SwitchThemeData(
//                   trackColor: MaterialStateProperty.all(Con_grey)),
//               primaryColor: DarkTheme_Main,
//               // primaryColor: Con_black,
//               primaryColorDark: DarkTheme_Main,
//               unselectedWidgetColor: Con_white,
//               dialogBackgroundColor: DarkTheme_Main,
//               listTileTheme: ListTileThemeData(
//                 iconColor: Con_white,
//                 selectedTileColor: Con_Main_1.withOpacity(0.70),
//                 selectedColor: Con_Main_1.withOpacity(0.70),
//               ),
//               textTheme: Theme.of(context).textTheme.apply(
//                     bodyColor: Con_white,
//                     displayColor: Con_white,
//                   ),
//               popupMenuTheme: const PopupMenuThemeData(
//                   color: DarkTheme_Main,
//                   textStyle: TextStyle(color: Con_white)),
//               floatingActionButtonTheme: const FloatingActionButtonThemeData(
//                   backgroundColor: Con_Main_1),
//               tabBarTheme: const TabBarTheme(unselectedLabelColor: Con_white),
//               appBarTheme: const AppBarTheme(
//                   backgroundColor: DarkTheme_AppBar, //  appbar color
//                   elevation: 0,
//                   iconTheme: IconThemeData(color: Con_white),
//                   actionsIconTheme: IconThemeData(color: Con_white)),
//               textSelectionTheme: const TextSelectionThemeData(
//                 cursorColor: Color.fromRGBO(66, 133, 244, 1.0),
//                 selectionColor: Con_green,
//                 // selectionColor: Color(0xff90caf9),
//                 selectionHandleColor: Color(0xff64b5f6),
//               ),
//               splashColor: const Color(0x4d5193a1),
//               highlightColor: const Color(0x4d5193a1),
//               scaffoldBackgroundColor: DarkTheme_Main,
//               hintColor: AppBlueGreyColor2,
//               // colorScheme: ColorScheme(background: Con_black, onSecondary: ),
//             ),
//             // home: const Splash(),
//             initialRoute: '/',
//             onGenerateRoute: (RouteSettings settings) {
//               switch (settings.name) {
//                 case '/':
//                   return MaterialPageRoute(
//                       builder: (context) => const Splash());
//                 case '/Splash':
//                   return MaterialPageRoute(
//                       builder: (context) => const Splash());
//                 default:
//                   return null;
//               }
//             },
//           )
//         : const CupertinoApp(
//             debugShowCheckedModeBanner: false,
//             home: Splash(),
//           );
//   });
// }
}
