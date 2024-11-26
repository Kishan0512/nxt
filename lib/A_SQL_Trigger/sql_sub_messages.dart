import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:nextapp/A_FB_Trigger/SharedPref.dart';
import 'package:nextapp/A_Local_DB/Sync_Json.dart';
import 'package:nextapp/A_SQL_Trigger/ConstantApi.dart';

import '../Notifications/NotificationService.dart';

class sql_sub_messages_tran {
  static Future<bool> Send_Msg(
      {String sender_name = "",
      required String msg_content,
      required String msg_type,
      required String msg_document_url,
      String msg_audio_name = "",
      String msg_media_size = "",
      String msg_blurhash = "",
      required String from_id,
      required String to_id,
      required String is_broadcast,
      required String broadcast_id,
      String server_key = ""}) async {

    if (from_id.toString() != 'null' &&
        from_id != '0' &&
        to_id != '0' &&
        to_id.toString() != 'null' &&
        from_id != to_id &&
        msg_content.toLowerCase() != 'null') {
      final response =
          await http.post(Uri.parse(ConstantApi.MessageSend), body: {
        "msg_content": msg_content.toString().trim(),
        "msg_type": msg_type,
        "msg_document_url": msg_document_url,
        "msg_audio_name": msg_audio_name,
        "msg_media_size": msg_media_size,
        "msg_from_user_mast_id": from_id,
        "msg_to_user_mast_id": to_id,
        "is_broadcast": is_broadcast,
        "broadcast_id": broadcast_id,
        "msg_blurhash": msg_blurhash
      });
      print(response.bodyBytes);
      print(response.statusCode);
      // String server_key =
      //     'ecuVQZZSRP-NzNQI40HgSM:APA91bEa7IpPEcLX2nmyZ6oCI3h7_4Ru4df45l1TWQcbqo1ywhru2Vj7IaZkH_80_6Lnk0wohWa_86Hg-yPLpD5k4eoxmT_6TRrFujf9hzL0qgr4XsJna3GLw56oMHXaTIkz_YO2jsyK';
      String? deviceKey = await FirebaseMessaging.instance.getToken();
      SendNotification.sendPushNotification(
          Receiver_Token: server_key,
          Sender_Token: deviceKey!,
          body: msg_type == '1'
              ? msg_content
              : ' ${msg_type == '2' ? '📷' : msg_type == '3' ? '🎶' : msg_type == '4' ? '📄' : '🎥'} $msg_audio_name',
          title: sender_name,
          from_id: from_id,
          to_id: to_id,
          pStrMediaType: msg_type,
          ImageUrl: msg_type == '2' ? msg_document_url : '',
          MediaName: msg_audio_name);
      // await SyncDB.SyncTable(Constants.usermainmsg, false);
      // await SyncDB.SyncTable(Constants.Table_Contacts_broadcast, false);
      if (response.statusCode == 200) {
        return true;
      } else {
        Fluttertoast.showToast(msg: "can't send message");
        return false;
      }
    } else {
      Fluttertoast.showToast(msg: "can't send message");
      return false;
    }
  }

  static Forword_Msg(
      {required String from_id,
      required String to_id,
      required String broadcast_id,
      required String msg_ids}) async {
    final response =
        await http.post(Uri.parse(ConstantApi.MessageForward), body: {
      "msg_from_user_id": from_id,
      "msg_to_user_id": to_id,
      "msg_broad_id": broadcast_id,
      "msg_ids": msg_ids
    });
    if (response.statusCode == 200) {
    } else {
      Fluttertoast.showToast(msg: "can't send message");
    }
  }

  // static Sub_getMsg(String pStrFromId, String pStrToId) async {
  //   List<Need_Sub_Msg> needsSubMsg = Need_Sub_Msg.decode(jsonEncode(
  //       await SyncDB.GetTable(Constants.usersubmsg, pStrFromId, pStrToId)));
  //    // SharedPref.save_sub_msg(pStrToId, needsSubMsg);
  //   return needsSubMsg;
  // }

  static Sub_getMsg_broadcast(String pStrUser, String pStrBrId) async {
    // List<Need_Sub_Msg> needsSubMsg = Need_Sub_Msg.decode(jsonEncode(
    //     await SyncDB.GetTable(Constants.usersubmsgbroad, pStrUser, pStrBrId)));
    return [];
  }

  static Sub_UserWiseClear(
      String msgFromUserMastId, int msgToUserMastId) async {
    SyncJSon.user_sub_main_chat_delete(msgToUserMastId.toString(), true);
    final response =
        await http.post(Uri.parse(ConstantApi.MessageUserWiseClear), body: {
      "msg_from_user_mast_id": msgFromUserMastId,
      "msg_to_user_mast_id": msgToUserMastId.toString()
    });
    if (response.statusCode == 200) {
      SharedPref.remove_key(msgToUserMastId.toString());
      SyncJSon.user_sub_main_chat_delete(msgToUserMastId.toString(), true);
    }
  }

  static Sub_UserWiseDelete(
      String msgFromUserMastId, String msgToUserMastId, bool DeleteAll) async {

    final response =
        await http.post(Uri.parse(ConstantApi.MessageUserWiseDelete), body: {
      "msg_from_user_mast_id": msgFromUserMastId,
      "msg_to_user_mast_ids": msgToUserMastId
    });
    if (response.statusCode == 200 && DeleteAll) {
      SharedPref.remove_key('first_main_chat');
      SharedPref.remove_key(msgToUserMastId);
    } else if (response.statusCode == 200 && !DeleteAll) {
      SharedPref.remove_key(msgToUserMastId);
      SyncJSon.user_main_chat_delete(msgToUserMastId);
    }
  }

  static Sub_ChatUserWiseClear(
      String msgFromUserMastId, int msgToUserMastId) async {
    final response =
        await http.post(Uri.parse(ConstantApi.MessageUserWiseClear), body: {
      "msg_from_user_mast_id": msgFromUserMastId,
      "msg_to_user_mast_id": msgToUserMastId
    });
    if (response.statusCode == 200) {
      SharedPref.remove_key(msgToUserMastId.toString());
      SyncJSon.user_sub_main_chat_delete(msgToUserMastId.toString(), true);
    }
  }

  static Sub_ChatUserWiseDelete(String msgFromUserMastId, int msgToUserMastId,
      String toIds, String fromIds, bool DeleteAll) async {
    final response =
        await http.post(Uri.parse(ConstantApi.MessageUserWiseClear), body: {
      "msg_from_user_mast_id": msgFromUserMastId,
      "msg_to_user_mast_id": msgToUserMastId.toString(),
      "from_ids": fromIds,
      "to_ids": toIds,
      "qtype": "selected_msg_delete",
    });
    SyncJSon.user_sub_main_chat_delete(
        msgToUserMastId.toString(), false, fromIds + ',' + toIds);
  }
}
