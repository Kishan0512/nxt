import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:nextapp/A_Local_DB/Sync_Json.dart';
import 'package:nextapp/A_SQL_Trigger/ConstantApi.dart';
import 'package:nextapp/A_SQL_Trigger/sql_usermast.dart';
import 'package:nextapp/Constant/Con_Usermast.dart';
import 'package:nextapp/Constant/Constants.dart';
import 'package:nextapp/Login/DownloadData.dart';

import '../A_FB_Trigger/sql_need_broadcast_sub_msg.dart';
import '../A_FB_Trigger/sql_need_main_sub_chat.dart';
import '../A_FB_Trigger/sql_need_quickreply.dart';
import 'ValueNotifier.dart';

class SyncDB {
  static List<String> TableName = const [
    'USER_MSG_LAST',
    'USER_QUICK_REP',
    'USER_BROADCAST',
    'USER_DEVICE_SESSION',
  ];
  static List<String> TableNameDel = const [
    'USER_BROADCAST',
    'USER_QUICK_REP',
    'USER_DEVICE_SESSION',
    'USER_MSG_BROADCAST',
    'USER_CONTACT',
    'USER_MAST',
    'USER_MSG',
    'USER_MSG_LAST',
  ];

  static Future SyncTableAuto(bool _blnAuto) async {
    for (var e in TableName) {
      SyncTable(e, _blnAuto);
    }
  }

  static Future SyncAllTable(bool _blnAuto) async {
    for (var e in TableNameDel) {
      SyncTable(e, _blnAuto);
    }
  }

  static Future<void> update_table(
      Map<String, Object?> note, String pStrTableName) async {
    try {
      // final db = await dbhelper.GenerateDB();
      // switch (pStrTableName) {
      //   case "USER_MSG":
      //     int value = (int.parse(note['id'].toString()));
      //     if (value == 0) {
      //       break;
      //     }
      //     if (value != 0) {
      //       await db
      //           .update(pStrTableName, note, where: "id=?", whereArgs: [value]);
      //     }
      //     break;
      //   case "USER_CONTACT":
      //     int value = (int.parse(note['id'].toString()));
      //     if (value == 0) {
      //       break;
      //     }
      //     if (value != 0) {
      //       await db
      //           .update(pStrTableName, note, where: "id=?", whereArgs: [value]);
      //     }
      //     break;
      //   case "USER_QUICK_REP":
      //     int value = (int.parse(note['id'].toString()));
      //     if (value == 0) {
      //       break;
      //     }
      //     if (value != 0) {
      //       await db
      //           .update(pStrTableName, note, where: "id=?", whereArgs: [value]);
      //     }
      //     break;
      //   case "USER_MSG_LAST":
      //     int value = (int.parse(note['id'].toString()));
      //     if (value == 0) {
      //       break;
      //     }
      //     if (value != 0) {
      //       await db
      //           .update(pStrTableName, note, where: "id=?", whereArgs: [value]);
      //     }
      //     break;
      //   case "USER_BROADCAST":
      //     int value = (int.parse(note['id'].toString()));
      //     if (value == 0) {
      //       break;
      //     }
      //     if (value != 0) {
      //       await db
      //           .update(pStrTableName, note, where: "id=?", whereArgs: [value]);
      //     }
      //     break;
      //   case "USER_MAST":
      //     int value = (int.parse(note['id'].toString()));
      //     if (value == 0) {
      //       break;
      //     }
      //     if (value != 0) {
      //       await db
      //           .update(pStrTableName, note, where: "ID=?", whereArgs: [value]);
      //     }
      //     break;
      //   case "USER_MSG_BROADCAST":
      //     int value = (int.parse(note['id'].toString()));
      //     if (value == 0) {
      //       break;
      //     }
      //     if (value != 0) {
      //       await db
      //           .update(pStrTableName, note, where: "id=?", whereArgs: [value]);
      //     }
      //     break;
      //   case "USER_DEVICE_SESSION":
      //     int value = (int.parse(note['id'].toString()));
      //     if (value == 0) {
      //       break;
      //     }
      //     if (value != 0) {
      //       await db
      //           .update(pStrTableName, note, where: "id=?", whereArgs: [value]);
      //     }
      //     break;
      // }
    } catch (e) {}
  }

  static MyNotifierClass myNotifier = MyNotifierClass(true);

  static Future SyncTable(String pStrTableName, bool _blnauto,
      [String? toId]) async {
    try {
      FirebaseMessaging.instance.onTokenRefresh.listen(
          (value) => sql_usermast_tran.mSetUserOtpDetail('', deviceKey: value));
    } catch (E) {}
    switch (pStrTableName) {
      case "USER_MSG_AUTOSENDER":
        if (myNotifier.getbool(Key: pStrTableName)) {
          myNotifier.updateBool(Key: pStrTableName, value: false);
          if (Constants_Usermast.user_id.isEmpty &&
              Constants_Usermast.user_id.toString() == "0") {
            break;
          }
          var response = await http
              .post(Uri.parse(ConstantApi.AutoSender_Select), body: {
            "msg_from_user_mast_id": Constants_Usermast.user_id.toString()
          });
          if (response.statusCode == 200) {
            myNotifier.updateBool(Key: pStrTableName, value: true);
          }
          if (response.body.isNotEmpty &&
              response.statusCode == 200 &&
              response.body.toString() != "[]") {
            try {
              var herds = json.decode(response.body);
              return await SyncJSon.user_auto_sender_save(herds);
            } catch (e) {}
          }
          // if (!DownloadData.Keyvalue.contains("USER_BROADCAST")) {
          //   DownloadData.Keyvalue.add("USER_BROADCAST");
          //   DownloadData.respones.add(response.statusCode);
          // }
        }
        break;
      case "USER_BROADCAST":
        if (myNotifier.getbool(Key: pStrTableName)) {
          myNotifier.updateBool(Key: pStrTableName, value: false);
          if (Constants_Usermast.user_id.isEmpty &&
              Constants_Usermast.user_id.toString() == "0") {
            break;
          }
          var response =
              await http.post(Uri.parse(ConstantApi.BroadCastGetData), body: {
            "br_user_mast_id": Constants_Usermast.user_id.toString(),
            "high_get_from_id": "0"
          });
          if (response.statusCode == 200) {
            myNotifier.updateBool(Key: pStrTableName, value: true);
          }
          if (response.body.isNotEmpty &&
              response.statusCode == 200 &&
              response.body.toString() != "[]") {
            try {
              var herds = json.decode(response.body);
              SyncJSon.user_broadcast_save(herds);
              SyncTable(Constants.Table_Msg_broadcast, false);
            } catch (e) {}
          }
          if (!DownloadData.Keyvalue.contains("USER_BROADCAST")) {
            DownloadData.Keyvalue.add("USER_BROADCAST");
            DownloadData.respones.add(response.statusCode);
          }
        }
        break;
      case "USER_MSG_BROADCAST":
        try {
          for (int ite = 0; ite < Constants_List.need_broadcast.length; ite++) {
            if (myNotifier.getbool(Key: pStrTableName)) {
              myNotifier.updateBool(Key: pStrTableName, value: false);
              var box = await Hive.openBox<Need_Broadcast_Sub_Msg>(
                  "Need_Broadcast_Sub_Msg" +
                      Constants_List.need_broadcast[ite].id);
              String updateId;
              try {
                updateId = box.keys.last.toString();
              } catch (e) {
                updateId = "0";
              }
              var response = await http
                  .post(Uri.parse(ConstantApi.BroadCastWiseGetData), body: {
                "id": Constants_List.need_broadcast[ite].id.toString(),
                "msg_from_user_mast_id": Constants_Usermast.user_id.toString(),
                "high_get_from_id": updateId.toString()
              });
              if (response.statusCode == 200) {
                myNotifier.updateBool(Key: pStrTableName, value: true);
              }
              if (response.body.isNotEmpty &&
                  response.statusCode == 200 &&
                  response.body.toString() != "[]") {
                List herds = json.decode(response.body);
                if (herds.isNotEmpty) {
                  SyncJSon.user_msg_broadcast_save(
                      herds, Constants_List.need_broadcast[ite].id);
                }
              }
            }
          }
        } catch (e) {}
        break;
      case "USER_CONTACT":
        if (myNotifier.getbool(Key: pStrTableName)) {
          myNotifier.updateBool(Key: pStrTableName, value: false);
          if (Constants_Usermast.user_id.isEmpty &&
              Constants_Usermast.user_id.toString() == "0") {
            break;
          }

          var response = await http.post(Uri.parse(ConstantApi.ContactGetData),
              body: {"contact_id": Constants_Usermast.user_id.toString()});

          if (response.statusCode == 200) {
            myNotifier.updateBool(Key: pStrTableName, value: true);
          }
          if (response.body.isNotEmpty &&
              response.statusCode == 200 &&
              response.body.toString() != "[]") {
            List herds;
            try {
              herds = json.decode(response.body);
            } catch (e) {
              herds = [];
            }
            SyncJSon.user_contact_save(herds);
            if (Constants_List.needs_main_chat.isEmpty) {
              SyncTable(Constants.usermainmsg, true);
            }
          }
        }
        break;
      case "USER_DEVICE_SESSION":
        if (myNotifier.getbool(Key: pStrTableName)) {
          myNotifier.updateBool(Key: pStrTableName, value: false);
          var response = await http
              .post(Uri.parse(ConstantApi.DeviceSelectData), body: {
            "user_mast_id": Constants_Usermast.user_id.toString(),
            "high_get_from_id": "0"
          });
          if (!DownloadData.Keyvalue.contains("USER_DEVICE_SESSION")) {
            DownloadData.Keyvalue.add("USER_DEVICE_SESSION");
            DownloadData.respones.add(response.statusCode);
          }
          if (response.statusCode == 200) {
            myNotifier.updateBool(Key: pStrTableName, value: true);
          }
          if (response.body.isNotEmpty &&
              response.statusCode == 200 &&
              response.body.toString() != "[]") {
            try {
              List herds = json.decode(response.body);
              SyncJSon.user_device_session_save(herds);
            } catch (e) {}
          }
        }
        break;
      case "USER_MAST":
        if (myNotifier.getbool(Key: pStrTableName)) {
          myNotifier.updateBool(Key: pStrTableName, value: false);
          if (Constants_Usermast.user_id.isEmpty &&
              Constants_Usermast.user_id.toString() == "0") {
            break;
          }
          var response = await http
              .post(Uri.parse(ConstantApi.LoginUserGetData), body: {
            "user_id": Constants_Usermast.user_id.toString(),
            "high_get_from_id": "0"
          });
          if (!DownloadData.Keyvalue.contains("SelectUserTable")) {
            DownloadData.Keyvalue.add("SelectUserTable");
            DownloadData.respones.add(response.statusCode);
          }
          if (response.statusCode == 200) {
            myNotifier.updateBool(Key: pStrTableName, value: true);
          }
          if (response.body.isNotEmpty &&
              response.statusCode == 200 &&
              response.body != "[]") {
            try {
              List herds = json.decode(response.body);
              SyncJSon.user_mast_table_save(herds);
            } catch (e) {}
          }
        }
        break;
      case "USER_MSG":
        if (Constants_Usermast.user_id.isEmpty &&
            Constants_Usermast.user_id.toString() == "0") {
          break;
        }
        try {
          if (myNotifier.getbool(Key: pStrTableName)) {
            myNotifier.updateBool(Key: pStrTableName, value: false);
            var box =
                await Hive.openBox<Need_Main_Sub_Chat>("Need_Main_Sub_Chat");
            String updateId;
            List temp = box.values
                .toList()
                .where((e) =>
                    e.is_right.toString() == '1' &&
                    (e.is_read != 'true' || e.is_delivered != 'true'))
                .map((e) => e.id)
                .toList()
              ..sort((a, b) => a.compareTo(b));

            if (temp.isNotEmpty) {
              updateId = temp.first.toString();
            } else if (temp.length == 1) {
              updateId = temp[0].toString();
            } else {
              try {
                updateId = box.keys.last.toString();
              } catch (e) {
                updateId = "0";
              }
            }

            var response =
                await http.post(Uri.parse(ConstantApi.MessageGet), body: {
              "msg_from_user_mast_id": Constants_Usermast.user_id.toString(),
              "msg_to_user_mast_id": '0',
              "high_get_from_id": updateId.toString()
            });

            if (response.statusCode == 200) {
              myNotifier.updateBool(Key: pStrTableName, value: true);
            }
            if (response.body.isNotEmpty &&
                response.statusCode == 200 &&
                response.body.toString() != "[]") {
              var herds = json.decode(response.body);
              if (herds.isNotEmpty || herds.toString().contains("[")) {
                SyncJSon.user_sub_main_chat_save(
                    herds);
              }
            }
          }
        } catch (e) {}
        // }
        break;
      case "USER_MSG1":
        if (Constants_Usermast.user_id.isEmpty &&
            Constants_Usermast.user_id == toId &&
            Constants_Usermast.user_id.toString() == "0") {
          break;
        }
        try {
          var box = await Hive.openBox<Need_Main_Sub_Chat>(
              "Need_Main_Sub_Chat");
          String updateId;
          try {
            updateId = box.keys.last.toString();
          } catch (e) {
            updateId = "0";
          }
          if (Constants_List.need_contact.isEmpty) {
            Constants_List.need_contact =
                (await SyncJSon.user_contact_select_contacts(0));
          }
          // for (int ite = 0; ite < Constants_List.need_contact.length; ite++) {
          var response =
              await http.post(Uri.parse(ConstantApi.MessageGet), body: {
            "msg_from_user_mast_id": Constants_Usermast.user_id.toString(),
            "msg_to_user_mast_id": toId.toString(),
            "high_get_from_id": updateId.toString()
          });
          if (response.body.isNotEmpty &&
              response.statusCode == 200 &&
              response.body.toString() != "[]") {
            List herds = json.decode(response.body);
            if (herds.isNotEmpty) {
              SyncJSon.user_sub_main_chat_save(herds);
            }
          }
        } catch (e) {
          print("USER_MSG1 = $e");
        }

        // }
        break;
      case "USER_MSG_LAST":
        if (myNotifier.getbool(Key: pStrTableName)) {
          myNotifier.updateBool(Key: pStrTableName, value: false);
          if (Constants_Usermast.user_id.isEmpty &&
              Constants_Usermast.user_id.toString() == "0") {
            break;
          }

          var response =
              await http.post(Uri.parse(ConstantApi.MainChatGetData), body: {
            "msg_from_user_mast_id": Constants_Usermast.user_id.toString(),
            "high_get_from_id": "0"
          });

          if (!DownloadData.Keyvalue.contains("USER_MSG_LAST")) {
            DownloadData.Keyvalue.add("USER_MSG_LAST");
            DownloadData.respones.add(response.statusCode);
          }
          if (response.statusCode == 200) {
            myNotifier.updateBool(Key: pStrTableName, value: true);
          }
          if (response.body.isNotEmpty &&
              response.statusCode == 200 &&
              response.body.toString() != "[]" &&
              response.body.toString() != "") {
            List herds;
            try {
              herds = json.decode(response.body);
            } catch (e) {
              herds = [];
            }
            SyncJSon.user_main_chat_save(herds);
            SyncTable(Constants.usersubmsg, false);
          }
        }
        break;
      case "USER_QUICK_REP":
        if (myNotifier.getbool(Key: pStrTableName)) {
          myNotifier.updateBool(Key: pStrTableName, value: false);
          if (Constants_Usermast.user_id.isEmpty &&
              Constants_Usermast.user_id.toString() == "0") {
            break;
          }
          var box = await Hive.openBox<Need_QuickReply>("Need_QuickReply");
          String updateId;
          try {
            updateId = box.keys.last.toString();
          } catch (e) {
            updateId = "0";
          }
          var response =
              await http.post(Uri.parse(ConstantApi.QuickReplyGetData), body: {
            "user_mast_id": Constants_Usermast.user_id.toString(),
            "high_get_from_id": updateId.toString()
          });
          if (response.statusCode == 200) {
            myNotifier.updateBool(Key: pStrTableName, value: true);
          }
          if (response.body.isNotEmpty &&
              response.statusCode == 200 &&
              response.body.toString() != "[]") {
            try {
              List herds = json.decode(response.body);
              if (herds.isNotEmpty) {
                SyncJSon.user_quick_rep_save(herds);
              }
            } catch (e) {}
          }
          if (!DownloadData.Keyvalue.contains("USER_QUICK_REP")) {
            DownloadData.Keyvalue.add("USER_QUICK_REP");
            DownloadData.respones.add(response.statusCode);
          }
          break;
        }
    }
  }

// static Future<void> update_table_idwise(
//     String pStrTableName, String pStrFromId,[String? pStrToId]) async {
//   try {
//     final db = await dbhelper.GenerateDB();
//     switch (pStrTableName) {
//
//       case "USER_MSG_READ":
//         int count = await db.rawUpdate(  'UPDATE USER_MSG SET msg_delivered = 1   WHERE msg_delivered=0 and msg_from_user_mast_id = ? and  msg_to_user_mast_id = ?  ' ,[pStrFromId,pStrToId]);
//         int count1 = await db.rawUpdate(  'UPDATE USER_MSG_LAST SET msg_delivered = 1   WHERE msg_delivered=0 and msg_from_user_mast_id = ? and  msg_to_user_mast_id = ?  ' ,[pStrFromId,pStrToId]);
//         break;
//
//       case "USER_MSG_BROADCAST":
//         int count = await db.rawUpdate(
//             'UPDATE USER_MSG_BROADCAST SET msg_is_clear_by_from_user = 1   WHERE id = ?',
//             [pStrFromId]);
//         break;
//       case "USER_BROADCAST":
//         int count = await db.rawUpdate(
//             'UPDATE USER_BROADCAST SET br_msg_content= ""   WHERE id = ?',
//             [pStrFromId]);
//         break;
//     }
//   } catch (e) {
//   }
// }

//
// static Future<List<Map<String, dynamic>>> GetTable(String pStrTableName,
//     [String? pStrFromId, String? pStrToid]) async {
//   List<Map<String, dynamic>> maps = [];
//   try {
//     final db = await dbhelper.GenerateDB();
//     switch (pStrTableName) {
//       case "USER_MSG":
//         db.rawQuery("DROP TABLE IF EXISTS temp.USER_MSG_TEMP ");
//         db.rawQuery("""
//         CREATE temp table  USER_MSG_TEMP    as
//          SELECT * FROM (SELECT * from [USER_MSG] where
//          (msg_from_user_mast_id ='$pStrFromId' and msg_to_user_mast_id='$pStrToid')
//          and msg_is_delete_by_from_user = 0
//          AND msg_is_clear_by_from_user = 0
//         UNION ALL
//         SELECT * from [USER_MSG] where
//          (msg_from_user_mast_id ='$pStrToid' and msg_to_user_mast_id='$pStrFromId')
//         and msg_is_delete_by_to_user = 0
//         AND msg_is_clear_by_to_user = 0
//         ) as t order by msg_timestamp desc,ord asc;
//        """);
//         String RawQuery = '''
//         SELECT * FROM
//         (
//             SELECT * FROM USER_MSG_TEMP
//             union all
//             SELECT   null id,
//             null msg_content,null msg_send,
//             min(m.msg_timestamp) msg_timestamp,
//            null msg_read,null msg_read_timestamp,
//             null msg_delivered,null msg_delivered_timestamp,
//             null msg_type,null msg_document_url,null msg_from_user_mast_id,null msg_to_user_mast_id,NULL msg_is_delete_by_from_user,NULL msg_is_delete_by_to_user,
//             NULL msg_is_clear_by_from_user,NULL msg_is_clear_by_to_user,null msg_is_delete,3 is_right,null msg_timestamp_show,null msg_read_timestamp_show,null msg_delivered_timestamp_show,
//             center_date,null msg_unread_count,null is_broadcast,null  broadcast_id,2 ord,null high_get_from_id,null broadcast_bulk_id,null as msg_audio_name,null as msg_media_size ,null as qtype,null as ids
//             FROM USER_MSG_TEMP AS m
//             GROUP BY m.center_date
//         ) AS main order by  main.msg_timestamp desc,main.ord desc ''';
//         maps = await db.rawQuery(RawQuery.toString());
//         SharedPref.save_sub_msg(
//             pStrToid!, Need_Sub_Msg.decode(jsonEncode(maps)));
//         return maps;
//       case "USER_MSG_BROAD":
//         maps = await db.rawQuery(
//             "SELECT * from [USER_MSG_BROADCAST] where   broadcast_bulk_id = '" +
//                 pStrFromId.toString() +
//                 "' and broadcast_id ='" +
//                 pStrToid.toString() +
//                 "' ");
//
//         return maps;
//       case "USER_MSG_LAST":
//         maps = await db.rawQuery(
//             "SELECT * FROM [USER_MSG_LAST] where msg_is_delete_by_from_user = 0 order by inserted_time desc ");
//         SharedPref.save_main_msg(
//             "first_main_chat", Need_MainChat.decode(jsonEncode(maps)));
//         Constants_List.needs_main_chat =
//             Need_MainChat.decode(jsonEncode(maps));
//         return maps;
//
//
//
//       case "USER_MSG_BROADCAST":
//         String UserId = Constants_Usermast.user_id;
//         db.rawQuery("DROP TABLE IF EXISTS temp.USER_MSG_BROADCAST_TEMP ");
//         db.rawQuery("""
//         CREATE temp table  USER_MSG_BROADCAST_TEMP    as
//       SELECT * from [USER_MSG_BROADCAST] where
//       broadcast_id ='0' or broadcast_id =$pStrFromId
//       and msg_from_user_mast_id=$UserId
//          and msg_is_delete_by_from_user = 0
//          AND msg_is_clear_by_from_user = 0
//       AND msg_to_user_mast_id = (SELECT msg_to_user_mast_id FROM USER_MSG_BROADCAST  WHERE    broadcast_id=$pStrFromId
//       LIMIT 1 )
//          ORDER BY msg_timestamp desc,ord desc; """);
//         String RawQuery = '''
//        	SELECT * FROM
//         (
//             SELECT 	* FROM USER_MSG_BROADCAST_TEMP
//             union all
//             SELECT   null id,
//             null msg_content,null msg_send,
//             min(m.msg_timestamp) msg_timestamp,
//            null msg_read,null msg_read_timestamp,
//             null msg_delivered,null msg_delivered_timestamp,
//             null msg_type,null msg_document_url, null msg_from_user_mast_id,null msg_to_user_mast_id,NULL msg_is_delete_by_from_user,NULL msg_is_delete_by_to_user,
//             NULL msg_is_clear_by_from_user,NULL msg_is_clear_by_to_user,null msg_is_delete,3 is_right,null msg_timestamp_show,null msg_read_timestamp_show,null msg_delivered_timestamp_show,
//             center_date,null msg_unread_count,null is_broadcast,null  broadcast_id,2 ord,null high_get_from_id,null broadcast_bulk_id,null as msg_audio_name,null as msg_media_size,null as qtype,null as ids
//             FROM USER_MSG_BROADCAST_TEMP AS m
//
//             GROUP BY m.center_date
//         ) AS main order by  main.msg_timestamp desc,main.ord desc ''';
//         maps = await db.rawQuery(RawQuery.toString());
//         SharedPref.save_broad_msg("BROAD_ID" + pStrFromId.toString(),
//             Need_Broadcast_Sub_Msg.decode(jsonEncode(maps)));
//         return maps;
//     }
//     return maps;
//   } catch (e) {}
//   return maps;
// }
}
