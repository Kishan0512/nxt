import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:nextapp/Constant/Con_Usermast.dart';
import 'package:path/path.dart';

import '../A_FB_Trigger/SharedPref.dart';
import '../main.dart';

String channelID = 'Nxt_Notifications',
    channelName = 'Nxt Notifications',
    channelDesc = 'nxt notifications channel description',
    groupKey = 'Nxt_Group_Notification',
    channelID_vibr = 'Nxt_Notifications_vibr',
    channelName_vibr = 'Nxt Notifications vibr',
    channelDesc_vibr = 'nxt notifications channel description vibr';

Future<String> _downloadAndSaveFile(String url, String fileName) async {
  if (url.isNotEmpty) {
    Directory base = Directory('/storage/emulated/0/');
    var dire = join(base.path, "Nxt");
    var img = join(dire, "Nxt Images");
    Directory images = Directory(img);
    if (await images.exists() == false) {
      images.create(recursive: true);
    }

    final String filePath = "${images.path}/${fileName.split('.').first}.webp";
    if (!File(filePath).existsSync()) {
      try {
        await Dio().download(url, filePath);
      } catch (E) {}
    }
    return filePath;
  } else {
    return '';
  }
}

@pragma('vm:entry-point')
Future<void> showLocalNotification(
    {required String title,
    required String body,
    required String Sender_token,
    required String fromid,
    required String ImageUrl,
    required String MediaName,
    required String pStrMediaType}) async {
  Constants_Usermast.user_notify_conversionTone =
      await SharedPref.read_bool('user_notify_conversionTone') ?? true;
  Constants_Usermast.user_vibrate =
      await SharedPref.read_int('user_vibrate') ?? 1;

  // print("Constants_Usermast.user_notify_conversionTone");
  // print(Constants_Usermast.user_notify_conversionTone);
  // print(Constants_Usermast.user_vibrate);
  final String largeIconPath = await _downloadAndSaveFile(ImageUrl, MediaName);
  final String bigPicturePath = await _downloadAndSaveFile(ImageUrl, MediaName);
  final BigPictureStyleInformation bigPictureStyleInformation =
      BigPictureStyleInformation(FilePathAndroidBitmap(bigPicturePath),
          hideExpandedLargeIcon: true);
  InboxStyleInformation inboxStyleInformation =
      InboxStyleInformation(GlbPandingNotification);
  AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
    Constants_Usermast.user_notify_conversionTone
        ? channelID
        : Constants_Usermast.user_vibrate == 2
            ? channelID_vibr
            : channelID_vibr + Constants_Usermast.user_vibrate.toString(),
    Constants_Usermast.user_notify_conversionTone
        ? channelName
        : Constants_Usermast.user_vibrate == 2
            ? channelName_vibr
            : channelName_vibr + Constants_Usermast.user_vibrate.toString(),
    channelDescription: Constants_Usermast.user_notify_conversionTone
        ? channelDesc
        : Constants_Usermast.user_vibrate == 2
            ? channelDesc_vibr
            : channelDesc_vibr + Constants_Usermast.user_vibrate.toString(),
    styleInformation: ImageUrl.isNotEmpty
        ? bigPictureStyleInformation
        : inboxStyleInformation,
    importance: Importance.high,
    enableVibration: Constants_Usermast.user_vibrate == 0 ? false : true,
    playSound: Constants_Usermast.user_notify_conversionTone,
    vibrationPattern: Constants_Usermast.user_vibrate == 1
        ? Int64List.fromList([0, 400, 800, 400]) // default
        : Constants_Usermast.user_vibrate == 2
            ? Int64List.fromList([100, 100]) // short
            : Constants_Usermast.user_vibrate == 3
                ? Int64List.fromList([0, 1000, 500, 1000]) // long
                : null,
    largeIcon:
        ImageUrl.isNotEmpty ? FilePathAndroidBitmap(largeIconPath) : null,
    priority: Priority.high,
    ticker: 'ticker',
    groupKey: groupKey,
    setAsGroupSummary: true,
    actions: <AndroidNotificationAction>[
      const AndroidNotificationAction(
        'Mark_As_Read',
        'Mark As Read',
        icon: DrawableResourceAndroidBitmap('me'),
      ),
      AndroidNotificationAction(
        fromid,
        'Reply',
        inputs: [
          const AndroidNotificationActionInput(
            label: 'Enter a message',
          ),
        ],
      ),
    ],
  );

  NotificationDetails notificationDetails = NotificationDetails(
    android: androidNotificationDetails,
  );
  await flutterLocalNotificationsPlugin.show(
    int.parse(fromid),
    title,
    body,
    notificationDetails,
    payload: Sender_token,
  );
}

class SendNotification {
  static Future<void> sendPushNotification({
    required String Receiver_Token,
    required String Sender_Token,
    required String body,
    required String title,
    required String pStrMediaType,
    required String MediaName,
    required String ImageUrl,
    required String from_id,
    required String to_id,
  }) async {
    try {
      http.Response response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':
              'key=AAAANabYAOE:APA91bHDjOOkPffN5jAWGrTbMJjxM-VonpvzjQAP3omAd5AbtXlrxVHrlz-Uh7ScznDSIt1L_C5IbvUt9Aq4hXOE5mgpqtg9x4hoP1lR-8hJFzrejrRHhHSgLcaAdrYhOCtHdq5dlF3Y',
        },
        body: jsonEncode(
          <String, dynamic>{
            'data': <String, dynamic>{
              if (body.isNotEmpty) 'body': body,
              if (title.isNotEmpty) 'title': title,
              'fromid': from_id,
              'Sender_token': Sender_Token,
              if (pStrMediaType.isNotEmpty) 'mediatype': pStrMediaType,
              if (ImageUrl.isNotEmpty) 'imageurl': ImageUrl.toString(),
              if (MediaName.isNotEmpty) 'medianame': MediaName,
            },
            'priority': 'high',
            'to': Receiver_Token,
          },
        ),
      );

    } catch (e) {
      if (kDebugMode) {
        print("notification error ---> $e");
      }
    }
  }
}
